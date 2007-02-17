Return-Path: <linux-kernel-owner+w=401wt.eu-S2993020AbXBQSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993020AbXBQSMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993019AbXBQSMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:12:54 -0500
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:58765 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993017AbXBQSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:12:49 -0500
Date: Sat, 17 Feb 2007 12:12:43 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_via: fix resource-managed iomap conversion
Message-ID: <20070217121243.67e4c010@osprey.hogchain.net>
In-Reply-To: <45D0C9A0.1030707@gmail.com>
References: <20070210010914.GA19717@havoc.gtf.org>
	<20070210054629.GA4395@gentoox2.trippelsdorf.de>
	<45CF93D1.9080009@gmail.com>
	<20070212025843.GA4406@gentoox2.trippelsdorf.de>
	<45D0B740.9050704@gmail.com>
	<20070212193302.GA5003@gentoox2.trippelsdorf.de>
	<45D0C9A0.1030707@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_eypskYVPY8Fg0zAR8veSja3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_eypskYVPY8Fg0zAR8veSja3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 12 Feb 2007 12:10:08 -0800
Tejun Heo <htejun@gmail.com> wrote:

> Markus Trippelsdorf wrote:
> > On Mon, Feb 12, 2007 at 10:51:44AM -0800, Tejun Heo wrote:
> >> Conversion to resource-managed iomap was buggy causing init
> >> failures on both vt6420 and 6421 - BAR5 wasn't mapped for both
> >> controllers while on vt6420 sata_via tried to map BAR0-4 twice.
> >> Fix it.
> 
> Great, can anyone verify this on vt6421?
> 

Tejun,

I've verified your patch works on a vt8237a (1106:0591).  Kernel
2.6.20-git10 (Fedora rawhide kernel-2.6.20-1.2932.fc7) would not boot
without the patch.  Dmesg and lspci attached.

Thanks for the patch.

Jay
--MP_eypskYVPY8Fg0zAR8veSja3
Content-Type: text/plain; name=dmesg-20070217.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg-20070217.txt

Linux version 2.6.20-1.2932 (jcliburn@hawk.hogchain.net) (gcc version 4.1.2 20070214 (Red Hat 4.1.2-1)) #1 SMP Sat Feb 17 09:48:58 CST 2007
Command line: ro root=/dev/VolGroup00/LogVol00 console=ttyS0,38400 console=tty0 debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
 BIOS-e820: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
 BIOS-e820: 000000003ffbe000 - 000000003ffe0000 (ACPI NVS)
 BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000FA960, 0014 (r0 ACPIAM)
ACPI: RSDT 3FFB0000, 0038 (r1 A M I  OEMRSDT   7000611 MSFT       97)
ACPI: FACP 3FFB0200, 0084 (r2 A M I  OEMFACP   7000611 MSFT       97)
ACPI: DSDT 3FFB0440, 4CCB (r1  A0498 A0498000        0 INTL 20060113)
ACPI: FACS 3FFBE000, 0040
ACPI: APIC 3FFB0390, 0068 (r1 A M I  OEMAPIC   7000611 MSFT       97)
ACPI: MCFG 3FFB0400, 003C (r1 A M I  OEMMCFG   7000611 MSFT       97)
ACPI: OEMB 3FFBE040, 0060 (r1 A M I  AMI_OEM   7000611 MSFT       97)
ACPI: SSDT 3FFB5110, 01C4 (r1 A M I  POWERNOW        1 AMD         1)
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 000000003ffb0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-000000003ffb0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262064
On node 0 totalpages: 261967
  DMA zone: 88 pages used for memmap
  DMA zone: 2316 pages reserved
  DMA zone: 1595 pages, LIFO batch:0
  DMA32 zone: 5542 pages used for memmap
  DMA32 zone: 252426 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 44416 bytes of per cpu data
