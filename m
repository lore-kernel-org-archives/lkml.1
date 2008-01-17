Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYAQW0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYAQW0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYAQW0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:26:46 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:60749 "EHLO
	mail77-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYAQW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:26:44 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 17 Jan 2008 23:26:34 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117222634.GG12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117214228.GD12631@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20080117214228.GD12631@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 22:26:18.0699 (UTC)
 FILETIME=[FAEE09B0:01C85957]
X-WSS-ID: 6B91098407S8367455-01-01
Content-Type: multipart/mixed;
 boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, Jan 17, 2008 at 10:42:28PM +0100, Andreas Herrmann3 wrote:
> On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > 
> > * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> > 
> > > Yes.
> > > 
> > > Meanwhile I have figured out that it is some ACPI stuff that maps the 
> > > page cached. I've changed the ioremap's in drivers/acpi/osl.c to 
> > > ioremap_nocache. See attached patch.
> > > 
> > > Now the machine boots without conflicts.
> > 
> > ah, nice!
> > 
> > but in general we must be robust enough in this case and just degrade 
> > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > failing the ioremap and thus failing the driver (and the bootup).
> > 
> > Does my third patch (which falls back to UC in case of attribute 
> > conflicts, also attached below) instead of your ioremap_nocache() patch 
> > solve your bootup problem too?
> 
> I'll check this asap


So, now that I've avoided this tiny NULL-pointer-dereference, the system boots
fine as well with your (slightly modified) patch. See dmesg attached.


Andreas

--Fig2xvG2VGoz8o/s
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=dmesg.log
Content-Transfer-Encoding: 7bit

Linux version 2.6.24-rc8-gd294e9ed-dirty (root@hunter) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #2 SMP Thu Jan 17 23:13:37 CET 2008
Command line: root=/dev/sda1 console=ttyS0,115200 debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008dc00 (usable)
 BIOS-e820: 000000000008dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077e70000 (usable)
 BIOS-e820: 0000000077e70000 - 0000000077e7a000 (ACPI data)
 BIOS-e820: 0000000077e7a000 - 0000000077f00000 (ACPI NVS)
 BIOS-e820: 0000000077f00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 141) 0 entries of 3200 used
