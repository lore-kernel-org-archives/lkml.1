Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXKLQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXKLQwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXKLQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:52:23 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:57962 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbXKLQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:52:18 -0500
From: Bernd Strieder <strieder@informatik.uni-kl.de>
Organization: TU Kaiserlautern
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: x86_64 SATA DVD drive + libata trouble
Date: Mon, 12 Nov 2007 17:48:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <200711091933.01523.strieder@informatik.uni-kl.de> <20071109190413.0efe9318@the-village.bc.nu>
In-Reply-To: <20071109190413.0efe9318@the-village.bc.nu>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1PIOHM0HdTlsFP8"
Message-Id: <200711121748.53313.strieder@informatik.uni-kl.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

> > I have a Tyan mainboard with NVIDIA chipset CK804. The only
> > SATA/IDE device is a SATA DVD combo, the harddisks are on a
> > RAID controller from 3ware. The harddisks are fine.

> A dmesg and further info would be useful here. Also knowing how
> much memory your system has and whether it passes memtest86.

It has 8GB RAM and passes memtest86, I had one run.

>
> > So there are clearly some problems with libata in this system.
>
> CK804 is known to work reliably. That means we are looking for
> something thats "different" about your system - perhaps the
> devices, the amount of memory etc.

I managed to get it running with the SuSE kernel when passing 
adma=0 to sata_nv module, and I managed to get it running when 
passing mem=2000M to the SuSE kernel. Thanks to Robert for those 
hints.

The vanilla kernels I tried 2.6.23.1 and 2.6.24-rc1-git10 (with 
patch to sata_nv.c from Robert Hancock see 
https://bugzilla.redhat.com/show_bug.cgi?id=351451)  seem to be 
very sensitive in this area. Whenever I got them to oops, I did 
not have much time to get anything read on the screen. 

I managed under the patched 2.6.24-rc1-git10 to manually load 
sata_nv and sr_mod, and then I got an OOps like

Unable to handle ... NULL pointer dref at 0000000000000000 RIP 
ffffff880edf6a
.....
		libata:ata_qc_prep + 0xe2/0x15b
.....
		srmod:sr_probe

I have  attached 3 dmesg outputs with the openSuSE 10.3 kernel and 
extracts of /var/log/messages, especially some Oopses. The oopses 
from the vanilla kernels seem to be so bad that they do never end 
up in a file. 

I will do some more tests as soon as possible. I have attached the 
files as I created them, you will have to diff the single files, 
anyway, to get the important information out, I cannot select for 
you.

Bernd Strieder



--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="cdrominfo.openSuSE2.6.22.5-31-default"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cdrominfo.openSuSE2.6.22.5-31-default"

CD-ROM information, Id: cdrom.c 3.20 2003/12/17

drive name:		sr0
drive speed:		0
drive # of slots:	1
Can close tray:		0
Can open tray:		0
Can lock tray:		1
Can change speed:	1
Can select disk:	0
Can read multisession:	1
Can read MCN:		1
Reports media changed:	1
Can play audio:		1
Can write CD-R:		0
Can write CD-RW:	0
Can read DVD:		0
Can write DVD-R:	0
Can write DVD-RAM:	0
Can read MRW:		1
Can write MRW:		1
Can write RAM:		1



--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.openSuSE2.6.22.5-31-default-2000M"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.openSuSE2.6.22.5-31-default-2000M"

Linux version 2.6.22.5-31-default (geeko@buildhost) (gcc version 4.2.1 (SUSE Linux)) #1 SMP 2007/09/21 22:29:00 UTC
Command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent mem=2000M
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000da000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff00000 (usable)
 BIOS-e820: 000000007ff00000 - 000000007ff11000 (ACPI data)
 BIOS-e820: 000000007ff11000 - 000000007ff80000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000280000000 (usable)
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 512000) 1 entries of 3200 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F78C0, 0014 (r0 PTLTD )
ACPI: RSDT 7FF0B188, 0040 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF10A3E, 0074 (r1 NVIDIA CK8S      6040000 PTL_    F4240)
ACPI: DSDT 7FF0B1C8, 5876 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 7FF11FC0, 0040
ACPI: SRAT 7FF10AB2, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SPCR 7FF10BC2, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: MCFG 7FF10C12, 003C (r1 PTLTD    MCFG    6040000             0)
ACPI: APIC 7FF10C4E, 009E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF10CEC, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7FF10D14, 02EC (r1 PTLTD  POWERNOW  6040000  LTP        1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 154) 1 entries of 3200 used
Entering add_active_range(0, 256, 512000) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-180000000
Entering add_active_range(0, 0, 154) 2 entries of 3200 used
Entering add_active_range(0, 256, 512000) 2 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000007d000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      154
    0:      256 ->   512000
On node 0 totalpages: 511898
  DMA zone: 56 pages used for memmap
  DMA zone: 1275 pages reserved
  DMA zone: 2663 pages, LIFO batch:0
  DMA32 zone: 6944 pages used for memmap
  DMA32 zone: 500960 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xc0000000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xc0000000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xc0001000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xc0001000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xc4000000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xc4000000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009a000 - 000000000009b000
swsusp: Registered nosave memory region: 000000000009b000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000da000
swsusp: Registered nosave memory region: 00000000000da000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 50296 bytes of per cpu data
Built 1 zonelists.  Total pages: 503623
Kernel command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent mem=2000M
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2009.275 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 8e000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 2009852k/2048000k available (2050k kernel code, 37740k reserved, 1017k data, 316k init)
Calibrating delay using timer specific routine.. 4020.99 BogoMIPS (lpj=8041997)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
Unpacking initramfs... done
Freeing initrd memory: 4326k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 757 Objects with 95 Devices 280 Methods 29 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 12 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
result 12557986
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.80 BogoMIPS (lpj=8037617)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4018.81 BogoMIPS (lpj=8037637)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4018.89 BogoMIPS (lpj=8037788)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
Brought up 4 CPUs
migration_cost=370
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e07fffff
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 00:19
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.........................................................................................
Initialized 29/29 Regions 2/2 Fields 29/29 Buffers 29/41 Packages (778 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 101 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:10)
PCI: Probing PCI hardware (bus 10)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
PCI: Probing PCI hardware (bus 80)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LSI1] (IRQs 52 53 54 55) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:00: iomem range 0xfefff000-0xfeffffff has been reserved
pnp: 00:02: ioport range 0x8000-0x807f has been reserved
pnp: 00:02: ioport range 0x8080-0x80ff has been reserved
pnp: 00:02: ioport range 0x8400-0x847f has been reserved
pnp: 00:02: ioport range 0x8480-0x84ff has been reserved
pnp: 00:02: ioport range 0x8800-0x887f has been reserved
pnp: 00:02: ioport range 0x8880-0x88ff has been reserved
pnp: 00:02: ioport range 0xa000-0xa03f has been reserved
pnp: 00:02: ioport range 0xa040-0xa07f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@c0000000 for 0000:02:00.0
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: 91000000-92ffffff
  PREFETCH window: a0000000-bfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:10:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:0b.0
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: c2000000-c3ffffff
PCI: Bridge: 0000:80:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1194875754.504:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:02:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0a.0 subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0b.0 subordinate bus.
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie01]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:0e.0:pcie01 failed with error 2
vesafb: framebuffer at 0xa0000000, mapped to 0xffffc20001380000, using 10240k, total 131072k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
bootsplash: silentjpeg size 98233 bytes
bootsplash: ...found (1280x1024, 35219 bytes, v3).
Console: switching to colour frame buffer device 156x60
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
NET: Registered protocol family 1
Freeing unused kernel memory: 316k freed
SCSI subsystem initialized
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ACPI: PCI Interrupt 0000:12:04.0[A] -> GSI 28 (level, low) -> IRQ 28
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xc0100000, IRQ: 28.
3w-9xxx: scsi0: Firmware FE9X 3.04.00.005, BIOS BE9X 3.04.00.002, Ports: 8.
scsi 0:0:0:0: Direct-Access     AMCC     9550SXU-8L DISK  3.04 PQ: 0 ANSI: 3
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0x90000000
sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22.5-31-default ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0x90001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22.5-31-default ehci_hcd
usb usb2: SerialNumber: 0000:00:02.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
swsusp: Marking nosave pages: 000000000009a000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: new device found, idVendor=046d, idProduct=c03e
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB-PS/2 Optical Mouse
usb 1-1: Manufacturer: Logitech
usb 1-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
i2c-adapter i2c-0: nForce2 SMBus adapter at 0xa000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0xa040
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
libata version 3.00 loaded.
ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
Found: SST 49LF080A
ck804xrom @fff00000: Found 1 x8 devices at 0x0 in 8-bit bank
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:06 failed with error -16
eth0: forcedeth.c: subsystem: 010f1:2895 bound to 0000:00:0a.0
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 55
ACPI: PCI Interrupt 0000:80:0a.0[A] -> Link [LMAC] -> GSI 55 (level, high) -> IRQ 55
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LACI] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:80:0a.0 to 64
forcedeth: using HIGHDMA
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 58771 usecs
intel8x0: clocking to 47017
eth1: forcedeth.c: subsystem: 010f1:2895 bound to 0000:80:0a.0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi1 : pata_amd
scsi2 : pata_amd
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000011c00 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000011c08 irq 15
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi3 : sata_nv
scsi4 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc20000336480 ctl 0xffffc200003364a0 bmdma 0x0000000000011c10 irq 23
ata4: SATA max UDMA/133 cmd 0xffffc20000336580 ctl 0xffffc200003365a0 bmdma 0x0000000000011c18 irq 23
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ata3: SATA link down (SStatus 0 SControl 310)
ata4: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 22 (level, high) -> IRQ 22
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi5 : sata_nv
scsi6 : sata_nv
ata5: SATA max UDMA/133 cmd 0xffffc20000338480 ctl 0xffffc200003384a0 bmdma 0x0000000000011c20 irq 22
ata6: SATA max UDMA/133 cmd 0xffffc20000338580 ctl 0xffffc200003385a0 bmdma 0x0000000000011c28 irq 22
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATAPI: TSSTcorp CDDVDW SH-S203B, SB00, max UDMA/100
ata5.00: configured for UDMA/100
floppy0: no floppy controllers found
ata6: SATA link down (SStatus 0 SControl 310)
scsi 5:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203B  SB00 PQ: 0 ANSI: 5
ata5: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
scsi 5:0:0:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
AppArmor: AppArmor initialized
audit(1194875765.740:2):  type=1505 info="AppArmor initialized" pid=2340
powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 270 processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
mtrr: type mismatch for a0000000,8000000 old: write-back new: write-combining
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
audit(1194875777.116:3): audit_pid=3506 old=0 by auid=4294967295

