Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDDTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDDTt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXDDTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:49:56 -0400
Received: from leo.stedwards.edu ([209.99.108.120]:37296 "EHLO
	leo.stedwards.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXDDTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:49:52 -0400
X-Greylist: delayed 1307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 15:49:52 EDT
Subject: kernel module file corruption on reboot
From: Stephen Olander Waters <debian@luy.info>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 04 Apr 2007 14:28:00 -0500
Message-Id: <1175714880.2547.38.camel@ix>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=417594

Package: linux-image-2.6.18-4-amd64
Version: 2.6.18.dfsg.1-12

Please note that this bug also affects the latest Debian amd64
experimental kernel linux-image-2.6.20-1-amd64, version:
2.6.20-1~experimental.1~snapshot.8402

About every 5 reboots, my kernel module directories will get corrupted
-- if I'm very careful and shut down first, boinc running in a 32-bit
chroot and second, GDM. If I just type in "shutdown -h now" in an xterm,
it almost guarantees corruption.

The most common corrupted file is tg3.ko and its parent directories. 

No other filesystems experience corruption. No other directories
experience corruption. Only the kernel module files/directories of the
running kernel are corrupted.

Annoying workaround:
1) reboot into rescue kernel
2) turn off networking / portmap
3) remount readonly
4) run fsck on root partition where the module files are stored
5) remount read/write
6) dpkg -i /home/user/saved_kernel.deb

Hardware:
Dual opteron 244s
MSI K8T Master2-FAR motherboard
via K8t8000 chipset
RAM with ECC turned off because the motherboard doesn't like x8bit ECC
and I can't afford to burn more $ on 2GB of new x4bit ECC RAM.

Here is some weirdness in dmesg with the hard drive. It has always had
this message, even when it was running on 32-bit kernels, but even then
I never experienced filesystem corruption with it.

