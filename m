Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZBWMGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZBWMGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZBWMGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:06:17 -0500
Received: from mail1.comlab-computer.de ([62.153.58.245]:53555 "EHLO
	mail1.comlab-computer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZBWMGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:06:13 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 07:06:12 EST
Date: Mon, 23 Feb 2009 12:58:37 +0100
From: Oliver =?UTF-8?B?TWVpw59uZXItS25pcHBzY2hpbGQ=?= 
	<lists.o@la-familia-grande.de>
To: linux-kernel@vger.kernel.org
Subject: siimage crashes on multiple SiL 0680 ATA-controller cards
Message-ID: <20090223125837.4153fd35@isis.olly-eva.lan>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got problems dealing with 2 SiL 0680 controllers at boot time.

It seems the siimage module crashes, see attached dmesg-output (at
6.624002) below.

Is it possible to load siimage twice and tell each one which controller
it should attach to (give pci-device-id as parameter) (and in which
order they have to be loaded)

an other problem is, that the order of the controllers differs changes
at each system startup, so the order of the hard drives changes (hde
becomes hda)

what can i do?

imhotep:~# uname -a
Linux imhotep 2.6.26-1-686 #1 SMP Sat Jan 10 18:29:31 UTC 2009 i686
GNU/Linux

imhotep:~# lspci
00:00.0 Host bridge: Intel Corporation 82845 845 [Brookdale]
Chipset Host Bridge (rev 04)
00:01.0 PCI bridge: Intel Corporation 82845 845 [Brookdale]
Chipset AGP Bridge (rev 04)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 05)
00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC)
(rev 05)
00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100
Controller (rev 05)
00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB
Controller #1 (rev 05)
00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus Controller
(rev 05)
00:1f.4 USB Controller: Intel Corporation 82801BA/BAM USB
Controller #1 (rev 05)
01:00.0 VGA compatible controller: ATI Technologies Inc Rage 128
PF/PRO AGP 4x TMDS
02:03.0 Multimedia audio controller: C-Media Electronics Inc
CM8738 (rev 10)
02:08.0 Ethernet controller: Intel Corporation 82801BA/BAM/CA/CAM
Ethernet Controller (rev 03)
02:0a.0 Network controller: AVM Audiovisuelles MKTG & Computer
System GmbH A1 ISDN [Fritz] (rev 02)
02:0b.0 RAID bus controller: Silicon Image, Inc. PCI0680 Ultra
ATA-133 Host Controller (rev 02)
02:0d.0 SCSI storage controller: Adaptec AHA-2940U/UW/D /
AIC-7881U (rev 01)
02:0e.0 RAID bus controller: Silicon Image, Inc. PCI0680 Ultra
ATA-133 Host Controller (rev 02)