Entering add_active_range(0, 256, 491120) 1 entries of 3200 used
end_pfn_map = 1048576
early_ioremap(000000000000040e, 00000002) => -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009e000, 00000002) => -000002104893440
early_iounmap(ffffffff8289e000, 00000002)
early_ioremap(0000000000008000, 00001000) => -000002105507840
early_ioremap(0000000000009000, 00001000) => -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) => -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) => -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_ioremap(000000000000c000, 00001000) => -000002103394304
early_iounmap(ffffffff82a0c000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) => -000002104557568
DMI present.
early_ioremap(0000000077eec000, 00000491) => -000002102476800
early_iounmap(ffffffff82aec000, 00000491)
early_iounmap(ffffffff828f0000, 00010000)
early_ioremap(0000000000000000, 00000400) => -000002105540608
early_iounmap(ffffffff82800000, 00000400)
early_ioremap(00000000000e0000, 00020000) => -000002104623104
early_iounmap(ffffffff828e0000, 00020000)
early_ioremap(00000000000f7870, 00000024) => -000002104526736
ACPI: RSDP 000F7870, 0024 (r2 PTLTD )
early_iounmap(ffffffff828f7870, 00000024)
early_ioremap(0000000077e72cc4, 00000024) => -000002105070396
early_iounmap(ffffffff82872cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) => -000002105070396
early_iounmap(ffffffff82872cc4, 0000004c)
early_ioremap(0000000077e72cc4, 00000024) => -000002105070396
ACPI: XSDT 77E72CC4, 004C (r1 PTLTD  	 XSDT    6040000  LTP        0)
early_iounmap(ffffffff82872cc4, 00000024)
early_ioremap(0000000077e72cc4, 0000004c) => -000002105070396
early_iounmap(ffffffff82872cc4, 0000004c)
early_ioremap(0000000077e7985c, 00000024) => -000002105042852
ACPI: FACP 77E7985C, 00F4 (r3 AMD    DUNE      6040000 ATI     F4240)
early_iounmap(ffffffff8287985c, 00000024)
early_ioremap(0000000077e7985c, 000000f4) => -000002105042852
early_iounmap(ffffffff8287985c, 000000f4)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
ACPI: DSDT 77E72D10, 6AD8 (r1    ATI    SB400  6040000 MSFT  100000E)
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e7afc0, 00000024) => -000002105036864
ACPI: FACS 77E7AFC0, 0040
early_iounmap(ffffffff8287afc0, 00000024)
early_ioremap(0000000077e79950, 00000024) => -000002105042608
ACPI: TCPA 77E79950, 0032 (r1 Phoeni  x        6040000  TL         0)
early_iounmap(ffffffff82879950, 00000024)
early_ioremap(0000000077e79982, 00000024) => -000002105042558
ACPI: SSDT 77E79982, 0544 (r1 AMD    POWERNOW  6040000 AMD         1)
early_iounmap(ffffffff82879982, 00000024)
early_ioremap(0000000077e79ec6, 00000024) => -000002105041210
ACPI: SRAT 77E79EC6, 00C0 (r1 AMD    HAMMER    6040000 AMD         1)
early_iounmap(ffffffff82879ec6, 00000024)
early_ioremap(0000000077e79f86, 00000024) => -000002105041018
ACPI: APIC 77E79F86, 007A (r1 PTLTD  	 APIC    6040000  LTP        0)
early_iounmap(ffffffff82879f86, 00000024)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e72d10, 00000024) => -000002105070320
early_iounmap(ffffffff82872d10, 00000024)
early_ioremap(0000000077e79ec6, 000000c0) => -000002105041210
early_ioremap(0000000077e79ec6, 000000c0) => -000002102944058
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 2 -> Node 0
SRAT: PXM 0 -> APIC 3 -> Node 0
early_iounmap(ffffffff82a79ec6, 000000c0)
early_ioremap(0000000077e79ec6, 000000c0) => -000002102944058
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 141) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 141) 1 entries of 3200 used
Entering add_active_range(0, 256, 491120) 1 entries of 3200 used
early_iounmap(ffffffff82a79ec6, 000000c0)
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000077e70000
early_ioremap(0000000000000000, 00000400) => -000002103443456
early_iounmap(ffffffff82a00000, 00000400)
early_ioremap(000000000009fc00, 00000400) => -000002102789120
early_iounmap(ffffffff82a9fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) => -000002102460416
early_iounmap(ffffffff82af0000, 00010000)
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002600000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002e00000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810003200000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810003600000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810004600000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004e00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      141
    0:      256 ->   491120
On node 0 totalpages: 491005
  DMA zone: 56 pages used for memmap
  DMA zone: 10 pages reserved
  DMA zone: 3915 pages, LIFO batch:0
  DMA32 zone: 6658 pages used for memmap
  DMA32 zone: 480366 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
early_ioremap(0000000077e7985c, 000000f4) => -000002102945700
ACPI: PM-Timer IO Port: 0x8008
early_iounmap(ffffffff82a7985c, 000000f4)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
ACPI: Local APIC address 0xfee00000
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
early_iounmap(ffffffff82a79f86, 0000007a)
early_ioremap(0000000077e79f86, 0000007a) => -000002102943866
early_iounmap(ffffffff82a79f86, 0000007a)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30368 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 484281
Policy zone: DMA32
Kernel command line: root=/dev/sda1 console=ttyS0,115200 debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2288.284 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Memory: 1928912k/1964480k available (3074k kernel code, 35108k reserved, 1737k data, 308k init)
Calibrating delay using timer specific routine.. 4581.44 BogoMIPS (lpj=9162891)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x1040600010406
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
ioremap: addr 77e72d10, size 6ad8
ioremap: addr 77e79982, size 544
Using local APIC timer interrupts.
APIC timer calibration result 12436345
Detected 12.436 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4576.71 BogoMIPS (lpj=9153426)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x1040600010406
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4576.71 BogoMIPS (lpj=9153423)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x1040600010406
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4576.72 BogoMIPS (lpj=9153454)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x1040600010406
AMD Phenom(tm) 9600 Quad-Core Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
CPU0 attaching sched-domain:
 domain 0: span f
  groups: 1 2 4 8
  domain 1: span f
   groups: f
