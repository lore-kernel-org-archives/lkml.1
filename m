Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXI0PQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXI0PQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXI0PQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:16:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbXI0PQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:16:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc8-mm2: problems on HP nx6325
Date: Thu, 27 Sep 2007 17:19:06 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <david-b@pacbell.net>, Tejun Heo <htejun@gmail.com>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
In-Reply-To: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qn8+GOrI9uuMr46"
Message-Id: <200709271719.06937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qn8+GOrI9uuMr46
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, 27 September 2007 11:22, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> 
> 
> - The scheduler devel tree has been restored
> 
> - The driver tree is presently busted, so I reverted it to the 2..23-rc8-mm1
>   version.
> 
> - It's now a nearly-32MB diff.

On HP nx6325:

1) The audio is back (thanks for reverting x86_64-mm-cpa-einval.patch)

2) CPU hotplug is busted (onlining of CPU1 kills the kernel), probably due to
   the same issue that I'm having with the -hrt version of 2.6.23-rc8 (we're
   debugging it right now)

3) Some call traces unrelated to 2) appear in dmesg:

   a) This probably is due to the fact that I've compiled two RTC drivers, by
      mistake ;-)

Duplicate file names "rtc" detected.
Call Trace:
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file
 '001'
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.23-rc8-mm2 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
 [<ffffffff802d1b77>] proc_register+0x15b/0x173
 [<ffffffff802d1c03>] create_proc_entry+0x74/0x89
 [<ffffffff8811e05a>] :rtc_core:rtc_proc_add_device+0x25/0x48
 [<ffffffff8811d229>] :rtc_core:rtc_device_register+0x182/0x215
 [<ffffffff802d7f8b>] sysfs_add_one+0xbf/0xc9
 [<ffffffff88160587>] :rtc_cmos:cmos_do_probe+0xa5/0x220
 [<ffffffff88160743>] :rtc_cmos:cmos_pnp_probe+0x41/0x43
 [<ffffffff80358805>] pnp_device_probe+0x7b/0xa2
 [<ffffffff803825e4>] driver_probe_device+0x100/0x18f
 [<ffffffff80382793>] __driver_attach+0x70/0xae
 [<ffffffff80382723>] __driver_attach+0x0/0xae
 [<ffffffff803818f8>] bus_for_each_dev+0x49/0x7a
 [<ffffffff803823f6>] driver_attach+0x1c/0x1e
 [<ffffffff80381cc5>] bus_add_driver+0x86/0x1d6
 [<ffffffff803829a5>] driver_register+0x72/0x76
 [<ffffffff803585a1>] pnp_register_driver+0x1c/0x1e
 [<ffffffff880e3010>] :rtc_cmos:cmos_init+0x10/0x12
 [<ffffffff80258398>] sys_init_module+0x16df/0x1864
 [<ffffffff8811d0a7>] :rtc_core:rtc_device_register+0x0/0x215
 [<ffffffff8020bfee>] system_call+0x7e/0x83

rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:07 failed with error -16

   b) I have no idea what causes these to appear, but the networking works
      nevertheless:

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net ethxx0: device_rename: sysfs_create_symlink failed (-17)

[--snip--]

WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_ad
d_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PE
S CCS
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
usb 3-1: new full speed USB device using ohci_hcd and address 2
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PE
S CCS
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83
usb 3-1: ep0 maxpacket = 8
usb 3-1: default language 0x0409

net ethxx1: device_rename: sysfs_create_symlink failed (-17)

[--snip--]

ethxx0 renamed to eth1
sysfs: duplicate filename 'eth1' can not be created
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_ad
d_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net eth1: device_rename: sysfs_create_symlink failed (-17)
ethxx1 renamed to eth0
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
Bluetooth: Core ver 2.11
sysfs: duplicate filename 'eth0' can not be created
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_ad
d_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net eth0: device_rename: sysfs_create_symlink failed (-17)

Full dmesg attached.

Greetings,
Rafael

--Boundary-00=_qn8+GOrI9uuMr46
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="2.6.23-rc8-mm2-boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="2.6.23-rc8-mm2-boot.log"

Linux version 2.6.23-rc8-mm2 (rafael@albercik) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #23 SMP Thu Sep 27 14:51:09 CEST 2007
Command line: root=/dev/sda3 vga=792 resume=/dev/sda1 no_console_suspend
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fd0000 (usable)
 BIOS-e820: 0000000077fd0000 - 0000000077fe5600 (reserved)
 BIOS-e820: 0000000077fe5600 - 0000000077ff8000 (ACPI NVS)
 BIOS-e820: 0000000077ff8000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7D30, 0024 (r2 HP    )
