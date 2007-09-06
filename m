Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbXIFPBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbXIFPBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbXIFPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:00:30 -0400
Received: from relaymail.wedohosting.com ([64.141.0.84]:51812 "HELO
	relaymail.wedohosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755037AbXIFPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:00:23 -0400
Message-ID: <46E01601.9010907@arbores.ca>
Date: Thu, 06 Sep 2007 08:00:17 -0700
From: Bryan Woods <bryan@arbores.ca>
Reply-To: bryan@arbores.ca
Organization: Arbores Infosystems Inc.
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Tejun Heo <htejun@gmail.com>, Michal.k.k.Piotrowski@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca> <6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com> <46DBCB6C.8080206@gmail.com>
In-Reply-To: <46DBCB6C.8080206@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------060407010300030306070102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060407010300030306070102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Michal Piotrowski wrote:
>> Hi,
>>
>> [Adding linux-ide to CC]
>>
>> On 25/08/07, Bryan Woods <bryan@arbores.ca> wrote:
>>> Hi KML
>>>
>>> I am installing gentoo 2007.0 (kernel 2.6.19) on a dual AMD Opteron server (total of 4 cores). The hard disk is a Stardom 2611-2S-S1 device: actually two 250GB drives in a RAID0 config managed by the device itself - it should appear to the kernel as one SATA drive. If it matters, the underlying HDs are "Seagate Barracuda 7200 10"s. Here's the device:
>>>
>>>  http://www.synetic.net/Synetic-Products/Stardoms/SR-2611-SA/Stardom-2611.htm
>>>
>>> During the install and at different points in the process I get an "HSM violation" and the system becomes unresponsive. It looks like a similar situation to:
>>>
>>>   http://lkml.org/lkml/2007/6/6/195
>>>
>>> Will more recent kernels work with this hardware (should I keep it and try the install again) or should I switch hardware to something more compatible (like an Adaptec card)?
>>>
>>> Thanks!
>>> Bryan
>>>
>>> --
>>> console output:
>>>
>>> tag 0 cmd 0x39 Emask 0x2 stat 0x58 err 0x0 (HSM violation)
>>> exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>>
> 
> Please post full dmesg and full 'hdparm -I' result.  Also, if possible,
> please try 2.6.22.5.  Even if it doesn't fix the problem, it would
> report error conditions better.
> 

The full dmesg and hdparm -I command output are attached.

I have received word from the vendor that the Stardom 2611 will do
RAID0 or 1 under windows, but only RAID1 under Linux. (Their manual
said it worked with Linux but failed to mention the RAID mode
restriction: argh!)

They recommended the 2600 model for RAID0 with Linux, but that model
is only SATA-I so I will probably go with alternate hardware.

The vendor also suggested the possibility of a firmware upgrade to
the 2611 - I am still waiting to hear. I will post a followup if
this happens.

Thanks all for your help and suggestions!

Regards,
Bryan

--------------060407010300030306070102
Content-Type: text/plain;
 name="hdparm.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hdparm.txt"


/dev/sda:

ATA device, with non-removable media
	Model Number:       STARDOM V.36.A0B                        
	Serial Number:      
	Firmware Revision:  V.36.A0B
Standards:
	Used: ATA/ATAPI-6 T13 1410D revision 0 
	Supported: 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  976794112
	device size with M = 1024*1024:      476950 MBytes
	device size with M = 1000*1000:      500118 MBytes (500 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Standby timer values: spec'd by Standard, with device specific minimum
	R/W multiple sector transfer: Max = 1	Current = 1
	Advanced power management level: unknown setting (0x0000)
	DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 udma3 udma4 udma5 udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	   *	Power Management feature set
	   *	Advanced Power Management feature set
	   *	48-bit Address feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
HW reset results:
	CBLID- above Vih
	Device num = 1

--------------060407010300030306070102
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

Linux version 2.6.19-gentoo-r5 (root@poseidon) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #1 SMP Fri Mar 23 22:03:13 UTC 2007
Command line: root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs loop=/image.squashfs cdroot initrd=gentoo.igz vga=791 BOOT_IMAGE=gentoo 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7fd0000 (usable)
 BIOS-e820: 00000000d7fd0000 - 00000000d7fde000 (ACPI data)
 BIOS-e820: 00000000d7fde000 - 00000000d8000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000128000000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 884688) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1212416) 2 entries of 256 used
