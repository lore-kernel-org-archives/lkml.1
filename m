Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYJHWSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYJHWSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYJHWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:18:42 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:44794 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYJHWSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:18:38 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt handlers
Date: Thu, 9 Oct 2008 00:18:33 +0200
User-Agent: KMail/1.9.10
References: <20081001223213.078984344@linutronix.de> <1222908014.31183.67.camel@perihelion.int.jonmasters.org> <20081002220742.GC9201@kroah.com>
In-Reply-To: <20081002220742.GC9201@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810090018.35460.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

[CC'ed some distribution specific experts]

On Friday 03 October 2008, you wrote:
> On Wed, Oct 01, 2008 at 08:40:14PM -0400, Jon Masters wrote:
> > On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:
> > 
> > > I hope to have a real converted driver (aside of the dummy module used
> > > for testing) ready real soon - as far as bugs/regressions stay out of
> > > my way for a while. :)
> > 
> > Sven and I started poking at the various USB host drivers on the flight
> > back from Plumbers. I'll see if I can convert over a few here on the
> > systems that I have and send over some patches.
> 
> There's only 3, how hard could it be?  :)

Heh! That feature is the only thing, that keeps my crappy combination
of hardware and Ubuntu Hardy together :-)

With the non-RT Ubuntu kernel flavors, it just hangs in that situation. 
It looks like this at the moment with a Ubuntu RT-Kernel, in case someone 
likes to debug that:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.24-21-rt (buildd@palmer) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP PREEMPT RT Mon Aug 25 19:24:40 UTC 2008 (Ubuntu 2.6.24-4.6-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfff0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000cfff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff3000 - 00000000d0000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e8000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Warning only 4GB will be used.
[    0.000000] Use a HIGHMEM64G enabled kernel.
[    0.000000] 3200MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f4b40
[    0.000000] Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1048576
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4040 pages, LIFO batch:0
[    0.000000]   Normal zone: 3080 pages used for memmap
[    0.000000]   Normal zone: 222200 pages, LIFO batch:31
[    0.000000]   HighMem zone: 11200 pages used for memmap
[    0.000000]   HighMem zone: 808000 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP signature @ 0xC00F6490 checksum 0
[    0.000000] ACPI: RSDP 000F6490, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFFF3000, 0030 (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: FACP CFFF3040, 0074 (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: DSDT CFFF30C0, 4B34 (r1 GBT    NVDAACPI     1000 MSFT  100000C)
[    0.000000] ACPI: FACS CFFF0000, 0040
[    0.000000] ACPI: MCFG CFFF7C80, 003C (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: APIC CFFF7C00, 007C (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 2
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:0ec00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1034240
[    0.000000] Kernel command line: root=/dev/mapper/Ubuntu-root ro noapic quiet splash
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2211.442 MHz processor.
[   18.517765] spurious 8259A interrupt: IRQ7.
[   18.519999] Console: colour VGA+ 80x25
[   18.520001] console [tty0] enabled
[   18.520235] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   18.520537] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   18.688113] Memory: 3335620k/4194304k available (2225k kernel code, 71024k reserved, 1059k data, 368k init, 2490304k highmem)
[   18.688120] virtual kernel memory layout:
[   18.688121]     fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
[   18.688122]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   18.688123]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   18.688124]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   18.688125]       .init : 0xc043b000 - 0xc0497000   ( 368 kB)
[   18.688126]       .data : 0xc032c6d0 - 0xc0435324   (1059 kB)
[   18.688127]       .text : 0xc0100000 - 0xc032c6d0   (2225 kB)
[   18.688130] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   18.748223] Calibrating delay using timer specific routine.. 4424.69 BogoMIPS (lpj=2212348)
[   18.748260] Security Framework initialized
[   18.748264] SELinux:  Disabled at boot.
[   18.748270] AppArmor: AppArmor initialized
[   18.748273] Failure registering capabilities with primary security module.
[   18.748287] Mount-cache hash table entries: 512
[   18.748396] Initializing cgroup subsys ns
[   18.748399] Initializing cgroup subsys cpuacct
[   18.748408] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f 00000000
[   18.748416] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   18.748418] CPU: L2 Cache: 512K (64 bytes/line)
[   18.748420] CPU 0(2) -> Core 0
[   18.748422] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00020410 00002001 00000000 0000001f 00000000
[   18.748431] Compat vDSO mapped to ffffe000.
[   18.748439] Checking 'hlt' instruction... OK.
[   18.752453] SMP alternatives: switching to UP code
[   18.753321] Early unpacking initramfs... done
[   19.066316] ACPI: Core revision 20070126
[   19.066372] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   19.068299] ACPI: setting ELCR to 0200 (from 8ca0)
[   19.069950] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 02
[   19.069966] SMP alternatives: switching to SMP code
[   19.070290] Booting processor 1/1 eip 3000
[   19.080875] Initializing CPU#1
[   19.141627] Calibrating delay using timer specific routine.. 4422.03 BogoMIPS (lpj=2211015)
[   19.141633] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f 00000000
[   19.141639] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   19.141641] CPU: L2 Cache: 512K (64 bytes/line)
[   19.141642] CPU 1(2) -> Core 1
[   19.141644] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00020410 00002001 00000000 0000001f 00000000
[   19.141254] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 02
[   19.141268] Total of 2 processors activated (8846.72 BogoMIPS).
[   19.243554] Brought up 2 CPUs
[   19.243573] CPU0 attaching sched-domain:
[   19.243576]  domain 0: span 03
[   19.243578]   groups: 01 02
[   19.243581] CPU1 attaching sched-domain:
[   19.243583]  domain 0: span 03
[   19.243585]   groups: 02 01
[   19.243785] net_namespace: 76 bytes
[   19.243790] Booting paravirtualized kernel on bare hardware
[   19.244211] Time:  5:45:17  Date: 10/08/08
[   19.244244] NET: Registered protocol family 16
[   19.244421] EISA bus registered
[   19.244425] ACPI: bus type pci registered
[   19.248898] PCI: PCI BIOS revision 3.00 entry at 0xfb2a0, last bus=3
[   19.248900] PCI: Using configuration type 1
[   19.248903] Setting up standard PCI resources
[   19.251879] ACPI: EC: Look up EC in DSDT
[   19.258260] ACPI: Interpreter enabled
[   19.258265] ACPI: (supports S0 S1 S4 S5)
[   19.258279] ACPI: Using PIC for interrupt routing
[   19.265816] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.266397] PCI: Transparent bridge - 0000:00:06.0
[   19.266644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   19.266953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   19.314347] ACPI: PCI Interrupt Link [LNK1] (IRQs *5 7 9 10 11 14 15)
[   19.314491] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.314634] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.314778] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 *15)
[   19.314919] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.315068] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.315216] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
[   19.315361] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.315506] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.315653] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 *7 9 10 11 14 15)
[   19.315799] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 *7 9 10 11 14 15)
[   19.315944] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[   19.316096] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.316243] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 *15)
[   19.316389] ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
[   19.316535] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   19.316681] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[   19.316827] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 14 *15)
[   19.316973] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 *10 11 14 15)
[   19.317161] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   19.317331] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[   19.317501] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[   19.317669] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   19.317837] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[   19.318005] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[   19.318183] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[   19.318355] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[   19.318526] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[   19.318698] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[   19.318869] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[   19.319041] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
[   19.319220] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[   19.319392] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[   19.319564] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[   19.319739] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[   19.319911] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[   19.320089] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[   19.320263] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0, disabled.
[   19.320395] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.320422] pnp: PnP ACPI init
[   19.320429] ACPI: bus type pnp registered
[   19.323619] pnp: PnP ACPI: found 10 devices
[   19.323621] ACPI: ACPI bus type pnp unregistered
[   19.323624] PnPBIOS: Disabled by ACPI PNP
[   19.323826] PCI: Using ACPI for IRQ routing
[   19.323830] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   19.377034] NET: Registered protocol family 8
[   19.377036] NET: Registered protocol family 20
[   19.377111] AppArmor: AppArmor Filesystem Enabled
[   19.389057] system 00:01: ioport range 0x1000-0x107f has been reserved
[   19.389060] system 00:01: ioport range 0x1080-0x10ff has been reserved
[   19.389063] system 00:01: ioport range 0x1400-0x147f has been reserved
[   19.389065] system 00:01: ioport range 0x1480-0x14ff has been reserved
[   19.389067] system 00:01: ioport range 0x1800-0x187f has been reserved
[   19.389070] system 00:01: ioport range 0x1880-0x18ff has been reserved
[   19.389073] system 00:01: iomem range 0xd0000000-0xdfffffff could not be reserved
[   19.389079] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   19.389081] system 00:02: ioport range 0x800-0x87f has been reserved
[   19.389084] system 00:02: ioport range 0x295-0x314 has been reserved
[   19.389086] system 00:02: ioport range 0x290-0x294 has been reserved
[   19.389094] system 00:08: iomem range 0xe8000000-0xefffffff could not be reserved
[   19.389100] system 00:09: iomem range 0xcc000-0xcffff has been reserved
[   19.389102] system 00:09: iomem range 0xf0000-0xf7fff could not be reserved
[   19.389105] system 00:09: iomem range 0xf8000-0xfbfff could not be reserved
[   19.389107] system 00:09: iomem range 0xfc000-0xfffff could not be reserved
[   19.389110] system 00:09: iomem range 0xcfff0000-0xcfffffff could not be reserved
[   19.389113] system 00:09: iomem range 0xffff0000-0xffffffff could not be reserved
[   19.389116] system 00:09: iomem range 0x0-0x9ffff could not be reserved
[   19.389118] system 00:09: iomem range 0x100000-0xcffeffff could not be reserved
[   19.389121] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[   19.389124] system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
[   19.419494] PCI: Bridge: 0000:00:06.0
[   19.419496]   IO window: 9000-9fff
[   19.419499]   MEM window: f5000000-f6ffffff
[   19.419501]   PREFETCH window: disabled.
[   19.419504] PCI: Bridge: 0000:02:00.0
[   19.419505]   IO window: disabled.
[   19.419510]   MEM window: f2000000-f4ffffff
[   19.419513]   PREFETCH window: f0000000-f1ffffff
[   19.419518] PCI: Bridge: 0000:00:0e.0
[   19.419519]   IO window: disabled.
[   19.419521]   MEM window: f2000000-f4ffffff
[   19.419523]   PREFETCH window: f0000000-f1ffffff
[   19.419531] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   19.419539] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   19.419551] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   19.419577] NET: Registered protocol family 2
[   19.454990] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   19.455239] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   19.455855] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[   19.456869] TCP: Hash tables configured (established 131072 bind 65536)
[   19.456874] TCP reno registered
[   19.468060] checking if image is initramfs... it is
[   20.080746] Freeing initrd memory: 8382k freed
[   20.081459] audit: initializing netlink socket (disabled)
[   20.081471] audit(1223444718.291:1): initialized
[   20.081613] krcupreemptd setsched 0
[   20.081614]   prio = 98
[   20.081671] highmem bounce pool size: 64 pages
[   20.081742] VFS: Disk quotas dquot_6.5.1
[   20.081763] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   20.081837] io scheduler noop registered
[   20.081838] io scheduler anticipatory registered
[   20.081840] io scheduler deadline registered
[   20.081849] io scheduler cfq registered (default)
[   20.106797] pci 0000:00:05.0: Enabling HT MSI Mapping
[   20.106811] pci 0000:00:05.1: Enabling HT MSI Mapping
[   20.106824] pci 0000:00:05.2: Enabling HT MSI Mapping
[   20.106836] pci 0000:00:06.0: Enabling HT MSI Mapping
[   20.106851] pci 0000:00:06.1: Enabling HT MSI Mapping
[   20.106866] pci 0000:00:08.0: Enabling HT MSI Mapping
[   20.106879] pci 0000:00:0e.0: Enabling HT MSI Mapping
[   20.106890] Boot video device is 0000:03:00.0
[   20.106992] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   20.107027] assign_interrupt_mode Found MSI capability
[   20.107044] Allocate Port Service[0000:00:0e.0:pcie00]
[   20.107265] isapnp: Scanning for PnP cards...
[   20.463165] isapnp: No Plug & Play device found
[   20.490553] Real Time Clock Driver v1.12ac
[   20.490664] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   20.491845] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   20.491906] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[   20.491985] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   20.491988] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   20.492106] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.503193] mice: PS/2 mouse device common for all mice
[   20.503308] EISA: Probing bus 0 at eisa.0
[   20.503314] Cannot allocate resource for EISA slot 1
[   20.503330] EISA: Detected 0 cards.
[   20.503332] cpuidle: using governor ladder
[   20.503404] NET: Registered protocol family 1
[   20.503427] Using IPI No-Shortcut mode
[   20.503456] registered taskstats version 1
[   20.503560]   Magic number: 12:388:769
[   20.503646]   hash matches device ptyp5
[   20.503660]   hash matches device kmsg
[   20.503666]   hash matches device 0000:00:05.0
[   20.503684] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   20.503686] EDD information not available.
[   20.503872] Freeing unused kernel memory: 368k freed
[   20.525317] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   21.742212] fuse init (API version 7.9)
[   21.768889] device-mapper: uevent: version 1.0.3
[   21.768936] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   21.783453] md: linear personality registered for level -1
[   21.787115] md: multipath personality registered for level -4
[   21.790905] md: raid0 personality registered for level 0
[   21.795291] md: raid1 personality registered for level 1
[   21.799015] xor: measuring software checksum speed
[   21.803477]    8regs     :  2896.000 MB/sec
[   21.808477]    8regs_prefetch:  2804.000 MB/sec
[   21.813478]    32regs    :  2192.000 MB/sec
[   21.818479]    32regs_prefetch:  1796.000 MB/sec
[   21.818481] xor: using function: 8regs (2896.000 MB/sec)
[   21.819566] async_tx: api initialized (async)
[   21.839519] raid6: int32x1    824 MB/s
[   21.856529] raid6: int32x2    871 MB/s
[   21.873550] raid6: int32x4    835 MB/s
[   21.890545] raid6: int32x8    609 MB/s
[   21.907509] raid6: mmxx1     1753 MB/s
[   21.924501] raid6: mmxx2     3230 MB/s
[   21.941508] raid6: sse1x1    1757 MB/s
[   21.958508] raid6: sse1x2    3011 MB/s
[   21.975510] raid6: sse2x1    2968 MB/s
[   21.992511] raid6: sse2x2    4074 MB/s
[   21.992512] raid6: using algorithm sse2x2 (4074 MB/s)
[   21.992515] md: raid6 personality registered for level 6
[   21.992517] md: raid5 personality registered for level 5
[   21.992518] md: raid4 personality registered for level 4
[   22.018354] md: raid10 personality registered for level 10
[   22.236163] usbcore: registered new interface driver usbfs
[   22.236183] usbcore: registered new interface driver hub
[   22.236259] usbcore: registered new device driver usb
[   22.247614] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   22.247891] ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 7
[   22.247894] PCI: setting IRQ 7 as level-triggered
[   22.247898] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 7 (level, low) -> IRQ 7
[   22.247907] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   22.247910] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   22.248138] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   22.248186] ohci_hcd 0000:00:02.0: irq 7, io mem 0xf7005000
[   22.301202] usb usb1: configuration #1 chosen from 1 choice
[   22.301223] hub 1-0:1.0: USB hub found
[   22.301233] hub 1-0:1.0: 10 ports detected
[   22.662617] usb 1-9: new low speed USB device using ohci_hcd and address 2
[   22.853579] usb 1-9: configuration #1 chosen from 1 choice
[   22.922573] SCSI subsystem initialized
[   22.980791] libata version 3.00 loaded.
[   22.983376] pata_amd 0000:00:04.0: version 0.3.10
[   22.983423] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   22.983502] scsi0 : pata_amd
[   22.983546] scsi1 : pata_amd
[   22.984057] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   22.984060] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   23.288979] ata1.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB02, max UDMA/33
[   23.445904] ata1.00: configured for UDMA/33
[   23.445937] ata2: port disabled. ignoring.
[   23.446803] scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB02 PQ: 0 ANSI: 5
[   23.740145] ACPI: PCI Interrupt Link [LSID] enabled at IRQ 11
[   23.740150] PCI: setting IRQ 11 as level-triggered
[   23.740153] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSID] -> GSI 11 (level, low) -> IRQ 11
[   23.740187] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   23.740196] ACPI: PCI interrupt for device 0000:00:05.0 disabled
[   23.740397] ACPI: PCI Interrupt Link [LFID] enabled at IRQ 15
[   23.740399] PCI: setting IRQ 15 as level-triggered
[   23.740403] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LFID] -> GSI 15 (level, low) -> IRQ 15
[   23.740417] PCI: Setting latency timer of device 0000:00:05.1 to 64
[   23.740423] ACPI: PCI interrupt for device 0000:00:05.1 disabled
[   23.740621] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 10
[   23.740623] PCI: setting IRQ 10 as level-triggered
[   23.740626] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 10 (level, low) -> IRQ 10
[   23.740641] PCI: Setting latency timer of device 0000:00:05.2 to 64
[   23.740647] ACPI: PCI interrupt for device 0000:00:05.2 disabled
[   24.228852] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   24.229104] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 7
[   24.229107] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 7 (level, low) -> IRQ 7
[   24.229112] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   24.742086] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:16:e6:88:c7:bc
[   24.742091] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   24.741991] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 5
[   24.741996] PCI: setting IRQ 5 as level-triggered
[   24.742000] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 5 (level, low) -> IRQ 5
[   24.742010] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   24.742013] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   24.742044] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
[   24.742071] ehci_hcd 0000:00:02.1: debug port 1
[   24.742074] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   24.742487] ehci_hcd 0000:00:02.1: irq 5, io mem 0xf7006000
[   24.743042] usb 1-9: USB disconnect, address 2
[   24.747902] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   24.748097] usb usb2: configuration #1 chosen from 1 choice
[   24.748118] hub 2-0:1.0: USB hub found
[   24.748126] hub 2-0:1.0: 10 ports detected
[   24.849006] sata_nv 0000:00:05.0: version 3.5
[   24.849018] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSID] -> GSI 11 (level, low) -> IRQ 11
[   24.849056] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   24.849682] scsi2 : sata_nv
[   24.849783] scsi3 : sata_nv
[   24.849933] ata3: SATA max UDMA/133 cmd 0xa400 ctl 0xa800 bmdma 0xb400 irq 11
[   24.849936] ata4: SATA max UDMA/133 cmd 0xac00 ctl 0xb000 bmdma 0xb408 irq 11
[   25.181614] Driver 'sr' needs updating - please use bus_type methods
[   25.189497] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   25.189502] Uniform CD-ROM driver Revision: 3.20
[   25.189552] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   25.203748] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   25.264959] usb 1-9: new low speed USB device using ohci_hcd and address 3
[   25.332719] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   25.455207] usb 1-9: configuration #1 chosen from 1 choice
[   25.458200] usbcore: registered new interface driver hiddev
[   25.467322] input: Logitech Trackball as /devices/pci0000:00/0000:00:02.0/usb1/1-9/1-9:1.0/input/input2
[   25.478011] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:02.0-9
[   25.478026] usbcore: registered new interface driver usbhid
[   25.478029] /build/buildd/linux-2.6.24/debian/build/custom-source-rt/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   25.543836] ata3.00: HPA unlocked: 976771055 -> 976773168, native 976773168
[   25.543843] ata3.00: ATA-7: ST3500630NS, 3.AEG, max UDMA/133
[   25.543845] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   25.580880] ata3.00: configured for UDMA/133
[   25.883782] ata4: SATA link down (SStatus 0 SControl 300)
[   25.894907] scsi 2:0:0:0: Direct-Access     ATA      ST3500630NS      3.AE PQ: 0 ANSI: 5
[   25.894973] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[   25.894521] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LFID] -> GSI 15 (level, low) -> IRQ 15
[   25.894568] PCI: Setting latency timer of device 0000:00:05.1 to 64
[   25.894608] scsi4 : sata_nv
[   25.894662] scsi5 : sata_nv
[   25.894806] ata5: SATA max UDMA/133 cmd 0xb800 ctl 0xbc00 bmdma 0xc800 irq 15
[   25.894809] ata6: SATA max UDMA/133 cmd 0xc000 ctl 0xc400 bmdma 0xc808 irq 15
[   26.197073] ata5: SATA link down (SStatus 0 SControl 300)
[   26.510116] ata6: SATA link down (SStatus 0 SControl 300)
[   26.520469] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 10 (level, low) -> IRQ 10
[   26.520505] PCI: Setting latency timer of device 0000:00:05.2 to 64
[   26.520560] scsi6 : sata_nv
[   26.520794] scsi7 : sata_nv
[   26.520936] ata7: SATA max UDMA/133 cmd 0xcc00 ctl 0xd000 bmdma 0xdc00 irq 10
[   26.520939] ata8: SATA max UDMA/133 cmd 0xd400 ctl 0xd800 bmdma 0xdc08 irq 10
[   26.823157] ata7: SATA link down (SStatus 0 SControl 300)
[   27.136196] ata8: SATA link down (SStatus 0 SControl 300)
[   27.149496] ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 15
[   27.149500] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [LNK4] -> GSI 15 (level, low) -> IRQ 15
[   27.149507] 3c59x: Donald Becker and others.
[   27.149511] 0000:01:07.0: 3Com PCI 3c905B Cyclone 100baseTx at f8886000.
[   27.158757] Driver 'sd' needs updating - please use bus_type methods
[   27.158833] sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   27.158844] sd 2:0:0:0: [sda] Write Protect is off
[   27.158846] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.158861] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.158901] sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   27.158909] sd 2:0:0:0: [sda] Write Protect is off
[   27.158911] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   27.158925] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.158928]  sda:ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 5
[   27.172844] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNK1] -> GSI 5 (level, low) -> IRQ 5
[   27.172855] 0000:01:08.0: 3Com PCI 3c905B Cyclone 100baseTx at f89b6000.
[   27.177621]  sda1 sda2 < sda5 >
[   27.185442] sd 2:0:0:0: [sda] Attached SCSI disk
[   27.700325] EXT3-fs: mounted filesystem with ordered data mode.
[   27.700371] kjournald starting.  Commit interval 5 seconds
[   34.798310] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   34.909990] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   35.084447] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[   35.084466] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c80
[   36.006688] udev: renamed network interface eth0 to lan
[   37.913301] input: Power Button (FF) as /devices/virtual/input/input3
[   37.930424] ACPI: Power Button (FF) [PWRF]
[   37.930474] input: Power Button (CM) as /devices/virtual/input/input4
[   37.949445] ACPI: Power Button (CM) [PWRB]
[   38.426176] udev: renamed network interface eth2 to dmz
[   38.435089] udev: renamed network interface eth1 to wan
[   39.990176] lan: no link during initialization.
[   40.072308] dmz:  setting half-duplex.
[   40.861083] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 10
[   40.861087] ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [LAZA] -> GSI 10 (level, low) -> IRQ 10
[   40.861102] PCI: Setting latency timer of device 0000:00:06.1 to 64
[   41.313471] NET: Registered protocol family 10
[   41.313839] lo: Disabled Privacy Extensions
[   41.314395] ADDRCONF(NETDEV_UP): lan: link is not ready
[   41.314915] ADDRCONF(NETDEV_UP): dmz: link is not ready
[   41.504445] lp: driver loaded but no devices found
[   41.699128] ACPI: PCI Interrupt Link [LNK7] enabled at IRQ 11
[   41.699133] ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNK7] -> GSI 11 (level, low) -> IRQ 11
[   41.699138] matroxfb: Matrox G550 detected
[   41.700140] PInS memtype = 5
[   41.700355] matroxfb: MTRR's turned on
[   41.700375] matroxfb: 640x480x8bpp (virtual: 640x26214)
[   41.700377] matroxfb: framebuffer at 0xF0000000, mapped to 0xf8c00000, size 33554432
[   41.700433] fb0: MATROX frame buffer device
[   41.700434] fb0: initializing hardware
[   42.307283] EXT3 FS on dm-0, internal journal
[   43.208393] kjournald starting.  Commit interval 5 seconds
[   43.217060] EXT3 FS on sda1, internal journal
[   43.217067] EXT3-fs: mounted filesystem with ordered data mode.
[   43.286046] Adding 10108920k swap on /dev/mapper/Ubuntu-swap_1.  Priority:-1 extents:1 across:10108920k
[   43.491686] ip_tables: (C) 2000-2006 Netfilter Core Team
[   43.582127] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   43.643560] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   43.903238] wan:  setting half-duplex.
[   43.904752] ADDRCONF(NETDEV_UP): wan: link is not ready
[   44.138697] PPP generic driver version 2.4.2
[   44.164043] NET: Registered protocol family 17
[   44.889602] No dock devices found.
[   45.332851] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (2 cpu cores) (version 2.20.00)
[   45.332360] powernow-k8: MP systems not supported by PSB BIOS structure
[   45.333080] powernow-k8: MP systems not supported by PSB BIOS structure
[   48.448693] Linux agpgart interface v0.102
[   48.483364] [drm] Initialized drm 1.1.0 20060810
[   48.626623] [drm] Initialized mga 3.2.1 20051102 on minor 0
[   50.264062] ppdev: user-space parallel port driver
[   55.001104] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   55.001111] apm: disabled - APM is not SMP safe.
[   65.381474] Bluetooth: Core ver 2.11
[   65.381855] NET: Registered protocol family 31
[   65.381859] Bluetooth: HCI device and connection manager initialized
[   65.381863] Bluetooth: HCI socket layer initialized
[   65.411817] Bluetooth: L2CAP ver 2.9
[   65.411822] Bluetooth: L2CAP socket layer initialized
[   65.469713] Bluetooth: RFCOMM socket layer initialized
[   65.469726] Bluetooth: RFCOMM TTY layer initialized
[   65.469728] Bluetooth: RFCOMM ver 1.8
[  940.928916] irq 7: nobody cared (try booting with the "irqpoll" option)
[  940.928922] Pid: 1606, comm: IRQ-7 Not tainted 2.6.24-21-rt #1
[  940.928943]  [<c016b924>] __report_bad_irq+0x24/0x80
[  940.928956]  [<c016bbfb>] note_interrupt+0x27b/0x2a0
[  940.928959]  [<c016a8dc>] handle_IRQ_event+0x5c/0x100
[  940.928974]  [<c016af3c>] thread_simple_irq+0x6c/0x90
[  940.928983]  [<c016b869>] do_irqd+0x229/0x290
[  940.928998]  [<c016b640>] do_irqd+0x0/0x290
[  940.929002]  [<c0141ea2>] kthread+0x42/0x70
[  940.929005]  [<c0141e60>] kthread+0x0/0x70
[  940.929011]  [<c0105847>] kernel_thread_helper+0x7/0x10
[  940.929022]  =======================
[  940.929023] handlers:
[  940.929024] [<f891ac70>] (usb_hcd_irq+0x0/0x60 [usbcore])
[  940.929043] turning off IO-APIC fast mode.
[ 1007.970826] irq 7: nobody cared (try booting with the "irqpoll" option)
[ 1007.970832] Pid: 1606, comm: IRQ-7 Not tainted 2.6.24-21-rt #1
[ 1007.970852]  [<c016b924>] __report_bad_irq+0x24/0x80
[ 1007.970864]  [<c016bbfb>] note_interrupt+0x27b/0x2a0
[ 1007.970868]  [<c016a8dc>] handle_IRQ_event+0x5c/0x100
[ 1007.970883]  [<c016af3c>] thread_simple_irq+0x6c/0x90
[ 1007.970892]  [<c016b869>] do_irqd+0x229/0x290
[ 1007.970907]  [<c016b640>] do_irqd+0x0/0x290
[ 1007.970911]  [<c0141ea2>] kthread+0x42/0x70
[ 1007.970914]  [<c0141e60>] kthread+0x0/0x70
[ 1007.970920]  [<c0105847>] kernel_thread_helper+0x7/0x10
[ 1007.970931]  =======================
[ 1007.970932] handlers:
[ 1007.970933] [<f891ac70>] (usb_hcd_irq+0x0/0x60 [usbcore])
[ 5970.101996] irq 7: nobody cared (try booting with the "irqpoll" option)
[ 5970.102003] Pid: 1606, comm: IRQ-7 Not tainted 2.6.24-21-rt #1
[ 5970.102022]  [<c016b924>] __report_bad_irq+0x24/0x80
[ 5970.102034]  [<c016bbfb>] note_interrupt+0x27b/0x2a0
[ 5970.102038]  [<c016a8dc>] handle_IRQ_event+0x5c/0x100
[ 5970.102053]  [<c016af3c>] thread_simple_irq+0x6c/0x90
[ 5970.102063]  [<c016b869>] do_irqd+0x229/0x290
[ 5970.102078]  [<c016b640>] do_irqd+0x0/0x290
[ 5970.102082]  [<c0141ea2>] kthread+0x42/0x70
[ 5970.102085]  [<c0141e60>] kthread+0x0/0x70
[ 5970.102091]  [<c0105847>] kernel_thread_helper+0x7/0x10
[ 5970.102102]  =======================
[ 5970.102103] handlers:
[ 5970.102105] [<f891ac70>] (usb_hcd_irq+0x0/0x60 [usbcore])
[ 7633.252211] irq 7: nobody cared (try booting with the "irqpoll" option)
[ 7633.252218] Pid: 1606, comm: IRQ-7 Not tainted 2.6.24-21-rt #1
[ 7633.252237]  [<c016b924>] __report_bad_irq+0x24/0x80
[ 7633.252249]  [<c016bbfb>] note_interrupt+0x27b/0x2a0
[ 7633.252253]  [<c016a8dc>] handle_IRQ_event+0x5c/0x100
[ 7633.252268]  [<c016af3c>] thread_simple_irq+0x6c/0x90
[ 7633.252278]  [<c016b869>] do_irqd+0x229/0x290
[ 7633.252292]  [<c016b640>] do_irqd+0x0/0x290
[ 7633.252297]  [<c0141ea2>] kthread+0x42/0x70
[ 7633.252300]  [<c0141e60>] kthread+0x0/0x70
[ 7633.252306]  [<c0105847>] kernel_thread_helper+0x7/0x10
[ 7633.252317]  =======================
[ 7633.252318] handlers:
[ 7633.252319] [<f891ac70>] (usb_hcd_irq+0x0/0x60 [usbcore])
[56238.249373] wan:  setting full-duplex.
[56238.250332] ADDRCONF(NETDEV_CHANGE): wan: link becomes ready
[56249.237072] wan: no IPv6 routers present
[56352.342443] NET: Registered protocol family 24
[58562.155510] irq 7: nobody cared (try booting with the "irqpoll" option)
[58562.155516] Pid: 1606, comm: IRQ-7 Not tainted 2.6.24-21-rt #1
[58562.155537]  [<c016b924>] __report_bad_irq+0x24/0x80
[58562.155550]  [<c016bbfb>] note_interrupt+0x27b/0x2a0
[58562.155554]  [<c016a8dc>] handle_IRQ_event+0x5c/0x100
[58562.155569]  [<c016af3c>] thread_simple_irq+0x6c/0x90
[58562.155579]  [<c016b869>] do_irqd+0x229/0x290
[58562.155594]  [<c016b640>] do_irqd+0x0/0x290
[58562.155599]  [<c0141ea2>] kthread+0x42/0x70
[58562.155602]  [<c0141e60>] kthread+0x0/0x70
[58562.155608]  [<c0105847>] kernel_thread_helper+0x7/0x10
[58562.155620]  =======================
[58562.155622] handlers:
[58562.155623] [<f891ac70>] (usb_hcd_irq+0x0/0x60 [usbcore])


           CPU0       CPU1       
  0:        556          1    XT-PIC-XT        timer
  1:       5841        888    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  5:          1          1    XT-PIC-XT        ehci_hcd:usb2, dmz
  7:     160816    1687071    XT-PIC-XT        ohci_hcd:usb1
  8:          2          1    XT-PIC-XT        rtc
  9:          0          0    XT-PIC-XT        acpi
 10:     383980      11338    XT-PIC-XT        sata_nv, HDA Intel
 11:     669673      57055    XT-PIC-XT        sata_nv
 14:     584674      64101    XT-PIC-XT        libata
 15:      42236      15407    XT-PIC-XT        libata, sata_nv, wan
