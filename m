Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYHMVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYHMVEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYHMVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:04:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:42415 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYHMVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rXzV+iNA9BgUtz55ApUKgpUg2UDtKVUhaAGkKQRTmUraSh23WEh3aN7bwdHNsWaWgg
         RnRnswZ2N2qc/Eek0BN5/MoR1z3BO1g/ENTZE34U+bAMDI3SkyeW9ymr906AKOHB4dxO
         CfQzrL3xfq6iHM1XvhOlKBZbI90Erx83BNPBg=
Subject: Re: Timer unstability on when using C2 and deeper sleep states
	(Dell Latitude XT)
From: Milan Plzik <milan.plzik@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <87proczn33.fsf@basil.nowhere.org>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost>  <87proczn33.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 23:04:16 +0200
Message-Id: <1218661456.4249.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On St, 2008-08-13 at 22:17 +0200, Andi Kleen wrote:
> Milan Plzik <milan.plzik@gmail.com> writes:
> 
> >   I apologize for replying on my own mail (and also for top-posting, but
> > this information is global update, not exactly fitting any of topics
> > mentioned below).
> >
> >   After playing for a longer while I found out that the system ends
> > sometimes in state where, in order to do anything useful, I need to
> > press keys on keyboard. 
> 
> This usually means it is using the wrong timer in a deeper idle state.
> Some idle states cannot be woken up by e.g. the APIC timer and then
> you get that effect: you only make progress when you wake up the 
> CPU in some other way like pressing a key. Then on wake up the
> timers get processed.
> 
> This is usually a bug in the kernel timer selection. It should be chosing
> a timer that always wakes up from the deepest idle state used.

  Last days I also considered this option; I tried all possible timers (hpet, tsc, acpi_pm), but their behavior is the same. 'jiffies' timer works correctly, but that one doesn't seem to put CPU to deeper sleeps, so we can't deduce any information from that. 

  I've seen some workaround in drivers/acpi/processor_idle.c, which seems to check the ARCH_APICTIMER_STOPS_ON_C3 macro, but it's enabled at compilation time, so the code is used by kernel... .

> 
> You should post the full boot log

  Posted; see below.

> 
> -Andi
> 

  Thank you,
	Milan

