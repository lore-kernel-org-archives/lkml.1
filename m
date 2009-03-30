Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZC3LLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZC3LLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZC3LLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:11:10 -0400
Received: from monster.nessie.de ([84.200.20.120]:54977 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZC3LLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:11:06 -0400
Message-ID: <49D0A8C2.8010307@nessie.de>
Date: Mon, 30 Mar 2009 13:10:58 +0200
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: petkovbb@gmail.com, Michael Roth <mroth@nessie.de>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
 workaround
References: <49CFCB2A.4020505@nessie.de> <20090329201337.GA9962@liondog.tnic> <49CFEA24.10700@nessie.de> <20090330072713.GA13776@liondog.tnic>
In-Reply-To: <20090330072713.GA13776@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

> That'll definitely be very helpful since I wanna know exactly why it
> locks up. If you still have no output it'd be cool if you could enable
> ide-cd debugging and retry catching the output. Here's a patch for that,

I got even no output over the serial console when the kernel freeze. So
I tried your patch and the complete log from the boot to the freezing state
is attached below.

One additional observance: Without your hotfix starting /usr/sbin/hald
takes quite longer (about 3 to 5 seconds) compared to about a half second
with your hotfix. Same behaviour with the commit found by bisect: Before
that commit hald starts fast and from that commit hald takes some seconds.

To me it looks like that probing (?) by /usr/sbin/hald maybe left the ide-cd
in some erroneous state which result in a freeze after about 2 minutes?




Linux version 2.6.29debug (root@nautilus) (gcc version 4.3.3 (Gentoo 4.3.3-r1) ) #18 PREEMPT Mon Mar 30 12:06:08 CEST 2009
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
Early serial console at I/O port 0x2f8 (options '115200n8')
console [uart0] enabled
DMI 2.2 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
RAMDISK: 37e7d000 - 37fef853
Allocated new RAMDISK: 00621000 - 00793853
Move RAMDISK from 0000000037e7d000 - 0000000037fef852 to 00621000 - 00793852
ACPI: RSDP 000F6F30, 0014 (r0 VKT333)
ACPI: RSDT 3FFF3000, 002C (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FFF30C0, 3E82 (r1 VKT333 AWRDACPI     1000 MSFT  100000D)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6F80, 0054 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00011000 - 00017f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000061dcec]    TEXT DATA BSS ==> [0000100000 - 000061dcec]
  #2 [000061e000 - 0000621000]    INIT_PG_TABLE ==> [000061e000 - 0000621000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [0000621000 - 0000793853]      NEW RAMDISK ==> [0000621000 - 0000793853]
  #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: earlycon=uart8250,io,0x2f8,115200n8 console=uart8250,io,0x2f8,115200n8 console=tty0 crypt_root=/dev/vg1/root.crypt dolvm lvmraid=/dev/md3 video=radeonfb
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1994.511 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [uart0] -> real [tty0]
Linux version 2.6.29debug (root@nautilus) (gcc version 4.3.3 (Gentoo 4.3.3-r1) ) #18 PREEMPT Mon Mar 30 12:06:08 CEST 2009
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
Early serial console at I/O port 0x2f8 (options '115200n8')
console [uart0] enabled
DMI 2.2 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
RAMDISK: 37e7d000 - 37fef853
Allocated new RAMDISK: 00621000 - 00793853
Move RAMDISK from 0000000037e7d000 - 0000000037fef852 to 00621000 - 00793852
ACPI: RSDP 000F6F30, 0014 (r0 VKT333)
ACPI: RSDT 3FFF3000, 002C (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3FFF30C0, 3E82 (r1 VKT333 AWRDACPI     1000 MSFT  100000D)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6F80, 0054 (r1 VKT333 AWRDACPI 42302E31 AWRD        0)
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00011000 - 00017f00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000061dcec]    TEXT DATA BSS ==> [0000100000 - 000061dcec]
  #2 [000061e000 - 0000621000]    INIT_PG_TABLE ==> [000061e000 - 0000621000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
  #5 [0000621000 - 0000793853]      NEW RAMDISK ==> [0000621000 - 0000793853]
  #6 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: earlycon=uart8250,io,0x2f8,115200n8 console=uart8250,io,0x2f8,115200n8 console=tty0 crypt_root=/dev/vg1/root.crypt dolvm lvmraid=/dev/md3 video=radeonfb
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1994.511 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [uart0] -> real [tty0]
console [ttyS1] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1031948k/1048512k available (3389k kernel code, 15736k reserved, 1193k data, 348k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc057c000 - 0xc05d3000   ( 348 kB)
      .data : 0xc044f64d - 0xc0579dc0   (1193 kB)
      .text : 0xc0100000 - 0xc044f64d   (3389 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.02 BogoMIPS (lpj=1994511)
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
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
pci 0000:00:11.0: quirk: region 5000-500f claimed by vt8235 SMB
pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:12.0: PME# disabled
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
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1482k freed
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
type=2000 audit(1238416744.453:1): initialized
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
pdc202xx_new 0000:00:0a.0: PLL input clock is 16599 kHz
pdc202xx_new 0000:00:0a.0: 100% native mode on irq 18
    ide2: BM-DMA at 0xb400-0xb407
    ide3: BM-DMA at 0xb408-0xb40f
hde: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hde: UDMA/66 mode selected
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
hda: SAMSUNG HD400LD, ATA DISK drive
hda: UDMA/100 mode selected
hdc: SAMSUNG HD400LD, ATA DISK drive
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
ide-cd: Call ide_cdrom_setup
ide-cd: Call ide_cdrom_probe_capabilities, drive->media: 0x5, drive->atapi_flags: 0x2
ide-cd: Call ide_cdrom_get_capabilities
ide-cd: Call ide_cd_queue_pc, cmd[0]: 0x5a, write: 0x0, timeout: 7000, cmd_flags: 0x0
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x5a, rq->cmd_type: 0xa, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x5a, rq->cmd_type: 0xa
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x5a, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 24
ide-cd: Call ide_cd_check_ireason, ireason: 0x2, rw: 0x0
ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0xa, ireason: 0x2
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x5a, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 0
ide-cd: Call ide_cd_request_sense_fixup, rq->cmd[0]: 0x5a
ide-cd: Call cdrom_end_request, cmd: 0x5a, uptodate: 0x1, nsectors: 0
ide-cd: Exit cdrom_end_request, uptodate: 0x1, nsectors: 1
ide-cd: Call ide_cdrom_update_speed
ide-cd: ide_cdrom_update_speed: curspeed: 8467, maxspeed: 8467
ide-cd: hde: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
ide-cd: Call ide_cdrom_register, nslots: 1
Uniform CD-ROM driver Revision: 3.20
ide-cd: Call ide_cd_read_toc
ide-cd: Call cdrom_check_status
ide-cd: Call ide_cd_queue_pc, cmd[0]: 0x0, write: 0x0, timeout: 0, cmd_flags: 0x8000
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x0, rq->cmd_type: 0xa, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x0, rq->cmd_type: 0xa
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x0, write: 0x0
ide-cd: cdrom_decode_status: stat: 0x51, good_stat: 0x0, rq->cmd[0]: 0x0, rq->cmd_type: 0xa, err: 0x24
ide-cd: Call cdrom_queue_request_sense
ide-cd: failed_cmd: 0x0
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x3, rq->cmd_type: 0x3, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x3, rq->cmd_type: 0x3
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 18
ide-cd: Call ide_cd_check_ireason, ireason: 0x2, rw: 0x0
ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0x3, ireason: 0x2
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 0
ide-cd: Call ide_cd_request_sense_fixup, rq->cmd[0]: 0x3
ide-cd: Call cdrom_end_request, cmd: 0x3, uptodate: 0x1, nsectors: 0
ide-cd: Call cdrom_analyze_sense_data, error_code: 0x70, sense_key: 0x2
ide-cd: cdrom_analyze_sense_data: failed cmd: 0x0
ide-cd: Call cdrom_log_sense, sense_key: 0x2
ide-cd: Exit cdrom_end_request, uptodate: 0x1, nsectors: 1
ide-cd: Call cdrom_read_capacity
ide-cd: Call ide_cd_queue_pc, cmd[0]: 0x25, write: 0x0, timeout: 0, cmd_flags: 0x8000
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x25, rq->cmd_type: 0xa, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x25, rq->cmd_type: 0xa
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x25, write: 0x0
ide-cd: cdrom_decode_status: stat: 0x51, good_stat: 0x0, rq->cmd[0]: 0x25, rq->cmd_type: 0xa, err: 0x24
ide-cd: Call cdrom_queue_request_sense
ide-cd: failed_cmd: 0x25
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x3, rq->cmd_type: 0x3, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x3, rq->cmd_type: 0x3
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 18
ide-cd: Call ide_cd_check_ireason, ireason: 0x2, rw: 0x0
ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0x3, ireason: 0x2
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 0
ide-cd: Call ide_cd_request_sense_fixup, rq->cmd[0]: 0x3
ide-cd: Call cdrom_end_request, cmd: 0x3, uptodate: 0x1, nsectors: 0
ide-cd: Call cdrom_analyze_sense_data, error_code: 0x70, sense_key: 0x2
ide-cd: cdrom_analyze_sense_data: failed cmd: 0x25
ide-cd: Call cdrom_log_sense, sense_key: 0x2
ide-cd: Exit cdrom_end_request, uptodate: 0x1, nsectors: 1
ide-cd: Call cdrom_read_tocentry
ide-cd: Call ide_cd_queue_pc, cmd[0]: 0x43, write: 0x0, timeout: 0, cmd_flags: 0x8000
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x43, rq->cmd_type: 0xa, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x43, rq->cmd_type: 0xa
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x43, write: 0x0
ide-cd: cdrom_decode_status: stat: 0x51, good_stat: 0x0, rq->cmd[0]: 0x43, rq->cmd_type: 0xa, err: 0x24
ide-cd: Call cdrom_queue_request_sense
ide-cd: failed_cmd: 0x43
ide-cd: Call ide_cd_do_request, rq->cmd[0]: 0x3, rq->cmd_type: 0x3, block: 4294967295
ide-cd: Call cdrom_do_block_pc, rq->cmd[0]: 0x3, rq->cmd_type: 0x3
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x58, thislen: 18
ide-cd: Call ide_cd_check_ireason, ireason: 0x2, rw: 0x0
ide-cd: cdrom_newpc_intr: data transfer, rq->cmd_type: 0x3, ireason: 0x2
ide-cd: Call cdrom_newpc_intr, rq->cmd[0]: 0x3, write: 0x0
ide-cd: cdrom_newpc_intr: DRQ: stat: 0x50, thislen: 0
ide-cd: Call ide_cd_request_sense_fixup, rq->cmd[0]: 0x3
ide-cd: Call cdrom_end_request, cmd: 0x3, uptodate: 0x1, nsectors: 0
ide-cd: Call cdrom_analyze_sense_data, error_code: 0x70, sense_key: 0x2
ide-cd: cdrom_analyze_sense_data: failed cmd: 0x43
ide-cd: Call cdrom_log_sense, sense_key: 0x2
ide-cd: Exit cdrom_end_request, uptodate: 0x1, nsectors: 1
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
usb usb1: Manufacturer: Linux 2.6.29debug ehci_hcd
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
usb usb2: Manufacturer: Linux 2.6.29debug uhci_hcd
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
usb usb3: Manufacturer: Linux 2.6.29debug uhci_hcd
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
usb usb4: Manufacturer: Linux 2.6.29debug uhci_hcd
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
Freeing unused kernel memory: 348k freed
Write protecting the kernel text: 3392k
Write protecting the kernel read-only data: 960k

