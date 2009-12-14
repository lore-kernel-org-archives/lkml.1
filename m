Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZLNTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZLNTeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZLNTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:34:24 -0500
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:35554
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZLNTeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:34:22 -0500
X-Trace: 223336495/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.32.1; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAAAiJktTQwwf/2dsb2JhbACBS8lmjTiEKwSBYg
X-IronPort-AV: E=Sophos;i="4.47,396,1257120000"; 
   d="scan'208";a="223336495"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Are these MTRR settings correct?
Date: Mon, 14 Dec 2009 19:34:10 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32.1; KDE/4.3.1; x86_64; ; )
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200912130807.44905.tvrtko@ursulin.net> <200912141119.55068.tvrtko.ursulin@sophos.com> <4B2620C6.9050901@kernel.org>
In-Reply-To: <4B2620C6.9050901@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141934.10628.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 Dec 2009 11:25:58 Yinghai Lu wrote:
> >> something wrong, we should not check that with e820 or acpi resource in
> >> that case. please check
> >>
> >> {PATCH] x86/pci: don't check mmconf again if it is from MSR with amd
> >> faml0h
> >>
> >> for AMD Fam10h, it we read mmconf from MSR early, we should just trust
> >> it because we check it and correct it already.
> >>
> >> so skip the reject check there.
> >
> > [path snipped]
> >
> > Do you want me to test with this patch and that pci=.. option active and
> > post dmesg? Or without the pci=... option?
> 
> with this patch and pci=... and post dmesg...

Here you go:

