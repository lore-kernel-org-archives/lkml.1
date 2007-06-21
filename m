Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbXFUQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbXFUQLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbXFUQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:10:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41663 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757102AbXFUQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:10:55 -0400
Date: Thu, 21 Jun 2007 18:10:50 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-ID: <20070621161050.GA5285@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net
References: <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com> <20070620154610.GA2802@localhost.localdomain> <20070621054318.GA31381@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621054318.GA31381@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 01:43:18PM +0800, Wang Zhenyu wrote:
> Thanks Carlo to report this problem. The following patch should fix
> his and potential issue.

Thanks for fixing it Wang :)
I have to admit that the Real Reason I did put time into this is because
I wanted to be sure that when debian upgrades 'testing' to the next
kernel, that I wouldn't be f*ck*d. But - as I just read in the new
kernel testing howto - that is a legit reason to do kernel testing ;)

> [AGPGART] intel_agp: don't load if no IGD detected and no AGP port
> 
> After i915 chip, GMCH has no AGP port. Origin bridge driver in device
> table will try to access illegal regs like APBASE, APSIZE, etc. This
> may cause problem.

I am glad to see that you found a real reason for why it might have
gone wrong. Just not initializing because it's not needed, but not
understanding WHY it went wrong would have been rather unsatisfactory.

I've tested this patch - and it works (is this the point where I'd
add an 'Ack-something'? Here is the dmesg (the -agp1 in the version
is your patch):

Linux version 2.6.22-rc5-agp1-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 (carlo@hikaru) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Thu Jun 21 15:16:09 CEST 2007
Command line: root=/dev/md2 ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
end_pfn_map = 1572864
DMI 2.4 present.
ACPI: RSDP 000FAE40, 0024 (r2 ACPIAM)
ACPI: XSDT 7FF90100, 0054 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000709 MSFT       97)
ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   3000709 MSFT       97)
ACPI: DSDT 7FF905C0, 8E7D (r1  A0483 A0483035       35 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   3000709 MSFT       97)
ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   3000709 MSFT       97)
ACPI: SLIC 7FF90440, 0176 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000709 MSFT       97)
ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   3000709 MSFT       97)
ACPI: HPET 7FF99440, 0038 (r1 MSTEST OEMHPET   3000709 MSFT       97)
No NUMA configuration found
Faking a node at 0000000000000000-0000000180000000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 524176) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000180000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524176
    0:  1048576 ->  1572864
On node 0 totalpages: 1048366
  DMA zone: 56 pages used for memmap
  DMA zone: 993 pages reserved
  DMA zone: 2949 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505800 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e4000
