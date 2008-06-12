Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYFLVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYFLVkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYFLVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:40:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:62009 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYFLVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dHi8VTXl6R96BBVN6izSV6eg3NetoEgBIhd0kBcBOl0ScikfSJlB42XixfAYupJY2g
         /D1vuxpiYexlEb40rbeMndptceTsc7/mlfu4r6zx/J5fw3ARPX3uE7yqh7zEG2m08Q4c
         cCZuL6xJ12OW0PusauvGXTFwZhAnFygDDMQk4=
Message-ID: <48519782.9070306@gmail.com>
Date: Thu, 12 Jun 2008 23:39:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806111303.39267.bjorn.helgaas@hp.com> <485190AC.3060107@gmail.com> <200806121522.44199.bjorn.helgaas@hp.com>
In-Reply-To: <200806121522.44199.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2008 11:22 PM, Bjorn Helgaas wrote:
> On Thursday 12 June 2008 03:10:04 pm Jiri Slaby wrote:
>> On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
>>> Before you go to all the trouble of bisecting it, can you turn on
>>> CONFIG_PNP_DEBUG and try the following debug patch?  I think this
>>> will prevent the oops, but it's just papering over the real problem,
>>> so please capture the complete dmesg log.
>> ACPI: PCI interrupt for device 0000:00:02.0 disabled
>> serial 00:07: disabled
>> serial 00:06: disabled
>> ACPI handle has no context!
>> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
>> ...
>> serial 00:06:   no dma resource to encode!
>> serial 00:06: activated
>> serial 00:07:   no dma resource to encode!
>> serial 00:07: activated
>> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> 
> Interesting.  I wonder why a serial device would have a DMA resource.
> We encode resources by following a template from _CRS, so evidently
> that template had a DMA resource.  Or something deeper is wrong.
> 
> Can you send me the rest of that dmesg log?

Below.

> I take it that with the debug patch, your system is functional
> after resume?

Yes, it is :).

Linux version 2.6.26-rc5-mm3_64 (ku@bellona) (gcc version 4.3.1 20080507 
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #421 SMP Thu Jun 12 
22:59:48 CEST 2008
Command line: root=/dev/md1 vga=1 ro reboot=a,w slub_debug
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007d5b0000 (usable)
  BIOS-e820: 000000007d5b0000 - 000000007d5be000 (ACPI data)
  BIOS-e820: 000000007d5be000 - 000000007d5f0000 (ACPI NVS)
  BIOS-e820: 000000007d5f0000 - 000000007d600000 (reserved)
  BIOS-e820: 00000000fed90000 - 00000000fed94000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
last_pfn = 513456 max_arch_pfn = 17179869183
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI present.
ACPI: RSDP 000F9990, 0024 (r2 ACPIAM)
ACPI: XSDT 7D5B0100, 0064 (r1 A M I  OEMXSDT   5000708 MSFT       97)
ACPI: FACP 7D5B0290, 00F4 (r3 A M I  OEMFACP   5000708 MSFT       97)
ACPI: DSDT 7D5B0490, 6643 (r1 SDBLI9 SDBLI944       44 INTL 20051117)
ACPI: FACS 7D5BE000, 0040
ACPI: APIC 7D5B0390, 006C (r1 A M I  OEMAPIC   5000708 MSFT       97)
ACPI: MCFG 7D5B0450, 003C (r1 A M I  OEMMCFG   5000708 MSFT       97)
ACPI: OEMB 7D5BE040, 0079 (r1 A M I  AMI_OEM   5000708 MSFT       97)
ACPI: HPET 7D5B6AE0, 0038 (r1 A M I  OEMHPET   5000708 MSFT       97)
ACPI: GSCI 7D5BE0C0, 2024 (r1 A M I  GMCHSCI   5000708 MSFT       97)
ACPI: iEIT 7D5C00F0, 00B0 (r1 A M I  EITTABLE  5000708 MSFT       97)
ACPI: DMAR 7D5B6BC0, 0118 (r1 A M I  OEMDMAR         1 MSFT       97)
   early res: 0 [0-fff] BIOS data page
   early res: 1 [6000-7fff] TRAMPOLINE
   early res: 2 [200000-7cd447] TEXT DATA BSS
   early res: 3 [9ec00-fffff] BIOS reserved
   early res: 4 [8000-afff] PGTABLE
Scan SMP from ffff810000000000 for 1024 bytes.
Scan SMP from ffff81000009fc00 for 1024 bytes.
Scan SMP from ffff8100000f0000 for 65536 bytes.
  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff810001200000-ffff810002dfffff] 
