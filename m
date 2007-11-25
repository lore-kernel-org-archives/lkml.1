Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXKYUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXKYUGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXKYUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:05:52 -0500
Received: from static-87-79-236-115.netcologne.de ([87.79.236.115]:59981 "EHLO
	alpha.blx4.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbXKYUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:05:50 -0500
X-Greylist: delayed 1776 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 15:05:49 EST
Message-ID: <4749CEA4.9070406@blx4.net>
Date: Sun, 25 Nov 2007 20:36:04 +0100
From: Mathias Kretschmer <posting@blx4.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071124)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 (gentoo + grsec) kernel BUG at mm/mlock.c:205!
Content-Type: multipart/mixed;
 boundary="------------090402010903060700020801"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090402010903060700020801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

this is a x86_64 kernel with 4GB of RAM. incident happened when
compiling cdrecord (or some variant of it :) in a 32-bit chroot jail
during the 'configure' process.

alpha / # uname -a
Linux alpha 2.6.22-hardened-r8 #10 SMP Sun Nov 25 12:52:39 CET 2007
x86_64 AMD Processor model unknown AuthenticAMD GNU/Linux

Let me know, if you need for info.

Best,

Mathias


--------------090402010903060700020801
Content-Type: text/plain;
 name="mm.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm.txt"