--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="cdrominfo.openSuSE2.6.22.5-31-default-2000M"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cdrominfo.openSuSE2.6.22.5-31-default-2000M"

CD-ROM information, Id: cdrom.c 3.20 2003/12/17

drive name:		sr0
drive speed:		48
drive # of slots:	1
Can close tray:		1
Can open tray:		1
Can lock tray:		1
Can change speed:	1
Can select disk:	0
Can read multisession:	1
Can read MCN:		1
Reports media changed:	1
Can play audio:		1
Can write CD-R:		1
Can write CD-RW:	1
Can read DVD:		1
Can write DVD-R:	1
Can write DVD-RAM:	1
Can read MRW:		1
Can write MRW:		1
Can write RAM:		1



--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.openSuSE2.6.22.5-31-default-adma0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.openSuSE2.6.22.5-31-default-adma0"

Linux version 2.6.22.5-31-default (geeko@buildhost) (gcc version 4.2.1 (SUSE Linux)) #1 SMP 2007/09/21 22:29:00 UTC
Command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000da000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff00000 (usable)
 BIOS-e820: 000000007ff00000 - 000000007ff11000 (ACPI data)
 BIOS-e820: 000000007ff11000 - 000000007ff80000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000280000000 (usable)
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2621440) 2 entries of 3200 used
end_pfn_map = 2621440
DMI present.
ACPI: RSDP 000F78C0, 0014 (r0 PTLTD )
ACPI: RSDT 7FF0B188, 0040 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF10A3E, 0074 (r1 NVIDIA CK8S      6040000 PTL_    F4240)
ACPI: DSDT 7FF0B1C8, 5876 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 7FF11FC0, 0040
ACPI: SRAT 7FF10AB2, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SPCR 7FF10BC2, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: MCFG 7FF10C12, 003C (r1 PTLTD    MCFG    6040000             0)
ACPI: APIC 7FF10C4E, 009E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF10CEC, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7FF10D14, 02EC (r1 PTLTD  POWERNOW  6040000  LTP        1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 154) 1 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-180000000
Entering add_active_range(0, 0, 154) 2 entries of 3200 used
Entering add_active_range(0, 256, 524032) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
Entering add_active_range(1, 1572864, 2621440) 3 entries of 3200 used
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-0000000280000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2621440
early_node_map[4] active PFN ranges
    0:        0 ->      154
    0:      256 ->   524032
    0:  1048576 ->  1572864
    1:  1572864 ->  2621440
On node 0 totalpages: 1048218
  DMA zone: 56 pages used for memmap
  DMA zone: 1281 pages reserved
  DMA zone: 2657 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505656 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xc0000000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xc0000000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xc0001000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xc0001000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xc4000000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xc4000000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009a000 - 000000000009b000
