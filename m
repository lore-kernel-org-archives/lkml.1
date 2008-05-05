Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYEEVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYEEVO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762109AbYEEVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:14:11 -0400
Received: from wsip-68-15-230-7.om.om.cox.net ([68.15.230.7]:57801 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761943AbYEEVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:14:07 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 May 2008 17:14:07 EDT
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: linux-kernel@vger.kernel.org
Subject: ext3 journal OOPS
Date: Mon, 5 May 2008 21:02:55 +0000
User-Agent: KMail/1.9.7
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805052102.57705.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not subscribed, so please CC me to replies. Thanks.

Any ideas on this? Running version 2.6.23-gentoo-r8 with no tainting.

After reading the oops having been ext3 related, I used the hard reset button 
to avoid any potentially dangerous shutdown procedures.

*** dmesg immediately after oops ***

Assertion failure in journal_dirty_data() at 
fs/jbd/transaction.c:983: "jh->b_transaction == 
journal->j_committing_transaction"
------------[ cut here ]------------
kernel BUG at fs/jbd/transaction.c:983!
invalid opcode: 0000 [#1]
Modules linked in: ipv6 floppy uhci_hcd pcspkr usbcore analog evdev gameport 
parport_pc 8139too parport i2c_prosavage mii rtc i2c_algo_bit ide_cd 
i2c_viapro i2c_core cdrom button thermal processor
CPU:    0
EIP:    0060:[<c01b2510>]    Not tainted VLI
EFLAGS: 00210296   (2.6.23-gentoo-r8 #1)
EIP is at journal_dirty_data+0x80/0x170
eax: 00000083   ebx: c439b54c   ecx: c0341640   edx: c0341640
esi: c28a0dd4   edi: c582f2c0   ebp: c7759ec0   esp: c5c0fcec
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process asterisk (pid: 17137, ti=c5c0e000 task=c77d3030 task.ti=c5c0e000)
Stack: c030ac44 c02ce90e c030964a 000003d7 c030cde8 00000000 00001000 c582f2c0
       c28a0dd4 c28a0dd4 c01a1488 0000000a c01b19e2 00001000 c10407a0 c28a0dd4
       c01a0852 00000004 c582f2c0 00001000 c10407a0 c10407a0 c46fd2a8 c582f2c0
Call Trace:
 [<c01a1488>] ext3_journal_dirty_data+0x18/0x50
 [<c01b19e2>] journal_start+0xb2/0xe0
 [<c01a0852>] walk_page_buffers+0x72/0x90
 [<c01a3321>] ext3_ordered_commit_write+0x51/0xe0
 [<c01a1470>] ext3_journal_dirty_data+0x0/0x50
 [<c0143b04>] generic_file_buffered_write+0x274/0x650
 [<c025b7d7>] sock_queue_rcv_skb+0xa7/0x100
 [<c0257766>] sock_recvmsg+0xe6/0x120
 [<c014415e>] __generic_file_aio_write_nolock+0x27e/0x510
 [<c0144442>] generic_file_aio_write+0x52/0xd0
 [<c019f510>] ext3_file_write+0x30/0xc0
 [<c015dfd5>] do_sync_write+0xd5/0x120
 [<c0128d50>] autoremove_wake_function+0x0/0x50
 [<c015e883>] vfs_write+0xa3/0x140
 [<c015dc0c>] vfs_llseek+0x3c/0x50
 [<c015df00>] do_sync_write+0x0/0x120
 [<c015ee51>] sys_write+0x41/0x70
 [<c0103f0e>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 44 24 10 e8 cd 30 c0 c7 44 24 0c d7 03 00 00 c7 44 24 08 4a 96 30 c0 c7 
44 24 04 0e e9 2c c0 c7 04 24 44 ac 30 c0 e8 c0 67 f6 ff <0f> 0b eb fe 8b 43 
08 83 f8 01 0f 97 c2 83 f8 08 0f 95 c0 84 c2
EIP: [<c01b2510>] journal_dirty_data+0x80/0x170 SS:ESP 0068:c5c0fcec

*** dmesg after subsequent boot ***

Linux version 2.6.23-gentoo-r8 (root@naizen) (gcc version 4.1.2 (Gentoo 4.1.2 
p1.0.1)) #1 Tue Feb 12 01:18:07 CST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000077f0000 (usable)
 BIOS-e820: 00000000077f0000 - 00000000077f8000 (ACPI data)
 BIOS-e820: 00000000077f8000 - 0000000007800000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
119MB LOWMEM available.
Entering add_active_range(0, 0, 30704) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    30704
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    30704
On node 0 totalpages: 30704
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 207 pages used for memmap
  Normal zone: 26401 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000FA640, 0014 (r0 AMI   )
ACPI: RSDT 077F0000, 002C (r1 AMIINT AMIINI09       10 MSFT  100000D)
ACPI: FACP 077F0030, 0081 (r1 AMIINT AMIINI09       11 MSFT  100000D)
ACPI: DSDT 077F0120, 304C (r1    VIA   VIA_K7     1000 MSFT  100000D)
ACPI: FACS 077F8000, 0040
ACPI: APIC 077F00C0, 0054 (r1 AMIINT AMIINI09       11 MSFT  100000D)
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 10000000 (gap: 07800000:f7400000)
Built 1 zonelists in Zone order.  Total pages: 30465
Kernel command line: root=/dev/hdc1
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 1313.021 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 118468k/122816k available (1798k kernel code, 3812k reserved, 621k 
data, 152k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
    vmalloc : 0xc8000000 - 0xffff4000   ( 895 MB)
    lowmem  : 0xc0000000 - 0xc77f0000   ( 119 MB)
      .init : 0xc0360000 - 0xc0386000   ( 152 kB)
      .data : 0xc02c18e6 - 0xc035d064   ( 621 kB)
      .text : 0xc0100000 - 0xc02c18e6   (1798 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2627.78 BogoMIPS 
(lpj=13138925)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 
00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 
00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Duron(tm) Processor stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 1c00)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: dfd00000-dfefffff
  PREFETCH window: cfb00000-dfbfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
audit(1210021150.469:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:11.1
ACPI: Unable to derive IRQ for device 0000:00:11.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8233a (rev 00) IDE UDMA133 controller on pci0000:00:11.1
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: PLEXTOR CD-R PX-W8432T, ATAPI CD/DVD-ROM drive
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: WDC WD1200JB-34EVA0, ATA DISK drive
hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: selected mode 0x42
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 512KiB
hdc: 234441648 sectors (120034 MB) w/8192KiB Cache, CHS=16383/255/63, UDMA(33)
hdc: cache flushes supported
 hdc: hdc1 hdc2
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: hdc1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 14598204
EXT3-fs: hdc1: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 152k freed
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> 
IRQ 10
eth0: RealTek RTL8139 at 0xc800ef00, 00:50:bf:73:43:b9, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139C'
ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> 
IRQ 10
eth1: RealTek RTL8139 at 0xc8020e00, 00:20:ed:44:ce:ce, IRQ 10
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
input: Power Button (FF) as /class/input/input0
Real Time Clock Driver v1.12ac
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Floppy drive(s): fd0 is 1.44M
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
input: PC Speaker as /class/input/input2
ACPI: Processor [CPU1] (supports 16 throttling states)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:11.2[D] -> Link [LNKD] -> GSI 12 (level, low) -> 
IRQ 12
uhci_hcd 0000:00:11.2: UHCI Host Controller
uhci_hcd 0000:00:11.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:11.2: irq 12, io base 0x0000e800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
FDC 0 is a post-1991 82077
ACPI: Power Button (CM) [PWRB]
hda: ATAPI 32X CD-ROM CD-R/RW drive, 4096kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
net inet0: device_rename: sysfs_create_symlink failed (-17)
udev: renamed network interface eth0 to inet0
net lan0: device_rename: sysfs_create_symlink failed (-17)
udev: renamed network interface eth1 to lan0
parport_pc 00:04: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
ACPI: PCI Interrupt 0000:00:11.3[D] -> Link [LNKD] -> GSI 12 (level, low) -> 
IRQ 12
uhci_hcd 0000:00:11.3: UHCI Host Controller
uhci_hcd 0000:00:11.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:11.3: irq 12, io base 0x0000e400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
EXT3 FS on hdc1, internal journal
Adding 248996k swap on /dev/hdc2.  Priority:-1 extents:1 across:248996k
inet0: link up, 100Mbps, full-duplex, lpa 0x45E1
inet0: link up, 100Mbps, full-duplex, lpa 0x45E1
lan0: link up, 100Mbps, full-duplex, lpa 0x45E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
inet0: no IPv6 routers present
