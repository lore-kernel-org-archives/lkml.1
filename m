Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbXCLIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbXCLIyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCLIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:54:52 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:36739 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965375AbXCLIyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:54:49 -0400
Date: Mon, 12 Mar 2007 09:54:47 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20*: PATA DMA timeout, hangs
Message-ID: <20070312085447.GA10955@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.19 is ok, 2.6.20.[12] hangs from the moment DMA is turned on (hdparm
-d 1 /dev/hda):

	hda: dma_timer_expiry: dma status == 0x20
	hda: DMA timeout retry
	hda: timeout waiting for DMA
	hda: status error: status=0x58 {
	DriveReady
	SeekComplete
	DataRequest
	}

Linux version 2.6.20.2-x152 (fvm@lokka) (gcc version 3.4.6 (Debian 3.4.6-4)) #1 SMP Sun Mar 11 21:21:07 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001fdd0000 end: 000000001fed0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001fed0000 size: 0000000000020000 end: 000000001fef0000 type: 4
copy_e820_map() start: 000000001fef0000 size: 0000000000010000 end: 000000001ff00000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000feea0000 size: 0000000001160000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fed0000 (usable)
 BIOS-e820: 000000001fed0000 - 000000001fef0000 (ACPI NVS)
 BIOS-e820: 000000001fef0000 - 000000001ff00000 (usable)
 BIOS-e820: 00000000feea0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
511MB LOWMEM available.
found SMP MP-table at 000f8da0
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   130816
  HighMem    130816 ->   130816
early_node_map[1] active PFN ranges
    0:        0 ->   130816
DMI 2.3 present.
ACPI: PM-Timer IO Port: 0xf808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:8 APIC version 17
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 1ff00000:defa0000)
Detected 996.780 MHz processor.
Built 1 zonelists.  Total pages: 129156
Kernel command line: auto BOOT_IMAGE=2.6.20.2-x152 ro root=302 nomodules panic=60 netconsole=@172.17.1.60/,514@172.17.1.64/00:12:3f:85:17:52
netconsole: local port 6665
netconsole: local IP 172.17.1.60
netconsole: interface eth0
netconsole: remote port 514
netconsole: remote IP 172.17.1.64
netconsole: remote ethernet address 00:12:3f:85:17:52
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1064 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 506148k/523264k available (4226k kernel code, 16352k reserved, 1988k data, 288k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdff00000   ( 511 MB)
      .init : 0xc0719000 - 0xc0761000   ( 288 kB)
      .data : 0xc0520b39 - 0xc0711c60   (1988 kB)
      .text : 0xc0100000 - 0xc0520b39   (4226 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1994.91 BogoMIPS (lpj=997456)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 17k freed
ACPI: Core revision 20060707
CPU0: Intel Pentium III (Coppermine) stepping 06
Total of 1 processors activated (1994.91 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xe8316, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *9
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region f800-f87f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region fa00-fa3f claimed by ICH4 GPIO
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
Generic PHY: Registered new driver
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: 40000000-402fffff
  PREFETCH window: 40400000-404fffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 7, 524288 bytes)
TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
Machine check exception polling timer started.
DLM (built Mar 11 2007 21:17:07) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.8)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
intel_rng: FWH not detected
ppdev: user-space parallel port driver
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel i815 Chipset.
agpgart: AGP aperture is 64M @ 0x44000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport0: irq 7 detected
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.3.15-k2
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 16 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0x40400000, irq 16, MAC addr 00:08:C7:A9:C1:BB
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: device eth0 not up yet, forcing it
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH: IDE controller at PCI slot 0000:00:1f.1
ICH: chipset revision 2
ICH: not 100%% native mode: will probe irqs later
    ide0: BM-DMA at 0x2460-0x2467, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x2468-0x246f, BIOS settings: hdc:DMA, hdd:pio
hda: Maxtor 32049H2, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: Compaq CD-ROM SC-148E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 40021632 sectors (20491 MB) w/2048KiB Cache, CHS=39704/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda4
hdc: ATAPI 48X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 17
uhci_hcd 0000:00:1f.2: UHCI Host Controller
uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1f.2: detected 2 ports
uhci_hcd 0000:00:1f.2: irq 17, io base 0x00002440
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.20.2-x152 uhci_hcd
usb usb1: SerialNumber: 0000:00:1f.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver wacom
drivers/usb/input/wacom_sys.c: v1.46:USB Wacom Graphire and Wacom Intuos tablet driver
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.0
drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 1
input: PS/2 Logitech Mouse as /class/input/input2
i2c /dev entries driver
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid6: int32x1    312 MB/s
raid6: int32x2    375 MB/s
raid6: int32x4    250 MB/s
raid6: int32x8    246 MB/s
raid6: mmxx1      953 MB/s
raid6: mmxx2     1207 MB/s
raid6: sse1x1     875 MB/s
raid6: sse1x2    1199 MB/s
raid6: using algorithm sse1x2 (1199 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  2044.000 MB/sec
raid5: using function: pIII_sse (2044.000 MB/sec)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.0.1 Mar 11 2007
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09 09:56:17 2007 UTC).
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 18
intel8x0_measure_ac97_clock: measured 50992 usecs
intel8x0: clocking to 40708
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: Intel 82801AA-ICH with AD1885 at 0x2000, irq 18
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4088 buckets, 32704 max)
ctnetlink v0.93: registering with nfnetlink.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP htcp registered
TCP vegas registered
TCP scalable registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
Ebtables v2.0 registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
Time: tsc clocksource has been installed.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 288k freed
Adding 1005440k swap on /dev/hda1.  Priority:-1 extents:1 across:1005440k
EXT3 FS on hda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
NFSD: starting 90-second grace period

lspci:
0000:00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 02)
0000:00:02.0 VGA compatible controller: Intel Corporation 82815 CGC [Chipset Graphics Controller] (rev 02)
0000:00:1e.0 PCI bridge: Intel Corporation 82801AA PCI Bridge (rev 02)
0000:00:1f.0 ISA bridge: Intel Corporation 82801AA ISA Bridge (LPC) (rev 02)
0000:00:1f.1 IDE interface: Intel Corporation 82801AA IDE (rev 02)
0000:00:1f.2 USB Controller: Intel Corporation 82801AA USB (rev 02)
0000:00:1f.5 Multimedia audio controller: Intel Corporation 82801AA AC'97 Audio (rev 02)
0000:02:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)

/proc/dma:
 2: floppy
 4: cascade

/proc/interrupts:
           CPU0
  0:     467214   IO-APIC-edge      timer
  1:          8   IO-APIC-edge      i8042
  6:          3   IO-APIC-edge      floppy
  8:          4   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:        105   IO-APIC-edge      i8042
 14:      80459   IO-APIC-edge      ide0
 15:         25   IO-APIC-edge      ide1
 16:       3767   IO-APIC-fasteoi   eth0
 17:          0   IO-APIC-fasteoi   uhci_hcd:usb1
 18:          0   IO-APIC-fasteoi   Intel 82801AA-ICH
NMI:          0
LOC:     467065
ERR:          0
MIS:          0

--
Frank
