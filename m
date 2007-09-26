Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXIZSwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXIZSwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIZSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:52:10 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36129 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199AbXIZSwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:52:06 -0400
Date: Wed, 26 Sep 2007 21:52:02 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send
 performance
In-Reply-To: <20070926170718.GA4870@electric-eye.fr.zoreil.com>
Message-ID: <Pine.LNX.4.64.0709262137440.5856@limbo>
References: <Pine.LNX.4.64.0709261853110.5869@limbo>
 <20070926170718.GA4870@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, Francois Romieu wrote:

> The patch below is scheduled for inclusion before 2.6.23. Please try it and
> see if it makes a difference on top of 2.6.23-rc8 (full dmesg will be welcome
> too).

Thanks for the quick reply and fix. Unfortunately the fix didn't help in my 
case.


Iperf readings (send+receive) from

2.6.23-git (just before 6dccd... commit)
[  5]  0.0-10.0 sec    830 MBytes    694 Mbits/sec
[  4]  0.0-10.0 sec    842 MBytes    706 Mbits/sec

2.3.23-rc8 (clean)
[  4]  0.0-10.0 sec    323 MBytes    270 Mbits/sec
[  5]  0.0-10.0 sec    961 MBytes    802 Mbits/sec

2.3.23-rc8 and your patch
[  5]  0.0-10.1 sec    326 MBytes    270 Mbits/sec
[  4]  0.0-10.0 sec    958 MBytes    802 Mbits/sec

2.3.23-rc8 and 6dccd... reverted
[  5]  0.0-10.1 sec    830 MBytes    692 Mbits/sec
[  4]  0.0-10.0 sec    803 MBytes    673 Mbits/sec


and full dmesg from 2.3.23-rc8+your patch below. Dmesg from other versions 
differed only by random noise caused by minor variations on bogomips 
scores, async initializations etc. I can send them to you too, if you think 
they are useful.

===cut
Linux version 2.6.23-rc8-fix (root@limbo) (gcc version 4.2.0 (Gentoo 4.2.0 p1.4)) #2 SMP Wed Sep 26 21:24:43 EEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
 BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
 BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
 BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
 BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
1150MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f3640
NX (Execute Disable) protection: active
Entering add_active_range(0, 0, 524000) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524000
On node 0 totalpages: 524000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2301 pages used for memmap
  HighMem zone: 292323 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F77F0, 0014 (r0 IntelR)