222:    5929886       3346   PCI-MSI-edge      lan
NMI:          0          0   Non-maskable interrupts
LOC:   59209279   59195939   Local timer interrupts
RES:    4365453    8967863   Rescheduling interrupts
CAL:      70549      64347   function call interrupts
TLB:      12860      12054   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:      14677
MIS:          0

00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
	Subsystem: Giga-byte Technology Unknown device 5001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] #00 [fee0]

00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
	Subsystem: Giga-byte Technology Unknown device 0c11
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
	Subsystem: Giga-byte Technology Unknown device 0c11
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 15
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c80 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
	Subsystem: Giga-byte Technology Unknown device 0c11
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Unknown device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at f7005000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Unknown device 5004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 5
	Region 0: Memory at f7006000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: Unknown device f458:5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Unknown device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at a400 [size=8]
	Region 1: I/O ports at a800 [size=4]
	Region 2: I/O ports at ac00 [size=8]
	Region 3: I/O ports at b000 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Region 5: Memory at f700a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Unknown device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 15
	Region 0: I/O ports at b800 [size=8]
	Region 1: I/O ports at bc00 [size=4]
	Region 2: I/O ports at c000 [size=8]
	Region 3: I/O ports at c400 [size=4]
	Region 4: I/O ports at c800 [size=16]
	Region 5: Memory at f700b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Unknown device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin C routed to IRQ 10
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at d000 [size=4]
	Region 2: I/O ports at d400 [size=8]
	Region 3: I/O ports at d800 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at f7004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: f5000000-f6ffffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [b8] Subsystem: Gammagraphx, Inc. Unknown device 0000
	Capabilities: [8c] HyperTransport: MSI Mapping

