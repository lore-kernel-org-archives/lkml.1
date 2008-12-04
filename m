Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbYLDO0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbYLDO0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYLDO0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:26:12 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:31825 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbYLDO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:26:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AggBANR2N0nDDR8P/2dsb2JhbAAI0EODAg
Message-ID: <4937E87C.6030106@belbone.be>
Date: Thu, 04 Dec 2008 15:26:04 +0100
From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Xorg crash at first start
Content-Type: multipart/mixed;
 boundary="------------070401050605040404020408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070401050605040404020408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

With the v2.6.28-rc7-105-gfeaf384 kernel, when booting my compaq with
attached config, the screen switches in graphical mode but then switches
back in textual mode with an 'irq10 nobody cared' error in dmesg (attached).

If I restart kdm by hand, all is ok (i have my kdm) but the error yet
appears in dmesg (at each X start in fact).

I bisected the problem (git bisect log attached) and found the following
commit as "culprit" :

commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Nov 18 09:30:25 2008 -0800

    drm: move drm vblank initialization/cleanup to driver load/unload

    drm vblank initialization keeps track of the changes in driver-supplied
    frame counts across vt switch and mode setting, but only if you let
it by
    not tearing down the drm vblank structure.

    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Reverting it brings back my X screen at first start.

If you need more infos, ask.

Cedric


--------------070401050605040404020408
Content-Type: text/plain;
 name="no-xorg-bisect-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no-xorg-bisect-log.txt"

git bisect start
# bad: [feaf3848a813a106f163013af6fcf6c4bfec92d9] Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
git bisect bad feaf3848a813a106f163013af6fcf6c4bfec92d9
# good: [ed313489badef16d700f5a3be50e8fd8f8294bc8] Merge master.kernel.org:/home/rmk/linux-2.6-arm
git bisect good ed313489badef16d700f5a3be50e8fd8f8294bc8
# bad: [b4dcfbee3b536c9125762e8f6681ac6be0e9256b] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect bad b4dcfbee3b536c9125762e8f6681ac6be0e9256b
# good: [9297524f6a2885bfb4e2431d658cd1ffaefbda41] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6
git bisect good 9297524f6a2885bfb4e2431d658cd1ffaefbda41
# bad: [a6e470fd1bbfea8e51d2b10b0713e802b782f19a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6
git bisect bad a6e470fd1bbfea8e51d2b10b0713e802b782f19a
# bad: [66a45cc4cc1c1f7d1ccae4d0fee261eab5560682] Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 66a45cc4cc1c1f7d1ccae4d0fee261eab5560682
# good: [c4858ffc8f2dc850cb1f609c679b1ac1ad36ef0c] x86, pebs: fix PEBS record size configuration
git bisect good c4858ffc8f2dc850cb1f609c679b1ac1ad36ef0c
# good: [6133047aa64d2fd5b3b79dff74f696ded45615b2] drm/i915: execbuffer pins objects, no need to ensure they're still in the GTT
git bisect good 6133047aa64d2fd5b3b79dff74f696ded45615b2
# good: [b627c8b17ccacba38c975bc0f69a49fc4e5261c9] x86: always define DECLARE_PCI_UNMAP* macros
git bisect good b627c8b17ccacba38c975bc0f69a49fc4e5261c9
# bad: [461cba2d294fe83297edf8a6556912812903dce1] drm/i915: Save/restore HWS_PGA on suspend/resume
git bisect bad 461cba2d294fe83297edf8a6556912812903dce1
# bad: [52440211dcdc52c0b757f8b34d122e11b12cdd50] drm: move drm vblank initialization/cleanup to driver load/unload
git bisect bad 52440211dcdc52c0b757f8b34d122e11b12cdd50

--------------070401050605040404020408
Content-Type: text/plain;
 name="no-xorg-cuplrit.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no-xorg-cuplrit.txt"

commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Nov 18 09:30:25 2008 -0800

    drm: move drm vblank initialization/cleanup to driver load/unload
    
    drm vblank initialization keeps track of the changes in driver-supplied
    frame counts across vt switch and mode setting, but only if you let it by
    not tearing down the drm vblank structure.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

