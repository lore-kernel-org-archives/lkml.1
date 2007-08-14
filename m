Return-Path: <linux-kernel-owner+w=401wt.eu-S935902AbXHNDyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935902AbXHNDyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 23:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbXHNDxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 23:53:45 -0400
Received: from smtp.hickorytech.net ([216.114.192.16]:47636 "EHLO
	avalanche.hickorytech.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757417AbXHNDxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 23:53:40 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 23:53:39 EDT
Message-ID: <46C11FFD.4040607@mnsu.edu>
Date: Mon, 13 Aug 2007 22:22:37 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: "pci=routeirq" on IBM Thinkpad A20m Type 2628-3au fixes wireless
 card in cardbus/pcmcia slot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci=routeirq makes my wireless lan card in a cardbus/pcmcia slot work.  
I'm posting these are requested in the dmesg.

(below are lspci and dmesg, more available by request)

Here's the lspci:
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host 
bridge (rev 03)
    Flags: bus master, medium devsel, latency 64
    Memory at f8000000 (32-bit, prefetchable) [size=64M]
    Capabilities: [a0] AGP version 1.0

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP 
bridge (rev 03) (prog-if 00 [Normal decode])
    Flags: bus master, 66MHz, medium devsel, latency 128
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
    I/O behind bridge: 00002000-00002fff
    Memory behind bridge: f4200000-f5ffffff
    Prefetchable memory behind bridge: 30000000-300fffff

00:02.0 CardBus bridge: Texas Instruments PCI1450 (rev 03)
    Subsystem: IBM Thinkpad T20/T22/A21m
    Flags: bus master, medium devsel, latency 168, IRQ 5
    Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
    Memory window 0: 20000000-23fff000 (prefetchable)
    Memory window 1: 24000000-27fff000
    I/O window 0: 00001400-000014ff
    I/O window 1: 00001c00-00001cff
    16-bit legacy interface ports at 0001

00:02.1 CardBus bridge: Texas Instruments PCI1450 (rev 03)
    Subsystem: IBM Thinkpad T20/T22/A21m
    Flags: bus master, medium devsel, latency 168, IRQ 9
    Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
    Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
    Memory window 0: 28000000-2bfff000 (prefetchable)
    Memory window 1: 2c000000-2ffff000
    I/O window 0: 00003000-000030ff
    I/O window 1: 00003400-000034ff
    16-bit legacy interface ports at 0001

00:03.0 Ethernet controller: Intel Corporation 82557/8/9 Ethernet Pro 
100 (rev 09)
    Subsystem: Intel Corporation EtherExpress PRO/100+ MiniPCI
    Flags: bus master, medium devsel, latency 66, IRQ 10
    Memory at f4120000 (32-bit, non-prefetchable) [size=4K]
    I/O ports at 1800 [size=64]
    Memory at f4100000 (32-bit, non-prefetchable) [size=128K]
    [virtual] Expansion ROM at 30100000 [disabled] [size=1M]
    Capabilities: [dc] Power Management version 2

00:03.1 Serial controller: Xircom Mini-PCI V.90 56k Modem (prog-if 02 
[16550])
    Subsystem: Intel Corporation Unknown device 2408
    Flags: medium devsel, IRQ 10
    I/O ports at 1840 [size=8]
    Memory at f4121000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [dc] Power Management version 2

00:05.0 Multimedia audio controller: Cirrus Logic CS 4614/22/24/30 
[CrystalClear SoundFusion Audio Accelerator] (rev 01)
    Subsystem: IBM ThinkPad A20m
    Flags: bus master, slow devsel, latency 64, IRQ 5
    Memory at f4122000 (32-bit, non-prefetchable) [size=4K]
    Memory at f4000000 (32-bit, non-prefetchable) [size=1M]
    Capabilities: [40] Power Management version 2

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
    Flags: bus master, medium devsel, latency 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 
01) (prog-if 80 [Master])
    Flags: bus master, medium devsel, latency 64
    [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] 
[size=8]
    [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] 
[size=1]
    [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] 
