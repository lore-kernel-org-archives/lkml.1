Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYGYI4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYGYI4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYGYI4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:56:39 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60028 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYGYI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:56:33 -0400
Date: Fri, 25 Jul 2008 10:52:10 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080725085206.GA6669@boogie.lpds.sztaki.hu>
References: <20080428092513.495378af.akpm@linux-foundation.org> <20080429175419.6c8a0ebf@strauss.suse.de> <20080430133824.GC18711@boogie.lpds.sztaki.hu> <20080430165131.7426d5d3@strauss.suse.de> <20080507114343.GB5583@boogie.lpds.sztaki.hu> <20080507144520.17e9902a@strauss.suse.de> <20080507134223.GB4278@boogie.lpds.sztaki.hu> <20080512142146.2a32793c@kopernikus.site> <20080513143917.GC17309@boogie.lpds.sztaki.hu> <20080615171140.GG22313@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080615171140.GG22313@boogie.lpds.sztaki.hu>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 07:11:41PM +0200, Gabor Gombas wrote:
> On Tue, May 13, 2008 at 04:39:29PM +0200, Gabor Gombas wrote:
> > On Mon, May 12, 2008 at 02:21:46PM +0200, Bernhard Walle wrote:
> > 
> > > Well, can you try if that really not happens without
> > > CONFIG_HPET_EMULATE_RTC? The question is if that 64 interrupts per second really
> > > cause a machine hang ...
> > 
> > I'll try when I have a little time...
> 
> Ok, it took much more time than I'd have liked, but now I'm having:
> 
> $ uname -a
> Linux boogie 2.6.25 #3 SMP Thu Jun 12 13:32:35 CEST 2008 x86_64 GNU/Linux
> $ grep EMULATE_RTC /boot/config-2.6.25
> # CONFIG_HPET_EMULATE_RTC is not set
> $ uptime
>  19:07:17 up 3 days,  4:07, 12 users,  load average: 0.14, 0.31, 0.20
> 
> So I'd say it works.

FYI, the bug is still present in 2.6.26. I also got the same hang on a
Dell PowerEdge 850 using a Debian-provided kernel (based on 2.6.25.6);
that is the 3rd distinct HW configuration that hangs.