--------------070401050605040404020408
Content-Type: text/plain;
 name="no-xorg-dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no-xorg-dmesg.txt"

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc7-00105-gfeaf384 (cedric@enea) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #1 Thu Dec 4 11:14:29 CET 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffd0000 (usable)
 BIOS-e820: 000000001ffd0000 - 000000001fff0c00 (reserved)
 BIOS-e820: 000000001fff0c00 - 000000001fffc000 (ACPI NVS)
 BIOS-e820: 000000001fffc000 - 0000000020000000 (reserved)
DMI 2.3 present.
last_pfn = 0x1ffd0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 1ffd0000 @ 7000-d000
RAMDISK: 1ff53000 - 1ffbf19e
ACPI: RSDP 000F6F90, 0014 (r0 COMPAQ)
ACPI: RSDT 1FFF0C84, 002C (r1 HP     HP0890   22040420 CPQ         1)
ACPI: FACP 1FFF0C00, 0084 (r2 HP     HP0890          2 CPQ         1)
ACPI: DSDT 1FFF0CB0, 62D9 (r1 HP       nc6000    10000 MSFT  100000E)
ACPI: FACS 1FFFBE80, 0040
ACPI: SSDT 1FFF6F89, 028A (r1 COMPAQ  CPQGysr     1001 MSFT  100000E)
511MB LOWMEM available.
  mapped low ram: 0 - 1ffd0000
  low ram: 00000000 - 1ffd0000
  bootmap 00001000 - 00004ffc
(7 early reservations) ==> bootmem [0000000000 - 001ffd0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00004436e4]    TEXT DATA BSS ==> [0000100000 - 00004436e4]
  #2 [001ff53000 - 001ffbf19e]          RAMDISK ==> [001ff53000 - 001ffbf19e]
  #3 [0000444000 - 0000447000]    INIT_PG_TABLE ==> [0000444000 - 0000447000]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #6 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001ffd0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001ffd0
