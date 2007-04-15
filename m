Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXDOKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXDOKOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXDOKOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:14:22 -0400
Received: from wasp.net.au ([203.190.192.17]:52197 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXDOKOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:14:19 -0400
Message-ID: <4621FAF0.7000705@wasp.net.au>
Date: Sun, 15 Apr 2007 14:14:08 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

G'day all,

All I have is a digital photo of this oops. (It's 3.5mb). I have serial console configured, but 
Murphy is watching me carefully and I just can't seem to reproduce it while logging the console output.

http://www.fnarfbargle.com/CIMG0736.JPG

I had it die the same way using plain 2.6.21-rc6 also.

This has happened about 7 times on this box now, it's always pretty much the same oops. The box has 
passed memtest and I've used it for a while in a slightly different configuration.

This oops is very difficult to reproduce and generally involves me running rsync -c or md5sum on a 
large series of files (usually 80-180GB) before it'll go *pop*.

The box is booted with PXE and runs an nfsroot. It's Debian 3.1. It has 2 SIL 3112 controllers in it 
with 4 WD 200GB ATA drives all on PATA->SATA bridges.

sd[abc] are all part of md0. md0 is ext3. sdd1 is formatted ext2. sdd has 5 bad blocks currently and 
I'm in the process of copying the data from sdd to md0 prior to reallocating those blocks. It's 
usually in rsync runs or post copy md5 checks that the box dies, but it can take 24 hours of beating 
to get it to panic. Unfortunately, it only panics when I'm not about and have my laptop with me 
(which I use to log the serial console).

dmesg, config and other hardware details attached.

I kinda need to get this box in service, but if there is any testing I can perform to help chase 
this down I'll leave it as-is.

Regards,
Brad


[    0.000000] Linux version 2.6.21-rc6-git5 (brad@srv) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 
Sat Apr 14 12:09:50 GST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009f400 end: 000000000009f400 
type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f400 size: 0000000000000c00 end: 00000000000a0000 
type: 2
[    0.000000] copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 
type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000003fef0000 end: 000000003fff0000 
type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fff0000 size: 0000000000003000 end: 000000003fff3000 
type: 4
[    0.000000] copy_e820_map() start: 000000003fff3000 size: 000000000000d000 end: 0000000040000000 
type: 3
[    0.000000] copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 
type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 
type: 2
[    0.000000] copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 
type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f52d0
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32497 pages, LIFO batch:7
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6D90, 0014 (r0 KM266 )
[    0.000000] ACPI: RSDT 3FFF3000, 002C (r1 KM266  AWRDACPI 42302E31 AWRD   0)
[    0.000000] ACPI: FACP 3FFF3040, 0074 (r1 KM266  AWRDACPI 42302E31 AWRD   0)
[    0.000000] ACPI: DSDT 3FFF30C0, 4E67 (r1 KM266  AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: APIC 3FFF7F40, 005A (r1 KM266  AWRDACPI 42302E31 AWRD   0)
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:8 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] Built 1 zonelists.  Total pages: 260081
[    0.000000] Kernel command line: BOOT_IMAGE=storage2 root=/dev/nfs 
nfsroot=/nfsroot-storage2,rsize=16384,wsize=16384 ip=both vga=1 nmi_watchdog=1 console=tty0 
console=ttyS0,38400
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1666.560 MHz processor.
[   35.821136] Console: colour VGA+ 80x50
[   36.915563] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   36.938672] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   36.994206] Memory: 1034968k/1048512k available (2211k kernel code, 12908k reserved, 1068k data, 
188k init, 131008k highmem)
[   37.027842] virtual kernel memory layout:
[   37.027843]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[   37.027845]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   37.027846]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   37.027847]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   37.027849]       .init : 0xc0436000 - 0xc0465000   ( 188 kB)
[   37.027850]       .data : 0xc0328f78 - 0xc0433fac   (1068 kB)
[   37.027852]       .text : 0xc0100000 - 0xc0328f78   (2211 kB)
[   37.160629] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   37.334977] Calibrating delay using timer specific routine.. 3335.94 BogoMIPS (lpj=16679707)
[   37.360448] Mount-cache hash table entries: 512
[   37.374219] CPU: After generic identify, caps: 0383fbff c1cbfbff 00000000 00000000 00000000 
00000000 00000000
[   37.374228] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)[   37.395646] CPU: 
L2 Cache: 256K (64 bytes/line)
[   37.409253] CPU: After all inits, caps: 0383fbff c1cbfbff 00000000 00000420 00000000 00000000 
00000000
[   37.409260] Intel machine check architecture supported.
[   37.424941] Intel machine check reporting enabled on CPU#0.
[   37.441675] Compat vDSO mapped to ffffe000.
[   37.454251] CPU: AMD Sempron(tm)   2400+ stepping 01
[   37.469351] Checking 'hlt' instruction... OK.
[   37.516415] ACPI: Core revision 20070126
[   37.533151] ENABLING IO-APIC IRQs
[   37.543466] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   37.774883] NET: Registered protocol family 16
[   37.788341] ACPI: bus type pci registered
[   37.841375] PCI: PCI BIOS revision 2.10 entry at 0xfbaf0, last bus=1
[   37.860451] PCI: Using configuration type 1
[   37.873020] Setting up standard PCI resources
[   37.902016] ACPI: Interpreter enabled
[   37.913072] ACPI: Using IOAPIC for interrupt routing
[   37.934965] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   37.949420] PCI: Probing PCI hardware (bus 00)
[   37.949850] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   37.968184] PCI: MSI-K8T-Neo2Fir, soundcard on
[   37.981734] Boot video device is 0000:01:00.0
[   37.981778] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   38.015522] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *15
[   38.036378] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[   38.056379] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12)
[   38.076363] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[   38.099889] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[   38.123417] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[   38.146950] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[   38.170485] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
[   38.194055] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[   38.209943] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[   38.225837] ACPI: PCI Interrupt Link [ALKC] (IRQs *22), disabled.
[   38.244705] ACPI: PCI Interrupt Link [ALKD] (IRQs *23)
[   38.260474] Linux Plug and Play Support v0.97 (c) Adam Belay
[   38.277475] pnp: PnP ACPI init
[   38.290662] pnp: PnP ACPI: found 11 devices
[   38.303385] SCSI subsystem initialized
[   38.314695] libata version 2.20 loaded.
[   38.314774] usbcore: registered new interface driver usbfs
[   38.331266] usbcore: registered new interface driver hub
[   38.347250] usbcore: registered new device driver usb
[   38.362503] PCI: Using ACPI for IRQ routing
[   38.375085] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   38.418084] pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
[   38.438465] Time: tsc clocksource has been installed.
[   38.453634] pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
[   38.474002] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[   38.494364] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
[   38.514734] pnp: 00:02: ioport range 0x4000-0x407f has been reserved
[   38.533797] pnp: 00:02: ioport range 0x5000-0x500f has been reserved
[   38.583116] PCI: Bridge: 0000:00:01.0
[   38.594136]   IO window: disabled.
[   38.604370]   MEM window: e8000000-e9ffffff
[   38.616942]   PREFETCH window: e0000000-e7ffffff
[   38.630826] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   38.630848] NET: Registered protocol family 2
[   38.734015] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)[   38.755672] TCP 
established hash table entries: 131072 (order: 8, 1048576 bytes)
[   38.780069] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[   38.800570] TCP: Hash tables configured (established 131072 bind 65536)
[   38.820411] TCP reno registered
[   38.854165] Machine check exception polling timer started.
[   38.870907] highmem bounce pool size: 64 pages
[   38.884414] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   38.903664] NTFS driver 2.1.28 [Flags: R/O].
[   38.916541] io scheduler noop registered
[   38.928347] io scheduler cfq registered (default)
[   38.942532] PCI: Bypassing VIA 8237 APIC De-Assert Message
[   38.959251] input: Power Button (FF) as /class/input/input0
[   38.975981] ACPI: Power Button (FF) [PWRF]
[   38.988361] input: Power Button (CM) as /class/input/input1
[   39.005100] ACPI: Power Button (CM) [PWRB]
[   39.017462] input: Sleep Button (CM) as /class/input/input2
[   39.034198] ACPI: Sleep Button (CM) [SLPB]
[   39.075104] Real Time Clock Driver v1.12ac
[   39.087461] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   39.114380] Hangcheck: Using get_cycles().
[   39.126725] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   39.150364] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   39.168730] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   39.187320] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   39.204508] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   39.221794] loop: loaded (max 8 devices)
[   39.233625] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[   39.251218] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[   39.271970] ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 23
[   39.289281] ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [ALKD] -> GSI 23 (level, low) -> IRQ 16
[   39.315956] eth0: VIA Rhine II at 0x1ee00, 00:11:09:95:ec:12, IRQ 16.
[   39.336530] eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1.
[   39.360782] tun: Universal TUN/TAP device driver, 1.6
[   39.376002] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   39.394692] sata_sil 0000:00:05.0: version 2.1
[   39.394714] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 17
[   39.417185] ata1: SATA max UDMA/100 cmd 0xf8814080 ctl 0xf881408a bmdma 0xf8814000 irq 17
[   39.441783] ata2: SATA max UDMA/100 cmd 0xf88140c0 ctl 0xf88140ca bmdma 0xf8814008 irq 17
[   39.466390] scsi0 : sata_sil
[   39.963089] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   39.993311] ata1.00: ATA-6: WDC WD2000JB-00DUA3, 75.13B75, max UDMA/100
[   40.013169] ata1.00: 390625000 sectors, multi 16: LBA48
[   40.029116] ata1.00: applying bridge limits
[   40.053259] ata1.00: configured for UDMA/100
[   40.066109] scsi1 : sata_sil
[   40.562638] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   40.592852] ata2.00: ATA-6: WDC WD2000JB-00DUA3, 75.13B75, max UDMA/100
[   40.612714] ata2.00: 390622887 sectors, multi 16: LBA48
[   40.628662] ata2.00: applying bridge limits
[   40.652809] ata2.00: configured for UDMA/100
[   40.665776] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 75.1 PQ: 0 ANSI: 5
[   40.690148] SCSI device sda: 390625000 512-byte hdwr sectors (200000 MB)
[   40.710267] sda: Write Protect is off
[   40.721290] sda: Mode Sense: 00 3a 00 00
[   40.721307] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.748239] SCSI device sda: 390625000 512-byte hdwr sectors (200000 MB)
[   40.768344] sda: Write Protect is off
[   40.779346] sda: Mode Sense: 00 3a 00 00
[   40.779361] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.806248]  sda: unknown partition table
[   40.833559] sd 0:0:0:0: Attached scsi disk sda
[   40.847002] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 75.1 PQ: 0 ANSI: 5
[   40.871371] SCSI device sdb: 390622887 512-byte hdwr sectors (199999 MB)
[   40.891496] sdb: Write Protect is off
[   40.902524] sdb: Mode Sense: 00 3a 00 00
[   40.902539] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.929485] SCSI device sdb: 390622887 512-byte hdwr sectors (199999 MB)
[   40.949602] sdb: Write Protect is off
[   40.960604] sdb: Mode Sense: 00 3a 00 00
[   40.960619] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   40.987506]  sdb: unknown partition table
[   41.024072] sd 1:0:0:0: Attached scsi disk sdb
[   41.037493] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 18
[   41.059844] ata3: SATA max UDMA/100 cmd 0xf8816080 ctl 0xf881608a bmdma 0xf8816000 irq 18
[   41.084429] ata4: SATA max UDMA/100 cmd 0xf88160c0 ctl 0xf88160ca bmdma 0xf8816008 irq 18
[   41.108984] scsi2 : sata_sil
[   41.601860] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   41.632079] ata3.00: ATA-6: WDC WD2000JB-00DUA3, 75.13B75, max UDMA/100
[   41.651929] ata3.00: 390625000 sectors, multi 16: LBA48
[   41.667875] ata3.00: applying bridge limits
[   41.692030] ata3.00: configured for UDMA/100
[   41.704868] scsi3 : sata_sil
[   42.201409] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   42.231623] ata4.00: ATA-6: WDC WD2000JB-00DUA3, 75.13B75, max UDMA/100
[   42.251474] ata4.00: 390622887 sectors, multi 16: LBA48
[   42.267422] ata4.00: applying bridge limits
[   42.291579] ata4.00: configured for UDMA/100
[   42.304490] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 75.1 PQ: 0 ANSI: 5
[   42.328849] SCSI device sdc: 390625000 512-byte hdwr sectors (200000 MB)
[   42.348971] sdc: Write Protect is off
[   42.359998] sdc: Mode Sense: 00 3a 00 00
[   42.360014] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.388342] SCSI device sdc: 390625000 512-byte hdwr sectors (200000 MB)
[   42.408452] sdc: Write Protect is off
[   42.419457] sdc: Mode Sense: 00 3a 00 00
[   42.419472] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.446357]  sdc: unknown partition table
[   42.477686] sd 2:0:0:0: Attached scsi disk sdc
[   42.491142] scsi 3:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 75.1 PQ: 0 ANSI: 5
[   42.515510] SCSI device sdd: 390622887 512-byte hdwr sectors (199999 MB)
[   42.535633] sdd: Write Protect is off
[   42.546661] sdd: Mode Sense: 00 3a 00 00
[   42.546676] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.573592] SCSI device sdd: 390622887 512-byte hdwr sectors (199999 MB)
[   42.593712] sdd: Write Protect is off
[   42.604715] sdd: Mode Sense: 00 3a 00 00
[   42.604730] SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.631616]  sdd: sdd1
[   42.659115] sd 3:0:0:0: Attached scsi disk sdd
[   42.672903] ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
[   42.690163] ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
[   42.716457] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   42.732193] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[   42.754463] ehci_hcd 0000:00:10.4: irq 19, io mem 0xeb081000
[   42.771463] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   42.794070] usb usb1: configuration #1 chosen from 1 choice
[   42.810860] hub 1-0:1.0: USB hub found
[   42.822146] hub 1-0:1.0: 8 ports detected
[   42.940924] USB Universal Host Controller Interface driver v3.0
[   42.958768] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
[   42.985044] uhci_hcd 0000:00:10.0: UHCI Host Controller
[   43.000775] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[   43.022987] uhci_hcd 0000:00:10.0: irq 19, io base 0x0000ea00
[   43.040366] usb usb2: configuration #1 chosen from 1 choice
[   43.057127] hub 2-0:1.0: USB hub found
[   43.068420] hub 2-0:1.0: 2 ports detected
[   43.180741] ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
[   43.207028] uhci_hcd 0000:00:10.1: UHCI Host Controller
[   43.222738] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[   43.244945] uhci_hcd 0000:00:10.1: irq 19, io base 0x0000eb00
[   43.262348] usb usb3: configuration #1 chosen from 1 choice
[   43.279110] hub 3-0:1.0: USB hub found
[   43.290384] hub 3-0:1.0: 2 ports detected
[   43.410579] ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
[   43.436863] uhci_hcd 0000:00:10.2: UHCI Host Controller
[   43.452608] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[   43.474835] uhci_hcd 0000:00:10.2: irq 19, io base 0x0000ec00
[   43.492218] usb usb4: configuration #1 chosen from 1 choice
[   43.509000] hub 4-0:1.0: USB hub found
[   43.520298] hub 4-0:1.0: 2 ports detected
[   43.640402] ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
[   43.666669] uhci_hcd 0000:00:10.3: UHCI Host Controller
[   43.682390] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[   43.704616] uhci_hcd 0000:00:10.3: irq 19, io base 0x0000ed00
[   43.721988] usb usb5: configuration #1 chosen from 1 choice
[   43.738755] hub 5-0:1.0: USB hub found
[   43.750054] hub 5-0:1.0: 2 ports detected
[   43.830164] usb 2-2: new low speed USB device using uhci_hcd and address 2
[   43.880215] Initializing USB Mass Storage driver...
[   44.031437] usb 2-2: configuration #1 chosen from 1 choice
[   45.029284] usbcore: registered new interface driver usb-storage
[   45.047326] USB Mass Storage support registered.
[   45.074716] input: Tangtop Generic USBPS2 as /class/input/input3
[   45.092777] input: USB HID v1.00 Keyboard [Tangtop Generic USBPS2] on usb-0000:00:10.0-2
[   45.138688] input: Tangtop Generic USBPS2 as /class/input/input4
[   45.156719] input: USB HID v1.00 Mouse [Tangtop Generic USBPS2] on usb-0000:00:10.0-2
[   45.180400] usbcore: registered new interface driver usbhid
[   45.197127] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   45.215742] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   45.234300] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   45.499003] serio: i8042 KBD port at 0x60,0x64 irq 1
[   45.514024] mice: PS/2 mouse device common for all mice
[   45.553763] input: AT Translated Set 2 keyboard as /class/input/input5
[   45.573377] i2c /dev entries driver
[   45.748768] raid6: int32x1    675 MB/s
[   45.928623] raid6: int32x2    898 MB/s
[   46.108530] raid6: int32x4    587 MB/s
[   46.288401] raid6: int32x8    535 MB/s
[   46.468196] raid6: mmxx1     1416 MB/s
[   46.648049] raid6: mmxx2     2507 MB/s
[   46.827944] raid6: sse1x1    1335 MB/s
[   47.007787] raid6: sse1x2    2209 MB/s
[   47.019066] raid6: using algorithm sse1x2 (2209 MB/s)
[   47.034237] md: raid6 personality registered for level 6
[   47.050185] md: raid5 personality registered for level 5
[   47.066135] md: raid4 personality registered for level 4
[   47.082085] raid5: automatically using best checksumming function: pIII_sse
[   47.147676]    pIII_sse  :  2447.200 MB/sec
[   47.160244] raid5: using function: pIII_sse (2447.200 MB/sec)
[   47.177502] TCP cubic registered
[   47.187224] NET: Registered protocol family 1
[   47.200331] NET: Registered protocol family 17
[   47.213711] Testing NMI watchdog ... OK.
[   47.425605] Using IPI Shortcut mode
[   47.938524] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   48.956320] Sending BOOTP requests . OK
[   49.006282] IP-Config: Got BOOTP answer from 192.168.2.1, my address is 192.168.2.86
[   49.029651] IP-Config: Complete:
[   49.038826]       device=eth0, addr=192.168.2.86, mask=255.255.255.0, gw=192.168.2.1,
[   49.062365]      host=192.168.2.86, domain=home, nis-domain=(none),
[   49.081274]      bootserver=192.168.2.1, rootserver=192.168.2.1, rootpath=
[   49.103168] md: Autodetecting RAID arrays.
[   49.115495] md: autorun ...
[   49.123908] md: ... autorun DONE.
[   49.133957] Looking up port of RPC 100003/2 on 192.168.2.1
[   49.156643] Looking up port of RPC 100005/1 on 192.168.2.1
[   49.204301] VFS: Mounted root (nfs filesystem) readonly.
[   49.220520] Freeing unused kernel memory: 188k freed
[   56.484745] md: md0 stopped.
[   56.606368] md: bind<sdb>
[   56.617198] md: bind<sdc>
[   56.629240] md: bind<sda>
[   56.641186] raid5: device sda operational as raid disk 0
[   56.661283] raid5: device sdc operational as raid disk 2
[   56.681411] raid5: device sdb operational as raid disk 1
[   56.702012] raid5: allocated 4203kB for md0
[   56.718301] raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
[   56.745455] RAID5 conf printout:
[   56.759362]  --- rd:4 wd:3
[   56.771700]  disk 0, o:1, dev:sda
[   56.785857]  disk 1, o:1, dev:sdb
[   56.800023]  disk 2, o:1, dev:sdc
[   61.269684] kjournald starting.  Commit interval 30 seconds
[   61.318268] EXT3 FS on md0, internal journal
[   61.336705] EXT3-fs: recovery complete.
[   61.352589] EXT3-fs: mounted filesystem with ordered data mode.