[size=8]
    [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] 
[size=1]
    I/O ports at 1850 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 
01) (prog-if 00 [UHCI])
    Flags: bus master, medium devsel, latency 64, IRQ 11
    I/O ports at 1860 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
    Flags: medium devsel, IRQ 9

01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility 
P/M AGP 2x (rev 64) (prog-if 00 [VGA])
    Subsystem: IBM ThinkPad A20m/A21m
    Flags: bus master, stepping, medium devsel, latency 66, IRQ 5
    Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
    I/O ports at 2000 [size=256]
    Memory at f4200000 (32-bit, non-prefetchable) [size=4K]
    [virtual] Expansion ROM at 30000000 [disabled] [size=128K]
    Capabilities: [50] AGP version 1.0
    Capabilities: [5c] Power Management version 2


dmesg:
Linux version 2.6.22-1-686 (Debian 2.6.22-3) (waldi@debian.org) (gcc 
version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Sun Jul 29 
14:37:42 UTC 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)
 BIOS-e820: 0000000013ff0000 - 0000000013ffec00 (ACPI data)
 BIOS-e820: 0000000013ffec00 - 0000000014000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
319MB LOWMEM available.
Entering add_active_range(0, 0, 81904) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    81904
  HighMem     81904 ->    81904
early_node_map[1] active PFN ranges
    0:        0 ->    81904
On node 0 totalpages: 81904
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 607 pages used for memmap
  Normal zone: 77201 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F6B30, 0014 (r0 PTLTD )
ACPI: RSDT 13FF596D, 002C (r1 PTLTD    RSDT    6041130  LTP        0)
ACPI: FACP 13FFEB65, 0074 (r1 IBM    TP-A20M   6041130             0)
ACPI: DSDT 13FF5999, 91CC (r1 IBM    TP A20m   6041130 MSFT  100000C)
ACPI: FACS 13FFF000, 0040
ACPI: BOOT 13FFEBD9, 0027 (r1 PTLTD  $SBFTBL$  6041130  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 20000000 (gap: 14000000:ebf80000)
Built 1 zonelists.  Total pages: 81265
Kernel command line: root=/dev/hda3 ro pci=routeirq
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (0128c000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 548.673 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 315784k/327616k available (1688k kernel code, 11248k reserved, 
649k data, 244k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xd4800000 - 0xff7fe000   ( 687 MB)
    lowmem  : 0xc0000000 - 0xd3ff0000   ( 319 MB)
      .init : 0xc034f000 - 0xc038c000   ( 244 kB)
      .data : 0xc02a6187 - 0xc03487e4   ( 649 kB)
      .text : 0xc0100000 - 0xc02a6187   (1688 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1098.47 BogoMIPS 
(lpj=2196950)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 
00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 128K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e20)
CPU0: Intel Celeron (Coppermine) stepping 03
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=7
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Firmware left 0000:00:03.0 e100 interrupts enabled, disabling
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
PIIX4 devres C PIO at 15e8-15ef
PIIX4 devres I PIO at 03f0-03f7
PIIX4 devres J PIO at 002e-002f
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PSER] (on)
ACPI: Power Resource [PSIO] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 5 (level, low) 
-> IRQ 5
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKB] -> GSI 9 (level, low) 
-> IRQ 9
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 10 (level, 
low) -> IRQ 10
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKC] -> GSI 10 (level, 
low) -> IRQ 10
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKA] -> GSI 5 (level, low) 
-> IRQ 5
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, 
low) -> IRQ 11
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 5 (level, low) 
-> IRQ 5
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff could not be reserved
pnp: 00:02: ioport range 0x1000-0x103f has been reserved
pnp: 00:02: ioport range 0x1040-0x104f has been reserved
pnp: 00:02: ioport range 0xfe00-0xfe0f has been reserved
pnp: 00:09: ioport range 0x15e0-0x15ef has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: f4200000-f5ffffff
  PREFETCH window: 30000000-300fffff
