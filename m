Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYCITA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYCITA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCITAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:00:16 -0400
Received: from mail.xtech.com.ar ([216.75.63.130]:58372 "EHLO
	mail.xtech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYCITAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:00:11 -0400
Date: Sun, 9 Mar 2008 17:00:02 -0200
From: Diego Woitasen <diego@woitasen.com.ar>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: BUG: High resolution timer/dynticks bug
Message-ID: <20080309190002.GB15058@motherbox.xtech.com.ar>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <20080304230032.GA2967@motherbox.xtech.com.ar> <20080305082731.GA24004@atrey.karlin.mff.cuni.cz> <20080306225006.GA2972@motherbox.xtech.com.ar> <alpine.LFD.1.00.0803071113340.3099@apollo.tec.linutronix.de> <20080309013009.GE2972@motherbox.xtech.com.ar> <alpine.LFD.1.00.0803091623100.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803091623100.3099@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 04:42:05PM +0100, Thomas Gleixner wrote:
> On Sat, 8 Mar 2008, Diego Woitasen wrote:
> > > 
> > > Is the problem reproducible when you add "hpet=disable" to the kernel
> > > command line ?
> > 
> > No, with hpet=disable works fine.
> 
> Can you please try "processor.max_cstate=2" on the kernel command line ?
> 
> Also please provide a full boot log and the output of lspci -vvv
> 
> Thanks,
> 
> 	tglx

I tried. Same results, freezes after few minutes.

----------------dmesg:

Linux version 2.6.25-rc4-porti-funca-00134-g84c6f60 (diegows@porti) (gcc version 4.2.3 (Debian 4.2.3-1)) #41 PREEMPT Sun Mar 9 16:04:34 ARST 2008
Command line: root=/dev/sda2 ro nmi_watchdog=2 netconsole=4444@192.168.1.101/eth0,5555@192.168.1.10/00:0e:a6:b1:7e:92 processor.max_cstate=2
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001df10000 (usable)
 BIOS-e820: 000000001df10000 - 000000001df18000 (ACPI data)
 BIOS-e820: 000000001df18000 - 000000001df80000 (ACPI NVS)
 BIOS-e820: 000000001df80000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 122640) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F87B0, 0024 (r3 HPQOEM)
