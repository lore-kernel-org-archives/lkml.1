Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYGEXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYGEXt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYGEXtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:49:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:33916 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYGEXts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:49:48 -0400
Message-ID: <cccedfc60807051649w226a5ccaqfac230530b2e1204@mail.gmail.com>
Date: Sat, 5 Jul 2008 18:49:45 -0500
From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
To: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
	 <486FBFAB.5050303@shaw.ca>
	 <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
	 <486FC5D2.80600@shaw.ca>
	 <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
X-Google-Sender-Auth: 0fb0984b2642942d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 5:53 PM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> On Sat, Jul 5, 2008 at 2:04 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>> Jon Nelson wrote:
>>>
>>> Where should APIC errors be posted?
>>> My EPoX MF570-SLI *will not boot* without noapic or nolapic.
>>
>> Post on linux-kernel about that one, with the dmesg from noapic mode and
>> whatever info you can gather from when it won't boot. You might want to also
>> test with 2.6.26-rc8 to see if the problem has already been fixed there.
>
> Here is the boot log from booting my EPoX MF570SLI in nolapic mode.
> When I boot without nolapic or noapic I get as far as

I recently tried a bunch of stuff:

Things that do not help:
1. adding nolapic_timer
2. adding either of acpi_skip_timer, acpi_use_time_override
3. with or without nolapic, adding acpi_serialize hangs the boot.

Additional debugging:
1. adding apic=debug
2. earlyprintk=vga

One time, I got far enough to see:

Booting
Initializing CPU #1
Stuck ??
Inquiring remote #1 ...
... APIC #1 ID: 01000000
... APIC #1 VERSION: 80050010
... APIC #1 SPIN: 000001ff
Brought up 1 CPUs
<hang here>

Then I tried 2.6.25.5 (which I can boot from but cannot use as yet)...
and it boots without nolapic or noapic.
Below, please find the dmesg for that. I added "apic=debug earlyprintk=vga".




