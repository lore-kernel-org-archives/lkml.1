Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXEBUtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXEBUtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXEBUtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:49:09 -0400
Received: from web52602.mail.re2.yahoo.com ([206.190.48.205]:25758 "HELO
	web52602.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752237AbXEBUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:49:03 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 16:49:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ZDBafstPZJ556AwmwQIvCRsnO/ngfrzhZN68ovbyRR0PdUnSv+xoBTWwhT25nSHY6itM9cH9dFeStg4EYWzlYvNthO46pM8pXKqWdlVhdgh6lg/SCJ4gBrfXENwAF5jhiWn2lRf7M2fgq2/UibKxWf7e7bkgrvo7ma6svMI7VW0=;
X-YMail-OSG: AtosU.YVM1mpJjeqPlcuIoH8fovAo98QQwlengaw
Date: Thu, 3 May 2007 06:42:20 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: [PROBLEM] 2.6.21-git oops
To: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <106433.5924.qm@web52602.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the first one (there a couple following this;
the complete dmesg is at the bottom of this email):

invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 xt_state
nf_conntrack nfnetlink ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables br
idge llc autofs4 sunrpc cpufreq_ondemand dm_mirror
dm_mod video sbs button dock
battery ac radeon drm parport loop kvm_amd kvm r8169
snd_hda_intel snd_hda_codec
 snd_seq_dummy snd_seq_oss snd_seq_midi_event shpchp
snd_seq snd_seq_device snd_
pcm_oss sr_mod cdrom snd_mixer_oss sg snd_pcm rtc_cmos
rtc_core rtc_lib snd_time
r ahci k8temp hwmon snd soundcore snd_page_alloc
floppy pcspkr ata_generic pata_
atiixp libata sd_mod scsi_mod ext3 jbd mbcache
ehci_hcd ohci_hcd
Pid: 6624, comm: objdump Not tainted 2.6.21-hv #4
RIP: 0010:[<ffffffff8031b011>]  [<ffffffff8031b011>]
selinux_bprm_free_security+
0x14/0x27
RSP: 0000:ffff81003c37feb8  EFLAGS: 00010296
RAX: 00000000e8000001 RBX: ffff810100839e00 RCX:
000000000000001b
RDX: ffffffff8020b137 RSI: ffff81003c37ff58 RDI:
ffff810100839e00
RBP: ffffffff80562b00 R08: 0000000000000000 R09:
ffff810000000000
R10: 0000000043d39ef2 R11: 0000000000000001 R12:
ffff810100839e00
R13: 0000000000000000 R14: ffff81005523e000 R15:
00000000008cef00
FS:  00002ae8f2bf8e00(0000) GS:ffff81011fc106c0(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ffff6045c80 CR3: 0000000043ebe000 CR4:
00000000000006e0
Process objdump (pid: 6624, threadinfo
ffff81003c37e000, task ffff81007438a0c0)
Stack:  ffff81005523e000 ffff8100d54f90c0
ffff81003c37ff18 ffffffff8023f6da
 00000000008d8f10 ffff81003c37ff58 00000000008d8010
ffff81005523e000
 00000000008cef00 00000000008d8010 ffff81005523e000
0000000000000000
Call Trace:
 [<ffffffff8023f6da>] do_execve+0x1b8/0x261
 [<ffffffff802532fe>] sys_execve+0x36/0x8b
 [<ffffffff8025c517>] stub_execve+0x67/0xb0


>From http://www.kernel.org/hg/linux-2.6 it's at
changeset 53525:446b168aa99e (with summary: libata:
honour host controllers that want just one host).

Vanilla 2.6.21 also hung solid. Alas, I didn't have
the serial console attached then to capture the
oops/bug/panic if there was one.

Here's the complete dmesg:
Linux version 2.6.21-hv (hari@fedora7) (gcc version
4.1.2 20070424 (Red Hat 4.1.2-11)) #4 SMP Wed May 2
23:33:59 EST 2007
Command line: ro root=LABEL=/1234 console=ttyS0,115200
console=tty0 rhgb
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000
(usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000
(reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000
(reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000
(usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI
NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI
data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000
(reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000
(reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000
(reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000
(usable)
end_pfn_map = 1179648
DMI 2.4 present.
ACPI: RSDP 000F80A0, 0024 (r2 ATI   )
ACPI: XSDT DFEE30C0, 0044 (r1 ATI    ASUSACPI 42302E31
AWRD        0)
ACPI: FACP DFEE83C0, 00F4 (r3 ATI    ASUSACPI 42302E31
AWRD        0)
ACPI: DSDT DFEE3240, 511F (r1 ATI    ASUSACPI     1000
MSFT  3000000)
ACPI: FACS DFEE0000, 0040
ACPI: SSDT DFEE85C0, 02CC (r1 PTLTD  POWERNOW        1
 LTP        1)
ACPI: MCFG DFEE8980, 003C (r1 ATI    ASUSACPI 42302E31
AWRD        0)
ACPI: APIC DFEE8500, 0068 (r1 ATI    ASUSACPI 42302E31
AWRD        0)
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 0000000120000000
Using node hash shift of 63
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
ACPI: IOAPIC (id[0x02] address[0xfec00000]
gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl
dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low
level)
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 -
00000000000a0000
Nosave address range: 00000000000a0000 -
00000000000f0000
Nosave address range: 00000000000f0000 -
0000000000100000
Nosave address range: 00000000dfee0000 -
00000000dfee3000
Nosave address range: 00000000dfee3000 -
00000000dfef0000
Nosave address range: 00000000dfef0000 -
00000000dff00000
Nosave address range: 00000000dff00000 -
00000000e0000000
Nosave address range: 00000000e0000000 -
00000000f0000000
Nosave address range: 00000000f0000000 -
00000000fec00000
Nosave address range: 00000000fec00000 -
0000000100000000
Allocating PCI resources starting at f1000000 (gap:
f0000000:ec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 42240 bytes of per cpu data
Built 1 zonelists.  Total pages: 1020626
Kernel command line: ro root=LABEL=/1234
console=ttyS0,115200 console=tty0 rhgb
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2799.954 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9,
2097152 bytes)
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 4018544k/4718592k available (2316k kernel
code, 174220k reserved, 1327k data, 320k init)
Calibrating delay using timer specific routine..
5602.65 BogoMIPS (lpj=2801325)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary
module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12499805
Detected 12.499 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine..
5598.98 BogoMIPS (lpj=2799493)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
stepping 03
Brought up 2 CPUs
migration_cost=300
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10
*11)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP
aperture
pnp: 00:01: ioport range 0x4100-0x411f has been
reserved
pnp: 00:01: ioport range 0x228-0x22f has been reserved
pnp: 00:01: ioport range 0x40b-0x40b has been reserved
pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:01: ioport range 0xc00-0xc01 has been reserved
pnp: 00:01: ioport range 0xc14-0xc14 has been reserved
pnp: 00:01: ioport range 0xc50-0xc52 has been reserved
pnp: 00:01: ioport range 0xc6c-0xc6d has been reserved
pnp: 00:0a: iomem range 0xe0000000-0xefffffff could
not be reserved
pnp: 00:0b: iomem range 0xf0000-0xf3fff could not be
reserved
pnp: 00:0b: iomem range 0xf4000-0xf7fff could not be
reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be
reserved
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be
reserved
PCI: Bridge: 0000:00:02.0
Time: acpi_pm clocksource has been installed.
  IO window: d000-dfff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:07.0
  IO window: e000-efff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fdf00000-fdffffff
PCI: Bridge: 0000:00:14.4
  IO window: c000-cfff
  MEM window: fde00000-fdefffff
  PREFETCH window: fdd00000-fddfffff
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
TCP established hash table entries: 65536 (order: 10,
4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016
bytes)
TCP: Hash tables configured (established 65536 bind
65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3036k freed
audit: initializing netlink socket (disabled)
audit(1178113287.223:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096
bytes)
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
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports,
IRQ sharing enabled
&#65533;serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a
16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K
size 4096 blocksize
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using
default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core
driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core
Processor 5600+ processors (version 2.00.00)
powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
Freeing unused kernel memory: 320k freed
Write protecting the kernel read-only data: 997k
input: AT Translated Set 2 keyboard as
/class/input/input0
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level,
low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered,
assigned bus number 1
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level,
low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered,
assigned bus number 2
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level,
low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered,
assigned bus number 3
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level,
low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered,
assigned bus number 4
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb 2-1: new low speed USB device using ohci_hcd and
address 2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level,
low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered,
assigned bus number 5
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb 2-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input1
input: USB HID v1.10 Keyboard [Logitech USB Receiver]
on usb-0000:00:13.1-1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech
keyboard report descriptor
input: Logitech USB Receiver as /class/input/input2
input,hiddev96: USB HID v1.10 Mouse [Logitech USB
Receiver] on usb-0000:00:13.1-1
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level,
low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered,
assigned bus number 6
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
usb 2-1: USB disconnect, address 2
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 10 ports detected
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level,
low) -> IRQ 16
scsi0 : pata_atiixp
scsi1 : pata_atiixp
ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x000000000001f900 irq 14
ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x000000000001f908 irq 15
usb 2-1: new low speed USB device using ohci_hcd and
address 3
ata1.00: ata_hpa_resize 1: sectors = 234435439,
hpa_sectors = 234441648
ata1.00: Host Protected Area detected:
	current size: 234435439 sectors
	native size: 234441648 sectors
ata1.00: ATA-6: ST3120026A, 3.06, max UDMA/100
ata1.00: 234435439 sectors, multi 1: LBA48 
ata1.01: ATAPI, max UDMA/33
ata1.00: ata_hpa_resize 1: sectors = 234435439,
hpa_sectors = 234441648
ata1.00: Host Protected Area detected:
	current size: 234435439 sectors
	native size: 234441648 sectors
ata1.00: configured for UDMA/100
usb 2-1: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Keyboard [Logitech USB Receiver]
on usb-0000:00:13.1-1
drivers/hid/usbhid/hid-core.c: Fixing up Logitech
keyboard report descriptor
input: Logitech USB Receiver as /class/input/input4
input,hiddev96: USB HID v1.10 Mouse [Logitech USB
Receiver] on usb-0000:00:13.1-1
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST3120026A   
   3.06 PQ: 0 ANSI: 5
SCSI device sda: 234435439 512-byte hdwr sectors
(120031 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
SCSI device sda: 234435439 512-byte hdwr sectors
(120031 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9
sda10 sda11 sda12 sda13 sda14 >
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM
GSA-4163B A102 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1178113293.782:2): enforcing=1 old_enforcing=0
auid=4294967295
audit(1178113294.074:3): policy loaded auid=4294967295
Bridge firewalling registered
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink
ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc autofs4 sunrpc cpufreq_ondemand dm_mirror
dm_mod video sbs button dock battery ac radeon drm
parport loop kvm_amd kvm r8169 snd_hda_intel
snd_hda_codec snd_seq_dummy snd_seq_oss
snd_seq_midi_event shpchp snd_seq snd_seq_device
snd_pcm_oss sr_mod cdrom snd_mixer_oss sg snd_pcm
rtc_cmos rtc_core rtc_lib snd_timer ahci k8temp hwmon
snd soundcore snd_page_alloc floppy pcspkr ata_generic
pata_atiixp libata sd_mod scsi_mod ext3 jbd mbcache
ehci_hcd ohci_hcd
Pid: 6624, comm: objdump Not tainted 2.6.21-hv #4
RIP: 0010:[<ffffffff8031b011>]  [<ffffffff8031b011>]
selinux_bprm_free_security+0x14/0x27
RSP: 0000:ffff81003c37feb8  EFLAGS: 00010296
RAX: 00000000e8000001 RBX: ffff810100839e00 RCX:
000000000000001b
RDX: ffffffff8020b137 RSI: ffff81003c37ff58 RDI:
ffff810100839e00
RBP: ffffffff80562b00 R08: 0000000000000000 R09:
ffff810000000000
R10: 0000000043d39ef2 R11: 0000000000000001 R12:
ffff810100839e00
R13: 0000000000000000 R14: ffff81005523e000 R15:
00000000008cef00
FS:  00002ae8f2bf8e00(0000) GS:ffff81011fc106c0(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ffff6045c80 CR3: 0000000043ebe000 CR4:
00000000000006e0
Process objdump (pid: 6624, threadinfo
ffff81003c37e000, task ffff81007438a0c0)
Stack:  ffff81005523e000 ffff8100d54f90c0
ffff81003c37ff18 ffffffff8023f6da
 00000000008d8f10 ffff81003c37ff58 00000000008d8010
ffff81005523e000
 00000000008cef00 00000000008d8010 ffff81005523e000
0000000000000000
Call Trace:
 [<ffffffff8023f6da>] do_execve+0x1b8/0x261
 [<ffffffff802532fe>] sys_execve+0x36/0x8b
 [<ffffffff8025c517>] stub_execve+0x67/0xb0


Code: f3 fe ee ff 48 c7 83 b8 01 00 00 00 00 00 00 5a
5b c9 c3 55 
RIP  [<ffffffff8031b011>]
selinux_bprm_free_security+0x14/0x27
 RSP <ffff81003c37feb8>
Bad page state in process 'as'
page:ffff810002c17f30 flags:0x0050080000000000
mapping:0000000000000000 mapcount:0 count:-2113929216
Trying to fix it up, but a reboot is needed
Backtrace:

Call Trace:
 [<ffffffff802bfb66>] bad_page+0x5b/0x89
 [<ffffffff8020a571>]
get_page_from_freelist+0x312/0x54b
 [<ffffffff8020ea05>] __alloc_pages+0x74/0x2dd
 [<ffffffff80221786>] alloc_page_vma+0x85/0x8e
 [<ffffffff80208c02>] __handle_mm_fault+0x580/0xcd1
 [<ffffffff8026604c>] do_page_fault+0x38b/0x7ed
 [<ffffffff80266108>] do_page_fault+0x447/0x7ed
 [<ffffffff802b8a61>] audit_syscall_exit+0x2f7/0x318
 [<ffffffff802642bd>] error_exit+0x0/0x96

Unable to handle kernel NULL pointer dereference at
0000000000000008 RIP: 
 [<ffffffff802d2e6d>] free_block+0xb2/0x15f
PGD 3a330067 PUD 4a872067 PMD 0 
Oops: 0002 [2] SMP 
CPU 0 
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink
ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc autofs4 sunrpc cpufreq_ondemand dm_mirror
dm_mod video sbs button dock battery ac radeon drm
parport loop kvm_amd kvm r8169 snd_hda_intel
snd_hda_codec snd_seq_dummy snd_seq_oss
snd_seq_midi_event shpchp snd_seq snd_seq_device
snd_pcm_oss sr_mod cdrom snd_mixer_oss sg snd_pcm
rtc_cmos rtc_core rtc_lib snd_timer ahci k8temp hwmon
snd soundcore snd_page_alloc floppy pcspkr ata_generic
pata_atiixp libata sd_mod scsi_mod ext3 jbd mbcache
ehci_hcd ohci_hcd
Pid: 4519, comm: rm Tainted: G    B  2.6.21-hv #4
RIP: 0010:[<ffffffff802d2e6d>]  [<ffffffff802d2e6d>]
free_block+0xb2/0x15f
RSP: 0018:ffff810073751b88  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff81011fc34a40 RCX:
ffff81011fc37ec0
RDX: 0000000000000000 RSI: ffff81001492f000 RDI:
ffff81005492ff68
RBP: ffff810073751bb8 R08: ffff81011fc36000 R09:
0000000000000001
R10: ffffffff802d3028 R11: ffff810073751d78 R12:
ffff81011fc358a8
R13: 000000000000000d R14: 0000000000000000 R15:
000000000000003c
FS:  00002b7528ff2280(0000) GS:ffffffff8058f000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000004e8d8000 CR4:
00000000000006e0
Process rm (pid: 4519, threadinfo ffff810073750000,
task ffff810070aa30c0)
Stack:  ffff81011fc35800 ffff81011fc37ec0
000000000000003c ffff81011fc35800
 0000000000000000 ffff81011fc34a40 ffff810073751bf8
ffffffff802d306f
 ffff81011fc37f00 ffff81011fc35800 0000000000000000
ffff81004776a338
Call Trace:
 [<ffffffff802d306f>] cache_flusharray+0x86/0xbc
 [<ffffffff8020769d>] kmem_cache_free+0x20a/0x241
 [<ffffffff80226d9c>] free_buffer_head+0x24/0x3e
 [<ffffffff80227c07>] try_to_free_buffers+0x8e/0xa5
 [<ffffffff8022d52e>] wake_up_bit+0x1e/0x23
 [<ffffffff8801b6a6>]
:jbd:journal_invalidatepage+0x334/0x37e
 [<ffffffff88032d5f>]
:ext3:ext3_invalidatepage+0x38/0x3a
 [<ffffffff802c16ce>] do_invalidatepage+0x23/0x25
 [<ffffffff8021c802>] truncate_complete_page+0x30/0x4e
 [<ffffffff8022b9de>]
truncate_inode_pages_range+0xb7/0x333
 [<ffffffff880331f0>] :ext3:ext3_delete_inode+0x0/0xda
 [<ffffffff802c19ac>] truncate_inode_pages+0xd/0xf
 [<ffffffff88033208>]
:ext3:ext3_delete_inode+0x18/0xda
 [<ffffffff880331f0>] :ext3:ext3_delete_inode+0x0/0xda
 [<ffffffff8022f544>] generic_delete_inode+0xc8/0x142
 [<ffffffff802397e5>] generic_drop_inode+0x17/0x176
 [<ffffffff8022b0d0>] iput+0x7c/0x80
 [<ffffffff8023c854>] do_unlinkat+0xf7/0x172
 [<ffffffff8026c332>] syscall_trace_enter+0x95/0x99
 [<ffffffff802db61b>] sys_unlinkat+0x24/0x26
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1


Code: 48 89 42 08 48 89 10 89 f8 48 c7 06 00 01 10 00
48 c7 46 08 
RIP  [<ffffffff802d2e6d>] free_block+0xb2/0x15f
 RSP <ffff810073751b88>
CR2: 0000000000000008
BUG: sleeping function called from invalid context at
kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>]
0x0
hardirqs last disabled at (0): [<ffffffff8021ee91>]
copy_process+0x541/0x15af
softirqs last  enabled at (0): [<ffffffff8021ee91>]
copy_process+0x541/0x15af
softirqs last disabled at (0): [<0000000000000000>]
0x0

Call Trace:
 [<ffffffff8020b765>] __might_sleep+0xda/0xdc
 [<ffffffff8029d305>] down_read+0x1d/0x4a
 [<ffffffff802ae017>] acct_collect+0x4c/0x19c
 [<ffffffff8021497d>] do_exit+0x1f8/0x85e
 [<ffffffff80266420>] do_page_fault+0x75f/0x7ed
 [<ffffffff802642bd>] error_exit+0x0/0x96
 [<ffffffff802d3028>] cache_flusharray+0x3f/0xbc
 [<ffffffff802d2e6d>] free_block+0xb2/0x15f
 [<ffffffff802d306f>] cache_flusharray+0x86/0xbc
 [<ffffffff8020769d>] kmem_cache_free+0x20a/0x241
 [<ffffffff80226d9c>] free_buffer_head+0x24/0x3e
 [<ffffffff80227c07>] try_to_free_buffers+0x8e/0xa5
 [<ffffffff8022d52e>] wake_up_bit+0x1e/0x23
 [<ffffffff8801b6a6>]
:jbd:journal_invalidatepage+0x334/0x37e
 [<ffffffff88032d5f>]
:ext3:ext3_invalidatepage+0x38/0x3a
 [<ffffffff802c16ce>] do_invalidatepage+0x23/0x25
 [<ffffffff8021c802>] truncate_complete_page+0x30/0x4e
 [<ffffffff8022b9de>]
truncate_inode_pages_range+0xb7/0x333
 [<ffffffff880331f0>] :ext3:ext3_delete_inode+0x0/0xda
 [<ffffffff802c19ac>] truncate_inode_pages+0xd/0xf
 [<ffffffff88033208>]
:ext3:ext3_delete_inode+0x18/0xda
 [<ffffffff880331f0>] :ext3:ext3_delete_inode+0x0/0xda
 [<ffffffff8022f544>] generic_delete_inode+0xc8/0x142
 [<ffffffff802397e5>] generic_drop_inode+0x17/0x176
 [<ffffffff8022b0d0>] iput+0x7c/0x80
 [<ffffffff8023c854>] do_unlinkat+0xf7/0x172
 [<ffffffff8026c332>] syscall_trace_enter+0x95/0x99
 [<ffffffff802db61b>] sys_unlinkat+0x24/0x26
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1

BUG: spinlock lockup on CPU#0, cp/4566,
ffff81011fc37f00

Call Trace:
 [<ffffffff802077f4>] _raw_spin_lock+0xd1/0xf9
 [<ffffffff80263a85>] _spin_lock+0x2d/0x31
 [<ffffffff802d3028>] cache_flusharray+0x3f/0xbc
BUG: spinlock lockup on CPU#1, fixdep/4571,
ffff81011fc37f00

Call Trace:
 [<ffffffff802077f4>] _raw_spin_lock+0xd1/0xf9
 [<ffffffff80263a85>] _spin_lock+0x2d/0x31
 [<ffffffff8025a87b>] cache_alloc_refill+0x86/0x1e9
 [<ffffffff8020a83a>] kmem_cache_alloc+0x90/0xd8
 [<ffffffff80223129>] alloc_buffer_head+0x19/0x40
 [<ffffffff8022eaf9>] alloc_page_buffers+0x3c/0xde
 [<ffffffff80222541>] create_empty_buffers+0x1d/0xa6
 [<ffffffff8020e2e8>] __block_prepare_write+0x88/0x4c0
 [<ffffffff88031dd3>] :ext3:ext3_get_block+0x0/0xed
 [<ffffffff8023cd2e>] block_prepare_write+0x22/0x2f
 [<ffffffff88033382>]
:ext3:ext3_prepare_write+0xb8/0x185
 [<ffffffff8020f5cb>]
generic_file_buffered_write+0x2de/0x83e
 [<ffffffff8020e064>] current_fs_time+0x3f/0x41
 [<ffffffff8031abea>] avc_has_perm+0x49/0x5b
 [<ffffffff802158a3>]
__generic_file_aio_write_nolock+0x393/0x406
 [<ffffffff80239daa>]
debug_mutex_free_waiter+0x5b/0x5f
 [<ffffffff802215b5>] generic_file_aio_write+0x64/0xc0
 [<ffffffff8802f292>] :ext3:ext3_file_write+0x1e/0x9e
 [<ffffffff802174c1>] do_sync_write+0xe2/0x126
 [<ffffffff802639db>] _spin_unlock+0x26/0x2a
 [<ffffffff8031bab0>] file_has_perm+0xa7/0xb6
 [<ffffffff8029aeeb>]
autoremove_wake_function+0x0/0x38
 [<ffffffff80215ce8>] vfs_write+0xcf/0x178
 [<ffffffff80216700>] sys_write+0x47/0x70
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1

 [<ffffffff8020769d>] kmem_cache_free+0x20a/0x241
 [<ffffffff80226d9c>] free_buffer_head+0x24/0x3e
 [<ffffffff80227c07>] try_to_free_buffers+0x8e/0xa5
 [<ffffffff8022d52e>] wake_up_bit+0x1e/0x23
 [<ffffffff8801b6a6>]
:jbd:journal_invalidatepage+0x334/0x37e
 [<ffffffff88032d5f>]
:ext3:ext3_invalidatepage+0x38/0x3a
 [<ffffffff802c16ce>] do_invalidatepage+0x23/0x25
 [<ffffffff8021c802>] truncate_complete_page+0x30/0x4e
 [<ffffffff8022b9de>]
truncate_inode_pages_range+0xb7/0x333
 [<ffffffff802c19ac>] truncate_inode_pages+0xd/0xf
 [<ffffffff802c5170>] vmtruncate+0x58/0xd4
 [<ffffffff8024076d>] inode_setattr+0x2b/0x125
 [<ffffffff88033ba7>] :ext3:ext3_setattr+0x1b7/0x220
 [<ffffffff8022cdec>] notify_change+0x160/0x305
 [<ffffffff802d6693>] do_truncate+0x53/0x72
 [<ffffffff8024db5a>] get_write_access+0x40/0x47
 [<ffffffff802117d4>] may_open+0x1ea/0x23f
 [<ffffffff8021a817>] open_namei+0x2ba/0x651
 [<ffffffff8021a3fa>] cp_new_stat+0xf6/0x10f
 [<ffffffff802279fe>] do_filp_open+0x28/0x4b
 [<ffffffff802639db>] _spin_unlock+0x26/0x2a
 [<ffffffff8021521b>] get_unused_fd+0xfb/0x10c
 [<ffffffff8021929c>] do_sys_open+0x4f/0xd0
 [<ffffffff80231761>] sys_open+0x1b/0x1d
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1

It's an AMD AM2, on AMD690G chipset on ASUS M2A-VM
board with 4 GB of RAM & 120 GB Seagate IDE disk.

On up-to-date Fedora 7 Test 4.

More info on request.

Thanks

Send instant messages to your online friends http://au.messenger.yahoo.com 
