Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbXKFSBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbXKFSBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXKFSBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:01:45 -0500
Received: from smtp010.mail.ukl.yahoo.com ([217.12.11.79]:32369 "HELO
	smtp010.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754219AbXKFSBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:01:43 -0500
X-Greylist: delayed 20700 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 13:01:42 EST
X-YMail-OSG: ZOzUPlAVM1kZDOYicyB.49Kh_tkdEEPWBrEXULh7H9JS.LgPsZChXj0w9I_HdKg2R6ttQNQzYKJuFqb3D6h4STP5J7ntlMPXPlPiENTnruukt.Fy
Message-ID: <4731630B.2050007@themis.com>
Date: Wed, 07 Nov 2007 08:02:35 +0100
From: jean-francois simon <jfs@themis.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Initrd problem with AMD opteron dual core
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
we have designed an embedded motherboard with dual AMD opteron CPU and 
Nvidia CK804 chipset. It has 4GB of SDRAM. this configuration works fine.
lately we have replaced the two single core CPUs with two dual core 
CPUs, giving us a total of 4 cores.
we are seeing that linux 2.6.23 is unable to load the initial ramdisk 
(initrd) with that new configuration. Basically the kernel complains 
that it can't load the programs on initrd,  with messages such as:

"Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine: 450:
elf-machine-rela-relative: Assertion '((reloc- r_info) & 0xffffffff) ==8'
failed!

This is happening here:
http://lxr.linux.no/source/init/main.c#L762

When initrd support is disabled in the kernel (CONFIG_BLK_DEV_INITRD=N), 
then the system is able to boot.


i don't know where to start to try solving this problem. why would the 
dual core CPUs cause a problem? i fear that just disabling the initrd 
could just mask a more serious problem.

also i don't understand why /proc/meminfo only reports 1GB...


thanks a lot for any help on this

op64d101:~ # uname -a
Linux op64d101 2.6.23 #1 SMP Sat Nov 3 20:00:57 EDT 2007 i686 athlon 
i386 GNU/Linux

# more /proc/mtrr
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=2048MB: write-back, count=1
reg02: base=0x180000000 (6144MB), size= 512MB: write-back, count=1
reg03: base=0x1a0000000 (6656MB), size= 256MB: write-back, count=1
reg04: base=0x40000000 (1024MB), size= 256MB: write-back, count=1
reg05: base=0xc8000000 (3200MB), size=  16MB: write-combining, count=1

----------------
more /proc/meminfo
MemTotal:      1270288 kB
MemFree:        937540 kB
Buffers:         32860 kB
Cached:         189832 kB
SwapCached:          0 kB
Active:         163980 kB
Inactive:       137592 kB
HighTotal:      392320 kB
HighFree:       118464 kB
LowTotal:       877968 kB
LowFree:        819076 kB
SwapTotal:     4200988 kB
SwapFree:      4200988 kB
Dirty:              84 kB
Writeback:           0 kB
AnonPages:       78884 kB
Mapped:          39956 kB
Slab:            15776 kB
SReclaimable:     9188 kB
SUnreclaim:       6588 kB
PageTables:       1580 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   4836132 kB
Committed_AS:   175040 kB
VmallocTotal:   114680 kB
VmallocUsed:      4096 kB
VmallocChunk:   110564 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     4096 kB

-------------


op64d101:~ # dmesg
Linux version 2.6.23 (root@op64d101) (gcc version 4.1.0 (SUSE Linux)) #1 
SMP Sat Nov 3 20:00:57 EDT 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000c2000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000004ff20000 (usable)
  BIOS-e820: 000000004ff20000 - 000000004ff80000 (ACPI NVS)
  BIOS-e820: 000000004ff80000 - 0000000050000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f70c0
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->  1048576
On node 0 totalpages: 1048576
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 6400 pages used for memmap
   HighMem zone: 812800 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI present.
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Intel MultiProcessor Specification v1.4
     Virtual Wire compatibility mode.
OEM ID:  TH  Product ID: OP64D       APIC at: 0xFEE00000
Processor #0 15:1 APIC version 16
Processor #1 15:1 APIC version 16
Processor #2 15:1 APIC version 16
Processor #3 15:1 APIC version 16
I/O APIC #4 Version 17 at 0xFEC00000.
I/O APIC #5 Version 17 at 0xD0000000.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Processors: 4
Allocating PCI resources starting at 60000000 (gap: 50000000:90000000)
swsusp: Registered nosave memory region: 000000000009b000 - 000000000009c000
swsusp: Registered nosave memory region: 000000000009c000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000c2000
swsusp: Registered nosave memory region: 00000000000c2000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 1040384
Kernel command line: root=/dev/sda7    acpi=off resume=/dev/sda2 
splash=silent acpi=off apm=off
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (d0000000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1808.475 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1269296k/4194304k available (3027k kernel code, 39360k reserved, 
1498k data, 228k init, 392320k highmem)
virtual kernel memory layout:
     fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0673000 - 0xc06ac000   ( 228 kB)
       .data : 0xc04f4d20 - 0xc066b72c   (1498 kB)
       .text : 0xc0200000 - 0xc04f4d20   (3027 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3618.99 BogoMIPS 
(lpj=7237988)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 
00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 
00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
CPU0: AMD Athlon(tm) or Opteron(tm) CPU - model unknow stepping 02
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3616.96 BogoMIPS 
(lpj=7233922)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 
00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 
00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) or Opteron(tm) CPU - model unknow stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/2 eip 3000
Initializing CPU#2
Calibrating delay using timer specific routine.. 3616.95 BogoMIPS 
(lpj=7233918)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 
00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 
00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: AMD Athlon(tm) or Opteron(tm) CPU - model unknow stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/3 eip 3000
Initializing CPU#3
Calibrating delay using timer specific routine.. 3616.95 BogoMIPS 
(lpj=7233912)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 
00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 
00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: AMD Athlon(tm) or Opteron(tm) CPU - model unknow stepping 02
Total of 4 processors activated (14469.87 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=-1 pin1=-1 apic2=0 pin2=0
...trying to set up timer (IRQ0) through the 8259A ...
..... (found pin 0) ...works.
Brought up 4 CPUs
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd6c1, last bus=135
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
PCI: Discovered peer bus 80
PCI: Bridge: 0000:00:09.0
   IO window: 2000-4fff
   MEM window: 50100000-bfffffff
   PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:0b.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
   IO window: 5000-5fff
   MEM window: c0000000-c00fffff
   PREFETCH window: c0100000-c01fffff
PCI: Bridge: 0000:00:0e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:80:09.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:80:0b.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:80:0c.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:80:0d.0
   IO window: 7000-7fff
   MEM window: d0100000-d01fffff
   PREFETCH window: c0200000-c02fffff
PCI: Bridge: 0000:85:00.0
   IO window: 8000-8fff
   MEM window: d0200000-d02fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:85:00.1
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:80:0e.0
   IO window: 8000-8fff
   MEM window: d0200000-d02fffff
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:09.0 to 64
PCI: Setting latency timer of device 0000:80:0b.0 to 64
PCI: Setting latency timer of device 0000:80:0c.0 to 64
PCI: Setting latency timer of device 0000:80:0d.0 to 64
PCI: Setting latency timer of device 0000:80:0e.0 to 64
PCI: Setting latency timer of device 0000:85:00.0 to 64
PCI: Setting latency timer of device 0000:85:00.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
0000:00:02.1 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:80:0b.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Found disabled HT MSI Mapping on 0000:80:0c.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Found disabled HT MSI Mapping on 0000:80:0d.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
Boot video device is 0000:01:06.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
PCI: Setting latency timer of device 0000:80:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0b.0:pcie00]
PCI: Setting latency timer of device 0000:80:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0c.0:pcie00]
PCI: Setting latency timer of device 0000:80:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0d.0:pcie00]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
PCI: Setting latency timer of device 0000:04:00.0 to 64
e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:80:b6:00:08:e5
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Setting latency timer of device 0000:04:00.1 to 64
e1000: 0000:04:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:80:b6:00:08:e4
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Setting latency timer of device 0000:84:00.0 to 64
e1000: 0000:84:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:80:b6:00:05:eb
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Setting latency timer of device 0000:84:00.1 to 64
e1000: 0000:84:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 
00:80:b6:00:05:ea
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth4: forcedeth.c: subsystem: 010de:cb84 bound to 0000:00:0a.0
PCI: Setting latency timer of device 0000:80:0a.0 to 64
forcedeth: using HIGHDMA
eth5: forcedeth.c: subsystem: 010de:cb84 bound to 0000:80:0a.0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 243
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f3) UDMA133 controller
     ide0: BM-DMA at 0x18a0-0x18a7, BIOS settings: hda:pio, hdb:pio
     ide1: BM-DMA at 0x18a8-0x18af, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