On node 0 totalpages: 130927
free_area_init_node: node 0, pgdat c03b2c40, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 125936 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129903
Kernel command line: root=/dev/sda1 resume=/dev/sda5 vga=0x316 video=vesafb:ywrap,mtrr,1024x768-16@60 splash=silent,theme:livecd-2007.0 CONSOLE=/dev/tty1 acpi_sleep=s3_bios lapic hpet=force
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 1594.815 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515140k/524096k available (1965k kernel code, 8316k reserved, 838k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    vmalloc : 0xe07d0000 - 0xfffaa000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffd0000   ( 511 MB)
      .init : 0xc03c0000 - 0xc0403000   ( 268 kB)
      .data : 0xc02eb5fc - 0xc03bd040   ( 838 kB)
      .text : 0xc0100000 - 0xc02eb5fc   (1965 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 3189.63 BogoMIPS (lpj=1594815)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080926
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 532 bytes
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf031f, last bus=5
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [C045] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xb0000000-0xbfffffff]
pci 0000:00:1d.0: reg 20 io port: [0x38c0-0x38df]
pci 0000:00:1d.1: reg 20 io port: [0x38e0-0x38ff]
pci 0000:00:1d.2: reg 20 io port: [0x3c00-0x3c1f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xa0000000-0xa00003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: Enabled i801 SMBus device
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x3c20-0x3c2f]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.3: reg 20 io port: [0x1200-0x121f]
pci 0000:00:1f.5: reg 10 io port: [0x3000-0x30ff]
pci 0000:00:1f.5: reg 14 io port: [0x3880-0x38bf]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xa0100000-0xa01001ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xa0180000-0xa01800ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0x3400-0x34ff]
pci 0000:00:1f.6: reg 14 io port: [0x3800-0x387f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0x98000000-0x9fffffff]
pci 0000:01:00.0: reg 14 io port: [0x2000-0x20ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0x90300000-0x9030ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:01.0: bridge 32bit mmio: [0x90300000-0x903fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0x98000000-0x9fffffff]
pci 0000:02:04.0: reg 10 32bit mmio: [0x90080000-0x9008ffff]
pci 0000:02:06.0: reg 10 32bit mmio: [0x90100000-0x90100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: reg 10 32bit mmio: [0x90180000-0x90180fff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: reg 10 32bit mmio: [0x90200000-0x90200fff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: reg 10 32bit mmio: [0x90280000-0x90280fff]
pci 0000:02:06.3: supports D1 D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.3: PME# disabled
pci 0000:02:0e.0: reg 10 64bit mmio: [0x90000000-0x9000ffff]
pci 0000:02:0e.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:02:0e.0: PME# supported from D3hot D3cold
pci 0000:02:0e.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x902fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C045._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C045.C046._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C045.C057._PRT]
ACPI: PCI Interrupt Link [C0C2] (IRQs *10 11)
ACPI: PCI Interrupt Link [C0C3] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C0C4] (IRQs *10 11)
ACPI: PCI Interrupt Link [C0C5] (IRQs *10 11)
ACPI: PCI Interrupt Link [C0C6] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C0C7] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C0C8] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C0C9] (IRQs *10 11)
ACPI: Power Resource [C16E] (on)
ACPI: Power Resource [C185] (on)
ACPI: Power Resource [C18C] (on)
ACPI: Power Resource [C196] (on)
ACPI: Power Resource [C0E7] (on)
ACPI: Power Resource [C202] (off)
ACPI: Power Resource [C203] (off)
ACPI: Power Resource [C204] (off)
ACPI: Power Resource [C205] (off)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
system 00:0b: ioport range 0x140-0x14f has been reserved
system 00:0b: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
system 00:0d: iomem range 0xfec01000-0xfec01fff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x2000-0x2fff
pci 0000:00:01.0:   MEM window: 0x90300000-0x903fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000098000000-0x0000009fffffff
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x004000-0x0040ff
pci 0000:02:06.0:   IO window: 0x004400-0x0044ff
pci 0000:02:06.0:   PREFETCH window: 0x30000000-0x33ffffff
pci 0000:02:06.0:   MEM window: 0x40000000-0x43ffffff
pci 0000:02:06.1: CardBus bridge, secondary bus 0000:05
pci 0000:02:06.1:   IO window: 0x004800-0x0048ff
pci 0000:02:06.1:   IO window: 0x004c00-0x004cff
pci 0000:02:06.1:   PREFETCH window: 0x34000000-0x37ffffff
pci 0000:02:06.1:   MEM window: 0x44000000-0x47ffffff
pci 0000:02:06.3: CardBus bridge, secondary bus 0000:09
pci 0000:02:06.3:   IO window: 0x001400-0x0014ff
pci 0000:02:06.3:   IO window: 0x001800-0x0018ff
pci 0000:02:06.3:   PREFETCH window: 0x38000000-0x3bffffff
pci 0000:02:06.3:   MEM window: 0x48000000-0x4bffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
pci 0000:00:1e.0:   MEM window: 0x90000000-0x902fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000030000000-0x0000003dffffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [C0C4] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:02:06.0: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
pci 0000:02:06.1: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
pci 0000:02:06.3: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0x2000-0x2fff]
bus: 01 index 1 mmio: [0x90300000-0x903fffff]
bus: 01 index 2 mmio: [0x98000000-0x9fffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0x4000-0x4fff]
bus: 02 index 1 mmio: [0x90000000-0x902fffff]
bus: 02 index 2 mmio: [0x30000000-0x3dffffff]
bus: 02 index 3 io port: [0x00-0xffff]
bus: 02 index 4 mmio: [0x000000-0xffffffff]
bus: 03 index 0 io port: [0x4000-0x40ff]
bus: 03 index 1 io port: [0x4400-0x44ff]
bus: 03 index 2 mmio: [0x30000000-0x33ffffff]
bus: 03 index 3 mmio: [0x40000000-0x43ffffff]
bus: 05 index 0 io port: [0x4800-0x48ff]
bus: 05 index 1 io port: [0x4c00-0x4cff]
bus: 05 index 2 mmio: [0x34000000-0x37ffffff]
bus: 05 index 3 mmio: [0x44000000-0x47ffffff]
bus: 09 index 0 io port: [0x1400-0x14ff]
bus: 09 index 1 io port: [0x1800-0x18ff]
bus: 09 index 2 mmio: [0x38000000-0x3bffffff]
bus: 09 index 3 mmio: [0x48000000-0x4bffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 432k freed
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
msgmni has been set to 1007
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
vesafb: framebuffer at 0x98000000, mapped to 0xe0800000, using 3072k, total 32704k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: protected mode interface info at c000:59e9
vesafb: pmi: set display start = c00c5a57, set palette = c00c5a91
vesafb: pmi: ports = 2010 2016 2054 2038 203c 205c 2000 2004 20b0 20b2 20b4 
vesafb: scrolling: ywrap using protected mode interface, yres_virtual=1536
vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [C13A]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [C139]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [C206] (off)
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [C207] (off)
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [C208] (off)
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [C209] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device4
ACPI: Processor [CPU0] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ1] (60 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ2] (51 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [TZ3] (34 C)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 855PM Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt Link [C0C3] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
serial 0000:00:1f.6: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
serial 0000:00:1f.6: PCI INT B disabled
brd: module loaded
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x3c20 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x3c28 irq 15
ata1.00: ATA-6: FUJITSU MHT2040AH, 006C, max UDMA/100
ata1.00: 78140160 sectors, multi 16: LBA 
ata1.00: configured for UDMA/100
Switched to high resolution mode on CPU 0
ata2.00: ATAPI: SD-R2512, 1A04, max MWDMA2
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2040A 006C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors: (40.0 GB/37.2 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors: (40.0 GB/37.2 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-R2512 1A04 PQ: 0 ANSI: 5
PNP: PS/2 Controller [PNP0303:C193,PNP0f13:C194] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
IO APIC resources could be not be allocated.
Using IPI Shortcut mode
Marking TSC unstable due to TSC halts in idle
input: AT Translated Set 2 keyboard as /class/input/input3
Clocksource tsc unstable (delta = -289997832 ns)
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x1b6eb1, caps: 0xa84793/0x100000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 268k freed
Write protecting the kernel text: 1968k
Write protecting the kernel read-only data: 660k
ACPI: AC Adapter [C135] (on-line)
ACPI: Battery Slot [C138] (battery present)
ACPI: Battery Slot [C137] (battery absent)
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
i801_smbus 0000:00:1f.3: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
ACPI: I/O resource 0000:00:1f.3 [0x1200-0x121f] conflicts with ACPI region C088 [0x1200-0x1205]
ACPI: Device needs an ACPI driver
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:0890]
yenta_cardbus 0000:02:06.0: O2: res at 0x94/0xD4: ea/00
yenta_cardbus 0000:02:06.0: O2: enabling read prefetch/write burst
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x00b8, PCI irq 10
yenta_cardbus 0000:02:06.0: Socket status: 30000006
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3dffffff
tg3.c:v3.94 (August 14, 2008)
ACPI: PCI Interrupt Link [C0C6] enabled at IRQ 11
tg3 0000:02:0e.0: PCI INT A -> Link[C0C6] -> GSI 11 (level, low) -> IRQ 11
eth0: Tigon3 [partno(BMC5705mA3) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:12:79:56:f0:f2
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:0890]
yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x00b8, PCI irq 10
yenta_cardbus 0000:02:06.1: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #05 to #08
yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3dffffff
yenta_cardbus 0000:02:06.3: CardBus bridge found [103c:0890]
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [C0C9] enabled at IRQ 10
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[C0C9] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xa0000000
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt Link [C0C2] enabled at IRQ 10
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[C0C2] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 10, io base 0x000038c0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [C0C5] enabled at IRQ 10
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[C0C5] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 10, io base 0x000038e0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 10, io base 0x00003c00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
yenta_cardbus 0000:02:06.3: ISA IRQ mask 0x00b8, PCI irq 10
yenta_cardbus 0000:02:06.3: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #08 to #0c
yenta_cardbus 0000:02:06.3: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
yenta_cardbus 0000:02:06.3: pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
yenta_cardbus 0000:02:06.3: pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x3dffffff
usb 2-2: new low speed USB device using uhci_hcd and address 2
Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
Intel ICH 0000:00:1f.5: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
Intel ICH 0000:00:1f.5: setting latency timer to 64
usb 2-2: configuration #1 chosen from 1 choice
input: Logitech Optical USB Mouse as /class/input/input5
generic-usb 0003:046D:C016.0001: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50921 usecs
intel8x0: measured clock 216 rejected
intel8x0: clocking to 48000
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
microcode: CPU0 updated from revision 0x17 to 0x18, date = 2004-10-17 
ADDRCONF(NETDEV_UP): eth0: link is not ready
Adding 982760k swap on /dev/sda5.  Priority:-1 extents:1 across:982760k
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
pci 0000:01:00.0: PCI INT A -> Link[C0C2] -> GSI 10 (level, low) -> IRQ 10
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.29.0 20080528 on minor 0
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:00.0: putting AGP V2 device into 4x mode
irq 10: nobody cared (try booting with the "irqpoll" option)
Pid: 2565, comm: X Not tainted 2.6.28-rc7-00105-gfeaf384 #1
Call Trace:
 [<c013e2ca>] __report_bad_irq+0x24/0x7f
 [<c013e456>] note_interrupt+0x131/0x16b
 [<c013d5fc>] handle_IRQ_event+0x25/0x4a
 [<c013eb3c>] handle_level_irq+0x58/0x8e
 [<c0104e33>] do_IRQ+0x6f/0x8c
 [<c010e899>] smp_apic_timer_interrupt+0x41/0x71
 [<c01039d7>] common_interrupt+0x23/0x28
 [<c011f09e>] __do_softirq+0x2d/0xe7
 [<c013d5fc>] handle_IRQ_event+0x25/0x4a
 [<c011f17f>] do_softirq+0x27/0x2a
 [<c011f3bc>] irq_exit+0x44/0x55
 [<c0104e38>] do_IRQ+0x74/0x8c
 [<c02e99f2>] __wait_on_bit_lock+0x54/0x5e
 [<c01407c6>] sync_page+0x0/0x39
 [<c01039d7>] common_interrupt+0x23/0x28
 [<c014007b>] generic_file_mmap+0x2a/0x3e
 [<e0c9007b>] radeon_cp_init+0xa92/0xd44 [radeon]
 [<e0c7a3dc>] drm_vblank_get+0x32/0x14a [drm]
 [<c0141b1c>] filemap_fault+0x1d7/0x3cd
 [<e0c7a93e>] drm_modeset_ctl+0x89/0x8d [drm]
 [<e0c7a8b5>] drm_modeset_ctl+0x0/0x8d [drm]
 [<e0c79067>] drm_ioctl+0x197/0x2c0 [drm]
 [<e0c78ed0>] drm_ioctl+0x0/0x2c0 [drm]
 [<c0169df1>] vfs_ioctl+0x51/0x55
 [<c016a187>] do_vfs_ioctl+0x270/0x42e
 [<c011215d>] do_page_fault+0x145/0x675
 [<c0160b44>] vfs_write+0xe5/0x118
 [<c016a379>] sys_ioctl+0x34/0x50
 [<c0102e89>] sysenter_do_call+0x12/0x25
 [<c02e0000>] __inet6_lookup_established+0x19d/0x25e
handlers:
[<e0bcf93e>] (yenta_interrupt+0x0/0xb4 [yenta_socket])
[<e0bcf93e>] (yenta_interrupt+0x0/0xb4 [yenta_socket])
[<e0bcf93e>] (yenta_interrupt+0x0/0xb4 [yenta_socket])
[<e0b4bcff>] (usb_hcd_irq+0x0/0x61 [usbcore])
[<e0b4bcff>] (usb_hcd_irq+0x0/0x61 [usbcore])
[<e0b4bcff>] (usb_hcd_irq+0x0/0x61 [usbcore])
[<e0b4bcff>] (usb_hcd_irq+0x0/0x61 [usbcore])
Disabling IRQ #10
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
eth0: no IPv6 routers present
[drm] Num pipes: 1
mtrr: no MTRR for 98000000,2000000 found

--------------070401050605040404020408--