Bootlog:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-gentoo (root@tiny) (gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) ) #29 SMP Wed Aug 13 21:23:54 CEST 2008
[    0.000000] Command line: root=/dev/sda6 resume=/dev/sda7 acpi_osi=Linux usbcore.autosuspend=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000006fe51800 (usable)
[    0.000000]  BIOS-e820: 000000006fe51800 - 0000000078000000 (reserved)
[    0.000000]  BIOS-e820: 00000000d8000000 - 00000000dc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 458321) 1 entries of 256 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FBF30, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 6FE53200, 0064 (r1 DELL    M08     27D8050C ASL        61)
[    0.000000] ACPI: FACP 6FE5309C, 00F4 (r4 DELL    M08     27D8050C ASL        61)
[    0.000000] ACPI Error (tbfadt-0453): 32/64X address mismatch in "Pm2ControlBlock": [00001218] [0000000000001214], using 64X [20080321]
[    0.000000] ACPI: DSDT 6FE53800, 53D4 (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 6FE62000, 0040
[    0.000000] ACPI: HPET 6FE53300, 0038 (r1 DELL    M08            1 ASL        61)
[    0.000000] ACPI: APIC 6FE53400, 0068 (r1 DELL    M08     27D8050C ASL        47)
[    0.000000] ACPI: ASF! 6FE53000, 006A (r32 DELL    M08     27D8050C ASL        61)
[    0.000000] ACPI: MCFG 6FE533C0, 003E (r16 DELL    M08     27D8050C ASL        61)
[    0.000000] ACPI: TCPA 6FE53700, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC 6FE5349C, 0176 (r1 DELL    M08     27D8050C ASL        61)
[    0.000000] ACPI: SSDT 6FE51BB5, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 458321) 1 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-92fe0f] TEXT DATA BSS
[    0.000000]   early res: 3 [9f000-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-bfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200019fffff] PMD -> [ffff810001200000-ffff810002bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   458321
[    0.000000] On node 0 totalpages: 458224
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1943 pages reserved
[    0.000000]   DMA zone: 2000 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6211 pages used for memmap
[    0.000000]   DMA32 zone: 448014 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 78000000:60000000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 33904 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 450014
[    0.000000] Kernel command line: root=/dev/sda6 resume=/dev/sda7 acpi_osi=Linux usbcore.autosuspend=1
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 1200.039 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000999] Checking aperture...
[    0.000999] Memory: 1794948k/1833284k available (4007k kernel code, 37560k reserved, 2145k data, 304k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.060994] Calibrating delay using timer specific routine.. 2402.18 BogoMIPS (lpj=1201094)
[    0.061224] Mount-cache hash table entries: 256
[    0.061546] Initializing cgroup subsys ns
[    0.061645] Initializing cgroup subsys devices
[    0.061755] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.061888] CPU: L2 cache: 2048K
[    0.061983] CPU: Physical Processor ID: 0
[    0.062087] CPU: Processor Core ID: 0
[    0.062189] CPU0: Thermal monitoring enabled (TM2)
[    0.062284] using mwait in idle threads.
[    0.062402] ACPI: Core revision 20080321
[    0.087369] CPU0: Intel(R) Core(TM)2 CPU         U7600  @ 1.20GHz stepping 02
[    0.087549] Using local APIC timer interrupts.
[    0.088986] APIC timer calibration result 8333598
[    0.088986] Detected 8.333 MHz APIC timer.
[    0.089260] Booting processor 1/1 ip 6000
[    0.099984] Initializing CPU#1
[    0.099984] Calibrating delay using timer specific routine.. 2400.00 BogoMIPS (lpj=1200003)
[    0.099984] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.099984] CPU: L2 cache: 2048K
[    0.099984] CPU: Physical Processor ID: 0
[    0.099984] CPU: Processor Core ID: 1
[    0.099984] CPU1: Thermal monitoring enabled (TM2)
[    0.099984] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.161975] CPU1: Intel(R) Core(TM)2 CPU         U7600  @ 1.20GHz stepping 02
[    0.162975] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.163974] Brought up 2 CPUs
[    0.163974] Total of 2 processors activated (4802.19 BogoMIPS).
[    0.163974] net_namespace: 616 bytes
[    0.164974] NET: Registered protocol family 16
[    0.164974] No dock devices found.
[    0.165717] ACPI: bus type pci registered
[    0.165974] PCI: MCFG configuration 0: base d8000000 segment 0 buses 0 - 63
[    0.165974] PCI: MCFG area at d8000000 reserved in E820
[    0.169821] PCI: Using MMCONFIG at d8000000 - dbffffff
[    0.169922] PCI: Using configuration type 1 for base access
[    0.174803] ACPI: EC: Look up EC in DSDT
[    0.174973] ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.174973] ACPI: DMI System Vendor: Dell Inc.
[    0.174973] ACPI: DMI Product Name: Latitude XT                     
[    0.174973] ACPI: DMI Product Version: 
[    0.175096] ACPI: DMI Board Name: 0KT812
[    0.175192] ACPI: DMI BIOS Vendor: Dell Inc.
[    0.175801] ACPI: DMI BIOS Date: 05/12/2008
[    0.175898] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
[    0.197305] ACPI: SSDT 6FE62080, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
[    0.223485] ACPI: Interpreter enabled
[    0.223485] ACPI: (supports S0 S3 S4 S5)
[    0.223752] ACPI: Using IOAPIC for interrupt routing
[    0.301557] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.304250] PCI: Transparent bridge - 0000:00:14.4
[    0.304420] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.304632] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.305249] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.305469] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.305702] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.305931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.322119] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *0, disabled.
[    0.322990] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *0, disabled.
[    0.323479] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
[    0.323999] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0, disabled.
[    0.324988] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.325868] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.326677] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.327557] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.328676] ACPI: WMI: Mapper loaded
[    0.328780] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.328973] pnp: PnP ACPI init
[    0.329080] ACPI: bus type pnp registered
[    0.413267] pnp: PnP ACPI: found 13 devices
[    0.413369] ACPI: ACPI bus type pnp unregistered
[    0.413992] SCSI subsystem initialized
[    0.414068] libata version 3.00 loaded.
[    0.414068] usbcore: registered new interface driver usbfs
[    0.414254] usbcore: registered new interface driver hub
[    0.414503] usbcore: registered new device driver usb
[    0.416067] PCI: Using ACPI for IRQ routing
[    0.422403] Bluetooth: Core ver 2.11
[    0.423066] NET: Registered protocol family 31
[    0.423066] Bluetooth: HCI device and connection manager initialized
[    0.423066] Bluetooth: HCI socket layer initialized
[    0.427066] DMAR:parse DMAR table failure.
[    0.427066] PCI-GART: No AMD northbridge found.
[    0.427066] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.427066] hpet0: 4 32-bit timers, 14318180 Hz
[    0.444186] ACPI: RTC can wake from S4
[    0.449504] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.450478] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.450588] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.450695] system 00:09: ioport range 0xcb0-0xcbb has been reserved
[    0.450796] system 00:09: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.450902] system 00:0a: ioport range 0x900-0x97f has been reserved
[    0.451002] system 00:0a: ioport range 0x980-0x9ff has been reserved
[    0.451103] system 00:0a: ioport range 0xa00-0xa7f has been reserved
[    0.451203] system 00:0a: ioport range 0xa80-0xaff has been reserved
[    0.451303] system 00:0a: ioport range 0xcb0-0xcff could not be reserved
[    0.451407] system 00:0a: ioport range 0xd00-0xd7f has been reserved
[    0.451508] system 00:0a: ioport range 0xd80-0xdff has been reserved
[    0.451608] system 00:0a: ioport range 0xe00-0xe7f has been reserved
[    0.451708] system 00:0a: ioport range 0xe80-0xeaf has been reserved
[    0.451808] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.455861] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.455961] system 00:0a: ioport range 0x1000-0x1005 has been reserved
[    0.456062] system 00:0a: ioport range 0x1008-0x100f has been reserved
[    0.456861] system 00:0a: ioport range 0x1100-0x117f has been reserved
[    0.456962] system 00:0a: ioport range 0x1180-0x11ff has been reserved
[    0.457063] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.457162] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.457162] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.457162] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.457163] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.457163] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.457163] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.457163] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.457265] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.457856] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.457962] system 00:0b: ioport range 0xf400-0xf4fe has been reserved
[    0.458063] system 00:0b: ioport range 0x1006-0x1007 has been reserved
[    0.458164] system 00:0b: ioport range 0x100a-0x1059 could not be reserved
[    0.458264] system 00:0b: ioport range 0x1080-0x10bf has been reserved
[    0.458365] system 00:0b: ioport range 0x10c0-0x10df could not be reserved
[    0.458467] system 00:0b: ioport range 0x1010-0x102f has been reserved
[    0.458567] system 00:0b: ioport range 0x809-0x809 has been reserved
[    0.458663] system 00:0c: iomem range 0x0-0x9efff could not be reserved
[    0.458766] system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved
[    0.458867] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.458968] system 00:0c: iomem range 0xe0000-0xfffff has been reserved
[    0.459069] system 00:0c: iomem range 0x100000-0x6fe517ff could not be reserved
[    0.459222] system 00:0c: iomem range 0x6fe51800-0x6fefffff could not be reserved
[    0.459374] system 00:0c: iomem range 0x6ff00000-0x6fffffff could not be reserved
[    0.459527] system 00:0c: iomem range 0xffe00000-0xffffffff could not be reserved
[    0.459680] system 00:0c: iomem range 0xfec00000-0xfec0ffff could not be reserved
[    0.459836] system 00:0c: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    0.459988] system 00:0c: iomem range 0xffa00800-0xffa008ff has been reserved
[    0.460090] system 00:0c: iomem range 0xd8000000-0xdbffffff could not be reserved
[    0.460675] PCI: region 0000:03:01.0/9 too large: 0x0000000000000000-0x0000000003ffffff
[    0.460838] PCI: Bridge: 0000:00:01.0
[    0.460936]   IO window: e000-efff
[    0.461034]   MEM window: 0xfea00000-0xfeafffff
[    0.461133]   PREFETCH window: 0x00000000e0000000-0x00000000efffffff
[    0.461235] PCI: Bridge: 0000:00:04.0
[    0.461330]   IO window: disabled.
[    0.461429]   MEM window: 0xfe900000-0xfe9fffff
[    0.461526]   PREFETCH window: disabled.
[    0.461622] PCI: Bridge: 0000:00:06.0
[    0.461622]   IO window: disabled.
[    0.461622]   MEM window: 0xfe800000-0xfe8fffff
[    0.461723]   PREFETCH window: disabled.
[    0.461823] PCI: Bridge: 0000:00:07.0
[    0.461934]   IO window: d000-dfff
[    0.462033]   MEM window: 0xfe600000-0xfe7fffff
[    0.462131]   PREFETCH window: 0x00000000f0000000-0x00000000f01fffff
[    0.462242] PCI: Bus 4, cardbus bridge: 0000:03:01.0
[    0.462339]   IO window: 0x00002000-0x000020ff
[    0.462440]   IO window: 0x00002400-0x000024ff
[    0.462540]   MEM window: 0x80000000-0x83ffffff
[    0.462727] PCI: Bridge: 0000:00:14.4
[    0.462825]   IO window: 2000-2fff
[    0.462933]   MEM window: 0xfe500000-0xfe5fffff
[    0.463033]   PREFETCH window: disabled.
[    0.463161] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.463175] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.463190] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.463228] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    0.463432] NET: Registered protocol family 2
[    0.472782] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.473406] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.476744] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.477748] TCP: Hash tables configured (established 262144 bind 65536)
[    0.477914] TCP reno registered
[    0.480917] NET: Registered protocol family 1
[    0.482650] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    0.483707] Total HugeTLB memory allocated, 0
[    0.487706] VFS: Disk quotas dquot_6.5.1
[    0.487706] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.489706] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.489981] msgmni has been set to 3506
[    0.490515] io scheduler noop registered
[    0.490615] io scheduler deadline registered
[    0.490707] io scheduler cfq registered (default)
[    0.490707] pci 0000:01:05.0: Boot video device
[    0.490815] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.490861] assign_interrupt_mode Found MSI capability
[    0.491009] Allocate Port Service[0000:00:04.0:pcie00]
[    0.491316] Allocate Port Service[0000:00:04.0:pcie03]
[    0.491677] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.491706] assign_interrupt_mode Found MSI capability
[    0.491706] Allocate Port Service[0000:00:06.0:pcie00]
[    0.491706] Allocate Port Service[0000:00:06.0:pcie03]
[    0.491706] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    0.491706] assign_interrupt_mode Found MSI capability
[    0.491870] Allocate Port Service[0000:00:07.0:pcie00]
[    0.492137] Allocate Port Service[0000:00:07.0:pcie03]
[    0.513602] Switched to high resolution mode on CPU 1
[    0.514512] Switched to high resolution mode on CPU 0
[    0.529502] hpet_resources: 0xfed00000 is busy
[    0.529502] Non-volatile memory driver v1.2
[    0.530091] i8k: unable to get SMM BIOS version
[    0.530196] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
[    0.530506] Linux agpgart interface v0.103
[    0.531354] ACPI: AC Adapter [AC] (on-line)
[    0.580535] ACPI: Battery Slot [BAT0] (battery present)
[    0.580712] ACPI: Battery Slot [BAT1] (battery absent)
[    0.580829] input: Lid Switch as /class/input/input0
[    0.582500] ACPI: Lid Switch [LID]
[    0.582505] input: Power Button (CM) as /class/input/input1
[    0.586508] ACPI: Power Button (CM) [PBTN]
[    0.587219] input: Sleep Button (CM) as /class/input/input2
[    0.590993] ACPI: Sleep Button (CM) [SBTN]
[    0.608043] ACPI: device:2e is registered as cooling_device0
[    0.609110] input: Video Bus as /class/input/input3
[    0.612905] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.629437] ACPI: device:33 is registered as cooling_device1
[    0.629948] input: Video Bus as /class/input/input4
[    0.634931] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    0.636104] ACPI: SSDT 6FE525BC, 01C0 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    0.636920] ACPI: SSDT 6FE52081, 04B6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    0.638045] Monitor-Mwait will be used to enter C-1 state
[    0.638045] Monitor-Mwait will be used to enter C-2 state
[    0.638045] Monitor-Mwait will be used to enter C-3 state
[    0.638045] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.638045] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.638045] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.638836] ACPI: SSDT 6FE5277C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    0.639758] ACPI: SSDT 6FE52537, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[    0.641196] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.641502] ACPI: ACPI0007:01 is registered as cooling_device3
[    0.641606] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.662576] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.665570] ACPI: Thermal Zone [THM] (60 C)
[    0.667612] brd: module loaded
[    0.669428] loop: module loaded
[    0.669519] tg3.c:v3.92.1 (June 9, 2008)
[    0.669692] ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.669927] PCI: Setting latency timer of device 0000:09:00.0 to 64
[    0.679315] eth0: Tigon3 [partno(BCM95756m) rev a200 PHY(5722/5756)] (PCI Express) 10/100/1000Base-T Ethernet 00:15:c5:86:ff:cc
[    0.679429] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    0.679429] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    0.679550] PPP generic driver version 2.4.2
[    0.680083] tun: Universal TUN/TAP device driver, 1.6
[    0.680184] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.680428] console [netcon0] enabled
[    0.680428] netconsole: network logging started
[    0.680428] Linux video capture interface: v2.00
[    0.680431] Loading iSCSI transport class v2.0-869.
[    0.681088] iscsi: registered transport (tcp)
[    0.681301] Driver 'sd' needs updating - please use bus_type methods
[    0.681428] Driver 'sr' needs updating - please use bus_type methods
[    0.681428] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 14 (level, low) -> IRQ 14
[    0.682592] scsi0 : pata_atiixp
[    0.682781] scsi1 : pata_atiixp
[    0.684054] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
[    0.684054] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
[    0.838515] ata1.00: ATA-7: SAMSUNG HS122JC, GQ100-01, max UDMA/100
[    0.838515] ata1.00: 234441648 sectors, multi 8: LBA 
[    0.842147] ata1.00: configured for UDMA/100
[    0.992626] isa bounce pool size: 16 pages
[    0.995729] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HS122JC  GQ10 PQ: 0 ANSI: 5
[    0.996649] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    0.996649] sd 0:0:0:0: [sda] Write Protect is off
[    0.996649] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.996649] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.996860] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    0.996880] sd 0:0:0:0: [sda] Write Protect is off
[    0.996978] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.997013] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.997170]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.222303] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.222303] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.223303] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 23 (level, low) -> IRQ 23
[    1.274061] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  MMIO=[fe5fb800-fe5fbfff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    1.274061] ieee1394: raw1394: /dev/raw1394 device initialized
[    1.275160] eth1394: eth1: IPv4 over IEEE 1394 (fw-host0)
[    1.275160] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
[    1.275367] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    1.276163] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    1.279221] ehci_hcd 0000:00:13.5: debug port 1
[    1.279331] ehci_hcd 0000:00:13.5: irq 19, io mem 0xffa80000
[    1.286357] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.286631] usb usb1: configuration #1 chosen from 1 choice
[    1.286631] hub 1-0:1.0: USB hub found
[    1.286631] hub 1-0:1.0: 10 ports detected
[    1.387633] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.387633] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.387633] usb usb1: Product: EHCI Host Controller
[    1.387633] usb usb1: Manufacturer: Linux 2.6.26-gentoo ehci_hcd
[    1.387633] usb usb1: SerialNumber: 0000:00:13.5
[    1.387633] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.387633] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.387838] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.388738] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    1.388738] ohci_hcd 0000:00:13.0: irq 16, io mem 0xffb00000
[    1.443631] usb usb2: configuration #1 chosen from 1 choice
[    1.443631] hub 2-0:1.0: USB hub found
[    1.443631] hub 2-0:1.0: 2 ports detected
[    1.545130] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.545130] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.545130] usb usb2: Product: OHCI Host Controller
[    1.545130] usb usb2: Manufacturer: Linux 2.6.26-gentoo ohci_hcd
[    1.545130] usb usb2: SerialNumber: 0000:00:13.0
[    1.545130] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
[    1.545130] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.546186] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    1.546186] ohci_hcd 0000:00:13.1: irq 17, io mem 0xffb01000
[    1.601128] usb usb3: configuration #1 chosen from 1 choice
[    1.601128] hub 3-0:1.0: USB hub found
[    1.601128] hub 3-0:1.0: 2 ports detected
[    1.703061] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.703061] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.703061] usb usb3: Product: OHCI Host Controller
[    1.703061] usb usb3: Manufacturer: Linux 2.6.26-gentoo ohci_hcd
[    1.703061] usb usb3: SerialNumber: 0000:00:13.1
[    1.703061] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 20 (level, low) -> IRQ 20
[    1.703061] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    1.704117] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    1.704117] ohci_hcd 0000:00:13.2: irq 20, io mem 0xffb02000
[    1.759058] usb usb4: configuration #1 chosen from 1 choice
[    1.759058] hub 4-0:1.0: USB hub found
[    1.759058] hub 4-0:1.0: 2 ports detected
[    1.802550] hub 1-0:1.0: unable to enumerate USB device on port 6
[    1.860794] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.860794] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.860794] usb usb4: Product: OHCI Host Controller
[    1.860794] usb usb4: Manufacturer: Linux 2.6.26-gentoo ohci_hcd
[    1.860794] usb usb4: SerialNumber: 0000:00:13.2
[    1.860794] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
[    1.860794] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    1.861853] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    1.862020] ohci_hcd 0000:00:13.3: irq 17, io mem 0xffb03000
[    1.917035] usb usb5: configuration #1 chosen from 1 choice
[    1.917035] hub 5-0:1.0: USB hub found
[    1.917035] hub 5-0:1.0: 2 ports detected
[    2.015262] usb 1-9: new high speed USB device using ehci_hcd and address 4
[    2.018533] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.018533] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.018533] usb usb5: Product: OHCI Host Controller
[    2.018533] usb usb5: Manufacturer: Linux 2.6.26-gentoo ohci_hcd
[    2.018533] usb usb5: SerialNumber: 0000:00:13.3
[    2.018533] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 20 (level, low) -> IRQ 20
[    2.018533] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    2.019584] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    2.019584] ohci_hcd 0000:00:13.4: irq 20, io mem 0xffb04000
[    2.075017] usb usb6: configuration #1 chosen from 1 choice
[    2.075017] hub 6-0:1.0: USB hub found
[    2.075017] hub 6-0:1.0: 2 ports detected
[    2.131083] usb 1-9: configuration #1 chosen from 1 choice
[    2.131083] hub 1-9:1.0: USB hub found
[    2.131083] hub 1-9:1.0: 6 ports detected
[    2.177085] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.177085] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.177085] usb usb6: Product: OHCI Host Controller
[    2.177085] usb usb6: Manufacturer: Linux 2.6.26-gentoo ohci_hcd
[    2.177085] usb usb6: SerialNumber: 0000:00:13.4
[    2.177085] USB Universal Host Controller Interface driver v3.0
[    2.178085] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.181924] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.182024] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.182342] mice: PS/2 mouse device common for all mice
[    2.200443] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.200443] rtc0: alarms up to one month, y3k
[    2.200443] i2c /dev entries driver
[    2.203776] input: AT Translated Set 2 keyboard as /class/input/input5
[    2.210776] coretemp coretemp.0: Using relative temperature scale!
[    2.210776] coretemp coretemp.1: Using relative temperature scale!
[    2.210776] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    2.211925] cpuidle: using governor ladder
[    2.212800] cpuidle: using governor menu
[    2.213665] Marking TSC unstable due to TSC halts in idle
[    2.213914] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    2.214103] ALSA device list:
[    2.214200]   No soundcards found.
[    2.215185] NET: Registered protocol family 26
[    2.215185] TCP cubic registered
[    2.216251] NET: Registered protocol family 10
[    2.216885] lo: Disabled Privacy Extensions
[    2.217617] IPv6 over IPv4 tunneling driver
[    2.218572] sit0: Disabled Privacy Extensions
[    2.218572] NET: Registered protocol family 17
[    2.218602] Bluetooth: L2CAP ver 2.9
[    2.218698] Bluetooth: L2CAP socket layer initialized
[    2.218800] Bluetooth: SCO (Voice Link) ver 0.5
[    2.219217] Bluetooth: SCO socket layer initialized
[    2.219265] RPC: Registered udp transport module.
[    2.219265] RPC: Registered tcp transport module.
[    2.219324] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.219424] All bugs added by David S. Miller <davem@redhat.com>
[    2.221729] rtc_cmos 00:03: setting system clock to 2008-08-13 22:45:59 UTC (1218667559)
[    2.221743] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.235609] usb 1-9: New USB device found, idVendor=413c, idProduct=a005
[    2.235671] usb 1-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.513884] kjournald starting.  Commit interval 5 seconds
[    2.514628] EXT3-fs: mounted filesystem with ordered data mode.
[    2.514628] VFS: Mounted root (ext3 filesystem) readonly.
[    2.514628] Freeing unused kernel memory: 304k freed
[    2.518923] Clocksource tsc unstable (delta = -174160168 ns)
[    2.750908] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[474fc0000ac73c70]
[    2.771694] usb 3-2: new full speed USB device using ohci_hcd and address 2
[    2.915213] usb 3-2: configuration #1 chosen from 1 choice
[    2.919856] usb 3-2: New USB device found, idVendor=1b96, idProduct=0001
[    2.919856] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.146423] usb 4-2: new full speed USB device using ohci_hcd and address 2
[    3.296840] usb 4-2: configuration #1 chosen from 1 choice
[    3.302161] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
[    3.302161] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.302161] usb 4-2: Product: Biometric Coprocessor
[    3.302161] usb 4-2: Manufacturer: STMicroelectronics
[    3.481982] usb 1-9.1: new high speed USB device using ehci_hcd and address 6
[    3.569660] usb 1-9.1: configuration #1 chosen from 1 choice
[    3.573712] usb 1-9.1: New USB device found, idVendor=413c, idProduct=9001
[    3.573712] usb 1-9.1: New USB device strings: Mfr=56, Product=71, SerialNumber=0
[    3.573712] usb 1-9.1: Product: A04 
[    3.573712] usb 1-9.1: Manufacturer: Dell USB Drive
[    3.753818] usb 1-9.4: new full speed USB device using ehci_hcd and address 7
[    3.860162] usb 1-9.4: configuration #1 chosen from 1 choice
[    3.867697] usb 1-9.4: New USB device found, idVendor=1028, idProduct=0204
[    3.867697] usb 1-9.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.868344] usb 1-9.4: Product: TUB3410 Device
[    3.868458] usb 1-9.4: Manufacturer: Dell
[    3.868844] usb 1-9.4: SerialNumber: 00000001
[    7.333964] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    7.363360] input: USB HIDBP Mouse 1b96:0001 as /class/input/input6
[    7.377019] input: USB HIDBP Mouse 1b96:0001 as /class/input/input7
[    7.395027] usbcore: registered new interface driver usbmouse
[    7.395035] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[    7.410322] Initializing USB Mass Storage driver...
[    7.413181] scsi2 : SCSI emulation for USB Mass Storage devices
[    7.413181] usb-storage: device found at 6
[    7.413181] usb-storage: waiting for device to settle before scanning
[    7.413181] usbcore: registered new interface driver usb-storage
[    7.413181] USB Mass Storage support registered.
[    7.486447] usbcore: registered new interface driver hiddev
[    7.486447] usbcore: registered new interface driver usbhid
[    7.486447] usbhid: v2.6:USB HID core driver
[    7.972143] sdhci: Secure Digital Host Controller Interface driver
[    7.972148] sdhci: Copyright(c) Pierre Ossman
[    7.972201] sdhci: SDHCI controller found at 0000:03:01.3 [104c:803c] (rev 0)
[    7.972231] ACPI: PCI Interrupt 0000:03:01.3[A] -> GSI 22 (level, low) -> IRQ 22
[    7.972677] Registered led device: mmc0
[    7.972717] mmc0: SDHCI at 0xfe5fb700 irq 22 DMA
[    8.296186] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[    8.329363] [fglrx]   vendor: 1002 device: 7942 count: 1
[    8.331363] [fglrx] ioport: bar 4, base 0xee00, size: 0x100
[    8.331363] [fglrx] Maximum main memory to use for locked dma buffers: 1638 MBytes.
[    8.333295] [fglrx:KCL_enable_pat] *ERROR* Pat entry 2 is already configured
[    8.333300] [fglrx] PAT is disabled!
[    8.333338] [fglrx] module loaded - fglrx 8.51.3 [Jul  3 2008] with 1 minors
[    8.367801] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[    8.398544] input: PC Speaker as /class/input/input8
[    8.655413] ACPI: PCI Interrupt 0000:00:14.2[B] -> GSI 17 (level, low) -> IRQ 17
[    9.530700] input: PS/2 Generic Mouse as /class/input/input9
[   10.822864] ndiswrapper version 1.53 loaded (smp=yes, preempt=no)
[   10.936539] ndiswrapper (link_pe_images:575): fixing KI_USER_SHARED_DATA address in the driver
[   10.943275] ndiswrapper: driver bcmwl5 (Broadcom,09/20/2007, 4.170.25.12) loaded
[   10.943876] ACPI: PCI Interrupt 0000:0b:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   10.944045] PCI: Setting latency timer of device 0000:0b:00.0 to 64
[   10.956043] ndiswrapper: using IRQ 18
[   11.158881] wlan0: ethernet device 00:1e:4c:04:ab:84 using NDIS driver: bcmwl5, version: 0x4aa190c, NDIS version: 0x501, vendor: 'NDIS Network Adapter', 14E4:4315.5.conf
[   11.159042] wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP with WPA, WPA2, WPA2PSK
[   11.173507] usbcore: registered new interface driver ndiswrapper
[   12.200988] EXT3 FS on sda6, internal journal
[   12.445736] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-U10N B100 PQ: 0 ANSI: 0
[   12.449599] sr0: scsi3-mmc drive: 62x/62x writer cd/rw xa/form2 cdda tray
[   12.449608] Uniform CD-ROM driver Revision: 3.20
[   12.449789] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   12.449883] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   12.451564] usb-storage: device scan complete
[   26.654561] Adding 2594456k swap on /dev/sda7.  Priority:-1 extents:1 across:2594456k
[   68.869143] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   71.883831] ADDRCONF(NETDEV_UP): eth0: link is not ready