PCI: Bus 2, cardbus bridge: 0000:00:02.0
  IO window: 00001400-000014ff
  IO window: 00001c00-00001cff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:02.1
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 28000000-2bffffff
  MEM window: 2c000000-2fffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 5 (level, low) 
-> IRQ 5
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKB] -> GSI 9 (level, low) 
-> IRQ 9
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on 
CPU 0
 it is
Freeing initrd memory: 5303k freed
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
audit(1187042830.816:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKC] -> GSI 10 (level, 
low) -> IRQ 10
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 244k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (65 C)
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 10 (level, 
low) -> IRQ 10
e100: eth0: e100_probe: addr 0xf4120000, irq 10, MAC addr 00:10:A4:8F:2A:03
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1850-0x1857, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1858-0x185f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
hda: FUJITSU MHT2040AH, ATA DISK drive
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
Clocksource tsc unstable (delta = -3678234910 ns)
hda: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: CRN-8241U, ATAPI CD/DVD-ROM drive
hdc: selected mode 0x42
ide1 at 0x170-0x177,0x376 on irq 15
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, 
low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00001860
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hda: max request size: 128KiB
hda: 78140160 sectors (40007 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(33)
hda: cache flushes supported
 hda: hda1 hda2 hda3
SGI XFS with ACLs, security attributes, realtime, large block numbers, 
no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem hda3
Ending clean XFS mount for filesystem: hda3
Linux agpgart interface v0.102 (c) Dave Jones
Yenta: CardBus bridge found at 0000:00:02.0 [1014:0130]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0x00001000, devctl 0x66
Yenta: ISA IRQ mask 0x0090, PCI irq 5
Socket status: 30000010
Yenta: CardBus bridge found at 0000:00:02.1 [1014:0130]
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0x00001000, devctl 0x66
Yenta: ISA IRQ mask 0x0090, PCI irq 9
Socket status: 30000006
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
pccard: PCMCIA card inserted into slot 0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: IBM system detected; this module may corrupt 
your serial eeprom! Refusing to load module!
piix4_smbus: probe of 0000:00:07.3 failed with error -1
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input1
irda_init()
NET: Registered protocol family 23
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input2
parport_pc 00:0d: reported by Plug and Play ACPI
parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
cs: IO port probe 0x100-0x3af: excluding 0x2f8-0x2ff
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: memory probe 0xa0000000-0xa0ffffff: clean.
pcmcia: registering new device pcmcia0.0
cs: IO port probe 0x100-0x3af: excluding 0x2f8-0x2ff
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 3.
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x02e
nsc-ircc, driver loaded (Dag Brattli)
IrDA: Registered device irda0
nsc-ircc, Found dongle: Reserved
nsc_ircc_init_dongle_interface(), Reserved not defined by irda yet
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKA] -> GSI 5 (level, low) 
-> IRQ 5
cs46xx: failure waiting for FIFO command to complete
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin 
<proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel 
Roskin <proski@gnu.org>, et al)
eth1: Hardware identity 0001:0001:0004:0000
eth1: Station identity  001f:0001:0008:0048
eth1: Firmware determined as Lucent/Agere 8.72
eth1: Ad-hoc demo mode supported
eth1: IEEE standard IBSS ad-hoc mode supported
eth1: WEP supported, 104-bit key
eth1: MAC address 00:60:1D:23:D3:1D
eth1: Station name "HERMES I"
eth1: ready
eth1: orinoco_cs at 0.0, irq 4, io 0x0100-0x013f
gameport: CS46xx Gameport is pci0000:00:05.0/gameport0, speed 1704kHz
Adding 695512k swap on /dev/hda2.  Priority:-1 extents:1 across:695512k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
pcmcia: Detected deprecated PCMCIA ioctl usage from process: discover.
pcmcia: This interface will soon be removed from the kernel; please 
expect breakage unless you upgrade to new tools.
pcmcia: see 
http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
eth1: New link status: Connected (0001)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [AC] (on-line)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
nbd: registered device at major 43
eth1: no IPv6 routers present
powernow: This module only works with AMD K7 CPUs