ACPI: XSDT 1DF11044, 005C (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 1DF17B21, 00F4 (r3 HPQOEM SLIC-MPC  6040000 PTL     F4240)
ACPI: DSDT 1DF110A0, 6A81 (r1 HPQOEM SLIC-MPC  6040000 MSFT  100000E)
ACPI: FACS 1DF18FC0, 0040
ACPI: SLIC 1DF17C89, 0176 (r1 HPQOEM SLIC-MPC  6040000 HPQ         1)
ACPI: MCFG 1DF17DFF, 003C (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: HPET 1DF17E3B, 0038 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
ACPI: APIC 1DF17E73, 0050 (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: BOOT 1DF17EC3, 0028 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
ACPI: SSDT 1DF17EEB, 0115 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 122640) 1 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [200000-676867] TEXT DATA BSS
early res: 2 [9dc00-9fbff] EBDA
early res: 3 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      157
    0:      256 ->   122640
On node 0 totalpages: 122541
  DMA zone: 56 pages used for memmap
  DMA zone: 1150 pages reserved
  DMA zone: 2791 pages, LIFO batch:0
  DMA32 zone: 1620 pages used for memmap
  DMA32 zone: 116924 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 119715
Kernel command line: root=/dev/sda2 ro nmi_watchdog=2 netconsole=4444@192.168.1.101/eth0,5555@192.168.1.10/00:0e:a6:b1:7e:92 processor.max_cstate=2
Unknown boot option `processor.max_cstate=2': ignoring
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2009.142 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Checking aperture...
Node 0: aperture @ b1fe000000 size 32 MB
Aperture beyond 4GB. Ignoring.
No AGP bridge found
Memory: 475876k/490560k available (2972k kernel code, 13632k reserved, 1044k data, 196k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 4020.80 BogoMIPS (lpj=2010403)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: AMD Turion(tm) 64  stepping 02
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12557133
Detected 12.557 MHz APIC timer.
Testing NMI watchdog ... OK.
net_namespace: 872 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e02fffff
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x1, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19 20 21 22 23) *10
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 20) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 19) *11
ACPI: PCI Interrupt Link [LK3E] (IRQs 21) *10
ACPI: PCI Interrupt Link [LK4E] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 22 23) *10
ACPI: PCI Interrupt Link [LSMU] (IRQs 16 17 18 19 20 21 22 23) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 18 19 20 21 22 23) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 18 19 20 21 22 23) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 18 19 20 21 22 23) *11
ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 16 17 18 19 20 21 22 23) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 16 17 18 19 20 21 22 23) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: tsc clocksource has been installed.
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1080-0x10ff has been reserved
system 00:02: ioport range 0x1400-0x147f has been reserved
system 00:02: ioport range 0x1480-0x14ff has been reserved
system 00:02: ioport range 0x1800-0x187f has been reserved
system 00:02: ioport range 0x1880-0x18ff has been reserved
system 00:02: ioport range 0x2000-0x203f has been reserved
system 00:03: ioport range 0x360-0x361 has been reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: 0xc3000000-0xc30fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: 4000-4fff
  MEM window: 0xc8000000-0xc87fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: 0xc3100000-0xc31fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
Total HugeTLB memory allocated, 0
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:02.0: Enabling HT MSI Mapping
pci 0000:00:03.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Boot video device
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:10.0: Enabling HT MSI Mapping
pci 0000:00:10.1: Enabling HT MSI Mapping
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie03]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to 64
Switched to high resolution mode on CPU 0
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:16:d3:91:30:79
forcedeth 0000:00:14.0: highdma pwrctl timirq lnktim desc-v3
netconsole: local port 4444
netconsole: local IP 192.168.1.101
netconsole: interface eth0
netconsole: remote port 5555
netconsole: remote IP 192.168.1.10
netconsole: remote ethernet address 00:0e:a6:b1:7e:92
netconsole: device eth0 not up yet, forcing it
eth0: no link during initialization.
netconsole: timeout waiting for carrier
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP51: 0000:00:0d.0 (rev f1) UDMA133 controller
NFORCE-MCP51: IDE controller (0x10de:0x0265 rev 0xf1) at  PCI slot 0000:00:0d.0
NFORCE-MCP51: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x3080-0x3087, BIOS settings: hda:PIO, hdb:PIO
    ide1: BM-DMA at 0x3088-0x308f, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: Slimtype DVD A DS8AZH, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: MWDMA2 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
isa bounce pool size: 16 pages
Probing IDE interface ide0...
hdc: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0e.0: version 3.5
PCI: Enabling device 0000:00:0e.0 (0005 -> 0007)
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LTID] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30b0 ctl 0x30a4 bmdma 0x3090 irq 22
ata2: SATA max UDMA/133 cmd 0x30a8 ctl 0x30a0 bmdma 0x3098 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: WDC WD1200BEVS-60LAT0, 01.06M01, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200BEVS-6 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
IPVS: Registered protocols ()
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: ipvs loaded.
NET: Registered protocol family 1
NET: Registered protocol family 17
can: controller area network core (rev 20071116 abi 8)
NET: Registered protocol family 29
input: AT Translated Set 2 keyboard as /class/input/input0
XFS mounting filesystem sda2
Ending clean XFS mount for filesystem: sda2
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 196k freed
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [TZS0] (54 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [TZS1] (57 C)
ACPI: PCI Interrupt Link [LK2E] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LK2E] -> GSI 19 (level, high) -> IRQ 19
PCI: Setting latency timer of device 0000:01:00.0 to 64
ACPI: AC Adapter [ADP1] (on-line)
ssb: Sonics Silicon Backplane found on PCI device 0000:01:00.0
ACPI: Battery Slot [BAT0] (battery present)
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x3000
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 21
ACPI: PCI Interrupt 0000:03:09.0[A] -> Link [LNK1] -> GSI 21 (level, high) -> IRQ 21
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUS2] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 20, io mem 0xc0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[c3100000-c31007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc4-porti-funca-00134-g84c6f60 ehci_hcd
usb usb1: SerialNumber: 0000:00:0b.1
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 18
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUS0] -> GSI 18 (level, high) -> IRQ 18
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 18, io mem 0xc0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
bcm43xx driver
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc4-porti-funca-00134-g84c6f60 ohci_hcd
usb usb2: SerialNumber: 0000:00:0b.0
sdhci: SDHCI controller found at 0000:03:09.1 [1180:0822] (rev 19)
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 17
ACPI: PCI Interrupt 0000:03:09.1[B] -> Link [LNK2] -> GSI 17 (level, high) -> IRQ 17
sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: SDHCI at 0xc3100800 irq 17 DMA
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 16
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 16 (level, high) -> IRQ 16
PCI: Setting latency timer of device 0000:00:10.1 to 64
input: ImPS/2 Synaptics TouchPad as /class/input/input5
b43-phy0: Broadcom 4311 WLAN found
phy0: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[07e40a00f6cb5006]
Adding 987956k swap on /dev/sda5.  Priority:-1 extents:1 across:987956k
loop: module loaded
powernow-k8: Found 1 AMD Turion(tm) 64  processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x12
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x18
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Ebtables v2.0 registered
Bridge firewalling registered
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
Filesystem "dm-1": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
atkbd.c: Unknown key pressed (translated set 2, code 0xd9 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e059 <keycode>' to make it known.
atkbd.c: Unknown key released (translated set 2, code 0xd9 on isa0060/serio0).
atkbd.c: Use 'setkeycodes e059 <keycode>' to make it known.
Marking TSC unstable due to TSC halts in idle
Time: hpet clocksource has been installed.


------------------------lspci -vvv:

00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 800MHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 800MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] #00 [00fe]
	Capabilities: [fc] #00 [0000]

00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c3000000-c30fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0100c  Data: 4149
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: c8000000-c87fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0100c  Data: 4151
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt+ MRL- PresDet- CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: pcieport-driver

00:05.0 VGA compatible controller: nVidia Corporation C51 [Geforce 6150 Go] (rev a2) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Presario V3242AU
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=9 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 800MHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 4: I/O ports at 3040 [size=64]
	Region 5: I/O ports at 3000 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
	Subsystem: Hewlett-Packard Company Presario V3242AU
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at c0040000 (32-bit, non-prefetchable) [size=256K]

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c0004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at c0005000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev f1) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at 3080 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: AMD_IDE

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev f1) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 30b0 [size=8]
	Region 1: I/O ports at 30a4 [size=4]
	Region 2: I/O ports at 30a8 [size=8]
	Region 3: I/O ports at 30a0 [size=4]
	Region 4: I/O ports at 3090 [size=16]
	Region 5: Memory at c0006000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: sata_nv

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c3100000-c31fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device 0000
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
	Subsystem: Hewlett-Packard Company Presario V3242AU
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 16
	Region 0: Memory at c0000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at c0007000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at 30b8 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Kernel driver in use: forcedeth

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=8
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

01:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan mini-PCI (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 1364
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at c3000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [13c] Virtual Channel <?>
	Kernel driver in use: b43-pci-bridge
	Kernel modules: bcm43xx, ssb

03:09.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at c3100000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

03:09.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at c3100800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sdhci
	Kernel modules: sdhci

03:09.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at c3100c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:09.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at c3101000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:09.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
	Subsystem: Hewlett-Packard Company Unknown device 30b5
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at c3101400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-





-- 

--------------
Diego Woitasen
