Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbXGILX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbXGILX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXGILXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:23:19 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:41356 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752016AbXGILXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:23:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 07:23:14 EDT
X-YMail-OSG: 1FNdtAsVM1kMwKAvPviWJ_Pw0927QL.0WK5PG8yF3jcl3YKdqQZoBiWrwPxxxkdpSlJbWVeDbkFLV6igv7J4kk5tmEcYd0c_xe4KKZORk7As26lFKA--
Subject: Re: [BUG] IT8212 libata driver *still* hard-freezes system on boot
	on 2.6.22 final.
From: Rodney Gordon II <meff@spherevision.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20070709104930.4e26f38f@the-village.bc.nu>
References: <1183944204.8932.8.camel@ghreen.sphere>
	 <20070709104930.4e26f38f@the-village.bc.nu>
Content-Type: multipart/mixed; boundary="=-UuY/stdL3LF8NLOeqOc9"
Date: Mon, 09 Jul 2007 06:16:22 -0500
Message-Id: <1183979782.4301.4.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UuY/stdL3LF8NLOeqOc9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-07-09 at 10:49 +0100, Alan Cox wrote:
> On Sun, 08 Jul 2007 20:23:24 -0500
> Rodney Gordon II <meff@spherevision.org> wrote:
> 
> > Have been quite busy, and I regret I haven't tried a rc kernel in
> > awhile, but, this bug has gone un-fixed still.. Thought I'd throw in
> > another "heads up"..
> > 
> > 2.6.22 hang: http://spherevision.org/sync/visual/itelock.jpg
> > lspci -vvv: http://spherevision.org/sync/tmp/lspci.out
> > 
> > Pentium-D 830 3.0GHz Dualcore on a ASUS P5LD2 with latest bios rev.
> > 1804.
> > 
> > SysRq does not work when this locks up.
> > 
> > Patches, info, things to try, anything is welcome, I am available for
> > awhile now and will try anything to get this working.
> 
> I'm at a bit of a loss on this one I'm afraid - it seems to be specific
> to a couple of boards and every IT821x box I can lay my paws on works
> beautifully.
> 
> It would be useful to know if a kernel built with no DMA support for the
> IT8212 behaved as that might give us a clue about what is choking. If you
> look in drivers/ata/pata_it821x.c:it821x_init_one you'll see a pair of
> lines that say
> 
> 	mwdma = 0x1f,
> 	udma_mask = 0x7f
> 
> 
> remove, rebuild and report..

Alright.

Attachment [0] is a successful boot with those lines removed. (This a
good thing or a bad thing? :)

Attachment [1] is a successful boot with the old ata subsystem using the
IT8212.

Hope this helps.

-r

--=-UuY/stdL3LF8NLOeqOc9
Content-Disposition: attachment; filename=dmesg.workinglibata
Content-Type: text/plain; name=dmesg.workinglibata; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.22-libatawork (meff@ghreen) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #4 SMP PREEMPT Mon Jul 9 06:02:02 CDT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005ffa0000 (usable)
 BIOS-e820: 000000005ffa0000 - 000000005ffae000 (ACPI data)
 BIOS-e820: 000000005ffae000 - 000000005ffe0000 (ACPI NVS)
 BIOS-e820: 000000005ffe0000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
639MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 393120) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   393120
early_node_map[1] active PFN ranges
    0:        0 ->   393120
On node 0 totalpages: 393120
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 1279 pages used for memmap
  HighMem zone: 162465 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FACD0, 0024 (r2 ACPIAM)