Built 1 zonelists.  Total pages: 254021
Kernel command line: ro root=/dev/VolGroup00/LogVol00 console=ttyS0,38400 console=tty0 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ 1046000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1010552k/1048256k available (2447k kernel code, 37316k reserved, 1426k data, 328k init)
Calibrating delay using timer specific routine.. 4001.02 BogoMIPS (lpj=2000514)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12498862
Detected 12.498 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3998.98 BogoMIPS (lpj=1999493)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 1 cycles, maxerr 491 cycles)
Brought up 2 CPUs
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 1999.818 MHz processor.
sizeof(vma)=176 bytes
sizeof(page)=88 bytes
sizeof(inode)=1008 bytes
sizeof(dentry)=248 bytes
sizeof(ext3inode)=1376 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=248 bytes
sizeof(task_struct)=3776 bytes
migration_cost=351
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:02:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs<7>Losing some ticks... checking if CPU frequency changed.
 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:07: ioport range 0xc00-0xc0f has been reserved
pnp: 00:07: ioport range 0xd00-0xd0f has been reserved
pnp: 00:07: ioport range 0xa20-0xa2f has been reserved
pnp: 00:07: ioport range 0xa30-0xa3f has been reserved
pnp: 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0f: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0f: iomem range 0xc0000-0xcffff could not be reserved
pnp: 00:0f: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x100000-0x3fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: f9000000-fbdfffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: f7f00000-f7ffffff
PCI: Bridge: 0000:00:03.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: f7e00000-f7efffff
PCI: Bridge: 0000:00:03.2
  IO window: disabled.
  MEM window: fbe00000-fbefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: f7d00000-f7dfffff
