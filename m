Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYGXWzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYGXWzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXWyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:54:49 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:7615 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGXWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:from;
        b=eSG1K2QKPm4SVqCfYG65RXHg86z6LSZzuIC8P6Xz0L86I2qWNoVnsAB49pzYJV/foV
         Ma214sY+I9MqzpH6uQ4eUyl90pPstgMU/9ChSbkCQsAxnlKP4BFAW4nnjHdpuHHqJSgg
         NbDDddKioSFbwzfCzDkNUwc7WRU9/rzy0w1/Q=
Message-ID: <4889081E.3000308@gmail.com>
Date: Thu, 24 Jul 2008 18:54:22 -0400
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Bisected] Regression: Hang on boot in schedule_timeout_interruptible
 during ACPI init on SMP
References: <4887B4D5.1050306@gmail.com> <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
In-Reply-To: <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040004010509030800000700"
From: Andrew Drake <zappacky.lists@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040004010509030800000700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Glauber Costa wrote:
 >
 > on the other hand, the commit right after the good one modifies the
 > mptable, and may have messed the apic ids for you box. Could you please
 > attach a dmesg with apic debug messages turned on? Whatever commit you
 > can boot is fine, provided you tell me which one you used.
 >

Attached, last-good.dmesg.txt is the last kernel without the regression, 
first-bad.dmesg.txt is the first kernel with the regression. Both have 
"apic=debug" enabled.


 >> Anybody have any ideas? I'm willing to write a patch if somebody can help me
 >> track down the root cause.
 >> P.S. I'm willing to provide any information that you'd like to see, like
 >> my .config or my DSDT (disassembled or otherwise). I didn't include it
 >> in this email because I wasn't sure what would be helpful.
 >
 > Yeah, sure. .config helps too.
 >

I only included the disassembled DSDT, since I don't know how well binary 
attachments are handled by the list/etc.

Thanks!

-Andrew

--------------040004010509030800000700
Content-Type: text/plain;
 name="first-bad.dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="first-bad.dmesg.txt"

Linux version 2.6.25-bisect (root@AndrewLaptop) (gcc version 4.3.1 (Debian 4.3.1-2) ) #1 SMP Thu Jul 24 06:05:15 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077f00000 (usable)
 BIOS-e820: 0000000077f00000 - 0000000077f0a000 (ACPI data)
 BIOS-e820: 0000000077f0a000 - 0000000077f80000 (ACPI NVS)
 BIOS-e820: 0000000077f80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
1023MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f89e0] 000f89e0
Entering add_active_range(0, 0, 491264) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   491264
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   491264
On node 0 totalpages: 491264
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2046 pages used for memmap
  HighMem zone: 259842 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F8920, 0014 (r0 HP    )
ACPI: RSDT 77F00926, 0040 (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 77F09AD4, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 77F00966, 916E (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 77F0AFC0, 0040
ACPI: SSDT 77F09B48, 0248 (r1 HP     POWERNOW  6040000  LTP        1)
ACPI: MCFG 77F09D90, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 77F09DCC, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 77F09E04, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 77F09E62, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: SLIC 77F09E8A, 0176 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:8 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:8 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 31784 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 487426
Kernel command line: root=/dev/sda3 ro apic=debug
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2194.127 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1943632k/1965056k available (2597k kernel code, 20388k reserved, 869k data, 212k init, 1047552k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc046a000 - 0xc049f000   ( 212 kB)
      .data : 0xc03897b3 - 0xc0462cc0   ( 869 kB)
      .text : 0xc0100000 - 0xc03897b3   (2597 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4393.23 BogoMIPS (lpj=7318769)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-64 stepping 02
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting LVT0: 10000
Getting LVT1: 10000
masked ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1246643
... PM timer delta = 357954
... PM timer result ok
..... delta 1246643
..... mult: 53546400
..... calibration result: 664876
..... CPU clock speed is 2194.1035 MHz.
..... host bus clock speed is 199.1609 MHz.
Booting processor 1/1 ip 2000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4389.02 BogoMIPS (lpj=7313635)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
AMD C1E detected late. 	Force timer broadcast.
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-64 stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8782.25 BogoMIPS).
net_namespace: 160 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: \_SB_.PCI0.IDE0.PRI0.MAST: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRI0.MAST: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRI0.MAST] Added
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *10
ACPI: PCI Interrupt Link [LK4E] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 20 22 23) *10
ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 20 22 23) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 21) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 21) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set PCI routing entry (2-13 -> 0x91 -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-8 -> 0x69 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-1 -> 0x39 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-12 -> 0x89 -> IRQ 12 Mode:0 Active:0)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 02000000
.......     : arbitration: 02
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    31
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 003 03  1    0    0   0   0    1    1    51
 06 003 03  0    0    0   0   0    1    1    59
 07 003 03  1    0    0   0   0    1    1    61
 08 003 03  1    0    0   0   0    1    1    69
 09 003 03  0    1    0   1   0    1    1    71
 0a 003 03  1    0    0   0   0    1    1    79
 0b 003 03  1    0    0   0   0    1    1    81
 0c 003 03  1    0    0   0   0    1    1    89
 0d 003 03  1    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  0    0    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:01: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1080-0x10ff has been reserved
system 00:04: ioport range 0x1400-0x147f has been reserved
system 00:04: ioport range 0x1480-0x14ff has been reserved
system 00:04: ioport range 0x1800-0x187f has been reserved
system 00:04: ioport range 0x1880-0x18ff has been reserved
system 00:04: ioport range 0x2000-0x203f has been reserved
system 00:05: ioport range 0x360-0x361 has been reserved
system 00:05: ioport range 0x380-0x383 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: 4000-4fff
  MEM window: 0xc4000000-0xc7ffffff
  PREFETCH window: 0x00000000c9000000-0x00000000c91fffff
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: 0xc8000000-0xc8ffffff
  PREFETCH window: 0x00000000c9200000-0x00000000c93fffff
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
Simple Boot Flag at 0x36 set to 0x1
highmem bounce pool size: 64 pages
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
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
ALI M7101 PMU not found.
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (51 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP51: 0000:00:0d.0 (rev f1) UDMA133 controller
NFORCE-MCP51: IDE controller (0x10de:0x0265 rev 0xf1) at  PCI slot 0000:00:0d.0
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP51: IDE port disabled
    ide0: BM-DMA at 0x3080-0x3087, BIOS settings: hda:DMA, hdb:PIO
Probing IDE interface ide0...
hda: Slimtype DVD A DS8A1H, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-869.
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0e.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
IOAPIC[0]: Set PCI routing entry (2-21 -> 0xb9 -> IRQ 21 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LTID] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30b0 ctl 0x30a4 bmdma 0x3090 irq 21
ata2: SATA max UDMA/133 cmd 0x30a8 ctl 0x30a0 bmdma 0x3098 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD2500BEVS-60UST0, 01.01A01, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BEVS-6 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
IOAPIC[0]: Set PCI routing entry (2-23 -> 0xc1 -> IRQ 23 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUS2] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 23, io mem 0xc0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
IOAPIC[0]: Set PCI routing entry (2-22 -> 0xc9 -> IRQ 22 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUS0] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 22, io mem 0xc0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
usb 2-7: new full speed USB device using ohci_hcd and address 2
usb 2-7: configuration #1 chosen from 1 choice
usb 1-2.1: new high speed USB device using ehci_hcd and address 4
usb 1-2.1: configuration #1 chosen from 1 choice
usb 1-2.2: new full speed USB device using ehci_hcd and address 5
usb 1-2.2: configuration #1 chosen from 1 choice
usb 1-2.3: new full speed USB device using ehci_hcd and address 6
usb 1-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
rtc_cmos: probe of 00:09 failed with error -16
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-64 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x12
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x13
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x14
powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0x15
powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x1e
Starting balanced_irq
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x180b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 212k freed
Adding 971924k swap on /dev/sda4.  Priority:-1 extents:1 across:971924k
EXT3 FS on sda3, internal journal
Clocksource tsc unstable (delta = -85152886 ns)
cdrom: This disc doesn't have any tracks I recognize!
pktcdvd: writer pktcdvd0 mapped to hda
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--------------040004010509030800000700
Content-Type: text/plain;
 name="last-good.dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="last-good.dmesg.txt"

Linux version 2.6.25.3 (root@AndrewLaptop) (gcc version 4.2.3 (Debian 4.2.3-5)) #1 SMP Wed May 14 17:20:19 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077f00000 (usable)
 BIOS-e820: 0000000077f00000 - 0000000077f0a000 (ACPI data)
 BIOS-e820: 0000000077f0a000 - 0000000077f80000 (ACPI NVS)
 BIOS-e820: 0000000077f80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
1023MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f89e0] 000f89e0
Entering add_active_range(0, 0, 491264) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   491264
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   491264
On node 0 totalpages: 491264
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2046 pages used for memmap
  HighMem zone: 259842 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F8920, 0014 (r0 HP    )
ACPI: RSDT 77F00926, 0040 (r1 HPQOEM SLIC-MPC  6040000  LTP        0)
ACPI: FACP 77F09AD4, 0074 (r1 HP     MCP51M    6040000 PTL_    F4240)
ACPI: DSDT 77F00966, 916E (r1 HP       MCP51M  6040000 MSFT  3000000)
ACPI: FACS 77F0AFC0, 0040
ACPI: SSDT 77F09B48, 0248 (r1 HP     POWERNOW  6040000  LTP        1)
ACPI: MCFG 77F09D90, 003C (r1 HP       MCFG    6040000  LTP        0)
ACPI: HPET 77F09DCC, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
ACPI: APIC 77F09E04, 005E (r1 HP     	 APIC    6040000  LTP        0)
ACPI: BOOT 77F09E62, 0028 (r1     HP $SBFTBL$  6040000  LTP        1)
ACPI: SLIC 77F09E8A, 0176 (r1 HPQOEM SLIC-MPC  6040000  LTP        1)
ACPI: DMI detected: Hewlett-Packard
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:8 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:8 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 487426
Kernel command line: root=/dev/sda3 ro apic=debug
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 797.867 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1942688k/1965056k available (3270k kernel code, 21340k reserved, 1053k data, 268k init, 1047552k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0541000 - 0xc0584000   ( 268 kB)
      .data : 0xc0431b92 - 0xc0539158   (1053 kB)
      .text : 0xc0100000 - 0xc0431b92   (3270 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 1597.09 BogoMIPS (lpj=798547)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-64 stepping 02
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting LVT0: 10000
Getting LVT1: 10000
masked ExtINT on CPU#0
Booting processor 1/1 ip 4000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 1595.78 BogoMIPS (lpj=797890)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
AMD C1E detected late. 	Force timer broadcast.
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-64 stepping 02
Total of 2 processors activated (3192.87 BogoMIPS).
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 2 CPUs
net_namespace: 160 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: \_SB_.PCI0.IDE0.PRI0.MAST: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRI0.MAST: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRI0.MAST] Added
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LK3E] (IRQs 18) *10
ACPI: PCI Interrupt Link [LK4E] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 20 22 23) *10
ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 20 22 23) *7
ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 20 22 23) *11
ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 20 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 21) *5
ACPI: PCI Interrupt Link [LSI1] (IRQs 21) *0
ACPI: WMI: Mapper loaded
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set PCI routing entry (2-13 -> 0x91 -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-8 -> 0x69 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-1 -> 0x39 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-12 -> 0x89 -> IRQ 12 Mode:0 Active:0)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 02000000
.......     : arbitration: 02
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 003 03  1    0    0   0   0    1    1    39
 02 003 03  0    0    0   0   0    1    1    31
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 003 03  1    0    0   0   0    1    1    51
 06 003 03  0    0    0   0   0    1    1    59
 07 003 03  1    0    0   0   0    1    1    61
 08 003 03  1    0    0   0   0    1    1    69
 09 003 03  0    1    0   1   0    1    1    71
 0a 003 03  1    0    0   0   0    1    1    79
 0b 003 03  1    0    0   0   0    1    1    81
 0c 003 03  1    0    0   0   0    1    1    89
 0d 003 03  1    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  0    0    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
ACPI: RTC can wake from S4
system 00:00: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:01: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:04: ioport range 0x1000-0x107f has been reserved
system 00:04: ioport range 0x1080-0x10ff has been reserved
system 00:04: ioport range 0x1400-0x147f has been reserved
system 00:04: ioport range 0x1480-0x14ff has been reserved
system 00:04: ioport range 0x1800-0x187f has been reserved
system 00:04: ioport range 0x1880-0x18ff has been reserved
system 00:04: ioport range 0x2000-0x203f has been reserved
system 00:05: ioport range 0x360-0x361 has been reserved
system 00:05: ioport range 0x380-0x383 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: 4000-4fff
  MEM window: 0xc4000000-0xc7ffffff
  PREFETCH window: 0x00000000c9000000-0x00000000c91fffff
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: 0xc8000000-0xc8ffffff
  PREFETCH window: 0x00000000c9200000-0x00000000c93fffff