ACPI: XSDT 5FFA0100, 0044 (r1 A M I  OEMXSDT  10000630 MSFT       97)
ACPI: FACP 5FFA0290, 00F4 (r3 A M I  OEMFACP  10000630 MSFT       97)
ACPI: DSDT 5FFA0410, 8318 (r1  A0227 A0227000        0 INTL  2002026)
ACPI: FACS 5FFAE000, 0040
ACPI: APIC 5FFA0390, 0080 (r1 A M I  OEMAPIC  10000630 MSFT       97)
ACPI: OEMB 5FFAE040, 0066 (r1 A M I  AMI_OEM  10000630 MSFT       97)
ACPI: MCFG 5FFA8730, 003C (r1 A M I  OEMMCFG  10000630 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 70000000 (gap: 60000000:9fb80000)
Built 1 zonelists.  Total pages: 390049
Kernel command line: root=/dev/sda2 ro 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0549000 soft=c0547000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3010.923 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1553512k/1572480k available (2948k kernel code, 17828k reserved, 1151k data, 240k init, 654976k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0506000 - 0xc0542000   ( 240 kB)
      .data : 0xc03e13ad - 0xc0500fcc   (1151 kB)
      .text : 0xc0100000 - 0xc03e13ad   (2948 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 6024.53 BogoMIPS (lpj=3012265)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000649d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000649d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c054a000 soft=c0548000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6020.54 BogoMIPS (lpj=3010274)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000649d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000649d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
Total of 2 processors activated (12045.07 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 165 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
pnp: 00:08: ioport range 0x290-0x297 has been reserved
pnp: 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved
pnp: 00:0f: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0f: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0f: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x100000-0x5fffffff could not be reserved
ACPI: PCI Interrupt 0000:01:02.2[B] -> GSI 23 (level, low) -> IRQ 16
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[cdddf800-cdddffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: cdf00000-cfffffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: d000-dfff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: c000-cfff
  MEM window: cde00000-cdefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-bfff
  MEM window: cdd00000-cddfffff
  PREFETCH window: 70000000-700fffff
Time: acpi_pm clocksource has been installed.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
DLM (built Jul  8 2007 19:35:52) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/O].
fuse init (API version 7.8)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:04:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI Warning (tbutils-0158): Incorrect checksum in table [SSDT] -  3C, should be 43 [20070126]
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  6B, should be 5E [20070126]
ACPI: SSDT 5FFA8770, 02E3 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: SSDT 5FFA8A60, 02DA (r1    AMI   CPU2PM        1 INTL 20060113)
ACPI: Processor [CPU2] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.14 addr 0xcdefc000 irq 18 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:13:d4:17:ec:35
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 16
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8826d00 ctl 0x00000000 bmdma 0x00000000 irq 16
ata2: SATA max UDMA/133 cmd 0xf8826d80 ctl 0x00000000 bmdma 0x00000000 irq 16
ata3: SATA max UDMA/133 cmd 0xf8826e00 ctl 0x00000000 bmdma 0x00000000 irq 16
ata4: SATA max UDMA/133 cmd 0xf8826e80 ctl 0x00000000 bmdma 0x00000000 irq 16
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c01510f7e69]
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: WDC WD5000AAKS-65TMA0, 12.01C01, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 12.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ata_piix 0000:00:1f.1: version 2.11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata5.00: ATAPI: LITE-ON DVDRW SOHW-1693S, KC4B, max UDMA/66
ata5.00: configured for UDMA/66
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KC4B PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg2 type 5
pata_it821x: controller in pass through mode.
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:01:03.0 to 64
scsi6 : pata_it821x
scsi7 : pata_it821x
ata7: PATA max PIO4 cmd 0x0001b800 ctl 0x0001b402 bmdma 0x0001a400 irq 20
ata8: PATA max PIO4 cmd 0x0001b000 ctl 0x0001a802 bmdma 0x0001a408 irq 20
ata7.00: ATAPI: LITE-ON DVDRW LH-20A1P, KL0N, max UDMA/66
ata7.00: configured for PIO4
scsi 6:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1P   KL0N PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
sr 6:0:0:0: Attached scsi CD-ROM sr1
sr 6:0:0:0: Attached scsi generic sg3 type 5
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xcdcff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006400
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00007000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
gameport: EMU10K1 is pci0000:01:02.1/gameport0, io 0xa000, speed 917kHz
input: AT Translated Set 2 keyboard as /class/input/input2
input: PC Speaker as /class/input/input3
input: PS2++ Logitech MX Mouse as /class/input/input4
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 16
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 22 (level, low) -> IRQ 19
Installing spdif_bug patch: Audigy 2 ZS [SB0350]
ALSA device list:
  #0: Audigy 2 ZS [SB0350] (rev.4, serial:0x20021102) at 0x9800, irq 19
IPv4 over IPv4 tunneling driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
SCTP: Hash tables configured (established 65536 bind 43690)
Starting balanced_irq
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 240k freed
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 4-2: new low speed USB device using uhci_hcd and address 2
Initializing USB Mass Storage driver...
usb 4-2: configuration #1 chosen from 1 choice
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb 2-2.4: new low speed USB device using uhci_hcd and address 3
usb 2-2.4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x6004
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
usbcore: registered new interface driver hiddev
hiddev96: USB HID v1.10 Device [American Power Conversion Smart-UPS 750 FW:651.12.D USB FW:4.2] on usb-0000:00:1d.2-2
usb-storage: device scan complete
scsi 8:0:0:0: Direct-Access     COWON    iAUDIO U2        0100 PQ: 0 ANSI: 4
sd 8:0:0:0: [sdc] 1025088 2048-byte hardware sectors (2099 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: 3e 00 00 00
sd 8:0:0:0: [sdc] Assuming drive cache: write through
sd 8:0:0:0: [sdc] 1025088 2048-byte hardware sectors (2099 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: 3e 00 00 00
sd 8:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 8:0:0:0: [sdc] Attached SCSI removable disk
sd 8:0:0:0: Attached scsi generic sg4 type 0
drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
drivers/hid/usbhid/hid-core.c: timeout initializing reports
input: Logitech Logitech Dual Action as /class/input/input5
input: USB HID v1.10 Joystick [Logitech Logitech Dual Action] on usb-0000:00:1d.0-2.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Adding 3903752k swap on /dev/sda1.  Priority:-1 extents:1 across:3903752k
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NTFS volume version 3.1.
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)

--=-UuY/stdL3LF8NLOeqOc9
Content-Disposition: attachment; filename=dmesg.oldlayer
Content-Type: text/plain; name=dmesg.oldlayer; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.22-ghreen-meff1 (meff@ghreen) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #2 SMP PREEMPT Mon Jul 9 05:46:50 CDT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005ffa0000 (usable)
 BIOS-e820: 000000005ffa0000 - 000000005ffae000 (ACPI data)
 BIOS-e820: 000000005ffae000 - 000000005ffe0000 (ACPI NVS)
 BIOS-e820: 000000005ffe0000 - 0000000060000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
639MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 393120) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   393120
early_node_map[1] active PFN ranges
    0:        0 ->   393120
On node 0 totalpages: 393120
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 1279 pages used for memmap
  HighMem zone: 162465 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FACD0, 0024 (r2 ACPIAM)
ACPI: XSDT 5FFA0100, 0044 (r1 A M I  OEMXSDT  10000630 MSFT       97)
ACPI: FACP 5FFA0290, 00F4 (r3 A M I  OEMFACP  10000630 MSFT       97)
ACPI: DSDT 5FFA0410, 8318 (r1  A0227 A0227000        0 INTL  2002026)
ACPI: FACS 5FFAE000, 0040
ACPI: APIC 5FFA0390, 0080 (r1 A M I  OEMAPIC  10000630 MSFT       97)
ACPI: OEMB 5FFAE040, 0066 (r1 A M I  AMI_OEM  10000630 MSFT       97)
ACPI: MCFG 5FFA8730, 003C (r1 A M I  OEMMCFG  10000630 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 70000000 (gap: 60000000:9fb80000)
Built 1 zonelists.  Total pages: 390049
Kernel command line: root=/dev/sda2 ro 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0559000 soft=c0557000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3010.897 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1553424k/1572480k available (2992k kernel code, 17916k reserved, 1163k data, 244k init, 654976k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0515000 - 0xc0552000   ( 244 kB)
      .data : 0xc03ec295 - 0xc050f04c   (1163 kB)
      .text : 0xc0100000 - 0xc03ec295   (2992 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 6024.50 BogoMIPS (lpj=3012251)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000649d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000649d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 15k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c055a000 soft=c0558000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6020.53 BogoMIPS (lpj=3010267)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000649d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000649d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) D CPU 3.00GHz stepping 04
Total of 2 processors activated (12045.03 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 105 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
pnp: 00:08: ioport range 0x290-0x297 has been reserved
pnp: 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0e: iomem range 0xf0000000-0xf3ffffff has been reserved
pnp: 00:0f: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0f: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0f: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0f: iomem range 0x100000-0x5fffffff could not be reserved
ACPI: PCI Interrupt 0000:01:02.2[B] -> GSI 23 (level, low) -> IRQ 16
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[cdddf800-cdddffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: cdf00000-cfffffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: d000-dfff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: c000-cfff
  MEM window: cde00000-cdefffff
Time: acpi_pm clocksource has been installed.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-bfff
  MEM window: cdd00000-cddfffff
  PREFETCH window: 70000000-700fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
DLM (built Jul  8 2007 19:35:52) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/O].
fuse init (API version 7.8)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:04:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI Warning (tbutils-0158): Incorrect checksum in table [SSDT] -  3C, should be 43 [20070126]
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  6B, should be 5E [20070126]
ACPI: SSDT 5FFA8770, 02E3 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: SSDT 5FFA8A60, 02DA (r1    AMI   CPU2PM        1 INTL 20060113)
ACPI: Processor [CPU2] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.14 addr 0xcdefc000 irq 18 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:13:d4:17:ec:35
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
IT8212: IDE controller at PCI slot 0000:01:03.0
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 20 (level, low) -> IRQ 19
IT8212: chipset revision 17
it821x: controller in pass through mode.
IT8212: 100% native mode on irq 19
    ide0: BM-DMA at 0xa400-0xa407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xa408-0xa40f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: LITE-ON DVDRW LH-20A1P, ATAPI CD/DVD-ROM drive
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c01510f7e69]
hda: selected mode 0x44
ide0 at 0xb800-0xb807,0xb402 on irq 19
Probing IDE interface ide1...
Probing IDE interface ide1...
ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 16
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8826d00 ctl 0x00000000 bmdma 0x00000000 irq 16
ata2: SATA max UDMA/133 cmd 0xf8826d80 ctl 0x00000000 bmdma 0x00000000 irq 16
ata3: SATA max UDMA/133 cmd 0xf8826e00 ctl 0x00000000 bmdma 0x00000000 irq 16
ata4: SATA max UDMA/133 cmd 0xf8826e80 ctl 0x00000000 bmdma 0x00000000 irq 16
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD5000KS-00MNB0, 07.02E07, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: WDC WD5000AAKS-65TMA0, 12.01C01, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000KS-00M 07.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-6 12.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xcdcff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 19, io base 0x00006000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 20, io base 0x00006400
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00007000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
gameport: EMU10K1 is pci0000:01:02.1/gameport0, io 0xa000, speed 917kHz
input: AT Translated Set 2 keyboard as /class/input/input2
input: PC Speaker as /class/input/input3
input: PS2++ Logitech MX Mouse as /class/input/input4
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23 (level, low) -> IRQ 16
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 22 (level, low) -> IRQ 22
Installing spdif_bug patch: Audigy 2 ZS [SB0350]
ALSA device list:
  #0: Audigy 2 ZS [SB0350] (rev.4, serial:0x20021102) at 0x9800, irq 22
IPv4 over IPv4 tunneling driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
SCTP: Hash tables configured (established 65536 bind 43690)
Starting balanced_irq
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 244k freed
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 4-2: new low speed USB device using uhci_hcd and address 2
Initializing USB Mass Storage driver...
usb 4-2: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb 2-2.4: new low speed USB device using uhci_hcd and address 3
usb 2-2.4: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x6004
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
hiddev96: USB HID v1.10 Device [American Power Conversion Smart-UPS 750 FW:651.12.D USB FW:4.2] on usb-0000:00:1d.2-2
usb-storage: device scan complete
scsi 4:0:0:0: Direct-Access     COWON    iAUDIO U2        0100 PQ: 0 ANSI: 4
sd 4:0:0:0: [sdc] 1025088 2048-byte hardware sectors (2099 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 3e 00 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
sd 4:0:0:0: [sdc] 1025088 2048-byte hardware sectors (2099 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 3e 00 00 00
sd 4:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg2 type 0
drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
drivers/hid/usbhid/hid-core.c: timeout initializing reports
input: Logitech Logitech Dual Action as /class/input/input5
input: USB HID v1.10 Joystick [Logitech Logitech Dual Action] on usb-0000:00:1d.0-2.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Adding 3903752k swap on /dev/sda1.  Priority:-1 extents:1 across:3903752k
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NTFS volume version 3.1.
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)

--=-UuY/stdL3LF8NLOeqOc9--

