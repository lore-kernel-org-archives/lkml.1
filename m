Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbXEIMtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbXEIMtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXEIMs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:48:56 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:40666 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXEIMsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:48:55 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 08:48:54 EDT
Date: Wed, 9 May 2007 14:41:02 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: BUG: soft lockup detected on CPU#0!
Message-ID: <20070509124101.GT22709@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got this after starting 2.6.21.1 (see below, I posted complete dmesg
output):

Linux version 2.6.21.1 (root@mail.charite.de) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Thu May 3 15:48:38 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000100 size: 000000000009f300 end: 000000000009f400 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f400 size: 0000000000000c00 end: 00000000000a0000 type: 2
copy_e820_map() start: 0000000000100000 size: 00000000bfefa000 end: 00000000bfffa000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000bfffa000 size: 0000000000006000 end: 00000000c0000000 type: 3
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 00000000fee10000 type: 2
copy_e820_map() start: 00000000ffc00000 size: 0000000000400000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfffa000 (usable)
 BIOS-e820: 00000000bfffa000 - 00000000c0000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
2175MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f4fd0
Entering add_active_range(0, 0, 786426) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   786426
early_node_map[1] active PFN ranges
    0:        0 ->   786426
On node 0 totalpages: 786426
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 4351 pages used for memmap
  HighMem zone: 552699 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F4F70, 0014 (r0 COMPAQ)
