Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbZFLOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbZFLOmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZFLOmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:42:36 -0400
Received: from bar.sig21.net ([80.81.252.164]:54743 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFLOmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:42:32 -0400
Date: Fri, 12 Jun 2009 16:42:27 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.30: hibernation/swsusp stuck in disable_nonboot_cpus
Message-ID: <20090612144227.GA4961@sig21.net>
References: <20090611165608.GA4908@sig21.net> <20090611203234.GA27376@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611203234.GA27376@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -1.9 (-)
X-Spam-21-Report: No, score=-1.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.073,BAYES_00=-2.599,SARE_BAYES_5x8=0.8,SARE_BAYES_6x8=0.8,SARE_BAYES_7x8=1 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:32:34PM +0200, Pavel Machek wrote:
> On Thu 2009-06-11 18:56:08, Johannes Stezenbach wrote:
> > 
> > on my work machine susend-to-disk is broken in 2.6.30.  Last
> > known working kernel was 2.6.29.1. I'm running a 32bit kernel.
> > CPU is an AMD Athlon(tm) Dual Core Processor 4850e.
> > Board is a Gigabyte GA-MA78GM-S2H rev 1.1.
> > 
> > - usually it stops on suspend after the message
> >   "Suspending console(s) (use no_console_suspend to debug)"
> > 
> > - I booted with no_console_suspend using serial console
> >   as recommended in Documentation/power/basic-pm-debugging.txt.
> > 
> >   No joy, apparently the serial driver is disabled during suspend
> >   and no interesting output on serial console...
> > 
> > - no_console_suspend on VESA fb console worked better, last msg is
> >   "Disabling non-boot CPUs ..."
> ...
> > Kernel config, dmesg and lspci below.  Is there anyting I could
> > try besides git bisect?
> 
> Trying to set CONFIG_SMP=n and reproducing? Trying hibernating after
> manually offlining CPU?

Suspend after manually offlining the CPU works, but during resume
it has to go through the same sequence and hangs there.

A kernel built with CONFIG_SMP=n does not boot at all.
Below is dmesg with SysRq-P and SysRq-T output captured from serial console.


Johannes


Linux version 2.6.30 (root@zzz) (gcc version 4.3.3 (Debian 4.3.3-10) ) #11 PREEMPT Fri Jun 12 15:56:34 CEST 2009
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
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000006fde0000 (usable)
 BIOS-e820: 000000006fde0000 - 000000006fde3000 (ACPI NVS)
 BIOS-e820: 000000006fde3000 - 000000006fdf0000 (ACPI data)
 BIOS-e820: 000000006fdf0000 - 000000006fe00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x6fde0 max_arch_pfn = 0x100000
init_memory_mapping: 0000000000000000-00000000377fe000
RAMDISK: 37d52000 - 37fef51e
Allocated new RAMDISK: 005f4000 - 0089151e
Move RAMDISK from 0000000037d52000 - 0000000037fef51d to 005f4000 - 0089151d
ACPI: RSDP 000f6ef0 00014 (v00 GBT   )
ACPI: RSDT 6fde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: FACP 6fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: DSDT 6fde30c0 0651C (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
ACPI: FACS 6fde0000 00040
ACPI: SSDT 6fde96c0 0028A (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
ACPI: HPET 6fde9980 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
ACPI: MCFG 6fde99c0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
ACPI: APIC 6fde9600 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
901MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00008000 - 0000ef00
(7 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 00005f0c6c]    TEXT DATA BSS ==> [0000100000 - 00005f0c6c]
  #2 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #3 [00005f1000 - 00005f30fe]              BRK ==> [00005f1000 - 00005f30fe]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #5 [00005f4000 - 000089151e]      NEW RAMDISK ==> [00005f4000 - 000089151e]
  #6 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0006fde0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0006fde0
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 70000000 (gap: 6fe00000:70200000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 454531
Kernel command line: root=/dev/mapper/zzz-croot libata.force=6:1.5G ro vga=0x376 console=ttyS0,115200
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:16
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 2510.848 MHz processor.
Console: colour dummy device 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing HighMem for node 0 (000377fe:0006fde0)
Memory: 1808592k/1832832k available (2952k kernel code, 22920k reserved, 1525k data, 284k init, 923528k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffeb000 - 0xfffff000   (  80 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0562000 - 0xc05a9000   ( 284 kB)
      .data : 0xc03e234d - 0xc055f968   (1525 kB)
      .text : 0xc0100000 - 0xc03e234d   (2952 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 5021.69 BogoMIPS (lpj=10043392)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using C1E aware idle routine
CPU: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
ACPI: setting ELCR to 0200 (from 0c28)
net_namespace: 496 bytes
Time: 14:24:45  Date: 06/12/09
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:0e.0: PME# supported from D0 D1 D2 D3hot
pci 0000:03:0e.0: PME# disabled
pci 0000:00:14.4: transparent bridge
ACPI Warning (nspredef-0949): \_SB_.PCI0.PCEA._PRT: Return Package type mismatch at index 2 - found [NULL Object Descriptor], expected Integer/Reference [20090320]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 3: can't allocate resource
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0c: mem resource (0xd1a00-0xd3fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0c: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0c: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0c: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0c: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0c: mem resource (0x100000-0x6fddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x220-0x225 has been reserved
system 00:01: ioport range 0x290-0x294 has been reserved
system 00:02: ioport range 0x4100-0x411f has been reserved
system 00:02: ioport range 0x228-0x22f has been reserved
system 00:02: ioport range 0x238-0x23f has been reserved
system 00:02: ioport range 0x40b-0x40b has been reserved
system 00:02: ioport range 0x4d6-0x4d6 has been reserved
system 00:02: ioport range 0xc00-0xc01 has been reserved
system 00:02: ioport range 0xc14-0xc14 has been reserved
system 00:02: ioport range 0xc50-0xc52 has been reserved
system 00:02: ioport range 0xc6c-0xc6d has been reserved
system 00:02: ioport range 0xc6f-0xc6f has been reserved
system 00:02: ioport range 0xcd0-0xcd1 has been reserved
system 00:02: ioport range 0xcd2-0xcd3 has been reserved
system 00:02: ioport range 0xcd4-0xcdf has been reserved
system 00:02: ioport range 0x4000-0x40fe has been reserved
system 00:02: ioport range 0x4210-0x4217 has been reserved
system 00:02: ioport range 0xb00-0xb0f has been reserved
system 00:02: ioport range 0xb10-0xb1f has been reserved
system 00:02: ioport range 0xb20-0xb3f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x6fde0000-0x6fdfffff could not be reserved
system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0c: iomem range 0x6fef0000-0x7feeffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0c: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xfde00000-0xfdffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
pci 0000:00:0a.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:0a.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
pci 0000:00:14.4:   IO window: 0xc000-0xcfff
pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
pci 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 2677k freed
cpu0(1) debug files 130
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
msgmni has been set to 1735
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
vesafb: framebuffer at 0xd0000000, mapped to 0xf8180000, using 15000k, total 16384k
vesafb: mode is 1600x1200x32, linelength=6400, pages=1
vesafb: protected mode interface info at c000:a1aa
vesafb: pmi: set display start = c00ca24c, set palette = c00ca30a
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 200x75
fb0: VESA VGA frame buffer device
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
processor ACPI_CPU:00: registered as cooling_device0
Real Time Clock Driver v1.12b
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.3
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:05.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[drm] Initialized radeon 1.30.0 20080528 for 0000:01:05.0 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
loop: module loaded
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ACPI: PCI Interrupt Link [LNK0] enabled at IRQ 11
ahci 0000:00:11.0: PCI INT A -> Link[LNK0] -> GSI 11 (level, low) -> IRQ 11
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 11
ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 11
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 11
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 11
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 11
ata6: FORCE: PHY spd limit set to 1.5Gbps
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 11
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 0 (level, low) -> IRQ 0
r8169 0000:02:00.0: no MSI. Back to INTx.
eth0: RTL8168c/8111c at 0xf8152000, 00:1f:d0:59:3c:6d, XID 3c4000c0 IRQ 0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
SysRq : Show Regs

Pid: 0, comm: swapper Not tainted (2.6.30 #11) GA-MA78GM-S2H
EIP: 0060:[<c0108072>] EFLAGS: 00000246 CPU: 0
EIP is at default_idle+0x42/0x50
EAX: c0560000 EBX: c0587260 ECX: c0010055 EDX: 00000000
ESI: 00099800 EDI: c0559000 EBP: c0561f9c ESP: c0561f9c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 005a9000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c0108332>] c1e_idle+0x32/0xf0
 [<c0101e89>] cpu_idle+0x29/0x60
 [<c03d8d16>] rest_init+0x66/0x70
 [<c0562a05>] start_kernel+0x281/0x2e4
 [<c056253c>] ? unknown_bootoption+0x0/0x1f7
 [<c0562324>] i386_start_kernel+0x74/0x81
SysRq : Show State
  task                PC stack   pid father
swapper       D 00000000     0     1      0
 f702dec4 00000046 f702a000 00000000 00000000 c052cea8 00000000 f702a1a0
 49303e3a 00000000 f702af34 f702deb8 c0528180 f702a1a0 f702af2c c052ce60
 f702def0 c052ef10 00000000 f702decc c03df842 f702df10 c01372ad f702a000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c01372ad>] async_synchronize_cookie_domain+0xbd/0x150
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c0144090>] ? software_resume+0x0/0x1e0
 [<c013734d>] async_synchronize_cookie+0xd/0x10
 [<c0137368>] async_synchronize_full+0x18/0x40
 [<c02d5ab8>] wait_for_device_probe+0x68/0x70
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c0144115>] software_resume+0x85/0x1e0
 [<c056cdfb>] ? pm_qos_power_init+0x8b/0xca
 [<c010111a>] do_one_initcall+0x2a/0x150
 [<c01b4800>] ? proc_create_data+0x50/0xb0
 [<c014b3cf>] ? register_irq_proc+0x7f/0x90
 [<c05624e5>] kernel_init+0x82/0xd9
 [<c0562463>] ? kernel_init+0x0/0xd9
 [<c0103513>] kernel_thread_helper+0x7/0x14
kthreadd      S 00000000     0     2      0
 f702ffcc 00000046 f702a3c0 00000000 00000000 c0528180 f702a560 f702a560
 49303e3a 00000000 00000000 00000000 c0528180 f702a560 f702ffc0 c03dfa1d
 f702ded0 00000000 00000000 f702ffd4 c03df842 f702ffe0 c0131365 c0131240
Call Trace:
 [<c03dfa1d>] ? preempt_schedule+0x2d/0x50
 [<c03df842>] schedule+0x12/0x30
 [<c0131365>] kthreadd+0x125/0x130
 [<c0131240>] ? kthreadd+0x0/0x130
 [<c0103513>] kernel_thread_helper+0x7/0x14
ksoftirqd/0   S 0013d341     0     3      2
 f7053fbc 00000046 f702a780 0013d341 00000000 00000046 f7053fb8 f702a920
 458cc60d 00000000 f702a920 048881d4 c0528180 f702a920 00000004 00000246
 00000000 c0122890 00000000 f7053fc4 c03df842 f7053fd0 c0122967 00000000
Call Trace:
 [<c0122890>] ? ksoftirqd+0x0/0x150
 [<c03df842>] schedule+0x12/0x30
 [<c0122967>] ksoftirqd+0xd7/0x150
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
events/0      R running      0     4      2
 f7055f88 00000046 f702ab40 00000004 ffffffff f70081c0 00000046 f702ace0
 f7055f7c 00000246 00000246 ffff3e55 c0528180 f702ace0 f70081c0 f70081c0
 00000000 f70081c0 f70081c0 f7055f90 c03df842 f7055fd0 c012df5d f702ace0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c029a190>] ? console_callback+0x0/0x130
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
khelper       S f7057f6c     0     5      2
 f7057f88 00000046 f702af00 f7057f6c c01181a0 00000286 f696ec80 f702b0a0
 f7057f64 c03df842 f7057f6c c03dfa1d c0528180 f702b0a0 00000000 00000000
 00000000 f7008240 f7008240 f7057f90 c03df842 f7057fd0 c012df5d f702b0a0
Call Trace:
 [<c01181a0>] ? __wake_up_common+0x40/0x70
 [<c03df842>] ? schedule+0x12/0x30
 [<c03dfa1d>] ? preempt_schedule+0x2d/0x50
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c012d340>] ? __call_usermodehelper+0x0/0x80
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/mgr     S 000001f9     0     8      2
 f705df90 00000046 f702ba40 000001f9 00000000 c0118fc4 c03e9e40 f702bbe0
 482bc259 00000000 00000246 00001e51 c0528180 f702bbe0 c052ce60 00000246
 00000006 00000006 f705dfb0 f705df98 c03df842 f705dfd0 c0136e35 c0136f70
Call Trace:
 [<c0118fc4>] ? check_preempt_wakeup+0x94/0xc0
 [<c03df842>] schedule+0x12/0x30
 [<c0136e35>] async_manager_thread+0x45/0xe0
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136df0>] ? async_manager_thread+0x0/0xe0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kblockd/0     S 00000367     0   120      2
 f7165f88 00000046 f715af00 00000367 00000000 f702af34 f7165f68 f715b0a0
 06a6e7a6 00000000 c052ce60 00000000 c0528180 f715b0a0 f715af00 f702a000
 f7051e00 c012dde0 f7051e00 f7165f90 c03df842 f7165fd0 c012df5d f715b0a0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kacpid        S 0000051b     0   122      2
 f7171f88 00000046 f715b680 0000051b 00000000 f702af34 f7171f68 f715b820
 06a732d3 00000000 c052ce60 00000000 c0528180 f715b820 f715b680 f702a000
 f711a000 c012dde0 f711a000 f7171f90 c03df842 f7171fd0 c012df5d f715b820
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kacpi_notify  S 00be20d3     0   123      2
 f7173f88 00000046 f715ba40 00be20d3 00000000 f702a3f4 f7173f68 f715bbe0
 07657d1e 00000000 c052ce60 00000000 c0528180 f715bbe0 f715ba40 f7074780
 f711a080 c012dde0 f711a080 f7173f90 c03df842 f7173fd0 c012df5d f715bbe0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
ata/0         S 00000a01     0   194      2
 f71abf88 00000046 f720b2c0 00000a01 00000000 f702af34 f71abf68 f720b460
 0ff9956f 00000000 c052ce60 00000000 c0528180 f720b460 f720b2c0 f702a000
 f703a5c0 c012dde0 f703a5c0 f71abf90 c03df842 f71abfd0 c012df5d f720b460
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
ata_aux       S 00000920     0   195      2
 f71c5f88 00000046 f720af00 00000920 00000000 f702a3f4 f71c5f68 f720b0a0
 0ff9ad8d 00000000 c052ce60 00000000 c0528180 f720b0a0 f720af00 f702a000
 f703a640 c012dde0 f703a640 f71c5f90 c03df842 f71c5fd0 c012df5d f720b0a0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
ksuspend_usbd S 00001435     0   196      2
 f7163f88 00000046 f720ab40 00001435 00000000 f702a3f4 f7163f68 f720ace0
 0ff9f183 00000000 c052ce60 00000000 c0528180 f720ace0 f720ab40 f720a780
 f703a6c0 c012dde0 f703a6c0 f7163f90 c03df842 f7163fd0 c012df5d f720ace0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
khubd         S 0000051a     0   201      2
 f71f7f00 00000046 f715a000 0000051a 00000000 235ce795 00000000 f715a1a0
 1073a632 00000000 00000000 f715a000 c0528180 f715a1a0 f71f7f08 0000016b
 f71f7fa4 c031dea0 00000000 f71f7f08 c03df842 f71f7fd0 c031ec98 00000000
Call Trace:
 [<c031dea0>] ? hub_thread+0x0/0x1150
 [<c03df842>] schedule+0x12/0x30
 [<c031ec98>] hub_thread+0xdf8/0x1150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c03df6a5>] ? __schedule+0x2c5/0x450
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c031dea0>] ? hub_thread+0x0/0x1150
 [<c031dea0>] ? hub_thread+0x0/0x1150
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kseriod       S 00000000     0   204      2
 f71b1f8c 00000046 f715ab40 00000000 00000000 c03d8857 00000000 f715ace0
 49303e3a 00000000 f71b1f88 c02d512f c0528180 f715ace0 00000000 f7142da0
 f71b1fb0 f7142da0 f7142da0 f71b1f94 c03df842 f71b1fd0 c0334d3f 10b109a7
Call Trace:
 [<c03d8857>] ? klist_next+0x37/0xd0
 [<c02d512f>] ? bus_for_each_dev+0x6f/0x80
 [<c03df842>] schedule+0x12/0x30
 [<c0334d3f>] serio_thread+0x2ff/0x3e0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c0334a40>] ? serio_thread+0x0/0x3e0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