end_pfn_map = 1212416
DMI present.
ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000f8df0
ACPI: XSDT (v001 A M I  OEMXSDT  0x12000629 MSFT 0x00000097) @ 0x00000000d7fd0100
ACPI: FADT (v003 A M I  OEMFACP  0x12000629 MSFT 0x00000097) @ 0x00000000d7fd0290
ACPI: MADT (v001 A M I  OEMAPIC  0x12000629 MSFT 0x00000097) @ 0x00000000d7fd0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x12000629 MSFT 0x00000097) @ 0x00000000d7fd0410
ACPI: OEMB (v001 A M I  AMI_OEM  0x12000629 MSFT 0x00000097) @ 0x00000000d7fde040
ACPI: HPET (v001 A M I  OEMHPET0 0x12000629 MSFT 0x00000097) @ 0x00000000d7fd4d10
ACPI: SRAT (v001 AMD    HAMMER   0x00000001 AMD  0x00000001) @ 0x00000000d7fd4d50
ACPI: SSDT (v001 A M I  POWERNOW 0x00000001 AMD  0x00000001) @ 0x00000000d7fd4e60
ACPI: DSDT (v001  0AAAA 0AAAA000 0x00000000 INTL 0x20051117) @ 0x0000000000000000
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 884688) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1212416) 2 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1212416
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   884688
    0:  1048576 ->  1212416
On node 0 totalpages: 1048431
  DMA zone: 56 pages used for memmap
  DMA zone: 1003 pages reserved
  DMA zone: 2940 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 866312 pages, LIFO batch:31
  Normal zone: 2240 pages used for memmap
  Normal zone: 161600 pages, LIFO batch:31
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Nosave address range: 00000000d7fd0000 - 00000000d7fde000
Nosave address range: 00000000d7fde000 - 00000000d8000000
Nosave address range: 00000000d8000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 00000000fec01000
Nosave address range: 00000000fec01000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fef00000
Nosave address range: 00000000fef00000 - 0000000100000000
Allocating PCI resources starting at dc000000 (gap: d8000000:26c00000)
PERCPU: Allocating 32960 bytes of per cpu data
Built 1 zonelists.  Total pages: 1030852
Kernel command line: root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs loop=/image.squashfs cdroot initrd=gentoo.igz vga=791 BOOT_IMAGE=gentoo 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Speakup v-2.00 CVS: Sat Oct 7 10:52:29 EDT 2006 : initialized
Console: colour dummy device 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ d8000000 size 128 MB
CPU 1: aperture @ d8000000 size 128 MB
Memory: 4111828k/4849664k available (2595k kernel code, 81484k reserved, 750k data, 228k init)
Calibrating delay using timer specific routine.. 4003.68 BogoMIPS (lpj=20018420)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12502066
Detected 12.502 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4000.19 BogoMIPS (lpj=20000995)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 635 cycles)
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4000.20 BogoMIPS (lpj=20001047)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
CPU 2: Syncing TSC to CPU 0.
CPU 2: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 1107 cycles)
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 3994.48 BogoMIPS (lpj=19972446)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
CPU 3: Syncing TSC to CPU 0.
CPU 3: synchronized TSC with CPU 0 (last diff 72 cycles, maxerr 1110 cycles)
Brought up 4 CPUs
testing NMI watchdog ... OK.
time.c: Using 25.000000 MHz WALL HPET GTOD HPET timer.
time.c: Detected 2000.331 MHz processor.
migration_cost=573
checking if image is initramfs... it is
Freeing initrd memory: 4723k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
pci_get_subsys() called while pci_devices is still empty
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:07.0
PCI: Transparent bridge - 0000:00:06.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *5
ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *7
ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSA2] (IRQs 20 21 22 23) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ d8000000 size 131072 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 128MB of IOMMU area in the AGP aperture
pnp: 00:0a: ioport range 0xca0-0xcaf has been reserved
pnp: 00:0c: ioport range 0xa00-0xa7f has been reserved
PCI: Bridge: 0000:00:06.0
  IO window: e000-efff
  MEM window: f9f00000-f9ffffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.1
  IO window: disabled.
  MEM window: fa000000-fdffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: fa000000-fdffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0f.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
