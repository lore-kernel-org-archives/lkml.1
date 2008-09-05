Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYIEWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYIEWva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYIEWvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:51:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:40974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYIEWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=M4GECtSU+9TTQ1mfRExMiLnbodSNkEOhkigRPwngBFUxIGpAgka18RqCzIpjfzZ1by
         YU7lbMLXECQaZORVs5b5woM1r4qxRqYU/qryAPq08NkX6d7iCF0gEFkLItFx0KvFbl/0
         J+vNeW4vo9lc1cX3Rfu3sCHYlpbGn2p7CpM0g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for September 5
Date: Sat, 6 Sep 2008 00:47:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andi Kleen <ak@linux.intel.com>
References: <20080905190941.0f86ebac.sfr@canb.auug.org.au>
In-Reply-To: <20080905190941.0f86ebac.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809060047.18770.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 05 September 2008, Stephen Rothwell wrote:
> Hi all,
> 
> There will be no linux-next tree until at least September 9 (US Central
> time) as I will be travelling.
> 
> Changes since next-20080904:

The following commit:

commit 50c0f43ff1199bbea5f0418d40df32f4d4029b13
Author: Andi Kleen <ak@linux.intel.com>
Date:   Thu Sep 4 15:13:29 2008 +0200

    ACPI: EC: do transaction from interrupt context

    From: Alexey Starikovskiy <astarikovskiy@suse.de>

    It is easier and faster to do transaction directly from interrupt context
    rather than waking control thread.
    Also, cleaner GPE storm avoidance is implemented.

    AK: Merged with earlier io port patch

    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

makes my laptop *power-off* on haldaemon startup (Fedora 9 here).

dmesg with the commit reverted:

Linux version 2.6.27-rc5-next-20080905-04648-ge9f2a9c (bzolnier@localhost.localdomain) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #223 PREEMPT Sat Sep 6 00:19:40 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fffffc0 (ACPI data)
 BIOS-e820: 000000001fffffc0 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
last_pfn = 0x1fff0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 1fff0000 @ 7000-d000
DMI 2.3 present.
ACPI: RSDP 000E6010, 0014 (r0 OID_00)
ACPI: RSDT 1FFFA7F0, 0034 (r1 INSYDE RSDT_000        1 _CSI    10101)
ACPI: FACP 1FFFFB00, 0074 (r1 ACER   DCL56         200 _CSI    10101)
ACPI: DSDT 1FFFAC70, 4E8A (r1 ACER     TM_290        6 MSFT  100000E)
ACPI: FACS 1FFFFFC0, 0040
ACPI: BOOT 1FFFFB90, 0028 (r1 INSYDE SYS_BOOT      100 _CSI    10101)
ACPI: DBGP 1FFFFBC0, 0034 (r1 INSYDE DBGP_000      100 _CSI    10101)
ACPI: SSDT 1FFFA830, 0192 (r1 INSYDE   GV3Ref     2000 INTL 20021002)
ACPI: DMI detected: Acer
511MB LOWMEM available.
  mapped low ram: 0 - 1fff0000
  low ram: 00000000 - 1fff0000
  bootmap 00001000 - 00005000
(6 early reservations) ==> bootmem [0000000000 - 001fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000045dc5c]    TEXT DATA BSS ==> [0000100000 - 000045dc5c]
  #2 [000045e000 - 0000461000]    INIT_PG_TABLE ==> [000045e000 - 0000461000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #5 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001fff0
