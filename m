Return-Path: <linux-kernel-owner+w=401wt.eu-S1764012AbXGFUB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764012AbXGFUB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762295AbXGFUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:01:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:64656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760809AbXGFUBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Jp219vfh7d92fqX3pCwPzVrnwX3o6JPt/uknCBiTU7jDnPONSkf8n52/zgdrlkhLnq8LoxtRZUPR0Q1Hlejh97Ul3iPeHEFPPtJkh5VgTnWQzu9fsS5d5oA9QBiUx9vAavYGQx5FBt4UfPsK1OMfOGa+qHgSGYwHLNz0q77yNkw=
Date: Fri, 6 Jul 2007 22:01:36 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [BUG] pata_ali not working on a 64 bit system
Message-ID: <20070706200136.GA6254@dreamland.darkstar.lan>
References: <20070706173605.GA6484@dreamland.darkstar.lan> <20070706184402.16d290b7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706184402.16d290b7@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Fri, Jul 06, 2007 at 06:44:02PM +0100, Alan Cox ha scritto: 
> On Fri, 6 Jul 2007 19:36:05 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
> 
> > Hello,
> > I found out that pata_ali is not working with a 64 bit kernel, while a
> > 32 bit kernel on the same machine works fine. I'm running a very recent
> > kernel (872aad45, somewhere after 2.6.22-rc7).
> > 
> > The problem is that as soon as the module is loaded I get a screaming
> > interrupt:
> 
> Can you report this with a full dmesg to the ACPI maintainers as that is
> where the IRQ routing is presumably coming from.

Ok, adding linux-acpi to CC.

> Are you using ACPI on both cases ?

By default it's enabled, but I've also tried with pci=noacpi without
success. That's why I reported the issue on linux-ide ;)

To recap, with ACPI enabled:

32bit: pata_ali gets IRQ 19, works
64bit: pata_ali gets IRQ 23, doesn't work, screaming interrupt

With pci=noacpi:

32bit: pata_ali gets IRQ 23, works
64bit: pata_ali gets IRQ 23, doesn't work, screaming interrupt

(as a side note: in this case pata_jmicron stops working...)

When ACPI is enabled IRQ mapping differs between 32 and 64 bit:

-ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 19
+ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 23

while with pci=noacpi the IRQ mapping for both 32 and 64 bit is the
following:

