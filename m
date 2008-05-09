Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYEIU4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYEIU4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYEIU4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:56:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:53389 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYEIU43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:56:29 -0400
Subject: linux-next: WARNING: at fs/sysfs/dir.c:425
	sysfs_add_one+0x31/0x7a()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 May 2008 22:56:20 +0200
Message-Id: <1210366580.4148.4.camel@dhcppc1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this warning while setting up a packet dvd mapping with:

# pktsetup pktcdvd0 /dev/sr0

PS: Is the bug descibed in commit 7b3d9545f9ac8b31528dd2d6d8ec8d19922917b8 already fixed?
->

    The proper fix for that is probably to just do something like
    
        bdev->bd_inode->i_size = (loff_t)get_capacity(disk)<<9;
    
    in fs/block_dev.c:do_open() even for the cases where we're not the
    original opener (but *not* call bd_set_size(), since that will also
    change the block size of the device).


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-rc1-next-20080509 (thomas@dhcppc1) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #26 SMP Fri May 9 18:48:22 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] 6272MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Entering add_active_range(0, 0, 1835008) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1835008
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1835008
[    0.000000] On node 0 totalpages: 1835008
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 12544 pages used for memmap
[    0.000000]   HighMem zone: 1593088 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F98B0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFD0000, 003C (r1 MSIISM OEMRSDT   4000807 MSFT       97)
[    0.000000] ACPI: FACP BFFD0200, 0084 (r2 MSIISM OEMFACP   4000807 MSFT       97)
[    0.000000] ACPI: DSDT BFFD0440, 5045 (r1  1ADGH 1ADGH013       13 INTL 20051117)
[    0.000000] ACPI: FACS BFFDE000, 0040
[    0.000000] ACPI: APIC BFFD0390, 0070 (r1 MSIISM OEMAPIC   4000807 MSFT       97)
[    0.000000] ACPI: MCFG BFFD0400, 003C (r1 MSIISM OEMMCFG   4000807 MSFT       97)
[    0.000000] ACPI: OEMB BFFDE040, 0061 (r1 MSIISM AMI_OEM   4000807 MSFT       97)
[    0.000000] ACPI: HPET BFFD5490, 0038 (r1 MSIISM OEMHPET0  4000807 MSFT       97)
[    0.000000] ACPI: SSDT BFFD54D0, 028A (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 40616 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 2
[    0.693310] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1820672
[    0.693310] Kernel command line: ro root=LABEL=ROOT rhgb
[    0.693310] mapped APIC to ffffb000 (fee00000)
[    0.693310] mapped IOAPIC to ffffa000 (fec00000)
[    0.693310] Enabling fast FPU save and restore... done.
[    0.693310] Enabling unmasked SIMD FPU exception support... done.
[    0.693310] Initializing CPU#0
[    0.693310] CPU 0 irqstacks, hard=c07b4000 soft=c0794000
[    0.693310] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.693310] Detected 2599.983 MHz processor.
[    0.693310] spurious 8259A interrupt: IRQ7.
[    0.693310] Console: colour VGA+ 80x25
[    0.693310] console [tty0] enabled
[    0.693310] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.693310] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.693310] Memory: 6224164k/7340032k available (2203k kernel code, 65888k reserved, 1153k data, 272k init, 5373760k highmem)
[    0.693310] virtual kernel memory layout:
[    0.693310]     fixmap  : 0xffe13000 - 0xfffff000   (1968 kB)
[    0.693310]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.693310]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.693310]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.693310]       .init : 0xc074d000 - 0xc0791000   ( 272 kB)
[    0.693310]       .data : 0xc0626fe5 - 0xc07476e0   (1153 kB)
[    0.693310]       .text : 0xc0400000 - 0xc0626fe5   (2203 kB)
[    0.693310] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.693310] CPA: page pool initialized 1 of 1 pages preallocated
[    0.693310] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.693310] hpet clockevent registered
[    0.753179] Calibrating delay using timer specific routine.. 5203.25 BogoMIPS (lpj=2601627)
[    0.753301] Security Framework initialized
[    0.753301] SELinux:  Initializing.
[    0.753301] SELinux:  Starting in permissive mode
[    0.753301] selinux_register_security:  Registering secondary module capability
[    0.753301] Capability LSM initialized as secondary
[    0.753301] Mount-cache hash table entries: 512
[    0.753301] Initializing cgroup subsys ns
[    0.753301] Initializing cgroup subsys cpuacct
[    0.753301] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.753301] CPU: L2 Cache: 512K (64 bytes/line)
[    0.753301] CPU 0(2) -> Core 0
[    0.753301] Intel machine check architecture supported.
[    0.753301] Intel machine check reporting enabled on CPU#0.
[    0.753373] Checking 'hlt' instruction... OK.
[    0.758300] ACPI: Core revision 20080321
[    0.764544] ENABLING IO-APIC IRQs
[    0.764807] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.774854] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.775298] CPU 1 irqstacks, hard=c07b5000 soft=c0795000
[    0.775298] Booting processor 1/1 ip 6000
[    0.775298] Initializing CPU#1
[    0.775298] Calibrating delay using timer specific routine.. 5199.66 BogoMIPS (lpj=2599831)
[    0.775298] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.775298] CPU: L2 Cache: 512K (64 bytes/line)
[    0.775298] CPU 1(2) -> Core 1
[    0.775298] Intel machine check architecture supported.
[    0.775298] Intel machine check reporting enabled on CPU#1.
[    0.775298] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.846287] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.846873] Brought up 2 CPUs
[    0.846928] Total of 2 processors activated (10402.91 BogoMIPS).
[    0.847023] CPU0 attaching sched-domain:
[    0.847025]  domain 0: span 0-1
[    0.847026]   groups: 0 1
[    0.847029] CPU1 attaching sched-domain:
[    0.847031]  domain 0: span 0-1
[    0.847032]   groups: 1 0
[    0.847287] net_namespace: 660 bytes
[    0.847287] Booting paravirtualized kernel on bare hardware
[    0.847287] NET: Registered protocol family 16
[    0.847287] No dock devices found.
[    0.848287] ACPI: bus type pci registered
[    0.848287] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.848287] PCI: Not using MMCONFIG.
[    0.848287] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
[    0.848287] PCI: Using configuration type 1 for base access
[    0.848287] Setting up standard PCI resources
[    0.853772] ACPI: EC: Look up EC in DSDT
[    0.862056] ACPI: Interpreter enabled
[    0.862113] ACPI: (supports S0 S1 S3 S4 S5)
[    0.862276] ACPI: Using IOAPIC for interrupt routing
[    0.862284] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.866970] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.867029] PCI: Using MMCONFIG for extended config space
[    0.875346] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.876282] PCI: Transparent bridge - 
[    0.876282] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.876559] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.876715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.876797] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.876880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.876962] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.877044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.877126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.886281] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.886281] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.886669] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.887054] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.887441] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.887827] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.888191] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.888579] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.888964] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
[    0.889280] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
[    0.889589] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
[    0.889933] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
[    0.890240] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
[    0.890588] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.890933] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.891278] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
[    0.891626] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
[    0.892003] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
[    0.892372] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.893280] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 03, should be 02 [20080321]
[    0.893280] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.893280] pnp: PnP ACPI init
[    0.893280] ACPI: bus type pnp registered
[    0.898274] pnp: PnP ACPI: found 15 devices
[    0.898279] ACPI: ACPI bus type pnp unregistered
[    0.898279] usbcore: registered new interface driver usbfs
[    0.898279] usbcore: registered new interface driver hub
[    0.898279] usbcore: registered new device driver usb
[    0.898279] PCI: Using ACPI for IRQ routing
[    0.900252] NetLabel: Initializing
[    0.900279] NetLabel:  domain hash size = 128
[    0.900279] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.900279] NetLabel:  unlabeled traffic allowed by default
[    0.900279] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.900279] hpet0: 3 32-bit timers, 25000000 Hz
[    0.901278] tracer: 643 pages allocated for 65536<6> entries of 40 bytes
[    0.901278]    actual entries 65586
[    0.901402] Switched to high resolution mode on CPU 0
[    0.901402] Switched to high resolution mode on CPU 1
[    0.905438] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.905497] system 00:06: ioport range 0x800-0x80f has been reserved
[    0.905556] system 00:06: ioport range 0x2000-0x207f has been reserved
[    0.906306] system 00:06: ioport range 0x2080-0x20ff has been reserved
[    0.906316] system 00:06: ioport range 0x2400-0x247f has been reserved
[    0.906381] system 00:06: ioport range 0x2480-0x24ff has been reserved
[    0.906440] system 00:06: ioport range 0x2800-0x287f has been reserved
[    0.906499] system 00:06: ioport range 0x2880-0x28ff has been reserved
[    0.906558] system 00:06: ioport range 0x2c00-0x2c7f has been reserved
[    0.906619] system 00:06: ioport range 0x2c80-0x2cff has been reserved
[    0.906679] system 00:06: iomem range 0xfbf80000-0xfbfbffff has been reserved
[    0.906739] system 00:06: iomem range 0xfee01000-0xfeefffff could not be reserved
[    0.906835] system 00:08: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.906927] system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.907022] system 00:0b: ioport range 0xa00-0xa0f has been reserved
[    0.907081] system 00:0b: ioport range 0xa10-0xa1f has been reserved
[    0.907143] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.907205] system 00:0d: iomem range 0xd0000000-0xdfffffff could not be reserved
[    0.907300] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.907325] system 00:0e: iomem range 0xc0000-0xcffff could not be reserved
[    0.907390] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.907449] system 00:0e: iomem range 0x100000-0xbfffffff could not be reserved
[    0.907541] system 00:0e: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.938315] PCI: Bridge: 0000:00:06.0
[    0.938315]   IO window: disabled.
[    0.938377]   MEM window: disabled.
[    0.938433]   PREFETCH window: disabled.
[    0.938489] PCI: Bridge: 0000:00:0a.0
[    0.938545]   IO window: disabled.
[    0.938605]   MEM window: disabled.
[    0.938661]   PREFETCH window: disabled.
[    0.938718] PCI: Bridge: 0000:00:0b.0
[    0.938773]   IO window: disabled.
[    0.938829]   MEM window: disabled.
[    0.938884]   PREFETCH window: disabled.
[    0.938941] PCI: Bridge: 0000:00:0c.0
[    0.938996]   IO window: disabled.
[    0.939052]   MEM window: disabled.
[    0.939107]   PREFETCH window: disabled.
[    0.939164] PCI: Bridge: 0000:00:0d.0
[    0.939219]   IO window: disabled.
[    0.939275]   MEM window: disabled.
[    0.939331]   PREFETCH window: disabled.
[    0.939393] PCI: Bridge: 0000:00:0e.0
[    0.939448]   IO window: disabled.
[    0.939504]   MEM window: disabled.
[    0.939559]   PREFETCH window: disabled.
[    0.939621] PCI: Bridge: 0000:00:0f.0
[    0.939677]   IO window: e000-efff
[    0.939733]   MEM window: 0xfc000000-0xfebfffff
[    0.939790]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[    0.939854] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.939861] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    0.939867] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.939873] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.939879] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.939884] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.939890] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    0.939900] NET: Registered protocol family 2
[    0.943400] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.943694] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.944418] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.944793] TCP: Hash tables configured (established 131072 bind 65536)
[    0.944852] TCP reno registered
[    0.946411] NET: Registered protocol family 1
[    0.946570] checking if image is initramfs... it is
[    1.118365] Freeing initrd memory: 2990k freed
[    1.119249] Machine check exception polling timer started.
[    1.119270] audit: initializing netlink socket (disabled)
[    1.119270] type=2000 audit(1210363084.427:1): initialized
[    1.124252] highmem bounce pool size: 64 pages
[    1.124252] Total HugeTLB memory allocated, 0
[    1.126302] VFS: Disk quotas dquot_6.5.1
[    1.126302] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.126304] msgmni has been set to 1668 for ipc namespace c071fcc0
[    1.126304] SELinux:  Registering netfilter hooks
[    1.126426] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.126518] io scheduler noop registered
[    1.126574] io scheduler anticipatory registered
[    1.126631] io scheduler deadline registered
[    1.126694] io scheduler cfq registered (default)
[    1.126774] pci 0000:00:00.0: Enabling HT MSI Mapping
[    1.137360] pci 0000:00:05.0: Enabling HT MSI Mapping
[    1.137427] pci 0000:00:05.1: Enabling HT MSI Mapping
[    1.137493] pci 0000:00:05.2: Enabling HT MSI Mapping
[    1.137559] pci 0000:00:06.0: Enabling HT MSI Mapping
[    1.137626] pci 0000:00:06.1: Enabling HT MSI Mapping
[    1.137695] pci 0000:00:08.0: Enabling HT MSI Mapping
[    1.137763] pci 0000:00:09.0: Enabling HT MSI Mapping
[    1.137829] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    1.137896] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    1.137963] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    1.138282] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    1.138282] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    1.138282] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    1.138282] pci 0000:07:00.0: Boot video device
[    1.138827] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.138844] assign_interrupt_mode Found MSI capability
[    1.138916] Allocate Port Service[]
[    1.139251] Allocate Port Service[]
[    1.139251] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    1.139251] assign_interrupt_mode Found MSI capability
[    1.139251] Allocate Port Service[]
[    1.139251] Allocate Port Service[]
[    1.139251] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    1.139251] assign_interrupt_mode Found MSI capability
[    1.139251] Allocate Port Service[]
[    1.139251] Allocate Port Service[]
[    1.139251] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    1.139251] assign_interrupt_mode Found MSI capability
[    1.139251] Allocate Port Service[]
[    1.139251] Allocate Port Service[]
[    1.139256] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    1.139256] assign_interrupt_mode Found MSI capability
[    1.139256] Allocate Port Service[]
[    1.139256] Allocate Port Service[]
[    1.139256] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    1.139256] assign_interrupt_mode Found MSI capability
[    1.139307] Allocate Port Service[]
[    1.139342] Allocate Port Service[]
[    1.139450] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.139818] processor ACPI0007:00: registered as cooling_device0
[    1.139922] processor ACPI0007:01: registered as cooling_device1
[    1.143985] isapnp: Scanning for PnP cards...
[    1.498637] isapnp: No Plug & Play device found
[    1.501787] Real Time Clock Driver v1.12ac
[    1.502249] hpet_resources: 0xfed00000 is busy
[    1.502249] Non-volatile memory driver v1.2
[    1.502249] Linux agpgart interface v0.103
[    1.502262] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.746115] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.747248] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.748250] brd: module loaded
[    1.748878] input: Macintosh mouse button emulation as /class/input/input0
[    1.749250] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.751813] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.751874] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.753250] mice: PS/2 mouse device common for all mice
[    1.795817] cpuidle: using governor ladder
[    1.795817] cpuidle: using governor menu
[    1.795817] usbcore: registered new interface driver hiddev
[    1.795817] usbcore: registered new interface driver usbhid
[    1.795817] usbhid: v2.6:USB HID core driver
[    1.797295] TCP cubic registered
[    1.797295] Initializing XFRM netlink socket
[    1.797295] NET: Registered protocol family 17
[    1.797295] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[    1.798318] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.798318] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.798318] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.798318] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.798318] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.798318] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.798318] Using IPI No-Shortcut mode
[    1.798318] registered taskstats version 1
[    1.798383] Freeing unused kernel memory: 272k freed
[    1.798464] Write protecting the kernel text: 2204k
[    1.798560] Write protecting the kernel read-only data: 948k
[    2.067250] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    2.067250] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 23 (level, low) -> IRQ 23
[    2.067400] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    2.067403] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    2.067529] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    2.067640] ehci_hcd 0000:00:02.1: debug port 1
[    2.067698] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    2.067708] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfbffac00
[    2.073333] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.073511] usb usb1: configuration #1 chosen from 1 choice
[    2.073588] hub 1-0:1.0: USB hub found
[    2.073648] hub 1-0:1.0: 10 ports detected
[    2.277254] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.277254] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    2.277254] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level, low) -> IRQ 22
[    2.277403] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    2.277406] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.277519] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    2.277625] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfbffb000
[    2.330334] usb usb2: configuration #1 chosen from 1 choice
[    2.330412] hub 2-0:1.0: USB hub found
[    2.330474] hub 2-0:1.0: 10 ports detected
[    2.379323] usb : new high speed USB device using ehci_hcd and address 2
[    2.443250] USB Universal Host Controller Interface driver v3.0
[    2.493711] usb 1-3: configuration #1 chosen from 1 choice
[    2.523250] SCSI subsystem initialized
[    2.543250] Driver 'sd' needs updating - please use bus_type methods
[    2.581298] libata version 3.00 loaded.
[    2.600730] usb : new high speed USB device using ehci_hcd and address 3
[    2.605313] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    2.605313] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[    2.605313] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
[    2.605313] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    2.605313] ACPI: PCI interrupt for device 0000:00:05.0 disabled
[    2.606361] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    2.606361] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23 (level, low) -> IRQ 23
[    2.606361] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    2.606361] ACPI: PCI interrupt for device 0000:00:05.1 disabled
[    2.606361] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 22
[    2.606361] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22 (level, low) -> IRQ 22
[    2.606361] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    2.606361] ACPI: PCI interrupt for device 0000:00:05.2 disabled
[    2.715250] usb 1-4: configuration #1 chosen from 1 choice
[    2.715378] hub 1-4:1.0: USB hub found
[    2.715482] hub 1-4:1.0: 4 ports detected
[    2.981325] usb : new low speed USB device using ehci_hcd and address 4
[    3.075492] usb 1-4.1: configuration #1 chosen from 1 choice
[    3.083188] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input1
[    3.087307] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-4.1
[    3.149325] usb : new low speed USB device using ehci_hcd and address 5
[    3.235370] usb 1-4.2: configuration #1 chosen from 1 choice
[    3.239412] input: DELL DELL USB Keyboard as /class/input/input2
[    3.243283] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[    3.252110] input: DELL DELL USB Keyboard as /class/input/input3
[    3.256279] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[    5.108253] pata_amd 0000:00:04.0: version 0.3.10
[    5.108253] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    5.108253] scsi0 : pata_amd
[    5.118250] scsi1 : pata_amd
[    5.119250] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    5.119250] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    5.279664] ata1.00: ATA-6: IC35L090AVV207-0, V23OA63A, max UDMA/100
[    5.279723] ata1.00: 160836480 sectors, multi 16: LBA48 
[    5.280011] ata1.01: ATA-6: Maxtor 32049H2, YAH814Y0, max UDMA/100
[    5.280069] ata1.01: 39062500 sectors, multi 16: LBA 
[    5.280133] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c60000) ACPI=0x3f01f (20:20:0x15)
[    5.280137] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c60000) ACPI=0x3f01f (20:20:0x15)
[    5.289594] ata1.00: configured for UDMA/100
[    5.295621] ata1.01: configured for UDMA/100
[    5.296313] ata2: port disabled. ignoring.
[    5.296313] scsi : Direct-Access     ATA      IC35L090AVV207-0 V23O PQ: 0 ANSI: 5
[    5.296313] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
[    5.296313] sd 0:0:0:0: [sda] Write Protect is off
[    5.296313] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.296313] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.296313] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
[    5.296389] sd 0:0:0:0: [sda] Write Protect is off
[    5.296446] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.296465] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.296558]  sda: sda1
[    5.305384] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.305522] scsi : Direct-Access     ATA      Maxtor 32049H2   YAH8 PQ: 0 ANSI: 5
[    5.305666] sd 0:0:1:0: [sdb] 39062500 512-byte hardware sectors (20000 MB)
[    5.305734] sd 0:0:1:0: [sdb] Write Protect is off
[    5.305792] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.305810] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.305937] sd 0:0:1:0: [sdb] 39062500 512-byte hardware sectors (20000 MB)
[    5.306005] sd 0:0:1:0: [sdb] Write Protect is off
[    5.306062] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.306081] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.306177]  sdb: sdb1 sdb2 sdb3
[    5.354189] sd 0:0:1:0: [sdb] Attached SCSI disk
[    7.857314] sata_nv 0000:00:05.0: version 3.5
[    7.857314] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
[    7.857314] sata_nv 0000:00:05.0: Using SWNCQ mode
[    7.857314] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    7.867313] scsi2 : sata_nv
[    7.867420] scsi3 : sata_nv
[    7.867591] ata3: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 21
[    7.867651] ata4: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 21
[    8.345326] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.355489] ata3.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    8.376318] ata3.00: configured for UDMA/66
[    8.680320] ata4: SATA link down (SStatus 0 SControl 300)
[    8.697127] scsi : CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 5
[    8.697303] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23 (level, low) -> IRQ 23
[    8.697313] sata_nv 0000:00:05.1: Using SWNCQ mode
[    8.697579] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    8.708057] scsi4 : sata_nv
[    8.708154] scsi5 : sata_nv
[    8.708310] ata5: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 irq 23
[    8.708313] ata6: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 irq 23
[    9.038313] ata5: SATA link down (SStatus 0 SControl 300)
[    9.352320] ata6: SATA link down (SStatus 0 SControl 300)
[    9.362647] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22 (level, low) -> IRQ 22
[    9.362780] sata_nv 0000:00:05.2: Using SWNCQ mode
[    9.363035] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    9.383313] scsi6 : sata_nv
[    9.383313] scsi7 : sata_nv
[    9.383313] ata7: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb480 irq 22
[    9.383313] ata8: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb488 irq 22
[    9.714313] ata7: SATA link down (SStatus 0 SControl 300)
[   10.028320] ata8: SATA link down (SStatus 0 SControl 300)
[   12.735689] kjournald starting.  Commit interval 5 seconds
[   12.735758] EXT3-fs: mounted filesystem with ordered data mode.
[   13.373298] type=1404 audit(1210363096.680:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   13.794252] SELinux: 8192 avtab hash slots, 222567 rules.
[   13.823798] SELinux: 8192 avtab hash slots, 222567 rules.
[   13.846939] SELinux:  6 users, 12 roles, 2420 types, 115 bools, 1 sens, 1024 cats
[   13.846942] SELinux:  67 classes, 222567 rules
[   13.848406] SELinux:  class peer not defined in policy
[   13.848466] SELinux:  class capability2 not defined in policy
[   13.848531] SELinux:  permission open in class dir not defined in policy
[   13.848591] SELinux:  permission open in class file not defined in policy
[   13.848651] SELinux:  permission open in class chr_file not defined in policy
[   13.848710] SELinux:  permission open in class blk_file not defined in policy
[   13.848769] SELinux:  permission open in class fifo_file not defined in policy
[   13.848866] SELinux:  permission recvfrom in class node not defined in policy
[   13.848925] SELinux:  permission sendto in class node not defined in policy
[   13.848986] SELinux:  permission ingress in class netif not defined in policy
[   13.849045] SELinux:  permission egress in class netif not defined in policy
[   13.849136] SELinux:  permission setfcap in class capability not defined in policy
[   13.849237] SELinux:  permission forward_in in class packet not defined in policy
[   13.849335] SELinux:  permission forward_out in class packet not defined in policy
[   13.849518] SELinux:  Completing initialization.
[   13.849519] SELinux:  Setting up existing superblocks.
[   13.867753] SELinux: initialized (dev sdb1, type ext3), uses xattr
[   14.109679] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   14.109687] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   14.109755] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   14.109779] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   14.109785] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   14.109790] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   14.109797] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   14.109800] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   14.109806] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   14.109809] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   14.109815] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   14.109843] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   14.109850] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   14.109859] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   14.109862] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   14.109879] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   14.116546] SELinux: policy loaded with handle_unknown=allow
[   14.116612] type=1403 audit(1210363097.424:3): policy loaded auid=4294967295 ses=4294967295
[   19.634483] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.634507] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   19.634530] scsi 2:0:0:0: Attached scsi generic sg2 type 5
[   19.806411] input: Power Button (FF) as /class/input/input4
[   19.816378] ACPI: Power Button (FF) [PWRF]
[   19.816460] input: Power Button (CM) as /class/input/input5
[   19.828364] ACPI: Power Button (CM) [PWRB]
[   19.868316] input: PC Speaker as /class/input/input6
[   19.894412] Driver 'sr' needs updating - please use bus_type methods
[   19.930178] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[   19.930178] Uniform CD-ROM driver Revision: 3.20
[   19.930178] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   19.997315] ck804xrom ck804xrom_init_one(): Unable to register resource 0x0000000000000000-0x00000000ffffffff - kernel bug?
[   19.997315] ck804xrom: ioremap(00000000, 00000000) failed
[   20.125312] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   20.125312] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   20.289314] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   20.289616] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   20.289616] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 20 (level, low) -> IRQ 20
[   20.289616] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   20.804617] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 00:16:17:45:c9:df
[   20.804621] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   20.804928] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   20.804931] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 20 (level, low) -> IRQ 20
[   20.804936] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   21.318622] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 00:16:17:45:c9:de
[   21.318625] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   21.320759] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   21.320763] ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [LAZA] -> GSI 21 (level, low) -> IRQ 21
[   21.320787] PCI: Setting latency timer of device 0000:00:06.1 to 64
[   23.571366] SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
[   24.763367] NET: Registered protocol family 10
[   24.763776] lo: Disabled Privacy Extensions
[   25.438492] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   25.438501] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   30.841686] device-mapper: uevent: version 1.0.3
[   30.851317] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   31.312315] device-mapper: multipath: version 1.0.5 loaded
[   32.962925] EXT3 FS on sdb1, internal journal
[   33.442312] SELinux: initialized (dev sdb3, type ext2), uses xattr
[   33.442600] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   35.551106] Adding 1004052k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1004052k
[   35.554317] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   36.541879] warning: process `kudzu' used the deprecated sysctl system call with 1.23.
[   37.054313] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   37.316315] ip_tables: (C) 2000-2006 Netfilter Core Team
[   37.495371] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   37.692322] Clocksource tsc unstable (delta = -153170760 ns)
[   39.877681] eth1: no link during initialization.
[   39.878653] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   46.696315] warning: `mcstransd' uses 32-bit capabilities (legacy support in use)
[   47.516724] RPC: Registered udp transport module.
[   47.516727] RPC: Registered tcp transport module.
[   47.523319] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   48.539935] fuse init (API version 7.9)
[   48.551522] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   48.689317] eth0: no IPv6 routers present
[   57.291404] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   57.973066] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   57.984313] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   58.526942] Bluetooth: Core ver 2.11
[   58.531321] NET: Registered protocol family 31
[   58.531321] Bluetooth: HCI device and connection manager initialized
[   58.531321] Bluetooth: HCI socket layer initialized
[   58.817315] Bluetooth: L2CAP ver 2.9
[   58.817315] Bluetooth: L2CAP socket layer initialized
[   58.847315] Bluetooth: RFCOMM socket layer initialized
[   58.847315] Bluetooth: RFCOMM TTY layer initialized
[   58.847315] Bluetooth: RFCOMM ver 1.8
[  152.948369] usb 1-4.2: USB disconnect, address 5
[  153.522399] usb : new low speed USB device using ehci_hcd and address 6
[  153.604130] usb 1-4.2: configuration #1 chosen from 1 choice
[  153.615434] input: DELL DELL USB Keyboard as /class/input/input7
[  153.630650] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[  153.647835] input: DELL DELL USB Keyboard as /class/input/input8
[  153.667533] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[10104.578316] pktcdvd: writer pktcdvd0 mapped to sr0
[10104.578752] sysfs: duplicate filename '252:0' can not be created
[10104.578760] ------------[ cut here ]------------
[10104.578761] WARNING: at fs/sysfs/dir.c:425 sysfs_add_one+0x31/0x7a()
[10104.579325] Modules linked in: pktcdvd rfcomm l2cap bluetooth autofs4 fuse sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_crypt ext2 dm_mirror dm_log dm_multipath scsi_dh dm_mod ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep forcedeth snd soundcore serio_raw i2c_nforce2 i2c_core k8temp hwmon mtd chipreg map_funcs sr_mod pcspkr button cdrom sg sata_nv pata_amd pata_acpi ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[10104.580322] Pid: 4127, comm: pktsetup Not tainted 2.6.26-rc1-next-20080509 #26
[10104.580322]  [<c0427bed>] warn_on_slowpath+0x40/0x64
[10104.580322]  [<c041ccee>] __wake_up_common+0x2e/0x58
[10104.580322]  [<c041e909>] __wake_up+0x29/0x39
[10104.580322]  [<c0427f1f>] wake_up_klogd+0x2b/0x2d
[10104.580322]  [<c04bb05b>] sysfs_ilookup_test+0x0/0xd
[10104.580322]  [<c0492465>] ifind+0x22/0x80
[10104.580322]  [<c0428524>] printk+0x14/0x18
[10104.580322]  [<c04bb2ad>] sysfs_add_one+0x31/0x7a
[10104.580322]  [<c04bbe14>] sysfs_create_link+0x8f/0xdb
[10104.580322]  [<c0563e81>] device_add+0x162/0x515
[10104.580322]  [<c04f427b>] kobject_init_internal+0xf/0x26
[10104.580322]  [<c05642b4>] device_create+0x70/0x9a
[10104.580322]  [<f8bb782c>] pkt_setup_dev+0x30e/0x474 [pktcdvd]
[10104.580322]  [<f8bb91cf>] pkt_ctl_ioctl+0x81/0x1aa [pktcdvd]
[10104.580322]  [<c048c823>] vfs_ioctl+0x47/0x5d
[10104.580322]  [<c048ca81>] do_vfs_ioctl+0x248/0x25f
[10104.580322]  [<c048cad9>] sys_ioctl+0x41/0x58
[10104.580322]  [<c04039da>] syscall_call+0x7/0xb
[10104.580322]  =======================
[10104.580322] ---[ end trace cfc75e2e04550ee9 ]---