CPU1 attaching sched-domain:
 domain 0: span f
  groups: 2 4 8 1
  domain 1: span f
   groups: f
CPU2 attaching sched-domain:
 domain 0: span f
  groups: 4 8 1 2
  domain 1: span f
   groups: f
CPU3 attaching sched-domain:
 domain 0: span f
  groups: 8 1 2 4
  domain 1: span f
   groups: f
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ioremap: addr 77e7afc0, size 40
ACPI: EC: Look up EC in DSDT
ioremap: addr c0403104, size fc
ioremap: addr 77e7ade1, size 3
ioremap: addr 77e7af04, size 1
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=Linux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0, disabled.
ioremap: addr 77e7985c, size f4
ioremap: addr 77e79950, size 32
ioremap: addr 77e79ec6, size c0
ioremap: addr 77e79f86, size 7a
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
ioremap: addr 77e7af74, size 48
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:08: ioport range 0x1080-0x1080 has been reserved
system 00:08: ioport range 0x220-0x22f has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x530-0x537 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc50-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x8000-0x805f has been reserved
system 00:08: ioport range 0xf40-0xf47 has been reserved
system 00:08: ioport range 0x87f-0x87f has been reserved
system 00:09: iomem range 0xe0000-0xfffff could not be reserved
system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:09: iomem range 0x0-0xfff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: c0000000-c00fffff
  PREFETCH window: c8000000-cfffffff
PCI: Bridge: 0000:00:14.4
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
ioremap_nocache: addr c0400000, size 1000
ioremap_nocache: addr c0401000, size 1000
ioremap_nocache: addr c0402000, size 1000
Boot video device is 0000:01:05.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [C000] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
ioremap_nocache: addr c0100000, size 80
3c59x: Donald Becker and others.
0000:02:04.0: 3Com PCI 3c905C Tornado at ffffc200008aa000.
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1060-0x1067, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1068-0x106f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: SONY DVD-ROM DDU1615, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
hdc: ATAPI 40X DVD-ROM drive, 254kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ioremap_nocache: addr c0403000, size 200
swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc0403080 irq 22
ata2: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc04030c0 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3120811AS, 3.AAE, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3120811AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SAS Host driver 3.04.06
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ioremap_nocache: addr c0402000, size 1000
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xc0402000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ioremap_nocache: addr c0400000, size 1000
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 19, io mem 0xc0400000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ioremap_nocache: addr c0401000, size 1000
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 19, io mem 0xc0401000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
i2c-core: driver [dev_driver] registered
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
piix4_smbus 0000:00:14.0: Using Interrupt SMI# for SMBus.
piix4_smbus 0000:00:14.0: SMBREV = 0x0
piix4_smbus 0000:00:14.0: SMBA = 0x1050
i2c-adapter i2c-0: adapter [SMBus PIIX4 adapter at 1050] registered
i2c-dev: adapter [SMBus PIIX4 adapter at 1050] registered as minor 0
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
ioremap_nocache: addr c0403800, size 100
swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
ALSA device list:
  #0: ATI IXP rev 80 with ALC655 at 0xc0403800, irq 17
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Phenom(tm) 9600 Quad-Core Processor processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2300 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (1150 MHz)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 308k freed
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 7823612k swap on /dev/sda6.  Priority:-1 extents:1 across:7823612k
eth0:  setting full-duplex.
eth0: no IPv6 routers present

--Fig2xvG2VGoz8o/s--