imhotep:~# dmesg
[    0.000000]   HighMem    131052 ->   131052
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   131052
[    0.000000] On node 0 totalpages: 131052
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125964 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] Warning: acpi=force overrules DMI blacklist:
acpi=ht
[    0.000000] ACPI: RSDP 000F7710, 0014 (r0 ASUS  )
[    0.000000] ACPI: RSDT 1FFEC000, 0030 (r1 ASUS   P4B266  
42302E31 MSFT 31313031)
[    0.000000] ACPI: FACP 1FFEC100, 0074 (r1 ASUS   P4B266  
42302E31 MSFT 31313031)
[    0.000000] ACPI: DSDT 1FFEC180, 254F (r1   ASUS P4B266      
1000 MSFT  100000B)
[    0.000000] ACPI: FACS 1FFFF000, 0040
[    0.000000] ACPI: BOOT 1FFEC040, 0028 (r1 ASUS   P4B266  
42302E31 MSFT 31313031)
[    0.000000] ACPI: APIC 1FFEC080, 005A (r1 ASUS   P4B266  
42302E31 MSFT 31313031)
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge
lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000]
gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address
0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2
dfl edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 22
low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration
information
[    0.000000] Allocating PCI resources starting at 30000000
(gap: 20000000:dec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 -
0000000000100000
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping
on.  Total pages: 130028
[    0.000000] Kernel command line: root=/dev/mapper/c_root
acpi=force acpi=force vga=0x31A
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support...
done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192
bytes)
[    0.000000] Detected 1715.375 MHz processor.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 65536 (order: 6,
262144 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5,
131072 bytes)
[    0.004000] Memory: 507716k/524208k available (1769k kernel
code, 15924k reserved, 752k data, 244k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02ba4ab - 0xc0376620   ( 752 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02ba4ab   (1769 kB)
[    0.004000] Checking if this processor honours the WP bit even
in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages
preallocated
[    0.084143] Calibrating delay using timer specific routine..
3435.49 BogoMIPS (lpj=6870998)
[    0.084218] Security Framework initialized
[    0.084230] SELinux:  Disabled at boot.
[    0.084240] Capability LSM initialized
[    0.084270] Mount-cache hash table entries: 512
[    0.084536] Initializing cgroup subsys ns
[    0.084551] Initializing cgroup subsys cpuacct
[    0.084560] Initializing cgroup subsys devices
[    0.084599] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.084610] CPU: L2 cache: 256K
[    0.084617] CPU: Hyper-Threading is disabled
[    0.084625] Intel machine check architecture supported.
[    0.084638] Intel machine check reporting enabled on CPU#0.
[    0.084647] CPU0: Intel P4/Xeon Extended MCE MSRs (12)
available
[    0.084657] CPU0: Thermal monitoring enabled
[    0.084685] Checking 'hlt' instruction... OK.
[    0.100597] SMP alternatives: switching to UP code
[    0.114749] Freeing SMP alternatives: 16k freed
[    0.114770] ACPI: Core revision 20080321
[    0.121397] ENABLING IO-APIC IRQs
[    0.121607] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1
pin2=-1
[    0.161298] CPU0: Intel(R) Pentium(R) 4 CPU 1.70GHz stepping
02
[    0.164010] Brought up 1 CPUs
[    0.164010] Total of 1 processors activated (3435.49
BogoMIPS).
[    0.164010] CPU0 attaching sched-domain:
[    0.164010]  domain 0: span 0
[    0.164010]   groups: 0
[    0.164010] net_namespace: 660 bytes
[    0.164010] Booting paravirtualized kernel on bare hardware
[    0.164010] NET: Registered protocol family 16
[    0.164010] ACPI: bus type pci registered
[    0.171840] PCI: PCI BIOS revision 2.10 entry at 0xf1090, last
bus=2
[    0.171852] PCI: Using configuration type 1 for base access
[    0.171871] Setting up standard PCI resources
[    0.188011] ACPI: EC: Look up EC in DSDT
[    0.195222] ACPI: Interpreter enabled
[    0.195238] ACPI: (supports S0 S1 S3 S4 S5)
[    0.195274] ACPI: Using IOAPIC for interrupt routing
[    0.213280] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.213603] pci 0000:00:1f.0: Enabled i801 SMBus device
[    0.213620] pci 0000:00:1f.0: quirk: region e400-e47f claimed
by ICH4 ACPI/GPIO/TCO
[    0.213632] pci 0000:00:1f.0: quirk: region ec00-ec3f claimed
by ICH4 GPIO
[    0.214442] PCI: Transparent bridge - 0000:00:1e.0
[    0.214481] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0._PRT]
[    0.214648] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCI1._PRT]
[    0.214768] ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCI2._PRT]
[    0.261414] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9
10 11 12 14 15)
[    0.261587] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9
10 11 12 14 15) *0, disabled.
[    0.261771] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9
10 *11 12 14 15)
[    0.261953] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9
10 11 12 14 15)
[    0.262137] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9
10 11 12 14 15)
[    0.262319] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9
10 11 12 14 15)
[    0.262479] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9
10 11 12 14 15) *0, disabled.
[    0.262663] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9
*10 11 12 14 15)
[    0.262996] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.263069] pnp: PnP ACPI init
[    0.263096] ACPI: bus type pnp registered
[    0.271869] pnp: PnP ACPI: found 15 devices
[    0.271886] ACPI: ACPI bus type pnp unregistered
[    0.271898] PnPBIOS: Disabled by ACPI PNP
[    0.272450] PCI: Using ACPI for IRQ routing
[    0.272853] ACPI: RTC can wake from S4
[    0.272920] system 00:00: iomem range 0x0-0x9ffff could not be
reserved
[    0.272932] system 00:00: iomem range 0xf0000-0xfffff could
not be reserved
[    0.272942] system 00:00: iomem range 0x100000-0x1fffffff
could not be reserved
[    0.272956] system 00:00: iomem range 0xfec00000-0xfec000ff
could not be reserved
[    0.272968] system 00:00: iomem range 0xfee00000-0xfee00fff
could not be reserved
[    0.272990] system 00:02: ioport range 0xe400-0xe47f has been
reserved
[    0.273000] system 00:02: ioport range 0xe800-0xe81f could not
be reserved
[    0.273008] system 00:02: ioport range 0xec00-0xec3f has been
reserved
[    0.273017] system 00:02: ioport range 0x4d6-0x4d6 has been
reserved
[    0.273027] system 00:02: iomem range 0xfff80000-0xffffffff
could not be reserved
[    0.273038] system 00:02: iomem range 0xffb80000-0xffbfffff
has been reserved
[    0.273055] system 00:03: ioport range 0x4d0-0x4d1 has been
reserved
[    0.273083] system 00:0e: ioport range 0x3f0-0x3f1 has been
reserved
[    0.303871] PCI: Bridge: 0000:00:01.0
[    0.303885]   IO window: d000-dfff
[    0.303895]   MEM window: 0xf7000000-0xf7cfffff
[    0.303903]   PREFETCH window:
0x00000000f7f00000-0x00000000fdffffff
[    0.303920] PCI: Bridge: 0000:00:1e.0
[    0.303927]   IO window: 7000-bfff
[    0.303937]   MEM window: 0xf4800000-0xf6ffffff
[    0.303946]   PREFETCH window:
0x00000000f7d00000-0x00000000f7efffff
[    0.303975] PCI: Setting latency timer of device 0000:00:1e.0
to 64
[    0.304038] NET: Registered protocol family 2
[    0.304239] IP route cache hash table entries: 4096 (order: 2,
16384 bytes)
[    0.304618] TCP established hash table entries: 16384 (order:
5, 131072 bytes)
[    0.304740] TCP bind hash table entries: 16384 (order: 5,
131072 bytes)
[    0.304885] TCP: Hash tables configured (established 16384
bind 16384)
[    0.304894] TCP reno registered
[    0.305146] NET: Registered protocol family 1
[    0.305371] checking if image is initramfs...<7>Switched to
high resolution mode on CPU 0
[    0.852572]  it is
[    1.475398] Freeing initrd memory: 8127k freed
[    1.475706] Simple Boot Flag at 0x3a set to 0x1
[    1.476568] audit: initializing netlink socket (disabled)
[    1.476602] type=2000 audit(1235382370.476:1): initialized
[    1.476806] Total HugeTLB memory allocated, 0
[    1.476939] VFS: Disk quotas dquot_6.5.1
[    1.476991] Dquot-cache hash table entries: 1024 (order 0,
4096 bytes)
[    1.477058] msgmni has been set to 1007
[    1.477295] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.477310] io scheduler noop registered
[    1.477316] io scheduler anticipatory registered
[    1.477322] io scheduler deadline registered
[    1.477348] io scheduler cfq registered (default)
[    1.477413] pci 0000:01:00.0: Boot video device
[    1.478196] vesafb: framebuffer at 0xf8000000, mapped to
0xe0880000, using 5120k, total 32768k
[    1.478213] vesafb: mode is 1280x1024x16, linelength=2560,
pages=11
[    1.478222] vesafb: protected mode interface info at c000:4681
[    1.478231] vesafb: pmi: set display start = c00c46ef, set
palette = c00c4729
[    1.478240] vesafb: pmi: ports = d810 d816 d854 d838 d83c d85c
d800 d804 d8b0 d8b2 d8b4 
[    1.478262] vesafb: scrolling: redraw
[    1.478270] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.530884] Console: switching to colour frame buffer device
160x64
[    1.583558] fb0: VESA VGA frame buffer device
[    1.584027] isapnp: Scanning for PnP cards...
[    1.895184] isapnp: No Plug & Play device found
[    1.900295] Serial: 8250/16550 driver $Revision: 1.90 $ 4
ports, IRQ sharing enabled
[    1.900958] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a
16550A
[    1.901514] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a
16550A
[    1.902555] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.903192] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.906359] brd: module loaded
[    1.906768] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    1.910643] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.910957] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.911583] mice: PS/2 mouse device common for all mice
[    1.912246] rtc_cmos 00:05: rtc core: registered rtc_cmos as
rtc0
[    1.912642] rtc0: alarms up to one month
[    1.912961] cpuidle: using governor ladder
[    1.913219] cpuidle: using governor menu
[    1.913466] No iBFT detected.
[    1.914370] TCP cubic registered
[    1.914568] NET: Registered protocol family 17
[    1.914864] Using IPI No-Shortcut mode
[    1.915372] registered taskstats version 1
[    1.915838] rtc_cmos 00:05: setting system clock to 2009-02-23
09:46:12 UTC (1235382372)
[    1.916761] Freeing unused kernel memory: 244k freed
[    1.934188] input: AT Translated Set 2 keyboard as
/class/input/input0
[    2.161615] ACPI: ACPI0007:00 is registered as cooling_device0
[    2.884302] No dock devices found.
[    2.972534] SCSI subsystem initialized
[    3.076346] libata version 3.00 loaded.
[    3.179948] Uniform Multi-Platform E-IDE driver
[    3.180256] ide: Assuming 33MHz system bus speed for PIO
modes; override with idebus=xx
[    3.185794] ICH2: IDE controller (0x8086:0x244b rev 0x05) at 
PCI slot 0000:00:1f.1
[    3.186297] ICH2: not 100% native mode: will probe irqs later
[    3.186663]     ide0: BM-DMA at 0x6800-0x6807
[    3.186942]     ide1: BM-DMA at 0x6808-0x680f
[    3.187217] Probing IDE interface ide0...
[    3.368177] e100: Intel(R) PRO/100 Network Driver,
3.5.23-k4-NAPI
[    3.368573] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.480204] hda: ST3160215A, ATA DISK drive
[    3.514509] usbcore: registered new interface driver usbfs
[    3.531938] usbcore: registered new interface driver hub
[    3.568381] usbcore: registered new device driver usb
[    3.610539] USB Universal Host Controller Interface driver
v3.0
[    3.705185] Floppy drive(s): fd0 is 1.44M
[    3.757449] FDC 0 is a post-1991 82077
[    4.168095] hda: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    4.168277] hda: UDMA/100 mode selected
[    4.185617] Probing IDE interface ide1...
[    5.200177] hdd: GCR-8523B, ATAPI CD/DVD-ROM drive
[    5.272097] hdd: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    5.272167] hdd: MWDMA2 mode selected
[    5.290467] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.311188] ide1 at 0x170-0x177,0x376 on irq 15
[    5.330562] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19
(level, low) -> IRQ 19
[    5.347472] PCI: Setting latency timer of device 0000:00:1f.2
to 64
[    5.347479] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[    5.364657] uhci_hcd 0000:00:1f.2: new USB bus registered,
assigned bus number 1
[    5.383284] uhci_hcd 0000:00:1f.2: irq 19, io base 0x00006400
[    5.400501] usb usb1: configuration #1 chosen from 1 choice
[    5.417441] hub 1-0:1.0: USB hub found
[    5.434127] hub 1-0:1.0: 2 ports detected
[    5.552217] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0001
[    5.569017] usb usb1: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
[    5.585741] usb usb1: Product: UHCI Host Controller
[    5.602276] usb usb1: Manufacturer: Linux 2.6.26-1-686
uhci_hcd
[    5.618940] usb usb1: SerialNumber: 0000:00:1f.2
[    5.640013] e100 0000:02:08.0: enabling device (0014 -> 0017)
[    5.656036] ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20
(level, low) -> IRQ 20
[    5.698972] e100: eth0: e100_probe: addr 0xf6800000, irq 20,
MAC addr 00:e0:18:82:99:7f
[    5.718117] SiI680: IDE controller (0x1095:0x0680 rev 0x02) at
 PCI slot 0000:02:0b.0