PCI: Probing PCI hardware
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Firmware left 0000:05:01.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/2810] at 0000:00:1f.0
PCI->APIC IRQ transform: 0000:00:01.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1a.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1a.1[B] -> IRQ 17
PCI->APIC IRQ transform: 0000:00:1a.7[C] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:1b.0[A] -> IRQ 22
PCI->APIC IRQ transform: 0000:00:1c.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1c.3[D] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1c.4[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:00:1d.0[A] -> IRQ 23
PCI->APIC IRQ transform: 0000:00:1d.1[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1d.2[C] -> IRQ 18
PCI->APIC IRQ transform: 0000:00:1d.7[A] -> IRQ 23
PCI->APIC IRQ transform: 0000:00:1f.2[B] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:1f.3[C] -> IRQ 18
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:03:00.0[A] -> IRQ 19
PCI->APIC IRQ transform: 0000:02:00.0[A] -> IRQ 16
PCI->APIC IRQ transform: 0000:02:00.1[B] -> IRQ 16
PCI->APIC IRQ transform: 0000:05:01.0[A] -> IRQ 22
PCI->APIC IRQ transform: 0000:05:02.0[A] -> IRQ 23
PCI->APIC IRQ transform: 0000:05:02.1[A] -> IRQ 23
PCI->APIC IRQ transform: 0000:05:03.0[A] -> IRQ 21

For reference the dmesg for 64 kernel with ACPI enabled is the
following:

Linux version 2.6.22-rc7-64-g872aad45-dirty (kronos@dreamland.darkstar.lan) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #14 SMP PREEMPT Tue Jul 3 21:18:19 CEST 2007
Command line: BOOT_IMAGE=linux-2.6.22-64 ro video=radeonfb:1024x768-8@60 lapic apic=verbose root=/dev/mapper/mainVol-root console=tty0 console=ttyS0,57600n8 break=modules
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
 BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff90000 (usable)
 BIOS-e820: 000000003ff90000 - 000000003ff9e000 (ACPI data)
 BIOS-e820: 000000003ff9e000 - 000000003ffe0000 (ACPI NVS)
 BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
ACPI: XSDT 3FF90100, 0054 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: FACP 3FF90290, 00F4 (r3 MSTEST OEMFACP  12000611 MSFT       97)
ACPI: DSDT 3FF905C0, 8F8C (r1  A0637 A0637000        0 INTL 20060113)
ACPI: FACS 3FF9E000, 0040
ACPI: APIC 3FF90390, 006C (r1 MSTEST OEMAPIC  12000611 MSFT       97)
ACPI: MCFG 3FF90400, 003C (r1 MSTEST OEMMCFG  12000611 MSFT       97)
ACPI: SLIC 3FF90440, 0176 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: OEMB 3FF9E040, 007B (r1 MSTEST AMI_OEM  12000611 MSFT       97)
ACPI: HPET 3FF99550, 0038 (r1 MSTEST OEMHPET  12000611 MSFT       97)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      156
    0:      256 ->   262032
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fd000 (        fee00000)
mapped IOAPIC to ffffffffff5fc000 (00000000fec00000)
swsusp: Registered nosave memory region: 000000000009c000 - 000000000009d000
swsusp: Registered nosave memory region: 000000000009d000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e4000
swsusp: Registered nosave memory region: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 33416 bytes of per cpu data
Built 1 zonelists.  Total pages: 255507
Kernel command line: BOOT_IMAGE=linux-2.6.22-64 ro video=radeonfb:1024x768-8@60 lapic apic=verbose root=/dev/mapper/mainVol-root console=tty0 console=ttyS0,57600n8 break=modules
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 2135.038 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
[...]
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
Memory: 1019908k/1048128k available (2296k kernel code, 27692k reserved, 1408k data, 220k init)
Calibrating delay using timer specific routine.. 4273.82 BogoMIPS (lpj=8547655)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1008 Objects with 75 Devices 286 Methods 36 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
result 16679977
Detected 16.679 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4270.23 BogoMIPS (lpj=8540475)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=26
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 11 Wake, Enabled 2 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................................................................................................................................................................................................
Initialized 35/36 Regions 44/44 Fields 51/51 Buffers 99/100 Packages (1017 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 1 _STA executions (examined 81 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Firmware left 0000:05:01.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
testing the IO APIC.......................

.................................... done.
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: 00:08: ioport range 0x290-0x297 has been reserved
pnp: 00:09: iomem range 0xffafe000-0xffb0cbff could not be reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:10: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:10: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:10: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:10: iomem range 0x100000-0x3fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 7000-9fff
  MEM window: ff200000-ff2fffff
  PREFETCH window: bfd00000-dfcfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
Time: tsc clocksource has been installed.
  MEM window: disabled.
  PREFETCH window: dfd00000-dfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: ff400000-ff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: a000-afff
  MEM window: ff300000-ff3fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-cfff
  MEM window: ff500000-ff9fffff
  PREFETCH window: dfe00000-dfefffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2980k freed
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
radeonfb_pci_register BEGIN
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
radeonfb (0000:01:00.0): Found 131072k of DDR 256 bits wide videoram
radeonfb (0000:01:00.0): mapped 16384k videoram
radeonfb: Found Intel x86 BIOS ROM Image
Retrieved PLL infos from ATOM BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=540.00 Mhz, System=520.00 MHz
PLL min 20000 max 50000
TMDS PLL from BIOS: 16500 b011c
index 3 port 2 conn 2 dac -1 ddc 0 tmds 0
index 4 port 2 conn 2 dac 1 ddc 0 tmds -1
index 7 port 1 conn 2 dac -1 ddc 1 tmds 1
Starting monitor auto detection...
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
radeonfb: I2C (port 1) ... not found
radeonfb: I2C (port 0) ... found CRT display
 * Connector 1 is DVI-I. Head -1, Monitor: None 
   ddc port: 1, dac: -1, tmds: 1
 * Connector 2 is DVI-I. Head 0, Monitor: CRT (EDID probed)
   ddc port: 0, dac: 1, tmds: 0
hStart = 1048, hEnd = 1184, hTotal = 1344
vStart = 771, vEnd = 777, vTotal = 806
h_total_disp = 0x7f00a7	   hsync_strt_wid = 0x910422
v_total_disp = 0x2ff0325	   vsync_strt_wid = 0x860302
pixclock = 15384
freq = 6500
freq = 6500, PLL min = 20000, PLL max = 50000
ref_div = 12, ref_clk = 2700, output_freq = 26000
ref_div = 12, ref_clk = 2700, output_freq = 26000
post div = 0x2
fb_div = 0x74
ppll_div_3 = 0x20074
Console: switching to colour frame buffer device 128x48
radeonfb (0000:01:00.0): ATI Radeon ]R 
radeonfb_pci_register END
ACPI Error (utglobal-0126): Unknown exception code: 0xFFFFFFF0 [20070126]
Linux agpgart interface v0.102 (c) Dave Jones
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
netconsole: not configured, aborting
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20000016900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata2: SATA max UDMA/133 cmd 0xffffc20000016980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata3: SATA max UDMA/133 cmd 0xffffc20000016a00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata4: SATA max UDMA/133 cmd 0xffffc20000016a80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata5: SATA max UDMA/133 cmd 0xffffc20000016b00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata6: SATA max UDMA/133 cmd 0xffffc20000016b80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 315
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3250820AS, 3.AAE, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3250820AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 cmd 0xffffc20000018100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
ata8: SATA max UDMA/133 cmd 0xffffc20000018180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 16
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x000000000001ac00 ctl 0x000000000001a882 bmdma 0x000000000001a400 irq 17
ata10: PATA max UDMA/100 cmd 0x000000000001a800 ctl 0x000000000001a482 bmdma 0x000000000001a408 irq 17
ata9.00: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL13, max UDMA/33
ata9.01: ATAPI: WAITEC  ALADAR/1, 0.010000, max UDMA/33
ata9.00: configured for UDMA/33
ata9.01: configured for UDMA/33
scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi generic sg1 type 5
scsi 8:0:1:0: CD-ROM            WAITEC   ALADAR/1         B1.5 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 16x/40x writer cd/rw xa/form2 cdda tray
sr 8:0:1:0: Attached scsi generic sg2 type 5
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 220k freed
Write protecting the kernel read-only data: 1156k
Loading, please wait...
WARNING: Not loading blacklisted module radeonfb
Spawning shell within the initramfs


BusyBox v1.01 (Debian 1:1.01-4) Built-in shell (ash)
Enter 'help' for a list of built-in commands.

/bin/sh: can't access tty; job control turned off
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
(initramfs) cat /proc/interrupts
           CPU0       CPU1       
  0:       5142          0   IO-APIC-edge      timer
  1:          8          0   IO-APIC-edge      i8042
  4:         50          0   IO-APIC-edge      serial
  6:          3          0   IO-APIC-edge      floppy
  7:          0          0   IO-APIC-edge      parport0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        113          0   IO-APIC-edge      i8042
 16:          0          0   IO-APIC-fasteoi   ahci
 17:         15          0   IO-APIC-fasteoi   libata
315:          6          0   PCI-MSI-edge      ahci
NMI:          0          0 
LOC:       5065       4243 
ERR:          0
(initramfs) modprobe pata_ali
ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 23
scsi10 : pata_ali
scsi11 : pata_ali
ata11: PATA max UDMA/133 cmd 0x000000000001c880 ctl 0x000000000001c802 bmdma 0x000000000001c080 irq 23
ata12: PATA max UDMA/133 cmd 0x000000000001c480 ctl 0x000000000001c402 bmdma 0x000000000001c088 irq 23
irq 23: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 <IRQ>  [<ffffffff80258407>] __report_bad_irq+0x30/0x72
 [<ffffffff80258620>] note_interrupt+0x1d7/0x21b
 [<ffffffff80258ccf>] handle_fasteoi_irq+0xaf/0xd8
 [<ffffffff8020c50c>] do_IRQ+0xf4/0x164
 [<ffffffff80208631>] mwait_idle+0x0/0x51
 [<ffffffff80209bc6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80208631>] mwait_idle+0x0/0x51
 [<ffffffff80208677>] mwait_idle+0x46/0x51
 [<ffffffff802085b5>] cpu_idle+0x95/0xcc
 [<ffffffff805bca4e>] start_kernel+0x2d3/0x2df
 [<ffffffff805bc138>] _sinittext+0x138/0x13c

handlers:
[<ffffffff803b6dcf>] (ata_interrupt+0x0/0x204)
Disabling IRQ #23
ata12.00: qc timeout (cmd 0xf8)
ata12.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (240121728)
ata12.00: ATA-7: Maxtor 6Y120L0, YAR41VW0, max UDMA/133
ata12.00: 240121728 sectors, multi 16: LBA 
ata12.01: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (20044080)
ata12.01: ATA-4: QUANTUM FIREBALLlct10 10, A03.0900, max UDMA/66
ata12.01: 20044080 sectors, multi 16: LBA 
ata12.01: limited to UDMA/33 due to 40-wire cable
ata12.00: failed to set xfermode (err_mask=0x40)
ata12: failed to recover some devices, retrying in 5 secs


Luca
-- 
#include <stdio.h> 
int main(void) {printf("\t\t\b\b\b\b\b\b");
printf("\t\t\b\b\b\b\b\b");return 0;}