ACPI: XSDT 77FE57B4, 0054 (r1 HP     0944      6070620 HP          1)
ACPI: FACP 77FE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 77FE58DC, EE7A (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 77FF7E80, 0040
ACPI: APIC 77FE5808, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 77FE586C, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 77FE58A8, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 77FF4756, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 77FF47AF, 0206 (r1 HP     PSSTBLID        1 HP          1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
No mptable found.
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   491472
On node 0 totalpages: 491375
Node 0 memmap at 0xffff810001000000 size 27525120 first pfn 0xffff810001000000
  DMA zone: 56 pages used for memmap
  DMA zone: 1476 pages reserved
  DMA zone: 2467 pages, LIFO batch:0
  DMA32 zone: 6663 pages used for memmap
  DMA32 zone: 480713 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 46448 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 483180
Kernel command line: root=/dev/sda3 vga=792 resume=/dev/sda1 no_console_suspend
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1994.999 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ 148000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1923936k/1965888k available (2269k kernel code, 41308k reserved, 1511k data, 252k init)
Calibrating delay using timer specific routine.. 3994.09 BogoMIPS (lpj=7988193)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1153 Objects with 113 Devices 337 Methods 33 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 2 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Disabling APIC timer
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.39 BogoMIPS (lpj=7980790)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
Brought up 2 CPUs
net_namespace: 112 bytes
Time: 14:56:28  Date: 09/27/07
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 11 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:................................................................................................................................................................
Initialized 29/33 Regions 0/0 Fields 63/64 Buffers 68/78 Packages (1172 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.......
Executed 7 _INI methods requiring 2 _STA executions (examined 120 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: PCI Root Bridge [C074] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: Power Resource [C223] (off)
ACPI: Power Resource [C1FE] (off)
ACPI: Power Resource [C217] (on)
ACPI: Power Resource [C34B] (off)
ACPI: Power Resource [C34C] (off)
ACPI: Power Resource [C34D] (off)
ACPI: Power Resource [C34E] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:No DMAR devices found
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x77ffffff could not be reserved
pnp: 00:0a: ioport range 0x40b-0x40b has been reserved
pnp: 00:0a: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0a: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0b: ioport range 0x8000-0x802f has been reserved
pnp: 00:0b: ioport range 0x8100-0x811f has been reserved
pnp: 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:0c: iomem range 0xcf000-0xcffff has been reserved
pnp: 00:0c: iomem range 0x78000000-0x7fffffff could not be reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: d4300000-d43fffff
  PREFETCH window: c0000000-c7ffffff
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: cc000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c8000000-c80fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 90000000-93ffffff
PCI: Bridge: 0000:00:14.4
  IO window: 1000-1fff
  MEM window: d4000000-d42fffff
  PREFETCH window: 88000000-8bffffff
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5249k freed
audit: initializing netlink socket (disabled)
audit(1190904988.972:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
Boot video device is 0000:01:05.0
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
Allocate Port Service[0000:00:04.0:pcie03]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
Allocate Port Service[0000:00:05.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Allocate Port Service[0000:00:06.0:pcie03]
AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 4608k, total 16384k
vesafb: mode is 1024x768x24, linelength=3072, pages=6
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd4409080 irq 16
ata2: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd44090c0 irq 16
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHV2080BH, 892C, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
NET: Registered protocol family 1
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
PM: Resume from disk failed.
registered taskstats version 1
  Magic number: 7:423:941
Freeing unused kernel memory: 252k freed
Write protecting the kernel read-only data: 1116k
sd 0:0:0:0: Attached scsi generic sg0 type 0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller at PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: chipset revision 128
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047, BIOS settings: hda:DMA, hdb:pio
ATIIXP: simplex device: DMA disabled
ide1: ATIIXP Bus-Master DMA disabled (BIOS)
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
swsusp: Resume From Partition 8:1
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Floppy drive(s): fd0 is 1.44M
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file 'devices'
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: reset hcs_params 0x2408 dbg=0 cc=2 pcc=4 ordered !ppc ports=8
ehci_hcd 0000:00:13.2: reset hcc_params a012 thresh 1 uframes 256/512/1024
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: MWI active
ehci_hcd 0000:00:13.2: irq 19, io mem 0xd4403000
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '001'
usb usb1: new device found, idVendor=0000, idProduct=0000
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-rc8-mm2 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.0: OHCI Host Controller
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: created debug files
ohci_hcd 0000:00:13.0: irq 19, io mem 0xd4401000
ieee80211_crypt: registered algorithm 'NULL'
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ieee80211: 802.11 data/management/control stack, git-1.1.13
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: hcca frame #0005
ohci_hcd 0000:00:13.0: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 4ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '001'
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-rc8-mm2 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '003'
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: created debug files
ohci_hcd 0000:00:13.1: irq 19, io mem 0xd4402000
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ohci_hcd 0000:00:13.1: OHCI controller state
ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.1: hcca frame #0005
ohci_hcd 0000:00:13.1: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [3] 0x00000100 PPS
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
ehci_hcd 0000:00:13.2: port 3 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
hub 3-0:1.0: 4 ports detected
hub 1-0:1.0: port 3 not reset yet, waiting 50ms
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: global over-current protection
hub 3-0:1.0: power on to power good time: 4ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: no over-current condition exists
hub 3-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
Duplicate file names "rtc" detected.
Call Trace:
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '001'
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.23-rc8-mm2 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
 [<ffffffff802d1b77>] proc_register+0x15b/0x173
 [<ffffffff802d1c03>] create_proc_entry+0x74/0x89
 [<ffffffff8811e05a>] :rtc_core:rtc_proc_add_device+0x25/0x48
 [<ffffffff8811d229>] :rtc_core:rtc_device_register+0x182/0x215
 [<ffffffff802d7f8b>] sysfs_add_one+0xbf/0xc9
 [<ffffffff88160587>] :rtc_cmos:cmos_do_probe+0xa5/0x220
 [<ffffffff88160743>] :rtc_cmos:cmos_pnp_probe+0x41/0x43
 [<ffffffff80358805>] pnp_device_probe+0x7b/0xa2
 [<ffffffff803825e4>] driver_probe_device+0x100/0x18f
 [<ffffffff80382793>] __driver_attach+0x70/0xae
 [<ffffffff80382723>] __driver_attach+0x0/0xae
 [<ffffffff803818f8>] bus_for_each_dev+0x49/0x7a
 [<ffffffff803823f6>] driver_attach+0x1c/0x1e
 [<ffffffff80381cc5>] bus_add_driver+0x86/0x1d6
 [<ffffffff803829a5>] driver_register+0x72/0x76
 [<ffffffff803585a1>] pnp_register_driver+0x1c/0x1e
 [<ffffffff880e3010>] :rtc_cmos:cmos_init+0x10/0x12
 [<ffffffff80258398>] sys_init_module+0x16df/0x1864
 [<ffffffff8811d0a7>] :rtc_core:rtc_device_register+0x0/0x215
 [<ffffffff8020bfee>] system_call+0x7e/0x83

rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:07 failed with error -16
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 6 low speed --> companion
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
ehci_hcd 0000:00:13.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0044
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
bcm43xx driver
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio initialized
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
bcm43xx: Radio initialized
tg3.c:v3.81 (September 5, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
eth1: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:2e:2e:f3
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth1: dma_rwctrl[763f0000] dma_mask[32-bit]
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 20 (level, low) -> IRQ 20
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
Yenta: CardBus bridge found at 0000:02:04.0 [103c:30b0]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
usb 2-2: new full speed USB device using ohci_hcd and address 2
Yenta TI: socket 0000:02:04.0, mfunc 0x01a11002, devctl 0x64
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
eth0 renamed to ethxx0
sysfs: duplicate filename 'ethxx0' can not be created
floppy0: no floppy controllers found
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_add_one()
Yenta: ISA IRQ mask 0x0eb8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x1000 - 0x1fff
pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd42fffff
pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net ethxx0: device_rename: sysfs_create_symlink failed (-17)
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
sdhci: SDHCI controller found at 0000:02:04.3 [104c:803c] (rev 0)
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
ACPI: PCI Interrupt 0000:02:04.3[A] -> <7>usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
usb 2-2: adding 2-2:1.3 (config #1, interface 3)
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '002'
usb 2-2: new device found, idVendor=03f0, idProduct=171d
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: HP Integrated Module
usb 2-2: Manufacturer: Broadcom Corp
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 000a
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI at 0xd4019000 irq 20 PIO
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929613f0c]
eth1 renamed to ethxx1
sysfs: duplicate filename 'ethxx1' can not be created
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_add_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
usb 3-1: new full speed USB device using ohci_hcd and address 2
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83
usb 3-1: ep0 maxpacket = 8
usb 3-1: default language 0x0409

net ethxx1: device_rename: sysfs_create_symlink failed (-17)
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '002'
usb 3-1: new device found, idVendor=08ff, idProduct=2580
usb 3-1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
hub 3-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
ethxx0 renamed to eth1
sysfs: duplicate filename 'eth1' can not be created
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_add_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net eth1: device_rename: sysfs_create_symlink failed (-17)
ethxx1 renamed to eth0
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
Bluetooth: Core ver 2.11
sysfs: duplicate filename 'eth0' can not be created
WARNING: at /home/rafael/src/mm/linux-2.6.23-rc8-mm2/fs/sysfs/dir.c:433 sysfs_add_one()

Call Trace:
 [<ffffffff802d7f28>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d8d2d>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80380ad4>] device_rename+0x17a/0x1db
 [<ffffffff803d27f9>] dev_change_name+0x13c/0x233
 [<ffffffff803d2c27>] dev_ifsioc+0x337/0x403
 [<ffffffff803d30a7>] dev_ioctl+0x3b4/0x4cc
 [<ffffffff8027c94b>] handle_mm_fault+0x1fe/0x6f3
 [<ffffffff8030a6c6>] __up_read+0x8f/0x97
 [<ffffffff803c58c5>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029de12>] do_ioctl+0x2a/0x77
 [<ffffffff8029e0b0>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029e124>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfee>] system_call+0x7e/0x83

net eth0: device_rename: sysfs_create_symlink failed (-17)
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: new low speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: skipped 1 descriptor after interface
usb 3-3: skipped 1 descriptor after interface
usb 3-3: default language 0x0409
usb 3-3: uevent
usb 3-3: usb_probe_device
usb 3-3: configuration #1 chosen from 1 choice
usb 3-3: adding 3-3:1.0 (config #1, interface 0)
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usb 3-3: adding 3-3:1.1 (config #1, interface 1)
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/inode.c: creating file '003'
usb 3-3: new device found, idVendor=046d, idProduct=c521
usb 3-3: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: USB Receiver
usb 3-3: Manufacturer: Logitech
hci_usb 2-2:1.0: usb_probe_interface
hci_usb 2-2:1.0: usb_probe_interface - got id
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0002
hci_usb 2-2:1.2: usb_probe_interface
hci_usb 2-2:1.2: usb_probe_interface - got id
hci_usb 2-2:1.3: usb_probe_interface
hci_usb 2-2:1.3: usb_probe_interface - got id
usbcore: registered new interface driver hci_usb
usbcore: registered new interface driver hiddev
usbhid 3-3:1.0: usb_probe_interface
usbhid 3-3:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
usbhid 3-3:1.1: usb_probe_interface
usbhid 3-3:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input3
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/usb/core/file.c: looking for a minor, starting at 96
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.1-3
usbcore: registered new interface driver usbhid
/home/rafael/src/mm/linux-2.6.23-rc8-mm2/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
Adding 1052216k swap on /dev/sda1.  Priority:-1 extents:1 across:1052216k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ACPI: AC Adapter [C1BD] (on-line)
ACPI: Battery Slot [C1BF] (battery present)
ACPI: Battery Slot [C1BE] (battery absent)
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [C25A]
input: Lid Switch as /class/input/input7
ACPI: Lid Switch [C25B]
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C34F] to D3
ACPI: Fan [C34F] (off)
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Fan [C350] (off)
ACPI: Transitioning device [C351] to D3
ACPI: Transitioning device [C351] to D3
ACPI: Fan [C351] (off)
ACPI: Transitioning device [C352] to D3
ACPI: Transitioning device [C352] to D3
ACPI: Fan [C352] (off)
ACPI: Processor [C000] (supports 8 throttling states)
ACPI: Processor [C001] (supports 8 throttling states)
ACPI: Thermal Zone [TZ1] (62 C)
ACPI: Thermal Zone [TZ2] (53 C)
ACPI: Thermal Zone [TZ3] (32 C)
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 processors (2 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x13
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x15
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x17
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0xc
mtrr: no more MTRRs available
APIC error on CPU0: 00(40)
APIC error on CPU1: 00(40)

--Boundary-00=_qn8+GOrI9uuMr46--
