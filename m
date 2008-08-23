Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYHWKmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYHWKmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYHWKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:41:54 -0400
Received: from ns1.smart-weblications.de ([91.204.168.2]:43143 "EHLO
	ns1.smart-weblications.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYHWKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:41:48 -0400
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Aug 2008 06:41:47 EDT
Message-ID: <48AFE67A.7090103@smart-weblications.de>
Date: Sat, 23 Aug 2008 12:29:14 +0200
From: "Smart Weblications GmbH, Florian Wiessner" 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with 2.6.26.2 - kobject (c06fb2a0): tried to init an initialized
 object, something is seriously,wrong.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


i have strange behavior with 2.6.26.2 kernel. I use openvpn to tunnel a
static ip address to my linux server, and after a while (<24h) it apears
that the systems does not connect via pppoex as it says PADO Timeout
although the link on eth2 is up and my dsl-modem is synced. when i
reboot the machine everything works fine for about another 20 hrs...

i switched the openvpn-tunnel to tcp-proto and now the system "lives" a
little longer, appr. 30 - 40 hrs when the problem occurs.

i don't see anything in dmesg or syslog, sometimes my pppoe connection
is still active, but i only get about 20kb/sec max. troughput.

today i found in dmesg:
Pid: 1, comm: swapper Not tainted 2.6.26.2 #1
 [<c02b7564>] kobject_init+0x29/0x53
 [<c0328f9d>] device_initialize+0x1b/0x8f
 [<c0329654>] device_register+0x8/0x10
 [<c03e2abf>] i2c_register_adapter+0x88/0x12c
 [<c03e2c74>] i2c_add_adapter+0x68/0x70
 [<c0743820>] amd756_s4882_init+0x258/0x262
 [<c07435b7>] amd756_init+0x0/0x11
 [<c0194e1a>] sysfs_add_file+0xb/0xe
 [<c07435c8>] amd756_s4882_init+0x0/0x262
 [<c072541d>] kernel_init+0x120/0x254
 [<c0507700>] _write_trylock+0xb/0x4b
 [<c011ac1b>] finish_task_switch+0x1f/0x70
 [<c011ac89>] schedule_tail+0x1d/0x4b
 [<c0102ade>] ret_from_fork+0x6/0x1c
 [<c07252fd>] kernel_init+0x0/0x254
 [<c07252fd>] kernel_init+0x0/0x254
 [<c01037cb>] kernel_thread_helper+0x7/0x10
 =======================

I also tried before 2.6.26.2 the kernels from 2.6.25 - 2.6.26.2 and it
seems that the problem is related to these error messsages i got with
kernel versions < 2.6.26.2: "SKB BUG: Invalid truesize (244) len=200,
sizeof(sk_buff)=164" when the eth/ppp interface became stale...

The error messages with "SKB BUG:" now don't appear in 2.6.26.2, but the
problem that the connection is slowed down still exists - it seems that
the problem arises, when i have heavy udp traffic.

but i don't know if that is the problem, so i am writing to the lkml.
any ideas/help to solve the problem would be nice.


dmesg:
Linux version 2.6.26.2 (root@office) (gcc version 4.1.3 20080420
(prerelease) (Debian 4.1.2-22)) #1 SMP PREEMPT Wed Aug 13 11:16:41 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffec000 (usable)
 BIOS-e820: 000000003ffec000 - 000000003ffef000 (ACPI data)
 BIOS-e820: 000000003ffef000 - 000000003ffff000 (reserved)
 BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00f7e90] 000f7e90
Entering add_active_range(0, 0, 262124) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262124
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262124
On node 0 totalpages: 262124
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 256 pages used for memmap
  HighMem zone: 32492 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F85E0, 0014 (r0 ASUS  )