0000:00:00.0 Host bridge: VIA Technologies, Inc. VT8378 [KM400] Chipset Host Bridge
         Subsystem: VIA Technologies, Inc. VT8378 [KM400] Chipset Host Bridge
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- 
<PERR-
         Latency: 8
         Region 0: Memory at ea000000 (32-bit, prefetchable) [size=16M]
         Capabilities: [80] AGP version 3.5
                 Status: RQ=32 Iso- ArqSz=0 Cal=2 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- 
Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: e8000000-e9ffffff
         Prefetchable memory behind bridge: e0000000-e7ffffff
         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:05.0 RAID bus controller: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
         Subsystem: Silicon Image, Inc. (formerly CMD Technology Inc) Asus A7N8X
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin A routed to IRQ 17
         Region 0: I/O ports at e000 [size=8]
         Region 1: I/O ports at e100 [size=4]
         Region 2: I/O ports at e200 [size=8]
         Region 3: I/O ports at e300 [size=4]
         Region 4: I/O ports at e400 [size=16]
         Region 5: Memory at eb083000 (32-bit, non-prefetchable) [size=512]
         Expansion ROM at 50000000 [disabled] [size=512K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

0000:00:06.0 Unknown mass storage controller: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 
3112 [SATALink/SATARaid] Serial ATA Controller (rev 02)
         Subsystem: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3112 [SATALink/SATARaid] 
Serial ATA Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin A routed to IRQ 18
         Region 0: I/O ports at e500 [size=8]
         Region 1: I/O ports at e600 [size=4]
         Region 2: I/O ports at e700 [size=8]
         Region 3: I/O ports at e800 [size=4]
         Region 4: I/O ports at e900 [size=16]
         Region 5: Memory at eb080000 (32-bit, non-prefetchable) [size=512]
         Expansion ROM at 50080000 [disabled] [size=512K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

0000:00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81) 
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin A routed to IRQ 19
         Region 4: I/O ports at ea00 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81) 
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin A routed to IRQ 19
         Region 4: I/O ports at eb00 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81) 
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin B routed to IRQ 19
         Region 4: I/O ports at ec00 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81) 
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin B routed to IRQ 19
         Region 4: I/O ports at ed00 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 20 [EHCI])
         Subsystem: VIA Technologies, Inc. USB 2.0
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32, Cache Line Size: 0x10 (64 bytes)
         Interrupt: pin C routed to IRQ 19
         Region 0: Memory at eb081000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [K8T800 South]        Subsystem: 