Probing IDE interface ide0...
Probing IDE interface ide1...
sata_nv 0000:00:07.0: version 3.5
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf8826480 ctl 0xf88264a0 bmdma 0x000118b0 
irq 11
ata2: SATA max UDMA/133 cmd 0xf8826580 ctl 0xf88265a0 bmdma 0x000118b8 
irq 11
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xf8828480 ctl 0xf88284a0 bmdma 0x000118c0 irq 5
ata4: SATA max UDMA/133 cmd 0xf8828580 ctl 0xf88285a0 bmdma 0x000118c8 irq 5
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: ASUS    DVD-E616A3T, 1.01, max UDMA/100
ata3.00: applying bridge limits
ata3.00: configured for UDMA/100
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3300622AS, 3.AAE, max UDMA/133
ata4.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: CD-ROM            ASUS     DVD-E616A3T      1.01 PQ: 0 ANSI: 5
ata3: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
sr0: scsi3-mmc drive: 15x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg0 type 5
scsi 3:0:0:0: Direct-Access     ATA      ST3300622AS      3.AA PQ: 0 ANSI: 5
ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
sd 3:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 sda3 < sda5 sda6 sda7 > sda4
sd 3:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg1 type 0
sata_nv 0000:80:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:80:07.0 to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xf882a480 ctl 0xf882a4a0 bmdma 0x00016000 irq 7
ata6: SATA max UDMA/133 cmd 0xf882a580 ctl 0xf882a5a0 bmdma 0x00016008 irq 7
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
sata_nv 0000:80:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:80:08.0 to 64
scsi6 : sata_nv
scsi7 : sata_nv
ata7: SATA max UDMA/133 cmd 0xf882c480 ctl 0xf882c4a0 bmdma 0x00016010 
irq 10
ata8: SATA max UDMA/133 cmd 0xf882c580 ctl 0xf882c5a0 bmdma 0x00016018 
irq 10
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
ieee1394: raw1394: /dev/raw1394 device initialized
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 10, io mem 0x50001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 7, io mem 0x50000000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
USB Universal Host Controller Interface driver v3.0
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon(tm) or Opteron(tm) CPU - model unknow 
processors (4 cpu cores) (version 2.00.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
Starting balanced_irq
Using IPI No-Shortcut mode
input: PS/2 Generic Mouse as /class/input/input1
ReiserFS: sda7: found reiserfs format "3.6" with standard journal
ReiserFS: sda7: using ordered data mode
ReiserFS: sda7: journal params: device sda7, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: sda7: checking transaction log (sda7)
ReiserFS: sda7: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 228k freed
net ethxx3: device_rename: sysfs_create_symlink failed (-17)
net ethxx4: device_rename: sysfs_create_symlink failed (-17)
net ethxx0: device_rename: sysfs_create_symlink failed (-17)
net eth0: device_rename: sysfs_create_symlink failed (-17)
net ethxx1: device_rename: sysfs_create_symlink failed (-17)
net ethxx5: device_rename: sysfs_create_symlink failed (-17)
net eth3: device_rename: sysfs_create_symlink failed (-17)
net eth1: device_rename: sysfs_create_symlink failed (-17)
net ethxx2: device_rename: sysfs_create_symlink failed (-17)
net eth4: device_rename: sysfs_create_symlink failed (-17)
net eth5: device_rename: sysfs_create_symlink failed (-17)
net eth2: device_rename: sysfs_create_symlink failed (-17)
ReiserFS: sda4: found reiserfs format "3.6" with standard journal
ReiserFS: sda4: using ordered data mode
ReiserFS: sda4: journal params: device sda4, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: sda4: checking transaction log (sda4)
ReiserFS: sda4: Using r5 hash to sort names
Adding 4200988k swap on /dev/sda2.  Priority:-1 extents:1 across:4200988k
eth0: no IPv6 routers present
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
eth0: no IPv6 routers present
op64d101:~ #


Regards,
jean-francois simon




