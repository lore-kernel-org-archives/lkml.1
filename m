Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbXHYVAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbXHYVAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXHYU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:59:55 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:49927 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXHYU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:59:52 -0400
Message-ID: <46D0974B.5030806@trn.iki.fi>
Date: Sat, 25 Aug 2007 23:55:39 +0300
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+bpsk@trn.iki.fi>
User-Agent: Thunderbird 2.0.0.6 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3 USB segfaults + urb status -32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My system is unusably unstable using this kernel. On last boot it
started flooding urb status -32 to kernel log at a rate of several
megabytes per second. Now it printed segfaults before the system had
finished booting and then some other errors... The full log is here:

I couldn't find information on these bugs. If you need more debug info,
please contact me. I can also reproduce the errors without the Nvidia
kernel module, if that is really necessary (note, however, that the
first segfaults in this log happen before the module loads).

I think that part of the USB problems may be related to M-Audio
FastTrack Pro USB sound card, because I have managed to crash the kernel
USB system before (with a 32 bit kernel, and also on another computer)
by switching bConfigurationValue of that card.

Running on x86-64 with Core2 Q6600 B3.

Linux version 2.6.23-rc3 (root@localhost) (gcc version 4.1.1 (Gentoo
4.1.1-r3)) #1 SMP PREEMPT Sat Aug 25 10:01:23 EEST 2007
Command line: root=/dev/md3 usbhid.mousepoll=2 usb-storage.delay_use=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
 BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
 BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
 BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524000) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F6CF0, 0014 (r0 GBT   )
ACPI: RSDT 7FEE3040, 0034 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP 7FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT 7FEE3180, 49F4 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS 7FEE0000, 0040
ACPI: HPET 7FEE7CC0, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG 7FEE7D40, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC 7FEE7BC0, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 524000) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524000
On node 0 totalpages: 523903
  DMA zone: 56 pages used for memmap
  DMA zone: 10 pages reserved
  DMA zone: 3933 pages, LIFO batch:0
  DMA32 zone: 7108 pages used for memmap
  DMA32 zone: 512796 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ff00000:70100000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 31200 bytes of per cpu data
Built 1 zonelists in Zone order.  Total pages: 516729
Kernel command line: root=/dev/md3 usbhid.mousepoll=2
usb-storage.delay_use=0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2400.000 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Memory: 2055772k/2096000k available (4847k kernel code, 39476k reserved,
1890k data, 268k init)
Calibrating delay using timer specific routine.. 4802.57 BogoMIPS
(lpj=2401287)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666654
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4799.96 BogoMIPS
(lpj=2399980)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x3
Initializing CPU#2
Calibrating delay using timer specific routine.. 4799.95 BogoMIPS
(lpj=2399978)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x2
Initializing CPU#3
Calibrating delay using timer specific routine.. 4800.09 BogoMIPS
(lpj=2400049)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
xor: automatically using best checksumming function: generic_sse
   generic_sse:  8468.000 MB/sec