pdflush       S 00000738     0   254      2
 f711df9c 00000046 f720ba40 00000738 00000000 f711df88 c03e9e40 f720bbe0
 2abb0f41 00000000 f711df80 c03df842 c0528180 f720bbe0 f711dfa4 c0119ad4
 f711dfbc c0157730 00000000 f711dfa4 c03df842 f711dfd0 c01577ff c0528180
Call Trace:
 [<c03df842>] ? schedule+0x12/0x30
 [<c0119ad4>] ? set_user_nice+0x124/0x190
 [<c0157730>] ? pdflush+0x0/0x250
 [<c03df842>] schedule+0x12/0x30
 [<c01577ff>] pdflush+0xcf/0x250
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
pdflush       S 000008a1     0   255      2
 f711ff9c 00000046 f720a000 000008a1 00000000 f711ff88 c03e9e40 f720a1a0
 2abb2978 00000000 f711ff80 c03df842 c0528180 f720a1a0 f711ffa4 c0119ad4
 f711ffbc c0157730 00000000 f711ffa4 c03df842 f711ffd0 c01577ff c0528180
Call Trace:
 [<c03df842>] ? schedule+0x12/0x30
 [<c0119ad4>] ? set_user_nice+0x124/0x190
 [<c0157730>] ? pdflush+0x0/0x250
 [<c03df842>] schedule+0x12/0x30
 [<c01577ff>] pdflush+0xcf/0x250
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kswapd0       S 000018aa     0   256      2
 f720df1c 00000046 f702b2c0 000018aa 00000000 f715b2ec 00000000 f702b460
 2aec3e43 00000000 c052ce8c f720df30 c0528180 f702b460 2abb3b98 4a16a245
 c0554bc0 c015b7e0 00000000 f720df24 c03df842 f720dfd0 c015bd85 00000000