swsusp: Registered nosave memory region: 000000000009b000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000da000
swsusp: Registered nosave memory region: 00000000000da000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007ff00000 - 000000007ff11000
swsusp: Registered nosave memory region: 000000007ff11000 - 000000007ff80000
swsusp: Registered nosave memory region: 000000007ff80000 - 0000000080000000
swsusp: Registered nosave memory region: 0000000080000000 - 00000000e0000000
swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000fff80000
swsusp: Registered nosave memory region: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 50296 bytes of per cpu data
Built 2 zonelists.  Total pages: 2059673
Kernel command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2009.281 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 8e000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 8168312k/10485760k available (2050k kernel code, 218864k reserved, 1017k data, 316k init)
Calibrating delay using timer specific routine.. 4021.00 BogoMIPS (lpj=8042017)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
Unpacking initramfs... done
Freeing initrd memory: 4326k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 757 Objects with 95 Devices 280 Methods 29 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 12 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
result 12558022
Detected 12.558 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.82 BogoMIPS (lpj=8037651)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4018.81 BogoMIPS (lpj=8037628)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4018.88 BogoMIPS (lpj=8037760)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
Brought up 4 CPUs
migration_cost=395,472
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e07fffff
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 00:19
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.........................................................................................
Initialized 29/29 Regions 2/2 Fields 29/29 Buffers 29/41 Packages (778 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 101 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:10)
PCI: Probing PCI hardware (bus 10)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
PCI: Probing PCI hardware (bus 80)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LSI1] (IRQs 52 53 54 55) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:00: iomem range 0xfefff000-0xfeffffff has been reserved
pnp: 00:02: ioport range 0x8000-0x807f has been reserved
pnp: 00:02: ioport range 0x8080-0x80ff has been reserved
pnp: 00:02: ioport range 0x8400-0x847f has been reserved
pnp: 00:02: ioport range 0x8480-0x84ff has been reserved
pnp: 00:02: ioport range 0x8800-0x887f has been reserved
pnp: 00:02: ioport range 0x8880-0x88ff has been reserved
pnp: 00:02: ioport range 0xa000-0xa03f has been reserved
pnp: 00:02: ioport range 0xa040-0xa07f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@c0000000 for 0000:02:00.0
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: 91000000-92ffffff
  PREFETCH window: a0000000-bfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:10:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:0b.0
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: c2000000-c3ffffff
PCI: Bridge: 0000:80:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1194881060.740:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:02:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0a.0 subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0b.0 subordinate bus.
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie01]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:0e.0:pcie01 failed with error 2
vesafb: framebuffer at 0xa0000000, mapped to 0xffffc20003000000, using 10240k, total 131072k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
bootsplash: silentjpeg size 98233 bytes
bootsplash: ...found (1280x1024, 35219 bytes, v3).
Console: switching to colour frame buffer device 156x60
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
NET: Registered protocol family 1
Freeing unused kernel memory: 316k freed
SCSI subsystem initialized
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ACPI: PCI Interrupt 0000:12:04.0[A] -> GSI 28 (level, low) -> IRQ 28
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xc0100000, IRQ: 28.
3w-9xxx: scsi0: Firmware FE9X 3.04.00.005, BIOS BE9X 3.04.00.002, Ports: 8.
scsi 0:0:0:0: Direct-Access     AMCC     9550SXU-8L DISK  3.04 PQ: 0 ANSI: 3
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 23, io mem 0x90000000
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22.5-31-default ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
usb usb1: configuration #1 chosen from 1 choice
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 22, io mem 0x90001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22.5-31-default ehci_hcd
usb usb2: SerialNumber: 0000:00:02.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: new device found, idVendor=046d, idProduct=c03e
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB-PS/2 Optical Mouse
usb 1-1: Manufacturer: Logitech
usb 1-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
swsusp: Marking nosave pages: 000000000009a000 - 0000000000100000
swsusp: Marking nosave pages: 000000007ff00000 - 0000000100000000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
libata version 3.00 loaded.
ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
i2c-adapter i2c-0: nForce2 SMBus adapter at 0xa000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0xa040
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi1 : pata_amd
scsi2 : pata_amd
CFI: Found no ck804xrom @ffc00000 device at location zero
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000011c00 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000011c08 irq 15
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
Found: SST 49LF080A
ck804xrom @fff00000: Found 1 x8 devices at 0x0 in 8-bit bank
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:06 failed with error -16
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 21 (level, high) -> IRQ 21
PCI: Setting latency timer of device 0000:00:07.0 to 64
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi3 : sata_nv
scsi4 : sata_nv
ata3: SATA max UDMA/133 cmd 0x0000000000011c40 ctl 0x0000000000011c36 bmdma 0x0000000000011c10 irq 21
ata4: SATA max UDMA/133 cmd 0x0000000000011c38 ctl 0x0000000000011c32 bmdma 0x0000000000011c18 irq 21
ata3: SATA link down (SStatus 0 SControl 310)
ata4: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 20 (level, high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi5 : sata_nv
scsi6 : sata_nv
ata5: SATA max UDMA/133 cmd 0x0000000000011c58 ctl 0x0000000000011c4e bmdma 0x0000000000011c20 irq 20
ata6: SATA max UDMA/133 cmd 0x0000000000011c50 ctl 0x0000000000011c4a bmdma 0x0000000000011c28 irq 20
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATAPI: TSSTcorp CDDVDW SH-S203B, SB00, max UDMA/100
ata5.00: configured for UDMA/100
ata6: SATA link down (SStatus 0 SControl 310)
scsi 5:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203B  SB00 PQ: 0 ANSI: 5
scsi 5:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LACI] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 58828 usecs
intel8x0: clocking to 47062
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
floppy0: no floppy controllers found
eth0: forcedeth.c: subsystem: 010f1:2895 bound to 0000:00:0a.0
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 55
ACPI: PCI Interrupt 0000:80:0a.0[A] -> Link [LMAC] -> GSI 55 (level, high) -> IRQ 55
PCI: Setting latency timer of device 0000:80:0a.0 to 64
forcedeth: using HIGHDMA
eth1: forcedeth.c: subsystem: 010f1:2895 bound to 0000:80:0a.0
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
AppArmor: AppArmor initialized
audit(1194881072.800:2):  type=1505 info="AppArmor initialized" pid=2329
powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 270 processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
mtrr: type mismatch for a0000000,8000000 old: write-back new: write-combining
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
audit(1194881083.934:3): audit_pid=3458 old=0 by auid=4294967295

--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="cdrominfo.openSuSE2.6.22.5-31-default-adma0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cdrominfo.openSuSE2.6.22.5-31-default-adma0"

CD-ROM information, Id: cdrom.c 3.20 2003/12/17

drive name:		sr0
drive speed:		48
drive # of slots:	1
Can close tray:		1
Can open tray:		1
Can lock tray:		1
Can change speed:	1
Can select disk:	0
Can read multisession:	1
Can read MCN:		1
Reports media changed:	1
Can play audio:		1
Can write CD-R:		1
Can write CD-RW:	1
Can read DVD:		1
Can write DVD-R:	1
Can write DVD-RAM:	1
Can read MRW:		1
Can write MRW:		1
Can write RAM:		1



--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="kernelmess"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernelmess"