on node 0
sizeof(struct page) = 56
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0:        0 ->      158
     0:      256 ->   513456
On node 0 totalpages: 513358
   DMA zone: 2352 pages, LIFO batch:0
   DMA32 zone: 502396 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a301 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7d600000:81790000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 35184 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 504748
Kernel command line: root=/dev/md1 vga=1 ro reboot=a,w slub_debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2992.466 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2014740k/2053824k available (3404k kernel code, 38056k reserved, 1500k 
data, 280k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 5992.29 BogoMIPS (lpj=11984590)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080321
CPU0: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
Using local APIC timer interrupts.
APIC timer calibration result 20781019
Detected 20.781 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5984.99 BogoMIPS (lpj=11969999)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (11977.29 BogoMIPS).
net_namespace: 568 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: To Be Filled By O.E.M.
ACPI: DMI Product Name: To Be Filled By O.E.M.
ACPI: DMI Product Version: To Be Filled By O.E.M.
ACPI: DMI Board Name: To be filled by O.E.M.
ACPI: DMI BIOS Vendor: American Megatrends Inc.
ACPI: DMI BIOS Date: 05/08/2007
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 12 *14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - C7, should be 
BC [20080321]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 23 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
tracer: 1286 pages allocated for 65536<6> entries of 80 bytes
    actual entries 65586
ACPI: RTC can wake from S4
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:09: ioport range 0xa20-0xa3f has been reserved
system 00:09: ioport range 0xa00-0xa0f has been reserved
system 00:09: ioport range 0xa10-0xa1f has been reserved
system 00:09: ioport range 0xa40-0xa5f has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x800-0x87f has been reserved
system 00:0a: ioport range 0x480-0x4bf has been reserved
system 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0e: iomem range 0xffc00000-0xffefffff could not be reserved
system 00:0f: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:10: iomem range 0xe0000000-0xefffffff has been reserved
system 00:12: iomem range 0xfed90000-0xfed90fff could not be reserved
system 00:13: iomem range 0xfed91000-0xfed91fff could not be reserved
system 00:14: iomem range 0xfed92000-0xfed92fff could not be reserved
system 00:15: iomem range 0xfed93000-0xfed93fff could not be reserved
system 00:16: iomem range 0x0-0x9ffff could not be reserved
system 00:16: iomem range 0xc0000-0xcffff has been reserved
system 00:16: iomem range 0xe0000-0xfffff could not be reserved
system 00:16: iomem range 0x100000-0x7d5fffff could not be reserved
PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.0
   IO window: disabled.
   MEM window: 0xff600000-0xff6fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
   IO window: disabled.
   MEM window: 0xff600000-0xff6fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
Int: type 0, pol 3, trig 3, bus 00, IRQ 70, APIC ID 2, APIC INT 11
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
Int: type 0, pol 3, trig 3, bus 00, IRQ 72, APIC ID 2, APIC INT 12
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 3936
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
agpgart: Detected an Intel G33 Chipset.
agpgart: Detected 6140K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 08, APIC ID 2, APIC INT 10
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
Int: type 0, pol 3, trig 3, bus 00, IRQ 0d, APIC ID 2, APIC INT 11
Couldn't register serial port 0000:00:03.3: -28
loop: module loaded
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
Int: type 0, pol 3, trig 3, bus 00, IRQ 64, APIC ID 2, APIC INT 14
PCI: Setting latency timer of device 0000:00:19.0 to 64
eth0: (PCI Express:2.5GB/s:Width x1) 00:13:20:f5:f2:1d
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 7d, APIC ID 2, APIC INT 13
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports ? Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xffa78800 port 0xffa78900 irq 221
ata2: SATA max UDMA/133 abar m2048@0xffa78800 port 0xffa78980 irq 221
ata3: SATA max UDMA/133 abar m2048@0xffa78800 port 0xffa78a00 irq 221
ata4: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 221
ata5: SATA max UDMA/133 abar m2048@0xffa78800 port 0xffa78b00 irq 221
ata6: SATA max UDMA/133 abar m2048@0xffa78800 port 0xffa78b80 irq 221
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
ata2.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.04, max UDMA/66
ata4.00: configured for UDMA/66
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sda: sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 3:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.04 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1a.7[D] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 6b, APIC ID 2, APIC INT 13
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 19, io mem 0xffa7b400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
Int: type 0, pol 3, trig 3, bus 00, IRQ 74, APIC ID 2, APIC INT 17
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xffa7b000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 68, APIC ID 2, APIC INT 10
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
Int: type 0, pol 3, trig 3, bus 00, IRQ 69, APIC ID 2, APIC INT 15
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
Int: type 0, pol 3, trig 3, bus 00, IRQ 6a, APIC ID 2, APIC INT 12
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000d480
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
Int: type 0, pol 3, trig 3, bus 00, IRQ 74, APIC ID 2, APIC INT 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 75, APIC ID 2, APIC INT 13
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[D] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 77, APIC ID 2, APIC INT 10
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000d000
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 6-1: new full speed USB device using uhci_hcd and address 2
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
Int: type 0, pol 3, trig 3, bus 00, IRQ 7e, APIC ID 2, APIC INT 12
usb 6-1: configuration #1 chosen from 1 choice
hub 6-1:1.0: USB hub found
hub 6-1:1.0: 3 ports detected
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.17rc1.
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
Int: type 0, pol 3, trig 3, bus 00, IRQ 6c, APIC ID 2, APIC INT 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usb 6-1.1: new full speed USB device using uhci_hcd and address 3
usb 6-1.1: configuration #1 chosen from 1 choice
ALSA device list:
   #0: HDA Intel at 0xffa70000 irq 22
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
PM: Resume from partition /dev/sda2
PM: Checking hibernation image.
PM: Resume from disk failed.
registered taskstats version 1
/home/l/latest/xxx/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
usb 6-1.2: new low speed USB device using uhci_hcd and address 4
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdb5 ...
md:  adding sdb5 ...
md: sdb3 has different UUID to sdb5
md: sdb2 has different UUID to sdb5
md:  adding sda5 ...
md: sda3 has different UUID to sdb5
md: sda2 has different UUID to sdb5
md: created md3
md: bind<sda5>
md: bind<sdb5>
md: running: <sdb5><sda5>
raid1: raid set md3 active with 2 out of 2 mirrors
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb2 has different UUID to sdb3
md:  adding sda3 ...
md: sda2 has different UUID to sdb3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
md2: setting max_sectors to 128, segment boundary to 32767
raid0: looking at sdb3
raid0:   comparing sdb3(11984384) with sdb3(11984384)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda3
raid0:   comparing sda3(11984384) with sdb3(11984384)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 23968768 blocks.
raid0 : conf->hash_spacing is 23968768 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
md: considering sdb2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
md1: setting max_sectors to 128, segment boundary to 32767
raid0: looking at sdb2
raid0:   comparing sdb2(4891712) with sdb2(4891712)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda2
raid0:   comparing sda2(4891648) with sdb2(4891712)
raid0:   NOT EQUAL
raid0:   comparing sda2(4891648) with sda2(4891648)
raid0:   END
raid0:   ==> UNIQUE
raid0: 2 zones
raid0: FINAL 2 zones
raid0: zone 1
raid0: checking sdb2 ... contained as device 0
   (4891712) is smallest!.
raid0: checking sda2 ... nope.
raid0: zone->nb_dev: 1, size: 64
raid0: current zone offset: 4891712
raid0: done.
raid0 : md_size is 9783360 blocks.
raid0 : conf->hash_spacing is 9783296 blocks.
raid0 : nb_zone is 2.
raid0 : Allocating 16 bytes for hash.
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 280k freed
Write protecting the kernel read-only data: 4616k
usb 6-1.2: configuration #1 chosen from 1 choice
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
Int: type 0, pol 3, trig 3, bus 03, IRQ 00, APIC ID 2, APIC INT 12
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[ff6ff800-ff6fffff]  Max 
Packet=[2048]  IR/IT contexts=[4/8]
usbcore: registered new interface driver hiddev
input: ABBHOME USB Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.1/6-1.1:1.0/input/input2
input,hidraw0: USB HID v1.10 Keyboard [ABBHOME USB Keyboard] on usb-0000:00:1d.0-1.1
input: ABBHOME USB Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.1/6-1.1:1.1/input/input3
input,hidraw1: USB HID v1.10 Mouse [ABBHOME USB Keyboard] on usb-0000:00:1d.0-1.1
input: Microsoft Corporation Microsoft � Laser Mouse 6000 as 
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1.2/6-1.2:1.0/input/input4
input,hidraw2: USB HID v1.11 Mouse [Microsoft Corporation Microsoft � Laser 
Mouse 6000] on usb-0000:00:1d.0-1.2
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Adding 2008084k swap on /dev/sdb6.  Priority:-1 extents:1 across:2008084k
EXT3 FS on md1, internal journal
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0000000000000000]
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
warning: `named' uses deprecated v2 capabilities in a way that may be insecure.
warning: `proftpd' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present
set status page addr 0x00043000





