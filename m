Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXJHQUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXJHQUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXJHQUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:20:09 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:59091 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbXJHQUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:20:04 -0400
Message-ID: <470A58AF.9080402@free.fr>
Date: Mon, 08 Oct 2007 18:19:59 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: robert.moore@intel.com, len.brown@intel.com
Subject: halt does not shut the system down
Content-Type: multipart/mixed;
 boundary="------------080703030109060408020501"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080703030109060408020501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

When I run 'halt' the kernel prints:

Halting.
Shutdown: hdc
ACPI: PCI interrupt for device 0000:01:05.0 disabled
ACPI: PCI interrupt for device 0000:01:04.0 disabled
ACPI: PCI interrupt for device 0000:01:03.0 disabled
ACPI: PCI interrupt for device 0000:01:02.0 disabled
Power down.
acpi_power_off called

But the system does not shut down. (The fans keep spinning, the LEDs 
keep shining, the LCD keeps displaying.) Basically, the motherboard is 
still providing power to every component, as if the power supply had 
refused to stop.

Kernel is 2.6.22.1-rt9

I followed the instructions given here:
http://bugzilla.kernel.org/show_bug.cgi?id=6431

# cat /sys/module/acpi/parameters/debug_layer
Description                     Hex        SET
ACPI_UTILITIES                  0x00000001 [*]
ACPI_HARDWARE                   0x00000002 [*]
ACPI_EVENTS                     0x00000004 [*]
ACPI_TABLES                     0x00000008 [*]
ACPI_NAMESPACE                  0x00000010 [*]
ACPI_PARSER                     0x00000020 [*]
ACPI_DISPATCHER                 0x00000040 [*]
ACPI_EXECUTER                   0x00000080 [*]
ACPI_RESOURCES                  0x00000100 [*]
ACPI_CA_DEBUGGER                0x00000200 [*]
ACPI_OS_SERVICES                0x00000400 [*]
ACPI_CA_DISASSEMBLER            0x00000800 [*]
ACPI_COMPILER                   0x00001000 [*]
ACPI_TOOLS                      0x00002000 [*]
ACPI_ALL_DRIVERS                0xFFFF0000 [*]
--
debug_layer = 0xFFFF3FFF ( * = enabled)

# cat /sys/module/acpi/parameters/debug_level
Description                     Hex        SET
ACPI_LV_ERROR                   0x00000001 [*]
ACPI_LV_WARN                    0x00000002 [*]
ACPI_LV_INIT                    0x00000004 [*]
ACPI_LV_DEBUG_OBJECT            0x00000008 [*]
ACPI_LV_INFO                    0x00000010 [*]
ACPI_LV_INIT_NAMES              0x00000020 [*]
ACPI_LV_PARSE                   0x00000040 [*]
ACPI_LV_LOAD                    0x00000080 [*]
ACPI_LV_DISPATCH                0x00000100 [*]
ACPI_LV_EXEC                    0x00000200 [*]
ACPI_LV_NAMES                   0x00000400 [*]
ACPI_LV_OPREGION                0x00000800 [*]
ACPI_LV_BFIELD                  0x00001000 [*]
ACPI_LV_TABLES                  0x00002000 [*]
ACPI_LV_VALUES                  0x00004000 [*]
ACPI_LV_OBJECTS                 0x00008000 [*]
ACPI_LV_RESOURCES               0x00010000 [*]
ACPI_LV_USER_REQUESTS           0x00020000 [*]
ACPI_LV_PACKAGE                 0x00040000 [*]
ACPI_LV_ALLOCATIONS             0x00100000 [*]
ACPI_LV_FUNCTIONS               0x00200000 [*]
ACPI_LV_OPTIMIZATIONS           0x00400000 [*]
ACPI_LV_MUTEX                   0x01000000 [*]
ACPI_LV_THREADS                 0x02000000 [*]
ACPI_LV_IO                      0x04000000 [*]
ACPI_LV_INTERRUPTS              0x08000000 [*]
ACPI_LV_AML_DISASSEMBLE         0x10000000 [*]
ACPI_LV_VERBOSE_INFO            0x20000000 [*]
ACPI_LV_FULL_TABLES             0x40000000 [*]
ACPI_LV_EVENTS                  0x80000000 [*]
--
debug_level = 0xFFFFFFFF (* = enabled)