PCI: Bridge: 0000:00:10.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1216924817.500:1): initialized
highmem bounce pool size: 64 pages
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
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
ALI M7101 PMU not found.
ACPI: AC Adapter [ACAD] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
ACPI: Lid Switch [LID]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (36 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
IOAPIC[0]: Set PCI routing entry (2-23 -> 0xb9 -> IRQ 23 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1e:68:04:ff:2e
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP51: 0000:00:0d.0 (rev f1) UDMA133 controller
NFORCE-MCP51: IDE controller (0x10de:0x0265 rev 0xf1) at  PCI slot 0000:00:0d.0
NFORCE-MCP51: not 100% native mode: will probe irqs later
NFORCE-MCP51: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP51: IDE port disabled
    ide0: BM-DMA at 0x3080-0x3087, BIOS settings: hda:DMA, hdb:PIO
Probing IDE interface ide0...
hda: Slimtype DVD A DS8A1H, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-869.
iscsi: registered transport (tcp)
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0e.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
IOAPIC[0]: Set PCI routing entry (2-21 -> 0xc1 -> IRQ 21 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LTID] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0e.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x30b0 ctl 0x30a4 bmdma 0x3090 irq 21
ata2: SATA max UDMA/133 cmd 0x30a8 ctl 0x30a0 bmdma 0x3098 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD2500BEVS-60UST0, 01.01A01, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BEVS-6 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
IOAPIC[0]: Set PCI routing entry (2-22 -> 0xc9 -> IRQ 22 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUS2] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 22, io mem 0xc0005000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
IOAPIC[0]: Set PCI routing entry (2-20 -> 0xd1 -> IRQ 20 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUS0] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 20, io mem 0xc0004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
hub 1-2:1.0: USB hub found
hub 1-2:1.0: 4 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 7
usb 2-7: new full speed USB device using ohci_hcd and address 2
usb 2-7: configuration #1 chosen from 1 choice
usb 1-2.1: new high speed USB device using ehci_hcd and address 4
usb 1-2.1: configuration #1 chosen from 1 choice
usb 1-2.2: new full speed USB device using ehci_hcd and address 5
usb 1-2.2: configuration #1 chosen from 1 choice
usb 1-2.3: new full speed USB device using ehci_hcd and address 6
usb 1-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
rtc_cmos: probe of 00:09 failed with error -16
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Bluetooth: Broadcom Blutonium firmware driver ver 1.1
usbcore: registered new interface driver bcm203x
Bluetooth: Digianswer Bluetooth USB driver ver 0.9
usbcore: registered new interface driver bpa10x
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-64 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x12
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x13
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x14
powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0x15
powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x1e
Starting balanced_irq
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x180b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 268k freed
ndiswrapper version 1.52 loaded (smp=yes, preempt=no)
uvcvideo: Found UVC 1.00 device HP Webcam (04f2:b015)
input: HP Webcam as /devices/pci0000:00/0000:00:0b.1/usb1/1-2/1-2.1/1-2.1:1.0/input/input6
usbcore: registered new interface driver uvcvideo
USB Video Class driver (SVN r209)
input: Wacom ISDv4 USB as /devices/pci0000:00/0000:00:0b.1/usb1/1-2/1-2.3/1-2.3:1.0/input/input7
input: Wacom ISDv4 USB as /devices/pci0000:00/0000:00:0b.1/usb1/1-2/1-2.3/1-2.3:1.1/input/input8
ndiswrapper: driver bcmwl5 (Broadcom,10/12/2006, 4.100.15.5) loaded
ACPI: PCI Interrupt Link [LK1E] enabled at IRQ 19
IOAPIC[0]: Set PCI routing entry (2-19 -> 0xd9 -> IRQ 19 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LK1E] -> GSI 19 (level, high) -> IRQ 19
PCI: Setting latency timer of device 0000:03:00.0 to 64
ndiswrapper: using IRQ 19
usbcore: registered new interface driver wacom
/home/andrew/wacgit/linux-wacom/src/2.6.24/wacom_sys.c: v1.46-pc0.2:USB Wacom Graphire and Wacom Intuos tablet driver
wlan0: ethernet device 00:1a:73:e7:3f:1b using NDIS driver: bcmwl5, version: 0x4640f05, NDIS version: 0x501, vendor: 'NDIS Network Adapter', 14E4:4328.5.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP with WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 17
IOAPIC[0]: Set PCI routing entry (2-17 -> 0xe1 -> IRQ 17 Mode:1 Active:0)
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 17 (level, high) -> IRQ 17
PCI: Setting latency timer of device 0000:00:10.1 to 64
Adding 971924k swap on /dev/sda4.  Priority:-1 extents:1 across:971924k
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda3, internal journal
dm_mod: no version for "struct_module" found: kernel tainted.
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
eth0: no link during initialization.
cdrom: This disc doesn't have any tracks I recognize!
pktcdvd: writer pktcdvd0 mapped to hda
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

--------------040004010509030800000700
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuinfo"

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 104
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-64
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch ts fid vid ttp tm stc 100mhzsteps
bogomips	: 1597.09
clflush size	: 64

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 104
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-64
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch ts fid vid ttp tm stc 100mhzsteps
bogomips	: 1595.78
clflush size	: 64


--------------040004010509030800000700
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24
# Sun Jul 20 18:13:39 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_SUPPORTS_OPROFILE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-bisect"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=y
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_B43_DMA_AND_PIO_MODE is not set
# CONFIG_B43_DMA_MODE is not set
# CONFIG_B43_PIO_MODE is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=800
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------040004010509030800000700
Content-Type: text/x-dsl;
 name="dsdt.dsl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dsdt.dsl"

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20061109
 *
 * Disassembly of dsdt, Thu Jul 24 18:49:15 2008
 *
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x0000916E (37230)
 *     Revision         0x01
 *     OEM ID           "HP    "
 *     OEM Table ID     "MCP51M"
 *     OEM Revision     0x06040000 (100925440)
 *     Creator ID       "MSFT"
 *     Creator Revision 0x03000000 (50331648)
 */
DefinitionBlock ("dsdt.aml", "DSDT", 1, "HP    ", "MCP51M", 0x06040000)
{
    External (\_PR_.CPU1._PPC)
    External (\_PR_.CPU0._PPC)

    Name (\_S0, Package (0x04)
    {
        0x00, 
        0x00, 
        0x00, 
        0x00
    })
    Name (\_S3, Package (0x04)
    {
        0x05, 
        0x05, 
        0x00, 
        0x00
    })
    Name (\_S4, Package (0x04)
    {
        0x06, 
        0x06, 
        0x00, 
        0x00
    })
    Name (\_S5, Package (0x04)
    {
        0x07, 
        0x07, 
        0x00, 
        0x00
    })
    Name (SX, 0x00)
    Method (\_PTS, 1, NotSerialized)
    {
        Store (0x01, RBRF)
        If (LGreater (Arg0, 0x01))
        {
            Store (Zero, LDTC)
            Store (0x04, Z000)
            Store (0x04, Z001)
            Store (0x04, Z002)
            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
            Store (0x02, \_SB.PCI0.SMIS)
            Store (0x83, \_SB.PCI0.SMIC)
            Sleep (0x05)
            Release (\_SB.PCI0.PSMX)
        }

        If (LEqual (Arg0, 0x03))
        {
            If (LEqual (ECON, 0x01))
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (KWCP, \_SB.PCI0.EC0.KBWK)
                Store (MWCP, \_SB.PCI0.EC0.MUWK)
                Release (\_SB.PCI0.EC0.MUT0)
            }
        }
        Else
        {
            If (LEqual (ECON, 0x01))
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (0x00, \_SB.PCI0.EC0.KBWK)
                Store (0x00, \_SB.PCI0.EC0.MUWK)
                Release (\_SB.PCI0.EC0.MUT0)
            }
        }

        Sleep (0x03E8)
    }

    Method (\_WAK, 1, NotSerialized)
    {
        If (LEqual (Arg0, 0x03))
        {
            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
            Store (0x84, \_SB.PCI0.SMIC)
            Store (\_SB.PCI0.SMIS, Local0)
            Sleep (0x05)
            Release (\_SB.PCI0.PSMX)
        }

        If (LEqual (Arg0, 0x04))
        {
            And (GP23, 0x07, GP26)
            If (LEqual (GP26, 0x05))
            {
                Store (0x01, GP26)
            }
            Else
            {
                Store (0x00, GP26)
            }

            And (GP24, 0x07, GP25)
            If (LEqual (GP25, 0x05))
            {
                Store (0x01, GP25)
            }
            Else
            {
                Store (0x00, GP25)
            }

            Store (Zero, S4FL)
            Store (Zero, S4RT)
            Notify (\_SB.PWRB, 0x02)
            Store (0x73, \_SB.PCI0.SMIC)
            Sleep (0x05)
        }

        If (LOr (LEqual (Arg0, 0x03), LEqual (Arg0, 0x04)))
        {
            Z003 ()
            Z004 ()
        }

        Return (Package (0x02)
        {
            0x00, 
            0x00
        })
    }

    Method (Z004, 0, NotSerialized)
    {
        Store (HOTB, Local0)
        If (LEqual (Local0, 0x04))
        {
            Notify (\_SB.QBTN, 0x02)
        }

        If (LEqual (Local0, 0x05))
        {
            Notify (\_SB.DBTN, 0x02)
        }

        If (LEqual (Local0, 0x03))
        {
            Notify (\_SB.MUBN, 0x02)
        }

        If (LEqual (Local0, 0x06))
        {
            Notify (\_SB.PIBN, 0x02)
        }

        If (LEqual (Local0, 0x10))
        {
            Notify (\_SB.WEBN, 0x02)
        }

        If (LEqual (Local0, 0x11))
        {
            Notify (\_SB.LVBN, 0x02)
        }

        If (LEqual (Local0, 0x12))
        {
            Notify (\_SB.LVBN, 0x02)
        }

        Store (0x00, HOTB)
    }

    Method (Z005, 0, NotSerialized)
    {
        \_SB.PCI0.PHSR (0x8F, 0x02)
        Store (0x00, Local0)
        Or (Local0, LEqual (\_SB.DUAL, 0x01), Local0)
        Or (Local0, LEqual (\_SB.CPUT, 0x0587), Local0)
        Or (Local0, LEqual (\_SB.CPUT, 0x0589), Local0)
        If (LNotEqual (Local0, 0x00))
        {
            \_SB.PCI0.PHSR (0x8A, 0x01)
        }
        Else
        {
            \_SB.PCI0.PHSR (0x8A, 0x00)
        }
    }

    Method (Z003, 0, NotSerialized)
    {
        Store (0x00, \_PR.CPU0._PPC)
        If (LEqual (\_SB.DUAL, 0x01))
        {
            Store (0x00, \_PR.CPU1._PPC)
        }

        Store (0x00, PST0)
        Store (0x00, THR0)
        Store (0x01, PST1)
        Store (0x01, THR1)
        Store (0x00, Q8C0)
        Store (0x00, Q8E0)
        Store (0x01, Q8C1)
        Store (0x01, Q8E1)
        Store (0x00, NOWP)
        Store (0x01, \_SB.PCI0.EC0.DTMC)
        Notify (\_SB.BAT0, 0x81)
    }

    Scope (\_PR)
    {
        Processor (CPU0, 0x00, 0x00001010, 0x06) {}
        Processor (CPU1, 0x01, 0x00001010, 0x06) {}
    }

    Scope (\_SI)
    {
        Method (_SST, 1, NotSerialized)
        {
            Store ("==== SST Working ====", Debug)
        }

        Method (_MSG, 1, NotSerialized)
        {
        }
    }

    Scope (\_GPE)
    {
        Method (_L14, 0, NotSerialized)
        {
            If (PEWS)
            {
                Store (0x01, PEWS)
            }

            Store (0x01, \_SB.PCI0.XVR2.BS19)
            Sleep (0xFA)
            Notify (\_SB.PCI0.XVR2.X2S0, 0x01)
        }

        Method (_L0B, 0, NotSerialized)
        {
            Notify (\_SB.PWRB, 0x02)
        }

        Method (_L0D, 0, NotSerialized)
        {
            Notify (\_SB.PWRB, 0x02)
        }

        Method (_L05, 0, NotSerialized)
        {
            Notify (\_SB.PWRB, 0x02)
        }
    }

    Scope (\_SB)
    {
        Device (MCFG)
        {
            Name (_HID, EisaId ("PNP0C02"))
            Name (_CRS, ResourceTemplate ()
            {
                DWordMemory (ResourceConsumer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0xE0000000,         // Range Minimum
                    0xEFFFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x10000000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
            })
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }
        }

        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
        }

        Device (ACAD)
        {
            Name (_HID, "ACPI0003")
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Method (_PSR, 0, NotSerialized)
            {
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.ACIN, Local0)
                    Release (\_SB.PCI0.EC0.MUT0)
                    If (Local0)
                    {
                        Return (0x01)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }
                Else
                {
                    Return (\_SB.ACST)
                }
            }
        }

        Method (VTOB, 1, NotSerialized)
        {
            Store (0x01, Local0)
            ShiftLeft (Local0, Arg0, Local0)
            Return (Local0)
        }

        Method (BTOV, 1, NotSerialized)
        {
            ShiftRight (Arg0, 0x01, Local0)
            Store (0x00, Local1)
            While (Local0)
            {
                Increment (Local1)
                ShiftRight (Local0, 0x01, Local0)
            }

            Return (Local1)
        }

        Method (MKWD, 2, NotSerialized)
        {
            If (And (Arg1, 0x80))
            {
                Store (0xFFFF0000, Local0)
            }
            Else
            {
                Store (Zero, Local0)
            }

            Or (Local0, Arg0, Local0)
            Or (Local0, ShiftLeft (Arg1, 0x08), Local0)
            Return (Local0)
        }

        Method (POSW, 1, NotSerialized)
        {
            If (And (Arg0, 0x8000))
            {
                If (LEqual (Arg0, 0xFFFF))
                {
                    Return (0xFFFFFFFF)
                }
                Else
                {
                    Not (Arg0, Local0)
                    Increment (Local0)
                    And (Local0, 0xFFFF, Local0)
                    Return (Local0)
                }
            }
            Else
            {
                Return (Arg0)
            }
        }

        Method (GBFE, 3, NotSerialized)
        {
            CreateByteField (Arg0, Arg1, TIDX)
            Store (TIDX, Arg2)
        }

        Method (PBFE, 3, NotSerialized)
        {
            CreateByteField (Arg0, Arg1, TIDX)
            Store (Arg2, TIDX)
        }

        Method (ITOS, 1, NotSerialized)
        {
            Store (Buffer (0x05)
                {
                    0x20, 0x20, 0x20, 0x20, 0x20
                }, Local0)
            Store (Buffer (0x11)
                {
                    "0123456789ABCDEF"
                }, Local7)
            Store (0x05, Local1)
            Store (0x00, Local2)
            Store (0x00, Local3)
            While (Local1)
            {
                Decrement (Local1)
                And (ShiftRight (Arg0, ShiftLeft (Local1, 0x02)), 0x0F, Local4)
                GBFE (Local7, Local4, RefOf (Local5))
                PBFE (Local0, Local2, Local5)
                Increment (Local2)
            }

            Return (Local0)
        }

        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Name (PBIF, Package (0x0D)
            {
                0x01, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0x01, 
                0xFFFFFFFF, 
                0xFA, 
                0x96, 
                0x0A, 
                0x19, 
                "BAT1", 
                " ", 
                " ", 
                " "
            })
            Name (PBST, Package (0x04)
            {
                0x00, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0x2710
            })
            Name (BAST, 0x00)
            Name (B1ST, 0x0F)
            Name (B1WT, 0x00)
            Method (_STA, 0, NotSerialized)
            {
                Sleep (0x19)
                If (ECON)
                {
                    If (\_SB.PCI0.EC0.MBTS)
                    {
                        Store (0x1F, B1ST)
                    }
                    Else
                    {
                        Store (0x0F, B1ST)
                    }
                }
                Else
                {
                    Store (0x0F, B1ST)
                }

                Return (B1ST)
            }

            Method (_BIF, 0, NotSerialized)
            {
                Sleep (0x19)
                If (LEqual (B1ST, 0x1F))
                {
                    UPBI ()
                }
                Else
                {
                    IVBI ()
                }

                Return (PBIF)
            }

            Method (_BST, 0, NotSerialized)
            {
                Sleep (0x19)
                If (LEqual (B1ST, 0x1F))
                {
                    UPBS ()
                }
                Else
                {
                    IVBS ()
                }

                Return (PBST)
            }

            Method (UPBI, 0, NotSerialized)
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x10, RefOf (Local5))))
                {
                    If (LAnd (Local5, LNot (And (Local5, 0x8000))))
                    {
                        ShiftRight (Local5, 0x05, Local5)
                        ShiftLeft (Local5, 0x05, Local5)
                        Store (Local5, Index (PBIF, 0x02))
                        Divide (Local5, 0x64, , Local2)
                        Add (Local2, 0x01, Local2)
                        Multiply (Local2, 0x05, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x05))
                        Multiply (Local2, 0x03, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x06))
                    }
                }

                Store (\_SB.PCI0.EC0.DDCP, Index (PBIF, 0x01))
                Store (\_SB.PCI0.EC0.DDVO, Index (PBIF, 0x04))
                Store ("Primary", Index (PBIF, 0x09))
                Store ("LION", Index (PBIF, 0x0B))
                Store ("Hewlett-Packard", Index (PBIF, 0x0C))
                Store (0x01, Index (PBIF, 0x00))
                Sleep (0xFA)
                Release (\_SB.PCI0.EC0.MUT0)
            }

            Method (UPUM, 0, NotSerialized)
            {
                Store (Buffer (0x0B)
                    {
                        /* 0000 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 
                        /* 0008 */    0x00, 0x00, 0x00
                    }, Local0)
                Store (Buffer (0x05)
                    {
                        0x36, 0x35, 0x35, 0x33, 0x35
                    }, Local6)
                Store (Buffer (0x05)
                    {
                        0x31, 0x32, 0x33, 0x32, 0x31
                    }, Local7)
                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1B, RefOf (Local5))))
                {
                    Divide (Local5, 0x0200, , Local1)
                    Subtract (Local5, Multiply (Local1, 0x0200, Local2), Local5)
                    Multiply (Subtract (Local1, 0x0A, Local1), 0x03E8, Local1)
                    Divide (Local5, 0x20, , Local2)
                    Subtract (Local5, Multiply (Local2, 0x20, Local3), Local3)
                    Add (Multiply (Decrement (Local2), 0x1E, Local5), Local3, Local5)
                    Add (Local1, Local5, Local5)
                    Store (ITOS (ToBCD (Local5)), Local7)
                }

                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1C, RefOf (Local5))))
                {
                    Store (ITOS (ToBCD (Local5)), Local6)
                }

                Store (0x05, Local1)
                Store (0x00, Local2)
                Store (0x00, Local3)
                While (Local1)
                {
                    Decrement (Local1)
                    GBFE (Local6, Local2, RefOf (Local5))
                    PBFE (Local0, Local3, Local5)
                    Increment (Local2)
                    Increment (Local3)
                }

                Increment (Local3)
                Store (0x00, Local2)
                Store (0x05, Local1)
                While (Local1)
                {
                    Decrement (Local1)
                    GBFE (Local7, Local2, RefOf (Local5))
                    PBFE (Local0, Local3, Local5)
                    Increment (Local2)
                    Increment (Local3)
                }

                Store (Local0, Index (PBIF, 0x0A))
                Store ("Hewlett-Packard", Index (PBIF, 0x0C))
            }

            Method (UPBS, 0, NotSerialized)
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (\_SB.PCI0.EC0.MBRM, Local5)
                If (LNot (And (Local5, 0x8000)))
                {
                    ShiftRight (Local5, 0x05, Local5)
                    ShiftLeft (Local5, 0x05, Local5)
                    If (LNotEqual (Local5, DerefOf (Index (PBST, 0x02))))
                    {
                        Store (Local5, Index (PBST, 0x02))
                    }
                }

                Store (\_SB.PCI0.EC0.MBCV, Index (PBST, 0x03))
                Sleep (0xFA)
                Store (\_SB.PCI0.EC0.MBST, Local0)
                Release (\_SB.PCI0.EC0.MUT0)
                Store (Local0, Index (PBST, 0x00))
            }

            Method (IVBI, 0, NotSerialized)
            {
                Store (0xFFFFFFFF, Index (PBIF, 0x01))
                Store (0xFFFFFFFF, Index (PBIF, 0x02))
                Store (0xFFFFFFFF, Index (PBIF, 0x04))
                Store ("Bad", Index (PBIF, 0x09))
                Store ("      ", Index (PBIF, 0x0A))
                Store ("Bad", Index (PBIF, 0x0B))
                Store ("Bad", Index (PBIF, 0x0C))
            }

            Method (IVBS, 0, NotSerialized)
            {
                Store (0x00, Index (PBST, 0x00))
                Store (0xFFFFFFFF, Index (PBST, 0x01))
                Store (0xFFFFFFFF, Index (PBST, 0x02))
                Store (0x2710, Index (PBST, 0x03))
            }
        }

        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Method (_LID, 0, NotSerialized)
            {
                If (And (GP17, 0x20))
                {
                    Store (0x65, Z006)
                    Return (0x01)
                }
                Else
                {
                    Store (0x44, Z006)
                    Return (0x00)
                }
            }
        }

        Device (MEM0)
        {
            Name (_HID, EisaId ("PNP0C01"))
            Method (_CRS, 0, Serialized)
            {
                Name (MEMR, ResourceTemplate ()
                {
                    Memory32Fixed (ReadOnly,
                        0xFFC00000,         // Address Base
                        0x00400000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFEC00000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFEE00000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x00000000,         // Address Base
                        0x00000000,         // Address Length
                        _Y00)
                })
                CreateDWordField (MEMR, \_SB.MEM0._CRS._Y00._BAS, MBAS)
                CreateDWordField (MEMR, \_SB.MEM0._CRS._Y00._LEN, MBLE)
                If (\_SB.PCI0.LPC0.MTBA)
                {
                    Store (\_SB.PCI0.LPC0.MTBA, MBAS)
                    Store (0x1000, MBLE)
                }

                Return (MEMR)
            }
        }

        Device (BBDD)
        {
            Name (_HID, "HPQ0007")
            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }
        }

        Device (WMID)
        {
            Name (Z007, Package (0x13)
            {
                0x04, 
                0x04, 
                0x04, 
                0x00, 
                0x04, 
                0x04, 
                0x00, 
                0x00, 
                0x04, 
                0x04, 
                0x0C, 
                0x00, 
                0x00, 
                0x00, 
                0x00, 
                0x05, 
                0x00, 
                0x00, 
                0x04
            })
            Name (Z008, Buffer (0x05) {})
            Name (Z009, 0x00)
            Name (Z00A, 0x00)
            Name (Z00B, 0x00)
            Name (Z00C, 0x00)
            Name (Z00D, 0x00)
            Method (Z00E, 2, NotSerialized)
            {
                CreateDWordField (Arg1, 0x00, Z00F)
                CreateDWordField (Arg1, 0x04, Z00G)
                CreateDWordField (Arg1, 0x08, Z00H)
                CreateDWordField (Arg1, 0x0C, Z00I)
                If (LEqual (Arg0, 0x01))
                {
                    Store (0x00, Local0)
                }

                If (LEqual (Arg0, 0x02))
                {
                    Store (0x04, Local0)
                }

                If (LEqual (Arg0, 0x03))
                {
                    Store (0x80, Local0)
                }

                If (LEqual (Arg0, 0x04))
                {
                    Store (0x0400, Local0)
                }

                If (LEqual (Arg0, 0x05))
                {
                    Store (0x1000, Local0)
                }

                Store (Buffer (Add (0x08, Local0)) {}, Local1)
                CreateDWordField (Local1, 0x00, Z00J)
                CreateDWordField (Local1, 0x04, Z00K)
                Store (0x4C494146, Z00J)
                Store (0x02, Z00K)
                If (LEqual (Z00F, 0x55434553))
                {
                    Store (0x03, Z00K)
                    If (LEqual (Z00G, 0x01))
                    {
                        Store (0x04, Z00K)
                        If (LEqual (Z00H, 0x05))
                        {
                            Store (^Z00L (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x0E))
                        {
                            Store (^Z00M (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x10))
                        {
                            Store (^Z00N (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x07))
                        {
                            If (Z00I)
                            {
                                Store (DerefOf (Index (Arg1, 0x10)), Local3)
                                Store (^Z00O (Local3), Local2)
                                Store (0x00, Z00K)
                            }
                            Else
                            {
                                Store (0x05, Z00K)
                            }
                        }

                        If (LEqual (Z00H, 0x01))
                        {
                            Store (^Z00P (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x08))
                        {
                            Store (^Z00Q (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x09))
                        {
                            Store (^Z00R (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x0A))
                        {
                            Store (^Z00S (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x0C))
                        {
                            Store (^Z00T (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x04))
                        {
                            Store (^Z00U (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x0B))
                        {
                            Store (^Z00V (), Local2)
                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x13))
                        {
                            Store (^Z00W (), Local2)
                            Store (0x00, Z00K)
                        }
                    }

                    If (LEqual (Z00G, 0x02))
                    {
                        Store (0x04, Z00K)
                        If (LAnd (LGreater (Z00H, 0x00), LLessEqual (Z00H, 0x13)))
                        {
                            If (LLess (Z00I, DerefOf (Index (Z007, Subtract (Z00H, 0x01)
                                ))))
                            {
                                Store (0x05, Z00K)
                            }
                            Else
                            {
                                CreateDWordField (Arg1, 0x10, Z00X)
                                If (LEqual (Z00I, 0x05))
                                {
                                    CreateByteField (Arg1, 0x10, Z009)
                                    CreateByteField (Arg1, 0x11, Z00A)
                                    CreateByteField (Arg1, 0x12, Z00B)
                                    CreateByteField (Arg1, 0x13, Z00C)
                                    CreateByteField (Arg1, 0x14, Z00D)
                                    Store (Z009, Index (Z008, 0x00))
                                    Store (Z00A, Index (Z008, 0x01))
                                    Store (Z00B, Index (Z008, 0x02))
                                    Store (Z00C, Index (Z008, 0x03))
                                    Store (Z00D, Index (Z008, 0x04))
                                }

                                If (LEqual (Z00H, 0x05))
                                {
                                    Store (^Z00Y (Z00X), Local2)
                                    Store (0x00, Z00K)
                                }

                                If (LEqual (Z00H, 0x10))
                                {
                                    If (LNotEqual (Z00I, DerefOf (Index (Z007, Subtract (Z00H, 0x01
                                        )))))
                                    {
                                        Store (0x05, Z00K)
                                    }
                                    Else
                                    {
                                        Store (^Z00Z (Z008), Local2)
                                        Store (0x00, Z00K)
                                    }
                                }

                                If (LEqual (Z00H, 0x01))
                                {
                                    Store (^Z010 (Z00X), Local2)
                                    Store (0x00, Z00K)
                                }

                                If (LEqual (Z00H, 0x09))
                                {
                                    Store (^Z011 (Z00X), Local2)
                                    Store (0x00, Z00K)
                                }

                                If (LEqual (Z00H, 0x0A))
                                {
                                    Store (^Z012 (Z00X), Local2)
                                    Store (0x00, Z00K)
                                }

                                If (LEqual (Z00H, 0x0B))
                                {
                                    CreateDWordField (Arg1, 0x14, Z013)
                                    CreateDWordField (Arg1, 0x18, Z014)
                                    Store (^Z015 (Z00X, Z013, Z014), Local2)
                                    Store (0x00, Z00K)
                                }

                                If (LEqual (Z00H, 0x13))
                                {
                                    Store (^Z016 (Z00X), Local2)
                                    Store (0x00, Z00K)
                                }
                            }
                        }
                    }

                    If (LEqual (Z00G, 0x00020002))
                    {
                        Acquire (\_SB.WMID.CTMX, 0xFFFF)
                        Store (0x04, Z00K)
                        If (LEqual (Z00H, 0x01))
                        {
                            If (^Z017 ())
                            {
                                Store (Package (0x03)
                                    {
                                        0x00, 
                                        0x04, 
                                        Buffer (0x04)
                                        {
                                            0x01, 0x00, 0x00, 0x00
                                        }
                                    }, Local2)
                            }
                            Else
                            {
                                Store (Package (0x03)
                                    {
                                        0x00, 
                                        0x04, 
                                        Buffer (0x04)
                                        {
                                            0x00, 0x00, 0x00, 0x00
                                        }
                                    }, Local2)
                            }

                            Store (0x00, Z00K)
                        }

                        If (LEqual (Z00H, 0x02))
                        {
                            Store (Package (0x02)
                                {
                                    0x00, 
                                    0x00
                                }, Local2)
                            CreateDWordField (Arg1, 0x10, Z018)
                            Store (^Z019 (Z018), Z00K)
                        }

                        If (LEqual (Z00H, 0x03))
                        {
                            Store (Package (0x02)
                                {
                                    0x00, 
                                    0x00
                                }, Local2)
                            CreateDWordField (Arg1, 0x10, Z01A)
                            Store (^Z01B (Z01A), Z00K)
                        }

                        Release (\_SB.WMID.CTMX)
                    }
                }

                If (LEqual (Z00K, 0x00))
                {
                    Store (DerefOf (Index (Local2, 0x00)), Z00K)
                    If (LEqual (Z00K, 0x00))
                    {
                        If (LLessEqual (DerefOf (Index (Local2, 0x01)), Local0))
                        {
                            Store (0x00, Local0)
                            While (LLess (Local0, DerefOf (Index (Local2, 0x01))))
                            {
                                Store (DerefOf (Index (DerefOf (Index (Local2, 0x02)), Local0)), 
                                    Index (Local1, Add (Local0, 0x08)))
                                Increment (Local0)
                            }

                            Store (0x53534150, Z00J)
                        }
                        Else
                        {
                            Store (0x05, Z00K)
                        }
                    }
                }

                Return (Local1)
            }

            Name (_HID, "PNP0C14")
            Name (_UID, 0x00)
            Name (TBLM, 0x00)
            Name (Z01C, 0x00)
            Name (Z01D, 0x00)
            Name (BUFF, Buffer (0x05)
            {
                0x00, 0x00, 0x00, 0x00, 0x00
            })
            CreateByteField (BUFF, 0x00, OB0)
            CreateByteField (BUFF, 0x01, OB1)
            CreateByteField (BUFF, 0x02, OB2)
            CreateByteField (BUFF, 0x03, OB3)
            CreateByteField (BUFF, 0x04, OB4)
            Name (_WDG, Buffer (0x50)
            {
                /* 0000 */    0x34, 0xF0, 0xB7, 0x5F, 0x63, 0x2C, 0xE9, 0x45, 
                /* 0008 */    0xBE, 0x91, 0x3D, 0x44, 0xE2, 0xC7, 0x07, 0xE4, 
                /* 0010 */    0x41, 0x44, 0x01, 0x02, 0x79, 0x42, 0xF2, 0x95, 
                /* 0018 */    0x7B, 0x4D, 0x34, 0x43, 0x93, 0x87, 0xAC, 0xCD, 
                /* 0020 */    0xC6, 0x7E, 0xF6, 0x1C, 0x80, 0x00, 0x01, 0x08, 
                /* 0028 */    0x21, 0x12, 0x90, 0x05, 0x66, 0xD5, 0xD1, 0x11, 
                /* 0030 */    0xB2, 0xF0, 0x00, 0xA0, 0xC9, 0x06, 0x29, 0x10, 
                /* 0038 */    0x41, 0x45, 0x01, 0x00, 0xD4, 0x2B, 0x99, 0xD0, 
                /* 0040 */    0x7C, 0xA4, 0xFE, 0x4E, 0xB0, 0x72, 0x32, 0x4A, 
                /* 0048 */    0xEC, 0x92, 0x29, 0x6C, 0x42, 0x43, 0x01, 0x00
            })
            Method (WQBC, 1, NotSerialized)
            {
                Store ("HP WMI WQBC)", Debug)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x88, \_SB.PCI0.SMIC)
                Store (\_SB.PCI0.SMIS, Local0)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                Store (Local0, CADL)
                If (LNot (And (GP17, 0x20)))
                {
                    And (Local0, 0xFE, Local0)
                }

                Return (Local0)
            }

            Method (WMAD, 3, NotSerialized)
            {
                Return (Z00E (Arg1, Arg2))
            }

            Method (Z00U, 0, NotSerialized)
            {
                Store (Package (0x03)
                    {
                        0x00, 
                        0x01, 
                        Buffer (0x01)
                        {
                            0x00
                        }
                    }, Local0)
                Store (0x90, TBLM)
                If (LEqual (\_SB.PCI0.EC0.TLID, 0x01))
                {
                    Store (Package (0x03)
                        {
                            0x00, 
                            0x01, 
                            Buffer (0x01)
                            {
                                0x04
                            }
                        }, Local0)
                    Store (0x91, TBLM)
                }

                Return (Local0)
            }

            Method (Z00L, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x5 (BIOS Read)", Debug)
                Store (0x01, WIRE)
                And (WC01, 0x07, Local0)
                Or (Local0, 0x60, OB0)
                ShiftRight (And (WC01, 0x40), 0x06, Local0)
                ShiftLeft (Local0, 0x01, Local0)
                ShiftRight (And (WC01, 0x10), 0x04, Local1)
                ShiftLeft (Local1, 0x01, Local1)
                ShiftRight (And (WC01, 0x20), 0x05, Local2)
                ShiftLeft (Local2, 0x01, Local2)
                And (WC01, 0x08, Local3)
                Or (Local0, Local3, Local0)
                Or (Local1, Local3, Local1)
                Or (Local2, Local3, Local2)
                And (GP24, 0x07, GP25)
                If (LEqual (GP25, 0x05))
                {
                    Store (0x01, GP25)
                }
                Else
                {
                    Store (0x00, GP25)
                }

                And (GP23, 0x07, GP26)
                If (LEqual (GP26, 0x05))
                {
                    Store (0x01, GP26)
                }
                Else
                {
                    Store (0x00, GP26)
                }

                And (PCQ3, 0x07, WWAN)
                If (LEqual (WWAN, 0x05))
                {
                    Store (0x01, WWAN)
                }
                Else
                {
                    Store (0x00, WWAN)
                }

                If (GP26)
                {
                    If (LNot (And (WC01, 0x10)))
                    {
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                    }

                    If (LNot (And (WC01, 0x08)))
                    {
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                    }
                }

                If (GP25)
                {
                    If (LNot (And (WC01, 0x20)))
                    {
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                    }

                    If (LNot (And (WC01, 0x08)))
                    {
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                    }
                }

                If (WWAN)
                {
                    If (LNot (And (WC01, 0x40)))
                    {
                        Store (0x00, WWAN)
                        Store (0x04, PCQ3)
                    }

                    If (LNot (And (WC01, 0x08)))
                    {
                        Store (0x00, WWAN)
                        Store (0x04, PCQ3)
                    }
                }

                Or (WWAN, Local0, Local0)
                Or (GP26, Local1, Local1)
                Or (GP25, Local2, Local2)
                Store (0x00, OB3)
                Store (0x00, OB2)
                Store (0x00, OB1)
                If (WLSU)
                {
                    Or (Local1, 0x04, Local1)
                }

                If (BTSU)
                {
                    Or (Local2, 0x04, Local2)
                }

                Or (Local0, 0x04, Local0)
                If (GP26)
                {
                    Or (Local1, 0x10, Local1)
                }
                Else
                {
                    And (Local1, 0xEF, Local1)
                }

                If (And (WC01, 0x01))
                {
                    Store (Local1, OB1)
                }

                If (And (WC01, 0x02))
                {
                    Store (Local2, OB2)
                }

                If (And (WC01, 0x04))
                {
                    Store (Local0, OB3)
                }

                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04)
                        {
                            0x01, 0x02, 0x03, 0x04
                        }
                    }, Local0)
                Store (OB0, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (OB1, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                Store (OB2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                Store (OB3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Return (Local0)
            }

            Method (Z00Y, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x5 (BIOS Write)", Debug)
                And (GP24, 0x07, GP25)
                If (LEqual (GP25, 0x05))
                {
                    Store (0x01, GP25)
                }
                Else
                {
                    Store (0x00, GP25)
                }

                And (GP23, 0x07, GP26)
                If (LEqual (GP26, 0x05))
                {
                    Store (0x01, GP26)
                }
                Else
                {
                    Store (0x00, GP26)
                }

                And (PCQ3, 0x07, WWAN)
                If (LEqual (WWAN, 0x05))
                {
                    Store (0x01, WWAN)
                }
                Else
                {
                    Store (0x00, WWAN)
                }

                If (And (WC01, 0x07))
                {
                    If (And (Arg0, 0x0800))
                    {
                        If (And (Arg0, 0x08))
                        {
                            Or (WC01, 0x10, WC01)
                            Or (WC01, 0x20, WC01)
                            Or (WC01, 0x40, WC01)
                            If (WLSU)
                            {
                                If (And (WC01, 0x08))
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                                Else
                                {
                                    Store (0x00, GP26)
                                    Store (0x04, GP23)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP26)
                                Store (0x04, GP23)
                            }

                            If (BTSU)
                            {
                                If (And (WC01, 0x08))
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                                Else
                                {
                                    Store (0x00, GP25)
                                    Store (0x04, GP24)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP25)
                                Store (0x04, GP24)
                            }

                            If (And (WC01, 0x08))
                            {
                                Store (0x01, WWAN)
                                Store (0x05, PCQ3)
                            }
                            Else
                            {
                                Store (0x00, WWAN)
                                Store (0x04, PCQ3)
                            }
                        }
                        Else
                        {
                            And (WC01, 0xEF, WC01)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                            And (WC01, 0xDF, WC01)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                            And (WC01, 0xBF, WC01)
                            Store (0x00, WWAN)
                            Store (0x04, PCQ3)
                        }
                    }

                    If (And (Arg0, 0x0100))
                    {
                        If (And (Arg0, 0x01))
                        {
                            Or (WC01, 0x10, WC01)
                            If (WLSU)
                            {
                                If (And (WC01, 0x08))
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                                Else
                                {
                                    Store (0x00, GP26)
                                    Store (0x04, GP23)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP26)
                                Store (0x04, GP23)
                            }
                        }
                        Else
                        {
                            And (WC01, 0xEF, WC01)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                        }
                    }

                    If (And (Arg0, 0x0200))
                    {
                        If (And (Arg0, 0x02))
                        {
                            Or (WC01, 0x20, WC01)
                            If (BTSU)
                            {
                                If (And (WC01, 0x08))
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                                Else
                                {
                                    Store (0x00, GP25)
                                    Store (0x04, GP24)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP25)
                                Store (0x04, GP24)
                            }
                        }
                        Else
                        {
                            And (WC01, 0xDF, WC01)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                        }
                    }

                    If (And (Arg0, 0x0400))
                    {
                        If (And (Arg0, 0x04))
                        {
                            Or (WC01, 0x40, WC01)
                            If (And (WC01, 0x08))
                            {
                                Store (0x01, WWAN)
                                Store (0x05, PCQ3)
                            }
                            Else
                            {
                                Store (0x01, WWAN)
                                Store (0x04, PCQ3)
                            }
                        }
                        Else
                        {
                            And (WC01, 0xBF, WC01)
                            Store (0x00, WWAN)
                            Store (0x04, PCQ3)
                        }
                    }

                    Store (0x05, \_SB.WMID.Z01C)
                    Store (0x00, \_SB.WMID.Z01D)
                    Notify (\_SB.WMID, 0x80)
                    Return (Package (0x02)
                    {
                        0x00, 
                        0x00
                    })
                }
                Else
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x00
                    })
                }
            }

            Method (Z00N, 0, NotSerialized)
            {
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x80, \_SB.PCI0.SMIC)
                Store (\_SB.PCI0.SMIS, Local1)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                Sleep (0x01F4)
                Store (\_SB.SID0, OB0)
                Store (\_SB.SID1, OB1)
                Store (\_SB.SID2, OB2)
                Store (\_SB.SID3, OB3)
                Store (\_SB.SID4, OB4)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x05, 
                        Buffer (0x05)
                        {
                            0x01, 0x02, 0x03, 0x04, 0x05
                        }
                    }, Local0)
                Store (OB0, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (OB1, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                Store (OB2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                Store (OB3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Store (OB4, Index (DerefOf (Index (Local0, 0x02)), 0x04))
                Return (Local0)
            }

            Method (Z00Z, 1, NotSerialized)
            {
                Store (DerefOf (Index (Arg0, 0x00)), \_SB.SID0)
                Store (DerefOf (Index (Arg0, 0x01)), \_SB.SID1)
                Store (DerefOf (Index (Arg0, 0x02)), \_SB.SID2)
                Store (DerefOf (Index (Arg0, 0x03)), \_SB.SID3)
                Store (DerefOf (Index (Arg0, 0x04)), \_SB.SID4)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x81, \_SB.PCI0.SMIC)
                Store (\_SB.PCI0.SMIS, Local1)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                Sleep (0x01F4)
                Return (Package (0x02)
                {
                    0x00, 
                    0x00
                })
            }

            Method (Z00M, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xE (BIOS Read)", Debug)
                Store (0x00, Local0)
                Store (0x02, \_SB.EAX0)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x00, \_SB.PCI0.SMIS)
                Store (0x89, \_SB.PCI0.SMIC)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                If (LNotEqual (\_SB.EAX0, 0xFFFFFFFF))
                {
                    Store (Buffer (0x06)
                        {
                            0x02, 0x02, 0x00, 0x00, 0x00, 0x00
                        }, Local1)
                    Store (And (\_SB.EAX0, 0xFF), Index (Local1, 0x02))
                    Store (And (ShiftRight (\_SB.EAX0, 0x08), 0xFF), Index (Local1, 
                        0x03))
                    Store (And (ShiftRight (\_SB.EAX0, 0x10), 0xFF), Index (Local1, 
                        0x04))
                    Store (And (ShiftRight (\_SB.EAX0, 0x18), 0xFF), Index (Local1, 
                        0x05))
                    Add (Local0, 0x06, Local0)
                }

                Store (0x03, \_SB.EAX0)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x00, \_SB.PCI0.SMIS)
                Store (0x89, \_SB.PCI0.SMIC)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                If (LNotEqual (\_SB.EAX0, 0xFFFFFFFF))
                {
                    Store (Buffer (0x06)
                        {
                            0x02, 0x03, 0x00, 0x00, 0x00, 0x00
                        }, Local2)
                    Store (And (\_SB.EAX0, 0xFF), Index (Local2, 0x02))
                    Store (And (ShiftRight (\_SB.EAX0, 0x08), 0xFF), Index (Local2, 
                        0x03))
                    Store (And (ShiftRight (\_SB.EAX0, 0x10), 0xFF), Index (Local2, 
                        0x04))
                    Store (And (ShiftRight (\_SB.EAX0, 0x18), 0xFF), Index (Local2, 
                        0x05))
                    If (LEqual (Local0, 0x00))
                    {
                        Store (Local2, Local1)
                    }
                    Else
                    {
                        Concatenate (Local1, Local2, Local3)
                        Store (Local3, Local1)
                    }

                    Add (Local0, 0x06, Local0)
                }

                Store (0x01, \_SB.EAX0)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x00, \_SB.PCI0.SMIS)
                Store (0x89, \_SB.PCI0.SMIC)
                Sleep (0x05)
                Release (\_SB.PCI0.PSMX)
                If (LNotEqual (\_SB.EAX0, 0xFFFFFFFF))
                {
                    Store (Buffer (0x0A)
                        {
                            /* 0000 */    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
                            /* 0008 */    0x00, 0x00
                        }, Local2)
                    Store (And (\_SB.EAX0, 0xFF), Index (Local2, 0x02))
                    Store (And (ShiftRight (\_SB.EAX0, 0x08), 0xFF), Index (Local2, 
                        0x03))
                    Store (And (ShiftRight (\_SB.EAX0, 0x10), 0xFF), Index (Local2, 
                        0x04))
                    Store (And (ShiftRight (\_SB.EAX0, 0x18), 0xFF), Index (Local2, 
                        0x05))
                    Store (And (\_SB.EBX0, 0xFF), Index (Local2, 0x06))
                    Store (And (ShiftRight (\_SB.EBX0, 0x08), 0xFF), Index (Local2, 
                        0x07))
                    Store (And (ShiftRight (\_SB.EBX0, 0x10), 0xFF), Index (Local2, 
                        0x08))
                    Store (And (ShiftRight (\_SB.EBX0, 0x18), 0xFF), Index (Local2, 
                        0x09))
                    If (LEqual (Local0, 0x00))
                    {
                        Store (Local2, Local1)
                    }
                    Else
                    {
                        Concatenate (Local1, Local2, Local3)
                        Store (Local3, Local1)
                    }

                    Add (Local0, 0x0A, Local0)
                }

                Store (Package (0x03) {}, Local2)
                Store (0x00, Index (Local2, 0x00))
                Store (Local0, Index (Local2, 0x01))
                Store (Local1, Index (Local2, 0x02))
                Return (Local2)
            }

            Method (Z00O, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x7 (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                If (LNot (ECON))
                {
                    Store (Package (0x02)
                        {
                            0x0D, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                If (Arg0)
                {
                    Store (Package (0x02)
                        {
                            0x06, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                If (LNot (\_SB.PCI0.EC0.MBTS))
                {
                    Store (Package (0x02)
                        {
                            0x06, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                Release (\_SB.PCI0.EC0.MUT0)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x80, 
                        Buffer (0x80) {}
                    }, Local0)
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x18, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x01))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x10, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x03))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x05))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x04))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x07))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x06))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x17, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x09))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x08))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x08, RefOf (Local1))
                Subtract (Local1, 0x0AAA, Local1)
                Divide (Local1, 0x0A, Local2, Local1)
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0A))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x09, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0D))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0C))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0A, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0F))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0E))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x19, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x11))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x10))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x16, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x13))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x12))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x15))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x14))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3E, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x17))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x16))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3D, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x19))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x18))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x1B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x1A))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1C, RefOf (Local1))
                Store (ITOS (ToBCD (Local1)), Local3)
                Store (0x1C, Local2)
                Store (0x00, Local4)
                Store (SizeOf (Local3), Local1)
                While (Local1)
                {
                    GBFE (Local3, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local4)
                }

                Store (0x20, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1B, RefOf (Local1))
                And (Local1, 0x1F, Local7)
                Store (ITOS (ToBCD (Local7)), Local6)
                And (Local1, 0x01E0, Local7)
                ShiftRight (Local7, 0x05, Local7)
                Store (ITOS (ToBCD (Local7)), Local5)
                ShiftRight (Local1, 0x09, Local7)
                Add (Local7, 0x07BC, Local7)
                Store (ITOS (ToBCD (Local7)), Local4)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local5, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local6, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x04, Local1)
                Store (0x01, Local7)
                While (Local1)
                {
                    GBFE (Local4, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store (0x00, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Store (0x2C, Local2)
                Store (0x00, Local4)
                Store (0x0F, Local1)
                Store (Buffer (0x10)
                    {
                        "Hewlett-Packard"
                    }, Local3)
                While (Local1)
                {
                    GBFE (Local3, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local4)
                }

                Store (0x00, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Sleep (0x96)
                Return (Local0)
            }

            Method (Z00P, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x1 (BIOS Read)", Debug)
                Store (WQBC (0x00), OB0)
                Or (OB0, 0x01, OB0)
                Store (0x00, OB1)
                Store (0x00, OB2)
                Store (0x00, OB3)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04)
                        {
                            0x01, 0x02, 0x03, 0x04
                        }
                    }, Local0)
                Store (OB0, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (OB1, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                Store (OB2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                Store (OB3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Return (Local0)
            }

            Method (Z010, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x1 (BIOS Write)", Debug)
                And (Arg0, 0x07, Local0)
                If (VGAT)
                {
                    If (LEqual (\_SB.PCI0.XVR0.VGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x87, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local1)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                        If (LEqual (Local0, Local1))
                        {
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                        Else
                        {
                            Store (0x00, NSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store ("TV+LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x06))
                            {
                                Store ("TV+CRT", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x07))
                            {
                                Store ("TV+CRT+LCD", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            Store (CADL, PADL)
                            Notify (\_SB.PCI0.XVR0.VGA, 0x80)
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }
                Else
                {
                    If (LEqual (\_SB.PCI0.UVGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x87, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local1)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                        If (LEqual (Local0, Local1))
                        {
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                        Else
                        {
                            Store (0x00, NSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store ("TV+LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x06))
                            {
                                Store ("TV+CRT", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x07))
                            {
                                Store ("TV+CRT+LCD", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            Store (CADL, PADL)
                            Notify (\_SB.PCI0.UVGA, 0x80)
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }
            }

            Method (Z00Q, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x8 (BIOS Read)", Debug)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x80, 
                        Buffer (0x80)
                        {
                            /* 0000 */    0x31, 0x01, 0x9B, 0x01, 0xFF, 0x01, 0x63, 0x02, 
                            /* 0008 */    0xAE, 0x01, 0x64, 0x02, 0x9D, 0x01, 0xB6, 0x01, 
                            /* 0010 */    0xB7, 0x01, 0x65, 0x02, 0x66, 0x02, 0x67, 0x02, 
                            /* 0018 */    0x68, 0x02, 0xFF, 0xFF, 0xE4, 0x20, 0xE5, 0x20, 
                            /* 0020 */    0xE6, 0x20, 0x42, 0x21, 0x70, 0x21, 0x71, 0x21, 
                            /* 0028 */    0x72, 0x21, 0x73, 0x21, 0x74, 0x21, 0x75, 0x21, 
                            /* 0030 */    0x76, 0x21, 0x77, 0x21, 0x78, 0x21, 0x79, 0x21, 
                            /* 0038 */    0x7A, 0x21, 0x7B, 0x21, 0x7C, 0x21, 0x7D, 0x21, 
                            /* 0040 */    0x7E, 0x21, 0x80, 0x21, 0x81, 0x21, 0x82, 0x21, 
                            /* 0048 */    0x87, 0x21, 0x8D, 0x21, 0x8E, 0x21, 0x8F, 0x21, 
                            /* 0050 */    0x90, 0x21, 0x91, 0x21, 0x92, 0x21, 0x93, 0x21, 
                            /* 0058 */    0x69, 0x21, 0x6A, 0x21, 0x00, 0x00
                        }
                    }, Local0)
                Return (Local0)
            }

            Method (Z00R, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x9 (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                Store (\_SB.PCI0.EC0.Z01E (), Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Release (\_SB.PCI0.EC0.MUT0)
                Return (Local0)
            }

            Method (Z011, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x9 (BIOS Write)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                \_SB.PCI0.EC0.Z01F (Arg0)
                Release (\_SB.PCI0.EC0.MUT0)
                Return (Package (0x02)
                {
                    0x00, 
                    0x00
                })
            }

            Method (Z01G, 0, NotSerialized)
            {
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.QBHK, Local1)
                    Store (0x00, \_SB.PCI0.EC0.QBHK)
                    Release (\_SB.PCI0.EC0.MUT0)
                }

                If (LEqual (Local1, 0x0D))
                {
                    Store ("Fn+ESC Pressed", Debug)
                    Store (0x31, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x01))
                {
                    Store ("Fn+F1 Pressed", Debug)
                    Store (0x9B, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x04))
                {
                    \_SB.PCI0.EC0._Q0D ()
                    Store (0x00, Local3)
                    Store (0x00, Local4)
                    Store (0x00, Local5)
                    Store (0xAE, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                    ShiftLeft (And (NSTE, 0x01), 0x01, Local3)
                    ShiftLeft (And (NSTE, 0x02), 0x01, Local4)
                    ShiftRight (And (NSTE, 0x08), 0x03, Local5)
                    Or (Local3, Local4, Local3)
                    Or (Local3, Local5, Local3)
                    Store (CSTE, Local3)
                    Store (Local3, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                    ShiftLeft (And (CADL, 0x01), 0x01, Local3)
                    ShiftLeft (And (CADL, 0x02), 0x01, Local4)
                    ShiftRight (And (CADL, 0x08), 0x03, Local5)
                    Or (Local3, Local4, Local3)
                    Or (Local3, Local5, Local3)
                    Store (PSTE, Local3)
                    Store (Local3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                }

                If (LEqual (Local1, 0x06))
                {
                    Store ("Fn+F6 Pressed", Debug)
                    Store (0x9D, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x07))
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Notify (\_SB.PCI0.UVGA.LCD, 0x87)
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8D, \_SB.PCI0.SMIC)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                    }

                    Sleep (0x32)
                    Store (0xB6, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x08))
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Notify (\_SB.PCI0.UVGA.LCD, 0x86)
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8C, \_SB.PCI0.SMIC)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                    }

                    Sleep (0x32)
                    Store (0xB7, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                Return (Local0)
            }

            Method (Z00S, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xA (BIOS Read)", Debug)
                Return (Z01G ())
            }

            Method (Z012, 1, NotSerialized)
            {
                Store ("HP WMI Command 0xA (BIOS Write)", Debug)
                And (Arg0, 0xFF, Local1)
                And (Arg0, 0xFF00, Local3)
                ShiftRight (Local3, 0x08, Local2)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                Store (Local1, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                If (LEqual (Arg0, 0x01AE))
                {
                    \_SB.PCI0.EC0._Q0D ()
                    Store (CSTE, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                    Store (PSTE, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                }

                Return (Local0)
            }

            Method (Z00V, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xB (BIOS Read)", Debug)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04)
                        {
                            0x01, 0x00, 0x00, 0x00
                        }
                    }, Local0)
                Return (Local0)
            }

            Method (Z015, 3, NotSerialized)
            {
                Store ("HP WMI Command 0x0B (BIOS Write)", Debug)
                Store (0x00, Local1)
                Store (0x00, Local2)
                If (Arg0)
                {
                    Or (Local1, 0x01, Local1)
                }
                Else
                {
                    And (Local1, 0xFE, Local1)
                }

                If (Arg1)
                {
                    Or (Local1, ShiftRight (And (Local1, 0x8000), 0x09), Local1)
                    Or (Local2, ShiftRight (And (Local2, 0x7000), 0x0C), Local2)
                }
                Else
                {
                    And (Local1, 0xBF, Local1)
                }

                If (Arg2)
                {
                    Or (Local1, 0x80, Local1)
                }
                Else
                {
                    And (Local1, 0x7F, Local1)
                }

                Return (Package (0x02)
                {
                    0x00, 
                    0x00
                })
            }

            Method (Z00T, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xC (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                If (ECON)
                {
                    Store (\_SB.PCI0.EC0.QBBB, Local1)
                    Store (0x00, \_SB.PCI0.EC0.QBBB)
                }

                If (LEqual (Local1, 0x03))
                {
                    Store (0xE4, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x20, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x04))
                {
                    Store (0x42, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x05))
                {
                    Store (0xE6, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x20, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x06))
                {
                    Store (0xE5, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x20, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x07))
                {
                    Store (0x6A, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x08))
                {
                    Store (0x69, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x11))
                {
                    Store (0x81, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x10))
                {
                    Store (0x70, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x20))
                {
                    Store (0x8D, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x21))
                {
                    Store (0x8E, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x22))
                {
                    Store (0x8F, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x23))
                {
                    Store (0x90, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x24))
                {
                    Store (0x91, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x25))
                {
                    Store (0x92, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x26))
                {
                    Store (0x93, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x30))
                {
                    Store (0x71, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x31))
                {
                    Store (0x72, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x32))
                {
                    Store (0x73, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x33))
                {
                    Store (0x74, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x34))
                {
                    Store (0x75, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x35))
                {
                    Store (0x76, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x36))
                {
                    Store (0x77, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x37))
                {
                    Store (0x78, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x38))
                {
                    Store (0x79, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x39))
                {
                    Store (0x7A, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x40))
                {
                    Store (0x7B, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x41))
                {
                    Store (0x7C, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x42))
                {
                    Store (0x7D, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x43))
                {
                    Store (0x7E, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x44))
                {
                    Store (0x80, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x45))
                {
                    Store (0x82, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x4B))
                {
                    Store (0x87, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                Release (\_SB.PCI0.EC0.MUT0)
                Return (Local0)
            }

            Method (Z00W, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x13 (BIOS Read)", Debug)
                Store (0x00, Local0)
                If (ECON)
                {
                    Store (\_SB.PCI0.EC0.BBDA, Local0)
                }

                If (Local0)
                {
                    Store (Package (0x03)
                        {
                            0x00, 
                            0x04, 
                            Buffer (0x04)
                            {
                                0x00, 0x00, 0x00, 0x00
                            }
                        }, Local1)
                }
                Else
                {
                    Store (Package (0x03)
                        {
                            0x00, 
                            0x04, 
                            Buffer (0x04)
                            {
                                0x01, 0x00, 0x00, 0x00
                            }
                        }, Local1)
                }

                Return (Local1)
            }

            Method (Z016, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x13 (BIOS Write)", Debug)
                Store (Arg0, Local0)
                If (Local0)
                {
                    Store (0x00, \_SB.PCI0.EC0.BBDA)
                }
                Else
                {
                    Store (0x01, \_SB.PCI0.EC0.BBDA)
                }

                Return (Package (0x02)
                {
                    0x00, 
                    0x00
                })
            }

            Mutex (CTMX, 0x00)
            Method (Z017, 0, NotSerialized)
            {
                Store (0x70, \_SB.PCI0.SMIC)
                Sleep (0x05)
                Store (CTKY, Local0)
                Return (Local0)
            }

            Method (Z019, 1, NotSerialized)
            {
                Store (Arg0, CTKY)
                If (LOr (LEqual (CTKY, 0x00), LEqual (CTKY, 0xFFFFFFFF)))
                {
                    Store (0x21, Local0)
                }
                Else
                {
                    Store (0x71, \_SB.PCI0.SMIC)
                    Sleep (0x05)
                    Store (CTKY, Local0)
                }

                Return (Local0)
            }

            Method (Z01B, 1, NotSerialized)
            {
                If (LGreaterEqual (CTDC, 0x04))
                {
                    Store (0x22, Local0)
                }
                Else
                {
                    Increment (CTDC)
                    Store (Arg0, CTKY)
                    Store (0x72, \_SB.PCI0.SMIC)
                    Sleep (0x05)
                    Store (CTKY, Local0)
                }

                Return (Local0)
            }

            Method (_WED, 1, NotSerialized)
            {
                Concatenate (Z01C, Z01D, Local0)
                Return (Local0)
            }

            Name (WQAE, Buffer (0x08A9)
            {
                /* 0000 */    0x46, 0x4F, 0x4D, 0x42, 0x01, 0x00, 0x00, 0x00, 
                /* 0008 */    0x99, 0x08, 0x00, 0x00, 0x8A, 0x3A, 0x00, 0x00, 
                /* 0010 */    0x44, 0x53, 0x00, 0x01, 0x1A, 0x7D, 0xDA, 0x54, 
                /* 0018 */    0x98, 0x4B, 0x9C, 0x00, 0x01, 0x06, 0x18, 0x42, 
                /* 0020 */    0x10, 0x13, 0x10, 0x22, 0x21, 0x04, 0x12, 0x01, 
                /* 0028 */    0xA1, 0xC8, 0x2C, 0x0C, 0x86, 0x10, 0x38, 0x2E, 
                /* 0030 */    0x84, 0x1C, 0x40, 0x88, 0x59, 0x50, 0x08, 0x21, 
                /* 0038 */    0x10, 0xEA, 0x4F, 0x20, 0xBF, 0x02, 0x10, 0x3A, 
                /* 0040 */    0x14, 0x20, 0x53, 0x80, 0x41, 0x01, 0x4E, 0x11, 
                /* 0048 */    0x44, 0xD0, 0xAB, 0x00, 0x9B, 0x02, 0x4C, 0x0A, 
                /* 0050 */    0xB0, 0x28, 0x40, 0xBB, 0x00, 0xCB, 0x02, 0x74, 
                /* 0058 */    0x0B, 0x90, 0x0E, 0x4B, 0x44, 0x82, 0xA3, 0xC4, 
                /* 0060 */    0x80, 0xA3, 0x74, 0x62, 0x0B, 0x37, 0x6C, 0xF0, 
                /* 0068 */    0x42, 0x51, 0x34, 0x83, 0x28, 0x09, 0x2A, 0x17, 
                /* 0070 */    0xE0, 0x1B, 0x41, 0xE0, 0xE5, 0x0A, 0x90, 0x3C, 
                /* 0078 */    0x01, 0x69, 0x16, 0x60, 0x58, 0x80, 0x75, 0x01, 
                /* 0080 */    0xB2, 0x87, 0x40, 0xA5, 0x0E, 0x01, 0x25, 0x67, 
                /* 0088 */    0x08, 0xA8, 0x01, 0xB4, 0x3A, 0x01, 0xE1, 0x57, 
                /* 0090 */    0x3A, 0x25, 0x24, 0x41, 0x38, 0x63, 0x15, 0x8F, 
                /* 0098 */    0xAF, 0x59, 0x34, 0x3D, 0x27, 0x39, 0xC7, 0x90, 
                /* 00A0 */    0xE3, 0x71, 0xA1, 0x07, 0xC1, 0x05, 0x78, 0x18, 
                /* 00A8 */    0x06, 0x1D, 0xB2, 0x22, 0x6B, 0x80, 0xC1, 0x58, 
                /* 00B0 */    0x18, 0x0B, 0x75, 0x31, 0x6A, 0xD4, 0x48, 0xD9, 
                /* 00B8 */    0x80, 0x0C, 0x51, 0x12, 0x1C, 0x6A, 0xD4, 0x96, 
                /* 00C0 */    0x28, 0xC0, 0xFC, 0x38, 0x34, 0xBB, 0xB6, 0xC7, 
                /* 00C8 */    0x42, 0x20, 0x99, 0xB4, 0xA1, 0xA0, 0xA4, 0x40, 
                /* 00D0 */    0x68, 0x6C, 0x67, 0xEA, 0x19, 0x45, 0x3C, 0x52, 
                /* 00D8 */    0xC3, 0x24, 0xF0, 0x28, 0x22, 0x1B, 0x8D, 0x43, 
                /* 00E0 */    0x63, 0x87, 0xE1, 0x61, 0x06, 0x3B, 0x88, 0xC3, 
                /* 00E8 */    0x38, 0xE6, 0xC8, 0x09, 0x3C, 0xA1, 0x23, 0x3D, 
                /* 00F0 */    0xF2, 0xC2, 0xE6, 0x29, 0xD4, 0x18, 0xCD, 0x41, 
                /* 00F8 */    0x11, 0xB8, 0xD0, 0x18, 0x19, 0x10, 0xF2, 0x3C, 
                /* 0100 */    0x7E, 0x8D, 0xC4, 0x04, 0x76, 0x2F, 0xC0, 0x1A, 
                /* 0108 */    0xA6, 0x60, 0x1B, 0x9B, 0x98, 0xFE, 0xFF, 0x10, 
                /* 0110 */    0x47, 0x1E, 0xA3, 0xAD, 0xB9, 0x0B, 0x29, 0x4C, 
                /* 0118 */    0x8C, 0x28, 0xC1, 0xE2, 0x55, 0x3C, 0x0D, 0xA1, 
                /* 0120 */    0x3C, 0x29, 0x84, 0x8A, 0x54, 0x19, 0x8A, 0x86, 
                /* 0128 */    0x1E, 0xA5, 0x42, 0x01, 0xCE, 0xE6, 0x21, 0xDC, 
                /* 0130 */    0x1A, 0x41, 0x85, 0x10, 0x2B, 0x52, 0xAC, 0xF6, 
                /* 0138 */    0x07, 0x41, 0x42, 0x2E, 0x5B, 0xC7, 0x07, 0x47, 
                /* 0140 */    0x1A, 0x0D, 0xEA, 0x50, 0xE0, 0xB1, 0x7B, 0xDC, 
                /* 0148 */    0xCF, 0x02, 0x3E, 0x08, 0x9C, 0x5B, 0x90, 0xA3, 
                /* 0150 */    0x3B, 0x8B, 0x47, 0x85, 0x83, 0xF6, 0xF0, 0xD8, 
                /* 0158 */    0x6D, 0xC0, 0x67, 0x08, 0x9F, 0x02, 0xF0, 0xAE, 
                /* 0160 */    0x01, 0x35, 0xFD, 0x83, 0x67, 0x82, 0xE0, 0x50, 
                /* 0168 */    0x43, 0xF4, 0xA8, 0xC3, 0x9D, 0xC0, 0x21, 0x32, 
                /* 0170 */    0x40, 0x4F, 0xEA, 0xB8, 0xB1, 0x83, 0x3B, 0x99, 
                /* 0178 */    0x83, 0x7E, 0x6F, 0x68, 0xF6, 0xC6, 0x40, 0x08, 
                /* 0180 */    0x8E, 0xC7, 0x97, 0x05, 0x36, 0xE1, 0x04, 0x96, 
                /* 0188 */    0x3F, 0x08, 0xD4, 0xC8, 0x0C, 0xED, 0x51, 0x9E, 
                /* 0190 */    0x56, 0xCC, 0x90, 0xCF, 0x0C, 0x26, 0xB0, 0x58, 
                /* 0198 */    0x08, 0x29, 0x80, 0xD0, 0x78, 0xC0, 0x7F, 0x03, 
                /* 01A0 */    0x78, 0xC0, 0xF0, 0xCD, 0xC0, 0xF3, 0x35, 0xC1, 
                /* 01A8 */    0xB0, 0x10, 0x32, 0xB2, 0x0A, 0x8F, 0x87, 0x8E, 
                /* 01B0 */    0xC2, 0xD7, 0x83, 0xC3, 0x39, 0xAD, 0x78, 0x26, 
                /* 01B8 */    0x18, 0x0E, 0x42, 0x27, 0x09, 0x8B, 0x1A, 0x36, 
                /* 01C0 */    0x3D, 0x39, 0xF0, 0x43, 0x03, 0xBB, 0x19, 0x9C, 
                /* 01C8 */    0xC1, 0x23, 0x80, 0x47, 0x72, 0x42, 0xFE, 0x98, 
                /* 01D0 */    0x78, 0x60, 0xF0, 0x01, 0xF1, 0xDE, 0xA7, 0x4C, 
                /* 01D8 */    0x46, 0x70, 0xA6, 0x06, 0xF4, 0x71, 0xC0, 0xFF, 
                /* 01E0 */    0xFF, 0xA1, 0xF0, 0x21, 0x7A, 0x7C, 0xA7, 0x7C, 
                /* 01E8 */    0xBC, 0x96, 0x00, 0x21, 0x59, 0xE3, 0x84, 0x7E, 
                /* 01F0 */    0x87, 0xF0, 0xF1, 0xC3, 0x47, 0x16, 0x47, 0x84, 
                /* 01F8 */    0x90, 0x93, 0x53, 0x00, 0x1A, 0xF8, 0x74, 0xCF, 
                /* 0200 */    0x2E, 0xC2, 0xE9, 0x7A, 0x52, 0x0E, 0x34, 0x0C, 
                /* 0208 */    0x3A, 0x4E, 0x70, 0x9C, 0x07, 0xC0, 0x31, 0x4E, 
                /* 0210 */    0xF8, 0xE7, 0x02, 0xF8, 0x03, 0xE4, 0xA7, 0x8C, 
                /* 0218 */    0x57, 0x8C, 0x04, 0x8E, 0x39, 0x42, 0xF4, 0xB9, 
                /* 0220 */    0xC6, 0x23, 0xC4, 0xC2, 0x3F, 0x55, 0x14, 0x3E, 
                /* 0228 */    0x10, 0x32, 0x46, 0x70, 0x01, 0x7A, 0x8C, 0xC0, 
                /* 0230 */    0x37, 0xE0, 0x18, 0xD1, 0x47, 0x09, 0xAE, 0xFE, 
                /* 0238 */    0xA0, 0x41, 0x07, 0x88, 0xFB, 0xFF, 0x0F, 0x10, 
                /* 0240 */    0x3E, 0xA8, 0x07, 0x08, 0x7C, 0xA3, 0x1F, 0x3D, 
                /* 0248 */    0xD0, 0xE3, 0xB2, 0xE8, 0xF3, 0x80, 0x8C, 0x9F, 
                /* 0250 */    0x68, 0x34, 0x2F, 0x7E, 0x3A, 0xE0, 0x87, 0x0F, 
                /* 0258 */    0xF0, 0x80, 0x7A, 0x48, 0x38, 0x50, 0xCC, 0xB4, 
                /* 0260 */    0x39, 0xE8, 0xB3, 0xCB, 0xA1, 0x63, 0x87, 0x0B, 
                /* 0268 */    0xFE, 0x13, 0x08, 0xB8, 0xE4, 0x1D, 0xC2, 0x40, 
                /* 0270 */    0x31, 0x62, 0xFC, 0x39, 0xC8, 0xA7, 0x30, 0xF0, 
                /* 0278 */    0xFF, 0xFF, 0x4F, 0x61, 0xB8, 0x11, 0xF0, 0x20, 
                /* 0280 */    0xAF, 0x05, 0x9F, 0xB6, 0xA8, 0x74, 0x18, 0xD4, 
                /* 0288 */    0x81, 0x0B, 0x30, 0x09, 0x1A, 0xE1, 0x59, 0xA2, 
                /* 0290 */    0x36, 0x08, 0x01, 0xBF, 0x4D, 0xBC, 0x6D, 0xF9, 
                /* 0298 */    0x16, 0x10, 0xE7, 0xC8, 0x7B, 0x3B, 0x70, 0x11, 
                /* 02A0 */    0x8C, 0x08, 0xA7, 0x1D, 0xCA, 0x63, 0x88, 0x18, 
                /* 02A8 */    0x23, 0xCA, 0xE3, 0x96, 0x51, 0xDE, 0xB6, 0x5E, 
                /* 02B0 */    0x00, 0xE2, 0x9D, 0xE5, 0xF3, 0x96, 0x31, 0x82, 
                /* 02B8 */    0x47, 0x7E, 0xE0, 0x62, 0x62, 0xDF, 0x13, 0xFA, 
                /* 02C0 */    0xB9, 0xF9, 0xC0, 0x05, 0x38, 0xFB, 0xFF, 0x1F, 
                /* 02C8 */    0xB8, 0x00, 0x0E, 0x05, 0x3D, 0x0C, 0xA1, 0x87, 
                /* 02D0 */    0xE1, 0xA9, 0x9C, 0xCB, 0x13, 0xE5, 0xA9, 0x44, 
                /* 02D8 */    0x8C, 0x1A, 0x26, 0xEA, 0x33, 0x94, 0x2F, 0x1A, 
                /* 02E0 */    0x3E, 0x10, 0x81, 0xEF, 0xCC, 0x05, 0xFC, 0xFE, 
                /* 02E8 */    0xFF, 0x07, 0x22, 0x38, 0x02, 0xCF, 0x34, 0xA0, 
                /* 02F0 */    0xF4, 0x39, 0x03, 0x81, 0x9C, 0x8A, 0x0F, 0x35, 
                /* 02F8 */    0xC0, 0x48, 0xF4, 0xAB, 0xC1, 0x27, 0x1A, 0x2A, 
                /* 0300 */    0x13, 0x06, 0x75, 0xA8, 0x01, 0x4C, 0x5E, 0x61, 
                /* 0308 */    0x9E, 0x46, 0xCF, 0xF9, 0x59, 0xC6, 0xA7, 0x1A, 
                /* 0310 */    0x1F, 0x4A, 0x8D, 0x63, 0x88, 0x97, 0x99, 0x87, 
                /* 0318 */    0x1A, 0x1F, 0x0B, 0x5E, 0x49, 0x7D, 0xA8, 0x31, 
                /* 0320 */    0x54, 0x9C, 0x87, 0x1A, 0x9F, 0x48, 0x03, 0x45, 
                /* 0328 */    0x7D, 0xB3, 0x79, 0xB6, 0x31, 0x7A, 0x7C, 0xDF, 
                /* 0330 */    0x50, 0x0D, 0xF1, 0x50, 0xC3, 0x84, 0xBD, 0x23, 
                /* 0338 */    0xF4, 0xC1, 0xF5, 0xA1, 0x06, 0x1C, 0xFF, 0xFF, 
                /* 0340 */    0x43, 0x0D, 0xC0, 0xFF, 0xFF, 0xFF, 0xA1, 0x06, 
                /* 0348 */    0x70, 0x74, 0x34, 0x80, 0x73, 0x64, 0xC4, 0x1D, 
                /* 0350 */    0x0D, 0xC0, 0x75, 0x28, 0x05, 0x0E, 0x47, 0x03, 
                /* 0358 */    0xE0, 0x71, 0x14, 0x02, 0xF3, 0x85, 0xC6, 0x47, 
                /* 0360 */    0x21, 0x60, 0xF1, 0xFF, 0x3F, 0x0A, 0xE1, 0x64, 
                /* 0368 */    0x9F, 0x83, 0x50, 0x42, 0x8F, 0x42, 0x80, 0x54, 
                /* 0370 */    0xC8, 0xA7, 0x88, 0x67, 0x1F, 0x5F, 0x7E, 0x1E, 
                /* 0378 */    0x08, 0x22, 0xBC, 0xE6, 0xFB, 0x14, 0xE4, 0x43, 
                /* 0380 */    0xBE, 0x8F, 0x42, 0x0C, 0xC6, 0x50, 0xBE, 0x06, 
                /* 0388 */    0xF9, 0x28, 0xC4, 0xA0, 0x5E, 0x83, 0x7C, 0xDF, 
                /* 0390 */    0x37, 0xC8, 0x91, 0x18, 0xFB, 0x99, 0xC0, 0x47, 
                /* 0398 */    0x21, 0x26, 0xED, 0x28, 0x04, 0x28, 0xFC, 0xFF, 
                /* 03A0 */    0x1F, 0x85, 0x00, 0xFE, 0xFF, 0xFF, 0x8F, 0x42, 
                /* 03A8 */    0x80, 0xB3, 0x00, 0x47, 0x03, 0xD0, 0x4D, 0xEB, 
                /* 03B0 */    0x51, 0x08, 0xBC, 0x77, 0x96, 0xD3, 0x3E, 0x01, 
                /* 03B8 */    0x9F, 0x85, 0x00, 0xB3, 0xFF, 0xFF, 0xB3, 0x10, 
                /* 03C0 */    0x30, 0x3B, 0x0A, 0x45, 0x3D, 0xE8, 0x57, 0xA1, 
                /* 03C8 */    0x27, 0x80, 0x17, 0x80, 0x18, 0x61, 0xDE, 0x81, 
                /* 03D0 */    0x5E, 0x32, 0xD9, 0x5D, 0xDC, 0x38, 0x4F, 0x2E, 
                /* 03D8 */    0xA7, 0x6D, 0x94, 0x97, 0x20, 0x1F, 0x28, 0x9E, 
                /* 03E0 */    0x85, 0x0C, 0xF5, 0x2E, 0x14, 0xF4, 0x8D, 0xDC, 
                /* 03E8 */    0xA3, 0x8C, 0x19, 0x3F, 0xC4, 0xF3, 0x90, 0x21, 
                /* 03F0 */    0x9E, 0x85, 0x00, 0x76, 0xFD, 0xFF, 0xCF, 0x42, 
                /* 03F8 */    0x00, 0xFF, 0xFF, 0xFF, 0x47, 0x03, 0xF8, 0x2F, 
                /* 0400 */    0x00, 0x9F, 0x85, 0x80, 0xE7, 0x09, 0xE0, 0x41, 
                /* 0408 */    0xDB, 0x67, 0x21, 0x80, 0x33, 0x87, 0xCB, 0xF3, 
                /* 0410 */    0x0F, 0x7A, 0x60, 0xEF, 0x11, 0x9E, 0xF5, 0x71, 
                /* 0418 */    0xBF, 0x5E, 0x7A, 0xE0, 0x0F, 0x05, 0xCF, 0x42, 
                /* 0420 */    0x0C, 0xEB, 0x98, 0x7C, 0x16, 0x62, 0x10, 0x2F, 
                /* 0428 */    0x9A, 0x86, 0x78, 0xE1, 0xF4, 0x61, 0xC0, 0xFF, 
                /* 0430 */    0x7F, 0xBC, 0xC0, 0xAF, 0x9C, 0x06, 0x0A, 0x12, 
                /* 0438 */    0xE8, 0x59, 0x08, 0x60, 0xFC, 0xFF, 0xFF, 0x2C, 
                /* 0440 */    0x04, 0x90, 0x71, 0x8D, 0x3A, 0x0B, 0x01, 0xCB, 
                /* 0448 */    0x63, 0x0C, 0x3B, 0xAD, 0x24, 0xF8, 0xFF, 0x3F, 
                /* 0450 */    0x0B, 0x01, 0x9F, 0x5C, 0x46, 0x0E, 0x42, 0x98, 
                /* 0458 */    0x88, 0x6F, 0x05, 0x1F, 0x33, 0x01, 0xA5, 0xE7, 
                /* 0460 */    0xA0, 0x17, 0x77, 0x63, 0x04, 0x7E, 0x91, 0x78, 
                /* 0468 */    0xCC, 0x64, 0x47, 0x4D, 0xC3, 0x3C, 0x0B, 0x19, 
                /* 0470 */    0xEF, 0x30, 0xCE, 0xE0, 0x09, 0xDE, 0x93, 0x7F, 
                /* 0478 */    0x16, 0x62, 0x60, 0xC7, 0x18, 0xEC, 0x51, 0xC8, 
                /* 0480 */    0xA0, 0x06, 0x8F, 0x1D, 0x22, 0x4C, 0xA0, 0x67, 
                /* 0488 */    0x21, 0x16, 0x6A, 0xDC, 0x3A, 0x7F, 0xF8, 0x2C, 
                /* 0490 */    0x04, 0xBC, 0xFF, 0xFF, 0x67, 0x21, 0xC0, 0xD3, 
                /* 0498 */    0x61, 0xC3, 0x67, 0x0D, 0xF0, 0x0C, 0xDF, 0xA3, 
                /* 04A0 */    0x3A, 0x87, 0xC7, 0x63, 0xE0, 0x92, 0x55, 0xC7, 
                /* 04A8 */    0x09, 0x83, 0xE5, 0x5E, 0xA7, 0x6C, 0x9C, 0x61, 
                /* 04B0 */    0xE8, 0x20, 0xAC, 0x0E, 0x48, 0xC3, 0xC1, 0xDC, 
                /* 04B8 */    0x43, 0x0E, 0xE2, 0x7C, 0xD8, 0x40, 0xAD, 0x08, 
                /* 04C0 */    0x4E, 0xC7, 0x24, 0x0F, 0xDA, 0x5A, 0x28, 0xA4, 
                /* 04C8 */    0x80, 0x46, 0x03, 0x32, 0xBC, 0x33, 0x9F, 0x96, 
                /* 04D0 */    0x28, 0x88, 0x01, 0x7D, 0x02, 0xB2, 0x8D, 0x73, 
                /* 04D8 */    0x00, 0x6A, 0x2F, 0x9A, 0x02, 0x39, 0xDA, 0x60, 
                /* 04E0 */    0xF4, 0x5F, 0x16, 0xE8, 0x6C, 0x7C, 0x0D, 0xE0, 
                /* 04E8 */    0x1A, 0x20, 0x74, 0x30, 0x30, 0xB4, 0xD5, 0xDC, 
                /* 04F0 */    0x62, 0x50, 0x60, 0xC6, 0x7F, 0x70, 0x31, 0x81, 
                /* 04F8 */    0x8F, 0x2E, 0xF8, 0xB3, 0x00, 0xEE, 0xFF, 0x3F, 
                /* 0500 */    0x5C, 0x8F, 0xF6, 0x5D, 0xA0, 0xEA, 0xC9, 0xEA, 
                /* 0508 */    0x8A, 0x60, 0x75, 0x97, 0x17, 0x08, 0x33, 0x32, 
                /* 0510 */    0x41, 0x7D, 0x07, 0x02, 0x50, 0x00, 0xF9, 0x0E, 
                /* 0518 */    0xE0, 0xA3, 0xD3, 0x73, 0x00, 0x9B, 0x48, 0x88, 
                /* 0520 */    0x30, 0xD1, 0x8C, 0x8E, 0x98, 0x30, 0x2A, 0xFA, 
                /* 0528 */    0x84, 0x29, 0x88, 0x27, 0xEC, 0x58, 0x13, 0x46, 
                /* 0530 */    0xCF, 0xC4, 0x77, 0x1B, 0x36, 0x62, 0x4C, 0x88, 
                /* 0538 */    0xDB, 0x06, 0xB4, 0x09, 0x06, 0xF5, 0x3D, 0x08, 
                /* 0540 */    0xD6, 0x90, 0xF9, 0x58, 0x7C, 0x67, 0xC0, 0x4D, 
                /* 0548 */    0x19, 0x8C, 0x73, 0x62, 0xD7, 0x04, 0x0B, 0x9C, 
                /* 0550 */    0x33, 0xC8, 0xE1, 0x31, 0xD7, 0x2F, 0x7E, 0x5B, 
                /* 0558 */    0xF2, 0xE8, 0xF8, 0x41, 0xC1, 0x37, 0x1C, 0x86, 
                /* 0560 */    0xFD, 0x30, 0xE6, 0x19, 0xBD, 0x8A, 0xF9, 0xE6, 
                /* 0568 */    0x86, 0x81, 0xF5, 0x78, 0x39, 0xAC, 0xD1, 0xC2, 
                /* 0570 */    0x1E, 0xDA, 0xAB, 0x87, 0xCF, 0x2D, 0x3E, 0x4F, 
                /* 0578 */    0x18, 0x23, 0xAC, 0x2F, 0x2C, 0xE0, 0x00, 0xFC, 
                /* 0580 */    0xFF, 0xBF, 0x5A, 0xC1, 0xBE, 0x6B, 0x80, 0xE7, 
                /* 0588 */    0x26, 0xE4, 0xBB, 0x06, 0xC0, 0xDA, 0xFF, 0xFF, 
                /* 0590 */    0x5D, 0x03, 0xFE, 0x35, 0xC1, 0x77, 0x0D, 0xE0, 
                /* 0598 */    0x3D, 0x74, 0xDF, 0x35, 0x80, 0x6B, 0xF6, 0xBB, 
                /* 05A0 */    0x06, 0xEA, 0x18, 0x60, 0x85, 0x77, 0x0D, 0x68, 
                /* 05A8 */    0xB7, 0xB4, 0x57, 0xB4, 0x87, 0x2A, 0x6B, 0xBA, 
                /* 05B0 */    0x6C, 0xA0, 0xD4, 0x5C, 0x36, 0x00, 0x6D, 0xFF, 
                /* 05B8 */    0xFF, 0xCB, 0x06, 0xB0, 0x91, 0x32, 0x61, 0x54, 
                /* 05C0 */    0xF8, 0x09, 0x53, 0x10, 0x4F, 0xD8, 0xC1, 0x2E, 
                /* 05C8 */    0x1B, 0xA0, 0x88, 0x71, 0xD9, 0x00, 0xFD, 0xD8, 
                /* 05D0 */    0x5E, 0x36, 0x80, 0xC1, 0x3D, 0x81, 0xDF, 0x36, 
                /* 05D8 */    0x80, 0x37, 0xA4, 0x6F, 0x1B, 0xC0, 0xF4, 0xFF, 
                /* 05E0 */    0x0F, 0x31, 0xFF, 0x6D, 0x03, 0xC5, 0x61, 0x95, 
                /* 05E8 */    0xB7, 0x0D, 0x88, 0x87, 0x77, 0x46, 0x60, 0x55, 
                /* 05F0 */    0xD7, 0x0D, 0x94, 0x9E, 0xEB, 0x06, 0x40, 0x02, 
                /* 05F8 */    0x31, 0x13, 0x46, 0xC5, 0x9F, 0x30, 0x05, 0xF1, 
                /* 0600 */    0x84, 0x1D, 0xED, 0xBA, 0x01, 0x8A, 0x20, 0xD7, 
                /* 0608 */    0x0D, 0xD0, 0xCF, 0xEB, 0x94, 0xC1, 0xFA, 0xFF, 
                /* 0610 */    0xBF, 0x6E, 0x60, 0x2F, 0x0A, 0x98, 0xFB, 0x06, 
                /* 0618 */    0xF0, 0x86, 0xE5, 0xF7, 0x0D, 0xC0, 0xC7, 0xE5, 
                /* 0620 */    0x1B, 0x73, 0xDF, 0x00, 0x6C, 0xFE, 0xFF, 0xEF, 
                /* 0628 */    0x1B, 0x00, 0x13, 0x2E, 0x0A, 0xB8, 0xFB, 0x06, 
                /* 0630 */    0xF0, 0xBE, 0x48, 0xFB, 0xBE, 0x01, 0x5C, 0x83, 
                /* 0638 */    0x49, 0xF8, 0xFF, 0xDF, 0xF5, 0xE8, 0x0B, 0x40, 
                /* 0640 */    0x51, 0x60, 0x50, 0x43, 0xF2, 0x99, 0x00, 0x3F, 
                /* 0648 */    0xBA, 0x83, 0x3B, 0xA6, 0xE0, 0x4C, 0x12, 0x1C, 
                /* 0650 */    0x6A, 0xE0, 0xBE, 0x02, 0x3C, 0xCD, 0x9F, 0xD6, 
                /* 0658 */    0x7B, 0xBD, 0xE7, 0xF1, 0x24, 0x10, 0x92, 0x1D, 
                /* 0660 */    0x61, 0x7C, 0x6C, 0x43, 0x9C, 0x0C, 0xC8, 0x41, 
                /* 0668 */    0xDC, 0x47, 0xF7, 0x88, 0xEF, 0xE1, 0x86, 0x49, 
                /* 0670 */    0xE0, 0x21, 0x33, 0x34, 0x0E, 0x8D, 0x1D, 0x86, 
                /* 0678 */    0xEF, 0x02, 0xC1, 0x0E, 0xE2, 0x30, 0xCE, 0xD7, 
                /* 0680 */    0x04, 0x9E, 0xD0, 0x83, 0xC0, 0x7B, 0xF9, 0xA3, 
                /* 0688 */    0x41, 0xF1, 0x77, 0x03, 0x4A, 0x60, 0xB8, 0xD0, 
                /* 0690 */    0x98, 0x91, 0xFA, 0x6C, 0xFF, 0x8E, 0x70, 0x24, 
                /* 0698 */    0x26, 0xB0, 0x7B, 0x48, 0x59, 0x13, 0xA0, 0xF1, 
                /* 06A0 */    0x96, 0x43, 0x20, 0x7A, 0xC3, 0x91, 0x2D, 0x14, 
                /* 06A8 */    0xCD, 0x2D, 0xCA, 0xFB, 0x42, 0x14, 0x3B, 0x43, 
                /* 06B0 */    0x10, 0x46, 0x94, 0x60, 0x41, 0x9E, 0xD6, 0x62, 
                /* 06B8 */    0x45, 0x79, 0x66, 0x37, 0x42, 0xC4, 0x10, 0xAF, 
                /* 06C0 */    0x0C, 0x81, 0x5E, 0x12, 0xC2, 0x07, 0x79, 0xEC, 
                /* 06C8 */    0x89, 0xD3, 0xFE, 0x20, 0x88, 0xF8, 0x17, 0x82, 
                /* 06D0 */    0x3C, 0x80, 0x28, 0xD2, 0x68, 0x50, 0xE7, 0x06, 
                /* 06D8 */    0x8F, 0xDD, 0x87, 0x10, 0x5F, 0xFE, 0x7D, 0xB8, 
                /* 06E0 */    0xF7, 0xE8, 0x0E, 0xEE, 0x45, 0xFE, 0xA0, 0x3D, 
                /* 06E8 */    0x3C, 0x76, 0xC2, 0xF0, 0x41, 0x03, 0x8E, 0x6B, 
                /* 06F0 */    0x40, 0x4D, 0xFF, 0x19, 0x01, 0x2C, 0x97, 0x7F, 
                /* 06F8 */    0xF8, 0xE3, 0xF1, 0x3D, 0xC1, 0xF3, 0x39, 0xE1, 
                /* 0700 */    0x04, 0x96, 0x3F, 0x08, 0xD4, 0x71, 0x84, 0xCF, 
                /* 0708 */    0xF3, 0x85, 0xC3, 0x90, 0xCF, 0x02, 0x87, 0xC5, 
                /* 0710 */    0xC4, 0x0A, 0xF8, 0xFF, 0x9F, 0x4C, 0xD8, 0x78, 
                /* 0718 */    0xC0, 0x7F, 0x0F, 0x79, 0xFD, 0xF7, 0xCD, 0xC0, 
                /* 0720 */    0xF3, 0x35, 0xC1, 0x88, 0x10, 0x72, 0x32, 0x1E, 
                /* 0728 */    0x34, 0xE8, 0xD9, 0xF8, 0x80, 0xE1, 0xEB, 0x09, 
                /* 0730 */    0x3B, 0x77, 0x70, 0x51, 0xE7, 0x0E, 0xD4, 0xD1, 
                /* 0738 */    0xC1, 0xA7, 0x06, 0x76, 0xB3, 0xC1, 0x1C, 0xB7, 
                /* 0740 */    0xF9, 0x59, 0x03, 0xFC, 0x23, 0x84, 0x7F, 0x7B, 
                /* 0748 */    0xF0, 0xBC, 0x7C, 0x65, 0x78, 0x75, 0x48, 0xE0, 
                /* 0750 */    0x90, 0x23, 0x44, 0x8F, 0xCB, 0x23, 0xC4, 0x9C, 
                /* 0758 */    0x6F, 0x30, 0x43, 0x04, 0xD7, 0x59, 0x00, 0x1C, 
                /* 0760 */    0x43, 0x04, 0x3E, 0x67, 0x4C, 0x9F, 0x71, 0x60, 
                /* 0768 */    0xFE, 0xFF, 0xCF, 0x38, 0xEC, 0xD2, 0xC3, 0x07, 
                /* 0770 */    0x6A, 0x78, 0x13, 0xF8, 0xFE, 0x8C, 0x3B, 0xD2, 
                /* 0778 */    0x18, 0x9C, 0x1F, 0x33, 0x1E, 0x76, 0x18, 0xF8, 
                /* 0780 */    0xFB, 0x8E, 0x67, 0x70, 0x34, 0x3E, 0xA0, 0x18, 
                /* 0788 */    0x21, 0xF8, 0x73, 0xC9, 0x73, 0x8A, 0x35, 0x0F, 
                /* 0790 */    0x52, 0x33, 0x7A, 0x67, 0x38, 0x04, 0x76, 0xB3, 
                /* 0798 */    0xC2, 0x1D, 0x38, 0x3C, 0x04, 0x3E, 0x80, 0x56, 
                /* 07A0 */    0x27, 0x47, 0x4E, 0x3F, 0xA7, 0x84, 0x1B, 0x3E, 
                /* 07A8 */    0xBF, 0x0A, 0x60, 0x0E, 0x41, 0x38, 0x85, 0x36, 
                /* 07B0 */    0x7D, 0x6A, 0x34, 0x6A, 0xD5, 0xA0, 0x4C, 0x8D, 
                /* 07B8 */    0x32, 0x0D, 0x6A, 0xF5, 0xA9, 0xD4, 0x98, 0xB1, 
                /* 07C0 */    0x0B, 0x8B, 0x03, 0xBE, 0x02, 0x74, 0x1C, 0xB0, 
                /* 07C8 */    0x3C, 0x0A, 0x1D, 0xC1, 0xC8, 0x9B, 0x40, 0x20, 
                /* 07D0 */    0x0E, 0x0B, 0x42, 0x23, 0xBD, 0x71, 0x04, 0x62, 
                /* 07D8 */    0xC9, 0xEF, 0x2F, 0x81, 0x58, 0xEE, 0x03, 0x45, 
                /* 07E0 */    0x20, 0x0E, 0x68, 0x02, 0x9C, 0xAA, 0x00, 0xA7, 
                /* 07E8 */    0xAF, 0x01, 0x81, 0x38, 0x32, 0x08, 0x15, 0xFA, 
                /* 07F0 */    0x35, 0x13, 0x88, 0x63, 0x82, 0xD0, 0x50, 0x3E, 
                /* 07F8 */    0x40, 0x98, 0xF4, 0x17, 0x80, 0x00, 0x89, 0x11, 
                /* 0800 */    0x10, 0x16, 0xEE, 0xE5, 0x20, 0x10, 0x4B, 0x7B, 
                /* 0808 */    0x2D, 0x08, 0xC4, 0x42, 0xAC, 0x80, 0xB0, 0xB8, 
                /* 0810 */    0x20, 0x34, 0x9C, 0x16, 0x10, 0x26, 0xC9, 0x0C, 
                /* 0818 */    0x08, 0x0B, 0x04, 0x42, 0xE5, 0x3F, 0xD3, 0x04, 
                /* 0820 */    0x62, 0x91, 0x6E, 0x00, 0xE9, 0xBA, 0x05, 0xE2, 
                /* 0828 */    0x20, 0x7A, 0x40, 0x98, 0x0C, 0x3F, 0x20, 0x2C, 
                /* 0830 */    0x34, 0x08, 0x8D, 0xF6, 0x6C, 0x10, 0x20, 0x31, 
                /* 0838 */    0x04, 0xC2, 0xE2, 0x3B, 0x02, 0x61, 0xE2, 0xDF, 
                /* 0840 */    0x44, 0x02, 0x71, 0x4A, 0x4B, 0x10, 0x37, 0xA5, 
                /* 0848 */    0x01, 0x06, 0x11, 0x90, 0x93, 0x6A, 0x02, 0x62, 
                /* 0850 */    0xB9, 0x41, 0x34, 0x24, 0xF2, 0xB0, 0x10, 0x90, 
                /* 0858 */    0x93, 0x82, 0x68, 0xC0, 0xC4, 0x14, 0x90, 0xFF, 
                /* 0860 */    0xFF, 0x43, 0x13, 0x88, 0x80, 0x9C, 0xCA, 0x15, 
                /* 0868 */    0x10, 0x8B, 0x08, 0x22, 0x20, 0x27, 0x7B, 0x52, 
                /* 0870 */    0x09, 0xC8, 0x39, 0x41, 0x74, 0x04, 0x20, 0xBA, 
                /* 0878 */    0x80, 0x58, 0x3E, 0x10, 0x01, 0x39, 0x96, 0x2F, 
                /* 0880 */    0x20, 0x16, 0x12, 0x44, 0x40, 0x4E, 0xF4, 0xF3, 
                /* 0888 */    0x09, 0x44, 0xE2, 0x81, 0x68, 0x10, 0xE4, 0x3F, 
                /* 0890 */    0x21, 0x20, 0x67, 0x04, 0x11, 0x10, 0x79, 0x12, 
                /* 0898 */    0x05, 0x21, 0x9A, 0x3E, 0x62, 0x02, 0x71, 0x6A, 
                /* 08A0 */    0x10, 0x9A, 0xEC, 0x27, 0x14, 0x84, 0xFC, 0xFF, 
                /* 08A8 */    0x01
            })
        }

        Device (PCI0)
        {
            Name (_ADR, 0x00)
            Name (_HID, EisaId ("PNP0A08"))
            Name (_CID, 0x030AD041)
            Name (_UID, 0x01)
            Name (SUPP, 0x00)
            Name (CTRL, 0x00)
            Method (_OSC, 4, NotSerialized)
            {
                If (LEqual (Arg0, Buffer (0x10)
                        {
                            /* 0000 */    0x5B, 0x4D, 0xDB, 0x33, 0xF7, 0x1F, 0x1C, 0x40, 
                            /* 0008 */    0x96, 0x57, 0x74, 0x41, 0xC0, 0x3D, 0xD7, 0x66
                        }))
                {
                    CreateDWordField (Arg3, 0x00, CDW1)
                    CreateDWordField (Arg3, 0x04, CDW2)
                    CreateDWordField (Arg3, 0x08, CDW3)
                    Store (CDW2, SUPP)
                    Store (CDW3, CTRL)
                    If (LNotEqual (And (SUPP, 0x16), 0x16))
                    {
                        And (CTRL, 0x1E)
                    }

                    And (CTRL, 0x10, CTRL)
                    If (Not (And (CDW1, 0x01)))
                    {
                        If (And (CTRL, 0x01))
                        {
                            Store (0x01, \_SB.PCI0.XVR2.EPDS)
                            Store (0x01, \_SB.PCI0.XVR2.EPDS)
                        }
                    }

                    If (LNotEqual (Arg1, One))
                    {
                        Or (CDW1, 0x08, CDW1)
                    }

                    If (LNotEqual (CDW3, CTRL))
                    {
                        Or (CDW1, 0x10, CDW1)
                    }

                    Store (CTRL, CDW3)
                    Return (Arg3)
                }
                Else
                {
                    Or (CDW1, 0x04, CDW1)
                    Return (Arg3)
                }
            }

            Method (_INI, 0, NotSerialized)
            {
                Store (0x07D0, OSYS)
                If (CondRefOf (\_OSI, Local0))
                {
                    If (\_OSI ("Linux"))
                    {
                        Store (0x03E8, OSYS)
                    }

                    If (\_OSI ("Windows 2001"))
                    {
                        Store (0x07D1, OSYS)
                    }

                    If (\_OSI ("Windows 2001 SP1"))
                    {
                        Store (0x07D1, OSYS)
                    }

                    If (\_OSI ("Windows 2001 SP2"))
                    {
                        Store (0x07D2, OSYS)
                    }

                    If (\_OSI ("Windows 2006"))
                    {
                        Store (0x07D6, OSYS)
                    }
                }

                Store (0x00, CTDC)
                Store (0x73, \_SB.PCI0.SMIC)
                Sleep (0x05)
            }

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Scope (\_SB)
            {
                OperationRegion (ASLD, SystemMemory, 0x77F0ADBC, 0x00000100)
                Field (ASLD, AnyAcc, NoLock, Preserve)
                {
                    TOM,    32, 
                    R_ST,   1, 
                        ,   3, 
                    R_P0,   4, 
                    R_S0,   4, 
                    R_S1,   4, 
                    RSS0,   4, 
                    RSS1,   4, 
                    PSTN,   8, 
                    DUAL,   8, 
                    IVIM,   8, 
                    ACBR,   8, 
                    DCBR,   8, 
                    WC01,   8, 
                    SID0,   8, 
                    SID1,   8, 
                    SID2,   8, 
                    SID3,   8, 
                    SID4,   8, 
                    EAX0,   32, 
                    EBX0,   32, 
                    CCBR,   8, 
                    ACST,   8, 
                    PLTY,   8, 
                    CPUT,   16, 
                    AMDP,   8, 
                    TMPO,   8, 
                    CPUF,   8, 
                    USBW,   8, 
                    CTKY,   32
                }
            }

            Method (_CRS, 0, NotSerialized)
            {
                Name (CBUF, ResourceTemplate ()
                {
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x00FF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0100,             // Length
                        ,, )
                    IO (Decode16,
                        0x0CF8,             // Range Minimum
                        0x0CF8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x0CF7,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0CF8,             // Length
                        ,, , TypeStatic)
                    WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x0000,             // Granularity
                        0x0D00,             // Range Minimum
                        0xFFFF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0xF300,             // Length
                        ,, , TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000A0000,         // Range Minimum
                        0x000BFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00020000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C0000,         // Range Minimum
                        0x000C3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C4000,         // Range Minimum
                        0x000C7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C8000,         // Range Minimum
                        0x000CBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000CC000,         // Range Minimum
                        0x000CFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D0000,         // Range Minimum
                        0x000D3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D4000,         // Range Minimum
                        0x000D7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D8000,         // Range Minimum
                        0x000DBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000DC000,         // Range Minimum
                        0x000DFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E0000,         // Range Minimum
                        0x000E3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E4000,         // Range Minimum
                        0x000E7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E8000,         // Range Minimum
                        0x000EBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000EC000,         // Range Minimum
                        0x000EFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000F0000,         // Range Minimum
                        0x000FFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00010000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x00100000,         // Range Minimum
                        0xFEBFFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0xFFF00000,         // Length
                        ,, _Y01, AddressRangeMemory, TypeStatic)
                })
                CreateDWordField (CBUF, \_SB.PCI0._CRS._Y01._MIN, PMMN)
                CreateDWordField (CBUF, \_SB.PCI0._CRS._Y01._LEN, PMLN)
                Multiply (\_SB.TOM, 0x00100000, PMMN)
                Subtract (0xFEC00000, PMMN, PMLN)
                Return (CBUF)
            }

            Name (_PRT, Package (0x0D)
            {
                Package (0x04)
                {
                    0x000AFFFF, 
                    0x00, 
                    \_SB.PCI0.LSMB, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000AFFFF, 
                    0x01, 
                    \_SB.PCI0.LPMU, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000BFFFF, 
                    0x00, 
                    \_SB.PCI0.LUS0, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000BFFFF, 
                    0x01, 
                    \_SB.PCI0.LUS2, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x00, 
                    \_SB.PCI0.LMAC, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0010FFFF, 
                    0x01, 
                    \_SB.PCI0.LAZA, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000DFFFF, 
                    0x00, 
                    \_SB.PCI0.LPID, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000EFFFF, 
                    0x00, 
                    \_SB.PCI0.LTID, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000FFFFF, 
                    0x00, 
                    \_SB.PCI0.LSI1, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x00, 
                    \_SB.PCI0.LK3E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x01, 
                    \_SB.PCI0.LK4E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x02, 
                    \_SB.PCI0.LK1E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x03, 
                    \_SB.PCI0.LK2E, 
                    0x00
                }
            })
            Device (LPC0)
            {
                Name (_ADR, 0x000A0000)
                OperationRegion (P44, PCI_Config, 0x44, 0x04)
                Field (P44, DWordAcc, NoLock, Preserve)
                {
                    MTBA,   32
                }

                OperationRegion (P74, PCI_Config, 0x74, 0x04)
                Field (P74, AnyAcc, NoLock, Preserve)
                {
                    HPTF,   16
                }

                Device (MBRD)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x1F)
                    Name (RSRC, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0xE0000000,         // Address Base
                            0x10000000,         // Address Length
                            )
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (RSRC)
                    }
                }

                Device (PMIO)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x03)
                    Method (_CRS, 0, NotSerialized)
                    {
                        Name (IODM, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x00,               // Alignment
                                0x00,               // Length
                                )
                        })
                        Name (IORT, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y02)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y03)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y04)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y05)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y06)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y07)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x40,               // Length
                                _Y08)
                        })
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y02._MIN, I1MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y02._MAX, I1MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y03._MIN, I2MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y03._MAX, I2MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y04._MIN, I3MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y04._MAX, I3MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y05._MIN, I4MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y05._MAX, I4MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y06._MIN, I5MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y06._MAX, I5MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y07._MIN, I6MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y07._MAX, I6MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y08._MIN, I9MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y08._MAX, I9MX)
                        And (\_SB.PCI0.SMB0.PMBR, 0xFFFC, I1MN)
                        Store (I1MN, I1MX)
                        Add (I1MN, 0x80, Local0)
                        Store (Local0, I2MN)
                        Store (Local0, I2MX)
                        And (\_SB.PCI0.SMB0.NVSB, 0xFFFC, I3MN)
                        Store (I3MN, I3MX)
                        Add (I3MN, 0x80, Local0)
                        Store (Local0, I4MN)
                        Store (Local0, I4MX)
                        And (\_SB.PCI0.SMB0.ANLG, 0xFFFC, I5MN)
                        Store (I5MN, I5MX)
                        Add (I5MN, 0x80, Local0)
                        Store (Local0, I6MN)
                        Store (Local0, I6MX)
                        And (\_SB.PCI0.SMB0.SB7C, 0xFFFC, I9MN)
                        Store (I9MN, I9MX)
                        If (I1MN)
                        {
                            Store (IORT, Local0)
                        }
                        Else
                        {
                            Store (IODM, Local0)
                        }

                        Return (Local0)
                    }
                }
            }

            OperationRegion (SSMI, SystemIO, 0x142E, 0x02)
            Field (SSMI, ByteAcc, NoLock, Preserve)
            {
                SMIC,   8, 
                SMIS,   8
            }

            Mutex (PSMX, 0x00)
            Method (PHSR, 2, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                Store (Arg1, SMIS)
                Store (Arg0, SMIC)
                Store (SMIS, Local0)
                Sleep (0x05)
                Release (PSMX)
                Return (Local0)
            }

            Device (SYS0)
            {
                Name (_HID, EisaId ("PNP0C02"))
                Name (_UID, 0x01)
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0010,             // Range Minimum
                        0x0010,             // Range Maximum
                        0x01,               // Alignment
                        0x10,               // Length
                        )
                    IO (Decode16,
                        0x0022,             // Range Minimum
                        0x0022,             // Range Maximum
                        0x01,               // Alignment
                        0x1E,               // Length
                        )
                    IO (Decode16,
                        0x0044,             // Range Minimum
                        0x0044,             // Range Maximum
                        0x01,               // Alignment
                        0x1C,               // Length
                        )
                    IO (Decode16,
                        0x0063,             // Range Minimum
                        0x0063,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0065,             // Range Minimum
                        0x0065,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0067,             // Range Minimum
                        0x0067,             // Range Maximum
                        0x01,               // Alignment
                        0x09,               // Length
                        )
                    IO (Decode16,
                        0x0072,             // Range Minimum
                        0x0072,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0074,             // Range Minimum
                        0x0074,             // Range Maximum
                        0x01,               // Alignment
                        0x0C,               // Length
                        )
                    IO (Decode16,
                        0x0080,             // Range Minimum
                        0x0080,             // Range Maximum
                        0x00,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0091,             // Range Minimum
                        0x0091,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x0097,             // Range Minimum
                        0x0097,             // Range Maximum
                        0x01,               // Alignment
                        0x09,               // Length
                        )
                    IO (Decode16,
                        0x00A2,             // Range Minimum
                        0x00A2,             // Range Maximum
                        0x01,               // Alignment
                        0x1E,               // Length
                        )
                    IO (Decode16,
                        0x00E0,             // Range Minimum
                        0x00E0,             // Range Maximum
                        0x01,               // Alignment
                        0x10,               // Length
                        )
                    IO (Decode16,
                        0x0360,             // Range Minimum
                        0x0360,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0380,             // Range Minimum
                        0x0380,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IO (Decode16,
                        0x04D0,             // Range Minimum
                        0x04D0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                })
            }

            Device (PIC0)
            {
                Name (_HID, EisaId ("PNP0000"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0020,             // Range Minimum
                        0x0020,             // Range Maximum
                        0x04,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00A0,             // Range Minimum
                        0x00A0,             // Range Maximum
                        0x04,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {2}
                })
            }

            Device (DMA0)
            {
                Name (_HID, EisaId ("PNP0200"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0000,             // Range Minimum
                        0x0000,             // Range Maximum
                        0x01,               // Alignment
                        0x09,               // Length
                        )
                    IO (Decode16,
                        0x000A,             // Range Minimum
                        0x000A,             // Range Maximum
                        0x01,               // Alignment
                        0x06,               // Length
                        )
                    IO (Decode16,
                        0x0081,             // Range Minimum
                        0x0081,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x0087,             // Range Minimum
                        0x0087,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0089,             // Range Minimum
                        0x0089,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x008F,             // Range Minimum
                        0x008F,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x00C0,             // Range Minimum
                        0x00C0,             // Range Maximum
                        0x01,               // Alignment
                        0x12,               // Length
                        )
                    IO (Decode16,
                        0x00D4,             // Range Minimum
                        0x00D4,             // Range Maximum
                        0x01,               // Alignment
                        0x0C,               // Length
                        )
                    DMA (Compatibility, BusMaster, Transfer8, )
                        {4}
                })
            }

            Device (SPK0)
            {
                Name (_HID, EisaId ("PNP0800"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0061,             // Range Minimum
                        0x0061,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                })
            }

            Device (MTH0)
            {
                Name (_HID, EisaId ("PNP0C04"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x00F0,             // Range Minimum
                        0x00F0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {13}
                })
            }

            Device (PIT0)
            {
                Name (_HID, EisaId ("PNP0100"))
                Name (BUF0, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0040,             // Range Minimum
                        0x0040,             // Range Maximum
                        0x00,               // Alignment
                        0x04,               // Length
                        )
                })
                Name (BUF1, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0040,             // Range Minimum
                        0x0040,             // Range Maximum
                        0x00,               // Alignment
                        0x04,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {0}
                })
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (BUF0)
                    }
                    Else
                    {
                        Return (BUF1)
                    }
                }
            }

            Device (RTC0)
            {
                Name (_HID, EisaId ("PNP0B00"))
                Name (BUF2, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0070,             // Range Minimum
                        0x0070,             // Range Maximum
                        0x00,               // Alignment
                        0x02,               // Length
                        )
                })
                Name (BUF3, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0070,             // Range Minimum
                        0x0070,             // Range Maximum
                        0x00,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {8}
                })
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (BUF2)
                    }
                    Else
                    {
                        Return (BUF3)
                    }
                }
            }

            Device (MMTM)
            {
                Name (_HID, EisaId ("PNP0103"))
                Name (BUF4, ResourceTemplate ()
                {
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {0}
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {8}
                    Memory32Fixed (ReadOnly,
                        0x00000000,         // Address Base
                        0x00000400,         // Address Length
                        _Y09)
                })
                Name (BUF5, ResourceTemplate ()
                {
                })
                Method (_STA, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (0x0F)
                    }

                    Return (0x00)
                }

                CreateDWordField (BUF4, \_SB.PCI0.MMTM._Y09._BAS, MMBB)
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Store (\_SB.PCI0.LPC0.MTBA, MMBB)
                        Return (BUF4)
                    }
                    Else
                    {
                        Return (BUF5)
                    }
                }
            }

            Device (KBC0)
            {
                Name (_HID, EisaId ("PNP0303"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0060,             // Range Minimum
                        0x0060,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0064,             // Range Minimum
                        0x0064,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {1}
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, KWCP)
                    }
                    Else
                    {
                        Store (0x00, KWCP)
                    }

                    Sleep (0x07D0)
                }
            }

            Device (MSE0)
            {
                Method (_HID, 0, NotSerialized)
                {
                    Return ("*SYN014C")
                }

                Name (_CID, Package (0x03)
                {
                    0x00012E4F, 
                    0x02002E4F, 
                    0x130FD041
                })
                Name (_CRS, ResourceTemplate ()
                {
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {12}
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, MWCP)
                    }
                    Else
                    {
                        Store (0x00, MWCP)
                    }

                    Sleep (0x07D0)
                }
            }

            Device (EC0)
            {
                Name (_HID, EisaId ("PNP0C09"))
                Name (_UID, 0x01)
                Name (_GPE, 0x10)
                Name (POLL, 0x05)
                Name (TBEL, 0x00)
                Method (_CRS, 0, NotSerialized)
                {
                    Name (BFFR, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0062,             // Range Minimum
                            0x0062,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0066,             // Range Minimum
                            0x0066,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                    })
                    Return (BFFR)
                }

                OperationRegion (ERAM, EmbeddedControl, 0x00, 0xFF)
                Field (ERAM, ByteAcc, Lock, Preserve)
                {
                    SMPR,   8, 
                    SMST,   8, 
                    SMAD,   8, 
                    SMCM,   8, 
                    SMD0,   256, 
                    BCNT,   8, 
                    SMAA,   8, 
                    BATD,   16, 
                            Offset (0x40), 
                    ACIN,   1, 
                            Offset (0x41), 
                        ,   4, 
                    FANC,   1, 
                    BLED,   1, 
                    AADA,   1, 
                            Offset (0x42), 
                            Offset (0x43), 
                    BBDA,   1, 
                        ,   3, 
                    BANK,   4, 
                            Offset (0x45), 
                    VFAN,   1, 
                    ISEN,   1, 
                    KBEP,   1, 
                    ASCN,   1, 
                    ALIN,   1, 
                            Offset (0x4E), 
                    LIDP,   1, 
                    DT1P,   1, 
                    ODDW,   1, 
                    TLDP,   1, 
                        ,   1, 
                        ,   1, 
                        ,   1, 
                            Offset (0x4F), 
                            Offset (0x52), 
                    LIDS,   1, 
                    DT1I,   1, 
                    ODDI,   1, 
                    TLID,   1, 
                    RBAT,   1, 
                    CRTS,   1, 
                    ABTN,   1, 
                    DBAY,   1, 
                            Offset (0x58), 
                    RTMP,   8, 
                    ECT1,   8, 
                    ECT2,   8, 
                    RG5B,   8, 
                    FSPD,   16, 
                            Offset (0x61), 
                    QPDD,   8, 
                            Offset (0x70), 
                    DDCP,   16, 
                    BFCC,   16, 
                    DDVO,   16, 
                            Offset (0x82), 
                    MBST,   8, 
                    MCUR,   16, 
                    MBRM,   16, 
                    MBCV,   16, 
                            Offset (0xA0), 
                    QBHK,   8, 
                        ,   5, 
                    TFAN,   1, 
                            Offset (0xA2), 
                    QBBB,   8, 
                            Offset (0xA4), 
                    MBTS,   1, 
                    MBTF,   1, 
                    BDES,   1, 
                    BTRK,   1, 
                    BARM,   1, 
                    BLOW,   1, 
                    BDIS,   1, 
                    BDED,   1, 
                        ,   3, 
                    NIMH,   1, 
                            Offset (0xAF), 
                    Q8CI,   1, 
                    Q8CO,   1, 
                    Q8DI,   1, 
                    Q8DO,   1, 
                    Q8EI,   1, 
                    Q8EO,   1, 
                    Q8FI,   1, 
                    Q8FO,   1, 
                            Offset (0xB2), 
                    RPM1,   8, 
                    RPM2,   8, 
                            Offset (0xC0), 
                    BRID,   8, 
                            Offset (0xD1), 
                    PWRE,   1, 
                            Offset (0xD4), 
                    PALL,   8, 
                    PCUR,   8, 
                    DDD0,   1, 
                    DDD1,   1, 
                            Offset (0xDB), 
                    KBWK,   1, 
                    MUWK,   1, 
                            Offset (0xE0), 
                    DTMC,   8, 
                            Offset (0xE2), 
                    BRIC,   8, 
                            Offset (0xE6), 
                    SFHK,   8, 
                    GQKS,   7
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    SMW0,   16
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    SMB0,   8
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD0,   64
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD1,   128
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD2,   192
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD3,   256
                }

                Name (BATO, 0x00)
                Name (BATN, 0x00)
                Name (BATF, 0xC0)
                Mutex (MUT0, 0x00)
                Mutex (MUT1, 0x00)
                Method (_REG, 2, NotSerialized)
                {
                    If (LAnd (LEqual (Arg0, 0x03), LEqual (Arg1, 0x01)))
                    {
                        Store (0x01, ECON)
                        Store (0x14, DTMC)
                    }
                }

                Method (_Q09, 0, NotSerialized)
                {
                    If (LNotEqual (\_SB.CPUF, 0x5A))
                    {
                        Store (0x00, Local0)
                        Store (0x00, Local1)
                        Store (0x00, Local2)
                        Or (Local2, LEqual (\_SB.DUAL, 0x01), Local2)
                        Or (Local2, LEqual (\_SB.CPUT, 0x0587), Local2)
                        Or (Local2, LEqual (\_SB.CPUT, 0x0589), Local2)
                        If (LNotEqual (Local2, 0x00))
                        {
                            Store (ACIN, Local0)
                            Store (0x00, Local1)
                            If (Local0)
                            {
                                \_SB.PCI0.PHSR (0x8F, 0x02)
                                \_SB.PCI0.PHSR (0x8A, 0x01)
                                Store (0x00, DTMC)
                                Store (0x00, PST0)
                                Store (0x00, B800)
                                \_SB.Z01H ()
                            }
                            Else
                            {
                                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                                Store (0x8E, \_SB.PCI0.SMIC)
                                Sleep (0x05)
                                Release (\_SB.PCI0.PSMX)
                                Store (\_SB.PCI0.SMIS, Local1)
                                If (Local1)
                                {
                                    Store (0x00, DTMC)
                                    Sleep (0x01F4)
                                    \_SB.PCI0.PHSR (0x8F, 0x01)
                                }
                                Else
                                {
                                    Store (POLL, DTMC)
                                }

                                Store (0x01, B800)
                                If (LEqual (\_SB.PSTN, 0x01))
                                {
                                    Store (\_SB.PSTN, PST0)
                                    \_SB.Z01H ()
                                }
                                Else
                                {
                                    Subtract (\_SB.PSTN, 0x01, PST0)
                                    \_SB.Z01H ()
                                }
                            }
                        }
                        Else
                        {
                            \_SB.PCI0.PHSR (0x8A, 0x00)
                            \_SB.PCI0.PHSR (0x8F, 0x01)
                            Store (0x00, DTMC)
                        }
                    }
                    Else
                    {
                        Store (0x00, DTMC)
                    }
                }

                Method (_Q20, 0, NotSerialized)
                {
                    Notify (\_SB.BAT0, 0x80)
                    Notify (\_SB.BAT0, 0x81)
                }

                Method (_Q21, 0, NotSerialized)
                {
                    If (LNotEqual (\_SB.CPUF, 0x5A))
                    {
                        Store (0x00, Local0)
                        Store (0x00, Local1)
                        Or (Local1, LEqual (\_SB.DUAL, 0x01), Local1)
                        Or (Local1, LEqual (\_SB.CPUT, 0x0587), Local1)
                        Or (Local1, LEqual (\_SB.CPUT, 0x0589), Local1)
                        If (LNotEqual (Local1, 0x00))
                        {
                            Store (ACIN, Local0)
                            If (Local0)
                            {
                                \_SB.PCI0.PHSR (0x8F, 0x02)
                                Sleep (0x64)
                                Store (0x00, PST0)
                                Store (0x00, B800)
                                \_SB.Z01H ()
                                \_SB.PCI0.PHSR (0x8A, 0x01)
                                Store (0x00, DTMC)
                            }
                            Else
                            {
                                Store (0x01, B800)
                                If (LEqual (\_SB.PSTN, 0x01))
                                {
                                    Store (\_SB.PSTN, PST0)
                                    \_SB.Z01H ()
                                }
                                Else
                                {
                                    Subtract (\_SB.PSTN, 0x01, PST0)
                                    \_SB.Z01H ()
                                }

                                Store (POLL, DTMC)
                            }
                        }
                    }

                    If (LNotEqual (OSYS, 0x07D6))
                    {
                        RSBR ()
                    }

                    Notify (\_SB.ACAD, 0x80)
                    Notify (\_SB.BAT0, 0x80)
                }

                Method (_Q0D, 0, NotSerialized)
                {
                    If (VGAT)
                    {
                        VSWT ()
                    }
                    Else
                    {
                        VSWU ()
                    }
                }

                Method (_Q10, 0, NotSerialized)
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Notify (\_SB.PCI0.UVGA.LCD, 0x87)
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8D, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (_Q11, 0, NotSerialized)
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Notify (\_SB.PCI0.UVGA.LCD, 0x86)
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8C, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (_Q15, 0, NotSerialized)
                {
                    Store ("!!! Wireless Button pressed !!!", Debug)
                    Acquire (M723, 0xFFFF)
                    If (LOr (BTSU, WLSU))
                    {
                        If (And (WC01, 0x08))
                        {
                            And (WC01, 0xF7, WC01)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                            Store (0x00, WWAN)
                            Store (0x04, PCQ3)
                        }
                        Else
                        {
                            Or (WC01, 0x08, WC01)
                            If (WLSU)
                            {
                                If (WIRE)
                                {
                                    If (And (WC01, 0x10))
                                    {
                                        Store (0x01, GP26)
                                        Store (0x05, GP23)
                                    }
                                }
                                Else
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                            }

                            If (BTSU)
                            {
                                If (WIRE)
                                {
                                    If (And (WC01, 0x20))
                                    {
                                        Store (0x01, GP25)
                                        Store (0x05, GP24)
                                    }
                                }
                                Else
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                            }

                            If (WIRE)
                            {
                                If (And (WC01, 0x40))
                                {
                                    Store (0x01, WWAN)
                                    Store (0x05, PCQ3)
                                }
                            }
                            Else
                            {
                                Store (0x01, WWAN)
                                Store (0x05, PCQ3)
                            }
                        }
                    }
                    Else
                    {
                        And (WC01, 0xF7, WC01)
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                        Store (0x00, WWAN)
                        Store (0x04, PCQ3)
                    }

                    Release (M723)
                    Store (0x05, \_SB.WMID.Z01C)
                    Store (0x00, \_SB.WMID.Z01D)
                    Notify (\_SB.WMID, 0x80)
                }

                Method (_Q16, 0, NotSerialized)
                {
                    Store (QBBB, Local0)
                    If (LEqual (Local0, 0x03))
                    {
                        Notify (\_SB.MUBN, 0x02)
                        Return (0x00)
                    }

                    If (LEqual (Local0, 0x06))
                    {
                        Notify (\_SB.PIBN, 0x02)
                        Return (0x00)
                    }

                    If (LEqual (Local0, 0x12))
                    {
                        Notify (\_SB.LVBN, 0x02)
                        Return (0x00)
                    }

                    Store (0x04, \_SB.WMID.Z01C)
                    Store (0x00, \_SB.WMID.Z01D)
                    Notify (\_SB.WMID, 0x80)
                }

                Method (_Q80, 0, NotSerialized)
                {
                    Store ("_Q80 : Temperature Up", Debug)
                    Notify (\_TZ.THRM, 0x80)
                    \_TZ.THRM.Z01I (RTMP)
                }

                Method (_Q81, 0, NotSerialized)
                {
                    Store ("_Q81 : Temperature Down", Debug)
                }

                Method (_Q8A, 0, NotSerialized)
                {
                    If (LIDP)
                    {
                        Store ("_Q8A : Lid Event", Debug)
                        Notify (\_SB.LID, 0x80)
                        Store (0x00, LIDP)
                    }

                    If (ODDW)
                    {
                        If (ODDI)
                        {
                            And (\_SB.PCI0.SMB0.PTRI, 0xFFDFFFFF, \_SB.PCI0.SMB0.PTRI)
                            Store (0x04, GP54)
                            Store (0x05, GP49)
                            Store (0x05, Z01J)
                            Sleep (0x32)
                            Store (0x05, GP54)
                            Sleep (0x03E8)
                            Store (0x00, BAYO)
                            Notify (\_SB.PCI0.IDE0.PRI0, 0x00)
                            Sleep (0x03E8)
                            Notify (\_SB.PCI0.IDE0.PRI0.MAST, 0x01)
                        }
                        Else
                        {
                            Store (0x01, BAYO)
                            Or (\_SB.PCI0.SMB0.PTRI, 0x00200000, \_SB.PCI0.SMB0.PTRI)
                            Store (0x04, GP49)
                            Store (0x04, Z01J)
                            Store (0x04, GP54)
                            Sleep (0x0A)
                            Notify (\_SB.PCI0.IDE0.PRI0, 0x00)
                            Sleep (0x03E8)
                            Notify (\_SB.PCI0.IDE0.PRI0.MAST, 0x01)
                        }

                        Store (0x00, ODDW)
                    }

                    If (TLDP)
                    {
                        Store (0x01, \_SB.WMID.Z01C)
                        Store (0x00, \_SB.WMID.Z01D)
                        Notify (\_SB.WMID, 0x80)
                        Store (0x00, TLDP)
                    }
                }

                Method (_Q88, 0, NotSerialized)
                {
                    If (LLess (Q880, \_SB.PSTN))
                    {
                        Increment (Q880)
                    }

                    \_SB.Z01H ()
                    Store (Q880, PCUR)
                }

                Method (_Q89, 0, NotSerialized)
                {
                    If (LGreater (Q880, 0x00))
                    {
                        Decrement (Q880)
                    }

                    \_SB.Z01H ()
                    Store (Q880, PCUR)
                }

                Method (_Q8C, 0, NotSerialized)
                {
                    Store (\_SB.PSTN, Q8C0)
                    \_SB.Z01H ()
                    Store (0x01, Q8CO)
                }

                Method (_Q8D, 0, NotSerialized)
                {
                    Store (0x00, Q8C0)
                    \_SB.Z01H ()
                    Store (0x01, Q8DO)
                }

                Method (_Q8E, 0, NotSerialized)
                {
                    Store (\_SB.PSTN, Q8E0)
                    \_SB.Z01H ()
                    Store (0x01, Q8EO)
                }

                Method (_Q8F, 0, NotSerialized)
                {
                    Store (0x00, Q8E0)
                    \_SB.Z01H ()
                    Store (0x01, Q8FO)
                }

                Method (VSWT, 0, NotSerialized)
                {
                    Store ("Hot-Keys: ----- _Q0C", Debug)
                    If (LEqual (\_SB.PCI0.XVR0.VGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x88, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                        Store (Local0, CADL)
                        If (LEqual (Local0, 0x10)) {}
                        Else
                        {
                            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                            Store (0x87, \_SB.PCI0.SMIC)
                            Store (\_SB.PCI0.SMIS, Local1)
                            Sleep (0x05)
                            Release (\_SB.PCI0.PSMX)
                            Store (Local1, PSTE)
                            If (LEqual (Local1, 0x05))
                            {
                                Store (Zero, Local1)
                            }

                            Store (Local1, \_SB.PCI0.XVR0.VGA.TOGF)
                            Increment (\_SB.PCI0.XVR0.VGA.TOGF)
                            While (LNotEqual (And (Local0, \_SB.PCI0.XVR0.VGA.TOGF), \_SB.PCI0.XVR0.VGA.TOGF))
                            {
                                Increment (\_SB.PCI0.XVR0.VGA.TOGF)
                                If (LGreater (\_SB.PCI0.XVR0.VGA.TOGF, 0x05))
                                {
                                    Store (One, \_SB.PCI0.XVR0.VGA.TOGF)
                                }
                            }

                            If (LEqual (CADL, 0x07))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x04, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x05, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x03))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x05))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x04, NSTE)
                                }
                            }

                            Store (\_SB.PCI0.XVR0.VGA.TOGF, Local0)
                            Store (Local0, CSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            }

                            Notify (\_SB.PCI0.XVR0.VGA, 0x80)
                        }
                    }
                    Else
                    {
                    }
                }

                Method (VSWU, 0, NotSerialized)
                {
                    Store ("Hot-Keys: ----- _Q0C", Debug)
                    If (LEqual (\_SB.PCI0.UVGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x88, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                        Store (Local0, CADL)
                        If (LEqual (Local0, 0x10)) {}
                        Else
                        {
                            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                            Store (0x87, \_SB.PCI0.SMIC)
                            Store (\_SB.PCI0.SMIS, Local1)
                            Sleep (0x05)
                            Release (\_SB.PCI0.PSMX)
                            Store (Local1, PSTE)
                            If (LEqual (Local1, 0x05))
                            {
                                Store (Zero, Local1)
                            }

                            Store (Local1, \_SB.PCI0.UVGA.TOGF)
                            Increment (\_SB.PCI0.UVGA.TOGF)
                            While (LNotEqual (And (Local0, \_SB.PCI0.UVGA.TOGF), \_SB.PCI0.UVGA.TOGF))
                            {
                                Increment (\_SB.PCI0.UVGA.TOGF)
                                If (LGreater (\_SB.PCI0.UVGA.TOGF, 0x05))
                                {
                                    Store (One, \_SB.PCI0.UVGA.TOGF)
                                }
                            }

                            If (LEqual (CADL, 0x07))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x04, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x05, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x03))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x05))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x04, NSTE)
                                }
                            }

                            Store (\_SB.PCI0.UVGA.TOGF, Local0)
                            Store (Local0, CSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                            }

                            Notify (\_SB.PCI0.UVGA, 0x80)
                        }
                    }
                    Else
                    {
                    }
                }

                Method (RSBR, 0, NotSerialized)
                {
                    If (LNotEqual (OSYS, 0x07D6))
                    {
                        PRTH ()
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8B, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Sleep (0x05)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (PRTH, 0, NotSerialized)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    If (\_SB.PCI0.EC0.ACIN)
                    {
                        Acquire (M723, 0xFFFF)
                        Store (ACBN, BRNS)
                        Release (M723)
                    }
                    Else
                    {
                        Acquire (M723, 0xFFFF)
                        Store (BABN, BRNS)
                        Release (M723)
                    }

                    Release (\_SB.PCI0.EC0.MUT0)
                }

                Method (SMRD, 4, NotSerialized)
                {
                    If (LNot (ECON))
                    {
                        Return (0xFF)
                    }

                    If (LNotEqual (Arg0, 0x07))
                    {
                        If (LNotEqual (Arg0, 0x09))
                        {
                            If (LNotEqual (Arg0, 0x0B))
                            {
                                Return (0x19)
                            }
                        }
                    }

                    Acquire (MUT0, 0xFFFF)
                    Store (0x04, Local0)
                    While (LGreater (Local0, 0x01))
                    {
                        Sleep (0x02)
                        And (SMST, 0x40, SMST)
                        Sleep (0x02)
                        Store (Arg2, SMCM)
                        Sleep (0x02)
                        Store (Arg1, SMAD)
                        Sleep (0x02)
                        Store (Arg0, SMPR)
                        Sleep (0x02)
                        Store (0x00, Local3)
                        While (LNot (And (SMST, 0xBF, Local1)))
                        {
                            Sleep (0x02)
                            Increment (Local3)
                            If (LEqual (Local3, 0x32))
                            {
                                Sleep (0x02)
                                And (SMST, 0x40, SMST)
                                Sleep (0x02)
                                Store (Arg2, SMCM)
                                Sleep (0x02)
                                Store (Arg1, SMAD)
                                Sleep (0x02)
                                Store (Arg0, SMPR)
                                Sleep (0x02)
                                Store (0x00, Local3)
                            }
                        }

                        If (LEqual (Local1, 0x80))
                        {
                            Store (0x00, Local0)
                        }
                        Else
                        {
                            Decrement (Local0)
                        }
                    }

                    If (Local0)
                    {
                        Store (And (Local1, 0x1F), Local0)
                    }
                    Else
                    {
                        If (LEqual (Arg0, 0x07))
                        {
                            Store (SMB0, Arg3)
                        }

                        If (LEqual (Arg0, 0x09))
                        {
                            Store (SMW0, Arg3)
                        }

                        If (LEqual (Arg0, 0x0B))
                        {
                            Sleep (0x02)
                            Store (BCNT, Local3)
                            ShiftRight (0x0100, 0x03, Local2)
                            If (LGreater (Local3, Local2))
                            {
                                Store (Local2, Local3)
                            }

                            If (LLess (Local3, 0x09))
                            {
                                Store (FLD0, Local2)
                            }
                            Else
                            {
                                If (LLess (Local3, 0x11))
                                {
                                    Store (FLD1, Local2)
                                }
                                Else
                                {
                                    If (LLess (Local3, 0x19))
                                    {
                                        Store (FLD2, Local2)
                                    }
                                    Else
                                    {
                                        Store (FLD3, Local2)
                                    }
                                }
                            }

                            Increment (Local3)
                            Store (Buffer (Local3) {}, Local4)
                            Decrement (Local3)
                            Store (Zero, Local5)
                            While (LGreater (Local3, Local5))
                            {
                                GBFE (Local2, Local5, RefOf (Local6))
                                PBFE (Local4, Local5, Local6)
                                Increment (Local5)
                            }

                            PBFE (Local4, Local5, 0x00)
                            Store (Local4, Arg3)
                        }
                    }

                    Release (MUT0)
                    Return (Local0)
                }

                Method (Z01E, 0, Serialized)
                {
                    If (ECON)
                    {
                        Store (SFHK, Local0)
                    }

                    Return (Local0)
                }

                Method (Z01F, 1, Serialized)
                {
                    If (ECON)
                    {
                        Store (Arg0, SFHK)
                    }
                }
            }

            Device (SMB0)
            {
                Name (_ADR, 0x000A0001)
                OperationRegion (SMCF, PCI_Config, 0x48, 0x04)
                Field (SMCF, AnyAcc, NoLock, Preserve)
                {
                    SB48,   4
                }

                OperationRegion (SBA0, PCI_Config, 0x20, 0x04)
                Field (SBA0, AnyAcc, NoLock, Preserve)
                {
                    SB20,   16
                }

                OperationRegion (SBA1, PCI_Config, 0x24, 0x04)
                Field (SBA1, AnyAcc, NoLock, Preserve)
                {
                    SB24,   16
                }

                OperationRegion (SBA2, PCI_Config, 0x7C, 0x04)
                Field (SBA2, AnyAcc, NoLock, Preserve)
                {
                    SB7C,   16
                }

                OperationRegion (P60, PCI_Config, 0x60, 0x02)
                Field (P60, AnyAcc, NoLock, Preserve)
                {
                    PMBR,   16
                }

                OperationRegion (P64, PCI_Config, 0x64, 0x02)
                Field (P64, AnyAcc, NoLock, Preserve)
                {
                    NVSB,   16
                }

                OperationRegion (P68, PCI_Config, 0x68, 0x02)
                Field (P68, AnyAcc, NoLock, Preserve)
                {
                    ANLG,   16
                }

                OperationRegion (CF58, PCI_Config, 0xE8, 0x04)
                Field (CF58, DWordAcc, NoLock, Preserve)
                {
                    PTRI,   32
                }
            }

            Device (USB0)
            {
                Name (_ADR, 0x000B0000)
                Method (_S1D, 0, NotSerialized)
                {
                    Return (0x01)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_PRW, 0, NotSerialized)
                {
                    If (\_SB.USBW)
                    {
                        Return (Package (0x02)
                        {
                            0x0D, 
                            0x03
                        })
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }

                Device (RH00)
                {
                    Name (_ADR, 0x00)
                    Device (PRT0)
                    {
                        Name (_ADR, 0x01)
                    }

                    Device (PRT1)
                    {
                        Name (_ADR, 0x02)
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x03)
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x04)
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x05)
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x06)
                        Name (_EJD, "_SB.PCI0.XVR2.X2S0")
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x07)
                    }

                    Device (PRT7)
                    {
                        Name (_ADR, 0x08)
                    }
                }
            }

            Device (USB2)
            {
                Name (_ADR, 0x000B0001)
                Method (_S1D, 0, NotSerialized)
                {
                    Return (0x01)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_PRW, 0, NotSerialized)
                {
                    If (\_SB.USBW)
                    {
                        Return (Package (0x02)
                        {
                            0x05, 
                            0x03
                        })
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }

                Device (RH00)
                {
                    Name (_ADR, 0x00)
                    Device (PRT0)
                    {
                        Name (_ADR, 0x01)
                    }

                    Device (PRT1)
                    {
                        Name (_ADR, 0x02)
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x03)
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x04)
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x05)
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x06)
                        Name (_EJD, "_SB.PCI0.XVR2.X2S0")
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x07)
                    }

                    Device (PRT7)
                    {
                        Name (_ADR, 0x08)
                    }
                }
            }

            Device (MAC0)
            {
                Name (_ADR, 0x00140000)
                Name (_PRW, Package (0x02)
                {
                    0x0B, 
                    0x05
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, LANV)
                    }
                    Else
                    {
                        Store (0x00, LANV)
                    }
                }
            }

            Device (AZA0)
            {
                Name (_ADR, 0x00100001)
                Method (_S1D, 0, NotSerialized)
                {
                    Return (0x01)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x01)
                }
            }

            Device (P2P0)
            {
                Name (_ADR, 0x00100000)
                Name (_UID, 0x02)
                OperationRegion (A080, PCI_Config, 0x19, 0x01)
                Field (A080, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x02)
                {
                    Package (0x04)
                    {
                        0x0005FFFF, 
                        0x00, 
                        \_SB.PCI0.LNK1, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x0005FFFF, 
                        0x01, 
                        \_SB.PCI0.LNK2, 
                        0x00
                    }
                })
            }

            Name (NATA, Package (0x01)
            {
                0x000D0000
            })
            Scope (\_SB.PCI0)
            {
                Device (NVRB)
                {
                    Name (_HID, "NVRAIDBUS")
                    Name (FNVR, 0xFF)
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, FNVR)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        If (LEqual (\_SB.R_ST, 0x01))
                        {
                            If (LEqual (FNVR, 0xFF))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x04D2,             // Range Minimum
                            0x04D2,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                }
            }

            Device (IDE0)
            {
                Name (SID4, 0x00)
                Name (SID5, 0x00)
                Name (SFLG, 0x00)
                Name (SID0, 0x00)
                Name (SID1, 0x00)
                Name (SID2, 0x00)
                Name (SID3, 0x00)
                Name (_ADR, 0x000D0000)
                OperationRegion (A090, PCI_Config, 0x50, 0x18)
                Field (A090, DWordAcc, NoLock, Preserve)
                {
                    ID20,   16, 
                            Offset (0x08), 
                    IDTS,   16, 
                    IDTP,   16, 
                    ID22,   32, 
                    UMSS,   16, 
                    UMSP,   16
                }

                Name (IDEP, Buffer (0x14) {})
                Name (IDES, Buffer (0x14) {})
                Method (GTM, 1, NotSerialized)
                {
                    If (LEqual (Arg0, 0x00))
                    {
                        Store (IDTP, Local0)
                        Store (UMSP, Local1)
                        Store (IDEP, Local2)
                    }
                    Else
                    {
                        Store (IDTS, Local0)
                        Store (UMSS, Local1)
                        Store (IDES, Local2)
                    }

                    CreateDWordField (Local2, 0x00, PIO0)
                    CreateDWordField (Local2, 0x04, DMA0)
                    CreateDWordField (Local2, 0x08, PIO1)
                    CreateDWordField (Local2, 0x0C, DMA1)
                    CreateDWordField (Local2, 0x10, FLAG)
                    Store (0x10, FLAG)
                    And (Local0, 0x0F00, Local3)
                    And (Local0, 0xF000, Local4)
                    ShiftRight (Local3, 0x08, Local3)
                    ShiftRight (Local4, 0x0C, Local4)
                    Add (Local3, Local4, Local3)
                    Multiply (Add (Local3, 0x02), 0x1E, PIO0)
                    If (LLessEqual (PIO0, 0xB4))
                    {
                        Or (FLAG, 0x02, FLAG)
                    }

                    If (And (Local1, 0x4000))
                    {
                        Or (FLAG, 0x01, FLAG)
                        And (Local1, 0x0700, Local3)
                        ShiftRight (Local3, 0x08, Local3)
                        Store (U2T (Local3), DMA0)
                    }
                    Else
                    {
                        Store (PIO0, DMA0)
                    }

                    And (Local0, 0x0F, Local3)
                    And (Local0, 0xF0, Local4)
                    ShiftRight (Local4, 0x04, Local4)
                    Add (Local3, Local4, Local3)
                    Multiply (Add (Local3, 0x02), 0x1E, PIO1)
                    If (LLessEqual (PIO1, 0xB4))
                    {
                        Or (FLAG, 0x08, FLAG)
                    }

                    If (And (Local1, 0x40))
                    {
                        Or (FLAG, 0x04, FLAG)
                        And (Local1, 0x07, Local3)
                        Store (U2T (Local3), DMA1)
                    }
                    Else
                    {
                        Store (PIO1, DMA1)
                    }

                    If (LEqual (Arg0, 0x00))
                    {
                        Store (Local2, IDEP)
                        Return (IDEP)
                    }
                    Else
                    {
                        Store (Local2, IDES)
                        Return (IDES)
                    }
                }

                Method (U2T, 1, NotSerialized)
                {
                    If (LEqual (Arg0, 0x00))
                    {
                        Return (0x3C)
                    }

                    If (LEqual (Arg0, 0x01))
                    {
                        Return (0x49)
                    }

                    If (LEqual (Arg0, 0x02))
                    {
                        Return (0x78)
                    }

                    If (LEqual (Arg0, 0x03))
                    {
                        Return (0x96)
                    }

                    If (LEqual (Arg0, 0x04))
                    {
                        Return (0x2D)
                    }

                    If (LEqual (Arg0, 0x05))
                    {
                        Return (0x1E)
                    }

                    If (LEqual (Arg0, 0x06))
                    {
                        Return (0x14)
                    }

                    Return (0x0F)
                }

                Method (T2U, 1, NotSerialized)
                {
                    If (LGreater (Arg0, 0x78))
                    {
                        Return (0x03)
                    }

                    If (LGreater (Arg0, 0x49))
                    {
                        Return (0x02)
                    }

                    If (LGreater (Arg0, 0x3C))
                    {
                        Return (0x01)
                    }

                    If (LGreater (Arg0, 0x2D))
                    {
                        Return (0x00)
                    }

                    If (LGreater (Arg0, 0x1E))
                    {
                        Return (0x04)
                    }

                    If (LGreater (Arg0, 0x14))
                    {
                        Return (0x05)
                    }

                    If (LGreater (Arg0, 0x0F))
                    {
                        Return (0x06)
                    }

                    Return (0x07)
                }

                Method (T2D, 1, NotSerialized)
                {
                    If (LGreater (Arg0, 0x01E0))
                    {
                        Return (0xA8)
                    }

                    If (LGreater (Arg0, 0x0186))
                    {
                        Return (0x77)
                    }

                    If (LGreater (Arg0, 0xF0))
                    {
                        Return (0x47)
                    }

                    If (LGreater (Arg0, 0xB4))
                    {
                        Return (0x33)
                    }

                    If (LGreater (Arg0, 0x96))
                    {
                        Return (0x22)
                    }

                    If (LGreater (Arg0, 0x78))
                    {
                        Return (0x21)
                    }

                    Return (0x20)
                }

                Method (STM, 4, NotSerialized)
                {
                    If (SX)
                    {
                        Store (SID0, ID20)
                        Store (SID1, IDTS)
                        Store (SID2, IDTP)
                        Store (SID3, ID22)
                        Store (SID4, UMSS)
                        Store (SID5, UMSP)
                    }
                    Else
                    {
                        Store (ID20, SID0)
                        Store (IDTS, SID1)
                        Store (IDTP, SID2)
                        Store (ID22, SID3)
                        Store (UMSS, SID4)
                        Store (UMSP, SID5)
                    }

                    Store (0x00, SX)
                    CreateDWordField (Arg0, 0x00, PIO0)
                    CreateDWordField (Arg0, 0x04, DMA0)
                    CreateDWordField (Arg0, 0x08, PIO1)
                    CreateDWordField (Arg0, 0x0C, DMA1)
                    CreateDWordField (Arg0, 0x10, FLAG)
                    If (LEqual (Arg3, 0x00))
                    {
                        Store (SID2, Local0)
                        Store (SID5, Local1)
                    }
                    Else
                    {
                        Store (SID1, Local0)
                        Store (SID4, Local1)
                    }

                    If (LNotEqual (PIO0, 0xFFFFFFFF))
                    {
                        And (Local0, 0xFF, Local0)
                        ShiftLeft (T2D (PIO0), 0x08, Local2)
                        Or (Local0, Local2, Local0)
                    }

                    If (LNotEqual (PIO1, 0xFFFFFFFF))
                    {
                        And (Local0, 0xFF00, Local0)
                        Or (Local0, T2D (PIO1), Local0)
                    }

                    If (And (FLAG, 0x01))
                    {
                        And (Local1, 0xFF, Local1)
                        ShiftLeft (T2U (DMA0), 0x08, Local2)
                        Or (0xC000, Local2, Local2)
                        Or (Local2, Local1, Local1)
                    }
                    Else
                    {
                        If (LNotEqual (DMA0, 0xFFFFFFFF))
                        {
                            And (Local0, 0xFF, Local0)
                            ShiftLeft (T2D (DMA0), 0x08, Local2)
                            Or (Local0, Local2, Local0)
                        }
                    }

                    If (And (FLAG, 0x04))
                    {
                        And (Local1, 0xFF00, Local1)
                        Or (0xC0, T2U (DMA1), Local2)
                        Or (Local2, Local1, Local1)
                    }
                    Else
                    {
                        If (LNotEqual (DMA1, 0xFFFFFFFF))
                        {
                            And (Local0, 0xFF00, Local0)
                            Or (Local0, T2D (DMA1), Local0)
                        }
                    }

                    If (LEqual (Arg3, 0x00))
                    {
                        Store (Local0, IDTP)
                        Store (Local1, UMSP)
                    }
                    Else
                    {
                        Store (Local0, IDTS)
                        Store (Local1, UMSS)
                    }
                }

                Method (GTF, 2, NotSerialized)
                {
                    Store (Buffer (0x07)
                        {
                            0x03, 0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF
                        }, Local0)
                    CreateByteField (Local0, 0x01, MODE)
                    CreateByteField (Local0, 0x05, DRIV)
                    Store (Arg1, DRIV)
                    If (LEqual (Arg0, 0x00))
                    {
                        Store (IDEP, Local1)
                    }
                    Else
                    {
                        Store (IDES, Local1)
                    }

                    CreateDWordField (Local1, 0x00, PIO0)
                    CreateDWordField (Local1, 0x04, DMA0)
                    CreateDWordField (Local1, 0x08, PIO1)
                    CreateDWordField (Local1, 0x0C, DMA1)
                    CreateDWordField (Local1, 0x10, FLGX)
                    If (LEqual (Arg1, 0xA0))
                    {
                        Store (PIO0, Local2)
                        Store (DMA0, Local3)
                        And (FLGX, 0x01, FLGX)
                    }
                    Else
                    {
                        Store (PIO1, Local2)
                        Store (DMA1, Local3)
                        And (FLGX, 0x04, FLGX)
                    }

                    Store (FLGX, Local1)
                    If (LGreater (Local2, 0x0186))
                    {
                        Store (0x00, Local2)
                    }
                    Else
                    {
                        If (LGreater (Local2, 0xF0))
                        {
                            Store (0x01, Local2)
                        }
                        Else
                        {
                            If (LGreater (Local2, 0xB4))
                            {
                                Store (0x02, Local2)
                            }
                            Else
                            {
                                If (LGreater (Local2, 0x78))
                                {
                                    Store (0x03, Local2)
                                }
                                Else
                                {
                                    Store (0x04, Local2)
                                }
                            }
                        }
                    }

                    Or (0x08, Local2, MODE)
                    Store (Local0, Local2)
                    If (FLGX)
                    {
                        If (LGreater (Local3, 0x49))
                        {
                            Store (0x00, Local3)
                        }
                        Else
                        {
                            If (LGreater (Local3, 0x3C))
                            {
                                Store (0x01, Local3)
                            }
                            Else
                            {
                                If (LGreater (Local3, 0x2D))
                                {
                                    Store (0x02, Local3)
                                }
                                Else
                                {
                                    If (LGreater (Local3, 0x1E))
                                    {
                                        Store (0x03, Local3)
                                    }
                                    Else
                                    {
                                        If (LGreater (Local3, 0x14))
                                        {
                                            Store (0x04, Local3)
                                        }
                                        Else
                                        {
                                            If (LGreater (Local3, 0x0F))
                                            {
                                                Store (0x05, Local3)
                                            }
                                            Else
                                            {
                                                Store (0x06, Local3)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Or (0x40, Local3, MODE)
                    }
                    Else
                    {
                        If (LEqual (Local3, 0xFFFFFFFF))
                        {
                            Return (Local0)
                        }
                        Else
                        {
                            If (LGreater (Local3, 0x96))
                            {
                                Store (0x00, Local3)
                            }
                            Else
                            {
                                If (LGreater (Local3, 0x78))
                                {
                                    Store (0x01, Local3)
                                }
                                Else
                                {
                                    Store (0x02, Local3)
                                }
                            }

                            Or (0x20, Local3, MODE)
                        }
                    }

                    Concatenate (Local0, Local2, Local1)
                    Return (Local1)
                }

                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (0x00))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        STM (Arg0, Arg1, Arg2, 0x00)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_PS0, 0, NotSerialized)
                        {
                            Store (0x00, Local0)
                        }

                        Method (_PS3, 0, NotSerialized)
                        {
                            Store (0x00, Local0)
                        }

                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x00, 0xA0))
                        }

                        Method (_STA, 0, NotSerialized)
                        {
                            If (BAYO)
                            {
                                Return (0x00)
                            }

                            If (And (GP16, 0x20))
                            {
                                Return (0x00)
                            }
                            Else
                            {
                                Return (0x0F)
                            }
                        }

                        Method (_RMV, 0, NotSerialized)
                        {
                            Return (0x01)
                        }

                        Method (_EJ0, 1, NotSerialized)
                        {
                            Or (\_SB.PCI0.SMB0.PTRI, 0x00200000, \_SB.PCI0.SMB0.PTRI)
                            Store (0x04, GP49)
                            Store (0x04, Z01J)
                            Store (0x04, GP54)
                            Store (0x01, BAYO)
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x00, 0xB0))
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (0x01))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        STM (Arg0, Arg1, Arg2, 0x01)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x01, 0xA0))
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x01, 0xB0))
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_P0)
                }
            }

            Device (SAT1)
            {
                Name (_ADR, 0x000F0000)
                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Name (SPTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SPTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SPTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Name (SSTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SSTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SSTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_S0)
                }
            }

            Device (SAT0)
            {
                Name (_ADR, 0x000E0000)
                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Name (SPTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SPTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SPTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Name (SSTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SSTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SSTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_S1)
                }
            }

            Device (UVGA)
            {
                Name (_ADR, 0x00050000)
                Name (SWIT, 0x01)
                Name (CRTA, 0x01)
                Name (LCDA, 0x01)
                Name (TVAF, 0x00)
                Name (TOGF, 0x00)
                Name (BRIP, Package (0x0D)
                {
                    0x64, 
                    0x30, 
                    0x13, 
                    0x18, 
                    0x1D, 
                    0x22, 
                    0x27, 
                    0x30, 
                    0x37, 
                    0x3D, 
                    0x47, 
                    0x50, 
                    0x64
                })
                Name (BRI2, Package (0x0D)
                {
                    0x5C, 
                    0x2B, 
                    0x11, 
                    0x16, 
                    0x1B, 
                    0x20, 
                    0x25, 
                    0x2B, 
                    0x37, 
                    0x3D, 
                    0x47, 
                    0x50, 
                    0x5C
                })
                Method (_DOS, 1, NotSerialized)
                {
                    Store ("VGA --_DOS Arg0", Debug)
                    Store (Arg0, SWIT)
                }

                Method (_DOD, 0, NotSerialized)
                {
                    Store ("VGA --_DOD", Debug)
                    Return (Package (0x03)
                    {
                        0x00010100, 
                        0x00010118, 
                        0x00010200
                    })
                }

                Method (_PS0, 0, NotSerialized)
                {
                    Store ("VGA_PS0", Debug)
                }

                Method (_PS2, 0, NotSerialized)
                {
                    Store ("VGA_PS2", Debug)
                }

                Method (_PS3, 0, NotSerialized)
                {
                    Store ("VGA_PS3", Debug)
                }

                Device (CRT)
                {
                    Name (_ADR, 0x0100)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("CRT --_DCS", Debug)
                        If (CRTA)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("CRT --_DGS", Debug)
                        Store (CRTA, Local0)
                        If (CRTA)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("CRT --_DSS", Debug)
                        Store (Arg0, Debug)
                    }
                }

                Device (LCD)
                {
                    Name (_ADR, 0x0118)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("LCD --_DCS", Debug)
                        If (LCDA)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("LCD --_DGS", Debug)
                        Store (LCDA, Local0)
                        If (LCDA)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("LCD --_DSS", Debug)
                        Store (Arg0, Debug)
                    }

                    Method (_BCL, 0, NotSerialized)
                    {
                        If (LEqual (\_SB.PLTY, 0x01))
                        {
                            Return (BRI2)
                        }
                        Else
                        {
                            Return (BRIP)
                        }
                    }

                    Method (_BCM, 1, NotSerialized)
                    {
                        Store (Arg0, Local0)
                        Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                        Store (Local0, \_SB.PCI0.EC0.BRIC)
                        Store (\_SB.PCI0.EC0.ACIN, Local1)
                        Release (\_SB.PCI0.EC0.MUT0)
                        Store (_BCL (), Local2)
                        Store (0x02, Local3)
                        While (LLess (Local3, 0x0D))
                        {
                            If (LEqual (Local0, DerefOf (Index (Local2, Local3))))
                            {
                                If (Local1)
                                {
                                    Subtract (Local3, 0x02, ACBR)
                                }
                                Else
                                {
                                    Subtract (Local3, 0x02, DCBR)
                                }

                                Subtract (Local3, 0x02, CCBR)
                                Store (0x0F, Local3)
                            }

                            Increment (Local3)
                        }
                    }

                    Method (_BQC, 0, NotSerialized)
                    {
                        If (ECON)
                        {
                            Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                            Store (\_SB.PCI0.EC0.BRIC, Local0)
                            Release (\_SB.PCI0.EC0.MUT0)
                            Return (Local0)
                        }
                        Else
                        {
                            Store (_BCL (), Local1)
                            Return (DerefOf (Index (Local1, CCBR)))
                        }
                    }
                }

                Device (TV)
                {
                    Name (_ADR, 0x0200)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("TV --_DCS", Debug)
                        If (TVAF)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("TV --_DGS", Debug)
                        Store (TVAF, Local0)
                        If (TVAF)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("TV --_DSS", Debug)
                        Store (Arg0, Debug)
                    }
                }
            }

            Device (XVR0)
            {
                Name (_ADR, 0x00040000)
                Name (_UID, 0x03)
                OperationRegion (A1E0, PCI_Config, 0x19, 0x01)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }
                })
                Device (VGA)
                {
                    Name (_ADR, 0x00)
                    Name (SWIT, 0x01)
                    Name (CRTA, 0x01)
                    Name (LCDA, 0x01)
                    Name (TVAF, 0x00)
                    Name (TOGF, 0x00)
                    Method (_DOS, 1, NotSerialized)
                    {
                        Store ("VGA --_DOS Arg0", Debug)
                        Store (Arg0, SWIT)
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        Store ("VGA --_DOD", Debug)
                        Return (Package (0x03)
                        {
                            0x00010100, 
                            0x00010118, 
                            0x00010200
                        })
                    }

                    Method (_PS0, 0, NotSerialized)
                    {
                        Store ("VGA_PS0", Debug)
                    }

                    Method (_PS2, 0, NotSerialized)
                    {
                        Store ("VGA_PS2", Debug)
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        Store ("VGA_PS3", Debug)
                    }

                    Device (CRT)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("CRT --_DCS", Debug)
                            If (CRTA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("CRT --_DGS", Debug)
                            Store (CRTA, Local0)
                            If (CRTA)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("CRT --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }

                    Device (LCD)
                    {
                        Name (_ADR, 0x0118)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("LCD --_DCS", Debug)
                            If (LCDA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("LCD --_DGS", Debug)
                            Store (LCDA, Local0)
                            If (LCDA)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("LCD --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }

                    Device (TV)
                    {
                        Name (_ADR, 0x0200)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("TV --_DCS", Debug)
                            If (TVAF)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("TV --_DGS", Debug)
                            Store (TVAF, Local0)
                            If (TVAF)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("TV --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }
                }
            }

            Device (XVR1)
            {
                Name (_ADR, 0x00030000)
                Name (_UID, 0x04)
                OperationRegion (A1E1, PCI_Config, 0x19, 0x01)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }
                })
                Device (X1S0)
                {
                    Name (_ADR, 0x00)
                }
            }

            Device (XVR2)
            {
                Name (_ADR, 0x00020000)
                Name (_UID, 0x05)
                OperationRegion (A1E2, PCI_Config, 0x19, 0x01)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }
                })
                OperationRegion (PCE1, PCI_Config, 0x90, 0x70)
                Field (PCE1, DWordAcc, Lock, Preserve)
                {
                            Offset (0x08), 
                        ,   3, 
                    BS03,   1, 
                        ,   1, 
                    BS05,   1, 
                        ,   13, 
                    BS19,   1, 
                        ,   2, 
                    EPDS,   1
                }

                Device (X2S0)
                {
                    Name (_ADR, 0x00)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (\_SB.PCI0.XVR2.EPDS)
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (0x01)
                    }

                    Name (_EJD, "_SB.PCI0.USB0.RH00.Prt5")
                }
            }
        }

        Device (QBTN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x01)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x04))
                {
                    Notify (QBTN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x01
                })
            }
        }

        Device (DBTN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x02)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x05))
                {
                    Notify (DBTN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x02
                })
            }
        }

        Device (MUBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x03)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x03))
                {
                    Notify (MUBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x03
                })
            }
        }

        Device (PIBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x06)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x06))
                {
                    Notify (PIBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x06
                })
            }
        }

        Device (WEBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x04)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x10))
                {
                    Notify (WEBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x04
                })
            }
        }

        Device (LVBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x08)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x11))
                {
                    Notify (LVBN, 0x02)
                    Store (0x00, HOTB)
                }
                Else
                {
                    If (LEqual (HOTB, 0x12))
                    {
                        Notify (LVBN, 0x02)
                        Store (0x00, HOTB)
                    }
                }

                Return (Buffer (0x01)
                {
                    0x08
                })
            }
        }

        Device (VOBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x07)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x12))
                {
                    Notify (VOBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x07
                })
            }
        }

        Scope (\)
        {
            Name (PICF, 0x00)
            Method (_PIC, 1, NotSerialized)
            {
                Store (Arg0, PICF)
            }

            OperationRegion (\_SB.PCI0.LPC0.PIRQ, PCI_Config, 0x7C, 0x0C)
            Field (\_SB.PCI0.LPC0.PIRQ, AnyAcc, NoLock, Preserve)
            {
                INTW,   4, 
                INTX,   4, 
                INTY,   4, 
                INTZ,   4, 
                INTA,   4, 
                INTB,   4, 
                INTC,   4, 
                INTD,   4, 
                ISCI,   4, 
                ITCO,   4, 
                ISMB,   4, 
                IUS2,   4, 
                INTU,   4, 
                INTS,   4, 
                PSI1,   4, 
                PSI0,   4, 
                IUS0,   4, 
                IUS1,   4, 
                IMAC,   4, 
                IAZA,   4, 
                IACI,   4, 
                IMCI,   4, 
                IPID,   4, 
                ISID,   4
            }
        }

        Scope (\_SB.PCI0)
        {
            Name (BUFA, ResourceTemplate ()
            {
                IRQ (Level, ActiveLow, Shared, )
                    {5,7,9,10,11,14,15}
            })
            Name (BUFB, ResourceTemplate ()
            {
                IRQ (Level, ActiveLow, Shared, _Y0A)
                    {}
            })
            CreateWordField (BUFB, \_SB.PCI0._Y0A._INT, IRQV)
            Method (CRS, 1, Serialized)
            {
                If (Arg0)
                {
                    ShiftLeft (0x01, Arg0, IRQV)
                }
                Else
                {
                    Store (Zero, IRQV)
                }

                Return (BUFB)
            }

            Method (SRS, 1, Serialized)
            {
                CreateWordField (Arg0, 0x01, IRQ0)
                FindSetRightBit (IRQ0, Local0)
                Decrement (Local0)
                Return (Local0)
            }

            Name (BUFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000010,
                    0x00000011,
                    0x00000014,
                    0x00000016,
                    0x00000017,
                }
            })
            Name (BUFJ, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000013,
                }
            })
            Name (BUFK, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000012,
                }
            })
            Name (BUFL, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000015,
                }
            })
            Name (BUFF, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000005,
                    0x00000007,
                    0x0000000A,
                    0x0000000B,
                    0x0000000E,
                    0x0000000F,
                }
            })
            Method (CRSI, 1, Serialized)
            {
                Name (IRZ5, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, _Y0B)
                    {
                        0x00000007,
                    }
                })
                CreateWordField (IRZ5, \_SB.PCI0.CRSI._Y0B._INT, INZ5)
                Store (Arg0, Local0)
                If (LEqual (Arg0, 0x03))
                {
                    Store (0x10, Local0)
                }

                If (LEqual (Arg0, 0x04))
                {
                    Store (0x11, Local0)
                }

                If (LEqual (Arg0, 0x06))
                {
                    Store (0x12, Local0)
                }

                If (LEqual (Arg0, 0x0C))
                {
                    Store (0x13, Local0)
                }

                If (LEqual (Arg0, 0x08))
                {
                    Store (0x14, Local0)
                }

                If (LEqual (Arg0, 0x0D))
                {
                    Store (0x15, Local0)
                }

                If (LEqual (Arg0, 0x02))
                {
                    Store (0x16, Local0)
                }

                If (LEqual (Arg0, 0x01))
                {
                    Store (0x17, Local0)
                }

                Store (Local0, INZ5)
                Return (IRZ5)
            }

            Method (SRSI, 1, Serialized)
            {
                CreateWordField (Arg0, 0x05, IRZ6)
                Store (IRZ6, Local0)
                If (LEqual (IRZ6, 0x10))
                {
                    Store (0x03, Local0)
                }

                If (LEqual (IRZ6, 0x11))
                {
                    Store (0x04, Local0)
                }

                If (LEqual (IRZ6, 0x12))
                {
                    Store (0x06, Local0)
                }

                If (LEqual (IRZ6, 0x13))
                {
                    Store (0x0C, Local0)
                }

                If (LEqual (IRZ6, 0x14))
                {
                    Store (0x08, Local0)
                }

                If (LEqual (IRZ6, 0x15))
                {
                    Store (0x0D, Local0)
                }

                If (LEqual (IRZ6, 0x16))
                {
                    Store (0x02, Local0)
                }

                If (LEqual (IRZ6, 0x17))
                {
                    Store (0x01, Local0)
                }

                Return (Local0)
            }

            Device (LNK1)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x01)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTW)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTW)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFF)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTW))
                    }
                    Else
                    {
                        Return (CRSI (INTW))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTW)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTW)
                    }
                }
            }

            Device (LNK2)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x02)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTX)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTX)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFF)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTX))
                    }
                    Else
                    {
                        Return (CRSI (INTX))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTX)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTX)
                    }
                }
            }

            Device (LNK3)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x03)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTY)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTY)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFF)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTY))
                    }
                    Else
                    {
                        Return (CRSI (INTY))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTY)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTY)
                    }
                }
            }

            Device (LNK4)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x04)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTZ)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTZ)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFF)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTZ))
                    }
                    Else
                    {
                        Return (CRSI (INTZ))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTZ)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTZ)
                    }
                }
            }

            Device (LK1E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x05)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTA)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTA)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFJ)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTA))
                    }
                    Else
                    {
                        Return (CRSI (INTA))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTA)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTA)
                    }
                }
            }

            Device (LK2E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x06)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTB)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTB)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTB))
                    }
                    Else
                    {
                        Return (CRSI (INTB))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTB)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTB)
                    }
                }
            }

            Device (LK3E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x07)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTC)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTC)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFK)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTC))
                    }
                    Else
                    {
                        Return (CRSI (INTC))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTC)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTC)
                    }
                }
            }

            Device (LK4E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x08)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTD)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTD)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTD))
                    }
                    Else
                    {
                        Return (CRSI (INTD))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTD)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTD)
                    }
                }
            }

            Device (LSMB)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x09)
                Method (_STA, 0, NotSerialized)
                {
                    If (ISMB)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, ISMB)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (ISMB))
                    }
                    Else
                    {
                        Return (CRSI (ISMB))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), ISMB)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), ISMB)
                    }
                }
            }

            Device (LPMU)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x14)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTS)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTS)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTS))
                    }
                    Else
                    {
                        Return (CRSI (INTS))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTS)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTS)
                    }
                }
            }

            Device (LUS0)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0A)
                Method (_STA, 0, NotSerialized)
                {
                    If (IUS0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IUS0)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IUS0))
                    }
                    Else
                    {
                        Return (CRSI (IUS0))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IUS0)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IUS0)
                    }
                }
            }

            Device (LUS2)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0C)
                Method (_STA, 0, NotSerialized)
                {
                    If (IUS2)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IUS2)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IUS2))
                    }
                    Else
                    {
                        Return (CRSI (IUS2))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IUS2)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IUS2)
                    }
                }
            }

            Device (LMAC)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0D)
                Method (_STA, 0, NotSerialized)
                {
                    If (IMAC)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IMAC)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IMAC))
                    }
                    Else
                    {
                        Return (CRSI (IMAC))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IMAC)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IMAC)
                    }
                }
            }

            Device (LAZA)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0E)
                Method (_STA, 0, NotSerialized)
                {
                    If (IAZA)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IAZA)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IAZA))
                    }
                    Else
                    {
                        Return (CRSI (IAZA))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IAZA)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IAZA)
                    }
                }
            }

            Device (LACI)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0F)
                Method (_STA, 0, NotSerialized)
                {
                    If (IACI)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IACI)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IACI))
                    }
                    Else
                    {
                        Return (CRSI (IACI))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IACI)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IACI)
                    }
                }
            }

            Device (LMCI)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x10)
                Method (_STA, 0, NotSerialized)
                {
                    If (IMCI)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IMCI)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IMCI))
                    }
                    Else
                    {
                        Return (CRSI (IMCI))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IMCI)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IMCI)
                    }
                }
            }

            Device (LPID)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x11)
                Method (_STA, 0, NotSerialized)
                {
                    If (IPID)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IPID)
                    Store (0x00, ISID)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IPID))
                    }
                    Else
                    {
                        Return (CRSI (IPID))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IPID)
                        Store (SRS (Arg0), ISID)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IPID)
                        Store (SRSI (Arg0), ISID)
                    }
                }
            }

            Device (LTID)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x12)
                Method (_STA, 0, NotSerialized)
                {
                    If (PSI0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, PSI0)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFL)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (PSI0))
                    }
                    Else
                    {
                        Return (CRSI (PSI0))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), PSI0)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), PSI0)
                    }
                }
            }

            Device (LSI1)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x13)
                Method (_STA, 0, NotSerialized)
                {
                    If (PSI0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, PSI1)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFL)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (PSI1))
                    }
                    Else
                    {
                        Return (CRSI (PSI1))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), PSI1)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), PSI1)
                    }
                }
            }
        }

        Scope (\_TZ)
        {
            Name (TPAS, 0x64)
            Name (TPA0, 0x52)
            Name (TPA1, 0x57)
            Name (TPA2, 0x5A)
            Name (TPC, 0x5F)
            Name (TPTM, 0x2D)
            ThermalZone (THRM)
            {
                Method (_CRT, 0, Serialized)
                {
                    Return (Add (0x0AAC, Multiply (TPC, 0x0A)))
                }

                Method (_SCP, 1, Serialized)
                {
                    Store (0x00, CTYP)
                }

                Method (_TMP, 0, Serialized)
                {
                    If (ECON)
                    {
                        Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                        Store (\_SB.PCI0.EC0.RTMP, Local0)
                        Release (\_SB.PCI0.EC0.MUT0)
                        Store ("Current temp is: ", Debug)
                        Return (Add (0x0AAC, Multiply (Local0, 0x0A)))
                    }
                    Else
                    {
                        Return (Add (0x0AAC, Multiply (TPTM, 0x0A)))
                    }
                }

                Method (_PSL, 0, Serialized)
                {
                    If (\_SB.DUAL)
                    {
                        Return (Package (0x02)
                        {
                            \_PR.CPU0, 
                            \_PR.CPU1
                        })
                    }
                    Else
                    {
                        Return (Package (0x01)
                        {
                            \_PR.CPU0
                        })
                    }
                }

                Method (_PSV, 0, Serialized)
                {
                    Return (Add (0x0AAC, Multiply (TPAS, 0x0A)))
                }

                Method (_TC1, 0, Serialized)
                {
                    Return (0x02)
                }

                Method (_TC2, 0, Serialized)
                {
                    Return (0x03)
                }

                Method (_TSP, 0, Serialized)
                {
                    Return (0x64)
                }

                Method (Z01I, 1, NotSerialized)
                {
                    If (LGreaterEqual (Arg0, TPA1))
                    {
                        If (LGreaterEqual (Arg0, TPA2))
                        {
                            Store (\_SB.PSTN, THR0)
                            \_SB.Z01H ()
                        }
                        Else
                        {
                            If (LEqual (\_SB.PSTN, 0x01))
                            {
                                Store (\_SB.PSTN, THR0)
                                \_SB.Z01H ()
                            }
                            Else
                            {
                                Subtract (\_SB.PSTN, 0x01, THR0)
                                \_SB.Z01H ()
                            }
                        }
                    }
                    Else
                    {
                        If (LLessEqual (Arg0, TPA0))
                        {
                            Store (0x00, THR0)
                            \_SB.Z01H ()
                        }
                    }
                }

                Name (REGN, "Processor Thermal Zone")
                Name (FMAX, 0x170C)
                Name (FMIN, 0x0F3C)
                Method (FRSP, 0, NotSerialized)
                {
                    Store (0x00, Local2)
                    Store (\_SB.PCI0.EC0.RPM1, Local0)
                    Store (\_SB.PCI0.EC0.RPM2, Local1)
                    ShiftLeft (Local1, 0x08, Local1)
                    Or (Local0, Local1, Local0)
                    Return (Local0)
                }

                Method (FSSP, 1, NotSerialized)
                {
                    Store (Arg0, \_SB.PCI0.EC0.TFAN)
                }
            }
        }

        Method (Z01H, 0, NotSerialized)
        {
            If (LNotEqual (\_SB.CPUF, 0x5A))
            {
                Store (0x00, Local0)
                Store (0x00, Local1)
                Or (Local1, LNotEqual (THR1, THR0), Local1)
                Or (Local1, LNotEqual (PST1, PST0), Local1)
                Or (Local1, LNotEqual (Q8C1, Q8C0), Local1)
                Or (Local1, LNotEqual (Q8E1, Q8E0), Local1)
                Or (Local1, LNotEqual (Q881, Q880), Local1)
                If (LNotEqual (Local1, 0x00))
                {
                    Store (0x00, Local1)
                    Or (Local1, LNotEqual (THR0, 0x00), Local1)
                    Or (Local1, LNotEqual (PST0, 0x00), Local1)
                    Or (Local1, LNotEqual (Q8C0, 0x00), Local1)
                    Or (Local1, LNotEqual (Q8E0, 0x00), Local1)
                    Or (Local1, LNotEqual (Q880, 0x00), Local1)
                    If (LEqual (Local1, 0x00))
                    {
                        Store (0x00, NOWP)
                        If (LEqual (\_SB.AMDP, 0x00))
                        {
                            If (LEqual (B800, 0x01))
                            {
                                Store (\_SB.PSTN, NOWP)
                            }
                            Else
                            {
                                Store (0x00, NOWP)
                            }
                        }

                        Store (NOWP, \_PR.CPU0._PPC)
                        If (LEqual (\_SB.DUAL, 0x01))
                        {
                            Store (0x00, \_PR.CPU1._PPC)
                            Notify (\_PR.CPU0, 0x80)
                            Notify (\_PR.CPU1, 0x80)
                        }
                        Else
                        {
                            Notify (\_PR.CPU0, 0x80)
                        }
                    }
                    Else
                    {
                        Store (0x00, NOWP)
                        If (LGreater (PST0, NOWP))
                        {
                            Store (PST0, NOWP)
                        }

                        If (LGreater (THR0, NOWP))
                        {
                            Store (THR0, NOWP)
                        }

                        If (LGreater (Q880, NOWP))
                        {
                            Store (Q880, NOWP)
                        }

                        If (LEqual (ECON, 0x01))
                        {
                            Store (\_SB.PCI0.EC0.ACIN, Local0)
                        }

                        If (LEqual (Local0, 0x00))
                        {
                            If (LGreater (Q8C0, NOWP))
                            {
                                Store (Q8C0, NOWP)
                            }

                            If (LGreater (Q8E0, NOWP))
                            {
                                Store (Q8E0, NOWP)
                            }
                        }

                        If (LEqual (\_SB.AMDP, 0x00))
                        {
                            If (LEqual (B800, 0x01))
                            {
                                Store (\_SB.PSTN, NOWP)
                            }
                        }

                        Store (NOWP, \_PR.CPU0._PPC)
                        If (LEqual (\_SB.DUAL, 0x01))
                        {
                            Store (NOWP, \_PR.CPU1._PPC)
                            Notify (\_PR.CPU0, 0x80)
                            Notify (\_PR.CPU1, 0x80)
                        }
                        Else
                        {
                            Notify (\_PR.CPU0, 0x80)
                        }
                    }

                    Store (Q8C0, Q8C1)
                    Store (Q8E0, Q8E1)
                    Store (PST0, PST1)
                    Store (THR0, THR1)
                    Store (Q880, Q881)
                }
            }
        }
    }

    Scope (\_SB.PCI0.LPC0)
    {
        OperationRegion (RGA0, PCI_Config, 0xA0, 0x04)
        Field (RGA0, AnyAcc, NoLock, Preserve)
        {
            COMP,   8, 
            ADIO,   4, 
            MIDS,   4, 
            MSSS,   4, 
            FDCP,   2, 
            ADLB,   1, 
                    Offset (0x03), 
            LPTP,   3, 
                ,   1, 
            DVR0,   1, 
            DVR1,   1, 
            DVR2,   1, 
            DVR3,   1
        }

        OperationRegion (RGA1, PCI_Config, 0xA4, 0x04)
        Field (RGA1, AnyAcc, NoLock, Preserve)
        {
            GMPS,   16, 
                    Offset (0x04)
        }
    }

    OperationRegion (CS72, SystemIO, 0x72, 0x02)
    Field (CS72, ByteAcc, NoLock, Preserve)
    {
        CI72,   8, 
        CO73,   8
    }

    IndexField (CI72, CO73, ByteAcc, NoLock, Preserve)
    {
                Offset (0x22), 
            ,   3, 
        HPBD,   3, 
                Offset (0x9A), 
        BRNS,   4, 
        ACBN,   4, 
        BABN,   4, 
        WLSU,   1, 
        BTSU,   1, 
        IVIK,   2, 
        BTWL,   3, 
        BTLS,   1, 
        WWLS,   1, 
        BWLS,   1, 
        WALS,   1, 
                Offset (0x9D), 
        S4FL,   1, 
        SETF,   1, 
        VGAT,   1, 
        LSHK,   1, 
        S4RT,   2, 
                Offset (0xA9), 
        WAKI,   8, 
                Offset (0xAD), 
        HOTB,   8, 
        MEMS,   8, 
        LDTY,   8, 
        LANV,   1
    }

    Mutex (M723, 0x00)
    OperationRegion (DBGP, SystemIO, 0x80, 0x01)
    Field (DBGP, ByteAcc, NoLock, Preserve)
    {
        DBUG,   8
    }

    OperationRegion (ENEP, SystemIO, 0x0380, 0x04)
    Field (ENEP, ByteAcc, NoLock, Preserve)
    {
        P380,   8, 
        P381,   8, 
        P382,   8, 
        P383,   8
    }

    Mutex (M380, 0x00)
    OperationRegion (PM1A, SystemIO, 0x1000, 0x04)
    Field (PM1A, ByteAcc, NoLock, Preserve)
    {
            ,   14, 
        PEWS,   1, 
                Offset (0x02)
    }

    OperationRegion (LDTR, SystemIO, 0x10A6, 0x01)
    Field (LDTR, ByteAcc, NoLock, Preserve)
    {
        LDTC,   1
    }

    OperationRegion (NVGP, SystemIO, 0x14C0, 0x40)
    Field (NVGP, ByteAcc, NoLock, Preserve)
    {
        Z01K,   8, 
        Z01L,   8, 
        Z006,   8, 
        Z01M,   8, 
        Z01J,   8, 
        Z01N,   8, 
        Z01O,   8, 
        Z000,   8, 
        Z001,   8, 
        Z002,   8, 
        Z01P,   8, 
        Z01Q,   8, 
                Offset (0x0F), 
        GP16,   8, 
        GP17,   8, 
                Offset (0x25), 
        PCQ3,   8, 
                Offset (0x27), 
        GP23,   8, 
                Offset (0x30), 
        GP49,   8, 
                Offset (0x35), 
        GP54,   8, 
                Offset (0x3F), 
        GP24,   8
    }

    Name (RBRF, 0x01)
    Name (L10F, 0x00)
    Name (SCIC, 0x00)
    Name (SCID, 0x00)
    Name (CADL, 0x01)
    Name (PADL, 0x01)
    Name (PSTE, 0x01)
    Name (CSTE, 0x01)
    Name (NSTE, 0x01)
    Name (SSTE, 0x01)
    Name (WMSF, 0x00)
    Name (JMPF, 0x00)
    Name (WIRE, 0x00)
    Name (WLID, 0xFF)
    Name (GP25, 0x01)
    Name (GP26, 0x01)
    Name (WWAN, 0x01)
    Name (WLSS, 0x01)
    Name (WLS2, 0x00)
    Name (S34F, 0x00)
    Name (S34C, 0x00)
    Name (OSYS, 0x07D2)
    Name (CTYP, 0x00)
    Name (\ECON, 0x00)
    Name (BAYO, 0x00)
    Name (FWSO, "FWSO")
    Name (IVI2, 0x00)
    Name (THR0, 0x00)
    Name (PST0, 0x00)
    Name (THR1, 0x00)
    Name (PST1, 0x00)
    Name (NOWP, 0x00)
    Name (Q880, 0x00)
    Name (Q881, 0x00)
    Name (Q8C0, 0x00)
    Name (Q8C1, 0x00)
    Name (Q8E0, 0x00)
    Name (Q8E1, 0x00)
    Name (KWCP, 0x01)
    Name (MWCP, 0x01)
    Name (B800, 0x00)
    Name (CTDC, 0x00)
}


--------------040004010509030800000700--