hda: Maxtor 94098H6, ATA DISK drive
hda: max request size: 128KiB
hda: 80043264 sectors (40982 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
hda: dma_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: cache flushes not supported
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x84 { DriveStatusError BadCRC }
ide: failed opcode was: unknown

Software:
Debian unstable + above mentioned kernels
All partitions are ext3 with internal journals mounted in data=ordered
mode and all defaults.


Thanks for any help! I appreciate all the hard work you guys put into
these kernels. If you want more information, just ask.

-s



dmesg
-----
Linux version 2.6.20-1-amd64 (Debian 2.6.20-1~experimental.1~snapshot.8402) (waldi@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri Mar 30 01:08:49 CEST 2007
Command line: root=/dev/hda3 ro 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
 BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
 BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
 BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 160) 0 entries of 3200 used
Entering add_active_range(0, 256, 524000) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP (v000 VIAK8                                 ) @ 0x00000000000f6980
ACPI: RSDT (v001 VIAK8  AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x000000007fee3000
ACPI: FADT (v001 VIAK8  AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x000000007fee3040
ACPI: MADT (v001 VIAK8  AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x000000007fee7b40
ACPI: DSDT (v001 VIAK8  AWRDACPI 0x00001000 MSFT 0x0100000e) @ 0x0000000000000000
Scanning NUMA topology in Northbridge 24
Number of nodes 2
Node 0 MemBase 0000000000000000 Limit 000000007fee0000
Entering add_active_range(0, 0, 160) 0 entries of 3200 used
Entering add_active_range(0, 256, 524000) 1 entries of 3200 used
Skipping disabled node 1
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-000000007fee0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      160
    0:      256 ->   524000
On node 0 totalpages: 523904
  DMA zone: 56 pages used for memmap
  DMA zone: 970 pages reserved
  DMA zone: 2974 pages, LIFO batch:0
  DMA32 zone: 7108 pages used for memmap
  DMA32 zone: 512796 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7ff00000:7ed00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36992 bytes of per cpu data
Built 1 zonelists.  Total pages: 515770
Kernel command line: root=/dev/hda3 ro 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ f0000000 size 64 MB
CPU 1: aperture @ f0000000 size 64 MB
Memory: 2058528k/2096000k available (1970k kernel code, 37088k reserved, 920k data, 284k init)
Calibrating delay using timer specific routine.. 3612.41 BogoMIPS (lpj=7224822)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12528841
Detected 12.528 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3608.45 BogoMIPS (lpj=7216918)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
AMD Opteron(tm) Processor 244 stepping 08
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -108 cycles, maxerr 968 cycles)
Brought up 2 CPUs
testing NMI watchdog ... OK.
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 1804.152 MHz processor.
migration_cost=569
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:0f.0: cannot adjust BAR0 (not I/O)
0000:00:0f.0: cannot adjust BAR1 (not I/O)
0000:00:0f.0: cannot adjust BAR2 (not I/O)
0000:00:0f.0: cannot adjust BAR3 (not I/O)
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 11 *12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0, disabled.
ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0, disabled.
ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0401
pnp: ACPI device : hid PNP0303
pnp: PnP ACPI: found 12 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
NET: Registered protocol family 8
NET: Registered protocol family 20
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 64M @ 0xf0000000
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:00' and the driver 'system'
pnp: match found with the PnP device '00:02' and the driver 'system'
pnp: 00:02: ioport range 0x4000-0x407f could not be reserved
pnp: 00:02: ioport range 0x5000-0x500f has been reserved
pnp: match found with the PnP device '00:03' and the driver 'system'
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: f4000000-f5ffffff
  PREFETCH window: e0000000-efffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1282k freed
audit: initializing netlink socket (disabled)
audit(1175601895.496:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:08' and the driver 'serial'
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: match found with the PnP device '00:09' and the driver 'serial'
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI: (supports S0 S1 S4 S5)
Freeing unused kernel memory: 284k freed
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
VP_IDE: IDE controller at PCI slot 0000:00:0f.0
ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.0
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
input: AT Translated Set 2 keyboard as /class/input/input0
hda: Maxtor 94098H6, ATA DISK drive
hdb: _NEC DVD_RW ND-3500AG, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: LS-120 CSMO 05 UHD Floppy, ATAPI FLOPPY drive
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 2.00 loaded.
hda: max request size: 128KiB
hda: 80043264 sectors (40982 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
hda: dma_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hda: cache flushes not supported
hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hda: dma_intr: error=0x84 { DriveStatusError BadCRC }
ide: failed opcode was: unknown
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000dc00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
pnp: the driver 'parport_pc' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'parport_pc'
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
hdc: No disk in drive
hdc: 123264kB, 963/8/32 CHS, 533 kBps, 512 sector size, 720 rpm
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:10.4: irq 21, io mem 0xf6010000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
tg3.c:v3.72 (January 8, 2007)
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 16 (level, low) -> IRQ 16
eth0: Tigon3 [partno(BCM95705A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:11:09:7a:79:1f
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[0] TSOcap[1] 
eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.5 to 64
usb 2-1: new low speed USB device using uhci_hcd and address 2
devpts: called with bogus options
usb 2-1: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using uhci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 4 ports detected
usbcore: registered new interface driver hiddev
usb 3-2.2: new low speed USB device using uhci_hcd and address 3
usb 3-2.2: configuration #1 chosen from 1 choice
hda: cache flushes not supported
EXT3 FS on hda3, internal journal
hiddev96: USB HID v1.10 Device [American Power Conversion Smart-UPS 1000 FW:600.3.D USB FW:8.1] on usb-0000:00:10.1-1
input: Kensington      Kensington USB/PS2 Wheel Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Kensington      Kensington USB/PS2 Wheel Mouse] on usb-0000:00:10.2-2.2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
hdc: No disk in drive
PM: Writing back config space on device 0000:00:0b.0 at offset b (was 165314e4, writing 13001462)
PM: Writing back config space on device 0000:00:0b.0 at offset 3 (was 0, writing 2008)
PM: Writing back config space on device 0000:00:0b.0 at offset 2 (was 2000000, writing 2000003)
PM: Writing back config space on device 0000:00:0b.0 at offset 1 (was 2b00000, writing 2b00006)
tg3: eth_tg3: Link is up at 1000 Mbps, full duplex.
tg3: eth_tg3: Flow control is on for TX and on for RX.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions

