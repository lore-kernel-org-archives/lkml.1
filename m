Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZAVX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZAVX5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZAVX5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:57:33 -0500
Received: from virgo.iok.hu ([212.40.97.103]:33440 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbZAVX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:57:29 -0500
Date: Fri, 23 Jan 2009 00:57:27 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090122235727.GB21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com> <20090121210726.GK21473@genesis.frugalware.org> <1232573646.6997.21.camel@localhost.localdomain> <20090122195132.GZ21473@genesis.frugalware.org> <1232654594.6678.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r3KnbM2MoJFBL7Dl"
Content-Disposition: inline
In-Reply-To: <1232654594.6678.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r3KnbM2MoJFBL7Dl
Content-Type: multipart/mixed; boundary="z4IKABJTiQIqPwmW"
Content-Disposition: inline


--z4IKABJTiQIqPwmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2009 at 12:03:14PM -0800, john stultz <johnstul@us.ibm.com>=
 wrote:
> > I did it two times when I finally realised that it depends on the
> > config. So currently I have two config files, with "-good" the clock is
> > fine, with "-bad" it's too fast.
>=20
> Could you send the same info I requested before (available_clocksources,
> current_clocksource, dmesg) for both good and bad configs? Also make
> sure they're on the same kernel version (as the configs are from
> slightly different kernel versions).

Good:

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
acpi_pm jiffies tsc
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
acpi_pm

Bad:

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc pit jiffies
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

> CONFIG_X86_VISWS: If I recall, this is support for SGI workstations that
> had different apics then most systems, and might be related.
>=20
> CONFIG_PARAVIRT_GUEST: I really haven't been paying much attention to
> the paravirt bits, but this has some clock related subconfig options
> that might be affecting it.

I just did a new build with CONFIG_X86_VISWS and CONFIG_X86_RDC321X
disabled, but I kept CONFIG_PARAVIRT_GUEST enabled and that works fine
as well. So CONFIG_PARAVIRT_GUEST seems to be unrelated.

(I built these on a faster machine, that's why the gcc version differs,
but that does not matter, I hope.)

Thank you both for your help! :)

--z4IKABJTiQIqPwmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-good
Content-Transfer-Encoding: quoted-printable

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28.1 (vmiklos@donau) (gcc version 4.1.2 20061115 (prerele=
ase) (Debian 4.1.1-21)) #3 SMP PREEMPT Fri Jan 23 00:11:27 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001dff0000 (usable)
 BIOS-e820: 000000001dff0000 - 000000001dffffc0 (ACPI data)
 BIOS-e820: 000000001dffffc0 - 000000001e000000 (ACPI NVS)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
DMI 2.2 present.
last_pfn =3D 0x1dff0 max_arch_pfn =3D 0x100000
Scanning 2 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000002000 (usable)
 modified: 0000000000002000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 0000000000007000 (usable)
 modified: 0000000000007000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 0000000000092c00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000001dff0000 (usable)
 modified: 000000001dff0000 - 000000001dffffc0 (ACPI data)
 modified: 000000001dffffc0 - 000000001e000000 (ACPI NVS)
 modified: 00000000fffc0000 - 0000000100000000 (reserved)
kernel direct mapping tables up to 1dff0000 @ 10000-16000
ACPI: RSDP 000E4010, 0014 (r0 OID_00)
ACPI: RSDT 1DFFFBD0, 002C (r1 OID_00 RSDT_000 30303030 _CSI    10101)
ACPI: FACP 1DFFFB20, 0074 (r1 INSYDE FACP_000      100 _CSI    10101)
ACPI: DSDT 1DFFAB20, 4FFE (r1 INSYDE KENORAA3     1004 MSFT  2000001)
ACPI: FACS 1DFFFFC0, 0040
ACPI: BOOT 1DFFFBA0, 0026 (r1 INSYDE SYS_BOOT      100 _CSI    10101)
0MB HIGHMEM available.
479MB LOWMEM available.
  mapped low ram: 0 - 1dff0000
  low ram: 00000000 - 1dff0000
  bootmap 00012000 - 00015c00