[    0.000000] Linux version 2.6.22-hardened-r8 (root@alpha) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #10 SMP Sun Nov 25 12:52:39 CET 2007
[    0.000000] Command line: root=/dev/ram0 lvm2root=/dev/RAID/lvm_root vga=extended panic=5
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dbfd0000 (usable)
[    0.000000]  BIOS-e820: 00000000dbfd0000 - 00000000dbfde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dbfde000 - 00000000dc000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000124000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 901072) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1196032) 2 entries of 256 used
[    0.000000] end_pfn_map = 1196032
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F90F0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT DBFD0100, 0054 (r1 101207 XSDT0933 20071012 MSFT       97)
[    0.000000] ACPI: FACP DBFD0290, 00F4 (r3 101207 FACP0933 20071012 MSFT       97)
[    0.000000] ACPI: DSDT DBFD0440, 49FA (r1  0AAAA 0AAAA000        0 INTL 20051117)
[    0.000000] ACPI: FACS DBFDE000, 0040
[    0.000000] ACPI: APIC DBFD0390, 0070 (r1 101207 APIC0933 20071012 MSFT       97)
[    0.000000] ACPI: MCFG DBFD0400, 003C (r1 101207 OEMMCFG  20071012 MSFT       97)
[    0.000000] ACPI: OEMB DBFDE040, 0091 (r1 101207 OEMB0933 20071012 MSFT       97)
[    0.000000] ACPI: HPET DBFD4E40, 0038 (r1 101207 OEMHPET0 20071012 MSFT       97)
[    0.000000] ACPI: SSDT DBFD4E80, 0248 (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 901072) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1196032) 2 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1196032
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   901072
[    0.000000]     0:  1048576 ->  1196032
[    0.000000] On node 0 totalpages: 1048431
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1764 pages reserved
[    0.000000]   DMA zone: 2179 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 882696 pages, LIFO batch:31
[    0.000000]   Normal zone: 2016 pages used for memmap
[    0.000000]   Normal zone: 145440 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
[    0.000000] PERCPU: Allocating 33264 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 1030315
[    0.000000] Kernel command line: root=/dev/ram0 lvm2root=/dev/RAID/lvm_root vga=extended panic=5
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   24.371969] time.c: Detected 2200.089 MHz processor.
[   24.375106] Console: colour VGA+ 80x50
[   24.379454] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[   24.382297] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   24.383350] Checking aperture...
[   24.383424] CPU 0: aperture @ dc000000 size 64 MB
[   24.416810] Memory: 4111084k/4784128k available (4319k kernel code, 82280k reserved, 1549k data, 296k init)
[   24.416969] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   24.476413] Calibrating delay using timer specific routine.. 4402.86 BogoMIPS (lpj=2201434)
[   24.476578] Security Framework v1.0.0 initialized
[   24.476655] Capability LSM initialized
[   24.476735] Mount-cache hash table entries: 256
[   24.476885] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   24.476964] CPU: L2 Cache: 512K (64 bytes/line)
[   24.477038] CPU: Physical Processor ID: 0
[   24.477110] CPU: Processor Core ID: 0
[   24.477195] Freeing SMP alternatives: 39k freed
[   24.477396] ACPI: Core revision 20070126
[   24.490215] Using local APIC timer interrupts.
[   24.535699] result 12500505
[   24.535769] Detected 12.500 MHz APIC timer.
[   24.536404] Booting processor 1/2 APIC 0x1
[   24.547073] Initializing CPU#1
[   24.607815] Calibrating delay using timer specific routine.. 4400.29 BogoMIPS (lpj=2200149)
[   24.607821] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   24.607823] CPU: L2 Cache: 512K (64 bytes/line)
[   24.607825] CPU: Physical Processor ID: 0
[   24.607826] CPU: Processor Core ID: 1
[   24.607914] AMD Processor model unknown stepping 02
[   24.608292] Brought up 2 CPUs
[   25.209954] migration_cost=131
[   25.209690] NET: Registered protocol family 16
[   25.209834] ACPI: bus type pci registered
[   25.212810] PCI: Using MMCONFIG at e0000000 - efffffff
[   25.212910] PCI: No mmconfig possible on device 00:18
[   25.220124] ACPI: Interpreter enabled
[   25.220200] ACPI: Using IOAPIC for interrupt routing
[   25.230416] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   25.230496] PCI: Probing PCI hardware (bus 00)
[   25.231004] PCI: Transparent bridge - 0000:00:06.0
[   25.231377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   25.231628] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   25.231791] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   25.231878] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   25.231965] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   25.232051] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   25.232138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[   25.232224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[   25.240554] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[   25.240986] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[   25.241431] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *5
[   25.241855] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[   25.242278] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[   25.242724] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
[   25.243168] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[   25.243612] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[   25.244061] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   25.244492] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *14
[   25.244924] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *14
[   25.245354] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *5
[   25.245785] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[   25.246236] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *10
[   25.246667] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *11
[   25.247097] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *7
[   25.247525] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *10
[   25.247992] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[   25.248442] ACPI: PCI Interrupt Link [LSA2] (IRQs 20 21 22 23) *11
[   25.248737] Linux Plug and Play Support v0.97 (c) Adam Belay
[   25.248824] pnp: PnP ACPI init
[   25.248899] ACPI: bus type pnp registered
[   25.253629] pnp: PnP ACPI: found 15 devices
[   25.253704] ACPI: ACPI bus type pnp unregistered
[   25.253850] Generic PHY: Registered new driver
[   25.253982] SCSI subsystem initialized
[   25.254083] libata version 2.21 loaded.
[   25.254141] usbcore: registered new interface driver usbfs
[   25.254243] usbcore: registered new interface driver hub
[   25.254347] usbcore: registered new device driver usb
[   25.254451] PCI: Using ACPI for IRQ routing
[   25.254526] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   25.254758] PCI-DMA: Disabling AGP.
[   25.255071] PCI-DMA: aperture base @ dc000000 size 65536 KB
[   25.255152] PCI-DMA: using GART IOMMU.
[   25.255228] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   25.255477] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   25.255631] hpet0: 3 32-bit timers, 25000000 Hz
[   25.256831] pnp: 00:08: iomem range 0xfea80000-0xfeabffff has been reserved
[   25.256913] pnp: 00:08: iomem range 0xfee01000-0xfeefffff has been reserved
[   25.256998] pnp: 00:0a: ioport range 0xca0-0xcaf has been reserved
[   25.257078] pnp: 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
[   25.257205] pnp: 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
[   25.257337] pnp: 00:0c: ioport range 0xa00-0xa7f has been reserved
[   25.257419] pnp: 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
[   25.257548] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   25.257627] pnp: 00:0e: iomem range 0xc0000-0xcffff has been reserved
[   25.258209] Time: hpet clocksource has been installed.
[   25.257783] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[   25.257864] pnp: 00:0e: iomem range 0x100000-0xdbffffff could not be reserved
[   25.258209] PCI: Bridge: 0000:00:06.0
[   25.258282]   IO window: e000-efff
[   25.258354]   MEM window: feb00000-febfffff
[   25.258428]   PREFETCH window: f8000000-fbffffff
[   25.258503] PCI: Bridge: 0000:00:0a.0
[   25.258576]   IO window: disabled.
[   25.258648]   MEM window: disabled.
[   25.258721]   PREFETCH window: disabled.
[   25.258794] PCI: Bridge: 0000:00:0b.0
[   25.258866]   IO window: disabled.
[   25.258938]   MEM window: disabled.
[   25.259010]   PREFETCH window: disabled.
[   25.259083] PCI: Bridge: 0000:00:0c.0
[   25.259154]   IO window: disabled.
[   25.259225]   MEM window: disabled.
[   25.259296]   PREFETCH window: disabled.
[   25.259369] PCI: Bridge: 0000:00:0d.0
[   25.259441]   IO window: disabled.
[   25.259513]   MEM window: disabled.
[   25.259585]   PREFETCH window: disabled.
[   25.259659] PCI: Bridge: 0000:00:0e.0
[   25.259732]   IO window: disabled.
[   25.259804]   MEM window: disabled.
[   25.259876]   PREFETCH window: disabled.
[   25.259949] PCI: Bridge: 0000:00:0f.0
[   25.260021]   IO window: disabled.
[   25.260093]   MEM window: disabled.
[   25.260165]   PREFETCH window: disabled.
[   25.260242] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   25.260249] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   25.260253] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   25.260258] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   25.260262] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   25.260267] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   25.260271] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   25.260280] NET: Registered protocol family 2
[   25.269662] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   25.270195] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[   25.271832] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   25.272404] TCP: Hash tables configured (established 131072 bind 65536)
[   25.272486] TCP reno registered
[   25.276746] checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
[   25.350315] Freeing initrd memory: 2453k freed
[   25.352642] audit: initializing netlink socket (disabled)
[   25.352732] audit(1196006496.932:1): initialized
[   25.354548] VFS: Disk quotas dquot_6.5.1
[   25.354667] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   25.354828] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   25.355021] fuse init (API version 7.8)
[   25.355209] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   25.355727] SGI XFS Quota Management subsystem
[   25.355879] io scheduler noop registered
[   25.356034] io scheduler cfq registered (default)
[   25.400196] Boot video device is 0000:01:0a.0
[   25.400310] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   25.400324] assign_interrupt_mode Found MSI capability
[   25.400414] Allocate Port Service[0000:00:0a.0:pcie00]
[   25.400446] Allocate Port Service[0000:00:0a.0:pcie03]
[   25.400485] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   25.400498] assign_interrupt_mode Found MSI capability
[   25.400583] Allocate Port Service[0000:00:0b.0:pcie00]
[   25.400608] Allocate Port Service[0000:00:0b.0:pcie03]
[   25.400649] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   25.400663] assign_interrupt_mode Found MSI capability
[   25.400748] Allocate Port Service[0000:00:0c.0:pcie00]
[   25.400772] Allocate Port Service[0000:00:0c.0:pcie03]
[   25.400812] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   25.400826] assign_interrupt_mode Found MSI capability
[   25.400910] Allocate Port Service[0000:00:0d.0:pcie00]
[   25.400934] Allocate Port Service[0000:00:0d.0:pcie03]
[   25.400974] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   25.400987] assign_interrupt_mode Found MSI capability
[   25.401082] Allocate Port Service[0000:00:0e.0:pcie00]
[   25.401108] Allocate Port Service[0000:00:0e.0:pcie03]
[   25.401149] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   25.401163] assign_interrupt_mode Found MSI capability
[   25.401247] Allocate Port Service[0000:00:0f.0:pcie00]
[   25.401274] Allocate Port Service[0000:00:0f.0:pcie03]
[   25.401459] input: Power Button (FF) as /class/input/input0
[   25.401536] ACPI: Power Button (FF) [PWRF]
[   25.401667] input: Power Button (CM) as /class/input/input1
[   25.401749] ACPI: Power Button (CM) [PWRB]
[   25.403902] Real Time Clock Driver v1.12ac
[   25.404139] hpet_resources: 0xfed00000 is busy
[   25.404203] Non-volatile memory driver v1.2
[   25.404300] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 1)
[   25.404432] Linux agpgart interface v0.102 (c) Dave Jones
[   25.404510] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   25.404723] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   25.404900] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   25.405224] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   25.405426] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   25.405631] Floppy drive(s): fd0 is 1.44M
[   25.421531] FDC 0 is a post-1991 82077
[   25.422457] RAMDISK driver initialized: 1 RAM disks of 8192K size 1024 blocksize
[   25.422769] loop: module loaded
[   25.422908] Marvell 88E1101: Registered new driver
[   25.423002] Marvell 88E1111: Registered new driver
[   25.423096] Marvell 88E1145: Registered new driver
[   25.423225] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
[   25.423677] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[   25.423759] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 23 (level, low) -> IRQ 23
[   25.423928] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   25.423935] forcedeth: using HIGHDMA
[   25.426371] eth0: forcedeth.c: subsystem: 010de:cb84 bound to 0000:00:08.0
[   25.426736] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 22
[   25.426814] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 22 (level, low) -> IRQ 22
[   25.426983] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   25.426986] forcedeth: using HIGHDMA
[   25.430360] eth1: forcedeth.c: subsystem: 010de:cb84 bound to 0000:00:09.0
[   25.430455] PPP generic driver version 2.4.2
[   25.430558] PPP Deflate Compression module registered
[   25.430634] PPP BSD Compression module registered
[   25.430779] PPP MPPE Compression module registered
[   25.430855] NET: Registered protocol family 24
[   25.431091] tun: Universal TUN/TAP device driver, 1.6
[   25.431167] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   25.431269] netconsole: not configured, aborting
[   25.431342] Linux video capture interface: v2.00
[   25.431471] SCSI Media Changer driver v0.25 
[   25.431588] sata_nv 0000:00:05.0: version 3.4
[   25.431884] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[   25.431963] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
[   25.432305] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   25.432397] scsi0 : sata_nv
[   25.432561] scsi1 : sata_nv
[   25.432664] ata1: SATA max UDMA/133 cmd 0x000000000001d480 ctl 0x000000000001d402 bmdma 0x000000000001cc00 irq 21
[   25.432797] ata2: SATA max UDMA/133 cmd 0x000000000001d080 ctl 0x000000000001d002 bmdma 0x000000000001cc08 irq 21
[   25.887050] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   26.166308] ata1.00: ATA-8: WDC WD7500AACS-00ZJB0, 01.01B01, max UDMA/133
[   26.166391] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   26.174807] ata1.00: configured for UDMA/133
[   26.628327] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   26.896241] ata2.00: ATA-8: WDC WD7500AACS-00ZJB0, 01.01B01, max UDMA/133
[   26.896323] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   26.904241] ata2.00: configured for UDMA/133
[   26.904378] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500AACS-0 01.0 PQ: 0 ANSI: 5
[   26.904620] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   26.904752] sd 0:0:0:0: [sda] Write Protect is off
[   26.904827] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   26.904837] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.904998] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[   26.905127] sd 0:0:0:0: [sda] Write Protect is off
[   26.905202] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   26.905212] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.905342]  sda: sda1
[   26.909729] sd 0:0:0:0: [sda] Attached SCSI disk
[   26.909848] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   26.909970] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7500AACS-0 01.0 PQ: 0 ANSI: 5
[   26.910158] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   26.910286] sd 1:0:0:0: [sdb] Write Protect is off
[   26.910361] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   26.910371] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.910522] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   26.910652] sd 1:0:0:0: [sdb] Write Protect is off
[   26.910730] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   26.910740] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.910870]  sdb: sdb1
[   26.919232] sd 1:0:0:0: [sdb] Attached SCSI disk
[   26.919350] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   26.919738] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 20
[   26.919818] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 20 (level, low) -> IRQ 20
[   26.920149] PCI: Setting latency timer of device 0000:00:05.1 to 64
[   26.920214] scsi2 : sata_nv
[   26.920383] scsi3 : sata_nv
[   26.920484] ata3: SATA max UDMA/133 cmd 0x000000000001c880 ctl 0x000000000001c802 bmdma 0x000000000001c080 irq 20
[   26.920623] ata4: SATA max UDMA/133 cmd 0x000000000001c480 ctl 0x000000000001c402 bmdma 0x000000000001c088 irq 20
[   27.374605] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   27.652626] ata3.00: ATA-8: WDC WD7500AACS-00ZJB0, 01.01B01, max UDMA/133
[   27.652708] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   27.660650] ata3.00: configured for UDMA/133
[   28.113883] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   28.412799] ata4.00: ATA-8: WDC WD7500AACS-00ZJB0, 01.01B01, max UDMA/133
[   28.412880] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   28.421144] ata4.00: configured for UDMA/133
[   28.421281] scsi 2:0:0:0: Direct-Access     ATA      WDC WD7500AACS-0 01.0 PQ: 0 ANSI: 5
[   28.421475] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[   28.421606] sd 2:0:0:0: [sdc] Write Protect is off
[   28.421681] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   28.421692] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.421852] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
[   28.421981] sd 2:0:0:0: [sdc] Write Protect is off
[   28.422056] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   28.422066] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.422195]  sdc: sdc1
[   28.429303] sd 2:0:0:0: [sdc] Attached SCSI disk
[   28.429426] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   28.429545] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7500AACS-0 01.0 PQ: 0 ANSI: 5
[   28.429729] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors (750156 MB)
[   28.429860] sd 3:0:0:0: [sdd] Write Protect is off
[   28.429936] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   28.429946] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.430095] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors (750156 MB)
[   28.430227] sd 3:0:0:0: [sdd] Write Protect is off
[   28.430304] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   28.430314] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.432311]  sdd: sdd1
[   28.435793] sd 3:0:0:0: [sdd] Attached SCSI disk
[   28.435911] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   28.436298] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 23
[   28.436376] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 23 (level, low) -> IRQ 23
[   28.436706] PCI: Setting latency timer of device 0000:00:05.2 to 64
[   28.436770] scsi4 : sata_nv
[   28.436938] scsi5 : sata_nv
[   28.437044] ata5: SATA max UDMA/133 cmd 0x000000000001c000 ctl 0x000000000001bc02 bmdma 0x000000000001b480 irq 23
[   28.437182] ata6: SATA max UDMA/133 cmd 0x000000000001b880 ctl 0x000000000001b802 bmdma 0x000000000001b488 irq 23
[   28.891132] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   29.286490] ata5.00: ATA-8: WDC WD7500AACS-00ZJB0, 01.01B01, max UDMA/133
[   29.286572] ata5.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   29.294418] ata5.00: configured for UDMA/133
[   29.748295] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   29.902230] ata6.00: ATAPI: HL-DT-STDVD-RAM GSA-H30N, 1.03, max UDMA/100
[   30.060077] ata6.00: configured for UDMA/100
[   30.060744] scsi 4:0:0:0: Direct-Access     ATA      WDC WD7500AACS-0 01.0 PQ: 0 ANSI: 5
[   30.060937] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors (750156 MB)
[   30.061068] sd 4:0:0:0: [sde] Write Protect is off
[   30.061142] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   30.061153] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.061311] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors (750156 MB)
[   30.061439] sd 4:0:0:0: [sde] Write Protect is off
[   30.061515] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   30.061525] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.061653]  sde: sde1
[   30.074239] sd 4:0:0:0: [sde] Attached SCSI disk
[   30.074359] sd 4:0:0:0: Attached scsi generic sg4 type 0
[   30.076162] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H30N 1.03 PQ: 0 ANSI: 5
[   30.084480] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   30.084606] Uniform CD-ROM driver Revision: 3.20
[   30.084720] sr 5:0:0:0: Attached scsi CD-ROM sr0
[   30.084765] sr 5:0:0:0: Attached scsi generic sg5 type 5
[   30.085249] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   30.085327] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[   30.085641] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   30.085646] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   30.085822] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   30.085968] ehci_hcd 0000:00:02.1: debug port 1
[   30.086043] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   30.086052] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeafac00
[   30.086132] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   30.086358] usb usb1: configuration #1 chosen from 1 choice
[   30.086466] hub 1-0:1.0: USB hub found
[   30.086549] hub 1-0:1.0: 10 ports detected
[   30.187457] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   30.187768] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[   30.187846] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21 (level, low) -> IRQ 21
[   30.188151] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   30.188156] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   30.188315] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   30.188456] ohci_hcd 0000:00:02.0: irq 21, io mem 0xfeafb000
[   30.241446] usb usb2: configuration #1 chosen from 1 choice
[   30.241558] hub 2-0:1.0: USB hub found
[   30.241637] hub 2-0:1.0: 10 ports detected
[   30.343311] Initializing USB Mass Storage driver...
[   30.393666] usb 1-1: new high speed USB device using ehci_hcd and address 2
[   32.328983] usb 1-1: configuration #1 chosen from 1 choice
[   32.536118] usb 1-3: new high speed USB device using ehci_hcd and address 3
[   32.650805] usb 1-3: configuration #1 chosen from 1 choice
[   32.857806] usb 1-4: new high speed USB device using ehci_hcd and address 4
[   32.972505] usb 1-4: configuration #1 chosen from 1 choice
[   32.973107] scsi6 : SCSI emulation for USB Mass Storage devices
[   32.972703] usb-storage: device found at 2
[   32.972705] usb-storage: waiting for device to settle before scanning
[   32.973248] usbcore: registered new interface driver usb-storage
[   32.973325] USB Mass Storage support registered.
[   32.973426] usbcore: registered new interface driver libusual
[   32.973555] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   32.973634] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   32.976104] serio: i8042 KBD port at 0x60,0x64 irq 1
[   32.976182] serio: i8042 AUX port at 0x60,0x64 irq 12
[   32.976292] mice: PS/2 mouse device common for all mice
[   32.976502] input: PC Speaker as /class/input/input2
[   33.018737] i2c /dev entries driver
[   33.018940] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   33.019072] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   33.230754] raid6: int64x1   2023 MB/s
[   33.247735] raid6: int64x2   2675 MB/s
[   33.264727] raid6: int64x4   2933 MB/s
[   33.281713] raid6: int64x8   2023 MB/s
[   33.298701] raid6: sse2x1    3058 MB/s
[   33.315678] raid6: sse2x2    4105 MB/s
[   33.332665] raid6: sse2x4    4187 MB/s
[   33.332738] raid6: using algorithm sse2x4 (4187 MB/s)
[   33.332814] md: raid6 personality registered for level 6
[   33.332889] md: raid5 personality registered for level 5
[   33.332965] md: raid4 personality registered for level 4
[   33.333040] raid5: automatically using best checksumming function: generic_sse
[   33.337648]    generic_sse:  6772.000 MB/sec
[   33.337722] raid5: using function: generic_sse (6772.000 MB/sec)
[   33.337866] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   33.338099] device-mapper: multipath: version 1.0.5 loaded
[   33.338176] device-mapper: multipath round-robin: version 1.0.0 loaded
[   33.338255] device-mapper: multipath emc: version 0.0.3 loaded
[   33.338437] CAPI Subsystem Rev 1.1.2.8
[   33.339317] capi20: Rev 1.1.2.7: started up with major 68 (middleware+capifs)
[   33.339417] capifs: Rev 1.1.2.3
[   33.339554] usbcore: registered new interface driver hiddev
[   33.339654] usbcore: registered new interface driver usbhid
[   33.339732] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   33.339822] Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
[   33.339976] ALSA device list:
[   33.340047]   No soundcards found.
[   33.340154] GACT probability on
[   33.340225] Mirror/redirect action on
[   33.340298] Simple TC action Loaded
[   33.340435] netem: version 1.2
[   33.340506] u32 classifier
[   33.340575]     Performance counters on
[   33.340649]     input device check on 
[   33.340721]     Actions configured 
[   33.340795] Netfilter messages via NETLINK v0.30.
[   33.340884] nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
[   33.341087] ctnetlink v0.93: registering with nfnetlink.
[   33.341427] ip_tables: (C) 2000-2006 Netfilter Core Team
[   33.341543] ClusterIP Version 0.8 loaded successfully
[   33.341620] arp_tables: (C) 2002 David S. Miller
[   33.341707] TCP westwood registered
[   33.341779] TCP vegas registered
[   33.341851] TCP veno registered
[   33.341921] Initializing XFRM netlink socket
[   33.342044] NET: Registered protocol family 1
[   33.342205] NET: Registered protocol family 10
[   33.342348] lo: Disabled Privacy Extensions
[   33.342520] NET: Registered protocol family 17
[   33.342596] NET: Registered protocol family 15
[   33.342692] Bridge firewalling registered
[   33.342766] Ebtables v2.0 registered
[   33.342931] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   33.343010] All bugs added by David S. Miller <davem@redhat.com>
[   33.343105] powernow-k8: Found 2 AMD Processor model unknown processors (version 2.00.00)
[   33.342736] powernow-k8:    0 : fid 0xf (2300 MHz), vid 0xc
[   33.342815] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xd
[   33.342892] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xf
[   33.342968] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x11
[   33.343045] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x16
[   33.343893] md: Autodetecting RAID arrays.
[   33.481833] md: autorun ...
[   33.481907] md: considering sde1 ...
[   33.481989] md:  adding sde1 ...
[   33.482067] md:  adding sdd1 ...
[   33.482144] md:  adding sdc1 ...
[   33.482221] md:  adding sdb1 ...
[   33.484287] md:  adding sda1 ...
[   33.484363] md: created md0
[   33.484438] md: bind<sda1>
[   33.484524] md: bind<sdb1>
[   33.484601] md: bind<sdc1>
[   33.484680] md: bind<sdd1>
[   33.484757] md: bind<sde1>
[   33.484834] md: running: <sde1><sdd1><sdc1><sdb1><sda1>
[   33.485076] raid5: device sde1 operational as raid disk 4
[   33.485157] raid5: device sdd1 operational as raid disk 3
[   33.485236] raid5: device sdc1 operational as raid disk 2
[   33.485315] raid5: device sdb1 operational as raid disk 1
[   33.485396] raid5: device sda1 operational as raid disk 0
[   33.485844] raid5: allocated 5312kB for md0
[   33.485922] raid5: raid level 6 set md0 active with 5 out of 5 devices, algorithm 2
[   33.486053] RAID5 conf printout:
[   33.486127]  --- rd:5 wd:5
[   33.486200]  disk 0, o:1, dev:sda1
[   33.486274]  disk 1, o:1, dev:sdb1
[   33.486349]  disk 2, o:1, dev:sdc1
[   33.486427]  disk 3, o:1, dev:sdd1
[   33.486501]  disk 4, o:1, dev:sde1
[   33.486618] md: ... autorun DONE.
[   33.486780] RAMDISK: Compressed image found at block 0
[   33.569930] VFS: Mounted root (ext2 filesystem) readonly.
[   33.570037] Freeing unused kernel memory: 296k freed
[   33.675360] Filesystem "dm-0": Disabling barriers, not supported by the underlying device
[   33.705984] XFS mounting filesystem dm-0
[   33.930913] Ending clean XFS mount for filesystem: dm-0
[   35.683078] usb 1-3: USB disconnect, address 3
[   35.683088] cinergyT2: probe of 1-3:1.0 failed with error -32
[   35.790423] usb 1-3: new high speed USB device using ehci_hcd and address 5
[   35.910317] usb 1-3: configuration #1 chosen from 1 choice
[   35.950462] usb 1-4: USB disconnect, address 4
[   35.950471] cinergyT2: probe of 1-4:1.0 failed with error -32
[   35.957212] ath_hal: module license 'Proprietary' taints kernel.
[   35.957861] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
[   35.964099] wlan: 0.8.4.2 (svn r2966)
[   35.967431] ath_pci: 0.9.4.5 (svn r2966)
[   35.967778] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[   35.967784] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [LNKA] -> GSI 19 (level, low) -> IRQ 19
[   36.398314] ath_pci: switching rfkill capability off
[   36.410563] ath_rate_minstrel: Minstrel automatic rate control algorithm 1.2 (svn r2966)
[   36.410567] ath_rate_minstrel: look around rate set to 10%
[   36.410569] ath_rate_minstrel: EWMA rolloff level set to 75%
[   36.410571] ath_rate_minstrel: max segment size in the mrr set to 6000 us
[   36.410693] ath_pci: switching per-packet transmit power control off
[   36.410830] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   36.410834] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   36.410841] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   36.410846] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   36.410850] wifi0: mac 5.9 phy 4.3 radio 4.6
[   36.410853] wifi0: Use hw queue 1 for WME_AC_BE traffic
[   36.410855] wifi0: Use hw queue 0 for WME_AC_BK traffic
[   36.410857] wifi0: Use hw queue 2 for WME_AC_VI traffic
[   36.410858] wifi0: Use hw queue 3 for WME_AC_VO traffic
[   36.410860] wifi0: Use hw queue 8 for CAB traffic
[   36.410862] wifi0: Use hw queue 9 for beacons
[   36.413095] wifi0: Atheros 5212: mem=0xfebf0000, irq=19
[   36.414032] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 18
[   36.414040] ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [LNKC] -> GSI 18 (level, low) -> IRQ 18
[   36.452596] usb 1-4: new high speed USB device using ehci_hcd and address 6
[   36.572506] usb 1-4: configuration #1 chosen from 1 choice
[   36.573100] DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver).
[   36.573342] DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver).
[   36.573499] usbcore: registered new interface driver cinergyT2
[   37.133800] Filesystem "dm-0": Disabling barriers, not supported by the underlying device
[   37.679733] Filesystem "dm-4": Disabling barriers, not supported by the underlying device
[   37.679978] XFS mounting filesystem dm-4
[   37.981521] Ending clean XFS mount for filesystem: dm-4
[   38.001166] Filesystem "dm-3": Disabling barriers, not supported by the underlying device
[   38.014478] XFS mounting filesystem dm-3
[   38.122224] Ending clean XFS mount for filesystem: dm-3
[   38.135547] Filesystem "dm-5": Disabling barriers, not supported by the underlying device
[   38.158121] XFS mounting filesystem dm-5
[   38.180286] usb-storage: device scan complete
[   38.181180] scsi 6:0:0:0: Direct-Access     USB 2.0  Reader(SM)       2003 PQ: 0 ANSI: 2
[   38.182215] scsi 6:0:0:1: Direct-Access     USB 2.0  Reader(MS+/SD+)  2003 PQ: 0 ANSI: 2
[   38.184826] scsi 6:0:0:2: Direct-Access     USB 2.0  Reader(CF)       2003 PQ: 0 ANSI: 2
[   38.187344] sd 6:0:0:0: [sdf] Attached SCSI removable disk
[   38.187376] sd 6:0:0:0: Attached scsi generic sg6 type 0
[   38.189417] sd 6:0:0:1: [sdg] Attached SCSI removable disk
[   38.189442] sd 6:0:0:1: Attached scsi generic sg7 type 0
[   38.193569] sd 6:0:0:2: [sdh] 500400 512-byte hardware sectors (256 MB)
[   38.195308] sd 6:0:0:2: [sdh] Write Protect is off
[   38.195311] sd 6:0:0:2: [sdh] Mode Sense: 03 00 00 00
[   38.195313] sd 6:0:0:2: [sdh] Assuming drive cache: write through
[   38.200878] sd 6:0:0:2: [sdh] 500400 512-byte hardware sectors (256 MB)
[   38.202575] sd 6:0:0:2: [sdh] Write Protect is off
[   38.202577] sd 6:0:0:2: [sdh] Mode Sense: 03 00 00 00
[   38.202579] sd 6:0:0:2: [sdh] Assuming drive cache: write through
[   38.202582]  sdh: sdh1
[   38.206535] sd 6:0:0:2: [sdh] Attached SCSI removable disk
[   38.206561] sd 6:0:0:2: Attached scsi generic sg8 type 0
[   38.320814] Ending clean XFS mount for filesystem: dm-5
[   38.325883] Filesystem "dm-8": Disabling barriers, not supported by the underlying device
[   38.326770] XFS mounting filesystem dm-8
[   38.519124] Ending clean XFS mount for filesystem: dm-8
[   38.535176] Filesystem "dm-6": Disabling barriers, not supported by the underlying device
[   38.551496] XFS mounting filesystem dm-6
[   38.717297] Ending clean XFS mount for filesystem: dm-6
[   39.072954] Adding 8388600k swap on /dev/RAID/lvm_swap.  Priority:-1 extents:1 across:8388600k
[   40.657203] grsec: time set by /sbin/hwclock[hwclock:2209] uid/euid:0/0 gid/egid:0/0, parent /bin/bash[bash:2208] uid/euid:0/0 gid/egid:0/0
[   47.790364] Modular ISDN Stack core version () revision ($Revision: 1.40 $)
[   47.790519] mISDNd: kernel daemon started (current:ffff810123442ea0)
[   47.790660] mISDNd: test event done
[   47.813027] ISDN L1 driver version 1.20
[   47.828937] ISDN L2 driver version 1.32
[   47.846247] mISDN: DSS1 Rev. 1.47
[   47.861828] mISDN Capi 2.0 driver file version 1.21
[   48.158529] HFC card ffff81012291d000 dch ffff81012291d0a0 bch1 ffff81012291d300 bch2 ffff81012291d560
[   48.158535] mISDN: HFC-PCI driver Rev. 1.49
[   48.158856] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 17
[   48.158863] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNKD] -> GSI 17 (level, low) -> IRQ 17
[   48.158872] mISDN: HFC-PCI card manufacturer: CCD/Billion/Asuscom card name: 2BD0
[   48.158901] HFC-PCI: defined at mem 0xffffc2000007ac00 fifo 0xffff8100ced08000(0xced08000) IRQ 17 HZ 1000
[   48.158906] reset_hfcpci: entered
[   48.158908] HFC_PCI: resetting HFC ChipId(30)
[   48.158912] HFC-PCI status(4) before reset
[   48.169366] HFC-PCI status(2) after reset
[   48.169375] HFC-PCI status(4) after 5us
[   48.169458] init_card: entered
[   48.169468] inithfcpci: entered
[   48.253078] HFC PCI: IRQ 17 count 36
[   48.253089] HFC card ffff8100cecd9000 dch ffff8100cecd90a0 bch1 ffff8100cecd9300 bch2 ffff8100cecd9560
[   48.253093] mISDN: HFC-PCI driver Rev. 1.49
[   48.253097] HFC-PCI: No more PCI cards found
[   48.253100] HFC 1 cards installed
[   48.263997] mISDN_dsp: Audio DSP  Rev. 1.29 (debug=0x0) EchoCancellor MG2 dtmfthreshold(100)
[   48.264002] mISDN_dsp: DSP clocks every 64 samples. This equals 8 jiffies.
[   52.364704] Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
[   52.364711] bonding: MII link monitoring set to 100 ms
[   52.387882] ADDRCONF(NETDEV_UP): bond0: link is not ready
[   52.474356] bonding: bond0: enslaving eth0 as an active interface with an up link.
[   52.477912] ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   52.499892] bonding: bond0: enslaving eth1 as an active interface with an up link.
[   52.646776] bond0.1: add 33:33:00:00:00:01 mcast address to master interface
[   52.646790] bond0.1: add 01:00:5e:00:00:01 mcast address to master interface
[   52.650253] bond0.1: add 33:33:ff:78:12:16 mcast address to master interface
[   52.848424] bond0.2: add 33:33:00:00:00:01 mcast address to master interface
[   52.848440] bond0.2: add 01:00:5e:00:00:01 mcast address to master interface
[   52.851890] bond0.2: add 33:33:ff:78:12:16 mcast address to master interface
[   53.003126] bond0.3: add 33:33:00:00:00:01 mcast address to master interface
[   53.003142] bond0.3: add 01:00:5e:00:00:01 mcast address to master interface
[   53.006596] bond0.3: add 33:33:ff:78:12:16 mcast address to master interface
[   57.025272] bond0.1: dev_set_promiscuity(master, 1)
[   57.025406] device eth0 entered promiscuous mode
[   57.025413] audit(1196006528.667:2): dev=eth0 prom=256 old_prom=0 auid=4294967295
[   57.025541] device eth1 entered promiscuous mode
[   57.025544] audit(1196006528.667:3): dev=eth1 prom=256 old_prom=0 auid=4294967295
[   57.025548] device bond0 entered promiscuous mode
[   57.025552] audit(1196006528.667:4): dev=bond0 prom=256 old_prom=0 auid=4294967295
[   57.025554] device bond0.1 entered promiscuous mode
[   57.025558] audit(1196006528.667:5): dev=bond0.1 prom=256 old_prom=0 auid=4294967295
[   57.032670] device ath0 entered promiscuous mode
[   57.032682] audit(1196006528.674:6): dev=ath0 prom=256 old_prom=0 auid=4294967295
[   57.046393] br0: port 2(ath0) entering learning state
[   57.046400] br0: port 1(bond0.1) entering learning state
[   62.763990] ath0: no IPv6 routers present
[   63.305002] eth0: no IPv6 routers present
[   63.464212] eth1: no IPv6 routers present
[   63.475699] bond0.1: no IPv6 routers present
[   63.554031] bond0.3: no IPv6 routers present
[   63.598488] bond0: no IPv6 routers present
[   64.118025] bond0.2: no IPv6 routers present
[   67.546874] br0: no IPv6 routers present
[   69.529775] dummy0: no IPv6 routers present
[   70.193209] br0: port 2(ath0) entering disabled state
[   70.236871] br0: port 2(ath0) entering learning state
[   70.552419] br0: topology change detected, propagating
[   70.552425] br0: port 1(bond0.1) entering forwarding state
[   74.905927] ath0: no IPv6 routers present
[   78.055054] br0: topology change detected, propagating
[   78.055060] br0: port 2(ath0) entering forwarding state
[   81.312541] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   81.312557] NFSD: starting 90-second grace period
[   81.313577] grsec: denied resource overstep by requesting 93135438180352 for RLIMIT_STACK against limit 8388608 for /[rpc.nfsd:10168] uid/euid:0/0 gid/egid:0/0, parent /sbin/runscript.sh[runscript.sh:10134] uid/euid:0/0 gid/egid:0/0
[  561.663439] br0: port 2(ath0) entering disabled state
[  561.762918] br0: port 2(ath0) entering learning state
[  566.445364] ath0: no IPv6 routers present
[  568.574663] br0: topology change detected, propagating
[  568.574668] br0: port 2(ath0) entering forwarding state
[  618.966030] br0: port 2(ath0) entering disabled state
[  619.064664] br0: port 2(ath0) entering learning state
[  623.713108] ath0: no IPv6 routers present
[  625.876464] br0: topology change detected, propagating
[  625.876469] br0: port 2(ath0) entering forwarding state
[  867.456740] usb 1-4: USB disconnect, address 6
[  867.770816] usb 1-3: USB disconnect, address 5
[  870.200090] usb 1-4: new high speed USB device using ehci_hcd and address 7
[  870.252302] usb 1-4: configuration #1 chosen from 1 choice
[  870.252452] DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver).
[  871.486568] usb 1-3: new high speed USB device using ehci_hcd and address 8
[  871.538833] usb 1-3: configuration #1 chosen from 1 choice
[  871.539034] DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver).
[ 1105.815992] br0: port 2(ath0) entering disabled state
[ 1105.923941] br0: port 2(ath0) entering learning state
[ 1110.673066] ath0: no IPv6 routers present
[ 1112.735607] br0: topology change detected, propagating
[ 1112.735613] br0: port 2(ath0) entering forwarding state
[ 2493.512439] br0: port 2(ath0) entering disabled state
[ 2519.014672] ------------[ cut here ]------------
[ 2519.014704] kernel BUG at mm/mlock.c:205!
[ 2519.014731] invalid opcode: 0000 [1] SMP 
[ 2519.014759] CPU 0 
[ 2519.014784] Modules linked in: wlan_ccmp wlan_tkip wlan_xauth bonding mISDN_dsp hfcpci mISDN_capi l3udss1 mISDN_l2 mISDN_l1 mISDN_core wlan_scan_ap ath_rate_minstrel snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_page_alloc snd_util_mem snd_hwdep ath_pci wlan ath_hal(P) cinergyT2
[ 2519.014911] Pid: 23439, comm: conftest Tainted: P       2.6.22-hardened-r8 #10
[ 2519.014962] RIP: 0010:[<ffffffff80275269>]  [<ffffffff80275269>] do_mlockall+0xf9/0x100
[ 2519.015019] RSP: 0018:ffff81003ea87f38  EFLAGS: 00010287
[ 2519.015047] RAX: 00000000c0000000 RBX: 0000000000000003 RCX: 00000000fffff000
[ 2519.015078] RDX: 00000000ffffe000 RSI: 00000000ff892000 RDI: ffff81003e746b00
[ 2519.015110] RBP: ffff81003ea87f48 R08: 800000003e5a8067 R09: 0000000000da3cc0
[ 2519.015140] R10: 000000000003cc2f R11: 0000000000000002 R12: 0000000000000000
[ 2519.015169] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2519.015200] FS:  00002b7a4bd99000(0000) GS:ffffffff807bc000(0063) knlGS:00000000556cb6c0
[ 2519.015252] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2519.015281] CR2: 0000000055652be0 CR3: 000000003e71f000 CR4: 00000000000006e0
[ 2519.015312] Process conftest (pid: 23439, threadinfo ffff81003ea86000, task ffff8100c09e35f0)
[ 2519.015363] Stack:  0000000000000000 ffffffff8023963c ffff81003e746790 0000000000000003
[ 2519.015418]  00000000fffffff4 ffffffff8027564b 0000000000000000 0000000000000003
[ 2519.015470]  00000000ff88f9e0 ffffffff80220dc4 0000000000000202 ffff81003ea86000
[ 2519.015501] Call Trace:
[ 2519.015551]  [<ffffffff8023963c>] __capable+0x3c/0x50
[ 2519.015581]  [<ffffffff8027564b>] sys_mlockall+0xbb/0x100
[ 2519.015611]  [<ffffffff80220dc4>] cstar_do_call+0x1b/0x65
[ 2519.015641] 
[ 2519.015664] 
[ 2519.015665] Code: 0f 0b eb fe 0f 1f 00 48 81 c6 ff 0f 00 00 48 83 ec 38 48 81 
[ 2519.015752] RIP  [<ffffffff80275269>] do_mlockall+0xf9/0x100
[ 2519.015782]  RSP <ffff81003ea87f38>
[ 2634.880291] ------------[ cut here ]------------
[ 2634.880331] kernel BUG at mm/mlock.c:205!
[ 2634.880367] invalid opcode: 0000 [2] SMP 
[ 2634.880423] CPU 0 
[ 2634.880465] Modules linked in: wlan_ccmp wlan_tkip wlan_xauth bonding mISDN_dsp hfcpci mISDN_capi l3udss1 mISDN_l2 mISDN_l1 mISDN_core wlan_scan_ap ath_rate_minstrel snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_page_alloc snd_util_mem snd_hwdep ath_pci wlan ath_hal(P) cinergyT2
[ 2634.880844] Pid: 28580, comm: conftest Tainted: P       2.6.22-hardened-r8 #10
[ 2634.880905] RIP: 0010:[<ffffffff80275269>]  [<ffffffff80275269>] do_mlockall+0xf9/0x100
[ 2634.880982] RSP: 0018:ffff810065015f38  EFLAGS: 00010287
[ 2634.881019] RAX: 00000000c0000000 RBX: 0000000000000003 RCX: 00000000fffff000
[ 2634.881058] RDX: 00000000ffffe000 RSI: 00000000ffa2e000 RDI: ffff8100c18230b0
[ 2634.881098] RBP: ffff810065015f48 R08: 800000005fe05067 R09: 00000000014f9118
[ 2634.881137] R10: 000000000003ad72 R11: 0000000000000002 R12: 0000000000000000
[ 2634.881176] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2634.881216] FS:  000000004a814950(0000) GS:ffffffff807bc000(0063) knlGS:00000000556cb6c0
[ 2634.881278] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2634.881316] CR2: 0000000055652be0 CR3: 000000005fe04000 CR4: 00000000000006e0
[ 2634.881356] Process conftest (pid: 28580, threadinfo ffff810065014000, task ffff8100a1014000)
[ 2634.881416] Stack:  0000000000000000 ffffffff8023963c ffff8100c1823630 0000000000000003
[ 2634.881527]  00000000fffffff4 ffffffff8027564b 0000000000000000 0000000000000003
[ 2634.881626]  00000000ffa2b9e0 ffffffff80220dc4 0000000000000202 ffff810065014000
[ 2634.881695] Call Trace:
[ 2634.881763]  [<ffffffff8023963c>] __capable+0x3c/0x50
[ 2634.881802]  [<ffffffff8027564b>] sys_mlockall+0xbb/0x100
[ 2634.881840]  [<ffffffff80220dc4>] cstar_do_call+0x1b/0x65
[ 2634.881878] 
[ 2634.881910] 
[ 2634.881911] Code: 0f 0b eb fe 0f 1f 00 48 81 c6 ff 0f 00 00 48 83 ec 38 48 81 
[ 2634.882206] RIP  [<ffffffff80275269>] do_mlockall+0xf9/0x100
[ 2634.882254]  RSP <ffff810065015f38>
[ 2683.701648] br0: port 2(ath0) entering learning state
[ 2692.452992] ath0: no IPv6 routers present
[ 2696.526055] br0: topology change detected, propagating
[ 2696.526124] br0: port 2(ath0) entering forwarding state
[ 3084.892340] process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
[ 5313.978388] device br0 entered promiscuous mode
[ 5313.978460] audit(1196015265.583:7): dev=br0 prom=256 old_prom=0 auid=4294967295
[ 6953.457186] device br0 left promiscuous mode
[ 6953.457245] audit(1196017022.992:8): dev=br0 prom=0 old_prom=256 auid=4294967295

--------------090402010903060700020801--