Gabor

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26 (gombasg@boogie) (gcc version 4.3.1 (Debian 4.3.1-7) ) #16 SMP Thu Jul 24 14:30:09 CEST 2008
[    0.000000] Command line: BOOT_IMAGE=l2626 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf2ac000 (usable)
[    0.000000]  BIOS-e820: 00000000cf2ac000 - 00000000cf2ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf2ef000 - 00000000cf3c7000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf3c7000 - 00000000cf3d7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf3d7000 - 00000000cf453000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf453000 - 00000000cf459000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf459000 - 00000000cf45a000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf45a000 - 00000000cf45c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf45c000 - 00000000cf45d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf45d000 - 00000000cf45e000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf45e000 - 00000000cf463000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf463000 - 00000000cf472000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf472000 - 00000000cf600000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] max_pfn_mapped = 1245184
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F03C0, 0024 (r2  INTEL)
[    0.000000] ACPI: XSDT CF45AF10, 0044 (r1  INTEL   DG31PR  6222004 MSFT    10013)
[    0.000000] ACPI: FACP CF458D90, 00F4 (r4  INTEL   DG31PR  6222004 MSFT    10013)
[    0.000000] ACPI: DSDT CF453010, 4D33 (r1  INTEL   DG31PR        0 INTL 20051117)
[    0.000000] ACPI: FACS CF459F40, 0040
[    0.000000] ACPI: APIC CF458F10, 006C (r2  INTEL   DG31PR  6222004 MSFT    10013)
[    0.000000] ACPI: HPET CF461D10, 0038 (r1  INTEL ICH7HPET  6222004 AMI.        1)
[    0.000000] ACPI: MCFG CF461C10, 003C (r1 INTEL  DG31PR    6222004 MSFT       97)
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-7582fb] TEXT DATA BSS
[    0.000000]   early res: 3 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-dfff] PGTABLE
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   848556
[    0.000000]     0:   849010 ->   849408
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f71c000)
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 35632 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1026966
[    0.000000] Kernel command line: BOOT_IMAGE=l2626 ro root=900 video=intelfb:1280x1024-16@60 resume=/dev/sda2 selinux=1 audit=1 nmi_watchdog=2
[    0.000000] audit: enabled (after initialization)
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 2199.953 MHz processor.
[    0.004000] Console: colour VGA+ 80x28
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Checking aperture...
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x163f000 - 0x563f000
[    0.004000] Memory: 4033484k/4980736k available (2898k kernel code, 147648k reserved, 1630k data, 304k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.083913] Calibrating delay using timer specific routine.. 4403.46 BogoMIPS (lpj=8806922)
[    0.084005] Security Framework initialized
[    0.084005] SELinux:  Initializing.
[    0.084005] selinux_register_security:  Registering secondary module capability
[    0.084005] Capability LSM initialized as secondary
[    0.084005] Mount-cache hash table entries: 256
[    0.084005] Initializing cgroup subsys ns
[    0.084005] Initializing cgroup subsys cpuacct
[    0.084005] Initializing cgroup subsys devices
[    0.084005] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084005] CPU: L2 cache: 1024K
[    0.084005] CPU: Physical Processor ID: 0
[    0.084005] CPU: Processor Core ID: 0
[    0.084005] CPU0: Thermal monitoring enabled (TM2)
[    0.084005] using mwait in idle threads.
[    0.084005] ACPI: Core revision 20080321
[    0.131240] CPU0: Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d
[    0.131386] Using local APIC timer interrupts.
[    0.136008] Detected 12.499 MHz APIC timer.
[    0.136008] Booting processor 1/1 ip 6000
[    0.144009] Initializing CPU#1
[    0.144009] Calibrating delay using timer specific routine.. 4399.89 BogoMIPS (lpj=8799797)
[    0.144009] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.144009] CPU: L2 cache: 1024K
[    0.144009] CPU: Physical Processor ID: 0
[    0.144009] CPU: Processor Core ID: 1
[    0.144009] CPU1: Thermal monitoring enabled (TM2)
[    0.144009] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.224014] CPU1: Intel(R) Pentium(R) Dual  CPU  E2200  @ 2.20GHz stepping 0d
[    0.224014] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.228014] Brought up 2 CPUs
[    0.228014] Total of 2 processors activated (8803.35 BogoMIPS).
[    0.228014] Testing NMI watchdog ... OK.
[    0.308019] net_namespace: 1224 bytes
[    0.308019] Booting paravirtualized kernel on bare hardware
[    0.308019] xor: automatically using best checksumming function: generic_sse
[    0.324905]    generic_sse:  8047.000 MB/sec
[    0.325001] xor: using function: generic_sse (8047.000 MB/sec)
[    0.325130] NET: Registered protocol family 16
[    0.328121] No dock devices found.
[    0.328121] ACPI: bus type pci registered
[    0.328121] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 64
[    0.328121] PCI: Not using MMCONFIG.
[    0.328121] PCI: Using configuration type 1 for base access
[    0.334329] ACPI: Interpreter enabled
[    0.334426] ACPI: (supports S0 S5)
[    0.334564] ACPI: Using IOAPIC for interrupt routing
[    0.334712] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 64
[    0.336122] PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources
[    0.336298] PCI: Not using MMCONFIG.
[    0.340122] ACPI: BIOS _OSI(Linux) query ignored
[    0.340122] ACPI: DMI System Vendor:         
[    0.340122] ACPI: DMI Product Name:         
[    0.340122] ACPI: DMI Product Version:         
[    0.340122] ACPI: DMI Board Name: DG31PR
[    0.340122] ACPI: DMI BIOS Vendor: Intel Corp.
[    0.340122] ACPI: DMI BIOS Date: 02/27/2008
[    0.340122] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
[    0.340122] ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
[    0.344122] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.344689] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.344861] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.345414] PCI: Transparent bridge - 0000:00:1e.0
[    0.352123] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.352123] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.352123] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.352123] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.352123] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.352123] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.352123] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.352653] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.356123] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.356123] pnp: PnP ACPI init
[    0.356123] ACPI: bus type pnp registered
[    0.360123] pnp: PnP ACPI: found 13 devices
[    0.360123] ACPI: ACPI bus type pnp unregistered
[    0.360123] SCSI subsystem initialized
[    0.360123] usbcore: registered new interface driver usbfs
[    0.360123] usbcore: registered new interface driver hub
[    0.360123] usbcore: registered new device driver usb
[    0.360123] PCI: Using ACPI for IRQ routing
[    0.380087] NetLabel: Initializing
[    0.380125] NetLabel:  domain hash size = 128
[    0.380125] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.380125] NetLabel:  unlabeled traffic allowed by default
[    0.380125] PCI-GART: No AMD northbridge found.
[    0.380125] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.380125] hpet0: 3 64-bit timers, 14318180 Hz
[    0.380125] ACPI: RTC can wake from S4
[    0.394408] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.394526] system 00:01: iomem range 0xe0000000-0xe3ffffff has been reserved
[    0.394643] system 00:02: ioport range 0x400-0x47f has been reserved
[    0.394746] system 00:02: ioport range 0x1180-0x119f has been reserved
[    0.394850] system 00:02: ioport range 0x500-0x53f has been reserved
[    0.394954] system 00:02: iomem range 0xfec00000-0xfecfffff has been reserved
[    0.395058] system 00:02: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.395163] system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.395334] system 00:02: iomem range 0xffb00000-0xffcfffff could not be reserved
[    0.395505] system 00:02: iomem range 0xfc800000-0xfc800fff has been reserved
[    0.395610] system 00:02: iomem range 0xfed20000-0xfed7ffff has been reserved
[    0.395715] system 00:02: iomem range 0xffe00000-0xffffffff could not be reserved
[    0.395888] system 00:03: ioport range 0x290-0x29f has been reserved
[    0.395999] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.396336] PCI: Bridge: 0000:00:01.0
[    0.396336]   IO window: disabled.
[    0.396336]   MEM window: disabled.
[    0.396336]   PREFETCH window: disabled.
[    0.396336] PCI: Bridge: 0000:00:1c.0
[    0.396336]   IO window: disabled.
[    0.396336]   MEM window: disabled.
[    0.396336]   PREFETCH window: disabled.
[    0.396336] PCI: Bridge: 0000:00:1c.1
[    0.396336]   IO window: e000-efff
[    0.396336]   MEM window: 0xff800000-0xff8fffff
[    0.396336]   PREFETCH window: disabled.
[    0.396336] PCI: Bridge: 0000:00:1e.0
[    0.396336]   IO window: d000-dfff
[    0.396336]   MEM window: 0xff700000-0xff7fffff
[    0.396336]   PREFETCH window: disabled.
[    0.396336] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.396336] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.398408] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.398619] NET: Registered protocol family 2
[    0.438664] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.439328] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.442608] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.443216] TCP: Hash tables configured (established 262144 bind 65536)
[    0.443322] TCP reno registered
[    0.451871] NET: Registered protocol family 1
[    0.454650] audit: initializing netlink socket (enabled)
[    0.454650] type=2000 audit(1216911801.448:1): initialized
[    0.458668] VFS: Disk quotas dquot_6.5.1
[    0.458668] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.458678] msgmni has been set to 7879
[    0.458678] async_tx: api initialized (sync-only)
[    0.458678] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.458678] io scheduler noop registered
[    0.458678] io scheduler anticipatory registered
[    0.458678] io scheduler deadline registered
[    0.458678] io scheduler cfq registered (default)
[    0.458678] assign_interrupt_mode Found MSI capability
[    0.458678] assign_interrupt_mode Found MSI capability
[    0.458678] assign_interrupt_mode Found MSI capability
[    0.458726] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.458898] ACPI: Power Button (FF) [PWRF]
[    0.459085] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.459263] ACPI: Sleep Button (CM) [SLPB]
[    0.459415] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.459592] ACPI: Power Button (CM) [PWRB]
[    0.459988] ACPI: SSDT CF45EC10, 02CC (r1    AMI      IST        1 MSFT  3000001)
[    0.466667] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.466667] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.466667] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.466667] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.524641] Linux agpgart interface v0.103
[    0.524755] agpgart: Detected an Intel G33 Chipset.
[    0.525203] agpgart: Detected 7164K stolen memory.
[    0.538224] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.538284] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    0.538284] Hangcheck: Using get_cycles().
[    0.538284] Driver 'sd' needs updating - please use bus_type methods
[    0.538284] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    0.538284] scsi0 : ata_piix
[    0.538284] scsi1 : ata_piix
[    0.539805] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14
[    0.539805] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15
[    0.698054] ata1.00: ATAPI: ASUS    DRW-1814BL, 1.13, max UDMA/66
[    0.713795] ata1.00: configured for UDMA/66
[    0.715215] scsi 0:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.13 PQ: 0 ANSI: 5
[    0.718780] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[    0.718780] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.718780] scsi2 : ata_piix
[    0.718780] scsi3 : ata_piix
[    0.718780] ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 17
[    0.718780] ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 17
[    0.879762] ata3.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
[    0.879876] ata3.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.897436] ata3.00: configured for UDMA/133
[    1.058295] ata4.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
[    1.058408] ata4.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.075859] ata4.00: configured for UDMA/133
[    1.075859] scsi 2:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
[    1.075859] sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
[    1.075859] sd 2:0:0:0: [sda] Write Protect is off
[    1.075859] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.075859] sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
[    1.075859] sd 2:0:0:0: [sda] Write Protect is off
[    1.075859] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.075859]  sda: sda1 sda2 sda3 < sda5 >
[    1.093168] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.093168] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
[    1.093168] sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
[    1.093168] sd 3:0:0:0: [sdb] Write Protect is off
[    1.093168] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.097312] sd 3:0:0:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
[    1.097426] sd 3:0:0:0: [sdb] Write Protect is off
[    1.097544] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.099009]  sdb: sdb1 sdb2 sdb3 < sdb5 >
[    1.123544] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.123544] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    1.123544] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.123544] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.134044] ehci_hcd 0000:00:1d.7: debug port 1
[    1.134155] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff984000
[    1.147551] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.148807] usb usb1: configuration #1 chosen from 1 choice
[    1.149945] hub 1-0:1.0: USB hub found
[    1.150045] hub 1-0:1.0: 8 ports detected
[    1.255045] USB Universal Host Controller Interface driver v3.0
[    1.255045] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.255055] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.255594] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.255594] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[    1.255594] usb usb2: configuration #1 chosen from 1 choice
[    1.255594] hub 2-0:1.0: USB hub found
[    1.255594] hub 2-0:1.0: 2 ports detected
[    1.359978] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.359978] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.360472] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.360472] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[    1.360472] usb usb3: configuration #1 chosen from 1 choice
[    1.360472] hub 3-0:1.0: USB hub found
[    1.360472] hub 3-0:1.0: 2 ports detected
[    1.466122] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.466122] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.466616] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.466616] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[    1.466616] usb usb4: configuration #1 chosen from 1 choice
[    1.466616] hub 4-0:1.0: USB hub found
[    1.466616] hub 4-0:1.0: 2 ports detected
[    1.570122] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    1.570122] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.570616] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.570616] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020
[    1.570616] usb usb5: configuration #1 chosen from 1 choice
[    1.570616] hub 5-0:1.0: USB hub found
[    1.570616] hub 5-0:1.0: 2 ports detected
[    1.674870] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.674870] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.675417] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.675417] mice: PS/2 mouse device common for all mice
[    1.682625] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.735381] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    1.735381] rtc0: alarms up to one year, y3k
[    1.735381] i2c /dev entries driver
[    1.735381] md: raid0 personality registered for level 0
[    1.735381] md: raid1 personality registered for level 1
[    1.735381] md: raid10 personality registered for level 10
[    1.770607] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.806453] raid6: int64x1   2156 MB/s
[    1.822579] usb 1-2: configuration #1 chosen from 1 choice
[    1.822686] hub 1-2:1.0: USB hub found
[    1.822686] hub 1-2:1.0: 4 ports detected
[    1.874528] raid6: int64x2   2757 MB/s
[    1.942471] raid6: int64x4   2041 MB/s
[    2.010382] raid6: int64x8   1833 MB/s
[    2.078319] raid6: sse2x1    3477 MB/s
[    2.146238] raid6: sse2x2    3853 MB/s
[    2.166584] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    2.214171] raid6: sse2x4    6662 MB/s
[    2.214267] raid6: using algorithm sse2x4 (6662 MB/s)
[    2.214367] md: raid6 personality registered for level 6
[    2.214466] md: raid5 personality registered for level 5
[    2.214565] md: raid4 personality registered for level 4
[    2.214630] EDAC MC: Ver: 2.1.0 Jul 24 2008
[    2.214630] cpuidle: using governor ladder
[    2.214630] cpuidle: using governor menu
[    2.230581] Marking TSC unstable due to TSC halts in idle
[    2.318609] usb 2-1: configuration #1 chosen from 1 choice
[    2.493463] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4
[    2.520324] input: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.0-1
[    2.520328] usbcore: registered new interface driver usbhid
[    2.520328] usbhid: v2.6:USB HID core driver
[    2.520331] TCP cubic registered
[    2.520340] NET: Registered protocol family 10
[    2.520340] lo: Disabled Privacy Extensions
[    2.520340] NET: Registered protocol family 17
[    2.520365] registered taskstats version 1
[    2.520365] rtc_cmos 00:08: setting system clock to 2008-07-24 15:03:24 UTC (1216911804)
[    2.520374] md: Autodetecting RAID arrays.
[    2.562137] md: invalid raid superblock magic on sda5
[    2.562137] md: sda5 does not have a valid v0.90 superblock, not importing!
[    2.591126] md: invalid raid superblock magic on sdb5
[    2.591126] md: sdb5 does not have a valid v0.90 superblock, not importing!
[    2.591126] md: Scanned 4 and added 2 devices.
[    2.591126] md: autorun ...
[    2.591126] md: considering sdb1 ...
[    2.591126] md:  adding sdb1 ...
[    2.591126] md:  adding sda1 ...
[    2.591126] md: created md0
[    2.591126] md: bind<sda1>
[    2.591126] md: bind<sdb1>
[    2.591938] md: running: <sdb1><sda1>
[    2.595977] raid1: raid set md0 active with 2 out of 2 mirrors
[    2.595977] md: ... autorun DONE.
[    2.615882] kjournald starting.  Commit interval 5 seconds
[    2.615882] EXT3-fs: mounted filesystem with ordered data mode.
[    2.615882] VFS: Mounted root (ext3 filesystem) readonly.
[    2.615882] Freeing unused kernel memory: 304k freed
[    3.097367] SELinux: policy loaded with handle_unknown=deny
[    3.097479] type=1403 audit(1216911805.025:2): policy loaded auid=4294967295 ses=4294967295
[    3.388376] type=1400 audit(1216911805.306:3): avc:  denied  { read write } for  pid=554 comm="hostname" name="console" dev=md0 ino=51240 scontext=system_u:system_r:hostname_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file
[    3.388490] type=1300 audit(1216911805.306:3): arch=40000003 syscall=11 success=yes exit=0 a0=980b374 a1=980b328 a2=980b334 a3=2 items=0 ppid=552 pid=554 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="hostname" exe="/bin/hostname" subj=system_u:system_r:hostname_t:s0 key=(null)
[    3.427939] type=1400 audit(1216911805.338:4): avc:  denied  { read write } for  pid=557 comm="mountpoint" name="console" dev=md0 ino=51240 scontext=system_u:system_r:mount_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file
[    3.427939] type=1300 audit(1216911805.338:4): arch=40000003 syscall=11 success=yes exit=0 a0=9a9f64c a1=9a9f5f8 a2=9a9f60c a3=2 items=0 ppid=555 pid=557 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="mountpoint" exe="/bin/mountpoint" subj=system_u:system_r:mount_t:s0 key=(null)
[    3.681882] type=1400 audit(1216911805.593:5): avc:  denied  { read write } for  pid=584 comm="restorecon" name="console" dev=md0 ino=51240 scontext=system_u:system_r:setfiles_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file
[    3.682246] type=1300 audit(1216911805.593:5): arch=40000003 syscall=11 success=yes exit=0 a0=95dea14 a1=95dea48 a2=95dea54 a3=95dbf5d items=0 ppid=577 pid=584 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="restorecon" exe="/sbin/setfiles" subj=system_u:system_r:setfiles_t:s0 key=(null)
[    4.846325] type=1400 audit(1216911806.753:6): avc:  denied  { getattr } for  pid=862 comm="hdparm" path="/proc/mdstat" dev=proc ino=4026531950 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:proc_mdstat_t:s0 tclass=file
[    4.846725] type=1300 audit(1216911806.753:6): arch=40000003 syscall=195 success=yes exit=0 a0=951a4dc a1=fffb4f2c a2=4546cff4 a3=805b285 items=0 ppid=789 pid=862 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="hdparm" exe="/bin/dash" subj=system_u:system_r:udev_t:s0-s0:c0.c1023 key=(null)
[    5.083531] FDC 0 is a post-1991 82077
[    5.097315] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
[    5.122995] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    5.123020] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.125589] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.146818] ACPI Exception (video-1600): AE_NOT_FOUND, Evaluating _DOD [20080321]
[    5.146875] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/input/input5
[    5.157692] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    5.157692] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
[    5.157932] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.169350] 8139too Fast Ethernet driver 0.9.28
[    5.169519] ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21
[    5.169688] eth0: RealTek RTL8139 at 0xffffc20000022000, 00:c1:28:01:d5:f6, IRQ 21
[    5.182384] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[    5.182384] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[    5.182932] eth1: RTL8168b/8111b at 0xffffc20000024000, 00:1c:c0:34:06:c9, XID 38500000 IRQ 380
[    5.199443] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    5.201572] Driver 'sr' needs updating - please use bus_type methods
[    5.206543] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.206543] Uniform CD-ROM driver Revision: 3.20
[    5.261656] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    5.282010] udev: renamed network interface eth0 to rtl
[    5.284596] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    5.284721] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    5.284745] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    5.290499] udev: renamed network interface eth1 to mobo
[    5.301018] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    5.635938] __ratelimit: 30 messages suppressed
[    5.635938] type=1400 audit(1216911807.526:12): avc:  denied  { read write } for  pid=1266 comm="hwclock" name="console" dev=md0 ino=51240 scontext=system_u:system_r:hwclock_t:s0 tcontext=user_u:object_r:device_t:s0 tclass=chr_file
[    5.709887] Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
[    5.737559] Adding 2008116k swap on /dev/sdb2.  Priority:-2 extents:1 across:2008116k
[    5.942999] EXT3 FS on md0, internal journal
[    6.391974] w83627ehf: Found W83627DHG chip at 0x290
[    6.403821] coretemp coretemp.0: Using relative temperature scale!
[    6.403821] coretemp coretemp.1: Using relative temperature scale!
[    6.431181] netconsole: local port 4444
[    6.431281] netconsole: local IP XXX.XXX.XXX.XXX
[    6.431378] netconsole: interface mobo
[    6.431473] netconsole: remote port 5555
[    6.431569] netconsole: remote IP XXX.XXX.XXX.XXX
[    6.431666] netconsole: remote ethernet address XX:XX:XX:XX:XX:XX
[    6.431770] netconsole: device mobo not up yet, forcing it
[    6.431804] r8169: mobo: link down
[    6.433992] r8169: mobo: link down
[    6.431804] ADDRCONF(NETDEV_UP): mobo: link is not ready
[    6.907881] r8169: mobo: link up
[    6.916340] ADDRCONF(NETDEV_CHANGE): mobo: link becomes ready
[    6.930927] console [netcon0] enabled
[    6.989436] netconsole: network logging started
[    7.077462] device-mapper: uevent: version 1.0.3
[    7.077462] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    7.128869] md: md3 stopped.
[    7.203243] md: bind<sda5>
[    7.203270] md: bind<sdb5>
[    7.213092] raid1: raid set md3 active with 2 out of 2 mirrors
[    9.462901] fuse init (API version 7.9)
[    9.613115] kjournald starting.  Commit interval 5 seconds
[    9.648150] EXT3 FS on dm-0, internal journal
[    9.648281] EXT3-fs: mounted filesystem with ordered data mode.
[    9.714664] kjournald starting.  Commit interval 5 seconds
[    9.714728] EXT3 FS on dm-1, internal journal
[    9.714853] EXT3-fs: mounted filesystem with ordered data mode.
[    9.757664] kjournald starting.  Commit interval 5 seconds
[    9.757683] EXT3 FS on dm-2, internal journal
[    9.757683] EXT3-fs: mounted filesystem with ordered data mode.
[    9.807357] kjournald starting.  Commit interval 5 seconds
[    9.807357] EXT3 FS on dm-3, internal journal
[    9.807357] EXT3-fs: mounted filesystem with ordered data mode.
[   10.949855] __ratelimit: 99 messages suppressed
[   10.949855] type=1400 audit(1216911812.374:29): avc:  denied  { getattr } for  pid=1240 comm="alsa-utils" path="/var/lib/alsa/asound.state" dev=dm-1 ino=655366 scontext=system_u:system_r:udev_t:s0-s0:c0.c1023 tcontext=system_u:object_r:var_lib_t:s0 tclass=file
[   12.772197] NET: Registered protocol family 15
[   13.185460] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.289625] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   13.934640] rtl: link down
[   13.934640] ADDRCONF(NETDEV_UP): rtl: link is not ready
[   14.667829] ttyS1: LSR safety check engaged!
[   14.667870] ttyS1: LSR safety check engaged!
[   17.018055] firmware: requesting intel-ucode/06-0f-0d
[   17.077251] firmware: requesting intel-ucode/06-0f-0d
[   17.077364] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   17.141598] microcode: CPU0 updated from revision 0xa1 to 0xa3, date = 08132007 
[   17.141810] microcode: CPU1 updated from revision 0xa1 to 0xa3, date = 08132007 
[   42.597389] RPC: Registered udp transport module.
[   42.597389] RPC: Registered tcp transport module.
[   42.921288] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   43.094238] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   43.226258] NFSD: starting 90-second grace period
[   53.427883] device mobo entered promiscuous mode
[   53.443555] device mobo left promiscuous mode
[   53.459186] device mobo entered promiscuous mode
[   59.367901] Initializing XFRM netlink socket
[   62.574567] ttyS1: LSR safety check engaged!
[   63.247403] Bluetooth: Core ver 2.11
[   63.249496] NET: Registered protocol family 31
[   63.249607] Bluetooth: HCI device and connection manager initialized
[   63.249715] Bluetooth: HCI socket layer initialized
[   63.275906] Bluetooth: L2CAP ver 2.9
[   63.276018] Bluetooth: L2CAP socket layer initialized
[   63.314702] Bluetooth: RFCOMM socket layer initialized
[   63.314823] Bluetooth: RFCOMM TTY layer initialized
[   63.314925] Bluetooth: RFCOMM ver 1.8
[   68.815816] [drm] Initialized drm 1.1.0 20060810
[   68.895173] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   68.896841] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   69.392331] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[  101.199286] ioctl32(gnome-terminal:5099): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/0
[  101.199286] ioctl32(gnome-terminal:5099): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/0
[  101.199286] ioctl32(gnome-terminal:5099): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/0
[  138.077160] ioctl32(gnome-terminal:5256): Unknown cmd fd(25) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/1
[  138.080047] ioctl32(gnome-terminal:5256): Unknown cmd fd(25) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/1
[  138.080166] ioctl32(gnome-terminal:5256): Unknown cmd fd(25) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/1
[  140.555330] ioctl32(gnome-terminal:5299): Unknown cmd fd(26) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/2
[  140.557362] ioctl32(gnome-terminal:5299): Unknown cmd fd(26) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/2
[  140.557569] ioctl32(gnome-terminal:5299): Unknown cmd fd(26) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/2
[  162.744075] ioctl32(gnome-terminal:5363): Unknown cmd fd(27) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/3
[  162.744094] ioctl32(gnome-terminal:5363): Unknown cmd fd(27) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/3
[  162.744099] ioctl32(gnome-terminal:5363): Unknown cmd fd(27) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/3
[  164.238901] ioctl32(gnome-terminal:5405): Unknown cmd fd(28) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/4
[  164.238919] ioctl32(gnome-terminal:5405): Unknown cmd fd(28) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/4
[  164.238925] ioctl32(gnome-terminal:5405): Unknown cmd fd(28) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/4
[  165.088925] ioctl32(gnome-terminal:5447): Unknown cmd fd(29) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/5
[  165.088948] ioctl32(gnome-terminal:5447): Unknown cmd fd(29) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/5
[  165.088954] ioctl32(gnome-terminal:5447): Unknown cmd fd(29) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/5
[  166.232412] ioctl32(gnome-terminal:5490): Unknown cmd fd(30) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/6
[  166.232412] ioctl32(gnome-terminal:5490): Unknown cmd fd(30) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/6
[  166.232412] ioctl32(gnome-terminal:5490): Unknown cmd fd(30) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/6
[  167.055135] ioctl32(gnome-terminal:5535): Unknown cmd fd(31) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/7
[  167.055155] ioctl32(gnome-terminal:5535): Unknown cmd fd(31) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/7
[  167.055161] ioctl32(gnome-terminal:5535): Unknown cmd fd(31) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/7
[  167.775924] ioctl32(gnome-terminal:5577): Unknown cmd fd(32) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/8
[  167.775942] ioctl32(gnome-terminal:5577): Unknown cmd fd(32) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/8
[  167.775948] ioctl32(gnome-terminal:5577): Unknown cmd fd(32) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/8
[  168.530811] ioctl32(gnome-terminal:5619): Unknown cmd fd(33) cmd(0000530b){t:'S';sz:0} arg(4ac58c2a) on /dev/pts/9
[  168.530832] ioctl32(gnome-terminal:5619): Unknown cmd fd(33) cmd(0000530b){t:'S';sz:0} arg(4ac58c2f) on /dev/pts/9
[  168.530838] ioctl32(gnome-terminal:5619): Unknown cmd fd(33) cmd(0000530b){t:'S';sz:0} arg(4ac58c36) on /dev/pts/9
[  177.572826] __ratelimit: 24 messages suppressed
[  177.572837] rtc: lost 1 interrupts
[ 1019.627462] [drm:drm_update_drawable_info] *ERROR* Failed to copy cliprects from userspace
[ 1035.463517] usb 1-2: USB disconnect, address 3
[ 1192.154032] NMI Watchdog detected LOCKUP on CPU 0
[ 1192.154032] CPU 0 
[ 1192.154032] Modules linked in: i915 drm rfcomm l2cap bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 aead ah4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs microcode ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_x86_64 aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_log dm_mod netconsole configfs coretemp w83627ehf hwmon_vid sg snd_hda_intel snd_pcm sr_mod snd_timer r8169 8139too iTCO_wdt video cdrom 8250_pnp 8250 serial_core i2c_i801 snd floppy snd_page_alloc
[ 1192.154032] Pid: 0, comm: swapper Not tainted 2.6.26 #16
[ 1192.154032] RIP: 0010:[<ffffffff8021cc9f>]  [<ffffffff8021cc9f>] hpet_rtc_interrupt+0x120/0x2f3
[ 1192.154032] RSP: 0018:ffffffff806e0eb8  EFLAGS: 00000046
[ 1192.154032] RAX: 0000000000000004 RBX: 0000000000000002 RCX: 0000000000000000
[ 1192.154032] RDX: 00000000d4ba4d4a RSI: 0000000000000002 RDI: 0000000000000002
[ 1192.154032] RBP: ffffffff806e0f18 R08: ffffffffff5fc128 R09: 0000000000000000
[ 1192.154032] R10: ffff8100affafd30 R11: ffffffff80685e98 R12: 00000000000000a6
[ 1192.154032] R13: 0000000100033c91 R14: ffff81012f1b8c00 R15: ffffffff80690140
[ 1192.154032] FS:  0000000000000000(0000) GS:ffffffff8066d000(0000) knlGS:0000000000000000
[ 1192.154032] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1192.154032] CR2: 000000000804fa50 CR3: 0000000000201000 CR4: 00000000000006e0
[ 1192.154032] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1192.154032] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1192.154032] Process swapper (pid: 0, threadinfo ffffffff80684000, task ffffffff80633350)
[ 1192.154032] Stack:  ffff81012c9d2c00 ffff810122b50000 0000000000000000 0000000000000000
[ 1192.154032]  0000000000000000 0000000000000000 ffffffff00000000 00000000000e6d36
[ 1192.154032]  ffff81012fce4880 0000000000000000 0000000000000000 0000000000000008
[ 1192.154032] Call Trace:
[ 1192.154032]  <IRQ>  [<ffffffff8026746c>] handle_IRQ_event+0x2e/0x65
[ 1192.154032]  [<ffffffff80268571>] handle_edge_irq+0xe9/0x12a
[ 1192.154032]  [<ffffffff8020e6d0>] do_IRQ+0xf7/0x169
[ 1192.154032]  [<ffffffff8020b9bd>] ret_from_intr+0x0/0x19
[ 1192.154032]  <EOI>  [<ffffffff80421208>] ? poll_idle+0x2d/0x61
[ 1192.154032]  [<ffffffff804211e9>] ? poll_idle+0xe/0x61
[ 1192.154032]  [<ffffffff80420f64>] ? cpuidle_idle_call+0x0/0xc1
[ 1192.154032]  [<ffffffff80209370>] ? default_idle+0x0/0x4b
[ 1192.154032]  [<ffffffff80420ff1>] ? cpuidle_idle_call+0x8d/0xc1
[ 1192.154032]  [<ffffffff80420f64>] ? cpuidle_idle_call+0x0/0xc1
[ 1192.154032]  [<ffffffff80209370>] ? default_idle+0x0/0x4b
[ 1192.154032]  [<ffffffff8020a53a>] ? cpu_idle+0x92/0xda
[ 1192.154032]  [<ffffffff804c2188>] ? rest_init+0x5c/0x5e
[ 1192.154032] 
[ 1192.154032] 
[ 1192.154032] Code: 4d 2b 00 bf 0a 00 00 00 48 89 c3 e8 34 52 ff ff 48 89 de 41 88 c4 48 c7 c7 18 9f 6e 80 e8 ad 4e 2b 00 45 84 e4 78 04 eb 12 f3 90 <48> 8b 05 da 5b 46 00 4c 29 e8 48 83 f8 04 76 ee 48 c7 c7 18 9f 
[ 1192.154032] ---[ end trace e0221fdc14e85140 ]---
[ 1197.498241] Kernel panic - not syncing: Aiee, killing interrupt handler!

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