PCI: Setting latency timer of device 0000:05:00.1 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Setting latency timer of device 0000:00:0f.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
squashfs: version 3.1 (2006/08/19) Phillip Lougher
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler deadline registered (default)
PCI: Setting latency timer of device 0000:00:0a.0 to 64
pcie_portdrv_probe->Dev[0376:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0a.0:pcie00]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
pcie_portdrv_probe->Dev[0374:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
pcie_portdrv_probe->Dev[0374:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
pcie_portdrv_probe->Dev[0378:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
pcie_portdrv_probe->Dev[0375:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
PCI: Setting latency timer of device 0000:00:0f.0 to 64
pcie_portdrv_probe->Dev[0377:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0f.0:pcie00]
initialized device: /dev/synth, node ( MAJOR 10, MINOR 25 )
Linux agpgart interface v0.101 (c) Dave Jones
vesafb: framebuffer at 0xf0000000, mapped to 0xffffc20000080000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP55: IDE controller at PCI slot 0000:00:04.0
NFORCE-MCP55: chipset revision 161
NFORCE-MCP55: not 100% native mode: will probe irqs later
NFORCE-MCP55: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP55: 0000:00:04.0 (rev a1) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
hda: HL-DT-STDVD-RAM GSA-H54N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 228k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf9efac00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
USB Universal Host Controller Interface driver v3.0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf9efb000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 2-4: new full speed USB device using ohci_hcd and address 2
usb 2-4: configuration #1 chosen from 1 choice
hub 2-4:1.0: USB hub found
hub 2-4:1.0: 2 ports detected
usb 2-4.1: new full speed USB device using ohci_hcd and address 3
usb 2-4.1: configuration #1 chosen from 1 choice
usb 2-4.2: new full speed USB device using ohci_hcd and address 4
usb 2-4.2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Chicony IBM Preferred Pro USB Fingerprint Keyboard as /class/input/input0
input: USB HID v1.10 Keyboard [Chicony IBM Preferred Pro USB Fingerprint Keyboard] on usb-0000:00:02.0-4.1
hiddev96: USB HID v1.10 Device [Chicony IBM Preferred Pro USB Fingerprint Keyboard] on usb-0000:00:02.0-4.1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
sl811: driver sl811-hcd, 19 May 2005
ieee1394: Initialized config rom entry `ip1394'
ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
ieee1394: sbp2: Try serialize_io=0 for better performance
libata version 2.00 loaded.
sata_nv 0000:00:05.0: version 2.0
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:05.0 to 64
ata1: SATA max UDMA/133 cmd 0xD480 ctl 0xD402 bmdma 0xCC00 irq 21
ata2: SATA max UDMA/133 cmd 0xD080 ctl 0xD002 bmdma 0xCC08 irq 21
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6, max UDMA/133, 976794112 sectors: LBA48 
ata1.00: ata1: dev 0 multi count 1
ata1.00: applying bridge limits
ata1.00: configured for UDMA/100
scsi1 : sata_nv
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xD087
scsi 0:0:0:0: Direct-Access     ATA      STARDOM V.36.A0B V.36 PQ: 0 ANSI: 5
SCSI device sda: 976794112 512-byte hdwr sectors (500119 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write through
SCSI device sda: 976794112 512-byte hdwr sectors (500119 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:05.1 to 64
ata3: SATA max UDMA/133 cmd 0xC880 ctl 0xC802 bmdma 0xC080 irq 20
ata4: SATA max UDMA/133 cmd 0xC480 ctl 0xC402 bmdma 0xC088 irq 20
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xC887
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xC487
ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:05.2 to 64
ata5: SATA max UDMA/133 cmd 0xC000 ctl 0xBC02 bmdma 0xB480 irq 23
ata6: SATA max UDMA/133 cmd 0xB880 ctl 0xB802 bmdma 0xB488 irq 23
scsi4 : sata_nv
ata5: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xC007
scsi5 : sata_nv
ata6: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0xB887
device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised: dm-devel@redhat.com
JFS: nTxBlock = 8192, nTxLock = 65536
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4
Copyright (c) 1999-2006 Intel Corporation.
UDF-fs: No partition found (1)
XFS: bad magic number
XFS: SB validate failed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: limiting speed to UDMA/66
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/66
ata1: EH complete
ata1.00: limiting speed to UDMA/44
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/44
ata1: EH complete
ata1.00: limiting speed to UDMA/33
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x20)
ata1.00: tag 0 cmd 0xca Emask 0x2 stat 0x0 err 0x0 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/33
sd 0:0:0:0: SCSI error: return code = 0x08000002
sda: Current: sense key=0xb
    ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 254097917
Buffer I/O error on device sda2, logical block 31752199
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752200
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752201
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752202
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752203
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752204
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752205
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752206
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752207
lost page write due to I/O error on sda2
Buffer I/O error on device sda2, logical block 31752208
lost page write due to I/O error on sda2
ata1: EH complete
SCSI device sda: 976794112 512-byte hdwr sectors (500119 MB)
ReiserFS: sda2: warning: journal-1226: REPLAY FAILURE, fsck required! buffer write failed
ReiserFS: sda2: warning: Replay Failure, unable to mount
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write through
SCSI device sda: 976794112 512-byte hdwr sectors (500119 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write through
UDF-fs: No partition found (1)
XFS: bad magic number
XFS: SB validate failed
UDF-fs: No partition found (1)
XFS: bad magic number
XFS: SB validate failed
ISO 9660 Extensions: Microsoft Joliet Level 3
Unable to load NLS charset iso8859-1
Unable to load NLS charset iso8859-1
ISO 9660 Extensions: RRIP_1991A
Real Time Clock Driver v1.12ac

--------------060407010300030306070102--