Nov  8 19:25:08 euklid kernel: ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Nov  8 19:25:08 euklid kernel: ata5.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x28 data 45056 in
Nov  8 19:25:08 euklid kernel:          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Nov  8 19:25:13 euklid kernel: ata5: port is slow to respond, please be patient (Status 0xd0)
Nov  8 19:25:18 euklid kernel: ata5: device not ready (errno=-16), forcing hardreset
Nov  8 19:25:18 euklid kernel: ata5: hard resetting link
Nov  8 19:25:23 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:25:28 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:25:28 euklid kernel: ata5: hard resetting link
Nov  8 19:25:33 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:25:38 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:25:38 euklid kernel: ata5: hard resetting link
Nov  8 19:25:43 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:26:13 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:26:13 euklid kernel: ata5: hard resetting link
Nov  8 19:26:18 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:26:18 euklid kernel: ata5: reset failed, giving up
Nov  8 19:26:18 euklid kernel: ata5.00: disabled
Nov  8 19:26:18 euklid kernel: ata5: EH complete
Nov  8 19:26:18 euklid kernel: sr 4:0:0:0: [sr0] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Nov  8 19:26:18 euklid kernel: end_request: I/O error, dev sr0, sector 48
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 6
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 7
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 8
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 9
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 10
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 11
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 12
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 13
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 14
Nov  8 19:26:18 euklid kernel: Buffer I/O error on device sr0, logical block 15
Nov  8 19:30:38 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:30:38 euklid kernel: ata5: hard resetting link
Nov  8 19:30:44 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:30:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:30:48 euklid kernel: ata5: hard resetting link
Nov  8 19:30:54 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:30:58 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:30:58 euklid kernel: ata5: hard resetting link
Nov  8 19:31:04 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:31:33 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:31:33 euklid kernel: ata5: hard resetting link
Nov  8 19:31:38 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:31:38 euklid kernel: ata5: reset failed, giving up
Nov  8 19:31:38 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=4)
Nov  8 19:31:38 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:31:38 euklid kernel: ata5: hard resetting link
Nov  8 19:31:44 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:31:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:31:48 euklid kernel: ata5: hard resetting link
Nov  8 19:31:54 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:31:58 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:31:58 euklid kernel: ata5: hard resetting link
Nov  8 19:32:04 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:32:33 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:32:33 euklid kernel: ata5: hard resetting link
Nov  8 19:32:38 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:32:38 euklid kernel: ata5: reset failed, giving up
Nov  8 19:32:38 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=3)
Nov  8 19:32:38 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:32:38 euklid kernel: ata5: hard resetting link
Nov  8 19:32:44 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:32:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:32:48 euklid kernel: ata5: hard resetting link
Nov  8 19:32:54 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:32:58 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:32:58 euklid kernel: ata5: hard resetting link
Nov  8 19:33:04 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:33:33 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:33:33 euklid kernel: ata5: hard resetting link
Nov  8 19:33:38 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:33:38 euklid kernel: ata5: reset failed, giving up
Nov  8 19:33:38 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=2)
Nov  8 19:33:38 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:33:38 euklid kernel: ata5: hard resetting link
Nov  8 19:33:44 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:33:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:33:48 euklid kernel: ata5: hard resetting link
Nov  8 19:33:54 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:33:58 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:33:58 euklid kernel: ata5: hard resetting link
Nov  8 19:34:04 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:34:33 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:34:33 euklid kernel: ata5: hard resetting link
Nov  8 19:34:38 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:34:38 euklid kernel: ata5: reset failed, giving up
Nov  8 19:34:38 euklid kernel: ata5: EH complete
Nov  8 19:34:38 euklid kernel: ata5.00: detaching (SCSI 4:0:0:0)
Nov  8 19:34:38 euklid kernel: scsi 4:0:0:0: rejecting I/O to dead device
Nov  8 19:44:53 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:44:53 euklid kernel: ata5: hard resetting link
Nov  8 19:44:59 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:45:03 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:45:03 euklid kernel: ata5: hard resetting link
Nov  8 19:45:09 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:45:13 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:45:13 euklid kernel: ata5: hard resetting link
Nov  8 19:45:19 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:45:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:45:48 euklid kernel: ata5: hard resetting link
Nov  8 19:45:53 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:45:53 euklid kernel: ata5: reset failed, giving up
Nov  8 19:45:53 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=4)
Nov  8 19:45:53 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:45:53 euklid kernel: ata5: hard resetting link
Nov  8 19:45:59 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:46:03 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:46:03 euklid kernel: ata5: hard resetting link
Nov  8 19:46:09 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:46:13 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:46:13 euklid kernel: ata5: hard resetting link
Nov  8 19:46:19 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:46:48 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:46:48 euklid kernel: ata5: hard resetting link
Nov  8 19:46:53 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:46:53 euklid kernel: ata5: reset failed, giving up
Nov  8 19:46:53 euklid kernel: ata5: EH complete
Nov  8 19:48:02 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:48:02 euklid kernel: ata5: hard resetting link
Nov  8 19:48:07 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:48:12 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:48:12 euklid kernel: ata5: hard resetting link
Nov  8 19:48:17 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:48:22 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:48:22 euklid kernel: ata5: hard resetting link
Nov  8 19:48:27 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:48:57 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:48:57 euklid kernel: ata5: hard resetting link
Nov  8 19:49:02 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:49:02 euklid kernel: ata5: reset failed, giving up
Nov  8 19:49:02 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=4)
Nov  8 19:49:02 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:49:02 euklid kernel: ata5: hard resetting link
Nov  8 19:49:08 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:49:12 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:49:12 euklid kernel: ata5: hard resetting link
Nov  8 19:49:18 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:49:22 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:49:22 euklid kernel: ata5: hard resetting link
Nov  8 19:49:28 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:49:57 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:49:57 euklid kernel: ata5: hard resetting link
Nov  8 19:50:02 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:50:02 euklid kernel: ata5: reset failed, giving up
Nov  8 19:50:02 euklid kernel: ata5: EH complete
Nov  8 19:50:54 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:50:54 euklid kernel: ata5: hard resetting link
Nov  8 19:51:00 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:51:04 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:51:04 euklid kernel: ata5: hard resetting link
Nov  8 19:51:10 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:51:14 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:51:14 euklid kernel: ata5: hard resetting link
Nov  8 19:51:20 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:51:49 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:51:49 euklid kernel: ata5: hard resetting link
Nov  8 19:51:54 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:51:54 euklid kernel: ata5: reset failed, giving up
Nov  8 19:51:54 euklid kernel: ata5: EH pending after completion, repeating EH (cnt=4)
Nov  8 19:51:54 euklid kernel: ata5: exception Emask 0x10 SAct 0x0 SErr 0x150000 action 0xa frozen
Nov  8 19:51:54 euklid kernel: ata5: hard resetting link
Nov  8 19:52:00 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:52:04 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:52:04 euklid kernel: ata5: hard resetting link
Nov  8 19:52:10 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:52:14 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:52:14 euklid kernel: ata5: hard resetting link
Nov  8 19:52:20 euklid kernel: ata5: port is slow to respond, please be patient (Status 0x80)
Nov  8 19:52:49 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:52:49 euklid kernel: ata5: hard resetting link
Nov  8 19:52:54 euklid kernel: ata5: COMRESET failed (errno=-16)
Nov  8 19:52:54 euklid kernel: ata5: reset failed, giving up
Nov  8 19:52:54 euklid kernel: ata5: EH complete
Nov  8 20:24:37 euklid kernel: Unable to handle kernel paging request at ffffc20000c3e4c0 RIP: 
Nov  8 20:24:37 euklid kernel:  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 20:24:37 euklid kernel: PGD 18001b067 PUD 17a838067 PMD 27c461067 PTE 0
Nov  8 20:24:37 euklid kernel: Oops: 0002 [1] SMP 
Nov  8 20:24:37 euklid kernel: last sysfs file: /devices/pci0000:00/0000:00:00.0/irq
Nov  8 20:24:37 euklid kernel: CPU 1 
Nov  8 20:24:37 euklid kernel: Modules linked in: rfcomm l2cap bluetooth snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device snd_intel8x0 snd_ac97_codec snd_pcm snd_timer snd lp parport_pc parport nfs lockd nfs_acl sunrpc st ide_disk ide_cd ide_core joydev iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 apparmor loop dm_mod k8temp rtc_cmos rtc_core rtc_lib shpchp hwmon pci_hotplug ac97_bus forcedeth soundcore cfi_cmdset_0002 cfi_util mtdpart sr_mod cdrom snd_page_alloc jedec_probe cfi_probe i2c_nforce2 gen_probe ck804xrom i2c_core mtdcore chipreg map_funcs button container sg usbhid hid ff_memless sd_mod ehci_hcd ohci_hcd usbcore edd ext3 mbcache jbd fan 3w_9xxx sata_nv pata_amd libata scsi_mod thermal processor
Nov  8 20:24:37 euklid kernel: Pid: 23070, comm: rmmod Tainted: G      N 2.6.22.5-31-default #1
Nov  8 20:24:37 euklid kernel: RIP: 0010:[<ffffffff8807ca54>]  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 20:24:37 euklid kernel: RSP: 0000:ffff8101442a7dd0  EFLAGS: 00010282
Nov  8 20:24:37 euklid kernel: RAX: ffffc20000c3e480 RBX: 0000000000000000 RCX: 000000000000001f
Nov  8 20:24:37 euklid kernel: RDX: 0000000000000012 RSI: ffff810178f04098 RDI: ffff810178888000
Nov  8 20:24:37 euklid kernel: RBP: ffff810178f04098 R08: 000000000000000d R09: 0000000000000000
Nov  8 20:24:37 euklid kernel: R10: ffff8101442a7e18 R11: ffffffff802f4e67 R12: ffff8101442a7e18
Nov  8 20:24:37 euklid kernel: R13: ffff8101799f6870 R14: 000000000000000d R15: ffff8101799f6ad0
Nov  8 20:24:37 euklid kernel: FS:  00002b3c1866d6f0(0000) GS:ffff81017a3faac0(0000) knlGS:00000000f69f96d0
Nov  8 20:24:37 euklid kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  8 20:24:37 euklid kernel: CR2: ffffc20000c3e4c0 CR3: 00000001630f8000 CR4: 00000000000006e0
Nov  8 20:24:37 euklid kernel: Process rmmod (pid: 23070, threadinfo ffff8101442a6000, task ffff810174cfe7d0)
Nov  8 20:24:37 euklid kernel: Stack:  ffffffff8804f4e4 ffff810178f04080 ffff810178f04080 ffff810178e7ada0
Nov  8 20:24:37 euklid kernel:  ffff8101442a7e18 0000000000000000 ffffffff8036f663 0000000000000246
Nov  8 20:24:37 euklid kernel:  ffff8101799f6870 ffff810178e7ada0 ffff810178db2f80 0000000000000000
Nov  8 20:24:37 euklid kernel: Call Trace:
Nov  8 20:24:37 euklid kernel:  [<ffffffff8804f4e4>] :libata:ata_host_release+0x3a/0xb3
Nov  8 20:24:37 euklid kernel:  [<ffffffff8036f663>] release_nodes+0x149/0x18d
Nov  8 20:24:37 euklid kernel:  [<ffffffff8036ced7>] __device_release_driver+0x96/0xb0
Nov  8 20:24:37 euklid kernel:  [<ffffffff8036d38b>] driver_detach+0xb8/0xfd
Nov  8 20:24:37 euklid kernel:  [<ffffffff8036c9a7>] bus_remove_driver+0x80/0xa3
Nov  8 20:24:37 euklid kernel:  [<ffffffff803038e4>] pci_unregister_driver+0x17/0x6b
Nov  8 20:24:37 euklid kernel:  [<ffffffff8024e7b4>] sys_delete_module+0x1a2/0x1d8
Nov  8 20:24:37 euklid kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
Nov  8 20:24:37 euklid kernel: 
Nov  8 20:24:37 euklid kernel: 
Nov  8 20:24:37 euklid kernel: Code: 66 c7 40 40 00 00 c3 48 8b 87 f0 2b 00 00 53 48 8b 58 20 e8 
Nov  8 20:24:37 euklid kernel: RIP  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 20:24:37 euklid kernel:  RSP <ffff8101442a7dd0>
Nov  8 20:24:37 euklid kernel: CR2: ffffc20000c3e4c0