[    5.735430] ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23
(level, low) -> IRQ 23
[    5.752715] SiI680: BASE CLOCK == 133
[    5.769692] SiI680: 100% native mode on irq 23
[    5.787988]     ide2: MMIO-DMA
[    5.805588]     ide3: MMIO-DMA
[    5.823393] Probing IDE interface ide2...
[    5.832002] ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23
(level, low) -> IRQ 23
[    5.848019] PCI: Setting latency timer of device 0000:00:1f.4
to 64
[    5.848026] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[    5.866896] uhci_hcd 0000:00:1f.4: new USB bus registered,
assigned bus number 2
[    5.884082] uhci_hcd 0000:00:1f.4: irq 23, io base 0x00006000
[    5.901577] usb usb2: configuration #1 chosen from 1 choice
[    5.919140] hub 2-0:1.0: USB hub found
[    5.936317] hub 2-0:1.0: 2 ports detected
[    6.052199] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0001
[    6.069636] usb usb2: New USB device strings: Mfr=3,
Product=2, SerialNumber=1
[    6.087257] usb usb2: Product: UHCI Host Controller
[    6.107275] usb usb2: Manufacturer: Linux 2.6.26-1-686
uhci_hcd
[    6.125008] usb usb2: SerialNumber: 0000:00:1f.4
[    6.252371] hde: WDC WD200BB-00DEA0, ATA DISK drive
[    6.548368] hdf: WDC WD1200JB-00GVA0, ATA DISK drive
[    6.620015] Unbalanced enable for IRQ 23
[    6.624002] ------------[ cut here ]------------
[    6.624002] WARNING: at kernel/irq/manage.c:158
enable_irq+0x2b/0x3d()
[    6.624002] Modules linked in: ide_pci_generic(+) floppy
uhci_hcd(+) aic7xxx(+) usbcore scsi_transport_spi siimage(+) e100
mii piix ide_core ata_generic libata scsi_mod dock thermal
processor fan thermal_sys twofish twofish_common
[    6.624002] Pid: 628, comm: modprobe Not tainted 2.6.26-1-686
#1
[    6.624002]  [<c012256f>] warn_on_slowpath+0x40/0x66
[    6.624002]  [<c0230710>] vt_console_print+0x0/0x23c
[    6.624002]  [<c01225ea>] __call_console_drivers+0x4f/0x5b
[    6.624002]  [<c0134d68>] up+0x9/0x2a
[    6.624002]  [<c0122a10>] release_console_sem+0x173/0x18c
[    6.624002]  [<c0129b00>] try_to_del_timer_sync+0x34/0x4a
[    6.624002]  [<c02b8550>] schedule_timeout+0x72/0x86
[    6.624002]  [<c01297ec>] process_timeout+0x0/0x5
[    6.624002]  [<c0122ea7>] printk+0x14/0x18
[    6.624002]  [<c01524f5>] __enable_irq+0x1a/0x46
[    6.624002]  [<c0152791>] enable_irq+0x2b/0x3d
[    6.624002]  [<e085fa7f>] ide_probe_port+0x3ee/0x3fa
[ide_core]
[    6.624002]  [<e0860241>] ide_device_add_all+0x1dc/0x551
[ide_core]
[    6.624002]  [<c023a971>] __driver_attach+0x0/0x55
[    6.624002]  [<e08605e5>] ide_device_add+0x2f/0x35 [ide_core]
[    6.624002]  [<e0861a3f>] ide_setup_pci_device+0x36/0x3d
[ide_core]
[    6.624002]  [<e084760d>] siimage_init_one+0x55/0x5b [siimage]
[    6.624002]  [<e084772b>] init_chipset_siimage+0x0/0x289
[siimage]
[    6.624002]  [<e0847648>] init_iops_siimage+0x0/0xe3 [siimage]
[    6.624002]  [<c01e856b>] pci_device_probe+0x36/0x57
[    6.624002]  [<c023a8fa>] driver_probe_device+0xb5/0x12c
[    6.624002]  [<c023a9a8>] __driver_attach+0x37/0x55
[    6.624002]  [<c023a23b>] bus_for_each_dev+0x37/0x59
[    6.624002]  [<c023a795>] driver_attach+0x11/0x13
[    6.624002]  [<c023a971>] __driver_attach+0x0/0x55
[    6.624002]  [<c023a598>] bus_add_driver+0x8a/0x1a6
[    6.624002]  [<c01ddbcc>] kset_find_obj+0x20/0x4b
[    6.624002]  [<c023ab89>] driver_register+0x6d/0xc1
[    6.624002]  [<c01e8722>] __pci_register_driver+0x32/0x60
[    6.624002]  [<c013f5c7>] sys_init_module+0x186c/0x19dc
[    6.624002]  [<e0843000>] uhci_hcd_init+0x0/0x8e [uhci_hcd]
[    6.624002]  [<c0127007>] __request_region+0x0/0x80
[    6.624002]  [<c01038ce>] syscall_call+0x7/0xb
[    6.624002]  =======================
[    6.624002] ---[ end trace 4f6624876ef0391d ]---
[    7.325981] hde: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    7.327063] hde: UDMA/100 mode selected
[    7.347051] hdf: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    7.348003] hdf: UDMA/100 mode selected
[    7.364727] Probing IDE interface ide3...
[    7.648369] hdg: ST380023A, ATA DISK drive
[    7.940370] hdh: ST380023A, ATA DISK drive
[    8.008103] hdg: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    8.008334] hdg: UDMA/100 mode selected
[    8.023448] hdh: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    8.023742] hdh: UDMA/100 mode selected
[    8.039584] ide2 at 0xe0858080-0xe0858087,0xe085808a on irq 23
[    8.054379] ide3 at 0xe08580c0-0xe08580c7,0xe08580ca on irq 23
[    8.071319] SiI680: IDE controller (0x1095:0x0680 rev 0x02) at
 PCI slot 0000:02:0e.0