00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
	Subsystem: Giga-byte Technology Unknown device a002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
	Subsystem: Giga-byte Technology Unknown device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 222
	Region 0: Memory at f7007000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at e400 [size=8]
	Region 2: Memory at f7008000 (32-bit, non-prefetchable) [size=256]
	Region 3: Memory at f7009000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
		Vector table: BAR=2 offset=00000000
		PBA: BAR=3 offset=00000000
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+
		Address: 00000000fee0100c  Data: 4141
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping

00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f2000000-f4ffffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4139
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]

01:07.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
	Subsystem: 3Com Corporation 3C905B Fast Etherlink XL 10/100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at 9000 [size=128]
	Region 1: Memory at f6000000 (32-bit, non-prefetchable) [size=128]
	[virtual] Expansion ROM at f5000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:08.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
	Subsystem: 3Com Corporation 3C905B Fast Etherlink XL 10/100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at 9400 [size=128]
	Region 1: Memory at f6001000 (32-bit, non-prefetchable) [size=128]
	[virtual] Expansion ROM at f5020000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f2000000-f4ffffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Subsystem: Matrox Graphics, Inc. Unknown device 6666
	Capabilities: [90] Express PCI/PCI-X Bridge IRQ 0
		Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <4us, L1 <64us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
		Link: Latency L0s <512ns, L1 <16us
		Link: ASPM Disabled CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1

03:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G550 AGP (rev 01) (prog-if 00 [VGA controller])
	Subsystem: Matrox Graphics, Inc. Unknown device 22c0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at f2000000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at f3000000 (32-bit, non-prefetchable) [size=8M]
	[virtual] Expansion ROM at f2020000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [f0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=<none>
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x1



Bus 002 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.24-21-rt ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:02.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts            10
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00 0x00
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0100 power
   Port 8: 0000.0100 power
   Port 9: 0000.0100 power
   Port 10: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 003: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc404 TrackMan Wheel
  bcdDevice            2.20
  iManufacturer           1 Logitech
  iProduct                2 Trackball
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     103
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.24-21-rt ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:02.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts            10
  wHubCharacteristic 0x0002
    No power switching (usb 1.0)
    Ganged overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00 0x00
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0100 power
   Port 8: 0000.0100 power
   Port 9: 0000.0303 lowspeed power enable connect
   Port 10: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 2
cpu MHz		: 2211.442
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 4424.69
clflush size	: 64

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 2
cpu MHz		: 2211.442
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 4422.03
clflush size	: 64


Booting without "noapic" panics while booting. I wish I could debug that 
further and keep initrd stuff working at the same time...

Best Regards

Ingo Oeser