On node 0 totalpages: 130959
free_area_init_node: node 0, pgdat c03cdbd8, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 125968 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
Local APIC disabled by BIOS -- reenabling.
Found and enabled local APIC!
Allocating PCI resources starting at 30000000 (gap: 20000000:dfb80000)
dyn_array 0xc041a240 size:0xc nr:256 align:0x1000
dyn_array 0xc041a10c size:0x1c nr:32 align:0x1000
dyn_array 0xc044d9b0 size:0x48 nr:32 align:0x1000
dyn_array total_size: 0x3000
dyn_array 0xc041a240  ==> [0x1402000 - 0x1402c00]
dyn_array 0xc041a10c  ==> [0x1403000 - 0x1403380]
dyn_array 0xc044d9b0  ==> [0x1404000 - 0x1404900]
kstat_irqs ==> [0x1405000 - 0x1405080]
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129935
Kernel command line: ro vga=0x318 lapic pci=assign-busses
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
found new irq_desc for irq 0
found new irq_desc for irq 1
found new irq_desc for irq 2
found new irq_desc for irq 3
found new irq_desc for irq 4
found new irq_desc for irq 5
found new irq_desc for irq 6
found new irq_desc for irq 7
found new irq_desc for irq 8
found new irq_desc for irq 9
found new irq_desc for irq 10
found new irq_desc for irq 11
found new irq_desc for irq 12
found new irq_desc for irq 13
found new irq_desc for irq 14
found new irq_desc for irq 15
CPU 0 irqstacks, hard=c040e000 soft=c040d000
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1495.140 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 515676k/524224k available (2047k kernel code, 8000k reserved, 852k data, 208k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xe07f0000 - 0xfffb7000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc03d6000 - 0xc040a000   ( 208 kB)
      .data : 0xc02ffd05 - 0xc03d4de0   ( 852 kB)
      .text : 0xc0100000 - 0xc02ffd05   (2047 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer frequency.. 2990.28 BogoMIPS (lpj=5980560)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) M processor 1.50GHz stepping 06
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080729
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 612 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xe97a4, last bus=2
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x27/0x2f()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5-next-20080905-04648-ge9f2a9c #223
 [<c011c5a1>] warn_slowpath+0x5a/0x7b
 [<c011663b>] update_curr+0x3d/0x5d
 [<c011723d>] __dequeue_entity+0x1f/0x71
 [<c01d0ba8>] idr_get_empty_slot+0x154/0x202
 [<c01d0d35>] ida_get_new_above+0xdf/0x17b
 [<c01912d8>] sysfs_ilookup_test+0x0/0xd
 [<c016cee9>] ifind+0x15/0x8a
 [<c01914d3>] sysfs_find_dirent+0x13/0x23
 [<c019164c>] sysfs_add_one+0x27/0x2f
 [<c0191ae8>] create_dir+0x3c/0x6b
 [<c0191b40>] sysfs_create_dir+0x29/0x3b
 [<c01d145a>] kobject_get+0xf/0x13
 [<c01d1578>] kobject_add_internal+0xb8/0x151
 [<c01d18ac>] kobject_init_and_add+0x23/0x25
 [<c03e1e76>] kernel_param_sysfs_setup+0x4f/0x9f
 [<c03e1fb5>] param_sysfs_init+0xef/0x141
 [<c0101122>] _stext+0x3a/0x12a
 [<c03e1ec6>] param_sysfs_init+0x0/0x141
 [<c0117500>] __enqueue_entity+0xa8/0xe2
 [<c0128dd3>] __create_workqueue_key+0x14d/0x162
 [<c03d64ba>] kernel_init+0xec/0x150
 [<c03d63ce>] kernel_init+0x0/0x150
 [<c0103a47>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-next-20080905-04648-ge9f2a9c #223
 [<c01d1601>] kobject_add_internal+0x141/0x151
 [<c01d18ac>] kobject_init_and_add+0x23/0x25
 [<c03e1e76>] kernel_param_sysfs_setup+0x4f/0x9f
 [<c03e1fb5>] param_sysfs_init+0xef/0x141
 [<c0101122>] _stext+0x3a/0x12a
 [<c03e1ec6>] param_sysfs_init+0x0/0x141
 [<c0117500>] __enqueue_entity+0xa8/0xe2
 [<c0128dd3>] __create_workqueue_key+0x14d/0x162
 [<c03d64ba>] kernel_init+0xec/0x150
 [<c03d63ce>] kernel_init+0x0/0x150
 [<c0103a47>] kernel_thread_helper+0x7/0x10
 =======================
Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1300-133f claimed by ICH4 GPIO
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:00.0: supports D1 D2
PCI: bridge 0000:00:01.0 io port: [c000, dfff]
PCI: bridge 0000:00:01.0 32bit mmio: [e0000000, efffffff]
PCI: bridge 0000:00:01.0 32bit mmio pref: [a0000000, afffffff]
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:01.0: supports D1 D2
pci 0000:02:01.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:03.0: supports D1 D2
pci 0000:02:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [a000, bfff]
PCI: bridge 0000:00:1e.0 32bit mmio: [d0000000, dfffffff]
PCI: bridge 0000:00:1e.0 32bit mmio pref: [90000000, 9fffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 10) *11
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 10) *11
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:02:03.0: BAR 0: can't allocate resource
system 00:01: ioport range 0x1000-0x107f has been reserved
system 00:01: ioport range 0x1300-0x133f has been reserved
system 00:01: ioport range 0x200-0x20f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0xfe00-0xfe00 has been reserved
system 00:01: ioport range 0xff2c-0xff2f has been reserved
system 00:01: iomem range 0xfff80000-0xffffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xc000-0xdfff
pci 0000:00:01.0:   MEM window: 0xe0000000-0xefffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000a0000000-0x000000afffffff
pci 0000:02:03.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:03.0:   IO window: 0x00a400-0x00a4ff
pci 0000:02:03.0:   IO window: 0x00a800-0x00a8ff
pci 0000:02:03.0:   PREFETCH window: 0x90000000-0x93ffffff
pci 0000:02:03.0:   MEM window: 0xd4000000-0xd7ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0xa000-0xbfff
pci 0000:00:1e.0:   MEM window: 0xd0000000-0xdfffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000090000000-0x0000009fffffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:02:03.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [c000, dfff]
bus: 01 index 1 mmio: [e0000000, efffffff]
bus: 01 index 2 mmio: [a0000000, afffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [a000, bfff]
bus: 02 index 1 mmio: [d0000000, dfffffff]
bus: 02 index 2 mmio: [90000000, 9fffffff]
bus: 02 index 3 io port: [0, ffff]
bus: 02 index 4 mmio: [0, ffffffff]
bus: 03 index 0 io port: [a400, a4ff]
bus: 03 index 1 io port: [a800, a8ff]
bus: 03 index 2 mmio: [90000000, 93ffffff]
bus: 03 index 3 mmio: [d4000000, d7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
ACPI Error (evxfevnt-0186): Could not enable SleepButton event [20080729]
ACPI Warning (evxface-0145): Could not enable fixed event 3 [20080729]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
Simple Boot Flag at 0x37 set to 0x1
Machine check exception polling timer started.
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
audit: initializing netlink socket (disabled)
type=2000 audit(1220653912.172:1): initialized
HugeTLB registered 4 MB page size, pre-allocated 0 pages
fuse init (API version 7.9)
msgmni has been set to 1007
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
vesafb: framebuffer at 0xa8000000, mapped to 0xe0880000, using 4608k, total 65536k
vesafb: mode is 1024x768x24, linelength=3072, pages=27
vesafb: protected mode interface info at c000:5673
vesafb: pmi: set display start = c00c56e1, set palette = c00c571b
vesafb: pmi: ports = c010 c016 c054 c038 c03c c05c c000 c004 c0b0 c0b2 c0b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ACAD] (off-line)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 855PM Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xb0000000
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Switched to NOHz mode on CPU #0
serial8250: ttyS1 at I/O 0x2f8 (irq = 0) is a 16550A
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
serial 0000:00:1f.6: PCI INT B disabled
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
8139too 0000:02:01.0: PCI INT A -> Link[LNKD] -> GSI 10 (level, low) -> IRQ 10
eth0: RealTek RTL8139 at 0xa000, 00:02:3f:18:5a:a6, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
pci 0000:00:1f.1: enabling device (0005 -> 0007)
pci 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1100-0x1107
    ide1: BM-DMA at 0x1108-0x110f
Probing IDE interface ide0...
hda: IC25N060ATMR04-0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TOSHIBA ODD-DVD SD-R6372, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
hda: max request size: 512KiB
hda: 117210240 sectors (60011 MB) w/7884KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP bic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
IO APIC resources could be not be allocated.
Using IPI Shortcut mode
Marking TSC unstable due to TSC halts in idle
Clocksource tsc unstable (delta = -77171083 ns)
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x254ab1, caps: 0x804713/0x0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 208k freed
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 10, io base 0x00001200
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001600
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xf4000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2k
ipw2200: Copyright(c) 2003-2006 Intel Corporation
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001700
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ppdev: user-space parallel port driver
yenta_cardbus 0000:02:03.0: CardBus bridge found [1025:005a]
yenta_cardbus 0000:02:03.0: Using CSCINT to route CSC interrupts to PCI
yenta_cardbus 0000:02:03.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:03.0: TI: mfunc 0x001c1112, devctl 0x44
yenta_cardbus 0000:02:03.0: ISA IRQ mask 0x0860, PCI irq 10
yenta_cardbus 0000:02:03.0: Socket status: 30000006
yenta_cardbus 0000:02:03.0: pcmcia: parent PCI bridge I/O window: 0xa000 - 0xbfff
 : cs: IO port probe 0xa000-0xbfff: clean.
yenta_cardbus 0000:02:03.0: pcmcia: parent PCI bridge Memory window: 0xd0000000 - 0xdfffffff
yenta_cardbus 0000:02:03.0: pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x9fffffff
ipw2200 0000:02:02.0: power state changed by ACPI to D0
ipw2200 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
firmware: requesting ipw2200-bss.fw
ipw2200: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
Intel ICH Modem 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Intel ICH 0000:00:1f.5: setting latency timer to 64
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x230-0x237
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
intel8x0_measure_ac97_clock: measured 54490 usecs
intel8x0: clocking to 48000
EXT3 FS on hda1, internal journal
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE storm detected, disabling EC GPE
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
[drm] Initialized radeon 1.29.0 20080528 on minor 0
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64 bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
[drm] Num pipes: 1
