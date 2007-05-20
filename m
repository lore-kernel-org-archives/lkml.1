Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXETNf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXETNf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbXETNfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:35:15 -0400
Received: from web52609.mail.re2.yahoo.com ([206.190.48.212]:24393 "HELO
	web52609.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755955AbXETNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:35:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=c1gJGUQK2ZST4F3LlqHIXyx3lNZIVF0wbqzg/f3AuwfODaLDzkmiKAkDpzjKKUtwRWrAgdLYDPLSnd0cKCGIzSfi4XVKF4SnCuI8KDzYSjWMnhcZz6oyIbdx0ZIvz5kpPMEF0G/wNbGr4/VrXoXakBs1G0o7LHuX6DW9Zu/1Ais=  ;
Message-ID: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
X-YMail-OSG: maxnC_UVM1l0UQsT0PGzkk2tDeD538o4Bd5b481EXA_F7cp7j3ni2uGYXus.oQqHnuNoc7Ha9leAQDiLPWH5NKIjiRjoCSnVSs5ElswKhuJaerjuG2PKIX2jTWdB4w--
Date: Sun, 20 May 2007 23:35:05 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-451405972-1179668105=:45990"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-451405972-1179668105=:45990
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:
> --- Christoph Lameter <clameter@sgi.com> wrote:
> > On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:
> > 
> > > Code: 0f ob eb fe 48 8b 1b 48 8b 0x 0f 18 08 48 81 fb 60 cb 51 80
> > > RIP [...] slab_sysfs_init+0x49/0x98
> > > RSP [...]
> > > kernel panic - not syncing: Attempted to kill init!
> > 
> > sysfs? If you build without CONFIG_SLUB_DEBUG then SLUB will not use 
> > sysfs. You can switch that off in the embedded section.
> 
> Fair enough. Would you the section name it appears in 'menuconfig'?

[Sorry for replying to my own email. I've made some progress since then, so
here goes ...]

Sorry for the noise. I've discovered it under "General setup - Configure
standard kernel features (for small systems)".

With no CONFIG_SLUB_DEBUG, things have slightly improved. No more panic. Good.
Serial console is working. Good. But there is another problem:

...
Freeing unused kernel memory: 308k freed
BUG: spinlock bad magic on CPU#1, init/1
 lock: ffff81011ec0a100, .magic: ffff8101, .owner: <none>/-1, .owner_cpu: -1

Call Trace:
 [<ffffffff802fc516>] _raw_spin_lock+0x22/0xf6
 [<ffffffff8026f684>] vma_adjust+0x219/0x454
 [<ffffffff8026f684>] vma_adjust+0x219/0x454
 [<ffffffff8026fe0d>] vma_merge+0x147/0x1f4
 [<ffffffff80270b55>] do_mmap_pgoff+0x414/0x7c7
 [<ffffffff8040aa34>] _spin_unlock_irq+0x24/0x27
 [<ffffffff8020f528>] sys_mmap+0xe5/0x110
 [<ffffffff80209dde>] system_call+0x7e/0x83

ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
...
PM: Adding info for No Bus:vcsa1
BUG: spinlock lockup on CPU#0, sh/385, ffff81011ca8ffc0

Call Trace:
 [<ffffffff802fc5c3>] _raw_spin_lock+0xcf/0xf6
 [<ffffffff80273352>] anon_vma_unlink+0x1c/0x68
 [<ffffffff80273352>] anon_vma_unlink+0x1c/0x68
 [<ffffffff8026ddf4>] free_pgtables+0x69/0xc3
 [<ffffffff8026f0c0>] exit_mmap+0x91/0xeb
 [<ffffffff802295a1>] mmput+0x45/0xb8
 [<ffffffff80288ad8>] flush_old_exec+0x65f/0x941
 [<ffffffff80284c04>] vfs_read+0x13f/0x153
 [<ffffffff802b5a33>] load_elf_binary+0x0/0x197f
 [<ffffffff802b5e93>] load_elf_binary+0x460/0x197f
 [<ffffffff80263557>] __alloc_pages+0x72/0x2d4
 [<ffffffff802b5a33>] load_elf_binary+0x0/0x197f
 [<ffffffff80287d08>] search_binary_handler+0xc4/0x25f
 [<ffffffff80289834>] do_execve+0x188/0x231
 [<ffffffff80208bf7>] sys_execve+0x36/0x8a
 [<ffffffff8020a1d7>] stub_execve+0x67/0xb0

It just simply hangs there. With slab all is well, of course.

(If you want me to activate all kernel debugging options, do advise, I'm happy
to do that. Nothing changed in ref to my .config from the past email save the
CONFIG_SLUB_DEBUG is gone now.)

The dmesg is attached for your reference.

Thanks


      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

--0-451405972-1179668105=:45990
Content-Type: text/plain; name="dmesg-2.6.22-slub.txt"
Content-Description: 991354462-dmesg-2.6.22-slub.txt
Content-Disposition: inline; filename="dmesg-2.6.22-slub.txt"

Linux version 2.6.22-rc2-ahci-slub (hari@fedora7) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #6 SMP Sun May 20 23:05:08 EST 2007
Command line: ro root=LABEL=/1234 console=ttyS0,115200 console=tty0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
end_pfn_map = 1179648
DMI 2.4 present.
ACPI: RSDP 000F8110, 0024 (r2 ATI   )
ACPI: XSDT DFEE30C0, 0044 (r1 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: FACP DFEE83C0, 00F4 (r3 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: DSDT DFEE3240, 511E (r1 ATI    ASUSACPI     1000 MSFT  3000000)
ACPI: FACS DFEE0000, 0040
ACPI: SSDT DFEE85C0, 02CC (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG DFEE8980, 003C (r1 ATI    ASUSACPI 42302E31 AWRD        0)
ACPI: APIC DFEE8500, 0068 (r1 ATI    ASUSACPI 42302E31 AWRD        0)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Bootmem setup node 0 0000000000000000-0000000120000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1179648
early_node_map[3] active PFN ranges
    0:        0 ->      159
    0:      256 ->   917216
    0:  1048576 ->  1179648
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
PERCPU: Allocating 33672 bytes of per cpu data
Built 1 zonelists.  Total pages: 1030075
Kernel command line: ro root=LABEL=/1234 console=ttyS0,115200 console=tty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2799.974 MHz processor.
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
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 4058408k/4718592k available (2102k kernel code, 134356k reserved, 1229k data, 308k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, Processors=2, Nodes=1
Calibrating delay using timer specific routine.. 5604.66 BogoMIPS (lpj=11209328)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 22k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12499895
Detected 12.499 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5600.19 BogoMIPS (lpj=11200386)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ stepping 03
Brought up 2 CPUs
migration_cost=50
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
pnp: 00:01: ioport range 0x4100-0x411f has been reserved
pnp: 00:01: ioport range 0x228-0x22f has been reserved
pnp: 00:01: ioport range 0x40b-0x40b has been reserved
pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:01: ioport range 0xc00-0xc01 has been reserved
pnp: 00:01: ioport range 0xc14-0xc14 has been reserved
pnp: 00:01: ioport range 0xc50-0xc52 has been reserved
pnp: 00:01: ioport range 0xc6c-0xc6d has been reserved
pnp: 00:09: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0a: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0a: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0a: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:07.0
  IO window: e000-efff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fdf00000-fdffffff
PCI: Bridge: 0000:00:14.4
  IO window: c000-cfff
Time: acpi_pm clocksource has been installed.
  MEM window: fde00000-fdefffff
  PREFETCH window: fdd00000-fddfffff
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 13, 33554432 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3031k freed
audit: initializing netlink socket (disabled)
audit(1179666942.608:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing enabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
usbcore: registered new interface driver libusual
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
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ processors (version 2.00.00)
powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
Freeing unused kernel memory: 308k freed
BUG: spinlock bad magic on CPU#1, init/1
 lock: ffff81011ec0a100, .magic: ffff8101, .owner: <none>/-1, .owner_cpu: -1

Call Trace:
 [<ffffffff802fc516>] _raw_spin_lock+0x22/0xf6
 [<ffffffff8026f684>] vma_adjust+0x219/0x454
 [<ffffffff8026f684>] vma_adjust+0x219/0x454
 [<ffffffff8026fe0d>] vma_merge+0x147/0x1f4
 [<ffffffff80270b55>] do_mmap_pgoff+0x414/0x7c7
 [<ffffffff8040aa34>] _spin_unlock_irq+0x24/0x27
 [<ffffffff8020f528>] sys_mmap+0xe5/0x110
 [<ffffffff80209dde>] system_call+0x7e/0x83

ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb 2-1: new low speed USB device using ohci_hcd and address 2
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for usb:2-1
PM: Adding info for No Bus:usbdev2.2_ep00
usb 2-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-1:1.0
ACPI: PCI Interrupt 0000:00:13.4[C] -> <6>input: Logitech USB Receiver as /class/input/input0
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:13.1-1
PM: Adding info for No Bus:usbdev2.2_ep81
PM: Adding info for usb:2-1:1.1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech keyboard report descriptor
GSI 18 (level, low) -> IRQ 18
input: Logitech USB Receiver as /class/input/input1
PM: Adding info for No Bus:hiddev0
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-1
PM: Adding info for No Bus:usbdev2.2_ep82
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
PM: Adding info for usb:usb5
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev5.1_ep81
ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb 2-1: USB disconnect, address 2
PM: Adding info for usb:usb6
PM: Adding info for No Bus:usbdev6.1_ep00
PM: Removing info for No Bus:usbdev2.2_ep81
PM: Removing info for usb:2-1:1.0
PM: Removing info for No Bus:usbdev2.2_ep82
PM: Removing info for No Bus:hiddev0
PM: Removing info for usb:2-1:1.1
PM: Removing info for No Bus:usbdev2.2_ep00
PM: Removing info for usb:2-1
usb usb6: configuration #1 chosen from 1 choice
PM: Adding info for usb:6-0:1.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 10 ports detected
PM: Adding info for No Bus:usbdev6.1_ep81
SCSI subsystem initialized
libata version 2.20 loaded.
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
scsi0 : pata_atiixp
PM: Adding info for No Bus:host0
scsi1 : pata_atiixp
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001f900 irq 14
ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001f908 irq 15
usb 2-1: new low speed USB device using ohci_hcd and address 3
ata1.00: ata_hpa_resize 1: sectors = 234435439, hpa_sectors = 234441648
ata1.00: Host Protected Area detected:
	current size: 234435439 sectors
	native size: 234441648 sectors
ata1.00: ATA-6: ST3120026A, 3.06, max UDMA/100
ata1.00: 234435439 sectors, multi 1: LBA48 
ata1.01: ATAPI, max UDMA/33
ata1.00: ata_hpa_resize 1: sectors = 234435439, hpa_sectors = 234441648
ata1.00: Host Protected Area detected:
	current size: 234435439 sectors
	native size: 234441648 sectors
ata1.00: configured for UDMA/100
PM: Adding info for usb:2-1
PM: Adding info for No Bus:usbdev2.3_ep00
usb 2-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-1:1.0
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:13.1-1
PM: Adding info for No Bus:usbdev2.3_ep81
PM: Adding info for usb:2-1:1.1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech keyboard report descriptor
input: Logitech USB Receiver as /class/input/input3
PM: Adding info for No Bus:hiddev0
input,hiddev96: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-1
PM: Adding info for No Bus:usbdev2.3_ep82
ata1.01: configured for UDMA/33
ata2: device not ready (errno=-19), forcing hardreset
ata2: BUG: prereset() requested invalid reset type
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      ST3120026A       3.06 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
sd 0:0:0:0: [sda] 234435439 512-byte hardware sectors (120031 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234435439 512-byte hardware sectors (120031 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda14 >
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Adding info for No Bus:target0:0:1
scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A102 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:1:0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1179666950.984:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1817 types, 78 bools, 1 sens, 1024 cats
security:  60 classes, 65667 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), not configured for labeling
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1179666951.376:3): policy loaded auid=4294967295
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
BUG: spinlock lockup on CPU#0, sh/385, ffff81011ca8ffc0

Call Trace:
 [<ffffffff802fc5c3>] _raw_spin_lock+0xcf/0xf6
 [<ffffffff80273352>] anon_vma_unlink+0x1c/0x68
 [<ffffffff80273352>] anon_vma_unlink+0x1c/0x68
 [<ffffffff8026ddf4>] free_pgtables+0x69/0xc3
 [<ffffffff8026f0c0>] exit_mmap+0x91/0xeb
 [<ffffffff802295a1>] mmput+0x45/0xb8
 [<ffffffff80288ad8>] flush_old_exec+0x65f/0x941
 [<ffffffff80284c04>] vfs_read+0x13f/0x153
 [<ffffffff802b5a33>] load_elf_binary+0x0/0x197f
 [<ffffffff802b5e93>] load_elf_binary+0x460/0x197f
 [<ffffffff80263557>] __alloc_pages+0x72/0x2d4
 [<ffffffff802b5a33>] load_elf_binary+0x0/0x197f
 [<ffffffff80287d08>] search_binary_handler+0xc4/0x25f
 [<ffffffff80289834>] do_execve+0x188/0x231
 [<ffffffff80208bf7>] sys_execve+0x36/0x8a
 [<ffffffff8020a1d7>] stub_execve+0x67/0xb0


--0-451405972-1179668105=:45990--
