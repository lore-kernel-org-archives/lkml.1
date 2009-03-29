Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZC2Vh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZC2Vh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZC2Vht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:37:49 -0400
Received: from monster.nessie.de ([84.200.20.120]:42694 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZC2Vhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:37:46 -0400
Message-ID: <49CFEA24.10700@nessie.de>
Date: Sun, 29 Mar 2009 23:37:40 +0200
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: petkovbb@gmail.com, Michael Roth <mroth@nessie.de>,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
 workaround
References: <49CFCB2A.4020505@nessie.de> <20090329201337.GA9962@liondog.tnic>
In-Reply-To: <20090329201337.GA9962@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

thank you for your help.

Borislav Petkov schrieb:

>  Can we please see a dmesg of a working
> kernel on your machine

Sure, dmesg output appended beneath. I also added the dmesg output
of the patched kernel. See below.


> and also is it possible to catch any kernel output of the crash
> any oops or something when your machine freezes - the more the better.

There aren't any messages, neither on the console nor in the syslog.
The kernel simple freeze, cursor on the console stops blinking, no
more ide activity. I have to hit the reset-bottom to restart.


> Probably over a serial console would be best but photographed
> with a digicam and uploaded somewhere as a screenshot would do too.

I will do that on request, but it will take some time (about days)
because currently I don't have access to a second computer or so.


> You could also try the following patch to see whether that is of any
> help:

Your patch helps perfectly. I'm writing this email on the patched
2.6.29. I also tested CD and DVD access: They work well. Burning not
tested but I assume it will work too.


Ok, here the dmesg of the original 2.6.29 with deactivated idecd:


Linux version 2.6.29 (root@nautilus) (gcc version 4.3.3 (Gentoo 4.3.3-r1) ) #6 PREEMPT Sun Mar 29 20:11:02 CEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.2 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-15000
RAMDISK: 37e7d000 - 37fef7fa
Allocated new RAMDISK: 005d8000 - 0074a7fa
Move RAMDISK from 0000000037e7d000 - 0000000037fef7f9 to 005d8000 - 0074a7f9
ACPI: RSDP 000F6F30, 0014 (r0 VKT333)
ACPI: RSDT 3FFF3000, 002C (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FFF30C0, 3E82 (r1 VKT333 AWRDACPI     1000 MSFT  100000D)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6F80, 0054 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00011000 - 00017f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00005d4f2c]    TEXT DATA BSS ==> [0000100000 - 00005d4f2c]
  #2 [00005d5000 - 00005d8000]    INIT_PG_TABLE ==> [00005d5000 - 00005d8000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [00005d8000 - 000074a7fa]      NEW RAMDISK ==> [00005d8000 - 000074a7fa]
  #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c052f380, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: crypt_root=/dev/vg1/root.crypt dolvm lvmraid=/dev/md3 video=radeonfb
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1994.344 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032240k/1048512k available (3184k kernel code, 15444k reserved, 1134k data, 324k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc053a000 - 0xc058b000   ( 324 kB)
      .data : 0xc041c29f - 0xc0537d40   (1134 kB)
      .text : 0xc0100000 - 0xc041c29f   (3184 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3988.68 BogoMIPS (lpj=1994344)
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 60031223. Reprogramming to 20031223
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) XP 2400+ stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
net_namespace: 932 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb3b0, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:01.0: supports D1
pci 0000:00:09.0: reg 10 32bit mmio: [0xe8100000-0xe811ffff]
pci 0000:00:09.0: reg 14 32bit mmio: [0xe8120000-0xe813ffff]
pci 0000:00:09.0: reg 18 io port: [0xa000-0xa03f]
pci 0000:00:09.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: reg 10 io port: [0xa400-0xa407]
pci 0000:00:0a.0: reg 14 io port: [0xa800-0xa803]
pci 0000:00:0a.0: reg 18 io port: [0xac00-0xac07]
pci 0000:00:0a.0: reg 1c io port: [0xb000-0xb003]
pci 0000:00:0a.0: reg 20 io port: [0xb400-0xb40f]
pci 0000:00:0a.0: reg 24 32bit mmio: [0xe8160000-0xe8163fff]
pci 0000:00:0a.0: reg 30 32bit mmio: [0x000000-0x003fff]
pci 0000:00:0a.0: supports D1
pci 0000:00:10.0: reg 20 io port: [0xb800-0xb81f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0xbc00-0xbc1f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xc000-0xc01f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: reg 10 32bit mmio: [0xe8164000-0xe81640ff]
pci 0000:00:10.3: supports D1 D2
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
pci 0000:00:11.1: reg 20 io port: [0xc400-0xc40f]
pci 0000:00:11.5: reg 10 io port: [0xc800-0xc8ff]
pci 0000:00:11.5: supports D1 D2
pci 0000:00:12.0: reg 10 io port: [0xcc00-0xccff]
pci 0000:00:12.0: reg 14 32bit mmio: [0xe8165000-0xe81650ff]
pci 0000:00:12.0: supports D1 D2
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xe8020000-0xe802ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:01:00.1: reg 14 32bit mmio: [0xe8030000-0xe803ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xe8000000-0xe80fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xd8000000-0xe7ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0
ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0
ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0xd0000-0xd3fff has been reserved
system 00:00: iomem range 0xd9800-0xdbfff has been reserved
system 00:00: iomem range 0xf0000-0xfbfff could not be reserved
system 00:00: iomem range 0xfc000-0xfffff could not be reserved
system 00:00: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:00: iomem range 0xffff0000-0xffffffff has been reserved
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xe8000000-0xe80fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000e7ffffff
pci 0000:00:01.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xe8000000-0xe80fffff]
pci_bus 0000:01: resource 2 mem: [0xd8000000-0xe7ffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1481k freed
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1747
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: VIA PCI bridge detected. Disabling DAC.
pci 0000:01:00.0: Boot video device
radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=240.00 Mhz, System=166.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
Switched to high resolution mode on CPU 0
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 160x64
radeonfb (0000:01:00.0): ATI Radeon 5960 "Y`"
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI_CPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
Linux agpgart interface v0.103
agpgart: Detected VIA KT266/KY266x/KT333 chipset
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
pdc202xx_new 0000:00:0a.0: IDE controller (0x105a:0x4d69 rev 0x02)
Promise_IDE 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pdc202xx_new 0000:00:0a.0: PLL input clock is 16623 kHz
pdc202xx_new 0000:00:0a.0: 100% native mode on irq 18
    ide2: BM-DMA at 0xb400-0xb407
    ide3: BM-DMA at 0xb408-0xb40f
Probing IDE interface ide2...
hde: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hde: UDMA/66 mode selected
Probing IDE interface ide3...
ide2 at 0xa400-0xa407,0xa802 on irq 18
ide3 at 0xac00-0xac07,0xb002 on irq 18
via82cxxx 0000:00:11.1: VIA vt8235 (rev 00) IDE UDMA133
via82cxxx 0000:00:11.1: IDE controller (0x1106:0x0571 rev 0x06)
ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
VIA_IDE 0000:00:11.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
via82cxxx 0000:00:11.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xc400-0xc407
    ide1: BM-DMA at 0xc408-0xc40f
Probing IDE interface ide0...
hda: SAMSUNG HD400LD, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: SAMSUNG HD400LD, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: max request size: 512KiB
hdc: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3 hdc4
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ehci_hcd 0000:00:10.3: PCI INT D -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.3: EHCI Host Controller
ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.3: irq 21, io mem 0xe8164000
ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.3
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000b800
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000bc00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000c000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 324k freed
Marking TSC unstable due to TSC halts in idle
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: New USB device found, idVendor=0dda, idProduct=2005
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB2.0 Card Reader
usb 1-4: Manufacturer: ICSI
usb 1-4: SerialNumber: 0000001
usb 1-4: configuration #1 chosen from 1 choice
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: New USB device found, idVendor=046a, idProduct=0004
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1: configuration #1 chosen from 1 choice
input: HID 046a:0004 as /class/input/input4
generic-usb 0003:046A:0004.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0004] on usb-0000:00:10.0-1/input0
input: HID 046a:0004 as /class/input/input5
generic-usb 0003:046A:0004.0002: input,hidraw1: USB HID v1.10 Device [HID 046a:0004] on usb-0000:00:10.0-1/input1
usb 2-2: new low speed USB device using uhci_hcd and address 3
usb 2-2: New USB device found, idVendor=046d, idProduct=c024
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB-PS/2 Optical Mouse
usb 2-2: Manufacturer: B16_b_02
usb 2-2: configuration #1 chosen from 1 choice
input: B16_b_02 USB-PS/2 Optical Mouse as /class/input/input6
generic-usb 0003:046D:C024.0003: input,hidraw2: USB HID v1.10 Mouse [B16_b_02 USB-PS/2 Optical Mouse] on usb-0000:00:10.0-2/input0
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering hdc3 ...
md:  adding hdc3 ...
md: hdc2 has different UUID to hdc3
md:  adding hda3 ...
md: hda2 has different UUID to hdc3
md: created md2
md: bind<hda3>
md: bind<hdc3>
md: running: <hdc3><hda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering hdc2 ...
md:  adding hdc2 ...
md:  adding hda2 ...
md: created md3
md: bind<hda2>
md: bind<hdc2>
md: running: <hdc2><hda2>
raid1: raid set md3 active with 2 out of 2 mirrors
md: ... autorun DONE.
 md2: unknown partition table
 md3: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000 0000:00:09.0: PCI: Disallowing DAC for device
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine: Broken BIOS detected, avoid_D3 enabled.
IT8705 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
e1000: 0000:00:09.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:17:35:86
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 23
ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 23
via-rhine 0000:00:12.0: PCI INT A -> Link[ALKD] -> GSI 23 (level, low) -> IRQ 23
eth1: VIA Rhine II at 0xe8165000, 00:0a:e6:62:b1:b3, IRQ 23.
eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
EXT3 FS on dm-3, internal journal
scsi 0:0:0:0: Direct-Access     ICSI     IC1210        CF 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:1: Direct-Access     ICSI     IC1210        MS 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:2: Direct-Access     ICSI     IC1210    MMC/SD 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:3: Direct-Access     ICSI     IC1210        SM 1.6B PQ: 0 ANSI: 0 CCS
usb-storage: device scan complete
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:1: [sdb] Attached SCSI removable disk
sd 0:0:0:2: [sdc] Attached SCSI removable disk
sd 0:0:0:3: [sdd] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:1: Attached scsi generic sg1 type 0
sd 0:0:0:2: Attached scsi generic sg2 type 0
sd 0:0:0:3: Attached scsi generic sg3 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.11)
Adding 524280k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:524280k
hda: UDMA/100 mode selected
hda: cache flushes supported
hdc: UDMA/100 mode selected
hdc: cache flushes supported
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
eth1: link down
Bridge firewalling registered
device eth0 entered promiscuous mode
device eth1 entered promiscuous mode
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
warning: `squid' uses 32-bit capabilities (legacy support in use)
br0: no IPv6 routers present
eth0: no IPv6 routers present
agpgart-via 0000:00:00.0: AGP 2.0 bridge
agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
agpgart-via 0000:00:00.0: AGP 2.0 bridge
agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Loading R200 Microcode
loop: module loaded



And this is the dmesg output of the patched (localversion misleading) 2.6.29:


Linux version 2.6.29bisect (root@nautilus) (gcc version 4.3.3 (Gentoo 4.3.3-r1) ) #16 PREEMPT Sun Mar 29 22:47:23 CEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.2 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-15000
RAMDISK: 37e7d000 - 37fef7fc
Allocated new RAMDISK: 005fc000 - 0076e7fc
Move RAMDISK from 0000000037e7d000 - 0000000037fef7fb to 005fc000 - 0076e7fb
ACPI: RSDP 000F6F30, 0014 (r0 VKT333)
ACPI: RSDT 3FFF3000, 002C (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FFF30C0, 3E82 (r1 VKT333 AWRDACPI     1000 MSFT  100000D)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6F80, 0054 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00011000 - 00017f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00005f89ac]    TEXT DATA BSS ==> [0000100000 - 00005f89ac]
  #2 [00005f9000 - 00005fc000]    INIT_PG_TABLE ==> [00005f9000 - 00005fc000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [00005fc000 - 000076e7fc]      NEW RAMDISK ==> [00005fc000 - 000076e7fc]
  #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c0550c40, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: crypt_root=/dev/vg1/root.crypt dolvm lvmraid=/dev/md3 video=radeonfb
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1994.519 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1032096k/1048512k available (3289k kernel code, 15588k reserved, 1165k data, 328k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc055c000 - 0xc05ae000   ( 328 kB)
      .data : 0xc04367d7 - 0xc0559d40   (1165 kB)
      .text : 0xc0100000 - 0xc04367d7   (3289 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.03 BogoMIPS (lpj=1994519)
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 60031223. Reprogramming to 20031223
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) XP 2400+ stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
net_namespace: 932 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb3b0, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:01.0: supports D1
pci 0000:00:09.0: reg 10 32bit mmio: [0xe8100000-0xe811ffff]
pci 0000:00:09.0: reg 14 32bit mmio: [0xe8120000-0xe813ffff]
pci 0000:00:09.0: reg 18 io port: [0xa000-0xa03f]
pci 0000:00:09.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: reg 10 io port: [0xa400-0xa407]
pci 0000:00:0a.0: reg 14 io port: [0xa800-0xa803]
pci 0000:00:0a.0: reg 18 io port: [0xac00-0xac07]
pci 0000:00:0a.0: reg 1c io port: [0xb000-0xb003]
pci 0000:00:0a.0: reg 20 io port: [0xb400-0xb40f]
pci 0000:00:0a.0: reg 24 32bit mmio: [0xe8160000-0xe8163fff]
pci 0000:00:0a.0: reg 30 32bit mmio: [0x000000-0x003fff]
pci 0000:00:0a.0: supports D1
pci 0000:00:10.0: reg 20 io port: [0xb800-0xb81f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0xbc00-0xbc1f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xc000-0xc01f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: reg 10 32bit mmio: [0xe8164000-0xe81640ff]
pci 0000:00:10.3: supports D1 D2
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
pci 0000:00:11.1: reg 20 io port: [0xc400-0xc40f]
pci 0000:00:11.5: reg 10 io port: [0xc800-0xc8ff]
pci 0000:00:11.5: supports D1 D2
pci 0000:00:12.0: reg 10 io port: [0xcc00-0xccff]
pci 0000:00:12.0: reg 14 32bit mmio: [0xe8165000-0xe81650ff]
pci 0000:00:12.0: supports D1 D2
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xe8020000-0xe802ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:01:00.1: reg 14 32bit mmio: [0xe8030000-0xe803ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xe8000000-0xe80fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xd8000000-0xe7ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0
ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0
ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0xd0000-0xd3fff has been reserved
system 00:00: iomem range 0xd9800-0xdbfff has been reserved
system 00:00: iomem range 0xf0000-0xfbfff could not be reserved
system 00:00: iomem range 0xfc000-0xfffff could not be reserved
system 00:00: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:00: iomem range 0xffff0000-0xffffffff has been reserved
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xfff80000-0xfffeffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x805 has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x9000-0x9fff
pci 0000:00:01.0:   MEM window: 0xe8000000-0xe80fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000e7ffffff
pci 0000:00:01.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xe8000000-0xe80fffff]
pci_bus 0000:01: resource 2 mem: [0xd8000000-0xe7ffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1481k freed
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
type=2000 audit(1238368509.235:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1747
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: VIA PCI bridge detected. Disabling DAC.
pci 0000:01:00.0: Boot video device
radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=240.00 Mhz, System=166.00 MHz
radeonfb: PLL min 20000 max 40000
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
Console: switching to colour frame buffer device 160x64
radeonfb (0000:01:00.0): ATI Radeon 5960 "Y`"
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI_CPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
Linux agpgart interface v0.103
agpgart: Detected VIA KT266/KY266x/KT333 chipset
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.29.0 20080528 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
pdc202xx_new 0000:00:0a.0: IDE controller (0x105a:0x4d69 rev 0x02)
Promise_IDE 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pdc202xx_new 0000:00:0a.0: PLL input clock is 16608 kHz
pdc202xx_new 0000:00:0a.0: 100% native mode on irq 18
    ide2: BM-DMA at 0xb400-0xb407
    ide3: BM-DMA at 0xb408-0xb40f
Probing IDE interface ide2...
hde: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hde: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hde: UDMA/66 mode selected
Probing IDE interface ide3...
ide2 at 0xa400-0xa407,0xa802 on irq 18
ide3 at 0xac00-0xac07,0xb002 on irq 18
via82cxxx 0000:00:11.1: VIA vt8235 (rev 00) IDE UDMA133
via82cxxx 0000:00:11.1: IDE controller (0x1106:0x0571 rev 0x06)
ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
VIA_IDE 0000:00:11.1: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
via82cxxx 0000:00:11.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xc400-0xc407
    ide1: BM-DMA at 0xc408-0xc40f
Probing IDE interface ide0...
hda: SAMSUNG HD400LD, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: SAMSUNG HD400LD, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: max request size: 512KiB
hdc: 781422768 sectors (400088 MB) w/8192KiB Cache, CHS=48641/255/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3 hdc4
ide-cd driver 5.00
ide-cd: hde: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usbmon: debugfs is not available
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ehci_hcd 0000:00:10.3: PCI INT D -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.3: EHCI Host Controller
ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.3: irq 21, io mem 0xe8164000
ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29bisect ehci_hcd
usb usb1: SerialNumber: 0000:00:10.3
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000b800
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29bisect uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: PCI INT B -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000bc00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29bisect uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: PCI INT C -> Link[ALKB] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000c000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29bisect uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 328k freed
Marking TSC unstable due to TSC halts in idle
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: New USB device found, idVendor=0dda, idProduct=2005
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB2.0 Card Reader
usb 1-4: Manufacturer: ICSI
usb 1-4: SerialNumber: 0000001
usb 1-4: configuration #1 chosen from 1 choice
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: New USB device found, idVendor=046a, idProduct=0004
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1: configuration #1 chosen from 1 choice
input: HID 046a:0004 as /class/input/input4
generic-usb 0003:046A:0004.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 046a:0004] on usb-0000:00:10.0-1/input0
input: HID 046a:0004 as /class/input/input5
generic-usb 0003:046A:0004.0002: input,hidraw1: USB HID v1.10 Device [HID 046a:0004] on usb-0000:00:10.0-1/input1
usb 2-2: new low speed USB device using uhci_hcd and address 3
md: Autodetecting RAID arrays.
usb 2-2: New USB device found, idVendor=046d, idProduct=c024
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB-PS/2 Optical Mouse
usb 2-2: Manufacturer: B16_b_02
usb 2-2: configuration #1 chosen from 1 choice
input: B16_b_02 USB-PS/2 Optical Mouse as /class/input/input6
generic-usb 0003:046D:C024.0003: input,hidraw2: USB HID v1.10 Mouse [B16_b_02 USB-PS/2 Optical Mouse] on usb-0000:00:10.0-2/input0
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering hdc3 ...
md:  adding hdc3 ...
md: hdc2 has different UUID to hdc3
md:  adding hda3 ...
md: hda2 has different UUID to hdc3
md: created md2
md: bind<hda3>
md: bind<hdc3>
md: running: <hdc3><hda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering hdc2 ...
md:  adding hdc2 ...
md:  adding hda2 ...
md: created md3
md: bind<hda2>
md: bind<hdc2>
md: running: <hdc2><hda2>
raid1: raid set md3 active with 2 out of 2 mirrors
md: ... autorun DONE.
 md2: unknown partition table
 md3: unknown partition table
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine: Broken BIOS detected, avoid_D3 enabled.
ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 23
ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 23
via-rhine 0000:00:12.0: PCI INT A -> Link[ALKD] -> GSI 23 (level, low) -> IRQ 23
eth0: VIA Rhine II at 0xe8165000, 00:0a:e6:62:b1:b3, IRQ 23.
eth0: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000 0000:00:09.0: PCI: Disallowing DAC for device
IT8705 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
udev: renamed network interface eth0 to eth1
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
e1000: 0000:00:09.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:17:35:86
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] -> GSI 22 (level, low) -> IRQ 22
VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
EXT3 FS on dm-3, internal journal
scsi 0:0:0:0: Direct-Access     ICSI     IC1210        CF 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:1: Direct-Access     ICSI     IC1210        MS 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:2: Direct-Access     ICSI     IC1210    MMC/SD 1.6B PQ: 0 ANSI: 0 CCS
scsi 0:0:0:3: Direct-Access     ICSI     IC1210        SM 1.6B PQ: 0 ANSI: 0 CCS
usb-storage: device scan complete
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:1: [sdb] Attached SCSI removable disk
sd 0:0:0:2: [sdc] Attached SCSI removable disk
sd 0:0:0:3: [sdd] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:1: Attached scsi generic sg1 type 0
sd 0:0:0:2: Attached scsi generic sg2 type 0
sd 0:0:0:3: Attached scsi generic sg3 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.11)
Adding 524280k swap on /dev/mapper/swap.  Priority:-1 extents:1 across:524280k
hda: UDMA/100 mode selected
hda: cache flushes supported
hdc: UDMA/100 mode selected
hdc: cache flushes supported
hde: UDMA/66 mode selected
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
eth1: link down
Bridge firewalling registered
device eth0 entered promiscuous mode
device eth1 entered promiscuous mode
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
warning: `squid' uses 32-bit capabilities (legacy support in use)
br0: no IPv6 routers present
eth0: no IPv6 routers present
agpgart-via 0000:00:00.0: AGP 2.0 bridge
agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
agpgart-via 0000:00:00.0: AGP 2.0 bridge
agpgart-via 0000:00:00.0: putting AGP V2 device into 4x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Loading R200 Microcode
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A