I've attached my .config and the output of the following commands:
dmesg, lspci, acpidump, halt

Do you have any idea what the problem is?

Regards.

--------------080703030109060408020501
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.22.1-rt9 (root@venus) (gcc version 3.4.6) #2 PREEMPT RT Mon Oct 8 17:27:02 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fef0000 (usable)
 BIOS-e820: 000000000fef0000 - 000000000fef3000 (ACPI NVS)
 BIOS-e820: 000000000fef3000 - 000000000ff00000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
254MB LOWMEM available.
found SMP MP-table at 000f4fa0
Entering add_active_range(0, 0, 65264) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    65264
early_node_map[1] active PFN ranges
    0:        0 ->    65264
On node 0 totalpages: 65264
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 477 pages used for memmap
  Normal zone: 60691 pages, LIFO batch:15
DMI 2.2 present.
ACPI: RSDP 000F6850, 0014 (r0 IntelR)
ACPI: RSDT 0FEF3000, 002C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 0FEF3040, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 0FEF30C0, 39B3 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 0FEF0000, 0040
ACPI: APIC 0FEF6A80, 0068 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 10000000 (gap: 0ff00000:eed00000)
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists.  Total pages: 64755
Kernel command line: ro root=/dev/hdc1 console=ttyS0,57600n8 console=tty0 panic=3 apic=debug acpi_pm_good
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 2400.000 MHz processor.
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 255916k/261056k available (1513k kernel code, 4644k reserved, 560k data, 148k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xd0800000 - 0xfffb5000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcfef0000   ( 254 MB)
      .init : 0xc030a000 - 0xc032f000   ( 148 kB)
      .data : 0xc027a641 - 0xc030692c   ( 560 kB)
      .text : 0xc0100000 - 0xc027a641   (1513 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4802.77 BogoMIPS (lpj=24013893)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 09
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 483 Objects with 44 Devices 132 Methods 29 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
Getting VERSION: 50014
Getting VERSION: 50014
Getting ID: 0
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 833376
... PM timer delta = 357961
... PM timer result ok
..... delta 833376
..... mult: 35793226
..... calibration result: 1333401
..... CPU clock speed is 2400.1280 MHz.
..... host bus clock speed is 133.3401 MHz.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb3e0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 1 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:...................................................................
Initialized 29/29 Regions 9/9 Fields 19/19 Buffers 10/13 Packages (492 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 1 _STA executions (examined 49 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set PCI routing entry (2-8 -> 0x69 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-13 -> 0x91 -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-6 -> 0x59 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-4 -> 0x49 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set PCI routing entry (2-3 -> 0x41 -> IRQ 3 Mode:0 Active:0)
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
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
.... register #01: 00178020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0020
.... register #02: 00000000
.......     : arbitration: 00
.... register #03: 00000001
.......     : Boot DT    : 1
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 001 01  0    0    0   0   0    1    1    39
 02 001 01  0    0    0   0   0    1    1    31
 03 001 01  1    0    0   0   0    1    1    41
 04 001 01  1    0    0   0   0    1    1    49
 05 001 01  0    0    0   0   0    1    1    51
 06 001 01  1    0    0   0   0    1    1    59
 07 001 01  0    0    0   0   0    1    1    61
 08 001 01  1    0    0   0   0    1    1    69
 09 001 01  0    1    0   0   0    1    1    71
 0a 001 01  0    0    0   0   0    1    1    79
 0b 001 01  0    0    0   0   0    1    1    81
 0c 001 01  0    0    0   0   0    1    1    89
 0d 001 01  1    0    0   0   0    1    1    91
 0e 001 01  0    0    0   0   0    1    1    99
 0f 001 01  0    0    0   0   0    1    1    A1
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
pnp: 00:09: ioport range 0x400-0x4bf could not be reserved
pnp: 00:0b: iomem range 0xcb000-0xcbfff has been reserved
pnp: 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: ec000000-edffffff
  PREFETCH window: 10000000-100fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 6, 294912 bytes)
TCP bind hash table entries: 8192 (order: 5, 229376 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
io scheduler noop registered (default)
Boot video device is 0000:00:02.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
IOAPIC[0]: Set PCI routing entry (2-16 -> 0xa9 -> IRQ 16 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 16 (level, low) -> IRQ 16
e1000: 0000:01:02.0: e1000_probe: (PCI:33MHz:32-bit) 00:0b:ab:14:32:31
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
IOAPIC[0]: Set PCI routing entry (2-17 -> 0xb1 -> IRQ 17 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 17 (level, low) -> IRQ 17
e1000: 0000:01:03.0: e1000_probe: (PCI:33MHz:32-bit) 00:0b:ab:14:32:32
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
IOAPIC[0]: Set PCI routing entry (2-18 -> 0xb9 -> IRQ 18 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 18 (level, low) -> IRQ 18
e1000: 0000:01:04.0: e1000_probe: (PCI:33MHz:32-bit) 00:0b:ab:14:32:33
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
IOAPIC[0]: Set PCI routing entry (2-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1)
ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 19 (level, low) -> IRQ 19
e1000: 0000:01:05.0: e1000_probe: (PCI:33MHz:32-bit) 00:0b:ab:14:32:34
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: PQI IDE DiskOnModule, ATA DISK drive
hdc: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hdc: set_drive_speed_status: error=0x04 { DriveStatusError }
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 256000 sectors (131 MB) w/1KiB Cache, CHS=500/16/32
 hdc: hdc1 hdc2 hdc3 hdc4
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 148k freed
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX

--------------080703030109060408020501
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 03)
	Subsystem: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [e4] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 03) (prog-if 00 [VGA])
	Subsystem: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at ee000000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: ec000000-edffffff
	Prefetchable memory behind bridge: 10000000-100fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Unknown device 24c2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f000 [size=16]
	Region 5: Memory at 10100000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 24c2
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 0500 [size=32]

01:02.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller (rev 05)
	Subsystem: Intel Corporation PRO/1000 MT Network Connection
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ed000000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at ed080000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at c000 [size=64]
	[virtual] Expansion ROM at 10000000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=1
		Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:03.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller (rev 05)
	Subsystem: Intel Corporation PRO/1000 MT Network Connection
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at ed020000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at ed0a0000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at c400 [size=64]
	[virtual] Expansion ROM at 10010000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=1
		Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:04.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller (rev 05)
	Subsystem: Intel Corporation PRO/1000 MT Network Connection
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ed040000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at ed090000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at c800 [size=64]
	[virtual] Expansion ROM at 10020000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=1
		Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:05.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller (rev 05)
	Subsystem: Intel Corporation PRO/1000 MT Network Connection
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (63750ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at ed060000 (64-bit, non-prefetchable) [size=128K]
	Region 2: Memory at ed0b0000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at cc00 [size=64]
	[virtual] Expansion ROM at 10030000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [e4] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=512 OST=1
		Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
	Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

01:0f.0 Multimedia video controller: DekTec Digital Video B.V. DTA-105
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (4000ns min, 11750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at ed0c0000 (32-bit, non-prefetchable) [size=2K]


--------------080703030109060408020501
Content-Type: application/octet-stream;
 name="acpidump.txt.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="acpidump.txt.bz2"

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
+x89//F3JFOFCQxMcznw
--------------080703030109060408020501
Content-Type: application/octet-stream;
 name="halt.txt.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="halt.txt.bz2"

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
--------------080703030109060408020501
Content-Type: application/octet-stream;
 name="config-2.6.22.1-rt9.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config-2.6.22.1-rt9.bz2"

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
kinChIDfsb14
--------------080703030109060408020501--