[    8.086471] ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 18
(level, low) -> IRQ 18
[    8.101516] SiI680: BASE CLOCK == 133
[    8.116392] SiI680: 100% native mode on irq 18
[    8.131354]     ide4: MMIO-DMA
[    8.146202]     ide5: MMIO-DMA
[    8.160623] Probing IDE interface ide4...
[    8.448369] hdi: WDC WD1200JB-00GVA0, ATA DISK drive
[    8.740369] hdj: SAMSUNG SP0802N, ATA DISK drive
[    8.808107] hdi: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    8.809338] hdi: UDMA/100 mode selected
[    8.828004] hdj: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    8.828004] hdj: UDMA/100 mode selected
[    8.842209] Probing IDE interface ide5...
[    9.128382] hdk: WDC WD1200BB-22GUC0, ATA DISK drive
[    9.476097] hdk: host max PIO4 wanted PIO255(auto-tune)
selected PIO4
[    9.477316] hdk: UDMA/100 mode selected
[    9.496004] ide4 at 0xe0874080-0xe0874087,0xe087408a on irq 18
[    9.508069] ide5 at 0xe08740c0-0xe08740c7,0xe08740ca on irq 18
[    9.523242] ACPI: PCI Interrupt 0000:02:0d.0[A] -> GSI 21
(level, low) -> IRQ 21
[    9.616253] hda: max request size: 512KiB
[    9.675453] hda: 312581808 sectors (160041 MB) w/2048KiB
Cache, CHS=19457/255/63
[    9.700009] hda: cache flushes supported
[    9.714084]  hda: hda1 hda2 hda3 hda4
[    9.780413] hde: max request size: 64KiB
[    9.810358] hde: 39102336 sectors (20020 MB) w/2048KiB Cache,
CHS=38792/16/63
[    9.822385] hde: cache flushes not supported
[    9.838458]  hde: hde1 hde2 hde3
[    9.872004] hdf: max request size: 64KiB
[    9.902137] hdf: 234441648 sectors (120034 MB) w/8192KiB
Cache, CHS=16383/255/63
[    9.918878] hdf: cache flushes supported
[    9.930961]  hdf: hdf1
[    9.954160] hdg: max request size: 64KiB
[    9.972010] hdg: 156301488 sectors (80026 MB) w/2048KiB Cache,
CHS=65535/16/63
[    9.986540] hdg: cache flushes supported
[   10.000567]  hdg: hdg1
[   10.026298] hdh: max request size: 64KiB
[   10.044014] hdh: 156301488 sectors (80026 MB) w/2048KiB Cache,
CHS=65535/16/63
[   10.058837] hdh: cache flushes supported
[   10.072123]  hdh: hdh1
[   10.104894] hdi: max request size: 64KiB
[   10.135092] hdi: 234441648 sectors (120034 MB) w/8192KiB
Cache, CHS=16383/255/63
[   10.151453] hdi: cache flushes supported
[   10.165824]  hdi: hdi1 hdi2 hdi3
[   10.188006] hdj: max request size: 64KiB
[   10.204005] hdj: Host Protected Area detected.
[   10.204005] 	current capacity is 66055248 sectors (33820 MB)
[   10.204005] 	native  capacity is 156368016 sectors (80060 MB)
[   10.248195] hdj: Host Protected Area disabled.
[   10.262972] hdj: 156368016 sectors (80060 MB) w/2048KiB Cache,
CHS=16383/255/63
[   10.278381] hdj: cache flushes supported
[   10.293274]  hdj: hdj1
[   10.315708] hdk: max request size: 64KiB
[   10.344013] hdk: 234441648 sectors (120034 MB) w/2048KiB
Cache, CHS=16383/255/63
[   10.362414] hdk: cache flushes supported
[   10.375325]  hdk: hdk1 hdk3
[   24.549502] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
DRIVER, Rev 7.0
[   24.549506]         <Adaptec 2940 Ultra SCSI adapter>
[   24.549509]         aic7880: Ultra Wide Channel A, SCSI Id=7,
16/253 SCBs
[   24.549511] 
[   24.641938] scsi 0:0:0:0: Direct-Access     ST340014 A        
       3.06 PQ: 0 ANSI: 2