VIA Technologies, Inc. VT8237 ISA bridge [K8T800 South]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 0
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio 
Controller (rev 60)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Interrupt: pin C routed to IRQ 0
         Region 0: I/O ports at 1000 [disabled] [size=256]
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 78)
         Subsystem: Micro-Star International Co., Ltd.: Unknown device 7061
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32 (750ns min, 2000ns max), Cache Line Size: 0x08 (32 bytes)
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at ee00 [size=256]
         Region 1: Memory at eb082000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:01:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX 4000 AGP 8x] (rev c1) 
(prog-if 00 [VGA])
         Subsystem: Unknown device 1682:201a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR-
         Latency: 32 (1250ns min, 250ns max)
         Interrupt: pin A routed to IRQ 15
         Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at e0000000 (32-bit, prefetchable) [size=128M]
         Expansion ROM at e9000000 [disabled] [size=128K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [44] AGP version 3.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- 
Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>


processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Sempron(tm)   2400+
stepping        : 1
cpu MHz         : 1666.560
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr 
sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 3335.94
clflush size    : 32

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0295-0296 : w83627hf
02f8-02ff : serial
03c0-03df : vga+
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-10ff : 0000:00:11.5
4000-407f : pnp 00:02
   4000-4003 : ACPI PM1a_EVT_BLK
   4004-4005 : ACPI PM1a_CNT_BLK
   4008-400b : ACPI PM_TMR
   4020-4023 : ACPI GPE0_BLK
5000-500f : pnp 00:02
e000-e007 : 0000:00:05.0
e100-e103 : 0000:00:05.0
e200-e207 : 0000:00:05.0
e300-e303 : 0000:00:05.0
e400-e40f : 0000:00:05.0
e500-e507 : 0000:00:06.0
e600-e603 : 0000:00:06.0
e700-e707 : 0000:00:06.0
e800-e803 : 0000:00:06.0
e900-e90f : 0000:00:06.0
ea00-ea1f : 0000:00:10.0
   ea00-ea1f : uhci_hcd
eb00-eb1f : 0000:00:10.1
   eb00-eb1f : uhci_hcd
ec00-ec1f : 0000:00:10.2
   ec00-ec1f : uhci_hcd
ed00-ed1f : 0000:00:10.3
   ed00-ed1f : uhci_hcd
ee00-eeff : 0000:00:12.0
   ee00-eeff : via-rhine

00000000-0009f3ff : System RAM
0009f400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf7ff : Video ROM
000d0000-000d47ff : Adapter ROM
000d5000-000d97ff : Adapter ROM
000da000-000dbfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
   00100000-00328f77 : Kernel code
   00328f78-00433fab : Kernel data
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
50000000-5007ffff : 0000:00:05.0
50080000-500fffff : 0000:00:06.0
e0000000-e7ffffff : PCI Bus #01
   e0000000-e7ffffff : 0000:01:00.0
e8000000-e9ffffff : PCI Bus #01
   e8000000-e8ffffff : 0000:01:00.0
   e9000000-e901ffff : 0000:01:00.0
ea000000-eaffffff : 0000:00:00.0
eb080000-eb0801ff : 0000:00:06.0
   eb080000-eb0801ff : sata_sil
eb081000-eb0810ff : 0000:00:10.4
   eb081000-eb0810ff : ehci_hcd
eb082000-eb0820ff : 0000:00:12.0
   eb082000-eb0820ff : via-rhine
eb083000-eb0831ff : 0000:00:05.0
   eb083000-eb0831ff : sata_sil
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved

            CPU0
   0:      25760   IO-APIC-edge      timer
   1:          8   IO-APIC-edge      i8042
   8:          4   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  16:      65554   IO-APIC-fasteoi   eth0
  17:       1886   IO-APIC-fasteoi   libata
  18:        932   IO-APIC-fasteoi   libata
  19:         62   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, 
uhci_hcd:usb5
NMI:      25846
LOC:          0
ERR:          0
MIS:          0

CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_X86_PC=y
CONFIG_MK7=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_HZ_100=y
CONFIG_HZ=100
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_SCSI=y
CONFIG_BLK_DEV_SD=y
CONFIG_ATA=y
CONFIG_SATA_SIL=y
CONFIG_SATA_ACPI=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_NETDEVICES=y
CONFIG_TUN=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_PCI=y
CONFIG_VIA_RHINE=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=2
CONFIG_SERIAL_8250_RUNTIME_UARTS=2
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_RTC=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ISA=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_W83627HF=y
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_HID=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=y
CONFIG_USB_HID=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
CONFIG_JBD=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_DNOTIFY=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_RAMFS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_TCP=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y


-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
