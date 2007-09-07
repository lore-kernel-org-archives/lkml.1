Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIGSD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIGSD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 14:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbXIGSDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 14:03:21 -0400
Received: from cse-mail.unl.edu ([129.93.165.11]:34501 "EHLO cse-mail.unl.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbXIGSDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 14:03:17 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 14:03:16 EDT
Message-ID: <46E190FA.7000701@cse.unl.edu>
Date: Fri, 07 Sep 2007 12:57:14 -0500
From: "Sumanth J.V" <sumanth@cse.unl.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Spurious completions during NCQ
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (cse-mail.unl.edu [129.93.165.11]); Fri, 07 Sep 2007 12:57:21 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I keep seeing this message a few times a day on my box.

ata1.00: exception Emask 0x2 SAct 0x18 SErr 0x0 action 0x2 frozen
ata1.00: (spurious completions during NCQ issue=0x0 SAct=0x18 
FIS=004040a1:00000004)
ata1.00: cmd 60/08:18:bf:04:df/00:00:23:00:00/40 tag 3 cdb 0x0 data 4096 in
         res 40/00:24:c7:04:df/00:00:23:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/78:20:c7:04:df/00:00:23:00:00/40 tag 4 cdb 0x0 data 61440 in
         res 40/00:24:c7:04:df/00:00:23:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA



Can I assume that my data integrity is not compromised? Any idea what is 
happening to the pending writes during the soft reset? How can I verify 
that all the pending writes were committed?

I have attached the output of my dmesg, lspci, sdparm and mdadm. Do let 
me know if you need any other info?

Regards,
Sumanth


------------ dmesg output: --------------------
Linux version 2.6.22.4-65.fc7 
(kojibuilder@xenbuilder2.fedora.redhat.com) (gcc version 4.1.2 20070502 
(Red Hat 4.1.2-12)) #1 SMP Tue Aug 21 21:50:50 EDT 2007
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 2 entries of 3200 used
end_pfn_map = 1179648
DMI 2.4 present.
ACPI: RSDP 000F6F10, 0014 (r0 GBT   )
ACPI: RSDT DFEE3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP DFEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT DFEE3180, 4A88 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS DFEE0000, 0040
ACPI: HPET DFEE7D80, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG DFEE7E00, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC DFEE7C80, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: SSDT DFEE7E80, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
ACPI: SSDT DFEE8430, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000120000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1179648
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   917216
    0:  1048576 ->  1179648
On node 0 totalpages: 1048190
  DMA zone: 56 pages used for memmap
  DMA zone: 1303 pages reserved
  DMA zone: 2639 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 898840 pages, LIFO batch:31
  Normal zone: 1792 pages used for memmap
  Normal zone: 129280 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
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
swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
swsusp: Registered nosave memory region: 00000000dfee0000 - 00000000dfee3000
swsusp: Registered nosave memory region: 00000000dfee3000 - 00000000dfef0000
swsusp: Registered nosave memory region: 00000000dfef0000 - 00000000dff00000
swsusp: Registered nosave memory region: 00000000dff00000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000f4000000
swsusp: Registered nosave memory region: 00000000f4000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at e0000000 (gap: dff00000:10100000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 40968 bytes of per cpu data
Built 1 zonelists.  Total pages: 1030759
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2399.997 MHz processor.
Console: colour VGA+ 80x25
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1047000 - 0x5047000
Memory: 4060052k/4718592k available (2362k kernel code, 132708k 
reserved, 1399k data, 312k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4802.61 BogoMIPS 
(lpj=2401307)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666627
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.04 BogoMIPS 
(lpj=2400022)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x3
Initializing CPU#2
Calibrating delay using timer specific routine.. 4799.98 BogoMIPS 
(lpj=2399991)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 2/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x1
Initializing CPU#3
Calibrating delay using timer specific routine.. 4799.98 BogoMIPS 
(lpj=2399991)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=2048 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at f0000000 - f3ffffff
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
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
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: 00:08: ioport range 0x400-0x4bf has been reserved
pnp: 00:09: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:0a: iomem range 0xd5000-0xd7fff has been reserved
pnp: 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0a: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: b000-bfff
  MEM window: f4000000-f7ffffff
  PREFETCH window: e0000000-efffffff
PCI: Bridge: 0000:00:1c.0
  IO window: a000-afff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: c000-cfff
  MEM window: fa000000-fa0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: d000-dfff
  MEM window: f8000000-f9ffffff
  PREFETCH window: fa200000-fa2fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-9fff
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
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3779k freed
audit: initializing netlink socket (disabled)
audit(1189149752.663:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 34BBEB243C265B53
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
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
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 2 throttling states)
ACPI: SSDT DFEE8280, 0087 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
ACPI: Processor [CPU1] (supports 2 throttling states)
ACPI: SSDT DFEE8310, 0087 (r1  PmRef  Cpu2Ist     3000 INTL 20040311)
ACPI: Processor [CPU2] (supports 2 throttling states)
ACPI: SSDT DFEE83A0, 0087 (r1  PmRef  Cpu3Ist     3000 INTL 20040311)
ACPI: Processor [CPU3] (supports 2 throttling states)
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 312k freed
Write protecting the kernel read-only data: 1060k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input1
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfa104000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfa105000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
usb 1-1: USB disconnect, address 2
SCSI subsystem initialized
libata version 2.21 loaded.
ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
usb 1-1: new low speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1
input: Logitech USB Receiver as /class/input/input4
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1
usb 1-2: new low speed USB device using uhci_hcd and address 4
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA 
mode
ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000638100 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
ata2: SATA max UDMA/133 cmd 0xffffc20000638180 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
ata3: SATA max UDMA/133 cmd 0xffffc20000638200 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
ata4: SATA max UDMA/133 cmd 0xffffc20000638280 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
ata5: SATA max UDMA/133 cmd 0xffffc20000638300 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
ata6: SATA max UDMA/133 cmd 0xffffc20000638380 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 2299
usb 1-2: configuration #1 chosen from 1 choice
hiddev96: USB HID v1.10 Device [CPS  CP 1500C] on usb-0000:00:1a.0-2
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD5000AAKS-22TMA0, 12.01C01, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: ST3500641AS, 3.AAE, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3500641AS, 3.AAJ, max UDMA/133
ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3500641AS, 3.AAE, max UDMA/133
ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/133
ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: ST3500630AS, 3.AAE, max UDMA/133
ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-2 12.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 2:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
scsi 4:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 12.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 4:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
sd 5:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 5:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdf: sdf1
sd 5:0:0:0: [sdf] Attached SCSI disk
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 cmd 0xffffc2000063c100 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 19
ata8: SATA max UDMA/133 cmd 0xffffc2000063c180 ctl 0x0000000000000000 
bmdma 0x0000000000000000 irq 19
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: ATA-7: ST3250824AS, 3.AAH, max UDMA/133
ata7.00: 488395055 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: configured for UDMA/133
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: Host Protected Area detected:
        current size: 976771055 sectors
        native size: 976773168 sectors
ata8.00: ATA-7: Maxtor 7H500F0, HA431DN0, max UDMA/133
ata8.00: 976771055 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8.00: Host Protected Area detected:
        current size: 976771055 sectors
        native size: 976773168 sectors
ata8.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      ST3250824AS      3.AA PQ: 0 ANSI: 5
sd 6:0:0:0: [sdg] 488395055 512-byte hardware sectors (250058 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 6:0:0:0: [sdg] 488395055 512-byte hardware sectors (250058 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdg: sdg1 sdg2
sd 6:0:0:0: [sdg] Attached SCSI disk
scsi 7:0:0:0: Direct-Access     ATA      Maxtor 7H500F0   HA43 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdh] 976771055 512-byte hardware sectors (500107 MB)
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 7:0:0:0: [sdh] 976771055 512-byte hardware sectors (500107 MB)
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdh: sdh1
sd 7:0:0:0: [sdh] Attached SCSI disk
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.1 to 64
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x000000000001c000 ctl 0x000000000001c102 
bmdma 0x000000000001c400 irq 16
ata10: PATA max UDMA/100 cmd 0x000000000001c200 ctl 0x000000000001c302 
bmdma 0x000000000001c408 irq 16
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1189149769.878:2): selinux=0 auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 5:0:0:0: Attached scsi generic sg5 type 0
sd 6:0:0:0: Attached scsi generic sg6 type 0
sd 7:0:0:0: Attached scsi generic sg7 type 0
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: RTL8168b/8111b at 0xffffc20000640000, 00:1a:4d:4a:de:27, IRQ 16
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.11  Wed Jun 13 
16:33:22 PDT 2007
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
floppy0: no floppy controllers found
No dock devices found.
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input6
ACPI: Power Button (CM) [PWRB]
md: md0 stopped.
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdh1>
md: bind<sda1>
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  8536.000 MB/sec
raid5: using function: generic_sse (8536.000 MB/sec)
raid6: int64x1   2046 MB/s
raid6: int64x2   2734 MB/s
raid6: int64x4   2316 MB/s
raid6: int64x8   1875 MB/s
raid6: sse2x1    3750 MB/s
raid6: sse2x2    5410 MB/s
raid6: sse2x4    7113 MB/s
raid6: using algorithm sse2x4 (7113 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sda1 operational as raid disk 0
raid5: device sdh1 operational as raid disk 6
raid5: device sdf1 operational as raid disk 5
raid5: device sde1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdb1 operational as raid disk 1
raid5: allocated 7412kB for md0
raid5: raid level 5 set md0 active with 7 out of 7 devices, algorithm 2
RAID5 conf printout:
 --- rd:7 wd:7
 disk 0, o:1, dev:sda1
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdh1
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdg1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 
across:2031608k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
r8169: eth0: link up
r8169: eth0: link up
audit(1189149788.812:3): audit_pid=2221 old=0 by auid=4294967295
/dev/vmmon[2374]: VMCI: Driver initialized.
/dev/vmmon[2374]: Module vmmon: registered with major=10 minor=165
/dev/vmmon[2374]: Module vmmon: initialized
/dev/vmnet: open called by PID 2434 (vmnet-bridge)
/dev/vmnet: hub 0 does not exist, allocating memory.
/dev/vmnet: port on hub 0 successfully opened
bridge-eth0: enabling the bridge
bridge-eth0: up
bridge-eth0: already up
bridge-eth0: attached
/dev/vmnet: open called by PID 2450 (vmnet-dhcpd)
/dev/vmnet: hub 8 does not exist, allocating memory.
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 2455 (vmnet-natd)
/dev/vmnet: port on hub 8 successfully opened
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
it87: Found IT8718F chip at 0x290, revision 4
it87: in3 is VCC (+5V)
coretemp coretemp.0: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.2: Using undocumented features, absolute temperature 
might be wrong!
coretemp coretemp.3: Using undocumented features, absolute temperature 
might be wrong!
eth0: no IPv6 routers present
/dev/vmnet: open called by PID 2707 (vmnet-netifup)
/dev/vmnet: port on hub 8 successfully opened
vmnet8: no IPv6 routers present
i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
i2c-adapter i2c-2: SMBus Quick command not supported, can't probe for chips
i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/vmnet: open called by PID 3754 (vmware-vmx)
device eth0 entered promiscuous mode
bridge-eth0: enabled promiscuous mode
/dev/vmnet: port on hub 0 successfully opened
/dev/vmmon[3860]: host clock rate change request 0 -> 19
/dev/vmmon[3860]: host clock rate change request 19 -> 83
usb 8-4: new high speed USB device using ehci_hcd and address 2
usb 8-4: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi10 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 10:0:0:0: Direct-Access     SAMSUNG  HD501LJ          0-10 PQ: 0 
ANSI: 2 CCS
sd 10:0:0:0: [sdi] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:0:0: [sdi] Write Protect is off
sd 10:0:0:0: [sdi] Mode Sense: 00 38 00 00
sd 10:0:0:0: [sdi] Assuming drive cache: write through
sd 10:0:0:0: [sdi] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:0:0: [sdi] Write Protect is off
sd 10:0:0:0: [sdi] Mode Sense: 00 38 00 00
sd 10:0:0:0: [sdi] Assuming drive cache: write through
 sdi: sdi1
sd 10:0:0:0: [sdi] Attached SCSI disk
sd 10:0:0:0: Attached scsi generic sg8 type 0
usb 8-2: new high speed USB device using ehci_hcd and address 3
usb 8-2: configuration #1 chosen from 1 choice
scsi11 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 11:0:0:0: Direct-Access     ST332082 0A               0000 PQ: 0 
ANSI: 0
sd 11:0:0:0: [sdj] 625142448 512-byte hardware sectors (320073 MB)
sd 11:0:0:0: [sdj] Write Protect is off
sd 11:0:0:0: [sdj] Mode Sense: 27 00 00 00
sd 11:0:0:0: [sdj] Assuming drive cache: write through
sd 11:0:0:0: [sdj] 625142448 512-byte hardware sectors (320073 MB)
sd 11:0:0:0: [sdj] Write Protect is off
sd 11:0:0:0: [sdj] Mode Sense: 27 00 00 00
sd 11:0:0:0: [sdj] Assuming drive cache: write through
 sdj: sdj1
sd 11:0:0:0: [sdj] Attached SCSI disk
sd 11:0:0:0: Attached scsi generic sg9 type 0
fuse init (API version 7.8)
usb 7-3: new high speed USB device using ehci_hcd and address 4
usb 7-3: configuration #1 chosen from 1 choice
scsi12 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 12:0:0:0: Direct-Access     ST320082 2A               3.01 PQ: 0 
ANSI: 0 CCS
sd 12:0:0:0: [sdk] 390721968 512-byte hardware sectors (200050 MB)
sd 12:0:0:0: [sdk] Write Protect is off
sd 12:0:0:0: [sdk] Mode Sense: 00 14 00 00
sd 12:0:0:0: [sdk] Assuming drive cache: write through
sd 12:0:0:0: [sdk] 390721968 512-byte hardware sectors (200050 MB)
sd 12:0:0:0: [sdk] Write Protect is off
sd 12:0:0:0: [sdk] Mode Sense: 00 14 00 00
sd 12:0:0:0: [sdk] Assuming drive cache: write through
 sdk: sdk1
sd 12:0:0:0: [sdk] Attached SCSI disk
sd 12:0:0:0: Attached scsi generic sg10 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdk1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ata1.00: exception Emask 0x2 SAct 0x18 SErr 0x0 action 0x2 frozen
ata1.00: (spurious completions during NCQ issue=0x0 SAct=0x18 
FIS=004040a1:00000004)
ata1.00: cmd 60/08:18:bf:04:df/00:00:23:00:00/40 tag 3 cdb 0x0 data 4096 in
         res 40/00:24:c7:04:df/00:00:23:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/78:20:c7:04:df/00:00:23:00:00/40 tag 4 cdb 0x0 data 61440 in
         res 40/00:24:c7:04:df/00:00:23:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
ata7: illegal qc_active transition (00000007->ffffffff)
ata7.00: exception Emask 0x2 SAct 0x7 SErr 0x0 action 0x2 frozen
ata7.00: cmd 61/08:00:bd:f1:44/00:00:00:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:00:bd:f1:44/00:00:00:00:00/40 Emask 0x2 (HSM violation)
ata7.00: cmd 61/10:08:fd:1f:10/00:00:15:00:00/40 tag 1 cdb 0x0 data 8192 out
         res 40/00:00:bd:f1:44/00:00:00:00:00/40 Emask 0x2 (HSM violation)
ata7.00: cmd 61/10:10:85:f1:44/00:00:00:00:00/40 tag 2 cdb 0x0 data 8192 out
         res 40/00:00:bd:f1:44/00:00:00:00:00/40 Emask 0x2 (HSM violation)
ata7: soft resetting port
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: configured for UDMA/133
ata7: EH complete
sd 6:0:0:0: [sdg] 488395055 512-byte hardware sectors (250058 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
ata7: illegal qc_active transition (00000001->ffffffff)
ata7.00: exception Emask 0x2 SAct 0x1 SErr 0x0 action 0x2 frozen
ata7.00: cmd 61/10:00:bd:22:bf/00:00:15:00:00/40 tag 0 cdb 0x0 data 8192 out
         res 40/00:00:bd:22:bf/00:00:15:00:00/40 Emask 0x2 (HSM violation)
ata7: soft resetting port
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: Host Protected Area detected:
        current size: 488395055 sectors
        native size: 488397168 sectors
ata7.00: configured for UDMA/133
ata7: EH complete
sd 6:0:0:0: [sdg] 488395055 512-byte hardware sectors (250058 MB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
















---------------------------------------- lspci -vv -nn 
---------------------------------------



00:00.0 Host bridge [0600]: Intel Corporation DRAM Controller 
[8086:29c0] (rev 02)
        Subsystem: Giga-byte Technology Unknown device [1458:5000]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort+ <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge [0604]: Intel Corporation PCI Express Root Port 
[8086:29c1] (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: f4000000-f7ffffff
        Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [88] Subsystem: Giga-byte Technology Unknown 
device [1458:5000]
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: fee0f00c  Data: 4159
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 2
                Link: Latency L0s <256ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- 
Surpise-
                Slot: Number 32, PowerLimit 75.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [140] Unknown (5)

00:1a.0 USB Controller [0c03]: Intel Corporation USB UHCI Controller #4 
[8086:2937] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at e100 [size=32]
        Capabilities: [50] #13 [0306]

00:1a.1 USB Controller [0c03]: Intel Corporation USB UHCI Controller #5 
[8086:2938] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at e200 [size=32]
        Capabilities: [50] #13 [0306]

00:1a.2 USB Controller [0c03]: Intel Corporation USB UHCI Controller #6 
[8086:2939] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at e000 [size=32]
        Capabilities: [50] #13 [0306]

00:1a.7 USB Controller [0c03]: Intel Corporation USB2 EHCI Controller #2 
[8086:293c] (rev 02) (prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5006]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fa104000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device [0403]: Intel Corporation HD Audio Controller 
[8086:293e] (rev 02)
        Subsystem: Giga-byte Technology Unknown device [1458:a002]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fa100000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, 
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge [0604]: Intel Corporation PCI Express Port 1 
[8086:2940] (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000a000-0000afff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 16, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: fee0f00c  Data: 4161
        Capabilities: [90] Subsystem: Giga-byte Technology Unknown 
device [1458:5001]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.3 PCI bridge [0604]: Intel Corporation PCI Express Port 4 
[8086:2946] (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fa000000-fa0fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort+ <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 4
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 19, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: fee0f00c  Data: 4169
        Capabilities: [90] Subsystem: Giga-byte Technology Unknown 
device [1458:5001]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.4 PCI bridge [0604]: Intel Corporation PCI Express Port 5 
[8086:2948] (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: f8000000-f9ffffff
        Prefetchable memory behind bridge: 00000000fa200000-00000000fa2fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 5
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ 
Surpise+
                Slot: Number 20, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: fee0f00c  Data: 4171
        Capabilities: [90] Subsystem: Giga-byte Technology Unknown 
device [1458:5001]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 USB Controller [0c03]: Intel Corporation USB UHCI Controller #1 
[8086:2934] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at e300 [size=32]
        Capabilities: [50] #13 [0306]

00:1d.1 USB Controller [0c03]: Intel Corporation USB UHCI Controller #2 
[8086:2935] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at e400 [size=32]
        Capabilities: [50] #13 [0306]

00:1d.2 USB Controller [0c03]: Intel Corporation USB UHCI Controller #3 
[8086:2936] (rev 02) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5004]
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at e500 [size=32]
        Capabilities: [50] #13 [0306]

00:1d.7 USB Controller [0c03]: Intel Corporation USB2 EHCI Controller #1 
[8086:293a] (rev 02) (prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology Unknown device [1458:5006]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fa105000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge 
[8086:244e] (rev 92) (prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 00009000-00009fff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Giga-byte Technology Unknown 
device [1458:5000]

00:1f.0 ISA bridge [0601]: Intel Corporation LPC Interface Controller 
[8086:2916] (rev 02)
        Subsystem: Giga-byte Technology Unknown device [1458:5001]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 SATA controller [0106]: Intel Corporation 6 port SATA AHCI 
Controller [8086:2922] (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Giga-byte Technology Unknown device [1458:b005]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 2299
        Region 0: I/O ports at e600 [size=8]
        Region 1: I/O ports at e700 [size=4]
        Region 2: I/O ports at e800 [size=8]
        Region 3: I/O ports at e900 [size=4]
        Region 4: I/O ports at ea00 [size=32]
        Region 5: Memory at fa106000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable+
                Address: fee0900c  Data: 0091
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]
        Capabilities: [b0] #13 [0306]

00:1f.3 SMBus [0c05]: Intel Corporation SMBus Controller [8086:2930] 
(rev 02)
        Subsystem: Giga-byte Technology Unknown device [1458:5001]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at fa107000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 0500 [size=32]

01:00.0 VGA compatible controller [0300]: nVidia Corporation Unknown 
device [10de:0402] (rev a1) (prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device [1043:8243]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at f4000000 (64-bit, non-prefetchable) [size=32M]
        Region 5: I/O ports at b000 [size=128]
        [virtual] Expansion ROM at f7000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag+
                Device: Latency L0s <512ns, L1 <4us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, 
Port 0
                Link: Latency L0s <512ns, L1 <4us
                Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
        Capabilities: [100] Virtual Channel
        Capabilities: [128] Power Budgeting
        Capabilities: [600] Unknown (11)

03:00.0 SATA controller [0106]: JMicron Technologies, Inc. JMicron 
20360/20363 AHCI Controller [197b:2363] (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Giga-byte Technology Unknown device [1458:b000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 19
        Region 5: Memory at fa000000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Express Legacy Endpoint IRQ 1
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:00.1 IDE interface [0101]: JMicron Technologies, Inc. JMicron 
20360/20363 AHCI Controller [197b:2363] (rev 02) (prog-if 85 [Master 
SecO PriO])
        Subsystem: Giga-byte Technology Unknown device [1458:b000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+ 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 16
        Region 0: I/O ports at c000 [size=8]
        Region 1: I/O ports at c100 [size=4]
        Region 2: I/O ports at c200 [size=8]
        Region 3: I/O ports at c300 [size=4]
        Region 4: I/O ports at c400 [size=16]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 01)
        Subsystem: Giga-byte Technology Unknown device [1458:e000]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at d000 [size=256]
        Region 2: Memory at f9000000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at fa200000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, 
ExtTag+
                Device: Latency L0s <128ns, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [12c] Virtual Channel
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
        Capabilities: [154] Power Budgeting

















------------------- sdparm -a -v /dev/sdx -----------------------



[root@localhost ~]# sdparm -a -v /dev/sda
    /dev/sda: ATA       WDC WD5000AAKS-2  12.0
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdb
    /dev/sdb: ATA       ST3500641AS       3.AA
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdc
    /dev/sdc: ATA       ST3500641AS       3.AA
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdd
    /dev/sdd: ATA       ST3500641AS       3.AA
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sde
    /dev/sde: ATA       WDC WD5000AAKS-0  12.0
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdf
    /dev/sdf: ATA       ST3500630AS       3.AA
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdg
    /dev/sdg: ATA       ST3250824AS       3.AA
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdh
    /dev/sdh: ATA       Maxtor 7H500F0    HA43
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        1
  ARRE        1
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         1
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
  FSW         0
  LBCSS       0
  DRA         0
  NV_DIS      0
  NCS         0
  CSS         0
Control [0xa] mode page [PS=0]:
  TST         0
  TMF_ONLY    0
  D_SENSE     0
  GLTSD       1
  RLEC        0
  QAM         0
  QERR        0
  RAC         0
  UA_INTLCK   0
  SWP         0
  ATO         0
  TAS         0
  AUTOLOAD    0
  BTP        -1
  ESTCT      30
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdi
    /dev/sdi: SAMSUNG   HD501LJ           0-10
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        0
  ARRE        0
  TB          0
  RC          0
  EER         0
  PER         0
  DTE         0
  DCR         0
  RRC         0
  COR_S       0
  HOC         0
  DSOC        0
  WRC         0
  RTL         0
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
Caching (SBC) [0x8] mode page [PS=0]:
  IC          0
  ABPF        0
  CAP         0
  DISC        0
  SIZE        0
  WCE         0
  MF          0
  RCD         0
  DRRP        0
  WRP         0
  DPTL        0
  MIPF        0
  MAPF        0
  MAPFC       0
 >> skipping rest as field position exceeds mode page length=12
 >> Control mode page [0xa] not supported
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdj
    /dev/sdj: ST332082  0A                0000
Read write error recovery [0x1] mode page [PS=0]:
  AWRE        0  [cha: n, def:  0, sav:  0]
  ARRE        0  [cha: n, def:  0, sav:  0]
  TB          0  [cha: n, def:  0, sav:  0]
  RC          0  [cha: n, def:  0, sav:  0]
  EER         0  [cha: n, def:  0, sav:  0]
  PER         0  [cha: n, def:  0, sav:  0]
  DTE         0  [cha: n, def:  0, sav:  0]
  DCR         0  [cha: n, def:  0, sav:  0]
  RRC         0  [cha: n, def:  0, sav:  0]
  COR_S       0  [cha: n, def:  0, sav:  0]
  HOC         0  [cha: n, def:  0, sav:  0]
  DSOC        0  [cha: n, def:  0, sav:  0]
  WRC         0  [cha: n, def:  0, sav:  0]
  RTL         0  [cha: n, def:  0, sav:  0]
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
 >> Caching (SBC) mode page [0x8] failed
 >> Control mode page [0xa] not supported
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported
[root@localhost ~]# sdparm -a -v /dev/sdk
    /dev/sdk: ST320082  2A                3.01
 >> Read write error recovery mode page [0x1] not supported
 >> Disconnect-reconnect (SPC + transports) mode page [0x2] not supported
 >> Format (SBC) mode page [0x3] not supported
 >> Rigid disk (SBC) mode page [0x4] not supported
 >> Verify error recovery (SBC) mode page [0x7] not supported
 >> Caching (SBC) mode page [0x8] not supported
 >> Control mode page [0xa] not supported
 >> Control extension mode subpage [0xa,0x1] not supported
 >> SAT pATA control mode subpage [0xa,0xf1] not supported
 >> Power condition - old version mode page [0xd] not supported
 >> XOR control (SBC) mode page [0x10] not supported
 >> Protocol specific logical unit mode page [0x18] not supported
 >> Protocol specific port mode page [0x19] not supported
 >> Power condition mode page [0x1a] not supported
 >> Informational exceptions control mode page [0x1c] not supported
 >> Background control (SBC) mode subpage [0x1c,0x1] not supported






------------------- RAID setup on drives ------------------




[root@localhost ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Sep  6 21:51:17 2007
     Raid Level : raid5
     Array Size : 2930303616 (2794.56 GiB 3000.63 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Sep  7 12:20:12 2007
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 240004cd:0f00f1b9:ff34037b:d58aa0b2
         Events : 0.18

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8      113        6      active sync   /dev/sdh1