ACPI: RSDT 3FFEC000, 0030 (r1 ASUS   A7M266-D 30303031 MSFT 31313031)
ACPI: FACP 3FFEC100, 0074 (r1 ASUS   A7M266-D 30303031 MSFT 31313031)
ACPI: DSDT 3FFEC180, 20C6 (r1   ASUS A7M266-D     1000 MSFT  100000B)
ACPI: FACS 3FFFF000, 0040
ACPI: BOOT 3FFEC040, 0028 (r1 ASUS   A7M266-D 30303031 MSFT 31313031)
ACPI: APIC 3FFEC080, 0068 (r1 ASUS   A7M266-D 30303031 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37416 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260076
Kernel command line: auto BOOT_IMAGE=lx26262 root=901 max_loop=64
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1666.788 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1031580k/1048496k available (4140k kernel code, 16368k reserved,
2123k data, 304k init, 130992k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0725000 - 0xc0771000   ( 304 kB)
      .data : 0xc050b119 - 0xc071deac   (2123 kB)
      .text : 0xc0100000 - 0xc050b119   (4140 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3335.98 BogoMIPS
(lpj=1667992)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 278 Objects with 29 Devices 82 Methods 14 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode
successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(TM) MP 2000+ stepping 02
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3332.71 BogoMIPS
(lpj=1666358)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(TM) MP 2000+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (6668.70 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
net_namespace: 636 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1f20, last bus=3
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on
int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package
initialization:...........................................
Initialized 11/14 Regions 0/0 Fields 18/18 Buffers 14/14 Packages (287
nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 33 objects)
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 2 Wake, Enabled 1
Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x3fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
system 00:02: ioport range 0x3f0-0x3f1 has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:03: ioport range 0xe400-0xe4fe has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: 0xf9800000-0xfb3fffff
  PREFETCH window: 0x00000000fb700000-0x00000000fb7fffff
PCI: Bridge: 0000:02:06.0
  IO window: 7000-8fff
  MEM window: 0xf6700000-0xf67fffff
  PREFETCH window: 0x00000000fb400000-0x00000000fb4fffff
PCI: Bridge: 0000:00:10.0
  IO window: 7000-afff
  MEM window: 0xf6700000-0xf77fffff
  PREFETCH window: 0x00000000fb400000-0x00000000fb5fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Aug 13 2008 10:59:26) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.9)
SGI XFS with security attributes, large block numbers, no debug enabled
msgmni has been set to 1759
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: BIOS failed to enable PCI standards compliance; fixing
this error
pci 0000:01:05.0: Boot video device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
Console: switching to colour frame buffer device 80x30
fb0: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input1
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
Non-volatile memory driver v1.2
AMD768 RNG detected
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin
is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 20 (level, low) -> IRQ 20
e1000: 0000:00:08.0: e1000_probe: (PCI:66MHz:64-bit) 00:04:23:a7:b5:8e
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:00:08.1[B] -> GSI 21 (level, low) -> IRQ 21
e1000: 0000:00:08.1: e1000_probe: (PCI:66MHz:64-bit) 00:04:23:a7:b5:8f
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
sundance.c:v1.2 11-Sep-2006  Written by Donald Becker
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 17 (level, low) -> IRQ 17
eth2: D-Link DFE-580TX 4 port Server Adapter at 00018800,
00:0d:88:c5:b4:a8, IRQ 17.
eth2: MII PHY found at address 1, status 0x7829 advertising 01e1.
ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 18 (level, low) -> IRQ 18
eth3: D-Link DFE-580TX 4 port Server Adapter at 00018400,
00:0d:88:c5:b4:a9, IRQ 18.
eth3: MII PHY found at address 1, status 0x7809 advertising 01e1.
ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 19 (level, low) -> IRQ 19
eth4: D-Link DFE-580TX 4 port Server Adapter at 00018000,
00:0d:88:c5:b4:aa, IRQ 19.
eth4: MII PHY found at address 1, status 0x7809 advertising 01e1.
ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 16 (level, low) -> IRQ 16
eth5: D-Link DFE-580TX 4 port Server Adapter at 00017800,
00:0d:88:c5:b4:ab, IRQ 16.
eth5: MII PHY found at address 1, status 0x7809 advertising 01e1.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD7441: 0000:00:07.1 (rev 04) UDMA100 controller
AMD7441: IDE controller (0x1022:0x7441 rev 0x04) at  PCI slot 0000:00:07.1
AMD7441: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xb800-0xb807
    ide1: BM-DMA at 0xb808-0xb80f
Probing IDE interface ide0...
hda: ST3160812A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: ST3160812A, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hda: cache flushes supported
 hda: hda1 hda2
hdc: max request size: 512KiB
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hdc: cache flushes supported
 hdc: hdc1 hdc2
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_sil 0000:02:05.0: version 2.3
ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 18 (level, low) -> IRQ 18
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xf6800000 tf 0xf6800080 irq 18
ata2: SATA max UDMA/100 mmio m512@0xf6800000 tf 0xf68000c0 irq 18
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-8: SAMSUNG HD321KJ, CP100-12, max UDMA7
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-8: SAMSUNG HD321KJ, CP100-12, max UDMA7
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:02:00.0[D] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:02:00.0: OHCI Host Controller
ohci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:02:00.0: irq 19, io mem 0xf7000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
i2c /dev entries driver
Enabling SMBus multiplexing for Tyan S4882
i2c-adapter i2c-0: PCA9556 configuration failed
kobject (c06fb2a0): tried to init an initialized object, something is
seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.26.2 #1
 [<c02b7564>] kobject_init+0x29/0x53
 [<c0328f9d>] device_initialize+0x1b/0x8f
 [<c0329654>] device_register+0x8/0x10
 [<c03e2abf>] i2c_register_adapter+0x88/0x12c
 [<c03e2c74>] i2c_add_adapter+0x68/0x70
 [<c0743820>] amd756_s4882_init+0x258/0x262
 [<c07435b7>] amd756_init+0x0/0x11
 [<c0194e1a>] sysfs_add_file+0xb/0xe
 [<c07435c8>] amd756_s4882_init+0x0/0x262
 [<c072541d>] kernel_init+0x120/0x254
 [<c0507700>] _write_trylock+0xb/0x4b
 [<c011ac1b>] finish_task_switch+0x1f/0x70
 [<c011ac89>] schedule_tail+0x1d/0x4b
 [<c0102ade>] ret_from_fork+0x6/0x1c
 [<c07252fd>] kernel_init+0x0/0x254
 [<c07252fd>] kernel_init+0x0/0x254
 [<c01037cb>] kernel_thread_helper+0x7/0x10
 =======================
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using NMI interrupt.
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on
    Actions configured
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP scalable registered
TCP lp registered
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SCTP: Hash tables configured (established 65536 bind 65536)
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: hdc2 has different UUID to sdb1
md: hdc1 has different UUID to sdb1
md: hda2 has different UUID to sdb1
md: hda1 has different UUID to sdb1
md: created md5
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md5 active with 2 out of 2 mirrors
md: considering hdc2 ...
md:  adding hdc2 ...
md: hdc1 has different UUID to hdc2
md:  adding hda2 ...
md: hda1 has different UUID to hdc2
md: created md4
md: bind<hda2>
md: bind<hdc2>
md: running: <hdc2><hda2>
raid1: raid set md4 active with 2 out of 2 mirrors
md: considering hdc1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md1
md: bind<hda1>
md: bind<hdc1>
md: running: <hdc1><hda1>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 304k freed
Adding 1011960k swap on /dev/md4.  Priority:1 extents:1 across:1011960k
EXT3 FS on md1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: RRIP_1991A
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
e1000: eth1: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth2: Link changed: 100Mbps, full duplex
warning: `named' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present
eth1: no IPv6 routers present
eth2: no IPv6 routers present
UDP: bad checksum. From 123.5.32.153:8347 to 91.204.168.193:24441 ulen 106
mtrr: no more MTRRs available


/proc/cpuinfo:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(TM) MP 2000+
stepping        : 2
cpu MHz         : 1666.788
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips        : 3335.98
clflush size    : 32
power management: ts

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(TM) MP 2000+
stepping        : 2
cpu MHz         : 1666.788
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips        : 3332.71
clflush size    : 32
power management: ts

lspci -v:
00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
System Controller (rev 11)
        Flags: bus master, 66MHz, medium devsel, latency 32
        Memory at fc000000 (32-bit, prefetchable) [size=32M]
        Memory at fb800000 (32-bit, prefetchable) [size=4K]
        I/O ports at e800 [disabled] [size=4]
        Capabilities: [a0] AGP version 2.0

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
AGP Bridge (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: f9800000-fb3fffff
        Prefetchable memory behind bridge: fb700000-fb7fffff

00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ISA (rev 05)
        Subsystem: ASUSTeK Computer Inc. A7M-D Mainboard
        Flags: bus master, 66MHz, medium devsel, latency 0

00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE
(rev 04) (prog-if 8a [Master SecP PriP])
        Subsystem: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE
        Flags: bus master, medium devsel, latency 32
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
        I/O ports at b800 [size=16]

00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI (rev 03)
        Subsystem: ASUSTeK Computer Inc. A7M-D Mainboard
        Flags: medium devsel

00:08.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet
Controller (rev 03)
        Subsystem: Intel Corporation PRO/1000 MT Dual Port Network
Connection
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 20
        Memory at f9000000 (64-bit, non-prefetchable) [size=128K]
        Memory at f8800000 (64-bit, non-prefetchable) [size=256K]
        I/O ports at b400 [size=64]
        [virtual] Expansion ROM at 50000000 [disabled] [size=256K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [e4] PCI-X non-bridge device

00:08.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet
Controller (rev 03)
        Subsystem: Intel Corporation PRO/1000 MT Dual Port Network
Connection
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 21
        Memory at f8000000 (64-bit, non-prefetchable) [size=128K]
        Memory at f7800000 (64-bit, non-prefetchable) [size=256K]
        I/O ports at b000 [size=64]
        [virtual] Expansion ROM at 50040000 [disabled] [size=256K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [e4] PCI-X non-bridge device

00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] PCI (rev
05) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 32
        Bus: primary=00, secondary=02, subordinate=03, sec-latency=32
        I/O behind bridge: 00007000-0000afff
        Memory behind bridge: f6700000-f77fffff
        Prefetchable memory behind bridge: fb400000-fb5fffff

01:05.0 VGA compatible controller: ATI Technologies Inc 3D Rage LT Pro
AGP-133 (rev dc) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Rage LT Pro AGP 2X
        Flags: bus master, stepping, medium devsel, latency 64, IRQ 11
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        I/O ports at d800 [size=256]
        Memory at f9800000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at fb7e0000 [disabled] [size=128K]
        Capabilities: [50] AGP version 1.0
        Capabilities: [5c] Power Management version 1

02:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-768 [Opus] USB
(rev 07) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 8044
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at f7000000 (32-bit, non-prefetchable) [size=4K]

02:05.0 Mass storage controller: Silicon Image, Inc. SiI 3512
[SATALink/SATARaid] Serial ATA Controller (rev 01)
        Subsystem: Silicon Image, Inc. SiI 3512 SATALink Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
        I/O ports at a800 [size=8]
        I/O ports at a400 [size=4]
        I/O ports at a000 [size=8]
        I/O ports at 9800 [size=4]
        I/O ports at 9400 [size=16]
        Memory at f6800000 (32-bit, non-prefetchable) [size=512]
        [virtual] Expansion ROM at fb500000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 2

02:06.0 PCI bridge: Intel Corporation 21152 PCI-to-PCI Bridge (prog-if
00 [Normal decode])
        Flags: bus master, medium devsel, latency 32
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=32
        I/O behind bridge: 00007000-00008fff
        Memory behind bridge: f6700000-f67fffff
        Prefetchable memory behind bridge: 00000000fb400000-00000000fb4fffff
        Capabilities: [dc] Power Management version 2

03:04.0 Ethernet controller: D-Link System Inc DL10050 Sundance Ethernet
(rev 14)
        Subsystem: D-Link System Inc DFE-580TX
        Flags: bus master, medium devsel, latency 32, IRQ 17
        I/O ports at 8800 [size=128]
        [virtual] Expansion ROM at fb400000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 2

03:05.0 Ethernet controller: D-Link System Inc DL10050 Sundance Ethernet
(rev 14)
        Subsystem: D-Link System Inc DFE-580TX
        Flags: bus master, medium devsel, latency 32, IRQ 18
        I/O ports at 8400 [size=128]
        [virtual] Expansion ROM at fb410000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 2

03:06.0 Ethernet controller: D-Link System Inc DL10050 Sundance Ethernet
(rev 14)
        Subsystem: D-Link System Inc DFE-580TX
        Flags: bus master, medium devsel, latency 32, IRQ 19
        I/O ports at 8000 [size=128]
        [virtual] Expansion ROM at fb420000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 2

03:07.0 Ethernet controller: D-Link System Inc DL10050 Sundance Ethernet
(rev 14)
        Subsystem: D-Link System Inc DFE-580TX
        Flags: bus master, medium devsel, latency 32, IRQ 16
        I/O ports at 7800 [size=128]
        [virtual] Expansion ROM at fb430000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 2

-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 700 762 789 32 - 0,12 EUR/Min*
fax.: +49 700 762 789 32 - 0,12 EUR/Min*
24/7: +49 900 311 886 00 - 1,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