swsusp: Registered nosave memory region: 00000000000e4000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007ff90000 - 000000007ff9e000
swsusp: Registered nosave memory region: 000000007ff9e000 - 000000007ffe0000
swsusp: Registered nosave memory region: 000000007ffe0000 - 0000000080000000
swsusp: Registered nosave memory region: 0000000080000000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000ffb00000
swsusp: Registered nosave memory region: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37768 bytes of per cpu data
Built 1 zonelists.  Total pages: 1025869
Kernel command line: root=/dev/md2 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 2666.668 MHz processor.
Console: colour VGA+ 80x25
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1059000 - 0x5059000
Memory: 4030964k/6291456k available (2015k kernel code, 162500k reserved, 947k data, 296k init)
Calibrating delay using timer specific routine.. 5336.91 BogoMIPS (lpj=10673831)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666663
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5333.36 BogoMIPS (lpj=10666734)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5333.39 BogoMIPS (lpj=10666780)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5333.36 BogoMIPS (lpj=10666722)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
migration_cost=3353
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0103
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: 00:08: iomem range 0xffafe000-0xffb0cbff could not be reserved
pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
Time: tsc clocksource has been installed.
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
pnp: match found with the PnP device '00:0e' and the driver 'system'
pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0e: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8800000-fe8fffff
  PREFETCH window: bfe00000-dfdfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.5
  IO window: b000-bfff
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6182k freed
audit: initializing netlink socket (disabled)
audit(1182441605.492:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:0b' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0c' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 296k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  F5, should be F4 [20070126]
ACPI: SSDT 7FF9E0C0, 0208 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: SSDT 7FF9E2D0, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
ACPI: SSDT 7FF9E410, 013A (r1    AMI   CPU3PM        1 INTL 20060113)
ACPI: SSDT 7FF9E550, 013A (r1    AMI   CPU4PM        1 INTL 20060113)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
usb 5-2: new low speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A as /class/input/input1
input: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20001448900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc20001448980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata3: SATA max UDMA/133 cmd 0xffffc20001448a00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc20001448a80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata5: SATA max UDMA/133 cmd 0xffffc20001448b00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata6: SATA max UDMA/133 cmd 0xffffc20001448b80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata1.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata1.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata2.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata2.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata3.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata3.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata4.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata4.00: configured for UDMA/133
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI: LITE-ON DVDRW LH-20A1S, 9L02, max UDMA/100
ata5.00: configured for UDMA/100
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1S   9L02 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[feaff800-feafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 145226112 512-byte hardware sectors (74356 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 145226112 512-byte hardware sectors (74356 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: [sdc] 145226112 512-byte hardware sectors (74356 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 145226112 512-byte hardware sectors (74356 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 >
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: [sdd] Attached SCSI disk
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sr 4:0:0:0: Attached scsi generic sg4 type 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
Probing IDE interface ide0...
Probing IDE interface ide1...
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800011b7cd2]
md: raid1 personality registered for level 1
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  9514.000 MB/sec
raid5: using function: generic_sse (9514.000 MB/sec)
raid6: int64x1   2501 MB/s
raid6: int64x2   3018 MB/s
raid6: int64x4   2876 MB/s
raid6: int64x8   1920 MB/s
raid6: sse2x1    4192 MB/s
raid6: sse2x2    4387 MB/s
raid6: sse2x4    7840 MB/s
raid6: using algorithm sse2x4 (7840 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md0 stopped.
md: bind<sdb1>
md: bind<sdc1>
md: bind<sda1>
raid1: raid set md0 active with 3 out of 3 mirrors
md: md1 stopped.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sda2>
raid5: device sda2 operational as raid disk 0
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 3212kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: md2 stopped.
md: bind<sdb3>
md: bind<sdc3>
md: bind<sda3>
raid5: device sda3 operational as raid disk 0
raid5: device sdc3 operational as raid disk 2
raid5: device sdb3 operational as raid disk 1
raid5: allocated 3212kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
md: md3 stopped.
md: bind<sdb5>
md: bind<sdc5>
md: bind<sda5>
raid5: device sda5 operational as raid disk 0
raid5: device sdc5 operational as raid disk 2
raid5: device sdb5 operational as raid disk 1
raid5: allocated 3212kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda5
 disk 1, o:1, dev:sdb5
 disk 2, o:1, dev:sdc5
md: md4 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid5: device sda6 operational as raid disk 0
raid5: device sdc6 operational as raid disk 2
raid5: device sdb6 operational as raid disk 1
raid5: allocated 3212kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda6
 disk 1, o:1, dev:sdb6
 disk 2, o:1, dev:sdc6
md: md5 stopped.
md: bind<sdb7>
md: bind<sdc7>
md: bind<sda7>
raid5: device sda7 operational as raid disk 0
raid5: device sdc7 operational as raid disk 2
raid5: device sdb7 operational as raid disk 1
raid5: allocated 3212kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda7
 disk 1, o:1, dev:sdb7
 disk 2, o:1, dev:sdc7
md: md6 stopped.
md: bind<sdb8>
md: bind<sdc8>
md: bind<sda8>
raid5: device sda8 operational as raid disk 0
raid5: device sdc8 operational as raid disk 2
raid5: device sdb8 operational as raid disk 1
raid5: allocated 3212kB for md6
raid5: raid level 5 set md6 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda8
 disk 1, o:1, dev:sdb8
 disk 2, o:1, dev:sdc8
md: md7 stopped.
md: bind<sdb9>
md: bind<sdc9>
md: bind<sda9>
raid5: device sda9 operational as raid disk 0
raid5: device sdc9 operational as raid disk 2
raid5: device sdb9 operational as raid disk 1
raid5: allocated 3212kB for md7
raid5: raid level 5 set md7 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda9
 disk 1, o:1, dev:sdb9
 disk 2, o:1, dev:sdc9
md: md8 stopped.
md: bind<sdb10>
md: bind<sdc10>
md: bind<sda10>
raid5: device sda10 operational as raid disk 0
raid5: device sdc10 operational as raid disk 2
raid5: device sdb10 operational as raid disk 1
raid5: allocated 3212kB for md8
raid5: raid level 5 set md8 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda10
 disk 1, o:1, dev:sdb10
 disk 2, o:1, dev:sdc10
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input2
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.14 addr 0xfe9fc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
sky2 eth0: addr 00:1a:92:3a:4a:c1
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
gameport: EMU10K1 is pci0000:04:02.1/gameport0, io 0xcc00, speed 1041kHz
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
input: PS/2 Logitech Mouse as /class/input/input3
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
EXT3 FS on md2, internal journal
loop: module loaded
coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.2: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.3: Using undocumented features, absolute temperature might be wrong!
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 15631096k swap on /dev/mapper/cswap.  Priority:1 extents:1 across:15631096k
sky2 eth1: enabling interface
sky2 eth1: ram buffer 0K
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
pnp: the driver 'parport_pc' has been registered
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth1: no IPv6 routers present


Hmm, the dmesg stops here... Perhaps I should have
captured it with the serial console. But well, I'll
consider it fixed I don't think there was a warning
message. If there is then I'll post that later.

-- 
Carlo Wood <carlo@alinoe.com>