ACPI: RSDT 7FEE3000, 0034 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FEE3080, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FEE3100, 4D1C (r1 INTELR AWRDACPI     1000 MSFT  3000000)
ACPI: FACS 7FEE0000, 0040
ACPI: MCFG 7FEE7F00, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FEE7E40, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: SSDT 7FEE8860, 0380 (r1  PmRef    CpuPm     3000 INTL 20041203)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
Processor #3 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
Built 1 zonelists in Zone order.  Total pages: 519907
Kernel command line: ro root=/dev/sdb2 netconsole=2001@10.0.0.1/eth0,2001@10.0.0.254/ video=vesafb:ypan,mtrr:3 vga=0x0376
netconsole: local port 2001
netconsole: local IP 10.0.0.1
netconsole: interface eth0
netconsole: remote port 2001
netconsole: remote IP 10.0.0.254
netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2403.193 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2072204k/2096000k available (3500k kernel code, 22736k reserved, 1264k data, 248k init, 1178496k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff81000 - 0xfffff000   ( 504 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc05af000 - 0xc05ed000   ( 248 kB)
      .data : 0xc046b218 - 0xc05a739c   (1264 kB)
      .text : 0xc0100000 - 0xc046b218   (3500 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4808.00 BogoMIPS (lpj=2404003)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 17k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4805.33 BogoMIPS (lpj=2402669)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Booting processor 2/2 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4805.34 BogoMIPS (lpj=2402672)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Booting processor 3/3 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4805.35 BogoMIPS (lpj=2402676)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
Total of 4 processors activated (19224.04 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  8712.000 MB/sec
xor: using function: pIII_sse (8712.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *5 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNK0] (IRQs *4 5 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNK1] (IRQs 4 5 *7 9 10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:06: ioport range 0x400-0x4bf has been reserved
pnp: 00:09: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0a: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:0a: iomem range 0x7ff00000-0x7fffffff has been reserved
pnp: 00:0a: iomem range 0x7fee0000-0x7fefffff could not be reserved
pnp: 00:0a: iomem range 0x0-0x9ffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: fdd00000-fddfffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: c000-cfff
  MEM window: fda00000-fdafffff
  PREFETCH window: fd900000-fd9fffff
PCI: Bridge: 0000:00:1c.4
  IO window: b000-bfff
  MEM window: fd800000-fd8fffff
  PREFETCH window: fde00000-fdefffff
PCI: Bridge: 0000:00:1e.0
  IO window: a000-afff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: fdb00000-fdbfffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
NTFS driver 2.1.28 [Flags: R/O DEBUG].
SGI XFS with ACLs, no debug enabled
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 15000k, total 16384k
vesafb: mode is 1600x1200x32, linelength=6400, pages=1
vesafb: protected mode interface info at c000:a316
vesafb: pmi: set display start = c00ca3a4, set palette = c00ca466
vesafb: scrolling: ypan using protected mode interface, yres_virtual=2400
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 200x75
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT 7FEE7F80, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
ACPI: SSDT 7FEE8440, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
ACPI: SSDT 7FEE85A0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20041203)
ACPI: SSDT 7FEE8700, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20041203)
ACPI Error (dswstate-0226): No result objects! State=f7e4ec00 [20070126]
ACPI Exception (dsutils-0642): AE_AML_NO_RETURN_VALUE, Missing or null operand [20070126]
ACPI Exception (dsutils-0735): AE_AML_NO_RETURN_VALUE, While creating Arg 1 [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_TZ_.THRM._TMP] (Node c212a658), AE_AML_NO_RETURN_VALUE
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
loop: module loaded
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 23 (level, low) -> IRQ 17
eth0: RTL8169sc/8110sc at 0xf881a000, 00:50:8d:b2:37:3e, XID 18000000 IRQ 17
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 18
eth1: RTL8169sc/8110sc at 0xf881c000, 00:50:8d:b2:37:3f, XID 18000000 IRQ 18
netconsole: device eth0 not up yet, forcing it
r8169: eth0: link down
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #0
r8169: eth0: link up
console [netcon0] enabled
netconsole: network logging started
Linux video capture interface: v2.00
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xf881e100 ctl 0x00000000 bmdma 0x00000000 irq 19
ata2: SATA max UDMA/133 cmd 0xf881e180 ctl 0x00000000 bmdma 0x00000000 irq 19
ata3: SATA max UDMA/133 cmd 0xf881e200 ctl 0x00000000 bmdma 0x00000000 irq 19
ata4: SATA max UDMA/133 cmd 0xf881e280 ctl 0x00000000 bmdma 0x00000000 irq 19
ata5: SATA max UDMA/133 cmd 0xf881e300 ctl 0x00000000 bmdma 0x00000000 irq 19
ata6: SATA max UDMA/133 cmd 0xf881e380 ctl 0x00000000 bmdma 0x00000000 irq 19
r8169: eth0: link down
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: HDS722525VLSA80, V36OA63A, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
r8169: eth0: link up
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLSA80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 >
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 sdc11 >
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 sdd11 >
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 cmd 0xf8820100 ctl 0x00000000 bmdma 0x00000000 irq 16
ata8: SATA max UDMA/133 cmd 0xf8820180 ctl 0x00000000 bmdma 0x00000000 irq 16
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:03:00.1 to 64
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x0001bf00 ctl 0x0001be02 bmdma 0x0001bb00 irq 20
ata10: PATA max UDMA/100 cmd 0x0001bd00 ctl 0x0001bc02 bmdma 0x0001bb08 irq 20
ata9.00: ATAPI: LITE-ON DVDRW SOHW-1673S, JS02, max UDMA/66
ata9.00: configured for UDMA/66
scsi 8:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1673S JS02 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 125x/125x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi CD-ROM sr0
sr 8:0:0:0: Attached scsi generic sg4 type 5
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 21, io mem 0xfdfff000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 17, io mem 0xfdffe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 22, io base 0x0000fe00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt 0000:00:1a.2[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 17, io base 0x0000fc00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000fa00
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
usb 7-2: new low speed USB device using uhci_hcd and address 2
usb 7-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 18 (level, low) -> IRQ 21
abituguru3: found Abit uGuru3, motherboard ID: 001A (unknown)
coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.2: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.3: Using undocumented features, absolute temperature might be wrong!
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid6: int32x1    933 MB/s
raid6: int32x2    960 MB/s
raid6: int32x4    750 MB/s
raid6: int32x8    675 MB/s
raid6: mmxx1     3039 MB/s
raid6: mmxx2     3531 MB/s
raid6: sse1x1    2062 MB/s
raid6: sse1x2    2753 MB/s
raid6: sse2x1    3761 MB/s
raid6: sse2x2    4382 MB/s
raid6: using algorithm sse2x2 (4382 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input3
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-2
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input4
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.1-2
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input5
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.1-2
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input6
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0xfdff4000 irq 18
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdd10 ...
md:  adding sdd10 ...
md: sdd9 has different UUID to sdd10
md: sdd8 has different UUID to sdd10
md: sdd7 has different UUID to sdd10
md: sdd6 has different UUID to sdd10
md: sdd5 has different UUID to sdd10
md: sdd2 has different UUID to sdd10
md:  adding sdc10 ...
md: sdc9 has different UUID to sdd10
md: sdc8 has different UUID to sdd10
md: sdc7 has different UUID to sdd10
md: sdc6 has different UUID to sdd10
md: sdc5 has different UUID to sdd10
md: sdc2 has different UUID to sdd10
md:  adding sdb10 ...
md: sdb9 has different UUID to sdd10
md: sdb8 has different UUID to sdd10
md: sdb7 has different UUID to sdd10
md: sdb6 has different UUID to sdd10
md: sdb5 has different UUID to sdd10
md: created md5
md: bind<sdb10>
md: bind<sdc10>
md: bind<sdd10>
md: running: <sdd10><sdc10><sdb10>
raid5: device sdd10 operational as raid disk 2
raid5: device sdc10 operational as raid disk 1
raid5: device sdb10 operational as raid disk 0
raid5: allocated 3164kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb10
 disk 1, o:1, dev:sdc10
 disk 2, o:1, dev:sdd10
md: considering sdd9 ...
md:  adding sdd9 ...
md: sdd8 has different UUID to sdd9
md: sdd7 has different UUID to sdd9
md: sdd6 has different UUID to sdd9
md: sdd5 has different UUID to sdd9
md: sdd2 has different UUID to sdd9
md:  adding sdc9 ...
md: sdc8 has different UUID to sdd9
md: sdc7 has different UUID to sdd9
md: sdc6 has different UUID to sdd9
md: sdc5 has different UUID to sdd9
md: sdc2 has different UUID to sdd9
md:  adding sdb9 ...
md: sdb8 has different UUID to sdd9
md: sdb7 has different UUID to sdd9
md: sdb6 has different UUID to sdd9
md: sdb5 has different UUID to sdd9
md: created md4
md: bind<sdb9>
md: bind<sdc9>
md: bind<sdd9>
md: running: <sdd9><sdc9><sdb9>
raid5: device sdd9 operational as raid disk 2
raid5: device sdc9 operational as raid disk 1
raid5: device sdb9 operational as raid disk 0
raid5: allocated 3164kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb9
 disk 1, o:1, dev:sdc9
 disk 2, o:1, dev:sdd9
md: considering sdd8 ...
md:  adding sdd8 ...
md: sdd7 has different UUID to sdd8
md: sdd6 has different UUID to sdd8
md: sdd5 has different UUID to sdd8
md: sdd2 has different UUID to sdd8
md:  adding sdc8 ...
md: sdc7 has different UUID to sdd8
md: sdc6 has different UUID to sdd8
md: sdc5 has different UUID to sdd8
md: sdc2 has different UUID to sdd8
md:  adding sdb8 ...
md: sdb7 has different UUID to sdd8
md: sdb6 has different UUID to sdd8
md: sdb5 has different UUID to sdd8
md: created md3
md: bind<sdb8>
md: bind<sdc8>
md: bind<sdd8>
md: running: <sdd8><sdc8><sdb8>
raid5: device sdd8 operational as raid disk 2
raid5: device sdc8 operational as raid disk 1
raid5: device sdb8 operational as raid disk 0
raid5: allocated 3164kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb8
 disk 1, o:1, dev:sdc8
 disk 2, o:1, dev:sdd8
md: considering sdd7 ...
md:  adding sdd7 ...
md: sdd6 has different UUID to sdd7
md: sdd5 has different UUID to sdd7
md: sdd2 has different UUID to sdd7
md:  adding sdc7 ...
md: sdc6 has different UUID to sdd7
md: sdc5 has different UUID to sdd7
md: sdc2 has different UUID to sdd7
md:  adding sdb7 ...
md: sdb6 has different UUID to sdd7
md: sdb5 has different UUID to sdd7
md: created md2
md: bind<sdb7>
md: bind<sdc7>
md: bind<sdd7>
md: running: <sdd7><sdc7><sdb7>
raid5: device sdd7 operational as raid disk 2
raid5: device sdc7 operational as raid disk 1
raid5: device sdb7 operational as raid disk 0
raid5: allocated 3164kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb7
 disk 1, o:1, dev:sdc7
 disk 2, o:1, dev:sdd7
md: considering sdd6 ...
md:  adding sdd6 ...
md: sdd5 has different UUID to sdd6
md: sdd2 has different UUID to sdd6
md:  adding sdc6 ...
md: sdc5 has different UUID to sdd6
md: sdc2 has different UUID to sdd6
md:  adding sdb6 ...
md: sdb5 has different UUID to sdd6
md: created md1
md: bind<sdb6>
md: bind<sdc6>
md: bind<sdd6>
md: running: <sdd6><sdc6><sdb6>
raid5: device sdd6 operational as raid disk 2
raid5: device sdc6 operational as raid disk 1
raid5: device sdb6 operational as raid disk 0
raid5: allocated 3164kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb6
 disk 1, o:1, dev:sdc6
 disk 2, o:1, dev:sdd6
md: considering sdd5 ...
md:  adding sdd5 ...
md: sdd2 has different UUID to sdd5
md:  adding sdc5 ...
md: sdc2 has different UUID to sdd5
md:  adding sdb5 ...
md: created md0
md: bind<sdb5>
md: bind<sdc5>
md: bind<sdd5>
md: running: <sdd5><sdc5><sdb5>
raid5: device sdd5 operational as raid disk 2
raid5: device sdc5 operational as raid disk 1
raid5: device sdb5 operational as raid disk 0
raid5: allocated 3164kB for md0
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sdb5
 disk 1, o:1, dev:sdc5
 disk 2, o:1, dev:sdd5
md: considering sdd2 ...
md:  adding sdd2 ...
md:  adding sdc2 ...
md: created md6
md: bind<sdc2>
md: bind<sdd2>
md: running: <sdd2><sdc2>
raid1: raid set md6 active with 2 out of 2 mirrors
md: ... autorun DONE.
ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
ReiserFS: sdb2: using ordered data mode
ReiserFS: sdb2: journal params: device sdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb2: checking transaction log (sdb2)
ReiserFS: sdb2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 248k freed
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
input: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver remote control as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/input/input7
usbcore: registered new interface driver cinergyT2
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
ReiserFS: dm-2: warning: read_super_block: found reiserfs format "3.6" with non-standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 32748, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
ReiserFS: dm-3: warning: read_super_block: found reiserfs format "3.6" with non-standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 32748, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
ReiserFS: dm-4: warning: read_super_block: found reiserfs format "3.6" with non-standard journal
ReiserFS: dm-4: using ordered data mode
ReiserFS: dm-4: journal params: device dm-4, size 32748, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-4: checking transaction log (dm-4)
ReiserFS: dm-4: Using r5 hash to sort names
ReiserFS: dm-5: found reiserfs format "3.6" with standard journal
ReiserFS: dm-5: using ordered data mode
ReiserFS: dm-5: journal params: device dm-5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-5: checking transaction log (dm-5)
ReiserFS: dm-5: Using r5 hash to sort names
FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
NTFS volume version 3.1.
Adding 4194296k swap on /dev/vg/swap.  Priority:1 extents:1 across:4194296k
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
r8169: eth0: link up
r8169: eth0: link down
r8169: eth0: link up
SysRq : Changing Loglevel
Loglevel set to 9
===cyt



//T