Nov  8 21:13:21 euklid kernel: ata5.00: disabled
Nov  8 21:13:21 euklid kernel: Unable to handle kernel paging request at ffffc20000c3e4c0 RIP: 
Nov  8 21:13:21 euklid kernel:  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 21:13:21 euklid kernel: PGD 18001b067 PUD 17a838067 PMD 27c461067 PTE 0
Nov  8 21:13:21 euklid kernel: Oops: 0002 [1] SMP 
Nov  8 21:13:21 euklid kernel: last sysfs file: /devices/pci0000:80/0000:80:0a.0/irq
Nov  8 21:13:21 euklid kernel: CPU 1 
Nov  8 21:13:21 euklid kernel: Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_filter ip_tables ip6_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 apparmor loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm rtc_cmos snd_timer rtc_core snd rtc_lib shpchp pci_hotplug k8temp sr_mod soundcore cfi_cmdset_0002 hwmon cfi_util mtdpart cdrom forcedeth snd_page_alloc jedec_probe i2c_nforce2 cfi_probe i2c_core gen_probe ck804xrom mtdcore chipreg map_funcs container button sg usbhid hid ff_memless sd_mod ehci_hcd ohci_hcd usbcore edd ext3 mbcache jbd fan 3w_9xxx sata_nv pata_amd libata scsi_mod thermal processor
Nov  8 21:13:21 euklid kernel: Pid: 3844, comm: rmmod Tainted: G      N 2.6.22.5-31-default #1
Nov  8 21:13:21 euklid kernel: RIP: 0010:[<ffffffff8807ca54>]  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 21:13:21 euklid kernel: RSP: 0018:ffff81017a38ddd0  EFLAGS: 00010282
Nov  8 21:13:21 euklid kernel: RAX: ffffc20000c3e480 RBX: 0000000000000000 RCX: 000000000000001f
Nov  8 21:13:21 euklid kernel: RDX: 000000000000000c RSI: ffff810178efbcd8 RDI: ffff8101788ac000
Nov  8 21:13:21 euklid kernel: RBP: ffff810178efbcd8 R08: 000000000000000d R09: 0000000000000000
Nov  8 21:13:21 euklid kernel: R10: ffff81017a38de18 R11: ffffffff802f4e67 R12: ffff81017a38de18
Nov  8 21:13:21 euklid kernel: R13: ffff8101799f8870 R14: 000000000000000d R15: ffff8101799f8ad0
Nov  8 21:13:21 euklid kernel: FS:  00002b6aea4206f0(0000) GS:ffff81017a3faac0(0000) knlGS:0000000000000000
Nov  8 21:13:21 euklid kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  8 21:13:21 euklid kernel: CR2: ffffc20000c3e4c0 CR3: 000000027a91a000 CR4: 00000000000006e0
Nov  8 21:13:21 euklid kernel: Process rmmod (pid: 3844, threadinfo ffff81017a38c000, task ffff810179ca4810)
Nov  8 21:13:21 euklid kernel: Stack:  ffffffff8804f4e4 ffff810178efbcc0 ffff810178efbcc0 ffff810178f00300
Nov  8 21:13:21 euklid kernel:  ffff81017a38de18 0000000000000000 ffffffff8036f663 0000000000000246
Nov  8 21:13:21 euklid kernel:  ffff8101799f8870 ffff810178f00300 ffff810179f6ad00 0000000000000000
Nov  8 21:13:21 euklid kernel: Call Trace:
Nov  8 21:13:21 euklid kernel:  [<ffffffff8804f4e4>] :libata:ata_host_release+0x3a/0xb3
Nov  8 21:13:21 euklid kernel:  [<ffffffff8036f663>] release_nodes+0x149/0x18d
Nov  8 21:13:21 euklid kernel:  [<ffffffff8036ced7>] __device_release_driver+0x96/0xb0
Nov  8 21:13:21 euklid kernel:  [<ffffffff8036d38b>] driver_detach+0xb8/0xfd
Nov  8 21:13:21 euklid kernel:  [<ffffffff8036c9a7>] bus_remove_driver+0x80/0xa3
Nov  8 21:13:21 euklid kernel:  [<ffffffff803038e4>] pci_unregister_driver+0x17/0x6b
Nov  8 21:13:21 euklid kernel:  [<ffffffff8024e7b4>] sys_delete_module+0x1a2/0x1d8
Nov  8 21:13:21 euklid kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
Nov  8 21:13:21 euklid kernel: 
Nov  8 21:13:21 euklid kernel: 
Nov  8 21:13:21 euklid kernel: Code: 66 c7 40 40 00 00 c3 48 8b 87 f0 2b 00 00 53 48 8b 58 20 e8 
Nov  8 21:13:21 euklid kernel: RIP  [<ffffffff8807ca54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  8 21:13:21 euklid kernel:  RSP <ffff81017a38ddd0>
Nov  8 21:13:21 euklid kernel: CR2: ffffc20000c3e4c0


Nov  8 21:28:24 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:24 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:24 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:24 euklid kernel: end_request: I/O error, dev sr0, sector 232
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 29
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 30
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 31
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 32
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 33
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 34
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 35
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 36
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 37
Nov  8 21:28:24 euklid kernel: Buffer I/O error on device sr0, logical block 38
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:29 euklid kernel: end_request: I/O error, dev sr0, sector 232
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:29 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:29 euklid kernel: end_request: I/O error, dev sr0, sector 480
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:33 euklid kernel: end_request: I/O error, dev sr0, sector 232
Nov  8 21:28:33 euklid kernel: printk: 84 messages suppressed.
Nov  8 21:28:33 euklid kernel: Buffer I/O error on device sr0, logical block 29
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:33 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:33 euklid kernel: end_request: I/O error, dev sr0, sector 480
Nov  8 21:28:39 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:39 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:39 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:39 euklid kernel: end_request: I/O error, dev sr0, sector 232
Nov  8 21:28:39 euklid kernel: printk: 62 messages suppressed.
Nov  8 21:28:39 euklid kernel: Buffer I/O error on device sr0, logical block 29
Nov  8 21:28:39 euklid kernel: Buffer I/O error on device sr0, logical block 30
Nov  8 21:28:40 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:28:40 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:28:40 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:28:40 euklid kernel: end_request: I/O error, dev sr0, sector 480
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:30:11 euklid kernel: end_request: I/O error, dev sr0, sector 224
Nov  8 21:30:11 euklid kernel: printk: 61 messages suppressed.
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 28
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 29
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 30
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 31
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 32
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 33
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 34
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 35
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 36
Nov  8 21:30:11 euklid kernel: Buffer I/O error on device sr0, logical block 37
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:30:11 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:30:11 euklid kernel: end_request: I/O error, dev sr0, sector 480
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:30:16 euklid kernel: end_request: I/O error, dev sr0, sector 232
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Sense Key : Hardware Error [current] 
Nov  8 21:30:16 euklid kernel: sr 5:0:0:0: [sr0] Add. Sense: Logical unit communication CRC error (Ultra-DMA/32)
Nov  8 21:30:16 euklid kernel: end_request: I/O error, dev sr0, sector 480
Nov  8 21:30:16 euklid kernel: printk: 85 messages suppressed.
Nov  8 21:30:16 euklid kernel: Buffer I/O error on device sr0, logical block 60



Nov  9 07:56:45 euklid kernel: ata3.00: disabled
Nov  9 07:56:45 euklid kernel: Unable to handle kernel paging request at ffffc20000c444c0 RIP: 
Nov  9 07:56:45 euklid kernel:  [<ffffffff8820aa54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  9 07:56:45 euklid kernel: PGD 18001b067 PUD 17a838067 PMD 27c461067 PTE 0
Nov  9 07:56:45 euklid kernel: Oops: 0002 [1] SMP 
Nov  9 07:56:45 euklid kernel: last sysfs file: /devices/pci0000:80/0000:80:0a.0/irq
Nov  9 07:56:45 euklid kernel: CPU 3 
Nov  9 07:56:45 euklid kernel: Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_filter ip_tables ip6_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 apparmor loop dm_mod sr_mod cdrom amd74xx generic ide_core snd_intel8x0 snd_ac97_codec rtc_cmos rtc_core rtc_lib ac97_bus shpchp k8temp snd_pcm pci_hotplug snd_timer hwmon sata_nv snd soundcore snd_page_alloc forcedeth cfi_cmdset_0002 cfi_util i2c_nforce2 mtdpart ata_generic libata jedec_probe cfi_probe i2c_core gen_probe ck804xrom mtdcore chipreg map_funcs container sg button usbhid hid ff_memless sd_mod ehci_hcd ohci_hcd usbcore edd ext3 mbcache jbd fan 3w_9xxx scsi_mod thermal processor
Nov  9 07:56:45 euklid kernel: Pid: 3954, comm: rmmod Tainted: G      N 2.6.22.5-31-default #1
Nov  9 07:56:45 euklid kernel: RIP: 0010:[<ffffffff8820aa54>]  [<ffffffff8820aa54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  9 07:56:45 euklid kernel: RSP: 0018:ffff810179f3ddd0  EFLAGS: 00010282
Nov  9 07:56:45 euklid kernel: RAX: ffffc20000c44480 RBX: 0000000000000000 RCX: 000000000000000a
Nov  9 07:56:45 euklid kernel: RDX: ffff810178e6da40 RSI: ffff810178dad5d8 RDI: ffff8101784d0000
Nov  9 07:56:45 euklid kernel: RBP: ffff810178dad5d8 R08: 0000000000000007 R09: 0000000000000000
Nov  9 07:56:45 euklid kernel: R10: ffff810179f3de18 R11: ffffffff802f4e67 R12: ffff810179f3de18
Nov  9 07:56:45 euklid kernel: R13: ffff8101799b2870 R14: 000000000000000d R15: ffff8101799b2ad0
Nov  9 07:56:45 euklid kernel: FS:  00002ab48d5546f0(0000) GS:ffff81027bda88c0(0000) knlGS:0000000000000000
Nov  9 07:56:45 euklid kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov  9 07:56:45 euklid kernel: CR2: ffffc20000c444c0 CR3: 000000027c7c8000 CR4: 00000000000006e0
Nov  9 07:56:45 euklid kernel: Process rmmod (pid: 3954, threadinfo ffff810179f3c000, task ffff810178fb6850)
Nov  9 07:56:45 euklid kernel: Stack:  ffffffff881844e4 ffff810178dad5c0 ffff810178dad5c0 ffff8101784046a0
Nov  9 07:56:45 euklid kernel:  ffff810179f3de18 0000000000000000 ffffffff8036f663 0000000000000246
Nov  9 07:56:45 euklid kernel:  ffff8101799b2870 ffff8101784046a0 ffff810178ac8200 0000000000000000
Nov  9 07:56:45 euklid kernel: Call Trace:
Nov  9 07:56:45 euklid kernel:  [<ffffffff881844e4>] :libata:ata_host_release+0x3a/0xb3
Nov  9 07:56:45 euklid kernel:  [<ffffffff8036f663>] release_nodes+0x149/0x18d
Nov  9 07:56:45 euklid kernel:  [<ffffffff8036ced7>] __device_release_driver+0x96/0xb0
Nov  9 07:56:45 euklid kernel:  [<ffffffff8036d38b>] driver_detach+0xb8/0xfd
Nov  9 07:56:45 euklid kernel:  [<ffffffff8036c9a7>] bus_remove_driver+0x80/0xa3
Nov  9 07:56:45 euklid kernel:  [<ffffffff803038e4>] pci_unregister_driver+0x17/0x6b
Nov  9 07:56:45 euklid kernel:  [<ffffffff8024e7b4>] sys_delete_module+0x1a2/0x1d8
Nov  9 07:56:45 euklid kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
Nov  9 07:56:45 euklid kernel: 
Nov  9 07:56:45 euklid kernel: 
Nov  9 07:56:45 euklid kernel: Code: 66 c7 40 40 00 00 c3 48 8b 87 f0 2b 00 00 53 48 8b 58 20 e8 
Nov  9 07:56:45 euklid kernel: RIP  [<ffffffff8820aa54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov  9 07:56:45 euklid kernel:  RSP <ffff810179f3ddd0>
Nov  9 07:56:45 euklid kernel: CR2: ffffc20000c444c0



Nov 12 16:21:36 euklid kernel: sr0: scsi3-mmc drive: 0x/0x caddy
Nov 12 16:21:36 euklid kernel: sr 3:0:0:0: Attached scsi CD-ROM sr0
Nov 12 16:22:00 euklid kernel: sr0: scsi3-mmc drive: 0x/0x caddy
Nov 12 16:22:00 euklid kernel: sr 3:0:0:0: Attached scsi CD-ROM sr0
Nov 12 16:22:05 euklid kernel: sr0: scsi3-mmc drive: 0x/0x caddy
Nov 12 16:22:05 euklid kernel: sr 3:0:0:0: Attached scsi CD-ROM sr0
Nov 12 16:22:27 euklid kernel: ata3.00: disabled
Nov 12 16:22:27 euklid kernel: Unable to handle kernel paging request at ffffc20000c484c0 RIP: 
Nov 12 16:22:27 euklid kernel:  [<ffffffff881f0a54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov 12 16:22:27 euklid kernel: PGD 18001b067 PUD 17a838067 PMD 27c461067 PTE 0
Nov 12 16:22:27 euklid kernel: Oops: 0002 [1] SMP 
Nov 12 16:22:27 euklid kernel: last sysfs file: /block/sr0/capability
Nov 12 16:22:27 euklid kernel: CPU 3 
Nov 12 16:22:27 euklid kernel: Modules linked in: sr_mod snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_filter ip_tables ip6_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 apparmor loop dm_mod cdrom amd74xx generic ide_core snd_intel8x0 snd_ac97_codec ac97_bus rtc_cmos snd_pcm rtc_core rtc_lib snd_timer snd shpchp soundcore pci_hotplug k8temp pata_amd sata_nv snd_page_alloc hwmon forcedeth cfi_cmdset_0002 cfi_util mtdpart ata_generic libata jedec_probe cfi_probe gen_probe i2c_nforce2 ck804xrom mtdcore chipreg i2c_core map_funcs container button sg usbhid hid ff_memless ehci_hcd ohci_hcd sd_mod usbcore edd ext3 mbcache jbd fan 3w_9xxx scsi_mod thermal processor
Nov 12 16:22:27 euklid kernel: Pid: 3967, comm: rmmod Tainted: G      N 2.6.22.5-31-default #1
Nov 12 16:22:27 euklid kernel: RIP: 0010:[<ffffffff881f0a54>]  [<ffffffff881f0a54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov 12 16:22:27 euklid kernel: RSP: 0000:ffff810177a55dd0  EFLAGS: 00010282
Nov 12 16:22:27 euklid kernel: RAX: ffffc20000c48480 RBX: 0000000000000000 RCX: 0000000000000009
Nov 12 16:22:27 euklid kernel: RDX: ffff810178da8340 RSI: ffff8101789f9198 RDI: ffff81017a688000
Nov 12 16:22:27 euklid kernel: RBP: ffff8101789f9198 R08: 0000000000000007 R09: 0000000000000000
Nov 12 16:22:27 euklid kernel: R10: ffff810177a55e18 R11: ffffffff802f4e67 R12: ffff810177a55e18
Nov 12 16:22:27 euklid kernel: R13: ffff8101799b2870 R14: 000000000000000d R15: ffff8101799b2ad0
Nov 12 16:22:27 euklid kernel: FS:  00002ba66fee76f0(0000) GS:ffff81027bda88c0(0000) knlGS:0000000000000000
Nov 12 16:22:27 euklid kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 12 16:22:27 euklid kernel: CR2: ffffc20000c484c0 CR3: 0000000275d09000 CR4: 00000000000006e0
Nov 12 16:22:27 euklid kernel: Process rmmod (pid: 3967, threadinfo ffff810177a54000, task ffff810179e117d0)
Nov 12 16:22:27 euklid kernel: Stack:  ffffffff8818b4e4 ffff8101789f9180 ffff8101789f9180 ffff810178e07ac0
Nov 12 16:22:27 euklid kernel:  ffff810177a55e18 0000000000000000 ffffffff8036f663 0000000000000246
Nov 12 16:22:27 euklid kernel:  ffff8101799b2870 ffff810178e07ac0 ffff81017860f380 0000000000000000
Nov 12 16:22:27 euklid kernel: Call Trace:
Nov 12 16:22:27 euklid kernel:  [<ffffffff8818b4e4>] :libata:ata_host_release+0x3a/0xb3
Nov 12 16:22:27 euklid kernel:  [<ffffffff8036f663>] release_nodes+0x149/0x18d
Nov 12 16:22:27 euklid kernel:  [<ffffffff8036ced7>] __device_release_driver+0x96/0xb0
Nov 12 16:22:27 euklid kernel:  [<ffffffff8036d38b>] driver_detach+0xb8/0xfd
Nov 12 16:22:27 euklid kernel:  [<ffffffff8036c9a7>] bus_remove_driver+0x80/0xa3
Nov 12 16:22:27 euklid kernel:  [<ffffffff803038e4>] pci_unregister_driver+0x17/0x6b
Nov 12 16:22:27 euklid kernel:  [<ffffffff8024e7b4>] sys_delete_module+0x1a2/0x1d8
Nov 12 16:22:27 euklid kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
Nov 12 16:22:27 euklid kernel: 
Nov 12 16:22:27 euklid kernel: 
Nov 12 16:22:27 euklid kernel: Code: 66 c7 40 40 00 00 c3 48 8b 87 f0 2b 00 00 53 48 8b 58 20 e8 
Nov 12 16:22:27 euklid kernel: RIP  [<ffffffff881f0a54>] :sata_nv:nv_adma_port_stop+0xb/0x12
Nov 12 16:22:27 euklid kernel:  RSP <ffff810177a55dd0>
Nov 12 16:22:27 euklid kernel: CR2: ffffc20000c484c0




--Boundary-00=_1PIOHM0HdTlsFP8
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.openSuSE2.6.22.5-31-default"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.openSuSE2.6.22.5-31-default"

Linux version 2.6.22.5-31-default (geeko@buildhost) (gcc version 4.2.1 (SUSE Linux)) #1 SMP 2007/09/21 22:29:00 UTC
Command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000da000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff00000 (usable)
 BIOS-e820: 000000007ff00000 - 000000007ff11000 (ACPI data)
 BIOS-e820: 000000007ff11000 - 000000007ff80000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000280000000 (usable)
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2621440) 2 entries of 3200 used
end_pfn_map = 2621440
DMI present.
ACPI: RSDP 000F78C0, 0014 (r0 PTLTD )
ACPI: RSDT 7FF0B188, 0040 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF10A3E, 0074 (r1 NVIDIA CK8S      6040000 PTL_    F4240)
ACPI: DSDT 7FF0B1C8, 5876 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 7FF11FC0, 0040
ACPI: SRAT 7FF10AB2, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
ACPI: SPCR 7FF10BC2, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: MCFG 7FF10C12, 003C (r1 PTLTD    MCFG    6040000             0)
ACPI: APIC 7FF10C4E, 009E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF10CEC, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7FF10D14, 02EC (r1 PTLTD  POWERNOW  6040000  LTP        1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 154) 1 entries of 3200 used
Entering add_active_range(0, 256, 524032) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-180000000
Entering add_active_range(0, 0, 154) 2 entries of 3200 used
Entering add_active_range(0, 256, 524032) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
Entering add_active_range(1, 1572864, 2621440) 3 entries of 3200 used
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-0000000280000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2621440
early_node_map[4] active PFN ranges
    0:        0 ->      154
    0:      256 ->   524032
    0:  1048576 ->  1572864
    1:  1572864 ->  2621440
On node 0 totalpages: 1048218
  DMA zone: 56 pages used for memmap
  DMA zone: 1281 pages reserved
  DMA zone: 2657 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505656 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xc0000000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xc0000000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xc0001000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xc0001000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xc4000000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xc4000000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009a000 - 000000000009b000
swsusp: Registered nosave memory region: 000000000009b000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000da000
swsusp: Registered nosave memory region: 00000000000da000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007ff00000 - 000000007ff11000
swsusp: Registered nosave memory region: 000000007ff11000 - 000000007ff80000
swsusp: Registered nosave memory region: 000000007ff80000 - 0000000080000000
swsusp: Registered nosave memory region: 0000000080000000 - 00000000e0000000
swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000fff80000
swsusp: Registered nosave memory region: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 50296 bytes of per cpu data
Built 2 zonelists.  Total pages: 2059673
Kernel command line: root=/dev/disk/by-id/scsi-1AMCC_0278095931E5540026BE-part2 vga=0x31a    resume=/dev/sda1 splash=silent
bootsplash: silent mode.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2009.293 MHz processor.
Console: colour dummy device 80x25
Checking aperture...
CPU 0: aperture @ 8e000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 8168312k/10485760k available (2050k kernel code, 218864k reserved, 1017k data, 316k init)
Calibrating delay using timer specific routine.. 4021.02 BogoMIPS (lpj=8042040)
Security Framework v1.0.0 initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
Unpacking initramfs... done
Freeing initrd memory: 4326k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 757 Objects with 95 Devices 280 Methods 29 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 12 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
result 12558097
Detected 12.558 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.82 BogoMIPS (lpj=8037652)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4018.81 BogoMIPS (lpj=8037628)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 270 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4018.80 BogoMIPS (lpj=8037614)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
Brought up 4 CPUs
migration_cost=393,469
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - e07fffff
PCI: No mmconfig possible on device 00:18
PCI: No mmconfig possible on device 00:19
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.........................................................................................
Initialized 29/29 Regions 2/2 Fields 29/29 Buffers 29/41 Packages (778 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 101 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:10)
PCI: Probing PCI hardware (bus 10)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
PCI: Probing PCI hardware (bus 80)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LSI1] (IRQs 52 53 54 55) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
ACPI: RTC can wake from S4
pnp: 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:00: iomem range 0xfefff000-0xfeffffff has been reserved
pnp: 00:02: ioport range 0x8000-0x807f has been reserved
pnp: 00:02: ioport range 0x8080-0x80ff has been reserved
pnp: 00:02: ioport range 0x8400-0x847f has been reserved
pnp: 00:02: ioport range 0x8480-0x84ff has been reserved
pnp: 00:02: ioport range 0x8800-0x887f has been reserved
pnp: 00:02: ioport range 0x8880-0x88ff has been reserved
pnp: 00:02: ioport range 0xa000-0xa03f has been reserved
pnp: 00:02: ioport range 0xa040-0xa07f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: 90100000-901fffff
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@c0000000 for 0000:02:00.0
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: 91000000-92ffffff
  PREFETCH window: a0000000-bfffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:10:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:0b.0
  IO window: 2000-2fff
  MEM window: c0100000-c01fffff
  PREFETCH window: c2000000-c3ffffff
PCI: Bridge: 0000:80:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:0e.0 to 64
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 1048576 (order: 12, 25165824 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 1048576 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1194875452.740:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Boot video device is 0000:02:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0a.0 subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0b.0 subordinate bus.
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie01]
Allocate Port Service[0000:00:0e.0:pcie03]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:0e.0:pcie01 failed with error 2
vesafb: framebuffer at 0xa0000000, mapped to 0xffffc20003000000, using 10240k, total 131072k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
bootsplash: silentjpeg size 98233 bytes
bootsplash: ...found (1280x1024, 35219 bytes, v3).
Console: switching to colour frame buffer device 156x60
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
NET: Registered protocol family 1
Freeing unused kernel memory: 316k freed
SCSI subsystem initialized
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ACPI: PCI Interrupt 0000:12:04.0[A] -> GSI 28 (level, low) -> IRQ 28
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xc0100000, IRQ: 28.
3w-9xxx: scsi0: Firmware FE9X 3.04.00.005, BIOS BE9X 3.04.00.002, Ports: 8.
scsi 0:0:0:0: Direct-Access     AMCC     9550SXU-8L DISK  3.04 PQ: 0 ANSI: 3
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0x90001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22.5-31-default ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 624955392 512-byte hardware sectors (319977 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0x90000000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22.5-31-default ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 2-1: new low speed USB device using ohci_hcd and address 2
usb 2-1: new device found, idVendor=046d, idProduct=c03e
usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: USB-PS/2 Optical Mouse
usb 2-1: Manufacturer: Logitech
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
swsusp: Marking nosave pages: 000000000009a000 - 0000000000100000
swsusp: Marking nosave pages: 000000007ff00000 - 0000000100000000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
libata version 3.00 loaded.
ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
i2c-adapter i2c-0: nForce2 SMBus adapter at 0xa000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0xa040
CFI: Found no ck804xrom @ffc00000 device at location zero
pata_amd 0000:00:06.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi1 : pata_amd
scsi2 : pata_amd
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000011c00 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000011c08 irq 15
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc00000 device at location zero
JEDEC: Found no ck804xrom @ffc00000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc10000 device at location zero
JEDEC: Found no ck804xrom @ffc10000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc20000 device at location zero
JEDEC: Found no ck804xrom @ffc20000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc30000 device at location zero
JEDEC: Found no ck804xrom @ffc30000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc40000 device at location zero
JEDEC: Found no ck804xrom @ffc40000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc50000 device at location zero
JEDEC: Found no ck804xrom @ffc50000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc60000 device at location zero
JEDEC: Found no ck804xrom @ffc60000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc70000 device at location zero
JEDEC: Found no ck804xrom @ffc70000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc80000 device at location zero
JEDEC: Found no ck804xrom @ffc80000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffc90000 device at location zero
JEDEC: Found no ck804xrom @ffc90000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffca0000 device at location zero
JEDEC: Found no ck804xrom @ffca0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcb0000 device at location zero
JEDEC: Found no ck804xrom @ffcb0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcc0000 device at location zero
JEDEC: Found no ck804xrom @ffcc0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffcd0000 device at location zero
JEDEC: Found no ck804xrom @ffcd0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffce0000 device at location zero
JEDEC: Found no ck804xrom @ffce0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffcf0000 device at location zero
JEDEC: Found no ck804xrom @ffcf0000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd00000 device at location zero
JEDEC: Found no ck804xrom @ffd00000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd10000 device at location zero
JEDEC: Found no ck804xrom @ffd10000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd20000 device at location zero
JEDEC: Found no ck804xrom @ffd20000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd30000 device at location zero
JEDEC: Found no ck804xrom @ffd30000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd40000 device at location zero
JEDEC: Found no ck804xrom @ffd40000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd50000 device at location zero
JEDEC: Found no ck804xrom @ffd50000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd60000 device at location zero
JEDEC: Found no ck804xrom @ffd60000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd70000 device at location zero
JEDEC: Found no ck804xrom @ffd70000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd80000 device at location zero
JEDEC: Found no ck804xrom @ffd80000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffd90000 device at location zero
JEDEC: Found no ck804xrom @ffd90000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffda0000 device at location zero
JEDEC: Found no ck804xrom @ffda0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdb0000 device at location zero
JEDEC: Found no ck804xrom @ffdb0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdc0000 device at location zero
JEDEC: Found no ck804xrom @ffdc0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffdd0000 device at location zero
JEDEC: Found no ck804xrom @ffdd0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffde0000 device at location zero
JEDEC: Found no ck804xrom @ffde0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffdf0000 device at location zero
JEDEC: Found no ck804xrom @ffdf0000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe00000 device at location zero
JEDEC: Found no ck804xrom @ffe00000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe10000 device at location zero
JEDEC: Found no ck804xrom @ffe10000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe20000 device at location zero
JEDEC: Found no ck804xrom @ffe20000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe30000 device at location zero
JEDEC: Found no ck804xrom @ffe30000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe40000 device at location zero
JEDEC: Found no ck804xrom @ffe40000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe50000 device at location zero
JEDEC: Found no ck804xrom @ffe50000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe60000 device at location zero
JEDEC: Found no ck804xrom @ffe60000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe70000 device at location zero
JEDEC: Found no ck804xrom @ffe70000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe80000 device at location zero
JEDEC: Found no ck804xrom @ffe80000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffe90000 device at location zero
JEDEC: Found no ck804xrom @ffe90000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffea0000 device at location zero
JEDEC: Found no ck804xrom @ffea0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffeb0000 device at location zero
JEDEC: Found no ck804xrom @ffeb0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffec0000 device at location zero
JEDEC: Found no ck804xrom @ffec0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffed0000 device at location zero
JEDEC: Found no ck804xrom @ffed0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffee0000 device at location zero
JEDEC: Found no ck804xrom @ffee0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @ffef0000 device at location zero
JEDEC: Found no ck804xrom @ffef0000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
JEDEC: Found no ck804xrom @fff00000 device at location zero
CFI: Found no ck804xrom @fff00000 device at location zero
Found: SST 49LF080A
ck804xrom @fff00000: Found 1 x8 devices at 0x0 in 8-bit bank
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:06 failed with error -16
sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 21 (level, high) -> IRQ 21
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
scsi3 : sata_nv
scsi4 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc20000c40480 ctl 0xffffc20000c404a0 bmdma 0x0000000000011c10 irq 21
ata4: SATA max UDMA/133 cmd 0xffffc20000c40580 ctl 0xffffc20000c405a0 bmdma 0x0000000000011c18 irq 21
ata3: SATA link down (SStatus 0 SControl 310)
ata4: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 20 (level, high) -> IRQ 20
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi5 : sata_nv
scsi6 : sata_nv
ata5: SATA max UDMA/133 cmd 0xffffc20000c42480 ctl 0xffffc20000c424a0 bmdma 0x0000000000011c20 irq 20
ata6: SATA max UDMA/133 cmd 0xffffc20000c42580 ctl 0xffffc20000c425a0 bmdma 0x0000000000011c28 irq 20
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATAPI: TSSTcorp CDDVDW SH-S203B, SB00, max UDMA/100
ata5.00: configured for UDMA/100
ata6: SATA link down (SStatus 0 SControl 310)
scsi 5:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203B  SB00 PQ: 0 ANSI: 5
ata5: bounce limit 0xFFFFFFFF, segment boundary 0xFFFF, hw segs 127
scsi 5:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LACI] -> GSI 23 (level, high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:04.0 to 64
intel8x0_measure_ac97_clock: measured 58805 usecs
intel8x0: clocking to 47044
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 22 (level, high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
floppy0: no floppy controllers found
eth0: forcedeth.c: subsystem: 010f1:2895 bound to 0000:00:0a.0
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 55
ACPI: PCI Interrupt 0000:80:0a.0[A] -> Link [LMAC] -> GSI 55 (level, high) -> IRQ 55
PCI: Setting latency timer of device 0000:80:0a.0 to 64
forcedeth: using HIGHDMA
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
eth1: forcedeth.c: subsystem: 010f1:2895 bound to 0000:80:0a.0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
sr0: scsi3-mmc drive: 0x/0x caddy
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
AppArmor: AppArmor initialized
audit(1194875465.044:2):  type=1505 info="AppArmor initialized" pid=2354
powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 270 processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
mtrr: type mismatch for a0000000,8000000 old: write-back new: write-combining
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
audit(1194875476.933:3): audit_pid=3477 old=0 by auid=4294967295
bootsplash: status on console 0 changed to on

--Boundary-00=_1PIOHM0HdTlsFP8--