--------------------------------------------------------------------------
SUSPEND:


PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI: PCI interrupt for device 0000:00:02.0 disabled
serial 00:07: disabled
serial 00:06: disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
ACPI: PCI interrupt for device 0000:00:1a.7 disabled
ACPI: PCI interrupt for device 0000:00:1a.2 disabled
ACPI: PCI interrupt for device 0000:00:1a.1 disabled
ACPI: PCI interrupt for device 0000:00:1a.0 disabled
ACPI: PCI interrupt for device 0000:00:19.0 disabled
ACPI handle has no context!
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5985.09 BogoMIPS (lpj=11970190)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
CPU1 is up
PM: Writing back config space on device 0000:00:02.0 at offset 6 (was c0000008, 
writing d0000008)
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, 
writing 900003)
PM: Writing back config space on device 0000:00:03.0 at offset f (was 100, 
writing 105)
PM: Writing back config space on device 0000:00:03.1 at offset f (was 400, 
writing 40f)
PM: Writing back config space on device 0000:00:03.1 at offset b (was 0, writing 
29c58086)
PM: Writing back config space on device 0000:00:03.1 at offset 4 (was fed11004, 
writing ffa7b804)
PM: Writing back config space on device 0000:00:03.1 at offset 1 (was 100006, 
writing 180006)
PM: Writing back config space on device 0000:00:03.2 at offset f (was 300, 
writing 30c)
PM: Writing back config space on device 0000:00:03.2 at offset 8 (was 1, writing 
e081)
PM: Writing back config space on device 0000:00:03.2 at offset 7 (was 1, writing 
e401)
PM: Writing back config space on device 0000:00:03.2 at offset 6 (was 1, writing 
e481)
PM: Writing back config space on device 0000:00:03.2 at offset 5 (was 1, writing 
e801)
Switched to high resolution mode on CPU 1
PM: Writing back config space on device 0000:00:03.3 at offset f (was 200, 
writing 20a)
PM: Writing back config space on device 0000:00:03.3 at offset 5 (was 0, writing 
ffa7a000)
PM: Writing back config space on device 0000:00:19.0 at offset f (was 100, 
writing 10e)
PM: Writing back config space on device 0000:00:19.0 at offset 6 (was 1, writing 
dc01)
PM: Writing back config space on device 0000:00:19.0 at offset 5 (was 0, writing 
ffa79000)
PM: Writing back config space on device 0000:00:19.0 at offset 4 (was 0, writing 
ffa40000)
PM: Writing back config space on device 0000:00:19.0 at offset 1 (was 100000, 
writing 100007)
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
Int: type 0, pol 3, trig 3, bus 00, IRQ 64, APIC ID 2, APIC INT 14
PCI: Setting latency timer of device 0000:00:19.0 to 64
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 68, APIC ID 2, APIC INT 10
PCI: Setting latency timer of device 0000:00:1a.0 to 64
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
Int: type 0, pol 3, trig 3, bus 00, IRQ 69, APIC ID 2, APIC INT 15
PCI: Setting latency timer of device 0000:00:1a.1 to 64
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
Int: type 0, pol 3, trig 3, bus 00, IRQ 6a, APIC ID 2, APIC INT 12
PCI: Setting latency timer of device 0000:00:1a.2 to 64
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1a.7[D] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 6b, APIC ID 2, APIC INT 13
PCI: Setting latency timer of device 0000:00:1a.7 to 64
PM: Writing back config space on device 0000:00:1b.0 at offset 3 (was 0, writing 8)
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, 
writing 100002)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
Int: type 0, pol 3, trig 3, bus 00, IRQ 6c, APIC ID 2, APIC INT 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PM: Writing back config space on device 0000:00:1c.0 at offset f (was 20100, 
writing 2010a)
PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was 810000, 
writing 810008)
PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100104, 
writing 100504)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PM: Writing back config space on device 0000:00:1c.2 at offset f (was 20300, 
writing 2030c)
PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was f0, 
writing 200000f0)
PM: Writing back config space on device 0000:00:1c.2 at offset 3 (was 810000, 
writing 810008)
PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100106, 
writing 100506)
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
Int: type 0, pol 3, trig 3, bus 00, IRQ 74, APIC ID 2, APIC INT 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb6: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Int: type 0, pol 3, trig 3, bus 00, IRQ 75, APIC ID 2, APIC INT 13
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb7: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.2[D] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 77, APIC ID 2, APIC INT 10
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb8: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
Int: type 0, pol 3, trig 3, bus 00, IRQ 74, APIC ID 2, APIC INT 17
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1e.0 at offset f (was 20000, 
writing 200ff)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, 
writing 2b00407)
PCI: Setting latency timer of device 0000:00:1f.2 to 64
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
PM: Writing back config space on device 0000:00:1f.6 at offset b (was 0, writing 
29328086)
PM: Writing back config space on device 0000:02:00.0 at offset 7 (was 2a001f1, 
writing 22a001f1)
PCI: Setting latency timer of device 0000:02:00.0 to 64
PM: Writing back config space on device 0000:03:00.0 at offset f (was 4020100, 
writing 402010c)
PM: Writing back config space on device 0000:03:00.0 at offset 5 (was 0, writing 
ff6f8000)
PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing 
ff6ff800)
PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 
4008)
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 2300000, 
writing 2300016)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[ff6ff800-ff6fffff]  Max 
Packet=[2048]  IR/IT contexts=[4/8]
serial 00:06:   no dma resource to encode!
serial 00:06: activated
serial 00:07:   no dma resource to encode!
serial 00:07: activated
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
Int: type 0, pol 3, trig 3, bus 00, IRQ 08, APIC ID 2, APIC INT 10
sd 0:0:0:0: [sda] Starting disk
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
ata4.00: configured for UDMA/66
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
sd 1:0:0:0: [sdb] Starting disk
usb 6-1: reset full speed USB device using uhci_hcd and address 2
usb 6-1.1: reset full speed USB device using uhci_hcd and address 3
usb 6-1.2: reset low speed USB device using uhci_hcd and address 4
PM: Finishing wakeup.
Restarting tasks ... done.