Call Trace:
 [<c015b7e0>] ? kswapd+0x0/0x5c0
 [<c03df842>] schedule+0x12/0x30
 [<c015bd85>] kswapd+0x5a5/0x5c0
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c03df6a5>] ? __schedule+0x2c5/0x450
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c015b7e0>] ? kswapd+0x0/0x5c0
 [<c015b7e0>] ? kswapd+0x0/0x5c0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
aio/0         S 00000345     0   306      2
 f7265f88 00000046 f72592c0 00000345 00000000 f702af34 f7265f68 f7259460
 2b019a5b 00000000 c052ce60 00000000 c0528180 f7259460 f72592c0 f702a000
 f70df040 c012dde0 f70df040 f7265f90 c03df842 f7265fd0 c012df5d f7259460
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
crypto/0      S 000016f5     0   319      2
 f7267f88 00000046 f727c3c0 000016f5 00000000 f702af34 f7267f68 f727c560
 2b2fe2a8 00000000 c052ce60 00000000 c0528180 f727c560 f727c3c0 f702a000
 f70df680 c012dde0 f70df680 f7267f90 c03df842 f7267fd0 c012df5d f727c560
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_0     D 00016faa     0   973      2
 f695dc7c 00000046 f6803680 00016faa 00000000 f6803680 f702a000 f6803820
 48b19daf 00000000 00000000 00000000 c0528180 f6803820 f6803820 482ab5d2
 c05d5cc0 fffedc42 fffedc0f f695dc84 c03df842 f695dcc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_1     D 000174e6     0   976      2
 f6801c7c 00000046 f6802000 000174e6 00000000 f6802000 f6803680 f68021a0
 48b1a3e7 00000000 00000000 00000000 c0528180 f68021a0 f68021a0 482af8ba
 c05d5cc0 fffedc42 fffedc0f f6801c84 c03df842 f6801cc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_2     D 00017a32     0   979      2
 f697dc7c 00000046 f7196000 00017a32 00000000 f7196000 f6802000 f71961a0
 48b1aa54 00000000 00000000 00000000 c0528180 f71961a0 f71961a0 482b3596
 c05d5cc0 fffedc42 fffedc0f f697dc84 c03df842 f697dcc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_3     D 00017f3e     0   982      2
 f6a1fc7c 00000046 f7196b40 00017f3e 00000000 f7196b40 f7196000 f7196ce0
 48b1b06e 00000000 00000000 00000000 c0528180 f7196ce0 f7196ce0 482b7135
 c05d5cc0 fffedc42 fffedc0f f6a1fc84 c03df842 f6a1fcc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_4     D 00018537     0   985      2
 f6bf5c7c 00000046 f7197680 00018537 00000000 f7197680 f7196b40 f7197820
 48b1b777 00000000 00000000 00000000 c0528180 f7197820 f7197820 482bacf0
 c05d5cc0 fffedc42 fffedc0f f6bf5c84 c03df842 f6bf5cc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
