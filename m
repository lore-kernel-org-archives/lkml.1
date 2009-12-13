Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbZLMIRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbZLMIRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZLMIRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:17:49 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:15350
	"HELO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751591AbZLMIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:17:48 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 03:17:46 EST
X-Trace: 311956555/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoEAOsvJEtTQwwf/2dsb2JhbACBSsNWjQ2CNYF2BIFi
X-IronPort-AV: E=Sophos;i="4.47,390,1257120000"; 
   d="scan'208";a="311956555"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: linux-kernel@vger.kernel.org
Subject: Are there MTRR settings correct?
Date: Sun, 13 Dec 2009 08:07:44 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912130807.44905.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

They look a bit suspicious to me since machine has 4GB of RAM, and range covered by MTRR seems to be short of that. Last entry is from the 
IGP I believe, which is also strange because in BIOS an option to map that above 4G is set.

tvrtko@deuteros:~> cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

Also there is a warning in dmesg about no aperture memory hole. Full dmesg follows:

[    0.000000] Linux version 2.6.32 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #2 SMP PREEMPT Sat 
Dec 12 20:44:59 GMT 2009
[    0.000000] Command line: root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" 
splash=silent quiet vga=0x31a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff90000 (usable)
[    0.000000]  BIOS-e820: 00000000cff90000 - 00000000cffa8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffa8000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
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
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff90 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff90000 (usable)
[    0.000000]  modified: 00000000cff90000 - 00000000cffa8000 (ACPI data)
[    0.000000]  modified: 00000000cffa8000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff90000 page 4k
[    0.000000] kernel direct mapping tables up to cff90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 12000-14000
[    0.000000] RAMDISK: 379ea000 - 37fef00a
[    0.000000] ACPI: RSDP 00000000000fb4f0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cff90100 00054 (v01 101409 XSDT1929 20091014 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cff90290 000F4 (v03 101409 FACP1929 20091014 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20090903/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000cff90450 0D100 (v01  A1391 A1391001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cffa8000 00040
[    0.000000] ACPI: APIC 00000000cff90390 0007C (v01 101409 APIC1929 20091014 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cff90410 0003C (v01 101409 OEMMCFG  20091014 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffa8040 00072 (v01 101409 OEMB1929 20091014 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cff9f450 00038 (v01 101409 OEMHPET  20091014 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cff9f490 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
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
[    0.000000]   #3 [00379ea000 - 0037fef00a]          RAMDISK ==> [00379ea000 - 0037fef00a]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0001665000 - 0001665340]              BRK ==> [0001665000 - 0001665340]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff90
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 982814
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3823 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833480 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 00000000cff90000 - 00000000cffa8000
[    0.000000] PM: Registered nosave memory: 00000000cffa8000 - 00000000cffd0000
[    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2f700000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880028200000 s72856 r8192 d21352 u524288
[    0.000000] pcpu-alloc: s72856 r8192 d21352 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 966583
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" resume=UUID="fc2d8cd0-fed3-4196-
b346-83de887dfcf7" splash=silent quiet vga=0x31a
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 3797084k/4718592k available (3519k kernel code, 787336k absent, 134172k reserved, 1987k data, 416k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3013.216 MHz processor.
[    0.002004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6026.42 BogoMIPS (lpj=3013212)
[    0.003152] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004159] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004633] Mount-cache hash table entries: 256
[    0.004716] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004717] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004718] CPU 0/0x0 -> Node 0
[    0.004720] tseg: 0000000000
[    0.004726] CPU: Physical Processor ID: 0
[    0.004727] CPU: Processor Core ID: 0
[    0.004728] mce: CPU supports 6 MCE banks
[    0.004734] using C1E aware idle routine
[    0.004742] ACPI: Core revision 20090903
[    0.018033] Setting APIC routing to flat
[    0.018333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.028351] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.028995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.002999] Initializing CPU#1
[    0.002999] Calibrating delay using timer specific routine.. 6026.83 BogoMIPS (lpj=3013418)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 1/0x1 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 1
[    0.099094] CPU1: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.099100] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.100006] System has AMD C1E enabled
[    0.100014] Switch to broadcast mode on CPU0
[    0.100000] Switch to broadcast mode on CPU1
[    0.101991] Booting processor 2 APIC 0x2 ip 0x6000
[    0.002999] Initializing CPU#2
[    0.002999] Calibrating delay using timer specific routine.. 6026.85 BogoMIPS (lpj=3013425)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 2/0x2 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 2
[    0.173056] CPU2: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.173061] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.173990] Switch to broadcast mode on CPU2
[    0.175980] Booting processor 3 APIC 0x3 ip 0x6000
[    0.002999] Initializing CPU#3
[    0.002999] Calibrating delay using timer specific routine.. 6026.81 BogoMIPS (lpj=3013407)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 3/0x3 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 3
[    0.247036] CPU3: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.247041] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.247985] Brought up 4 CPUs
[    0.247987] Total of 4 processors activated (24106.92 BogoMIPS).
[    0.247985] Switch to broadcast mode on CPU3
[    0.248981] devtmpfs: initialized
[    0.249117] Time:  7:44:11  Date: 12/13/09
[    0.249970] NET: Registered protocol family 16
[    0.250025] node 0 link 0: io port [1000, ffffff]
[    0.250027] TOM: 00000000d0000000 aka 3328M
[    0.250028] Fam 10h mmconf [e0000000, efffffff]
[    0.250030] node 0 link 0: mmio [a0000, bffff]
[    0.250032] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    0.250034] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.250036] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.250037] node 0 link 0: mmio [fea00000, ffefffff]
[    0.250039] TOM2: 0000000130000000 aka 4864M
[    0.250040] bus: [00,07] on node 0 link 0
[    0.250042] bus: 00 index 0 io port: [0, ffff]
[    0.250043] bus: 00 index 1 mmio: [a0000, bffff]
[    0.250044] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.250045] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.250046] bus: 00 index 4 mmio: [130000000, fcffffffff]
[    0.250053] ACPI: bus type pci registered
[    0.250089] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.250090] PCI: Not using MMCONFIG.
[    0.250091] PCI: Using configuration type 1 for base access
[    0.250092] PCI: Using configuration type 1 for extended access
[    0.250399] bio: create slab <bio-0> at 0
[    0.251177] ACPI: EC: Look up EC in DSDT
[    0.253491] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
[    0.253495] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
[    0.253598] ACPI: Executed 3 blocks of module-level executable AML code
[    0.271554] ACPI: Interpreter enabled
[    0.271559] ACPI: (supports S0 S1 S3 S4 S5)
[    0.271578] ACPI: Using IOAPIC for interrupt routing
[    0.271624] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.275991] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.280874] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.287219] ACPI Warning: Incorrect checksum in table [OEMB] - 82, should be 7D (20090903/tbutils-314)
[    0.287311] ACPI: No dock devices found.
[    0.287450] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.287553] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.287555] pci 0000:00:07.0: PME# disabled
[    0.287583] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.287585] pci 0000:00:0a.0: PME# disabled
[    0.287627] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.287633] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.287639] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.287645] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.287650] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.287656] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.287702] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe7fe000-0xfe7fefff]
[    0.287750] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe7fd000-0xfe7fdfff]
[    0.287814] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe7ff800-0xfe7ff8ff]
[    0.287860] pci 0000:00:12.2: supports D1 D2
[    0.287861] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.287864] pci 0000:00:12.2: PME# disabled
[    0.287892] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe7fc000-0xfe7fcfff]
[    0.287939] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe7fb000-0xfe7fbfff]
[    0.288010] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.288056] pci 0000:00:13.2: supports D1 D2
[    0.288057] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.288061] pci 0000:00:13.2: PME# disabled
[    0.288164] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.288170] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.288175] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.288181] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.288186] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.288244] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe7f4000-0xfe7f7fff]
[    0.288282] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.288285] pci 0000:00:14.2: PME# disabled
[    0.288377] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe7fa000-0xfe7fafff]
[    0.288484] pci 0000:01:05.0: reg 10 32bit mmio pref: [0xd0000000-0xdfffffff]
[    0.288487] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.288490] pci 0000:01:05.0: reg 18 32bit mmio: [0xfe9f0000-0xfe9fffff]
[    0.288495] pci 0000:01:05.0: reg 24 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.288504] pci 0000:01:05.0: supports D1 D2
[    0.288517] pci 0000:01:05.1: reg 10 32bit mmio: [0xfe9e8000-0xfe9ebfff]
[    0.288532] pci 0000:01:05.1: supports D1 D2
[    0.288570] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.288572] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
[    0.288574] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.288611] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.288619] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.288640] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.288648] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.291025] pci 0000:00:07.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.291056] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.291069] pci 0000:03:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.291078] pci 0000:03:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.291083] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfebf0000-0xfebfffff]
[    0.291109] pci 0000:03:00.0: supports D1 D2
[    0.291110] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.291113] pci 0000:03:00.0: PME# disabled
[    0.293020] pci 0000:00:0a.0: bridge io port: [0xe000-0xefff]
[    0.293022] pci 0000:00:0a.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.293025] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.293077] pci 0000:00:14.4: transparent bridge
[    0.293096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.293244] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.293302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.293349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.293407] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.297203] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.297295] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.297386] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.297476] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.297567] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.297657] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.297748] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.297839] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.297908] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.297910] vgaarb: loaded
[    0.297974] SCSI subsystem initialized
[    0.305957] libata version 3.00 loaded.
[    0.305977] usbcore: registered new interface driver usbfs
[    0.305977] usbcore: registered new interface driver hub
[    0.305980] usbcore: registered new device driver usb
[    0.305980] PCI: Using ACPI for IRQ routing
[    0.306085] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.306088] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.308972] hpet: hpet2 irq 24 for MSI
[    0.310957] Switching to clocksource tsc
[    0.314054] pnp: PnP ACPI init
[    0.314063] ACPI: bus type pnp registered
[    0.317872] pnp: PnP ACPI: found 14 devices
[    0.317873] ACPI: ACPI bus type pnp unregistered
[    0.317885] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.317888] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.317891] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.317893] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.317895] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.317897] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.317898] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.317900] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.317902] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.317903] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.317905] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.317907] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.317909] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.317910] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.317912] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.317914] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.317915] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.317917] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.317919] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.317921] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.317923] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.317924] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.317926] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.317929] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.317931] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.317934] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.317937] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.317939] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.317940] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.317942] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.317945] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.317948] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.317950] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.317952] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.317954] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
[    0.317955] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.322638] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.322640] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.322643] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe9fffff
[    0.322645] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.322648] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.322649] pci 0000:00:07.0:   IO window: disabled
[    0.322652] pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
[    0.322653] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.322655] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
[    0.322657] pci 0000:00:0a.0:   IO window: 0xe000-0xefff
[    0.322659] pci 0000:00:0a.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.322661] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.322664] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.322665] pci 0000:00:14.4:   IO window: disabled
[    0.322669] pci 0000:00:14.4:   MEM window: disabled
[    0.322672] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.322696] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.322699] pci 0000:00:07.0: setting latency timer to 64
[    0.322704] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.322706] pci 0000:00:0a.0: setting latency timer to 64
[    0.322712] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.322713] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.322715] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.322716] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe9fffff]
[    0.322718] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.322720] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.322721] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.322723] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.322724] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.322726] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.322727] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.322747] NET: Registered protocol family 2
[    0.322843] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.323491] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.325404] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.325646] TCP: Hash tables configured (established 524288 bind 65536)
[    0.325647] TCP reno registered
[    0.325715] NET: Registered protocol family 1
[    0.452935] pci 0000:01:05.0: Boot video device
[    0.452969] Unpacking initramfs...
[    0.537310] Freeing initrd memory: 6164k freed
[    0.538654] PCI-DMA: Disabling AGP.
[    0.538742] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.538743] PCI-DMA: using GART IOMMU.
[    0.538745] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.540563] Scanning for low memory corruption every 60 seconds
[    0.540831] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.541601] VFS: Disk quotas dquot_6.5.2
[    0.541633] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.541801] msgmni has been set to 7428
[    0.541867] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.541868] io scheduler noop registered
[    0.541869] io scheduler anticipatory registered
[    0.541871] io scheduler deadline registered
[    0.541889] io scheduler cfq registered (default)
[    0.542006] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    0.542011] pcieport 0000:00:07.0: setting latency timer to 64
[    0.542098] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.542101] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.542256] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011100000, using 5120k, total 16384k
[    0.542258] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.542259] vesafb: scrolling: redraw
[    0.542261] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.623588] Console: switching to colour frame buffer device 160x64
[    0.700213] fb0: VESA VGA frame buffer device
[    0.700895] Non-volatile memory driver v1.3
[    0.700898] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.700990] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.701161] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.701288] ahci 0000:00:11.0: version 3.0
[    0.701304] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.701415] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.701418] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.701662] scsi0 : ahci
[    0.701723] scsi1 : ahci
[    0.701752] scsi2 : ahci
[    0.701781] scsi3 : ahci
[    0.701810] scsi4 : ahci
[    0.701841] scsi5 : ahci
[    0.701864] ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00 irq 22
[    0.701867] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    0.701869] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    0.701872] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    0.701874] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00 irq 22
[    0.701876] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80 irq 22
[    0.701914] Fixed MDIO Bus: probed
[    0.701918] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.701965] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.701978] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.701993] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.702021] ehci_hcd 0000:00:12.2: debug port 1
[    0.702036] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.708272] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.708285] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.708287] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.708289] usb usb1: Product: EHCI Host Controller
[    0.708290] usb usb1: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.708291] usb usb1: SerialNumber: 0000:00:12.2
[    0.708334] usb usb1: configuration #1 chosen from 1 choice
[    0.708351] hub 1-0:1.0: USB hub found
[    0.708355] hub 1-0:1.0: 6 ports detected
[    0.708414] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.708422] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.708428] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.708450] ehci_hcd 0000:00:13.2: debug port 1
[    0.708464] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.714265] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.714272] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.714274] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.714275] usb usb2: Product: EHCI Host Controller
[    0.714277] usb usb2: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.714278] usb usb2: SerialNumber: 0000:00:13.2
[    0.714304] usb usb2: configuration #1 chosen from 1 choice
[    0.714318] hub 2-0:1.0: USB hub found
[    0.714321] hub 2-0:1.0: 6 ports detected
[    0.714360] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.714381] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.714389] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.714394] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.714411] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.769288] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.769290] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.769291] usb usb3: Product: OHCI Host Controller
[    0.769293] usb usb3: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.769294] usb usb3: SerialNumber: 0000:00:12.0
[    0.769322] usb usb3: configuration #1 chosen from 1 choice
[    0.769335] hub 3-0:1.0: USB hub found
[    0.769342] hub 3-0:1.0: 3 ports detected
[    0.769408] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.769415] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.769420] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.769432] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.824300] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.824301] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.824303] usb usb4: Product: OHCI Host Controller
[    0.824304] usb usb4: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.824305] usb usb4: SerialNumber: 0000:00:12.1
[    0.824333] usb usb4: configuration #1 chosen from 1 choice
[    0.824345] hub 4-0:1.0: USB hub found
[    0.824350] hub 4-0:1.0: 3 ports detected
[    0.824414] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.824423] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.824428] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.824444] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.879300] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.879301] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.879303] usb usb5: Product: OHCI Host Controller
[    0.879304] usb usb5: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.879305] usb usb5: SerialNumber: 0000:00:13.0
[    0.879333] usb usb5: configuration #1 chosen from 1 choice
[    0.879345] hub 5-0:1.0: USB hub found
[    0.879350] hub 5-0:1.0: 3 ports detected
[    0.879415] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.879421] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.879427] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.879439] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.934299] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.934301] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.934302] usb usb6: Product: OHCI Host Controller
[    0.934303] usb usb6: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.934304] usb usb6: SerialNumber: 0000:00:13.1
[    0.934333] usb usb6: configuration #1 chosen from 1 choice
[    0.934345] hub 6-0:1.0: USB hub found
[    0.934351] hub 6-0:1.0: 3 ports detected
[    0.934419] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.934427] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.934433] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.934444] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    0.989300] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.989302] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.989303] usb usb7: Product: OHCI Host Controller
[    0.989305] usb usb7: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.989306] usb usb7: SerialNumber: 0000:00:14.5
[    0.989332] usb usb7: configuration #1 chosen from 1 choice
[    0.989345] hub 7-0:1.0: USB hub found
[    0.989351] hub 7-0:1.0: 2 ports detected
[    0.989396] Initializing USB Mass Storage driver...
[    0.989420] usbcore: registered new interface driver usb-storage
[    0.989422] USB Mass Storage support registered.
[    0.989439] usbcore: registered new interface driver libusual
[    0.989445] usbcore: registered new interface driver ums-alauda
[    0.989450] usbcore: registered new interface driver ums-cypress
[    0.989459] usbcore: registered new interface driver ums-datafab
[    0.989464] usbcore: registered new interface driver ums-freecom
[    0.989471] usbcore: registered new interface driver ums-isd200
[    0.989476] usbcore: registered new interface driver ums-jumpshot
[    0.989481] usbcore: registered new interface driver ums-karma
[    0.989486] usbcore: registered new interface driver ums-onetouch
[    0.989492] usbcore: registered new interface driver ums-sddr09
[    0.989497] usbcore: registered new interface driver ums-sddr55
[    0.989503] usbcore: registered new interface driver ums-usbat
[    0.989526] PNP: No PS/2 controller found. Probing ports directly.
[    0.989853] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.989857] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.989899] mice: PS/2 mouse device common for all mice
[    0.989910] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.989927] rtc_cmos 00:03: RTC can wake from S4
[    0.989946] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.989968] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.989978] cpuidle: using governor ladder
[    0.989979] cpuidle: using governor menu
[    0.990113] usbcore: registered new interface driver hiddev
[    0.990119] usbcore: registered new interface driver usbhid
[    0.990121] usbhid: v2.6:USB HID core driver
[    0.990294] TCP cubic registered
[    0.990358] NET: Registered protocol family 10
[    0.990617] lo: Disabled Privacy Extensions
[    0.990827] PM: Checking image partition UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7"
[    1.006988] ata4: SATA link down (SStatus 0 SControl 300)
[    1.007012] ata1: SATA link down (SStatus 0 SControl 300)
[    1.007968] ata5: SATA link down (SStatus 0 SControl 300)
[    1.007995] ata6: SATA link down (SStatus 0 SControl 300)
[    1.011962] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    1.087120] usb 1-3: New USB device found, idVendor=05e3, idProduct=0606
[    1.087122] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.087123] usb 1-3: Product: USB2.0 Hub
[    1.087154] usb 1-3: configuration #1 chosen from 1 choice
[    1.087635] hub 1-3:1.0: USB hub found
[    1.088117] hub 1-3:1.0: 4 ports detected
[    1.090240] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.091202] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.091892] ata2.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.091894] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.092599] ata3.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.092600] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.093961] ata2.00: configured for UDMA/133
[    1.094653] ata3.00: configured for UDMA/133
[    1.104306] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.104396] sd 1:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.104415] sd 1:0:0:0: [sda] Write Protect is off
[    1.104417] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.104426] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.104495]  sda:
[    1.105671] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.105731] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.105751] sd 2:0:0:0: [sdb] Write Protect is off
[    1.105753] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.105763] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.105824]  sdb: sdb1 sdb2
[    1.171974]  sda1 sda2
[    1.172080] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.172110] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.172113] PM: Resume from disk failed.
[    1.172116] registered taskstats version 1
[    1.172356]   Magic number: 5:438:723
[    1.172408] rtc_cmos 00:03: setting system clock to 2009-12-13 07:44:12 UTC (1260690252)
[    1.172433] Freeing unused kernel memory: 416k freed
[    1.172509] Write protecting the kernel read-only data: 5040k
[    1.194258] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.194279] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.194325] scsi6 : pata_atiixp
[    1.194361] scsi7 : pata_atiixp
[    1.195396] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.195398] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.349677] ata7.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
[    1.355621] ata7.00: configured for UDMA/33
[    1.357123] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
[    1.418240] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.512878] processor LNXCPU:00: registered as cooling_device0
[    1.513239] processor LNXCPU:01: registered as cooling_device1
[    1.513576] processor LNXCPU:02: registered as cooling_device2
[    1.513913] processor LNXCPU:03: registered as cooling_device3
[    1.517551] udev: starting version 146
[    1.565592] usb 4-2: New USB device found, idVendor=046a, idProduct=0021
[    1.565594] usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.565652] usb 4-2: configuration #1 chosen from 1 choice
[    1.574719] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input0
[    1.574761] generic-usb 0003:046A:0021.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-2/input0
[    1.584630] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input1
[    1.584666] generic-usb 0003:046A:0021.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-2/input1
[    1.811351] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.962706] usb 4-3: New USB device found, idVendor=046d, idProduct=c521
[    1.962709] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.962710] usb 4-3: Product: USB Receiver
[    1.962712] usb 4-3: Manufacturer: Logitech
[    1.962764] usb 4-3: configuration #1 chosen from 1 choice
[    1.974632] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
[    1.974679] generic-usb 0003:046D:C521.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    1.985642] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
[    1.985701] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:12.1-3/input1
[    2.051085] usb 1-3.1: new high speed USB device using ehci_hcd and address 5
[    2.131231] usb 1-3.1: New USB device found, idVendor=058f, idProduct=6362
[    2.131233] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.131235] usb 1-3.1: Product: Mass Storage Device
[    2.131236] usb 1-3.1: Manufacturer: Generic
[    2.131237] usb 1-3.1: SerialNumber: 058F312D81B
[    2.131280] usb 1-3.1: configuration #1 chosen from 1 choice
[    2.131842] scsi8 : SCSI emulation for USB Mass Storage devices
[    2.131928] usb-storage: device found at 5
[    2.131930] usb-storage: waiting for device to settle before scanning
[    7.131633] usb-storage: device scan complete
[    7.132725] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    7.133791] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    7.134841] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    7.135886] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    7.533636] sd 8:0:0:2: [sde] Attached SCSI removable disk
[    7.535634] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[    7.538368] sd 8:0:0:1: [sdd] 3915072 512-byte logical blocks: (2.00 GB/1.86 GiB)
[    7.541980] sd 8:0:0:1: [sdd] Write Protect is off
[    7.541983] sd 8:0:0:1: [sdd] Mode Sense: 03 00 00 00
[    7.541984] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.544586] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    7.554270] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.554834]  sdd: sdd1 sdd2
[    7.559010] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.559579] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[    8.343074] EXT4-fs (sdd2): mounted filesystem with ordered data mode
[   12.026650] udev: starting version 146
[   12.187991] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[   12.188027] ACPI: Power Button [PWRB]
[   12.188057] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   12.188070] ACPI: Power Button [PWRF]
[   12.258361] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[   12.259234] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.383649] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   12.383666] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   12.383685] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[   12.383701] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   12.383721] sd 8:0:0:1: Attached scsi generic sg4 type 0
[   12.383738] sd 8:0:0:2: Attached scsi generic sg5 type 0
[   12.383759] sd 8:0:0:3: Attached scsi generic sg6 type 0
[   12.429654] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   12.597564] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   12.597581] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.597632] r8169 0000:03:00.0: setting latency timer to 64
[   12.597668] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[   12.598045] eth0: RTL8168d/8111d at 0xffffc90011790000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 27
[   12.993577] sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.993580] Uniform CD-ROM driver Revision: 3.20
[   12.993633] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   13.049164] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   13.049171] firewire_ohci 0000:02:00.0: setting latency timer to 64
[   13.108234] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI version 1.10
[   13.267936] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.321479] ALSA sound/pci/hda/hda_codec.c:3881: autoconfig: line_outs=4 (0x1c/0x19/0x22/0x23/0x0)
[   13.321482] ALSA sound/pci/hda/hda_codec.c:3885:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.321485] ALSA sound/pci/hda/hda_codec.c:3889:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
[   13.321487] ALSA sound/pci/hda/hda_codec.c:3890:    mono: mono_out=0x0
[   13.321488] ALSA sound/pci/hda/hda_codec.c:3893:    dig-out=0x20/0x21
[   13.321490] ALSA sound/pci/hda/hda_codec.c:3901:    inputs: mic=0x1a, fmic=0x1e, line=0x1b, fline=0x0, cd=0x0, aux=0x0
[   13.323607] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.323626] HDA Intel 0000:01:05.1: setting latency timer to 64
[   13.608290] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[   15.166831] Adding 2097144k swap on /dev/sda1.  Priority:-1 extents:1 across:2097144k 
[   15.172239] Adding 2097144k swap on /dev/sdb1.  Priority:-2 extents:1 across:2097144k 
[   16.578743] device-mapper: uevent: version 1.0.3
[   16.579049] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   16.602774] md: md0 stopped.
[   16.603246] md: bind<sdb2>
[   16.603343] md: bind<sda2>
[   16.611522] md: raid0 personality registered for level 0
[   16.611619] raid0: looking at sda2
[   16.611621] raid0:   comparing sda2(308387392)
[   16.611623]  with sda2(308387392)
[   16.611624] raid0:   END
[   16.611624] raid0:   ==> UNIQUE
[   16.611625] raid0: 1 zones
[   16.611626] raid0: looking at sdb2
[   16.611627] raid0:   comparing sdb2(308387392)
[   16.611628]  with sda2(308387392)
[   16.611629] raid0:   EQUAL
[   16.611630] raid0: FINAL 1 zones
[   16.611632] raid0: done.
[   16.611633] raid0 : md_size is 616774784 sectors.
[   16.611634] ******* md0 configuration *********
[   16.611635] zone0=[sda2/sdb2/]
[   16.611637]         zone offset=0kb device offset=0kb size=308387392kb
[   16.611638] **********************************
[   16.611639] 
[   16.611646] md0: detected capacity change from 0 to 315788689408
[   16.612242]  md0: unknown partition table
[   18.428146] loop: module loaded
[   18.684837] EXT4-fs (dm-3): mounted filesystem with ordered data mode
[   18.712463] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[   18.751147] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[   18.778645] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[   18.914584] fuse init (API version 7.13)
[   21.971086] r8169: eth0: link up
[   21.971094] r8169: eth0: link up
[   22.365150] Slow work thread pool: Starting up
[   22.365227] Slow work thread pool: Ready
[   25.220389] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   26.000270] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor processors (4 cpu cores) (version 2.20.00)
[   26.000304] powernow-k8:    0 : pstate 0 (3000 MHz)
[   26.000306] powernow-k8:    1 : pstate 1 (2300 MHz)
[   26.000307] powernow-k8:    2 : pstate 2 (1800 MHz)
[   26.000308] powernow-k8:    3 : pstate 3 (800 MHz)
[   26.980869] it87: Found IT8712F chip at 0x290, revision 8
[   26.980884] it87: in3 is VCC (+5V)
[   26.980887] it87: in7 is VCCH (+5V Stand-By)
[   26.980941] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SIOE [0x290-0x2af]
[   26.980954] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   32.425286] eth0: no IPv6 routers present
[  181.639678] [drm] Initialized drm 1.1.0 20060810
[  182.008110] [drm] radeon defaulting to userspace modesetting.
[  182.008549] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  182.008553] pci 0000:01:05.0: setting latency timer to 64
[  182.008714] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
[  230.123564] mtrr: no MTRR for d0000000,10000000 found
[  520.128252] mtrr: no MTRR for d0000000,10000000 found
[  531.545469] mtrr: no MTRR for d0000000,10000000 found
[  863.072960] mtrr: no MTRR for d0000000,10000000 found
[  863.464437] [drm] Setting GART location based on new memory map
[  863.464680] [drm] Loading RS780 CP Microcode
[  863.464683] platform r600_cp.0: firmware: requesting radeon/RS780_pfp.bin
[  863.487859] platform r600_cp.0: firmware: requesting radeon/RS780_me.bin
[  863.540900] [drm] Resetting GPU
[  863.540960] [drm] writeback test succeeded in 1 usecs