(8 early reservations) =3D=3D> bootmem [0000000000 - 001dff0000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0000001000 - 00000=
02000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
07000]
  #3 [0000100000 - 00006c79ec]    TEXT DATA BSS =3D=3D> [0000100000 - 00006=
c79ec]
  #4 [00006c8000 - 00006cb000]    INIT_PG_TABLE =3D=3D> [00006c8000 - 00006=
cb000]
  #5 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000009fc00 - 00001=
00000]
  #6 [0000010000 - 0000012000]          PGTABLE =3D=3D> [0000010000 - 00000=
12000]
  #7 [0000012000 - 0000016000]          BOOTMAP =3D=3D> [0000012000 - 00000=
16000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001dff0
  HighMem  0x0001dff0 -> 0x0001dff0
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x00000002
    0: 0x00000006 -> 0x00000007
    0: 0x00000010 -> 0x00000092
    0: 0x00000100 -> 0x0001dff0
On node 0 totalpages: 122741
free_area_init_node: node 0, pgdat c05ad900, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3941 pages, LIFO batch:0
  Normal zone: 928 pages used for memmap
  Normal zone: 117840 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Local APIC disabled by BIOS -- you can enable it with "lapic"
PM: Registered nosave memory: 0000000000002000 - 0000000000006000
PM: Registered nosave memory: 0000000000007000 - 0000000000010000
PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 1e000000:e1fc0000)
PERCPU: Allocating 49152 bytes of per cpu data
NR_CPUS: 16, nr_cpu_ids: 1, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121781
Kernel command line: root=3D/dev/sda1 ro quiet vga=3D791 resume=3D/dev/sda2
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 1499.810 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Scanning for low memory corruption every 60 seconds
Memory: 480576k/491456k available (3303k kernel code, 10272k reserved, 1647=
k data, 432k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffee9000 - 0xfffff000   (1112 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xde7f0000 - 0xff7fe000   ( 528 MB)
    lowmem  : 0xc0000000 - 0xddff0000   ( 479 MB)
      .init : 0xc05dc000 - 0xc0648000   ( 432 kB)
      .data : 0xc0439c52 - 0xc05d5b9c   (1647 kB)
      .text : 0xc0100000 - 0xc0439c52   (3303 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2999.62 BogoMIPS (lpj=3D1499810)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 15k freed
ACPI: Core revision 20080926
ACPI: setting ELCR to 0200 (from 0c00)
weird, boot CPU (#0) not listedby the BIOS.
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (2999.62 BogoMIPS).
net_namespace: 772 bytes
Booting paravirtualized kernel on bare hardware
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  3848.000 MB/sec
xor: using function: pIII_sse (3848.000 MB/sec)
regulator: core version 0.5
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: EC: driver started in poll mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xa0000000-0xa7ffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xf0000000-0xf007ffff]
pci 0000:00:02.0: reg 18 io port: [0xe000-0xe007]
pci 0000:00:02.0: supports D1
pci 0000:00:02.1: reg 10 32bit mmio: [0xa8000000-0xafffffff]
pci 0000:00:02.1: reg 14 32bit mmio: [0xf0100000-0xf017ffff]
pci 0000:00:02.1: supports D1
pci 0000:00:1d.0: reg 20 io port: [0xe120-0xe13f]
pci 0000:00:1d.1: reg 20 io port: [0xe240-0xe25f]
pci 0000:00:1d.2: reg 20 io port: [0xe360-0xe37f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0080000-0xf00803ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
HPET not enabled in BIOS. You might try hpet=3Dforce boot option
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1300-133f claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1100-0x110f]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.5: reg 10 io port: [0xe600-0xe6ff]
pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe83f]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xf0180000-0xf01801ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xf0180200-0xf01802ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0xea00-0xeaff]
pci 0000:00:1f.6: reg 14 io port: [0xec00-0xec7f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:00.0: reg 10 io port: [0xc200-0xc2ff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xe0008000-0xe00080ff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:02.0: reg 10 32bit mmio: [0xe0001000-0xe00017ff]
pci 0000:01:02.0: reg 14 32bit mmio: [0xe0004000-0xe0007fff]
pci 0000:01:02.0: supports D1 D2
pci 0000:01:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:02.0: PME# disabled
pci 0000:01:03.0: reg 10 32bit mmio: [0xe0000000-0xe0000fff]
pci 0000:01:03.0: PME# supported from D0 D3hot D3cold
pci 0000:01:03.0: PME# disabled
pci 0000:01:09.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:09.0: PME# disabled
pci 0000:01:09.1: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:01:09.1: supports D1 D2
pci 0000:01:09.1: PME# supported from D0 D1 D2 D3hot
pci 0000:01:09.1: PME# disabled
pci 0000:01:09.2: reg 10 io port: [0xc000-0xc03f]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xdfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:1e.0: bridge 32bit mmio pref: [0x90000000-0x9fffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 *11)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:05: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:07: ioport range 0x120-0x12f has been reserved
system 00:07: ioport range 0x1000-0x107f has been reserved
system 00:07: ioport range 0x1300-0x133f has been reserved
system 00:07: ioport range 0x1400-0x141f has been reserved
pci 0000:01:09.0: CardBus bridge, secondary bus 0000:02
pci 0000:01:09.0:   IO window: 0x00c400-0x00c4ff
pci 0000:01:09.0:   IO window: 0x00c800-0x00c8ff
pci 0000:01:09.0:   PREFETCH window: 0x90000000-0x93ffffff
pci 0000:01:09.0:   MEM window: 0xe4000000-0xe7ffffff
pci 0000:01:09.1: CardBus bridge, secondary bus 0000:06
pci 0000:01:09.1:   IO window: 0x00cc00-0x00ccff
pci 0000:01:09.1:   IO window: 0x00d000-0x00d0ff
pci 0000:01:09.1:   PREFETCH window: 0x94000000-0x97ffffff
pci 0000:01:09.1:   MEM window: 0xe8000000-0xebffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xc000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xe0000000-0xefffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000090000000-0x0000009fffffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:01:09.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:01:09.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0xc000-0xdfff]
bus: 01 index 1 mmio: [0xe0000000-0xefffffff]
bus: 01 index 2 mmio: [0x90000000-0x9fffffff]
bus: 01 index 3 io port: [0x00-0xffff]
bus: 01 index 4 mmio: [0x000000-0xffffffff]
bus: 02 index 0 io port: [0xc400-0xc4ff]
bus: 02 index 1 io port: [0xc800-0xc8ff]
bus: 02 index 2 mmio: [0x90000000-0x93ffffff]
bus: 02 index 3 mmio: [0xe4000000-0xe7ffffff]
bus: 06 index 0 io port: [0xcc00-0xccff]
bus: 06 index 1 io port: [0xd000-0xd0ff]
bus: 06 index 2 mmio: [0x94000000-0x97ffffff]
bus: 06 index 3 mmio: [0xe8000000-0xebffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x37 set to 0x1
audit: initializing netlink socket (disabled)
type=3D2000 audit(1232669950.230:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, realtime, large block numbers, no d=
ebug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 938
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xa0000000, mapped to 0xde880000, using 3072k, total=
 32576k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D20
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ =
11
serial 0000:00:1f.6: PCI INT B disabled
Switched to high resolution mode on CPU 0
floppy0: no floppy controllers found
brd: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
stex: Promise SuperTrak EX Driver version: 3.6.0000.1
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IR=
Q 10
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1100 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1108 irq 15
ata1.00: ATA-8: SAMSUNG HM121HC, LS100-10, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48=20
ata1.00: configured for UDMA/100
ata2.00: ATAPI: TSSTcorpCDW/DVD TS-L462A, U301, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM121HC  LS10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            TSSTcorp CDW/DVD TS-L462A U301 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 5x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1    488 MB/s
raid6: int32x2    593 MB/s
raid6: int32x4    511 MB/s
raid6: int32x8    417 MB/s
raid6: mmxx1     1472 MB/s
raid6: mmxx2     1683 MB/s
raid6: sse1x1    1074 MB/s
raid6: sse1x2    1734 MB/s
raid6: sse2x1    1945 MB/s
raid6: sse2x2    2210 MB/s
raid6: using algorithm sse2x2 (2210 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
EISA: Probing bus 0 at eisa.0
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
IO APIC resources could be not be allocated.
Using IPI No-Shortcut mode
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x9d6eb1, caps: 0xa04713/0x4006
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/i=
nput0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 432k freed
EXT3 FS on sda1, internal journal
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /devices/platform/pcspkr/input/input2
iTCO_vendor_support: vendor-support=3D0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
iTCO_wdt: Found a ICH4-M TCO device (Version=3D1, TCOBASE=3D0x1060)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IR=
Q 10
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 10, io base 0x0000e120
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IR=
Q 11
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000e240
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IR=
Q 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 10, io base 0x0000e360
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not=
 after
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level, low) -> IR=
Q 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xf0080000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Linux agpgart interface v0.103
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/91=
5GM/945G/945GM/945GME/965G/965GM chipsets
intelfb: Version 0.9.6
intelfb 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ=
 10
intelfb: Cannot reserve FB region.
ACPI: AC Adapter [AC] (on-line)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Battery Slot [BAT0] (battery present)
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input=
/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: WMI: Mapper loaded
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input=
/input4
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
ACPI: Lid Switch [LID0]
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.=
com>
ohci1394 0000:01:02.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IR=
Q 11
Intel ICH Modem 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low=
) -> IRQ 11
Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> I=
RQ 11
Intel ICH 0000:00:1f.5: setting latency timer to 64
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/inp=
ut/input6
ACPI: Video Device [GRFX] (multi-head: yes  rom: yes  post: no)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D[e0001000-e0001=
7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
yenta_cardbus 0000:01:09.0: CardBus bridge found [1558:0350]
yenta_cardbus 0000:01:09.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:01:09.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:01:09.0: TI: mfunc 0x01001c00, devctl 0x66
8139too Fast Ethernet driver 0.9.28
yenta_cardbus 0000:01:09.0: ISA IRQ mask 0x0078, PCI irq 10
yenta_cardbus 0000:01:09.0: Socket status: 30000086
pci_bus 0000:01: Raising subordinate bus# of parent bus (#01) from #01 to #=
05
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge I/O window: 0xc000 - =
0xdfff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xdfff: clean.
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge Memory window: 0xe000=
0000 - 0xefffffff
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge Memory window: 0x9000=
0000 - 0x9fffffff
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmq
ipw2200: Copyright(c) 2003-2006 Intel Corporation
8139too 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ=
 10
eth0: RealTek RTL8139 at 0xc200, 00:90:f5:3d:c5:6f, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
ipw2200 0000:01:03.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ=
 11
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
ipw2200 0000:01:03.0: firmware: requesting ipw2200-bss.fw
intel8x0_measure_ac97_clock: measured 50372 usecs
intel8x0: clocking to 48000
agpgart-intel 0000:00:00.0: Intel 855GM Chipset
agpgart-intel 0000:00:00.0: detected 32636K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xa0000000
ppdev: user-space parallel port driver
Marking TSC unstable due to TSC halts in idle
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090f501003dc56f]
ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
yenta_cardbus 0000:01:09.1: CardBus bridge found [1558:0350]
yenta_cardbus 0000:01:09.1: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:01:09.1: Routing CardBus interrupts to PCI
yenta_cardbus 0000:01:09.1: TI: mfunc 0x01001c00, devctl 0x66
udev: renamed network interface eth1 to eth0
udev: renamed network interface eth0_rename to eth1
yenta_cardbus 0000:01:09.1: ISA IRQ mask 0x0078, PCI irq 11
yenta_cardbus 0000:01:09.1: Socket status: 30000006
pci_bus 0000:01: Raising subordinate bus# of parent bus (#01) from #05 to #=
09
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge I/O window: 0xc000 - =
0xdfff
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc000-0xdfff: clean.
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge Memory window: 0xe000=
0000 - 0xefffffff
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge Memory window: 0x9000=
0000 - 0x9fffffff
Clocksource tsc unstable (delta =3D -266351989 ns)
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d=
0-0x4d7
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d=
0-0x4d7
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
EXT3 FS on sda1, internal journal
fuse init (API version 7.10)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redha=
t.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
eth1: link down
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (7679 buckets, 30716 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
warning: `pure-ftpd' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
eth0: Setting MAC to 00:0e:35:ca:6d:87
ieee80211_crypt: registered algorithm 'CCMP'
padlock: VIA PadLock not detected.
ieee80211_crypt: registered algorithm 'TKIP'
eth0: Setting MAC to 00:0e:35:ca:6d:87

--z4IKABJTiQIqPwmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-bad
Content-Transfer-Encoding: quoted-printable

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28.1 (vmiklos@donau) (gcc version 4.1.2 20061115 (prerele=
ase) (Debian 4.1.1-21)) #4 SMP PREEMPT Fri Jan 23 00:44:26 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001dff0000 (usable)
 BIOS-e820: 000000001dff0000 - 000000001dffffc0 (ACPI data)
 BIOS-e820: 000000001dffffc0 - 000000001e000000 (ACPI NVS)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
DMI 2.2 present.
last_pfn =3D 0x1dff0 max_arch_pfn =3D 0x100000
Scanning 2 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000002000 (usable)
 modified: 0000000000002000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 0000000000007000 (usable)
 modified: 0000000000007000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 0000000000092c00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000001dff0000 (usable)
 modified: 000000001dff0000 - 000000001dffffc0 (ACPI data)
 modified: 000000001dffffc0 - 000000001e000000 (ACPI NVS)
 modified: 00000000fffc0000 - 0000000100000000 (reserved)
kernel direct mapping tables up to 1dff0000 @ 10000-16000
ACPI: RSDP 000E4010, 0014 (r0 OID_00)
ACPI: RSDT 1DFFFBD0, 002C (r1 OID_00 RSDT_000 30303030 _CSI    10101)
ACPI: FACP 1DFFFB20, 0074 (r1 INSYDE FACP_000      100 _CSI    10101)
ACPI: DSDT 1DFFAB20, 4FFE (r1 INSYDE KENORAA3     1004 MSFT  2000001)
ACPI: FACS 1DFFFFC0, 0040
ACPI: BOOT 1DFFFBA0, 0026 (r1 INSYDE SYS_BOOT      100 _CSI    10101)
0MB HIGHMEM available.
479MB LOWMEM available.
  mapped low ram: 0 - 1dff0000
  low ram: 00000000 - 1dff0000
  bootmap 00012000 - 00015c00
(8 early reservations) =3D=3D> bootmem [0000000000 - 001dff0000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0000001000 - 00000=
02000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
07000]
  #3 [0000100000 - 00006c79ec]    TEXT DATA BSS =3D=3D> [0000100000 - 00006=
c79ec]
  #4 [00006c8000 - 00006cb000]    INIT_PG_TABLE =3D=3D> [00006c8000 - 00006=
cb000]
  #5 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000009fc00 - 00001=
00000]
  #6 [0000010000 - 0000012000]          PGTABLE =3D=3D> [0000010000 - 00000=
12000]
  #7 [0000012000 - 0000016000]          BOOTMAP =3D=3D> [0000012000 - 00000=
16000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001dff0
  HighMem  0x0001dff0 -> 0x0001dff0
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x00000002
    0: 0x00000006 -> 0x00000007
    0: 0x00000010 -> 0x00000092
    0: 0x00000100 -> 0x0001dff0
On node 0 totalpages: 122741
free_area_init_node: node 0, pgdat c05ada00, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3941 pages, LIFO batch:0
  Normal zone: 928 pages used for memmap
  Normal zone: 117840 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Local APIC disabled by BIOS -- you can enable it with "lapic"
PM: Registered nosave memory: 0000000000002000 - 0000000000006000
PM: Registered nosave memory: 0000000000007000 - 0000000000010000
PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 1e000000:e1fc0000)
PERCPU: Allocating 49152 bytes of per cpu data
NR_CPUS: 16, nr_cpu_ids: 1, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121781
Kernel command line: root=3D/dev/sda1 ro quiet vga=3D791 resume=3D/dev/sda2
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration deviates from PMTIMER: 1309349 1499779.
TSC: Using PIT calibration value
Detected 1309.349 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Scanning for low memory corruption every 60 seconds
Memory: 480576k/491456k available (3301k kernel code, 10272k reserved, 1649=
k data, 432k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffee5000 - 0xfffff000   (1128 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xde7f0000 - 0xff7fe000   ( 528 MB)
    lowmem  : 0xc0000000 - 0xddff0000   ( 479 MB)
      .init : 0xc05dc000 - 0xc0648000   ( 432 kB)
      .data : 0xc04395d2 - 0xc05d5b9c   (1649 kB)
      .text : 0xc0100000 - 0xc04395d2   (3301 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2618.69 BogoMIPS (lpj=3D1309349)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 15k freed
ACPI: Core revision 20080926
ACPI: setting ELCR to 0200 (from 0c00)
weird, boot CPU (#0) not listedby the BIOS.
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (2618.69 BogoMIPS).
net_namespace: 772 bytes
Booting paravirtualized kernel on bare hardware
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  3360.000 MB/sec
xor: using function: pIII_sse (3360.000 MB/sec)
regulator: core version 0.5
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: EC: driver started in poll mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xa0000000-0xa7ffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xf0000000-0xf007ffff]
pci 0000:00:02.0: reg 18 io port: [0xe000-0xe007]
pci 0000:00:02.0: supports D1
pci 0000:00:02.1: reg 10 32bit mmio: [0xa8000000-0xafffffff]
pci 0000:00:02.1: reg 14 32bit mmio: [0xf0100000-0xf017ffff]
pci 0000:00:02.1: supports D1
pci 0000:00:1d.0: reg 20 io port: [0xe120-0xe13f]
pci 0000:00:1d.1: reg 20 io port: [0xe240-0xe25f]
pci 0000:00:1d.2: reg 20 io port: [0xe360-0xe37f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0080000-0xf00803ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
HPET not enabled in BIOS. You might try hpet=3Dforce boot option
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1300-133f claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1100-0x110f]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.5: reg 10 io port: [0xe600-0xe6ff]
pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe83f]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xf0180000-0xf01801ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xf0180200-0xf01802ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0xea00-0xeaff]
pci 0000:00:1f.6: reg 14 io port: [0xec00-0xec7f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:00.0: reg 10 io port: [0xc200-0xc2ff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xe0008000-0xe00080ff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:02.0: reg 10 32bit mmio: [0xe0001000-0xe00017ff]
pci 0000:01:02.0: reg 14 32bit mmio: [0xe0004000-0xe0007fff]
pci 0000:01:02.0: supports D1 D2
pci 0000:01:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:02.0: PME# disabled
pci 0000:01:03.0: reg 10 32bit mmio: [0xe0000000-0xe0000fff]
pci 0000:01:03.0: PME# supported from D0 D3hot D3cold
pci 0000:01:03.0: PME# disabled
pci 0000:01:09.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:09.0: PME# disabled
pci 0000:01:09.1: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:01:09.1: supports D1 D2
pci 0000:01:09.1: PME# supported from D0 D1 D2 D3hot
pci 0000:01:09.1: PME# disabled
pci 0000:01:09.2: reg 10 io port: [0xc000-0xc03f]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xdfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:1e.0: bridge 32bit mmio pref: [0x90000000-0x9fffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 *11)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:05: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:07: ioport range 0x120-0x12f has been reserved
system 00:07: ioport range 0x1000-0x107f has been reserved
system 00:07: ioport range 0x1300-0x133f has been reserved
system 00:07: ioport range 0x1400-0x141f has been reserved
PM-Timer running at invalid rate: 87% of normal - aborting.
pci 0000:01:09.0: CardBus bridge, secondary bus 0000:02
pci 0000:01:09.0:   IO window: 0x00c400-0x00c4ff
pci 0000:01:09.0:   IO window: 0x00c800-0x00c8ff
pci 0000:01:09.0:   PREFETCH window: 0x90000000-0x93ffffff
pci 0000:01:09.0:   MEM window: 0xe4000000-0xe7ffffff
pci 0000:01:09.1: CardBus bridge, secondary bus 0000:06
pci 0000:01:09.1:   IO window: 0x00cc00-0x00ccff
pci 0000:01:09.1:   IO window: 0x00d000-0x00d0ff
pci 0000:01:09.1:   PREFETCH window: 0x94000000-0x97ffffff
pci 0000:01:09.1:   MEM window: 0xe8000000-0xebffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xc000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xe0000000-0xefffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000090000000-0x0000009fffffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:01:09.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:01:09.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0xc000-0xdfff]
bus: 01 index 1 mmio: [0xe0000000-0xefffffff]
bus: 01 index 2 mmio: [0x90000000-0x9fffffff]
bus: 01 index 3 io port: [0x00-0xffff]
bus: 01 index 4 mmio: [0x000000-0xffffffff]
bus: 02 index 0 io port: [0xc400-0xc4ff]
bus: 02 index 1 io port: [0xc800-0xc8ff]
bus: 02 index 2 mmio: [0x90000000-0x93ffffff]
bus: 02 index 3 mmio: [0xe4000000-0xe7ffffff]
bus: 06 index 0 io port: [0xcc00-0xccff]
bus: 06 index 1 io port: [0xd000-0xd0ff]
bus: 06 index 2 mmio: [0x94000000-0x97ffffff]
bus: 06 index 3 mmio: [0xe8000000-0xebffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x37 set to 0x1
audit: initializing netlink socket (disabled)
type=3D2000 audit(1232671826.255:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, realtime, large block numbers, no d=
ebug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 938
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xa0000000, mapped to 0xde880000, using 3072k, total=
 32576k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D20
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ =
11
serial 0000:00:1f.6: PCI INT B disabled
floppy0: no floppy controllers found
brd: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
stex: Promise SuperTrak EX Driver version: 3.6.0000.1
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IR=
Q 10
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1100 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1108 irq 15
ata1.00: ATA-8: SAMSUNG HM121HC, LS100-10, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48=20
ata1.00: configured for UDMA/100
ata2.00: ATAPI: TSSTcorpCDW/DVD TS-L462A, U301, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM121HC  LS10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            TSSTcorp CDW/DVD TS-L462A U301 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 5x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1    425 MB/s
raid6: int32x2    519 MB/s
raid6: int32x4    445 MB/s
raid6: int32x8    363 MB/s
raid6: mmxx1     1304 MB/s
raid6: mmxx2     1476 MB/s
raid6: sse1x1     949 MB/s
raid6: sse1x2    1519 MB/s
raid6: sse2x1    1707 MB/s
raid6: sse2x2    1941 MB/s
raid6: using algorithm sse2x2 (1941 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
EISA: Probing bus 0 at eisa.0
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
IO APIC resources could be not be allocated.
Using IPI No-Shortcut mode
registered taskstats version 1
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x9d6eb1, caps: 0xa04713/0x4006
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/i=
nput0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 432k freed
EXT3 FS on sda1, internal journal
ACPI: AC Adapter [AC] (on-line)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Battery Slot [BAT0] (battery present)
ACPI: WMI: Mapper loaded
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/inp=
ut/input2
ACPI: Video Device [GRFX] (multi-head: yes  rom: yes  post: no)
input: PC Speaker as /devices/platform/pcspkr/input/input3
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IR=
Q 10
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 10, io base 0x0000e120
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IR=
Q 11
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000e240
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IR=
Q 10
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 10, io base 0x0000e360
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input=
/input4
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input=
/input5
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input6
ACPI: Lid Switch [LID0]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Linux agpgart interface v0.103
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
ieee80211_crypt: registered algorithm 'NULL'
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not=
 after
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level, low) -> IR=
Q 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xf0080000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
iTCO_vendor_support: vendor-support=3D0
agpgart-intel 0000:00:00.0: Intel 855GM Chipset
agpgart-intel 0000:00:00.0: detected 32636K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xa0000000
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/91=
5GM/945G/945GM/945GME/965G/965GM chipsets
intelfb: Version 0.9.6
intelfb 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ=
 10
intelfb: Cannot reserve FB region.
ohci1394 0000:01:02.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IR=
Q 11
8139too Fast Ethernet driver 0.9.28
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D[e0001000-e0001=
7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
8139too 0000:01:00.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ=
 10
eth0: RealTek RTL8139 at 0xc200, 00:90:f5:3d:c5:6f, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.=
com>
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
iTCO_wdt: Found a ICH4-M TCO device (Version=3D1, TCOBASE=3D0x1060)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
yenta_cardbus 0000:01:09.0: CardBus bridge found [1558:0350]
yenta_cardbus 0000:01:09.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:01:09.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:01:09.0: TI: mfunc 0x01001c00, devctl 0x66
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmq
ipw2200: Copyright(c) 2003-2006 Intel Corporation
yenta_cardbus 0000:01:09.0: ISA IRQ mask 0x0078, PCI irq 10
yenta_cardbus 0000:01:09.0: Socket status: 30000086
pci_bus 0000:01: Raising subordinate bus# of parent bus (#01) from #01 to #=
05
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge I/O window: 0xc000 - =
0xdfff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xdfff: clean.
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge Memory window: 0xe000=
0000 - 0xefffffff
yenta_cardbus 0000:01:09.0: pcmcia: parent PCI bridge Memory window: 0x9000=
0000 - 0x9fffffff
udev: renamed network interface eth0 to eth1
ipw2200 0000:01:03.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ=
 11
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
ipw2200 0000:01:03.0: firmware: requesting ipw2200-bss.fw
ppdev: user-space parallel port driver
Intel ICH Modem 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low=
) -> IRQ 11
Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> I=
RQ 11
Intel ICH 0000:00:1f.5: setting latency timer to 64
ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
yenta_cardbus 0000:01:09.1: CardBus bridge found [1558:0350]
yenta_cardbus 0000:01:09.1: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:01:09.1: Routing CardBus interrupts to PCI
yenta_cardbus 0000:01:09.1: TI: mfunc 0x01001c00, devctl 0x66
yenta_cardbus 0000:01:09.1: ISA IRQ mask 0x0078, PCI irq 11
yenta_cardbus 0000:01:09.1: Socket status: 30000006
pci_bus 0000:01: Raising subordinate bus# of parent bus (#01) from #05 to #=
09
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge I/O window: 0xc000 - =
0xdfff
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc000-0xdfff: clean.
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge Memory window: 0xe000=
0000 - 0xefffffff
yenta_cardbus 0000:01:09.1: pcmcia: parent PCI bridge Memory window: 0x9000=
0000 - 0x9fffffff
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090f501003dc56f]
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d=
0-0x4d7
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d=
0-0x4d7
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
intel8x0_measure_ac97_clock: measured 50296 usecs
intel8x0: clocking to 54739
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
EXT3 FS on sda1, internal journal
fuse init (API version 7.10)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redha=
t.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
eth1: link down
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (7679 buckets, 30716 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
warning: `pure-ftpd' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
eth0: Setting MAC to 00:0e:35:ca:6d:87
ieee80211_crypt: registered algorithm 'CCMP'
padlock: VIA PadLock not detected.
ieee80211_crypt: registered algorithm 'TKIP'

--z4IKABJTiQIqPwmW--

--r3KnbM2MoJFBL7Dl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl5B+cACgkQe81tAgORUJaXZACeORA7rm1VPn64vC8+lT1sGjZM
uTEAn17yDqZSzJcoS5aqwgdDZmy1zWjb
=AAm0
-----END PGP SIGNATURE-----

--r3KnbM2MoJFBL7Dl--