PCI: Bridge: 0000:00:13.0
  IO window: disabled.
  MEM window: fbf00000-fbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 27
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 31
PCI: Setting latency timer of device 0000:00:03.0 to 64
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 35 (level, low) -> IRQ 35
PCI: Setting latency timer of device 0000:00:03.1 to 64
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 39 (level, low) -> IRQ 39
PCI: Setting latency timer of device 0000:00:03.2 to 64
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 43 (level, low) -> IRQ 43
PCI: Setting latency timer of device 0000:00:03.3 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3698k freed
audit: initializing netlink socket (disabled)
audit(1171713241.877:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 87B885CDE4968314
  - key was been created 13843 seconds in future
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.1:pcie00]
Allocate Port Service[0000:00:03.1:pcie02]
PCI: Setting latency timer of device 0000:00:03.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.2:pcie00]
Allocate Port Service[0000:00:03.2:pcie02]
PCI: Setting latency timer of device 0000:00:03.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.3:pcie00]
Allocate Port Service[0000:00:03.3:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [P001] (supports 16 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 328k freed
Write protecting the kernel read-only data: 1043k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 20, io base 0x0000d480
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[B] -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 22, io base 0x0000d800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[C] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000d880
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 23, io base 0x0000dc00
usb usb4: configuration #1 chosen from 1 choice
usb 2-1: new low speed USB device using uhci_hcd and address 2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
usb 2-1: configuration #1 chosen from 1 choice
input: Microsoft Basic Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:10.1-1
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8fffc00
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.10 loaded.
sata_via 0000:00:0f.0: version 2.0
usb 2-1: USB disconnect, address 2
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21
sata_via 0000:00:0f.0: routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0x000000000001ec00 ctl 0x000000000001e882 bmdma 0x000000000001e400 irq 21
ata2: SATA max UDMA/133 cmd 0x000000000001e800 ctl 0x000000000001e482 bmdma 0x000000000001e408 irq 21
scsi0 : sata_via
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x000000000001ec07
ATA: abnormal status 0x7F on port 0x000000000001ec07
ata1.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/133
scsi1 : sata_via
usb 2-1: new low speed USB device using uhci_hcd and address 3
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x000000000001e807
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500KS-00M 02.0 PQ: 0 ANSI: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
usb 2-1: configuration #1 chosen from 1 choice
input: Microsoft Basic Optical Mouse as /class/input/input3
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:10.1-1
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1171713248.186:2): selinux=0 auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
pata_via 0000:00:0f.1: version 0.2.1
ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001fc00 irq 14
ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001fc08 irq 15
scsi2 : pata_via
ata3.00: ATAPI, max UDMA/33
ata3.00: configured for UDMA/33
scsi3 : pata_via
EDAC MC: Ver: 2.0.1 Feb 17 2007
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
input: PC Speaker as /class/input/input4
parport0: Printer, HEWLETT-PACKARD DESKJET 840C
ATA: abnormal status 0x8 on port 0x0000000000010177
Attansic L1 Ethernet Network Driver - version 2.0.6
Copyright(c) 2005-2006 Attansic Corporation.
scsi 2:0:0:0: CD-ROM            _NEC     DVD_RW ND-3550A  1.05 PQ: 0 ANSI: 5
scsi 2:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 36 (level, low) -> IRQ 36
PCI: Setting latency timer of device 0000:04:00.0 to 64
EDAC MC0: Giving out device to k8_edac Athlon64/Opteron: DEV 0000:00:18.2
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:02 does not support disabling.
rtc_cmos: probe of 00:02 failed with error -16
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:08:01.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:08:01.0 to 64
lp0: using parport0 (interrupt-driven).
lp0: console ready
No dock devices found.
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input7
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
loop: loaded (max 8 devices)
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (4094 buckets, 32752 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.lo.retrans_time; Use net.ipv6.neigh.lo.retrans_time_ms instead.
atl1: eth0 link is up 100 Mbps full duplex
atl1: eth0 link is up 1000 Mbps full duplex
eth0: no IPv6 routers present

--MP_eypskYVPY8Fg0zAR8veSja3
Content-Type: text/plain; name=lspci-20070217.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=lspci-20070217.txt

00:00.0 0600: 1106:0351
	Subsystem: 1106:0351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] HyperTransport: Slave or Primary Interface
		!!! Possibly incomplete decoding
		Command: BaseUnitID=0 UnitCnt=3 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config 0: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 1.02
	Capabilities: [58] #00 [0000]
00: 06 11 51 03 06 01 10 02 00 00 00 06 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 51 03
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00
40: 3f 63 08 00 00 00 00 00 00 00 1f c4 00 0c 00 01
50: 01 60 02 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 58 60 00 20 00 11 11 d0 00 00 00 22 06 75 00
70: 02 00 00 00 00 00 00 00 00 00 00 00 08 00 00 00
80: 02 50 30 00 07 02 00 1f 00 00 00 00 28 00 00 00
90: 80 01 00 00 20 0f 01 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 40 00 00 06 08 00 00
c0: 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 08 00 00 98 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.1 0600: 1106:1351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 13 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.2 0600: 1106:2351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 23 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 03 8a 10 31 30 3c 80 86 7f cf 44 22 24 00 22 30
b0: 3f 13 c0 00 02 00 00 00 00 00 00 00 00 00 0e 00
c0: 20 aa 00 00 50 50 00 00 00 00 00 00 00 00 00 00
d0: 33 33 02 30 00 00 33 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.3 0600: 1106:3351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 33 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 22 22 00 00 00 00 e4 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: aa 00 c0 20 00 ff 19 00 40 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.4 0600: 1106:4351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 43 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 ff 00 00 00 00 00 1f 00 04 40 00 10 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.5 0800: 1106:5351 (prog-if 20)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 53 06 00 00 00 00 20 00 08 10 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 8c 00 05 00 02 40 c0 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 2b 0e 00 00 23 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 85 00 00 11 08 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 7e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.6 0600: 1106:6238
	Subsystem: 0008:0000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 38 62 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:00.7 0600: 1106:7351
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
00: 06 11 51 73 06 00 00 02 00 00 00 06 10 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 70 3b 88 82 82 44 00 30 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 06 01 00 82 97 88 88 61 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:01.0 0604: 1106:b999
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 99 b9 04 00 30 02 00 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 f0 00 20 02
20: f0 ff 00 00 f0 ff 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 70 00 00 00 00 00 00 00 00 00 03 00
40: 91 40 00 44 31 3a 99 b9 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 0e 70 35 00 07 02 00 1f 00 00 00 00 28 00 00 00
90: 80 00 00 00 00 08 01 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: bf 63 08 00 00 00 00 00 00 00 1f c4 00 04 00 00
c0: 08 00 0b ff 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.0 0604: 1106:a238
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f9000000-fbdfffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dff00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <1us, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4061
00: 06 11 38 a2 07 04 10 00 00 00 04 06 10 00 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 f0 00 00 20
20: 00 f9 d0 fb 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 0c 00
40: 10 68 41 01 01 0f 00 00 0f 00 12 00 01 0d 18 00
50: 00 00 01 21 60 00 00 00 00 00 48 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 01 70 22 c8 00 00 00 00
70: 05 00 81 01 00 00 e0 fe 00 00 00 00 61 40 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 54 30 f0 6c ff 7f 0c 00 00 00 00 00 00 00 00
b0: 0c 12 41 81 04 00 03 00 00 00 00 00 00 00 00 00
c0: 03 00 27 8a 44 44 44 44 44 44 44 44 00 00 00 00
d0: 50 20 00 50 02 00 00 00 00 00 00 00 08 00 02 a8
e0: 0c 06 80 92 f8 00 00 00 80 82 f8 00 00 00 00 00
f0: 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00

00:03.0 0604: 1106:c238
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000f7f00000-00000000f7f00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4069
00: 06 11 38 c2 06 05 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 06 06 00 f0 00 00 00
20: f0 ff 00 00 f1 f7 f1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 03 00
40: 10 68 41 01 c1 0e 00 00 0f 00 10 00 41 0c 18 01
50: 10 00 10 00 60 00 00 00 00 00 48 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 01 70 22 c8 00 00 00 00
70: 05 00 81 01 00 00 e0 fe 00 00 00 00 69 40 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 44 30 f0 7c ff 7f 0c 00 00 00 00 00 00 00 00
b0: 12 1b 41 81 04 00 03 00 00 00 00 00 00 00 00 00
c0: 03 00 27 8a 44 44 00 00 00 00 00 00 00 00 00 00
d0: 50 00 00 00 02 00 00 00 00 00 00 00 08 00 02 a8
e0: 00 0f 00 93 08 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00

00:03.1 0604: 1106:d238
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000f7e00000-00000000f7e00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed unknown, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4071
00: 06 11 38 d2 06 05 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 05 05 00 f0 00 00 00
20: f0 ff 00 00 e1 f7 e1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 03 00
40: 10 68 41 01 01 0e 00 00 0f 00 10 00 11 0c 18 02
50: 00 00 00 00 60 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 01 70 22 c8 00 00 00 00
70: 05 00 81 01 00 00 e0 fe 00 00 00 00 71 40 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 44 30 f0 7c ff 7f 0c 00 00 00 00 00 00 00 00
b0: 12 1b 41 81 04 00 03 00 00 00 00 00 00 00 00 00
c0: 03 00 00 8a 44 44 44 44 00 00 00 00 00 00 00 00
d0: 50 00 00 00 00 00 00 00 00 00 00 00 08 00 02 a8
e0: 00 0f 00 02 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 00

00:03.2 0604: 1106:e238
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <4us, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4079
00: 06 11 38 e2 06 05 10 40 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 f0 00 00 20
20: e0 fb e0 fb f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 03 03 00
40: 10 68 41 01 81 0f 00 00 0f 00 12 00 11 0c 18 03
50: 00 00 11 20 60 00 00 00 00 00 48 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 01 70 22 c8 00 00 00 00
70: 05 00 81 01 00 00 e0 fe 00 00 00 00 79 40 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 44 30 f0 7c ff 7f 0c 00 00 00 00 00 00 00 00
b0: 12 1b 41 81 04 00 03 00 00 00 00 00 00 00 00 00
c0: 00 00 00 8a 04 00 00 00 00 00 00 00 00 00 00 00
d0: 50 00 00 00 00 00 00 00 00 00 00 00 08 00 02 a8
e0: 00 0f 00 02 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:03.3 0604: 1106:f238
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000f7d00000-00000000f7d00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed unknown, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee00000  Data: 4081
00: 06 11 38 f2 06 05 10 00 00 00 04 06 10 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f0 00 00 00
20: f0 ff 00 00 d1 f7 d1 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 04 03 00
40: 10 68 41 01 01 0e 00 00 0f 00 10 00 11 0c 18 04
50: 00 00 00 00 60 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 01 70 22 c8 00 00 00 00
70: 05 00 81 01 00 00 e0 fe 00 00 00 00 81 40 00 00
80: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 44 30 f0 7c ff 7f 0c 00 00 00 00 00 00 00 00
b0: 12 1b 41 81 04 00 03 00 00 00 00 00 00 00 00 00
c0: 00 00 00 8a 04 00 00 00 00 00 00 00 00 00 00 00
d0: 50 00 00 00 00 00 00 00 00 00 00 00 08 00 02 a8
e0: 00 0f 00 02 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0f.0 0101: 1106:0591 (rev 80) (prog-if 8f)
	Subsystem: 1106:0591
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at ec00 [size=8]
	Region 1: I/O ports at e880 [size=4]
	Region 2: I/O ports at e800 [size=8]
	Region 3: I/O ports at e480 [size=4]
	Region 4: I/O ports at e400 [size=16]
	Region 5: I/O ports at e000 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 91 05 07 00 90 02 80 8f 01 01 00 40 80 00
10: 01 ec 00 00 81 e8 00 00 01 e8 00 00 81 e4 00 00
20: 01 e4 00 00 01 e0 00 00 00 00 00 00 06 11 91 05
30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00
40: 03 03 f1 44 06 af 40 00 00 80 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 22 00 10 00 00 00 00 20 00
60: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 01 00 01 10 04 00 00 00
80: 00 00 00 00 00 00 00 00 00 60 a6 3e 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 80 02 91 05 06 11 91 05 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:0f.1 0101: 1106:0571 (rev 07) (prog-if 8a)
	Subsystem: 1106:0571
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at fc00 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 71 05 05 00 90 02 07 8a 01 01 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 fc 00 00 00 00 00 00 00 00 00 00 06 11 71 05
30: 00 00 00 00 c0 00 00 00 00 00 00 00 ff 00 00 00
40: 0b f2 09 05 18 8c c4 00 a8 a8 a8 20 ff 00 b6 20
50: 07 07 17 e6 0c 03 00 00 a8 a8 a8 a8 00 00 00 00
60: 00 02 00 00 00 00 00 00 00 02 00 00 00 00 00 00
70: 02 01 25 00 00 00 00 00 82 01 00 00 00 00 00 00
80: 00 c0 8d 3d 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 07 01 71 05 06 11 71 05 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.0 0c03: 1106:3038 (rev a0)
	Subsystem: 1106:3038
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at d480 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 38 30 17 00 10 02 a0 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d4 00 00 00 00 00 00 00 00 00 00 06 11 38 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 01 00 00
40: 40 12 03 00 00 00 00 00 00 0b a0 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 c2 ff 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.1 0c03: 1106:3038 (rev a0)
	Subsystem: 1106:3038
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at d800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 38 30 17 00 10 02 a0 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 d8 00 00 00 00 00 00 00 00 00 00 06 11 38 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00
40: 40 12 03 00 00 00 00 00 00 0b a0 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 c2 ff 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.2 0c03: 1106:3038 (rev a0)
	Subsystem: 1106:3038
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at d880 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 38 30 17 00 10 02 a0 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d8 00 00 00 00 00 00 00 00 00 00 06 11 38 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 05 03 00 00
40: 40 12 03 00 00 00 00 00 00 0b a0 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 c2 ff 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.3 0c03: 1106:3038 (rev a0)
	Subsystem: 1106:3038
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 23
	Region 4: I/O ports at dc00 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 38 30 17 00 10 02 a0 00 03 0c 10 40 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 dc 00 00 00 00 00 00 00 00 00 00 06 11 38 30
30: 00 00 00 00 80 00 00 00 00 00 00 00 03 04 00 00
40: 40 12 03 00 00 00 00 00 00 0b a0 03 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 c2 ff 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.4 0c03: 1106:3104 (rev 86) (prog-if 20)
	Subsystem: 1106:3104
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at f8fffc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 04 31 17 00 10 02 86 20 03 0c 10 40 80 00
10: 00 fc ff f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 04 31
30: 00 00 00 00 80 00 00 00 00 00 00 00 05 03 00 00
40: 00 00 03 00 00 00 00 00 80 20 00 09 00 00 00 00
50: 00 5a 00 80 00 00 00 00 04 0b 03 22 03 00 00 00
60: 20 20 01 00 00 00 00 00 01 00 00 00 00 00 08 80
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 c2 ff 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 a0 00 00 00 00 00 00 00 00 00

00:11.0 0601: 1106:3337
	Subsystem: 1106:3337
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 06 11 37 33 03 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 37 33
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 40 f0 0b 00 00 10 00 0c 20 00 00 44 00 0a 00
50: 00 0d 09 00 00 00 00 00 62 00 00 0b 00 00 00 00
60: 00 00 00 00 00 00 00 05 00 00 00 00 00 00 00 00
70: 06 11 37 33 00 00 00 00 00 00 00 00 00 00 00 00
80: 20 84 59 00 88 00 00 00 01 08 00 00 05 18 00 00
90: 00 fe a4 88 30 c1 01 02 00 14 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 04 05 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 06 00 24 69 ef 00 00 00 00 00 04 00 00 00
f0: 00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00

00:11.7 0600: 1106:287e
	Subsystem: 1106:337e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128
	Capabilities: [58] HyperTransport: Interrupt Discovery and Configuration
00: 06 11 7e 28 06 01 10 02 00 00 00 06 00 80 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 7e 33
30: 00 00 00 00 58 00 00 00 00 00 00 00 00 00 00 00
40: f4 24 00 80 82 00 00 00 23 3b 88 80 82 44 80 43
50: 80 8f d3 03 00 04 01 40 08 00 01 80 00 00 00 00
60: 00 aa 00 20 ff 00 00 00 00 00 00 00 00 00 00 00
70: 42 c8 ee 01 3c 0f 50 48 01 00 00 00 77 00 12 02
80: 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: fd 3f df 00 00 00 00 e0 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 50 68 88 8a 88 00 03 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 19 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.0 0604: 1106:337b
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [70] #0d [0000]
00: 06 11 7b 33 06 01 10 20 00 00 04 06 00 00 81 00
10: 00 00 00 00 00 00 00 00 00 08 08 00 f0 00 00 02
20: f0 fb f0 fb f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 60 00 00 00 00 00 00 00 00 00 03 00
40: 02 00 06 06 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 70 02 a8 00 00 00 00 00 00 00 00 00 00 00 00
70: 0d 00 00 00 86 6c db b6 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:13.1 0604: 1106:337a (prog-if 01)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [70] #0d [0000]
00: 06 11 7a 33 04 01 10 20 00 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 07 07 00 f0 00 00 02
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 60 00 00 00 00 00 00 00 00 00 03 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 08 70 02 a8 00 00 00 00 00 00 00 00 00 00 00 00
70: 0d 00 00 00 40 84 6b 4c 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.0 0600: 1022:1100
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 01 00 e4 00 00 00 20 c8 0e 0f 2c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 11 22 06 75 80 02 00 00 00
90: 56 04 51 02 00 00 ff 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.1 0600: 1022:1101
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 3f 00 00 00 00 00 01 00 00 00
50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
80: 03 00 e0 00 80 ff ef 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 40 00 00 ff ff 00
c0: 13 10 00 00 00 f0 ff 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.2 0600: 1022:1102
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: e0 3f 38 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 46 00 00 00 00 00 00 00
80: 02 00 00 00 00 00 00 00 34 f3 ef 5d 20 13 13 00
90: 10 08 01 00 5a 80 00 64 21 00 00 80 17 17 17 16
a0: e9 02 00 5d 00 00 00 00 00 00 00 00 00 00 00 00
b0: 5c 72 95 8e be 00 00 00 20 c0 08 33 0e b0 46 80
c0: 00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: d5 60 0d 40 f4 43 0a cd c6 ac c5 1f 10 5c 01 f8
e0: c2 20 81 67 56 02 a0 ec 97 c8 e0 e6 ca c9 27 d1
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:18.3 0600: 1022:1103
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]
00: 22 10 03 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 40 00 50 0a 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 40 f0 f3 9c
60: 59 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 02 51 11 80 00 50 00 2a 00 08 2a 22 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 00 00 00 00 23 08 00 00 80 42 76 1d 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 01 a7 0d 00 00 00 60 00 25 25 25 00
e0: 00 00 00 00 24 1b 46 00 19 17 00 00 00 00 00 00
f0: 0f 00 10 00 00 04 00 00 02 00 00 00 b2 0f 04 00