[    0.000000] Linux version 2.6.32.1 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #4 SMP PREEMPT 
Mon Dec 14 19:21:12 GMT 2009
[    0.000000] Command line: pci=check_enable_amd_mmconf root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" 
resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" splash=silent quiet vga=0x31a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dff90000 (usable)
[    0.000000]  BIOS-e820: 00000000dff90000 - 00000000dffa8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dffa8000 - 00000000dffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdff90 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dff90000 (usable)
[    0.000000]  modified: 00000000dff90000 - 00000000dffa8000 (ACPI data)
[    0.000000]  modified: 00000000dffa8000 - 00000000dffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000dffd0000 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000dff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dff90000 page 4k
[    0.000000] kernel direct mapping tables up to dff90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 12000-14000
[    0.000000] RAMDISK: 379ea000 - 37fef66e
[    0.000000] ACPI: RSDP 00000000000fb4f0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dff90100 00054 (v01 112609 XSDT1132 20091126 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dff90290 000F4 (v03 112609 FACP1132 20091126 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20090903/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000dff90450 0D100 (v01  A1391 A1391001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000dffa8000 00040
[    0.000000] ACPI: APIC 00000000dff90390 0007C (v01 112609 APIC1132 20091126 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dff90410 0003C (v01 112609 OEMMCFG  20091126 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dffa8040 00072 (v01 112609 OEMB1132 20091126 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000dff9f450 00038 (v01 112609 OEMHPET  20091126 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000dff9f490 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000000013000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  0000000000038fff] pages 24
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000166476c]    TEXT DATA BSS ==> [0001000000 - 000166476c]
[    0.000000]   #3 [00379ea000 - 0037fef66e]          RAMDISK ==> [00379ea000 - 0037fef66e]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0001665000 - 0001665340]              BRK ==> [0001665000 - 0001665340]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000dff90
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048350
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3823 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 899016 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] 6 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dff90000 - 00000000dffa8000
[    0.000000] PM: Registered nosave memory: 00000000dffa8000 - 00000000dffd0000
[    0.000000] PM: Registered nosave memory: 00000000dffd0000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:1f700000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880028200000 s72856 r8192 d21352 u524288
[    0.000000] pcpu-alloc: s72856 r8192 d21352 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032119
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: pci=check_enable_amd_mmconf root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" 
resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" splash=silent quiet vga=0x31a
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 3ca6000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 4055132k/4718592k available (3519k kernel code, 525192k absent, 138268k reserved, 1987k data, 416k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3013.368 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6026.72 BogoMIPS (lpj=3013364)
[    0.003156] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004181] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004662] Mount-cache hash table entries: 256
[    0.004744] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004746] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004747] CPU 0/0x0 -> Node 0
[    0.004749] tseg: 0000000000
[    0.004755] CPU: Physical Processor ID: 0
[    0.004756] CPU: Processor Core ID: 0
[    0.004757] mce: CPU supports 6 MCE banks
[    0.004762] using C1E aware idle routine
[    0.004771] ACPI: Core revision 20090903
[    0.018034] Setting APIC routing to flat
[    0.018332] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.028409] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.028995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.002999] Initializing CPU#1
[    0.002999] Calibrating delay using timer specific routine.. 6026.84 BogoMIPS (lpj=3013420)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 1/0x1 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 1
[    0.099094] CPU1: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.099099] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.100006] System has AMD C1E enabled
[    0.100014] Switch to broadcast mode on CPU0
[    0.100000] Switch to broadcast mode on CPU1
[    0.101991] Booting processor 2 APIC 0x2 ip 0x6000
[    0.002999] Initializing CPU#2
[    0.002999] Calibrating delay using timer specific routine.. 6026.84 BogoMIPS (lpj=3013422)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 2/0x2 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 2
[    0.173020] CPU2: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.173025] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.173991] Switch to broadcast mode on CPU2
[    0.175980] Booting processor 3 APIC 0x3 ip 0x6000
[    0.002999] Initializing CPU#3
[    0.002999] Calibrating delay using timer specific routine.. 6026.80 BogoMIPS (lpj=3013402)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 3/0x3 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 3
[    0.247052] CPU3: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.247057] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.247985] Brought up 4 CPUs
[    0.247987] Total of 4 processors activated (24107.21 BogoMIPS).
[    0.247984] Switch to broadcast mode on CPU3
[    0.248981] devtmpfs: initialized
[    0.249116] Time: 19:29:29  Date: 12/14/09
[    0.249987] NET: Registered protocol family 16
[    0.250041] node 0 link 0: io port [1000, ffffff]
[    0.250043] TOM: 00000000e0000000 aka 3584M
[    0.250044] Fam 10h mmconf [e0000000, efffffff]
[    0.250046] node 0 link 0: mmio [a0000, bffff]
[    0.250048] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.250050] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.250051] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.250053] node 0 link 0: mmio [fea00000, ffefffff]
[    0.250054] TOM2: 0000000120000000 aka 4608M
[    0.250056] bus: [00,07] on node 0 link 0
[    0.250057] bus: 00 index 0 io port: [0, ffff]
[    0.250058] bus: 00 index 1 mmio: [a0000, bffff]
[    0.250060] bus: 00 index 2 mmio: [f0000000, ffffffff]
[    0.250061] bus: 00 index 3 mmio: [120000000, fcffffffff]
[    0.250068] ACPI: bus type pci registered
[    0.250091] PCI: Found AMD Family 10h NB with MMCONFIG support.
[    0.254793] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.254795] PCI: Using configuration type 1 for base access
[    0.255126] bio: create slab <bio-0> at 0
[    0.255618] ACPI: EC: Look up EC in DSDT
[    0.258244] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
[    0.258248] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
[    0.258336] ACPI: Executed 3 blocks of module-level executable AML code
[    0.273591] ACPI: Interpreter enabled
[    0.273595] ACPI: (supports S0 S1 S3 S4 S5)
[    0.273615] ACPI: Using IOAPIC for interrupt routing
[    0.280008] ACPI Warning: Incorrect checksum in table [OEMB] - 69, should be 64 (20090903/tbutils-314)
[    0.280101] ACPI: No dock devices found.
[    0.280238] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.280341] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.280344] pci 0000:00:07.0: PME# disabled
[    0.280372] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.280373] pci 0000:00:0a.0: PME# disabled
[    0.280416] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.280422] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.280428] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.280433] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.280439] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.280445] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.280491] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe7fe000-0xfe7fefff]
[    0.280539] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe7fd000-0xfe7fdfff]
[    0.280603] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe7ff800-0xfe7ff8ff]
[    0.280649] pci 0000:00:12.2: supports D1 D2
[    0.280650] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.280653] pci 0000:00:12.2: PME# disabled
[    0.280681] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe7fc000-0xfe7fcfff]
[    0.280729] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe7fb000-0xfe7fbfff]
[    0.280792] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.280838] pci 0000:00:13.2: supports D1 D2
[    0.280840] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.280843] pci 0000:00:13.2: PME# disabled
[    0.280946] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.280952] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.280965] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.280970] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.280976] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.281033] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe7f4000-0xfe7f7fff]
[    0.281071] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.281075] pci 0000:00:14.2: PME# disabled
[    0.281166] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe7fa000-0xfe7fafff]
[    0.281273] pci 0000:01:05.0: reg 10 32bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.281276] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.281279] pci 0000:01:05.0: reg 18 32bit mmio: [0xfe9f0000-0xfe9fffff]
[    0.281284] pci 0000:01:05.0: reg 24 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.281293] pci 0000:01:05.0: supports D1 D2
[    0.281306] pci 0000:01:05.1: reg 10 32bit mmio: [0xfe9e8000-0xfe9ebfff]
[    0.281321] pci 0000:01:05.1: supports D1 D2
[    0.281359] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.281361] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
[    0.281364] pci 0000:00:01.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.281400] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.281408] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.281428] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.281436] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.284026] pci 0000:00:07.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.284056] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.284069] pci 0000:03:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.284078] pci 0000:03:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.284084] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfebf0000-0xfebfffff]
[    0.284109] pci 0000:03:00.0: supports D1 D2
[    0.284111] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.284114] pci 0000:03:00.0: PME# disabled
[    0.286021] pci 0000:00:0a.0: bridge io port: [0xe000-0xefff]
[    0.286023] pci 0000:00:0a.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.286026] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.286079] pci 0000:00:14.4: transparent bridge
[    0.286098] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.286246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.286303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.286348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.286405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.290263] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.290355] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.290446] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.290537] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.290627] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.290718] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.290809] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.290899] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.290986] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.290988] vgaarb: loaded
[    0.291037] SCSI subsystem initialized
[    0.296960] libata version 3.00 loaded.
[    0.296980] usbcore: registered new interface driver usbfs
[    0.296980] usbcore: registered new interface driver hub
[    0.296981] usbcore: registered new device driver usb
[    0.296981] PCI: Using ACPI for IRQ routing
[    0.297085] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.297088] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.299973] hpet: hpet2 irq 24 for MSI
[    0.301958] Switching to clocksource tsc
[    0.304055] pnp: PnP ACPI init
[    0.304064] ACPI: bus type pnp registered
[    0.308354] pnp: PnP ACPI: found 14 devices
[    0.308356] ACPI: ACPI bus type pnp unregistered
[    0.308368] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.308370] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.308373] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.308375] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.308377] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.308379] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.308381] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.308382] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.308384] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.308386] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.308387] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.308389] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.308391] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.308392] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.308394] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.308396] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.308398] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.308399] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.308401] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.308403] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.308405] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.308407] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.308409] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.308411] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.308413] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.308415] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.308418] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.308420] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.308421] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.308423] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.308426] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.308429] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.308431] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.308433] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.308435] system 00:0d: iomem range 0x100000-0xdfffffff could not be reserved
[    0.308436] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.313137] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.313139] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.313141] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe9fffff
[    0.313143] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    0.313146] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.313148] pci 0000:00:07.0:   IO window: disabled
[    0.313150] pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
[    0.313151] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.313153] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
[    0.313155] pci 0000:00:0a.0:   IO window: 0xe000-0xefff
[    0.313157] pci 0000:00:0a.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.313159] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.313161] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.313162] pci 0000:00:14.4:   IO window: disabled
[    0.313166] pci 0000:00:14.4:   MEM window: disabled
[    0.313169] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.313180] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.313182] pci 0000:00:07.0: setting latency timer to 64
[    0.313187] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.313189] pci 0000:00:0a.0: setting latency timer to 64
[    0.313195] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.313197] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.313198] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.313200] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe9fffff]
[    0.313201] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
[    0.313203] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.313205] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.313206] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.313207] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.313209] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.313210] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.313230] NET: Registered protocol family 2
[    0.313327] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.313993] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.315914] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316166] TCP: Hash tables configured (established 524288 bind 65536)
[    0.316167] TCP reno registered
[    0.316220] NET: Registered protocol family 1
[    0.463911] pci 0000:01:05.0: Boot video device
[    0.463946] Unpacking initramfs...
[    0.548339] Freeing initrd memory: 6165k freed
[    0.549688] PCI-DMA: Disabling AGP.
[    0.549759] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.549760] PCI-DMA: using GART IOMMU.
[    0.549762] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.551600] Scanning for low memory corruption every 60 seconds
[    0.551880] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.552645] VFS: Disk quotas dquot_6.5.2
[    0.552680] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.552845] msgmni has been set to 7932
[    0.552910] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.552912] io scheduler noop registered
[    0.552913] io scheduler anticipatory registered
[    0.552914] io scheduler deadline registered
[    0.552933] io scheduler cfq registered (default)
[    0.553047] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    0.553052] pcieport 0000:00:07.0: setting latency timer to 64
[    0.553138] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.553142] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.553296] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90011100000, using 5120k, total 16384k
[    0.553298] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.553299] vesafb: scrolling: redraw
[    0.553301] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.560165] Console: switching to colour frame buffer device 160x64
[    0.566549] fb0: VESA VGA frame buffer device
[    0.567229] Non-volatile memory driver v1.3
[    0.567231] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.567323] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.567494] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.567628] ahci 0000:00:11.0: version 3.0
[    0.567644] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.567756] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.567758] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.568011] scsi0 : ahci
[    0.568071] scsi1 : ahci
[    0.568100] scsi2 : ahci
[    0.568130] scsi3 : ahci
[    0.568158] scsi4 : ahci
[    0.568188] scsi5 : ahci
[    0.568210] ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00 irq 22
[    0.568213] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    0.568215] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    0.568217] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    0.568220] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00 irq 22
[    0.568222] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80 irq 22
[    0.568283] Fixed MDIO Bus: probed
[    0.568288] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.568321] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.568331] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.568346] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.568374] ehci_hcd 0000:00:12.2: debug port 1
[    0.568389] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.574230] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.574243] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.574245] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.574246] usb usb1: Product: EHCI Host Controller
[    0.574248] usb usb1: Manufacturer: Linux 2.6.32.1 ehci_hcd
[    0.574249] usb usb1: SerialNumber: 0000:00:12.2
[    0.574287] usb usb1: configuration #1 chosen from 1 choice
[    0.574304] hub 1-0:1.0: USB hub found
[    0.574308] hub 1-0:1.0: 6 ports detected
[    0.574369] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.574377] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.574384] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.574405] ehci_hcd 0000:00:13.2: debug port 1
[    0.574419] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.580232] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.580239] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.580240] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.580241] usb usb2: Product: EHCI Host Controller
[    0.580243] usb usb2: Manufacturer: Linux 2.6.32.1 ehci_hcd
[    0.580244] usb usb2: SerialNumber: 0000:00:13.2
[    0.580270] usb usb2: configuration #1 chosen from 1 choice
[    0.580283] hub 2-0:1.0: USB hub found
[    0.580286] hub 2-0:1.0: 6 ports detected
[    0.580326] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.580349] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.580357] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.580362] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.580379] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.635252] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.635254] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.635255] usb usb3: Product: OHCI Host Controller
[    0.635256] usb usb3: Manufacturer: Linux 2.6.32.1 ohci_hcd
[    0.635257] usb usb3: SerialNumber: 0000:00:12.0
[    0.635285] usb usb3: configuration #1 chosen from 1 choice
[    0.635297] hub 3-0:1.0: USB hub found
[    0.635305] hub 3-0:1.0: 3 ports detected
[    0.635393] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.635400] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.635405] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.635417] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.690243] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.690244] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.690246] usb usb4: Product: OHCI Host Controller
[    0.690247] usb usb4: Manufacturer: Linux 2.6.32.1 ohci_hcd
[    0.690248] usb usb4: SerialNumber: 0000:00:12.1
[    0.690276] usb usb4: configuration #1 chosen from 1 choice
[    0.690287] hub 4-0:1.0: USB hub found
[    0.690293] hub 4-0:1.0: 3 ports detected
[    0.690380] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.690389] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.690394] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.690409] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.745254] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.745255] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.745257] usb usb5: Product: OHCI Host Controller
[    0.745258] usb usb5: Manufacturer: Linux 2.6.32.1 ohci_hcd
[    0.745259] usb usb5: SerialNumber: 0000:00:13.0
[    0.745287] usb usb5: configuration #1 chosen from 1 choice
[    0.745298] hub 5-0:1.0: USB hub found
[    0.745304] hub 5-0:1.0: 3 ports detected
[    0.745391] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.745398] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.745406] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.745418] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.800281] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.800282] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.800284] usb usb6: Product: OHCI Host Controller
[    0.800285] usb usb6: Manufacturer: Linux 2.6.32.1 ohci_hcd
[    0.800286] usb usb6: SerialNumber: 0000:00:13.1
[    0.800315] usb usb6: configuration #1 chosen from 1 choice
[    0.800326] hub 6-0:1.0: USB hub found
[    0.800332] hub 6-0:1.0: 3 ports detected
[    0.800422] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.800430] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.800436] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.800447] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    0.855252] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.855253] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.855255] usb usb7: Product: OHCI Host Controller
[    0.855256] usb usb7: Manufacturer: Linux 2.6.32.1 ohci_hcd
[    0.855257] usb usb7: SerialNumber: 0000:00:14.5
[    0.855283] usb usb7: configuration #1 chosen from 1 choice
[    0.855296] hub 7-0:1.0: USB hub found
[    0.855302] hub 7-0:1.0: 2 ports detected
[    0.855348] Initializing USB Mass Storage driver...
[    0.855371] usbcore: registered new interface driver usb-storage
[    0.855373] USB Mass Storage support registered.
[    0.855391] usbcore: registered new interface driver libusual
[    0.855396] usbcore: registered new interface driver ums-alauda
[    0.855402] usbcore: registered new interface driver ums-cypress
[    0.855411] usbcore: registered new interface driver ums-datafab
[    0.855416] usbcore: registered new interface driver ums-freecom
[    0.855422] usbcore: registered new interface driver ums-isd200
[    0.855427] usbcore: registered new interface driver ums-jumpshot
[    0.855432] usbcore: registered new interface driver ums-karma
[    0.855438] usbcore: registered new interface driver ums-onetouch
[    0.855444] usbcore: registered new interface driver ums-sddr09
[    0.855449] usbcore: registered new interface driver ums-sddr55
[    0.855455] usbcore: registered new interface driver ums-usbat
[    0.855478] PNP: No PS/2 controller found. Probing ports directly.
[    0.855805] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.855808] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.855851] mice: PS/2 mouse device common for all mice
[    0.855861] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.855879] rtc_cmos 00:03: RTC can wake from S4
[    0.855898] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.855919] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.855925] cpuidle: using governor ladder
[    0.855927] cpuidle: using governor menu
[    0.856063] usbcore: registered new interface driver hiddev
[    0.856069] usbcore: registered new interface driver usbhid
[    0.856070] usbhid: v2.6:USB HID core driver
[    0.856241] TCP cubic registered
[    0.856304] NET: Registered protocol family 10
[    0.856567] lo: Disabled Privacy Extensions
[    0.856785] PM: Checking image partition UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7"
[    0.873253] ata5: SATA link down (SStatus 0 SControl 300)
[    0.873931] ata4: SATA link down (SStatus 0 SControl 300)
[    0.873952] ata6: SATA link down (SStatus 0 SControl 300)
[    0.873968] ata1: SATA link down (SStatus 0 SControl 300)
[    0.877914] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    0.996715] usb 1-4: New USB device found, idVendor=05e3, idProduct=0606
[    0.996717] usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    0.996718] usb 1-4: Product: USB2.0 Hub
[    0.996748] usb 1-4: configuration #1 chosen from 1 choice
[    0.997175] hub 1-4:1.0: USB hub found
[    0.997712] hub 1-4:1.0: 4 ports detected
[    1.026251] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.026920] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.027949] ata2.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.027951] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.028652] ata3.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.028654] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.030018] ata2.00: configured for UDMA/133
[    1.030707] ata3.00: configured for UDMA/133
[    1.041972] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.042067] sd 1:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.042086] sd 1:0:0:0: [sda] Write Protect is off
[    1.042088] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.042098] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.042120] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.042173]  sda:
[    1.042187] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.042212] sd 2:0:0:0: [sdb] Write Protect is off
[    1.042213] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.042224] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.042286]  sdb: sda1 sda2
[    1.106085] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.113593]  sdb1 sdb2
[    1.113690] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.113693] PM: Resume from disk failed.
[    1.113696] registered taskstats version 1
[    1.113939]   Magic number: 5:32:496
[    1.113986] rtc_cmos 00:03: setting system clock to 2009-12-14 19:29:30 UTC (1260818970)
[    1.114012] Freeing unused kernel memory: 416k freed
[    1.114087] Write protecting the kernel read-only data: 5040k
[    1.135601] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.135623] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.135676] scsi6 : pata_atiixp
[    1.135715] scsi7 : pata_atiixp
[    1.136746] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.136747] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.290682] ata7.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
[    1.296626] ata7.00: configured for UDMA/33
[    1.298415] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
[    1.321244] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.453823] processor LNXCPU:00: registered as cooling_device0
[    1.454229] processor LNXCPU:01: registered as cooling_device1
[    1.454566] processor LNXCPU:02: registered as cooling_device2
[    1.454907] processor LNXCPU:03: registered as cooling_device3
[    1.458282] udev: starting version 146
[    1.466274] usb 4-2: New USB device found, idVendor=046a, idProduct=0021
[    1.466276] usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.466331] usb 4-2: configuration #1 chosen from 1 choice
[    1.474462] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input0
[    1.474510] generic-usb 0003:046A:0021.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-2/input0
[    1.484331] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input1
[    1.484392] generic-usb 0003:046A:0021.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-2/input1
[    1.711243] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.864595] usb 4-3: New USB device found, idVendor=046d, idProduct=c521
[    1.864597] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.864599] usb 4-3: Product: USB Receiver
[    1.864600] usb 4-3: Manufacturer: Logitech
[    1.864696] usb 4-3: configuration #1 chosen from 1 choice
[    1.876736] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
[    1.876825] generic-usb 0003:046D:C521.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    1.888648] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
[    1.888706] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:12.1-3/input1
[    1.953236] usb 1-4.1: new high speed USB device using ehci_hcd and address 5
[    2.033217] usb 1-4.1: New USB device found, idVendor=058f, idProduct=6362
[    2.033219] usb 1-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.033220] usb 1-4.1: Product: Mass Storage Device
[    2.033221] usb 1-4.1: Manufacturer: Generic
[    2.033223] usb 1-4.1: SerialNumber: 058F312D81B
[    2.033271] usb 1-4.1: configuration #1 chosen from 1 choice
[    2.033846] scsi8 : SCSI emulation for USB Mass Storage devices
[    2.033919] usb-storage: device found at 5
[    2.033920] usb-storage: waiting for device to settle before scanning
[    7.033803] usb-storage: device scan complete
[    7.034912] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    7.035965] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    7.037032] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    7.037692] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    7.437397] sd 8:0:0:2: [sde] Attached SCSI removable disk
[    7.439518] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[    7.443005] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    7.445661] sd 8:0:0:1: [sdd] 3915072 512-byte logical blocks: (2.00 GB/1.86 GiB)
[    7.448854] sd 8:0:0:1: [sdd] Write Protect is off
[    7.448856] sd 8:0:0:1: [sdd] Mode Sense: 03 00 00 00
[    7.448857] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.457275] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.457327]  sdd: sdd1 sdd2
[    7.462617] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.462669] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[    8.209805] EXT4-fs (sdd2): mounted filesystem with ordered data mode
[   11.878799] udev: starting version 146
[   12.172369] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[   12.172448] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.173022] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[   12.173052] ACPI: Power Button [PWRB]
[   12.173083] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   12.173096] ACPI: Power Button [PWRF]
[   12.194362] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   12.194380] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   12.194399] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[   12.194416] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   12.194431] sd 8:0:0:1: Attached scsi generic sg4 type 0
[   12.194445] sd 8:0:0:2: Attached scsi generic sg5 type 0
[   12.194461] sd 8:0:0:3: Attached scsi generic sg6 type 0
[   12.223487] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   12.223504] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.223552] r8169 0000:03:00.0: setting latency timer to 64
[   12.223588] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[   12.223940] eth0: RTL8168d/8111d at 0xffffc9001172e000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 27
[   12.398179] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   12.758815] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.758818] Uniform CD-ROM driver Revision: 3.20
[   12.758879] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   12.856829] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.856835] firewire_ohci 0000:02:00.0: setting latency timer to 64
[   12.917244] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI version 1.10
[   13.090223] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.143612] ALSA sound/pci/hda/hda_codec.c:3881: autoconfig: line_outs=4 (0x1c/0x19/0x22/0x23/0x0)
[   13.143615] ALSA sound/pci/hda/hda_codec.c:3885:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.143617] ALSA sound/pci/hda/hda_codec.c:3889:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
[   13.143619] ALSA sound/pci/hda/hda_codec.c:3890:    mono: mono_out=0x0
[   13.143621] ALSA sound/pci/hda/hda_codec.c:3893:    dig-out=0x20/0x21
[   13.143623] ALSA sound/pci/hda/hda_codec.c:3901:    inputs: mic=0x1a, fmic=0x1e, line=0x1b, fline=0x0, cd=0x0, aux=0x0
[   13.145650] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.145669] HDA Intel 0000:01:05.1: setting latency timer to 64
[   13.257225] Adding 2097144k swap on /dev/sda1.  Priority:-1 extents:1 across:2097144k 
[   13.262863] Adding 2097144k swap on /dev/sdb1.  Priority:-2 extents:1 across:2097144k 
[   13.417292] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[   14.045913] device-mapper: uevent: version 1.0.3
[   14.046232] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   14.171487] md: md0 stopped.
[   14.172109] md: bind<sdb2>
[   14.172202] md: bind<sda2>
[   14.180314] md: raid0 personality registered for level 0
[   14.180401] raid0: looking at sda2
[   14.180403] raid0:   comparing sda2(308387392)
[   14.180404]  with sda2(308387392)
[   14.180405] raid0:   END
[   14.180406] raid0:   ==> UNIQUE
[   14.180407] raid0: 1 zones
[   14.180408] raid0: looking at sdb2
[   14.180409] raid0:   comparing sdb2(308387392)
[   14.180410]  with sda2(308387392)
[   14.180411] raid0:   EQUAL
[   14.180411] raid0: FINAL 1 zones
[   14.180413] raid0: done.
[   14.180414] raid0 : md_size is 616774784 sectors.
[   14.180415] ******* md0 configuration *********
[   14.180416] zone0=[sda2/sdb2/]
[   14.180419]         zone offset=0kb device offset=0kb size=308387392kb
[   14.180420] **********************************
[   14.180420] 
[   14.180427] md0: detected capacity change from 0 to 315788689408
[   14.180919]  md0: unknown partition table
[   15.746607] loop: module loaded
[   15.985962] EXT4-fs (dm-3): mounted filesystem with ordered data mode
[   15.994445] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[   16.021282] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[   16.029736] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[   16.162987] fuse init (API version 7.13)
[   18.857530] r8169: eth0: link up
[   18.857535] r8169: eth0: link up
[   19.328588] Slow work thread pool: Starting up
[   19.328626] Slow work thread pool: Ready
[   19.431453] [drm] Initialized drm 1.1.0 20060810
[   19.774666] [drm] radeon defaulting to userspace modesetting.
[   19.775064] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   19.775067] pci 0000:01:05.0: setting latency timer to 64
[   19.775229] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
[   19.861647] [drm] Setting GART location based on new memory map
[   19.861751] [drm] Loading RS780 CP Microcode
[   19.861754] platform r600_cp.0: firmware: requesting radeon/RS780_pfp.bin
[   19.876353] platform r600_cp.0: firmware: requesting radeon/RS780_me.bin
[   19.920940] [drm] Resetting GPU
[   19.920996] [drm] writeback test succeeded in 1 usecs
[   22.059679] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   22.894797] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor processors (4 cpu cores) (version 2.20.00)
[   22.894831] powernow-k8:    0 : pstate 0 (3000 MHz)
[   22.894832] powernow-k8:    1 : pstate 1 (2300 MHz)
[   22.894834] powernow-k8:    2 : pstate 2 (1800 MHz)
[   22.894835] powernow-k8:    3 : pstate 3 (800 MHz)
[   24.019826] it87: Found IT8712F chip at 0x290, revision 8
[   24.019834] it87: in3 is VCC (+5V)
[   24.019835] it87: in7 is VCCH (+5V Stand-By)
[   24.019853] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SIOE [0x290-0x2af]
[   24.019857] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   29.248331] eth0: no IPv6 routers present
[   30.589074] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