Linux version 2.6.25.5-1.1-default (geeko@buildhost) (gcc version
4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE
Linux) ) #1 SMP 2008-06-07 01:55:22 +0200
Command line: root=/dev/disk/by-id/scsi-SATA_Hitachi_HDT7250_VFB200R210J8UJ-part1
splash=silent showopts apic=debug earlyprintk=vga 1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000d0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyvga0] enabled
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.2 present.
ACPI: RSDP 000F80B0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 6732 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SSDT 3FFF99C0, 01C4 (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG 3FFF9C00, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF9900, 0072 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003fff0000
 NODE_DATA [000000000000b000 - 0000000000012fff]
 bootmap [0000000000013000 -  000000000001afff] pages 8
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-8b5bd7] TEXT DATA BSS
early res: 3 [37d1c000-37fef5bd] RAMDISK
early res: 4 [9f000-9ffff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
 DMA             0 ->     4096
 DMA32        4096 ->  1048576
 Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
   0:        0 ->      159
   0:      256 ->   262128
On node 0 totalpages: 262031
 DMA zone: 56 pages used for memmap
 DMA zone: 1726 pages reserved
 DMA zone: 2217 pages, LIFO batch:0
 DMA32 zone: 3527 pages used for memmap
 DMA32 zone: 254505 pages, LIFO batch:31
 Normal zone: 0 pages used for memmap
 Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:90000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 47936 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256722
Policy zone: DMA32
Kernel command line:
root=/dev/disk/by-id/scsi-SATA_Hitachi_HDT7250_VFB200R210J8UJ-part1
splash=silent showopts apic=debug earlyprintk=vga 1
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1909.785 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console handover: boot [earlyvga0] -> real [tty0]
Checking aperture...
Node 0: aperture @ 4a0000000 size 32 MB
Aperture beyond 4GB. Ignoring.
No AGP bridge found
Memory: 1023680k/1048512k available (2365k kernel code, 24444k
reserved, 1920k data, 404k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3822.85 BogoMIPS (lpj=7645719)
Security Framework initialized
AppArmor: AppArmor initialized <NULL>
AppArmor: Registered secondary security module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
ACPI: Checking initramfs for custom DSDT
ACPI: Found DSDT in DSDT.aml.
ACPI: Override [DSDT-AWRDACPI], this is unsafe: tainting kernel
ACPI: Table DSDT replaced by host OS
ACPI: DSDT 00000000, 5CEF (r1 NVIDIA AWRDACPI     1000 INTL 20060912)
ACPI: DSDT override uses original SSDTs unless
"acpi_no_auto_ssdt"Parsing all Control Methods:
Table [DSDT](id 0001) - 1114 Objects with 104 Devices 325 Methods 43 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x32 -> IRQ 2 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23
not connected.
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
Using local APIC timer interrupts.
APIC timer calibration result 12564376
Detected 12.564 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 3819.63 BogoMIPS (lpj=7639279)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 3600+ stepping 01
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
 groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
 domain 1: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000003
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
 groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
 domain 1: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000003
net_namespace: 1016 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 1
Runtime GPEs in this block
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0
Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package
initialization:...................................................................................................
Initialized 39/43 Regions 9/9 Fields 34/34 Buffers 17/29 Packages (1131 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 1 _STA executions (examined 109 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:06.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 003 0    0    0   0   0    1    1    30
 01 003 0    0    0   0   0    1    1    31
 02 003 1    0    0   0   0    1    1    32
 03 003 0    0    0   0   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 1    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   0   0    1    1    39
 0a 003 1    0    0   0   0    1    1    3A
 0b 003 1    0    0   0   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
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
AppArmor: AppArmor Filesystem Enabled
ACPI: RTC can wake from S4
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1080-0x10ff has been reserved
system 00:01: ioport range 0x1400-0x147f has been reserved
system 00:01: ioport range 0x1480-0x14ff has been reserved
system 00:01: ioport range 0x1800-0x187f has been reserved
system 00:01: ioport range 0x1880-0x18ff has been reserved
system 00:01: iomem range 0xfff00000-0x10fefffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
system 00:02: ioport range 0x295-0x296 has been reserved
system 00:08: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:09: iomem range 0xf0000-0xf3fff could not be reserved
system 00:09: iomem range 0xf4000-0xf7fff could not be reserved
system 00:09: iomem range 0xf8000-0xfbfff could not be reserved
system 00:09: iomem range 0xfc000-0xfffff could not be reserved
system 00:09: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:09: iomem range 0xffff0000-0xffffffff has been reserved
system 00:09: iomem range 0x0-0x9ffff could not be reserved
system 00:09: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:09: iomem range 0xfefff000-0xfeffffff has been reserved
system 00:09: iomem range 0xfff80000-0xfff80fff has been reserved
system 00:09: iomem range 0xfff90000-0xfffbffff has been reserved
system 00:09: iomem range 0xfffed000-0xfffeffff has been reserved
PCI: Bridge: 0000:00:06.0
 IO window: a000-afff
 MEM window: 0xfc800000-0xfd3fffff
 PREFETCH window: 0x00000000fde00000-0x00000000fdefffff
PCI: Bridge: 0000:00:0a.0
 IO window: 9000-9fff
 MEM window: 0xfdd00000-0xfddfffff
 PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
PCI: Bridge: 0000:00:0b.0
 IO window: 8000-8fff
 MEM window: 0xfdb00000-0xfdbfffff
 PREFETCH window: 0x00000000fda00000-0x00000000fdafffff
PCI: Bridge: 0000:00:0d.0
Switched to high resolution mode on CPU 0
 IO window: 7000-7fff
 MEM window: 0xfd900000-0xfd9fffff
Switched to high resolution mode on CPU 1
 PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
PCI: Bridge: 0000:00:0e.0
 IO window: 6000-6fff
 MEM window: 0xfd700000-0xfd7fffff
 PREFETCH window: 0x00000000fd600000-0x00000000fd6fffff
PCI: Bridge: 0000:00:0f.0
 IO window: 5000-5fff
 MEM window: 0xfd500000-0xfd5fffff
 PREFETCH window: 0x00000000fd400000-0x00000000fd4fffff
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Setting latency timer of device 0000:00:0f.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2893k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1215301014.736:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:05.0: Enabling HT MSI Mapping
pci 0000:00:05.1: Enabling HT MSI Mapping
pci 0000:00:05.2: Enabling HT MSI Mapping
pci 0000:00:06.0: Enabling HT MSI Mapping
pci 0000:00:08.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0a.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0f.0: Enabling HT MSI Mapping
pci 0000:01:05.0: Boot video device
PCI: Setting latency timer of device 0000:00:0a.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0a.0:pcie00]
Allocate Port Service[0000:00:0a.0:pcie03]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:00:0f.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0f.0:pcie00]
Allocate Port Service[0000:00:0f.0:pcie03]
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
input: PC Speaker as /devices/platform/pcspkr/input/input1
cpuidle: using governor ladder
cpuidle: using governor menu
NET: Registered protocol family 1
registered taskstats version 1
Freeing unused kernel memory: 404k freed
Write protecting the kernel read-only data: 1680k
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (41 C)
No dock devices found.
SCSI subsystem initialized

-- 
Jon