02:00.0 0300: 10de:0141 (rev a2)
	Subsystem: 1462:0410
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f9000000 (64-bit, non-prefetchable) [size=16M]
	Expansion ROM at fbde0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
00: de 10 41 01 07 01 10 00 a2 00 00 03 10 00 00 00
10: 00 00 00 fa 0c 00 00 d0 00 00 00 00 04 00 00 f9
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 10 04
30: 00 00 de fb 60 00 00 00 00 00 00 00 0b 01 00 00
40: 62 14 10 04 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 02 00 00 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 00 01 00 c0 04 00 00
80: 10 28 0a 00 01 4d 01 00 08 00 01 01 00 00 00 00
90: 00 00 00 00 00 00 00 00 0c 08 40 c1 01 04 40 c1
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

04:00.0 0200: 1969:1048 (rev b0)
	Subsystem: 1043:8226
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 2298
	Region 0: Memory at fbec0000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at fbea0000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
		Address: 00000000fee01000  Data: 40c9
	Capabilities: [58] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <4us, L1 unlimited
		Device: AtnBtn+ AtnInd+ PwrInd+
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
		Link: Latency L0s unlimited, L1 unlimited
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [6c] Vital Product Data
00: 69 19 48 10 06 05 10 00 b0 00 00 02 10 00 00 00
10: 04 00 ec fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 26 82
30: 00 00 ea fb 40 00 00 00 00 00 00 00 0b 01 00 00
40: 01 48 02 c0 00 00 00 00 05 58 81 00 00 10 e0 fe
50: 00 00 00 00 c9 40 00 00 10 6c 01 00 80 7f 00 00
60: 00 20 1b 00 11 f4 03 00 00 00 11 10 03 00 28 81
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 69 19 48 10 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

08:01.0 0403: 1106:3288 (rev 10)
	Subsystem: 1043:81e7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0
00: 06 11 88 32 06 00 10 00 10 00 03 04 10 00 00 00
10: 04 c0 ff fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 e7 81
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
60: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 10 00 91 00 00 00 00 00 00 00 30 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


--MP_eypskYVPY8Fg0zAR8veSja3--
