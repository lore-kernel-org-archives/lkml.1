Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbYA2WXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbYA2WXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYA2WXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:23:18 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:9206 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbYA2WXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:23:03 -0500
X-IronPort-AV: E=Sophos;i="4.25,271,1199692800"; 
   d="txt'?scan'208";a="10512705"
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: nai.xia@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, bzolnier@gmail.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
X-Message-Flag: Warning: May contain useful information
References: <200801292201.45718.nai.xia@gmail.com>
	<20080129.151353.48534987.k-ueda@ct.jp.nec.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 29 Jan 2008 14:22:53 -0800
In-Reply-To: <20080129.151353.48534987.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's message of "Tue, 29 Jan 2008 15:13:53 -0500 (EST)")
Message-ID: <adar6g0e0g2.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-OriginalArrivalTime: 29 Jan 2008 22:22:53.0403 (UTC) FILETIME=[7D855AB0:01C862C5]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi, I saw the same BUG from ide-cd on one of my systems.  I applied
the debugging patch to replace the BUG with blk_dump_rq_flags(), and I
got the output below (full boot log and .config attached to this
email).

Please let me know if there's anything else that would help debug the
problem.

[    4.072271] Uniform CD-ROM driver Revision: 3.20
[    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.100269]
[    4.100269] sector 1949759, nr/cnr 0/0
[    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
[    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.104269]
[    4.104269] sector 1949759, nr/cnr 0/0
[    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
[    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.112270]
[    4.112270] sector 1949759, nr/cnr 0/0
[    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
[    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.116270]
[    4.116270] sector 1949759, nr/cnr 0/0
[    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
[    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00


--=-=-=
Content-Disposition: inline; filename=bootlog.txt

[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0,38400n8       *
[    0.000000] BIOS-provided physical RAM map:                             *
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)    *
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)  *
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)  *
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009fff0000 (usable)    *
[    0.000000]  BIOS-e820: 000000009fff0000 - 000000009fffe000 (ACPI data) *
[    0.000000]  BIOS-e820: 000000009fffe000 - 00000000a0000000 (ACPI NVS)***
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000245000000 (usable)
[    0.000000] end_pfn_map = 2379776
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA190, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 9FFF0100, 0044 (r1 A M I  OEMXSDT  12000505 MSFT       97)
[    0.000000] ACPI: FACP 9FFF0290, 00F4 (r3 A M I  OEMFACP  12000505 MSFT       97)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or]
[    0.000000] ACPI: DSDT 9FFF0440, 5544 (r1  1HQC8 1HQC8003        3 INTL  2002026)
[    0.000000] ACPI: FACS 9FFFE000, 0040
[    0.000000] ACPI: APIC 9FFF0390, 00A4 (r1 A M I  OEMAPIC  12000505 MSFT       97)
[    0.000000] ACPI: OEMB 9FFFE040, 0071 (r1 A M I  AMI_OEM  12000505 MSFT       97)
[    0.000000] ACPI: SRAT 9FFF5990, 01A0 (r1 A M I  OEMSRAT  12000505 MSFT       97)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-a0000000
[    0.000000] SRAT: Node 2 PXM 2 145000000-1c5000000
[    0.000000] SRAT: Node 3 PXM 3 1c5000000-245000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-145000000
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 1 0000000080000000-0000000145000000
[    0.000000] Bootmem setup node 2 0000000145000000-00000001c5000000
[    0.000000] Bootmem setup node 3 00000001c5000000-0000000245000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2379776
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524288
[    0.000000]     1:   524288 ->   655344
[    0.000000]     1:  1048576 ->  1331200
[    0.000000]     2:  1331200 ->  1855488
[    0.000000]     3:  1855488 ->  2379776
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] Processor #4
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] Processor #5
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] Processor #6
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] Processor #7
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xbf9fe000] gsi_base[40])
[    0.000000] IOAPIC[1]: apic_id 13, address 0xbf9fe000, GSI 40-46
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xbf9ff000] gsi_base[47])
[    0.000000] IOAPIC[2]: apic_id 14, address 0xbf9ff000, GSI 47-53
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at a8000000 (gap: a0000000:5ec00000)
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35496 bytes of per cpu data
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 195285
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0,38400n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.004000] Marking TSC unstable due to TSCs unsynchronized
[    0.004000] time.c: Detected 2599.998 MHz processor.
[    0.009695] Console: colour VGA+ 80x25
[    0.009710] console [ttyS0] enabled
[    0.012003] Checking aperture...
[    0.016003] CPU 0: aperture @ 4000000 size 32 MB
[    0.020003] Aperture too small (32 MB)
[    0.032304] No AGP bridge found
[    0.036003] Your BIOS doesn't leave a aperture memory hole
[    0.040004] Please enable the IOMMU option in the BIOS setup
[    0.044004] This costs you 64 MB of RAM
[    0.092697] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.181787] Memory: 7745176k/9519104k available (2217k kernel code, 200612k reserved, )
[    0.184088] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=8, Nodes=4
[    0.268018] Calibrating delay using timer specific routine.. 5203.24 BogoMIPS (lpj=104)
[    0.277176] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.287250] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.291037] Mount-cache hash table entries: 256
[    0.292332] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.296020] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.300021] CPU 0/0 -> Node 0
[    0.304021] CPU: Physical Processor ID: 0
[    0.308020] CPU: Processor Core ID: 0
[    0.312038] SMP alternatives: switching to UP code
[    0.316023] ACPI: Core revision 20070126
[    0.369888] Using local APIC timer interrupts.
[    0.376026] Detected 12.500 MHz APIC timer.
[    0.380123] SMP alternatives: switching to SMP code
[    0.384044] Booting processor 1/8 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.480310] SMP alternatives: switching to SMP code
[    0.484049] Booting processor 2/8 APIC 0x2
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5200.12 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 2/2 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.580297] SMP alternatives: switching to SMP code
[    0.584058] Booting processor 3/8 APIC 0x3
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 3/3 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.680241] SMP alternatives: switching to SMP code
[    0.684063] Booting processor 4/8 APIC 0x4
[    0.004000] Initializing CPU#4
[    0.004000] Calibrating delay using timer specific routine.. 5200.10 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 4/4 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.780320] SMP alternatives: switching to SMP code
[    0.784069] Booting processor 5/8 APIC 0x5
[    0.004000] Initializing CPU#5
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 5/5 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.880324] SMP alternatives: switching to SMP code
[    0.884076] Booting processor 6/8 APIC 0x6
[    0.004000] Initializing CPU#6
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 6/6 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.980298] SMP alternatives: switching to SMP code
[    0.984081] Booting processor 7/8 APIC 0x7
[    0.004000] Initializing CPU#7
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 7/7 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    1.080296] Brought up 8 CPUs
[    1.084850] net_namespace: 416 bytes
[    1.088255] NET: Registered protocol family 16
[    1.092323] ACPI: bus type pci registered
[    1.096075] PCI: Using configuration type 1
[    1.110169] ACPI: Interpreter enabled
[    1.112070] ACPI: (supports S0 S5)
[    1.117702] ACPI: Using IOAPIC for interrupt routing
[    1.130141] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.132594] PCI: Transparent bridge - 0000:00:09.0
[    1.146516] ACPI: PCI Root Bridge [PCIB] (0000:04)
[    1.149388] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *9
[    1.160213] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *9
[    1.170675] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    1.178131] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *9
[    1.188757] ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *0, disabled.
[    1.200786] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *5
[    1.212181] ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0, disabled.
[    1.224789] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
[    1.234685] ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *0, disabled.
[    1.240765] ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
[    1.252083] ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
[    1.264792] ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
[    1.276796] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *11
[    1.286950] ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *9
[    1.292802] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
[    1.302931] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.304123] pnp: PnP ACPI init
[    1.308088] ACPI: bus type pnp registered
[    1.318276] pnp: PnP ACPI: found 16 devices
[    1.320084] ACPI: ACPI bus type pnp unregistered
[    1.324300] SCSI subsystem initialized
[    1.332415] usbcore: registered new interface driver usbfs
[    1.336130] usbcore: registered new interface driver hub
[    1.340145] usbcore: registered new device driver usb
[    1.348135] PCI: Using ACPI for IRQ routing
[    1.352086] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a ret
[    1.372155] PCI-DMA: Disabling AGP.
[    1.377324] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    1.380093] PCI-DMA: using GART IOMMU.
[    1.384094] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.404124] system 00:09: ioport range 0x190-0x193 has been reserved
[    1.408090] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    1.412093] system 00:09: iomem range 0xffb80000-0xfffffffe could not be reserved
[    1.416090] system 00:09: iomem range 0xdfefc000-0xdfefcfff has been reserved
[    1.420090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.424090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.428090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.432091] system 00:09: iomem range 0xfefff000-0xfeffffff has been reserved
[    1.436100] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.440091] system 00:0a: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.444098] system 00:0c: ioport range 0x680-0x6ff has been reserved
[    1.448092] system 00:0c: ioport range 0x295-0x296 has been reserved
[    1.452092] system 00:0c: ioport range 0x778-0x77f has been reserved
[    1.456092] system 00:0c: ioport range 0xb78-0xb7f has been reserved
[    1.460092] system 00:0c: ioport range 0xf78-0xf7f has been reserved
[    1.464100] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    1.468098] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    1.472093] system 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    1.476093] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    1.480094] system 00:0e: iomem range 0x100000-0x9fffffff could not be reserved
[    1.484094] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    1.488791] PCI: Bridge: 0000:00:09.0
[    1.492093] Time: acpi_pm clocksource has been installed.
[    1.496265]   IO window: a000-afff
[    1.496272]   MEM window: bd200000-bf2fffff
[    1.496276]   PREFETCH window: disabled.
[    1.496282] PCI: Bridge: 0000:00:0d.0
[    1.496283]   IO window: disabled.
[    1.496285]   MEM window: bce00000-bd1fffff
[    1.496287]   PREFETCH window: disabled.
[    1.496290] PCI: Bridge: 0000:00:0e.0
[    1.496290]   IO window: disabled.
[    1.496293]   MEM window: bbd00000-bcdfffff
[    1.496295]   PREFETCH window: disabled.
[    1.496328] PCI: Bridge: 0000:04:01.0
[    1.496330]   IO window: f000-ffff
[    1.496333]   MEM window: bf600000-bf8fffff
[    1.496335]   PREFETCH window: bfa00000-dfefffff
[    1.496338] PCI: Bridge: 0000:04:02.0
[    1.496340]   IO window: e000-efff
[    1.496342]   MEM window: bf500000-bf5fffff
[    1.496344]   PREFETCH window: disabled.
[    1.496380] NET: Registered protocol family 2
[    1.756473] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.765129] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.777260] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.780773] TCP: Hash tables configured (established 524288 bind 65536)
[    1.784115] TCP reno registered
[    1.268079] Total HugeTLB memory allocated, 0
[    1.274603] VFS: Disk quotas dquot_6.5.1
[    1.276178] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.280803] io scheduler noop registered
[    1.284083] io scheduler anticipatory registered (default)
[    1.288083] io scheduler deadline registered
[    1.292224] io scheduler cfq registered
[    1.309067] PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
[    1.312100] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.316089] PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
[    1.320090] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.868117] assign_interrupt_mode Found MSI capability
[    1.868268] assign_interrupt_mode Found MSI capability
[    1.555860] Real Time Clock Driver v1.12ac
[    1.556258] Linux agpgart interface v0.102
[    1.560102] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.564245] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.568225] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.576467] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.580331] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.585578] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    1.588111] console [netcon0] enabled
[    0.000000] Linux version 2.6.24 (rdreier@roland-microway-4) (gcc version 4.2.3 2008018
[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0,38400n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009fff0000 (usable)
[    0.000000]  BIOS-e820: 000000009fff0000 - 000000009fffe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000009fffe000 - 00000000a0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000245000000 (usable)
[    0.000000] end_pfn_map = 2379776
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA190, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 9FFF0100, 0044 (r1 A M I  OEMXSDT  12000505 MSFT       97)
[    0.000000] ACPI: FACP 9FFF0290, 00F4 (r3 A M I  OEMFACP  12000505 MSFT       97)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or]
[    0.000000] ACPI: DSDT 9FFF0440, 5544 (r1  1HQC8 1HQC8003        3 INTL  2002026)
[    0.000000] ACPI: FACS 9FFFE000, 0040
[    0.000000] ACPI: APIC 9FFF0390, 00A4 (r1 A M I  OEMAPIC  12000505 MSFT       97)
[    0.000000] ACPI: OEMB 9FFFE040, 0071 (r1 A M I  AMI_OEM  12000505 MSFT       97)
[    0.000000] ACPI: SRAT 9FFF5990, 01A0 (r1 A M I  OEMSRAT  12000505 MSFT       97)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-a0000000
[    0.000000] SRAT: Node 2 PXM 2 145000000-1c5000000
[    0.000000] SRAT: Node 3 PXM 3 1c5000000-245000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-145000000
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 1 0000000080000000-0000000145000000
[    0.000000] Bootmem setup node 2 0000000145000000-00000001c5000000
[    0.000000] Bootmem setup node 3 00000001c5000000-0000000245000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2379776
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524288
[    0.000000]     1:   524288 ->   655344
[    0.000000]     1:  1048576 ->  1331200
[    0.000000]     2:  1331200 ->  1855488
[    0.000000]     3:  1855488 ->  2379776
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] Processor #4
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] Processor #5
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] Processor #6
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] Processor #7
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xbf9fe000] gsi_base[40])
[    0.000000] IOAPIC[1]: apic_id 13, address 0xbf9fe000, GSI 40-46
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xbf9ff000] gsi_base[47])
[    0.000000] IOAPIC[2]: apic_id 14, address 0xbf9ff000, GSI 47-53
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at a8000000 (gap: a0000000:5ec00000)
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35496 bytes of per cpu data
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 195285
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0,38400n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.004000] Marking TSC unstable due to TSCs unsynchronized
[    0.004000] time.c: Detected 2599.998 MHz processor.
[    0.009695] Console: colour VGA+ 80x25
[    0.009710] console [ttyS0] enabled
[    0.012003] Checking aperture...
[    0.016003] CPU 0: aperture @ 4000000 size 32 MB
[    0.020003] Aperture too small (32 MB)
[    0.032304] No AGP bridge found
[    0.036003] Your BIOS doesn't leave a aperture memory hole
[    0.040004] Please enable the IOMMU option in the BIOS setup
[    0.044004] This costs you 64 MB of RAM
[    0.092697] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.181787] Memory: 7745176k/9519104k available (2217k kernel code, 200612k reserved, )
[    0.184088] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=8, Nodes=4
[    0.268018] Calibrating delay using timer specific routine.. 5203.24 BogoMIPS (lpj=104)
[    0.277176] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.287250] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.291037] Mount-cache hash table entries: 256
[    0.292332] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.296020] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.300021] CPU 0/0 -> Node 0
[    0.304021] CPU: Physical Processor ID: 0
[    0.308020] CPU: Processor Core ID: 0
[    0.312038] SMP alternatives: switching to UP code
[    0.316023] ACPI: Core revision 20070126
[    0.369888] Using local APIC timer interrupts.
[    0.376026] Detected 12.500 MHz APIC timer.
[    0.380123] SMP alternatives: switching to SMP code
[    0.384044] Booting processor 1/8 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.480310] SMP alternatives: switching to SMP code
[    0.484049] Booting processor 2/8 APIC 0x2
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5200.12 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 2/2 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.580297] SMP alternatives: switching to SMP code
[    0.584058] Booting processor 3/8 APIC 0x3
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 3/3 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.680241] SMP alternatives: switching to SMP code
[    0.684063] Booting processor 4/8 APIC 0x4
[    0.004000] Initializing CPU#4
[    0.004000] Calibrating delay using timer specific routine.. 5200.10 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 4/4 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.780320] SMP alternatives: switching to SMP code
[    0.784069] Booting processor 5/8 APIC 0x5
[    0.004000] Initializing CPU#5
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 5/5 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.880324] SMP alternatives: switching to SMP code
[    0.884076] Booting processor 6/8 APIC 0x6
[    0.004000] Initializing CPU#6
[    0.004000] Calibrating delay using timer specific routine.. 5200.13 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 6/6 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    0.980298] SMP alternatives: switching to SMP code
[    0.984081] Booting processor 7/8 APIC 0x7
[    0.004000] Initializing CPU#7
[    0.004000] Calibrating delay using timer specific routine.. 5200.11 BogoMIPS (lpj=104)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 7/7 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Dual Core AMD Opteron(tm) Processor 885 stepping 02
[    1.080296] Brought up 8 CPUs
[    1.084850] net_namespace: 416 bytes
[    1.088255] NET: Registered protocol family 16
[    1.092323] ACPI: bus type pci registered
[    1.096075] PCI: Using configuration type 1
[    1.110169] ACPI: Interpreter enabled
[    1.112070] ACPI: (supports S0 S5)
[    1.117702] ACPI: Using IOAPIC for interrupt routing
[    1.130141] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.132594] PCI: Transparent bridge - 0000:00:09.0
[    1.146516] ACPI: PCI Root Bridge [PCIB] (0000:04)
[    1.149388] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *9
[    1.160213] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *9
[    1.170675] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    1.178131] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *9
[    1.188757] ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *0, disabled.
[    1.200786] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *5
[    1.212181] ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0, disabled.
[    1.224789] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *9
[    1.234685] ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *0, disabled.
[    1.240765] ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
[    1.252083] ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
[    1.264792] ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
[    1.276796] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *11
[    1.286950] ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *9
[    1.292802] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
[    1.302931] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.304123] pnp: PnP ACPI init
[    1.308088] ACPI: bus type pnp registered
[    1.318276] pnp: PnP ACPI: found 16 devices
[    1.320084] ACPI: ACPI bus type pnp unregistered
[    1.324300] SCSI subsystem initialized
[    1.332415] usbcore: registered new interface driver usbfs
[    1.336130] usbcore: registered new interface driver hub
[    1.340145] usbcore: registered new device driver usb
[    1.348135] PCI: Using ACPI for IRQ routing
[    1.352086] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a ret
[    1.372155] PCI-DMA: Disabling AGP.
[    1.377324] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    1.380093] PCI-DMA: using GART IOMMU.
[    1.384094] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.404124] system 00:09: ioport range 0x190-0x193 has been reserved
[    1.408090] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    1.412093] system 00:09: iomem range 0xffb80000-0xfffffffe could not be reserved
[    1.416090] system 00:09: iomem range 0xdfefc000-0xdfefcfff has been reserved
[    1.420090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.424090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.428090] system 00:09: iomem range 0x0-0x0 could not be reserved
[    1.432091] system 00:09: iomem range 0xfefff000-0xfeffffff has been reserved
[    1.436100] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.440091] system 00:0a: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.444098] system 00:0c: ioport range 0x680-0x6ff has been reserved
[    1.448092] system 00:0c: ioport range 0x295-0x296 has been reserved
[    1.452092] system 00:0c: ioport range 0x778-0x77f has been reserved
[    1.456092] system 00:0c: ioport range 0xb78-0xb7f has been reserved
[    1.460092] system 00:0c: ioport range 0xf78-0xf7f has been reserved
[    1.464100] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    1.468098] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    1.472093] system 00:0e: iomem range 0xc0000-0xdffff has been reserved
[    1.476093] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    1.480094] system 00:0e: iomem range 0x100000-0x9fffffff could not be reserved
[    1.484094] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    1.488791] PCI: Bridge: 0000:00:09.0
[    1.492093] Time: acpi_pm clocksource has been installed.
[    1.496265]   IO window: a000-afff
[    1.496272]   MEM window: bd200000-bf2fffff
[    1.496276]   PREFETCH window: disabled.
[    1.496282] PCI: Bridge: 0000:00:0d.0
[    1.496283]   IO window: disabled.
[    1.496285]   MEM window: bce00000-bd1fffff
[    1.496287]   PREFETCH window: disabled.
[    1.496290] PCI: Bridge: 0000:00:0e.0
[    1.496290]   IO window: disabled.
[    1.496293]   MEM window: bbd00000-bcdfffff
[    1.496295]   PREFETCH window: disabled.
[    1.496328] PCI: Bridge: 0000:04:01.0
[    1.496330]   IO window: f000-ffff
[    1.496333]   MEM window: bf600000-bf8fffff
[    1.496335]   PREFETCH window: bfa00000-dfefffff
[    1.496338] PCI: Bridge: 0000:04:02.0
[    1.496340]   IO window: e000-efff
[    1.496342]   MEM window: bf500000-bf5fffff
[    1.496344]   PREFETCH window: disabled.
[    1.496380] NET: Registered protocol family 2
[    1.756473] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.765129] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.777260] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.780773] TCP: Hash tables configured (established 524288 bind 65536)
[    1.784115] TCP reno registered
[    1.268079] Total HugeTLB memory allocated, 0
[    1.274603] VFS: Disk quotas dquot_6.5.1
[    1.276178] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.280803] io scheduler noop registered
[    1.284083] io scheduler anticipatory registered (default)
[    1.288083] io scheduler deadline registered
[    1.292224] io scheduler cfq registered
[    1.309067] PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
[    1.312100] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.316089] PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
[    1.320090] PCI: Found enabled HT MSI Mapping on 0000:00:00.0
[    1.868117] assign_interrupt_mode Found MSI capability
[    1.868268] assign_interrupt_mode Found MSI capability
[    1.555860] Real Time Clock Driver v1.12ac
[    1.556258] Linux agpgart interface v0.102
[    1.560102] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.564245] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.568225] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.576467] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.580331] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.585578] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    1.588111] console [netcon0] enabled
[    1.596120] netconsole: network logging started
[    1.600158] Driver 'sd' needs updating - please use bus_type methods
[    6.730264] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 22
[    6.732430] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 22 (level, low) 2
[    6.744424] sata_nv 0000:00:07.0: Using ADMA mode
[    6.752556] scsi0 : sata_nv
[    6.756606] scsi1 : sata_nv
[    6.760601] ata1: SATA max UDMA/133 cmd 0xdc00 ctl 0xd800 bmdma 0xcc00 irq 22
[    6.764426] ata2: SATA max UDMA/133 cmd 0xd400 ctl 0xd000 bmdma 0xcc08 irq 22
[    2.772189] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.344084] ata1.00: ATA-7: ST3808110AS, 3.AAD, max UDMA/133
[    1.344090] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.364085] ata1.00: configured for UDMA/133
[    2.904189] ata2: SATA link down (SStatus 0 SControl 300)
[    6.788424] scsi 0:0:0:0: Direct-Access     ATA      ST3808110AS      3.AA PQ: 0 ANSI:5
[    6.788433] ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw seg1
[    6.792600] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    6.796438] sd 0:0:0:0: [sda] Write Protect is off
[    6.800447] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppoA
[    6.804477] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    6.808436] sd 0:0:0:0: [sda] Write Protect is off
[    6.812446] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppoA
[    6.816430]  sda: sda1 sda2 < sda5 sda6 >
[    6.829967] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.836693] ACPI: PCI Interrupt Link [LTIE] enabled at IRQ 21
[    6.840437] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LTIE] -> GSI 21 (level, low) 1
[    6.852431] sata_nv 0000:00:08.0: Using ADMA mode
[    6.856838] scsi2 : sata_nv
[    6.860603] scsi3 : sata_nv
[    6.864612] ata3: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 21
[    6.868433] ata4: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 21
[    3.012202] ata3: SATA link down (SStatus 0 SControl 300)
[    3.072199] ata4: SATA link down (SStatus 0 SControl 300)
[    6.896431] PNP: PS/2 Controller [PNP0f12:PS2M] at 0x60,0x64 irq 12
[    6.896435] PNP: PS/2 controller doesn't have KBD irq; using default 1
[    1.392087] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.392100] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.396261] mice: PS/2 mouse device common for all mice
[    1.400526] TCP bic registered
[    1.404115] NET: Registered protocol family 1
[    1.408106] NET: Registered protocol family 17
[    3.128196] kjournald starting.  Commit interval 5 seconds
[    1.456091] EXT3-fs: mounted filesystem with ordered data mode.
[    1.456091] VFS: Mounted root (ext3 filesystem) readonly.
[    1.456091] Freeing unused kernel memory: 288k freed
Mount failed for selinuxfs on /selinux:  No such file or directory
INIT: version 2.86 booting
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[    2.774795] Uniform Multi-Platform E-IDE driv2
[    2.776181] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.803340] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.896182] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[    2.896194] shpchp: shpc_init: cannot reserve MMIO region
[    2.900199] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[    2.904186] shpchp: shpc_init: cannot reserve MMIO region
[    2.908208] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.974838] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
[    7.976512] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 20 (level, low) 0
[    7.989002] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    7.992890] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[    7.996518] ohci_hcd 0000:00:02.0: irq 20, io mem 0xbf3fd000
[    4.545473] input: Power Button (FF) as /devices/virtual/input/input0
[    4.576304] ACPI: Power Button (FF) [PWRF]
[    8.062643] usb usb1: configuration #1 chosen from 1 choice
[    8.062668] hub 1-0:1.0: USB hub found
[    8.062678] hub 1-0:1.0: 10 ports detected
[    3.167516] input: Power Button (CM) as /devices/virtual/input/input1
[    3.197423] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    3.200205] Copyright (c) 1999-2006 Intel Corporation.
[    3.204266] ACPI: PCI Interrupt 0000:05:03.0[A] -> GSI 47 (level, low) -> IRQ 47
[    8.208567] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[    8.212557] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[    3.486222] e1000: 0000:05:03.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:57:44:1e
[    8.480354] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    8.480579] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 22 (level, low) 2
[    3.529625] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    3.529662] ACPI: PCI Interrupt 0000:05:03.1[B] -> GSI 48 (level, low) -> IRQ 48
[    8.492930] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.496631] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
[    8.500562] ehci_hcd 0000:00:02.1: debug port 1
[    8.504542] ehci_hcd 0000:00:02.1: irq 22, io mem 0xbf3e0000
[    8.524541] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.528627] usb usb2: configuration #1 chosen from 1 choice
[    8.532557] hub 2-0:1.0: USB hub found
[    8.536542] hub 2-0:1.0: 10 ports detected
[    3.798363] e1000: 0000:05:03.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:30:48:57:44:1f
[    8.648736] NFORCE-CK804: IDE controller (0x10de:0x0053 rev 0xf2) at  PCI slot 0000:000
[    8.652561] NFORCE-CK804: not 100% native mode: will probe irqs later
[    3.841669] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    8.656556] NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
[    8.660549]     ide0: BM-DMA at 0x3000-0x3007, BIOS settings: hda:DMA, hdb:DMA
[    8.669112]     ide1: BM-DMA at 0x3008-0x300f, BIOS settings: hdc:DMA, hdd:DMA
[    3.956315] ACPI: Power Button (CM) [PWRB]
[    8.836631] hda: MATSHITADVD-ROM SR-8178, ATAPI CD/DVD-ROM drive
[    8.850945] hda: UDMA/66 mode selected
[    8.904612] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.915418] ib_ipath 0000:02:00.0: infinipath0: Board SN 1256100059 did not pass functg
[    4.062245] hda: ATAPI 24X DVD-ROM drive, 256kB Cache
[    4.072271] Uniform CD-ROM driver Revision: 3.20
[    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.100269]
[    4.100269] sector 1949759, nr/cnr 0/0
[    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
[    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.104269]
[    4.104269] sector 1949759, nr/cnr 0/0
[    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
[    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.112270]
[    4.112270] sector 1949759, nr/cnr 0/0
[    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
[    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
[    4.116270]
[    4.116270] sector 1949759, nr/cnr 0/0
[    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
[    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00

--=-=-=
Content-Disposition: inline; filename=config.txt

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24
# Tue Jan 29 13:45:54 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_QUICKLIST is not set
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_CLASSIC_RCU=y
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_VSMP is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_RCU_TRACE is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_OUT_OF_LINE_PFN_TO_PAGE=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=m
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_NET_PCI is not set
# CONFIG_B44 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=m
CONFIG_BNX2=m
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T1_NAPI=y
CONFIG_CHELSIO_T3=m
# CONFIG_IXGBE is not set
CONFIG_IXGB=m
CONFIG_IXGB_NAPI=y
CONFIG_S2IO=m
CONFIG_S2IO_NAPI=y
CONFIG_MYRI10GE=m
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
CONFIG_TR=y
CONFIG_IBMOL=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_PROSAVAGE=m
CONFIG_I2C_SAVAGE4=m
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
# CONFIG_PCF8575 is not set
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_TPS65010 is not set
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_AIRPRIME=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=m
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m

#
# USB DSL modem support
#

#
# USB Gadget Support
#
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=m
# CONFIG_USB_GADGET_PXA2XX is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FILE_STORAGE=m
# CONFIG_USB_FILE_STORAGE_TEST is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
CONFIG_EXT4DEV_FS_XATTR=y
CONFIG_EXT4DEV_FS_POSIX_ACL=y
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_NOLOCK=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_KPROBES=y
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=m
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--=-=-=--
