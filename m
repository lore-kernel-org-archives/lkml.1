Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXE3Ixw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXE3Ixw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXE3Ixo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:53:44 -0400
Received: from twin.jikos.cz ([213.151.79.26]:49226 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXE3Ixm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:53:42 -0400
Date: Wed, 30 May 2007 10:53:28 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB-related panic
In-Reply-To: <Pine.LNX.4.64.0705291009040.23611@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705301049260.8531@twin.jikos.cz>
References: <Pine.LNX.4.64.0705281858200.8531@twin.jikos.cz>
 <Pine.LNX.4.64.0705291009040.23611@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-734524457-1180515208=:8531"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-734524457-1180515208=:8531
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 29 May 2007, Christoph Lameter wrote:

> > when trying to reproduce a bugreport in bugzilla, I am experiencing=20
> > panics upon boot. The .config which causes this is at [1]
> Please reboot with "slub_debug" to identify what causes this.

Hi Christoph,

with slub_debug, there is no panic (which just supports that there is a=20
race somewhere). The boot with slub_debug below up to the point where it=20
panics without slub_debug

Linux version 2.6.22-rc2-mm1 (root@box) (gcc version 4.1.3 20070302=20
(prerelease) (SUSE Linux)) #85 SMP PREEMPT Wed May 30 01:44:05 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f680000 (usable)
 BIOS-e820: 000000003f680000 - 000000003f692000 (ACPI data)
 BIOS-e820: 000000003f692000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
118MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6010
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   259712
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   259712
DMI present.
ACPI: RSDP 000F5F80, 0014 (r0 PTLTD )
ACPI: RSDT 3F689EF2, 0048 (r1 PTLTD  Capell00  6040000  LTP        0)
ACPI: FACP 3F691E25, 0074 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 3F68B5C6, 685F (r1 INTEL  CALISTGA  6040000 INTL 20050624)
ACPI: FACS 3F692FC0, 0040
ACPI: APIC 3F691E99, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 3F691F01, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 3F691F39, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: BOOT 3F691F75, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: ASF! 3F691F9D, 0063 (r32   CETP     CETP  6040000 PTL         1)
ACPI: SSDT 3F68AF77, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT 3F68A8DB, 069C (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT 3F689F3A, 0508 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:=20
256162
Kernel command line: root=3D/dev/sda6 vga=3Dnormal resume=3D/dev/sda1 showo=
pts=20
console=3Dtty0 console=3DttyS0,9600n8 slub_debug
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1833.519 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
=2E.. MAX_LOCKDEP_SUBCLASSES:    8
=2E.. MAX_LOCK_DEPTH:          30
=2E.. MAX_LOCKDEP_KEYS:        2048
=2E.. CLASSHASH_SIZE:           1024
=2E.. MAX_LOCKDEP_ENTRIES:     8192
=2E.. MAX_LOCKDEP_CHAINS:      16384
=2E.. CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1200 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1012416k/1038848k available (1975k kernel code, 25728k reserved,=20
1495k data, 244k init, 121344k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0569000 - 0xc05a6000   ( 244 kB)
      .data : 0xc03edd37 - 0xc0563b94   (1495 kB)
      .text : 0xc0200000 - 0xc03edd37   (1975 kB)
Checking if this processor honours the WP bit even in supervisor mode...=20
Ok.
SLUB: Genslabs=3D23, HWalign=3D64, Order=3D0-3, MinObjects=3D16, Processors=
=3D2,=20
Nodes=3D1
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3671.10 BogoMIPS=20
(lpj=3D1835552)
kswapd reclaim order set to 3
Security Framework v1.0.0 initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) M CPU        000  @ 1.83GHz stepping 04
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3619.50 BogoMIPS=20
(lpj=3D1809754)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Pentium(R) M CPU        000  @ 1.83GHz stepping 04
Total of 2 processors activated (7290.61 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
*** SLUB kmalloc-8: Redzone Active@0xc20b6070 slab 0xc10727d0
    offset=3D112 flags=3D0x10000c3 inuse=3D3 freelist=3D0xc20b60a8
  Bytes b4 0xc20b6060:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a=20
=2E.......ZZZZZZZZ
    Object 0xc20b6070:  30 39 2f 30 38 2f 30 35                        =20
09/08/05
   Redzone 0xc20b6078:  00 cc cc cc                                    =20
=2E=FE=FE=FE
FreePointer 0xc20b607c -> 0xc20b60a8
Last alloc: get_modalias+0x61/0x102 jiffies_ago=3D0 cpu=3D0 pid=3D1
    Filler 0xc20b60a0:  5a 5a 5a 5a 5a 5a 5a 5a                        =20
ZZZZZZZZ
 [<c02035ff>] dump_trace+0x68/0x1d9
 [<c0203788>] show_trace_log_lvl+0x18/0x2c
 [<c0204237>] show_trace+0xf/0x11
 [<c020424b>] dump_stack+0x12/0x14
 [<c026296d>] check_object+0x64/0x238
 [<c026305d>] __slab_free+0x19e/0x2bb
 [<c02637f7>] kfree+0x7e/0x87
 [<c03798a2>] get_modalias+0xc2/0x102
 [<c0379924>] dmi_dev_uevent+0x27/0x3b
 [<c0342f71>] dev_uevent+0x1b7/0x1e3
 [<c02de4cf>] kobject_uevent_env+0x221/0x42c
 [<c0342bae>] device_add+0x271/0x46d
 [<c0587a5a>] dmi_id_init+0x253/0x268
 [<c0569793>] kernel_init+0x147/0x2af
 [<c020321b>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc20b6078-0xc20b607b
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
ACPI: Power Resource [FN00] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=
=20
report
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
pnp: 00:07: ioport range 0x6a0-0x6af has been reserved
pnp: 00:07: ioport range 0x6b0-0x6ff has been reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: d0000000-d01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4230k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1180514947.216:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
ACPI: SSDT 3F68A625, 01FA (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3F68A442, 015E (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3F68A81F, 00BC (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3F68A5A0, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
Time: hpet clocksource has been installed.
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
ACPI: PCI Interrupt 0000:02:00.3[C] -> GSI 18 (level, low) -> IRQ 17
0000:02:00.3: ttyS1 at I/O 0x2048 (irq =3D 17) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
Freeing unused kernel memory: 244k freed
Write protecting the kernel text: 1976k
Write protecting the kernel read-only data: 1292k
input: AT Translated Set 2 keyboard as /class/input/input0
Boot logging started on /dev/ttyS0(/dev/console) at Wed May 30 08:49:20=20
2007
Trying manual resume from /dev/sda1
Creating d*** SLUB kmalloc-8: Redzone Active@0xc2266e70 slab 0xc1078650
evice nodes with    offset=3D3696 flags=3D0x10000c3 inuse=3D67=20
freelist=3D0xc2266ea8
 udev
  Bytes b4 0xc2266e60:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a=20
=2E.......ZZZZZZZZ
    Object 0xc2266e70:  30 39 2f 30 38 2f 30 35                        =20
09/08/05
   Redzone 0xc2266e78:  00 cc cc cc                                    =20
=2E=FE=FE=FE
FreePointer 0xc2266e7c -> 0xc2266ea8
Last alloc: get_modalias+0x61/0x102 jiffies_ago=3D495 cpu=3D1 pid=3D500
    Filler 0xc2266ea0:  5a 5a 5a 5a 5a 5a 5a 5a                        =20
ZZZZZZZZ
 [<c02035ff>] dump_trace+0x68/0x1d9
 [<c0203788>] show_trace_log_lvl+0x18/0x2c
 [<c0204237>] show_trace+0xf/0x11
 [<c020424b>] dump_stack+0x12/0x14
 [<c026296d>] check_object+0x64/0x238
 [<c026305d>] __slab_free+0x19e/0x2bb
 [<c02637f7>] kfree+0x7e/0x87
 [<c03798a2>] get_modalias+0xc2/0x102
 [<c0379924>] dmi_dev_uevent+0x27/0x3b
 [<c0342f71>] dev_uevent+0x1b7/0x1e3
 [<c02de4cf>] kobject_uevent_env+0x221/0x42c
 [<c0342345>] store_uevent+0x4c/0x55
 [<c0341f33>] dev_attr_store+0x27/0x2c
 [<c02a2e3b>] sysfs_write_file+0x118/0x144
 [<c0267842>] vfs_write+0xa8/0x154
 [<c0267e5b>] sys_write+0x41/0x67
 [<c02025fa>] sysenter_past_esp+0x5f/0x85
 [<ffffe410>] 0xffffe410
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc2266e78-0xc2266e7b
ACPI: Thermal Zone [TZ00] (37 C)

ACPI: Thermal Zone [TZ01] (37 C)
Loading fan
ACPI: Transitioning device [FAN0] to D3
ACPI: Transitioning device [FAN0] to D3
ACPI: Fan [FAN0] (off)
Loading edd
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Loading jbd
Loading ext3
=2E..

--=20
Jiri Kosina
---1747641777-734524457-1180515208=:8531--