scsi_eh_5     D 00002aa1     0   988      2
 f705fc7c 00000046 f6803a40 00002aa1 00000000 f6803a40 f7197680 f6803be0
 48b1bda0 00000000 00000000 00000000 c0528180 f6803be0 f6803be0 482bf42e
 c05d5cc0 fffedc42 fffedc0f f705fc84 c03df842 f705fcc0 c03dfe49 c05d5cc0
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c03dfe49>] schedule_timeout+0xd9/0x160
 [<c01272e0>] ? process_timeout+0x0/0x10
 [<c03dfee4>] schedule_timeout_uninterruptible+0x14/0x20
 [<c0127275>] msleep+0x15/0x30
 [<c02f5a6e>] sata_link_resume+0x5e/0xb0
 [<c02f5def>] sata_link_hardreset+0x19f/0x270
 [<c02f3fd8>] ? ata_wait_register+0x28/0x80
 [<c0309f9f>] ahci_hardreset+0xaf/0x130
 [<c0309020>] ? ahci_check_ready+0x0/0x40
 [<c02fe6b0>] ata_do_reset+0x20/0x60
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c02ffcec>] ata_eh_reset+0x32c/0xcb0
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c0301627>] ata_eh_recover+0x217/0xd80
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c023066e>] ? number+0x27e/0x290
 [<c0309d00>] ? ahci_sb600_softreset+0x0/0x110
 [<c02f5ac0>] ? ata_std_prereset+0x0/0xd0
 [<c0182de1>] ? path_walk+0xa1/0xb0
 [<c0306cfc>] sata_pmp_error_handler+0xbc/0xbb0
 [<c0309ef0>] ? ahci_hardreset+0x0/0x130
 [<c030a9f0>] ? ahci_postreset+0x0/0x50
 [<c0231747>] ? vsnprintf+0x317/0x8a0
 [<c0118d7e>] ? update_curr+0x14e/0x190
 [<c012e133>] ? __cancel_work_timer+0x23/0x150
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c012e26b>] ? cancel_delayed_work_sync+0xb/0x10
 [<c030a9e9>] ahci_error_handler+0x39/0x40
 [<c0302eeb>] ata_scsi_error+0x4fb/0x850
 [<c011849e>] ? set_next_entity+0x2e/0x70
 [<c02e21d0>] scsi_error_handler+0xa0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c02e2130>] ? scsi_error_handler+0x0/0x3b0
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/0       D 00004c20     0   991      2
 f6a1df40 00000046 f727c000 00004c20 00000000 00000000 f727c000 f727c1a0
 482ab82d 00000000 f727c000 000001b6 c0528180 f727c1a0 00000000 f727c1a4
 00000286 f71fc000 f71fdea8 f6a1df48 c03df842 f6a1df70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/1       D 0000317f     0   993      2
 f71a5f40 00000046 f727cf00 0000317f 00000000 00000000 f727cf00 f727d0a0
 482afa21 00000000 f727cf00 00000138 c0528180 f727d0a0 00000000 f727d0a4
 00000286 f71ac000 f71adea8 f71a5f48 c03df842 f71a5f70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/2       D 00002d1c     0   994      2
 f70d9f40 00000046 f727d2c0 00002d1c 00000000 00000000 f727d2c0 f727d460
 482b3701 00000000 f727d2c0 00000106 c0528180 f727d460 00000000 f727d464
 00000286 f6958000 f6959ea8 f70d9f48 c03df842 f70d9f70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/3       D 00002ac1     0   995      2
 f68adf40 00000046 f727da40 00002ac1 00000000 00000000 f727da40 f727dbe0
 482b725f 00000000 f727da40 00000116 c0528180 f727dbe0 00000000 f727dbe4
 00000286 f71c0000 f71c1ea8 f68adf48 c03df842 f68adf70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/4       D 00002c7d     0   996      2
 f68cff40 00000046 f715a3c0 00002c7d 00000000 00000000 f715a3c0 f715a560
 482bae0d 00000000 f715a3c0 000000ee c0528180 f715a560 00000000 f715a564
 00000286 f719c000 f719dea8 f68cff48 c03df842 f68cff70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