[   24.657859] scsi0:A:0:0: Tagged Queuing enabled.  Depth 8
[   24.673849]  target0:0:0: Beginning Domain Validation
[   24.708009]  target0:0:0: wide asynchronous
[   24.739552]  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50
ns, offset 8)
[   24.767988]  target0:0:0: Domain Validation skipping write
tests
[   24.784021]  target0:0:0: Ending Domain Validation
[   24.840096] hdd: ATAPI 52X CD-ROM drive, 128kB Cache
[   24.856802] Uniform CD-ROM driver Revision: 3.20
[   25.334538] device-mapper: uevent: version 1.0.3
[   25.356015] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18)
initialised: dm-devel@redhat.com
[   29.521130] Driver 'sd' needs updating - please use bus_type
methods
[   29.521975]  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50
ns, offset 8)
[   29.525674] sd 0:0:0:0: [sda] 78165360 512-byte hardware
sectors (40021 MB)
[   29.529769] sd 0:0:0:0: [sda] Write Protect is off
[   29.529769] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
[   29.538045] sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
[   29.538045] sd 0:0:0:0: [sda] 78165360 512-byte hardware
sectors (40021 MB)
[   29.540006] sd 0:0:0:0: [sda] Write Protect is off
[   29.540006] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
[   29.540006] sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
[   29.540006]  sda: sda1
[   29.544006] sd 0:0:0:0: [sda] Attached SCSI disk
[   47.586446] PM: Starting manual resume from disk
[   47.747321] kjournald starting.  Commit interval 5 seconds
[   47.765668] EXT3-fs: mounted filesystem with ordered data
mode.
[   52.101242] udevd version 125 started
[   57.354447] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   57.407590] Linux agpgart interface v0.103


Mit freundlichen Grüßen / Best regards,
Oliver Meissner-Knippschild <lists.o@la-familia-grande.de>