ACPI: RSDT BFFFA000, 0030 (r1 COMPAQ P31             2   “     162E)
ACPI: FACP BFFFA040, 0074 (r1 COMPAQ P31             2   “     162E)
ACPI: DSDT BFFFA240, 318A (r1 COMPAQ     DSDT        1 MSFT  100000B)
ACPI: FACS BFFFA0C0, 0040
ACPI: APIC BFFFA100, 00AC (r1 COMPAQ 00000083        2             0)
ACPI: SPCR BFFFA1C0, 0050 (r1 COMPAQ SPCRRBSU        1   “     162E)
ACPI: PM-Timer IO Port: 0x920
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
ACPI: IOAPIC (id[0x05] address[0xfec03000] gsi_base[48])
IOAPIC[3]: apic_id 5, version 17, address 0xfec03000, GSI 48-63
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 4 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
Built 1 zonelists.  Total pages: 780283
Kernel command line: boot=/dev/cciss/c0d0 root=/dev/cciss/c0d0p6 panic=10
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec01000)
mapped IOAPIC to ffffa000 (fec02000)
mapped IOAPIC to ffff9000 (fec03000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0404000 soft=c0400000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2799.258 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3115712k/3145704k available (2137k kernel code, 28900k reserved, 702k data, 192k init, 2228200k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03cb000 - 0xc03fb000   ( 192 kB)
      .data : 0xc03167a9 - 0xc03c60d4   ( 702 kB)
      .text : 0xc0100000 - 0xc03167a9   (2137 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5600.87 BogoMIPS (lpj=2800437)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0405000 soft=c0401000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5597.53 BogoMIPS (lpj=2798769)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
Booting processor 2/6 eip 2000
CPU 2 irqstacks, hard=c0406000 soft=c0402000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5597.66 BogoMIPS (lpj=2798830)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
Booting processor 3/7 eip 2000
CPU 3 irqstacks, hard=c0407000 soft=c0403000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5597.68 BogoMIPS (lpj=2798842)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
Total of 4 processors activated (22393.75 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 1060 cycles TSC warp between CPUs, turning off TSC clock.
Brought up 4 CPUs
migration_cost=1000,2000
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0094, last bus=6
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:03.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:01)
PCI: Probing PCI hardware (bus 01)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:04)
PCI: Probing PCI hardware (bus 04)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
ACPI: PCI Interrupt Link [IUSB] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN16] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN17] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN18] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN19] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN20] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN21] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN22] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN23] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN24] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN25] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN26] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN27] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN28] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN29] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN30] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN31] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN32] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN33] (IRQs 4 5 7 10 11 15) *0, disabled.
ACPI: PCI Interrupt Link [IN34] (IRQs 4 5 7 10 11 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Device 0000:00:00.0 not found by BIOS
PCI: Device 0000:00:00.1 not found by BIOS
PCI: Device 0000:00:00.2 not found by BIOS
PCI: Device 0000:00:0f.0 not found by BIOS
PCI: Device 0000:00:0f.3 not found by BIOS
PCI: Device 0000:00:11.0 not found by BIOS
PCI: Device 0000:00:11.2 not found by BIOS
pnp: 00:01: ioport range 0xf50-0xf58 has been reserved
pnp: 00:01: ioport range 0x408-0x40f has been reserved
pnp: 00:01: ioport range 0x900-0x903 has been reserved
pnp: 00:01: ioport range 0x910-0x911 has been reserved
pnp: 00:01: ioport range 0x920-0x923 has been reserved
pnp: 00:01: ioport range 0x930-0x937 has been reserved
pnp: 00:01: ioport range 0x940-0x947 has been reserved
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SGI XFS with ACLs, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 31 (level, low) -> IRQ 16
cciss0: <0xb178> at PCI 0000:00:04.0 IRQ 16 using DAC
      blocks= 142253280 block_size= 512
      heads=255, sectors=32, cylinders=17433

      blocks= 142253280 block_size= 512
      heads=255, sectors=32, cylinders=17433

 cciss/c0d0: p1 < p5 p6 p7 >
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks CSB5: IDE controller at PCI slot 0000:00:0f.1
SvrWks CSB5: chipset revision 147
SvrWks CSB5: not 100% native mode: will probe irqs later
SvrWks CSB5: simplex device: DMA forced
    ide0: BM-DMA at 0x2000-0x2007, BIOS settings: hda:pio, hdb:pio
SvrWks CSB5: simplex device: DMA forced
    ide1: BM-DMA at 0x2008-0x200f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: CRN-8245B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
Adding 5993492k swap on /dev/cciss/c0d0p7.  Priority:-1 extents:1 across:5993492k
EXT3 FS on cciss/c0d0p6, internal journal
Real Time Clock Driver v1.12ac
Generic RTC Driver v1.07
piix4_smbus 0000:00:0f.0: Found 0000:00:0f.0 device
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on cciss/c0d0p5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tg3.c:v3.75 (March 23, 2007)
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 30 (level, low) -> IRQ 17
eth0: Tigon3 [partno(N/A) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:11:0a:e9:fa:b6
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[769c4000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 29 (level, low) -> IRQ 18
eth1: Tigon3 [partno(N/A) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:11:0a:ea:a7:be
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[769c4000] dma_mask[64-bit]
logips2pp: Detected unknown logitech mouse model 1
PM: Writing back config space on device 0000:01:02.0 at offset b (was 164714e4, writing cb0e11)
PM: Writing back config space on device 0000:01:02.0 at offset 3 (was 4000, writing 4010)
PM: Writing back config space on device 0000:01:02.0 at offset 2 (was 2000000, writing 2000002)
PM: Writing back config space on device 0000:01:02.0 at offset 1 (was 2b00000, writing 2b00146)
PM: Writing back config space on device 0000:01:02.0 at offset 0 (was 164714e4, writing 16a714e4)
input: ImExPS/2 Logitech Explorer Mouse as /class/input/input1
NET: Registered protocol family 10
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
Clocksource tsc unstable (delta = 4686825172 ns)
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
NOHZ: local_softirq_pending 08
BUG: soft lockup detected on CPU#0!
 [<c013c69a>] softlockup_tick+0x90/0xb5
 [<c0123564>] update_process_times+0x28/0x5e
 [<c01328fe>] tick_sched_timer+0x48/0x9a
 [<c012eff1>] hrtimer_interrupt+0x13f/0x1c5
 [<c010e75d>] smp_apic_timer_interrupt+0x55/0x85
 [<c011461c>] __wake_up_common+0x39/0x59
 [<c01048d0>] apic_timer_interrupt+0x28/0x30
 [<c02db6d0>] rt_check_expire+0xf8/0x160
 [<c02db5d8>] rt_check_expire+0x0/0x160
 [<c01227b7>] run_timer_softirq+0x11e/0x17a
 [<c011ece9>] it_real_fn+0x0/0x17
 [<c011ecfb>] it_real_fn+0x12/0x17
 [<c011f8c2>] __do_softirq+0x74/0xd9
 [<c011f794>] ksoftirqd+0x0/0xba
 [<c0106624>] do_softirq+0x5f/0xa8
 [<c011f807>] ksoftirqd+0x73/0xba
 [<c012bd02>] kthread+0xae/0xd3
 [<c012bc54>] kthread+0x0/0xd3
 [<c0104a53>] kernel_thread_helper+0x7/0x14
 =======================
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 22
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02
NOHZ: local_softirq_pending 02

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universit√§tsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                    send no mail to plonk@charite.de
