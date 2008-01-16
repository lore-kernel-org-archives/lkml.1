Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYAPBmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYAPBmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYAPBmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:42:25 -0500
Received: from ns2.lanforge.com ([66.165.47.211]:45242 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYAPBmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:42:23 -0500
X-Greylist: delayed 2406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 20:42:23 EST
Message-ID: <478D5797.6060800@candelatech.com>
Date: Tue, 15 Jan 2008 17:02:15 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: BUG related to serial console in 2.6.23.14 kernel.
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this crash when booting 2.6.23.14 on serial console.  This
kernel also has my patches applied, but nothing that should
affect the serial consle (tm).

2.6.20.12 plus my patches boots fine on this same system.

The hardware is some little embedded system with some pro/1000
NICs, Pentium-M processor, 1GB RAM, and generally pc-ish in nature.  It is booting
a minimal install of Fedora 8 off of a 2GB CF disk.

Fedora 8 is up-to-date as of today.

I'm happy to provide whatever other info is needed.

Thanks,
Ben


Starting udev: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c printing eip:
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: 8139too mii e1000 i2c_i801 8250_pnp i2c_core button usb_storage sd_mod scsidCPU:    0
EIP:    0060:[<c0265a5d>]    Not tainted VLI
EFLAGS: 00210202   (2.6.23.14c3 #2)
EIP is at uart_write_room+0xd/0x20
eax: f75fa280   ebx: 00000001   ecx: f6e78000   edx: 00000000
esi: 00000001   edi: f7fa3800   ebp: f6e79f1c   esp: f6e79ee4
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process start_udev (pid: 367, ti=f6e78000 task=f7d0d0c0 task.ti=f6e78000)
Stack: c0240b4e f7fa395c f7f9a400 f7feea40 f7f9a400 00200246 00000000 f7d0d0c0
        c01153e0 f7fa396c f7fa396c 00000001 f7fa3800 f7feea40 f6e79f50 c023e308
        00000001 00000001 b7d06000 c0240a50 f7fa380c c0424f40 00000001 00000000
Call Trace:
  [<c010416a>] show_trace_log_lvl+0x1a/0x30
  [<c0104231>] show_stack_log_lvl+0xb1/0xe0
  [<c010445f>] show_registers+0x1ff/0x370
  [<c01046d4>] die+0x104/0x250
  [<c0112cde>] do_page_fault+0x35e/0x640
  [<c0344afa>] error_code+0x6a/0x70
  [<c023e308>] tty_write+0x128/0x1c0
  [<c023e41c>] redirected_tty_write+0x7c/0x80
  [<c0165086>] vfs_write+0x96/0x130
  [<c016563d>] sys_write+0x3d/0x70
  [<c0102b66>] sysenter_past_esp+0x5f/0x89
  =======================
Code: 08 89 ec 5d c3 8b 40 10 81 48 10 00 00 00 02 eb db 81 49 10 00 00 00 04 eb c2 8d 74 26 0
EIP: [<c0265a5d>] uart_write_room+0xd/0x20 SS:ESP 0068:f6e79ee4


root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83
kernel /boot/ct2.6.23.14c3.img ro root=LABEL=/ ide=nodma console=ttyS0,38400
    [Linux-bzImage, setup=0x2c00, size=0x1bf118]
initrd /boot/initrd-ct2.6.23.14c3.img
    [Linux-initrd @ 0x37d30000, 0x2bfbc4 bytes]

Linux version 2.6.23.14c3 (greearb@file-server) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)8BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
  BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003fbf0000 (usable)
  BIOS-e820: 000000003fbf0000 - 000000003fbf3000 (ACPI NVS)
  BIOS-e820: 000000003fbf3000 - 000000003fc00000 (ACPI data)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   229376
DMI 2.3 present.
ACPI: RSDP 000F6460, 0014 (r0 IntelR)
ACPI: RSDT 3FBF3040, 0028 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FBF30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FBF3180, 3A5E (r1 INTELR AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FBF0000, 0040
ACPI: PM-Timer IO Port: 0x408
Allocating PCI resources starting at 40000000 (gap: 3fc00000:bf000000)
Built 1 zonelists in Zone order.  Total pages: 227584
Kernel command line: ro root=LABEL=/ ide=nodma console=ttyS0,38400
ide_setup: ide=nodma : Prevented DMA
Found and enabled local APIC!
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1599.858 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 902236k/917504k available (2326k kernel code, 14652k reserved, 1003k data, 212k init, )virtual kernel memory layout:
     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
     vmalloc : 0xf8800000 - 0xfffb3000   ( 119 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0444000 - 0xc0479000   ( 212 kB)
       .data : 0xc0345846 - 0xc04405e4   (1003 kB)
       .text : 0xc0100000 - 0xc0345846   (2326 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3200.75 BogoMIPS (lpj=1600376)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) M processor 1600MHz stepping 05
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e20)
khelper used greatest stack depth: 7424 bytes left
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb630, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
khelper used greatest stack depth: 7348 bytes left
khelper used greatest stack depth: 7196 bytes left
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:09: ioport range 0x400-0x4bf could not be reserved
pnp: 00:0b: iomem range 0xcc600-0xcffff has been reserved
pnp: 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:1e.0
   IO window: d000-dfff
   MEM window: e8000000-e80fffff
   PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2814k freed
audit: initializing netlink socket (disabled)
audit(1200414595.806:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
ACPI: Fan [FAN] (on)
ACPI: Processor [CPU0] (supports 2 throttling states)
ACPI: Thermal Zone [THRM] (45 C)
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Linux agpgart interface v0.102
agpgart: Detected an Intel 855GM Chipset.
agpgart: Detected 3964K stolen memory.
agpgart: AGP aperture is 128M @ 0xd8000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Switched to high resolution mode on CPU 0
?serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
khelper used greatest stack depth: 6864 bytes left
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:pio
hdc: , ATA DISK drive
hdc: applying conservative PIO "downgrade"
hdc: applying conservative PIO "downgrade"
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 4061232 sectors (2079 MB) w/1KiB Cache, CHS=4029/16/63
  hdc: hdc1
ide-floppy driver 0.99.newide
usbmon: debugfs is not available
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
/home/greearb/git/linux-2.6.dev.23/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 212k freed
Red Hat nash version 6.0.19 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block dACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
evice nodes.
LoACPI: PCI Interrupt 0000:00:1d.7[D] -> ading ehci-hcd.kLink [LNK1] -> GSI 11 (level, low) ->1o module
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xe8200000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
insmod used greatest stack depth: 6220 bytes left
Loading ohci-hcd.ko module
LoadUSB Universal Host Controller Interface driver v3.0
ing uhci-hcd.ko ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 9
module
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 9, io base 0x0000eb00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 10, io base 0x0000ed00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 11, io base 0x0000e800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
insmod used greatest stack depth: 6208 bytes left
Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Loading usb-storInitializing USB Mass Storage driver...
age.ko module
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
Waiting for driver initialization.
Creating root device.
Mounting root filesystem.
EXT3-fs: mounted filesystem with ordered data mode.
Setting up otherkjournald starting.  Commit interval 5 seconds
  filesystems.
Setting up new root fs
no fstab.sys, mounting internal defaults
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
Mount failed for selinuxfs on /selinux:  No such device
INIT: version 2.86 booting
mount used greatest stack depth: 6100 bytes left
awk used greatest stack depth: 6008 bytes left
                 Welcome to Fedora
                 Press 'I' to enter interactive startup.
date used greatest stack depth: 6000 bytes left
Setting clock  (utc): Tue Jan 15 08:30:14 PST 2008 [  OK  ]
Starting udev: BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c printing eip:
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: 8139too mii e1000 i2c_i801 8250_pnp i2c_core button usb_storage sd_mod scsidCPU:    0
EIP:    0060:[<c0265a5d>]    Not tainted VLI
EFLAGS: 00210202   (2.6.23.14c3 #2)
EIP is at uart_write_room+0xd/0x20
eax: f75fa280   ebx: 00000001   ecx: f6e78000   edx: 00000000
esi: 00000001   edi: f7fa3800   ebp: f6e79f1c   esp: f6e79ee4
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process start_udev (pid: 367, ti=f6e78000 task=f7d0d0c0 task.ti=f6e78000)
Stack: c0240b4e f7fa395c f7f9a400 f7feea40 f7f9a400 00200246 00000000 f7d0d0c0
        c01153e0 f7fa396c f7fa396c 00000001 f7fa3800 f7feea40 f6e79f50 c023e308
        00000001 00000001 b7d06000 c0240a50 f7fa380c c0424f40 00000001 00000000
Call Trace:
  [<c010416a>] show_trace_log_lvl+0x1a/0x30
  [<c0104231>] show_stack_log_lvl+0xb1/0xe0
  [<c010445f>] show_registers+0x1ff/0x370
  [<c01046d4>] die+0x104/0x250
  [<c0112cde>] do_page_fault+0x35e/0x640
  [<c0344afa>] error_code+0x6a/0x70
  [<c023e308>] tty_write+0x128/0x1c0
  [<c023e41c>] redirected_tty_write+0x7c/0x80
  [<c0165086>] vfs_write+0x96/0x130
  [<c016563d>] sys_write+0x3d/0x70
  [<c0102b66>] sysenter_past_esp+0x5f/0x89
  =======================
Code: 08 89 ec 5d c3 8b 40 10 81 48 10 00 00 00 02 eb db 81 49 10 00 00 00 04 eb c2 8d 74 26 0
EIP: [<c0265a5d>] uart_write_room+0xd/0x20 SS:ESP 0068:f6e79ee4

  CTRL-A Z for help | 38400 8N1 | NOR | Minicom 2.1    | VT102 |      Offline


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

