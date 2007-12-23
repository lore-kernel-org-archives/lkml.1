Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXLWNMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXLWNMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXLWNMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:12:21 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50522 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXLWNMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:12:18 -0500
To: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.24-rc6-mm1] BUG() at check_irqs_on() in fs/buffer.c .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200712232212.GII90159.tFFVSOLFJHQOOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 23 Dec 2007 22:12:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I encountered a BUG().
I didn't encounter this bug for 2.6.24-rc5-mm1 .
I guess this bug was introduced between 2.6.24-rc5-mm1 and 2.6.24-rc6-mm1 .

I placed .config at http://I-love.SAKURA.ne.jp/tmp/config-2.6.24-rc6-mm1
The dmesg is attached below.

Regards.
-----
Linux version 2.6.24-rc6-mm1 (root@tomoyo) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Sun Dec 23 21:58:00 JST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
512MB LOWMEM available.
found SMP MP-table at 000f6cd0
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131072
DMI present.
Using APIC driver default
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 1FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 1FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 1FEFFFC0, 0040
ACPI: APIC 1FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:15 APIC version 17
Processor #1 6:15 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: ro root=LABEL=/ noapic nolapic console=tty console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 2327.355 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511068k/524288k available (3178k kernel code, 12560k reserved, 1656k data, 264k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc05c1000 - 0xc0603000   ( 264 kB)
      .data : 0xc041ab1c - 0xc05b8f10   (1656 kB)
      .text : 0xc0100000 - 0xc041ab1c   (3178 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4660.97 BogoMIPS (lpj=9321950)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 329 Objects with 31 Devices 84 Methods 9 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
ACPI: setting ELCR to 0200 (from 0e00)
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4656.63 BogoMIPS (lpj=9313272)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 08
Total of 2 processors activated (9317.61 BogoMIPS).
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 112 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 1 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................
Initialized 5/9 Regions 0/0 Fields 26/26 Buffers 22/23 Packages (338 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 37 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 14 15)
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
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2059k freed
Simple Boot Flag at 0x36 set to 0x80
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
pcnet32: PCnet/PCI II 79C970A at 0x1400, 00 0c 29 fc a9 60 assigned IRQ 10.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
console [netcon0] enabled
Linux version 2.6.24-rc6-mm1 (root@tomoyo) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Sun Dec 23 21:58:00 JST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
 BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
 BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
512MB LOWMEM available.
found SMP MP-table at 000f6cd0
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131072
  HighMem    131072 ->   131072
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   131072
DMI present.
Using APIC driver default
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 1FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 1FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 1FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 1FEFFFC0, 0040
ACPI: APIC 1FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:15 APIC version 17
Processor #1 6:15 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: ro root=LABEL=/ noapic nolapic console=tty console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 2327.355 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 511068k/524288k available (3178k kernel code, 12560k reserved, 1656k data, 264k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe14000 - 0xfffff000   (1964 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc05c1000 - 0xc0603000   ( 264 kB)
      .data : 0xc041ab1c - 0xc05b8f10   (1656 kB)
      .text : 0xc0100000 - 0xc041ab1c   (3178 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4660.97 BogoMIPS (lpj=9321950)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 329 Objects with 31 Devices 84 Methods 9 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
ACPI: setting ELCR to 0200 (from 0e00)
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4656.63 BogoMIPS (lpj=9313272)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 08
Total of 2 processors activated (9317.61 BogoMIPS).
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 112 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 1 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................
Initialized 5/9 Regions 0/0 Fields 26/26 Buffers 22/23 Packages (338 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 37 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 14 15)
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
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2059k freed
Simple Boot Flag at 0x36 set to 0x80
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
pcnet32: PCnet/PCI II 79C970A at 0x1400, 00 0c 29 fc a9 60 assigned IRQ 10.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
PIIX4: IDE port disabled
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:pio
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 24X DVD-ROM drive, 512kB Cache
Uniform CD-ROM driver Revision: 3.20
3ware Storage Controller device driver for Linux v1.26.02.002.
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=11
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 0:0:0:0: [sda] 12582912 512-byte hardware sectors (6442 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 12582912 512-byte hardware sectors (6442 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ieee1394: raw1394: /dev/raw1394 device initialized
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 9, io base 0x00001060
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
Freeing unused kernel memory: 264k freed
Red Hat nash version 5.1.19.6 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block device nodes.
Scanning and configuring dmraid supported devices
Creating root device.
end_request: I/O error, dev fd0, sector 0
Mounting root filesystem.
end_request: I/O error, dev fd0, sector 0
------------[ cut here ]------------
kernel BUG at fs/buffer.c:1282!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/block/sda/dev
Modules linked in:

Pid: 1, comm: init Not tainted (2.6.24-rc6-mm1 #1)
EIP: 0060:[<c017e8d3>] EFLAGS: 00010046 CPU: 0
EIP is at __find_get_block+0x1b/0x143
EAX: 00000086 EBX: 00000000 ECX: 00000400 EDX: 00000001
ESI: 00000001 EDI: df25c000 EBP: df4691c0 ESP: df823c60
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process init (pid: 1, ti=df822000 task=df820000 task.ti=df822000)
Stack: 00000001 00000000 c014b0e2 00000003 0000000a 0000c0d0 c13d9b00 c13d9be0 
       decdf000 c13d9b00 c014be29 00000000 00000001 df25c000 df4691c0 c017ec05 
       00000400 00000001 00000000 00000000 00000000 0000c0d0 0000c0d0 c0564798 
Call Trace:
 [<c014b0e2>] __rmqueue+0x13/0x174
 [<c014be29>] get_page_from_freelist+0x2d1/0x344
 [<c017ec05>] __getblk+0x21/0x295
 [<c014bf15>] __alloc_pages+0x67/0x2c5
 [<c01807e3>] __bread+0xa/0x78
 [<c01c20cb>] ext3_fill_super+0x138/0x1335
 [<c0218b72>] vsnprintf+0x407/0x445
 [<c0218c26>] snprintf+0x1c/0x1f
 [<c0194679>] disk_name+0x51/0x5b
 [<c01664f1>] get_sb_bdev+0xce/0x10c
 [<c014bf15>] __alloc_pages+0x67/0x2c5
 [<c0161b76>] __kmalloc+0x2f/0x9b
 [<c01c0b7e>] ext3_get_sb+0x12/0x16
 [<c01c1f93>] ext3_fill_super+0x0/0x1335
 [<c016603e>] vfs_kern_mount+0x39/0x72
 [<c01660b5>] do_kern_mount+0x2f/0xb4
 [<c0176a48>] do_mount+0x5bf/0x621
 [<c0175a5a>] mntput_no_expire+0x11/0x85
 [<c016c0b1>] link_path_walk+0x86/0x8f
 [<c0167229>] sys_stat64+0xf/0x23
 [<c016529a>] put_filp+0x3c/0x9a
 [<c014bbc1>] get_page_from_freelist+0x69/0x344
 [<c014bf15>] __alloc_pages+0x67/0x2c5
 [<c01756fa>] copy_mount_options+0x26/0x109
 [<c0176b17>] sys_mount+0x6d/0xaa
 [<c01038f2>] syscall_call+0x7/0xb
 =======================
Code: 24 04 e8 65 f9 fc ff 89 d8 5b 5e 5b 5e 5f 5d c3 55 89 c5 57 56 53 83 ec 2c 89 4c 24 04 8b 4c 24 40 89 14 24 9c 58 f6 c4 02 75 04 <0f> 0b eb fe fa b8 00 ff 5f c0 31 ff 64 8b 15 10 e1 5f c0 01 c2 
EIP: [<c017e8d3>] __find_get_block+0x1b/0x143 SS:ESP 0068:df823c60
---[ end trace a42f6a3546687747 ]---
Kernel panic - not syncing: Attempted to kill init!