async/5       D 00003742     0   997      2
 f7199f40 00000046 f715a780 00003742 00000000 00000000 f715a780 f715a920
 482bf56d 00000000 f715a780 00000103 c0528180 f715a920 00000000 f715a924
 00000286 f68a8000 f68a9ea8 f7199f48 c03df842 f7199f70 c030296e 00000000
Call Trace:
 [<c03df842>] schedule+0x12/0x30
 [<c030296e>] ata_port_wait_eh+0x6e/0xf0
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c02fa189>] async_port_probe+0x89/0xe0
 [<c013704e>] async_thread+0xde/0x280
 [<c0119fe0>] ? default_wake_function+0x0/0x10
 [<c0136f70>] ? async_thread+0x0/0x280
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kpsmoused     S 00000000     0  1015      2
 f6b41f88 00000046 f7197a40 00000000 00000000 f715ab74 f6b41f68 f7197be0
 49303e3a 00000000 c052ce60 00000000 c0528180 f7197be0 f7197a40 f702a000
 f70df2c0 c012dde0 f70df2c0 f6b41f90 c03df842 f6b41fd0 c012df5d f7197be0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
kstriped      S 00000000     0  1022      2
 f68a5f88 00000046 f68a2000 00000000 00000000 f702a3f4 f68a5f68 f68a21a0
 49303e3a 00000000 c052ce60 00000000 c0528180 f68a21a0 f68a2000 f702a000
 f696e040 c012dde0 f696e040 f68a5f90 c03df842 f68a5fd0 c012df5d f68a21a0
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
usbhid_resume S 00000000     0  1047      2
 f714df88 00000046 f71483c0 00000000 00000000 f702a3f4 f714df68 f7148560
 49303e3a 00000000 c052ce60 00000000 c0528180 f7148560 f71483c0 f702a000
 f696e340 c012dde0 f696e340 f714df90 c03df842 f714dfd0 c012df5d f7148560
Call Trace:
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c03df842>] schedule+0x12/0x30
 [<c012df5d>] worker_thread+0x17d/0x200
 [<c01315e0>] ? autoremove_wake_function+0x0/0x40
 [<c012dde0>] ? worker_thread+0x0/0x200
 [<c0131203>] kthread+0x43/0x80
 [<c01311c0>] ? kthread+0x0/0x80
 [<c0103513>] kernel_thread_helper+0x7/0x14