xor: using function: generic_sse (8468.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - f3ffffff
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
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
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:08: ioport range 0x400-0x4bf could not be reserved
pnp: 00:09: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:0a: iomem range 0xd1000-0xd3fff has been reserved
pnp: 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0a: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: f4000000-f7ffffff
  PREFETCH window: e0000000-efffffff
PCI: Bridge: 0000:00:1c.0
  IO window: 4000-4fff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: fa000000-fa0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: 9000-9fff
  MEM window: f8000000-f9ffffff
  PREFETCH window: 80000000-800fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 5000-5fff
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NTFS driver 2.1.28 [Flags: R/O].
fuse init (API version 7.8)
SGI XFS with large block/inode numbers, no debug enabled
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
ACPI: Processor [CPU0] (supports 2 throttling states)
ACPI: Processor [CPU1] (supports 2 throttling states)
ACPI: Processor [CPU2] (supports 2 throttling states)
ACPI: Processor [CPU3] (supports 2 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
sky2 0000:04:00.0: v1.16 addr 0xf9000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
sky2 eth0: addr 00:1a:4d:66:e9:e7
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Linux video capture interface: v2.00
saa7146: register extension 'budget dvb'.
usbcore: registered new interface driver dvb_usb_dibusb_mb
usbcore: registered new interface driver dvb_usb_dibusb_mc
dib0700: loaded with support for 2 different device-types
usbcore: registered new interface driver dvb_usb_dib0700
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x000000000001b400 ctl 0x000000000001b802
bmdma 0x000000000001c400 irq 19
ata2: SATA max UDMA/133 cmd 0x000000000001bc00 ctl 0x000000000001c002
bmdma 0x000000000001c408 irq 19
ata1.00: Host Protected Area detected:
	current size: 1953523055 sectors
	native size: 1953525168 sectors
ata1.00: ATA-7: Hitachi HDS721010KLA330, GKAOA51D, max UDMA/133
ata1.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: Host Protected Area detected:
	current size: 1953523055 sectors
	native size: 1953525168 sectors
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72101 GKAO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x000000000001d000 ctl 0x000000000001d402
bmdma 0x000000000001e000 irq 19
ata4: SATA max UDMA/133 cmd 0x000000000001d800 ctl 0x000000000001dc02
bmdma 0x000000000001e008 irq 19
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfa104000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfa105000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ac00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b000
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 2-3: new high speed USB device using ehci_hcd and address 2
usb 2-3: configuration #1 chosen from 1 choice
usb 2-6: new high speed USB device using ehci_hcd and address 3
usb 2-6: configuration #1 chosen from 1 choice
hub 2-6:1.0: USB hub found
hub 2-6:1.0: 4 ports detected
usb 1-1.1: new low speed USB device using ehci_hcd and address 3
usb 1-1.1: configuration #1 chosen from 1 choice
usb 1-1.2: new high speed USB device using ehci_hcd and address 4
usb 1-1.2: configuration #1 chosen from 1 choice
usb 1-1.3: new high speed USB device using ehci_hcd and address 5
usb 1-1.3: configuration #1 chosen from 1 choice
usb 1-1.4: new full speed USB device using ehci_hcd and address 6
usb 1-1.4: device not accepting address 6, error -110
usb 1-1.4: new full speed USB device using ehci_hcd and address 7
usb 1-1.4: configuration #1 chosen from 1 choice
usb 2-6.1: new full speed USB device using ehci_hcd and address 4
usb 2-6.1: configuration #1 chosen from 2 choices
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
usb-storage: device scan complete
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
scsi 4:0:0:0: Direct-Access     JetFlash TS16GJF2A/120    8.07 PQ: 0 ANSI: 2
sd 4:0:0:0: [sdb] 32112638 512-byte hardware sectors (16442 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 32112638 512-byte hardware sectors (16442 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 sdb2 sdb3
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16
i2c /dev entries driver
coretemp coretemp.0: Using undocumented features, absolute temperature
might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature
might be wrong!
coretemp coretemp.2: Using undocumented features, absolute temperature
might be wrong!
coretemp coretemp.3: Using undocumented features, absolute temperature
might be wrong!
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int64x1   2035 MB/s
raid6: int64x2   2792 MB/s
raid6: int64x4   3121 MB/s
raid6: int64x8   1921 MB/s
raid6: sse2x1    3843 MB/s
raid6: sse2x2    3964 MB/s
raid6: sse2x4    6824 MB/s
raid6: using algorithm sse2x4 (6824 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
EDAC MC: Ver: 2.1.0 Aug 25 2007
input: HID 04d9:1400 as
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1:1.0/input/input0
input: USB HID v1.10 Keyboard [HID 04d9:1400] on usb-0000:00:1a.7-1.1
input: HID 04d9:1400 as
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1:1.1/input/input1
input: USB HID v1.10 Mouse [HID 04d9:1400] on usb-0000:00:1a.7-1.1
input: Razer Razer Copperhead Laser Mouse as
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.4/1-1.4:1.0/input/input2
input: USB HID v10.01 Mouse [Razer Razer Copperhead Laser Mouse] on
usb-0000:00:1a.7-1.4
input: Razer Razer Copperhead Laser Mouse as
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.4/1-1.4:1.1/input/input3
input: USB HID v10.01 Keyboard [Razer Razer Copperhead Laser Mouse] on
usb-0000:00:1a.7-1.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20
09:12:58 2007 UTC).
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: Creative Labs USB Device 0x41e:0x4058 at usb-0000:00:1a.7-1.2,
high speed
  #1: M-Audio FastTrack Pro at usb-0000:00:1d.7-6.1, full speed
oprofile: using NMI interrupt.
netem: version 1.2
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP scalable registered
TCP yeah registered
TCP illinois registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md: sda2 has different UUID to sdb3
md: created md3
md: bind<sdb3>
md: running: <sdb3>
raid1: raid set md3 active with 1 out of 1 mirrors
md: considering sda2 ...
md:  adding sda2 ...
md: created md13
md: bind<sda2>
md: running: <sda2>
raid1: raid set md13 active with 1 out of 2 mirrors
md: ... autorun DONE.
UDF-fs: No VRS found
Filesystem "md3": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md3
Starting XFS recovery on filesystem: md3 (logdev: internal)
Ending XFS recovery on filesystem: md3 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 268k freed
usb_id[1773]: segfault at 0000000000000000 rip 00002aef50015df0 rsp
00007fff5ac20568 error 4
usb_id[1777]: segfault at 0000000000000000 rip 00002b5029847df0 rsp
00007fff813efd38 error 4
usb_id[1778]: segfault at 0000000000000000 rip 00002b411ea9bdf0 rsp
00007fff8c199ad8 error 4
usb_id[1776]: segfault at 0000000000000000 rip 00002b6a7a12bdf0 rsp
00007fff30b0a448 error 4
usb_id[1780]: segfault at 0000000000000000 rip 00002b2485beadf0 rsp
00007fff2504c998 error 4
usb_id[1781]: segfault at 0000000000000000 rip 00002b2c8cf6bdf0 rsp
00007fff1dccc608 error 4
uvcvideo: Found UVC 1.00 device <unnamed> (041e:4058)
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13
16:33:22 PDT 2007
Filesystem "md3": Disabling barriers, not supported by the underlying device
sky2 eth0: enabling interface
sky2 eth0: ram buffer 0K
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
Filesystem "md13": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem md13
Ending clean XFS mount for filesystem: md13
cannot submit datapipe for urb 0, error -38: enable
CONFIG_USB_EHCI_SPLIT_ISO to play through a hub
cannot submit datapipe for urb 0, error -38: enable
CONFIG_USB_EHCI_SPLIT_ISO to play through a hub
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
urb status -32
usb 2-6.1: USB disconnect, address 4
sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"

Call Trace:
 [<ffffffff81367499>] usb_remove_sysfs_dev_files+0x89/0xa0
 [<ffffffff813636d5>] usb_unbind_device+0x15/0x20
 [<ffffffff812bc812>] __device_release_driver+0x82/0xc0
 [<ffffffff812bcd23>] device_release_driver+0x33/0x60
 [<ffffffff812bbffb>] bus_remove_device+0x5b/0x90
 [<ffffffff812ba1db>] device_del+0x16b/0x2a0
 [<ffffffff8135d179>] usb_disconnect+0xc9/0x150
 [<ffffffff8135d9a8>] hub_thread+0x3c8/0xdd0
 [<ffffffff814b6580>] thread_return+0x57/0x5a7
 [<ffffffff8104fb10>] autoremove_wake_function+0x0/0x30
 [<ffffffff8135d5e0>] hub_thread+0x0/0xdd0
 [<ffffffff8104f73b>] kthread+0x4b/0x80
 [<ffffffff8100cb98>] child_rip+0xa/0x12
 [<ffffffff8104f6f0>] kthread+0x0/0x80
 [<ffffffff8100cb8e>] child_rip+0x0/0x12

usb 2-6.1: new full speed USB device using ehci_hcd and address 5
usb 2-6.1: configuration #1 chosen from 2 choices
cannot submit datapipe for urb 0, error -38: enable
CONFIG_USB_EHCI_SPLIT_ISO to play through a hub
cannot submit datapipe for urb 0, error -38: enable
CONFIG_USB_EHCI_SPLIT_ISO to play through a hub
cannot submit datapipe for urb 0, error -38: enable
CONFIG_USB_EHCI_SPLIT_ISO to play through a hub

