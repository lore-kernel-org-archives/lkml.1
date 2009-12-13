Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809AbZLMI1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbZLMI1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 03:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZLMI1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 03:27:00 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:25347
	"HELO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751756AbZLMI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 03:26:58 -0500
X-Trace: 311957213/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoEAHkzJEtTQwwf/2dsb2JhbACBSsNfjQyCNYF2BIFi
X-IronPort-AV: E=Sophos;i="4.47,390,1257120000"; 
   d="scan'208";a="311957213"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Are these MTRR settings correct?
Date: Sun, 13 Dec 2009 08:26:48 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
Cc: Tvrtko Ursulin <tvrtko@ursulin.net>
References: <200912130807.44905.tvrtko@ursulin.net>
In-Reply-To: <200912130807.44905.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912130826.48302.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 Dec 2009 08:07:44 Tvrtko Ursulin wrote:
> Hi all,
> 
> They look a bit suspicious to me since machine has 4GB of RAM, and range
>  covered by MTRR seems to be short of that. Last entry is from the IGP I
>  believe, which is also strange because in BIOS an option to map that above
>  4G is set.
> 
> tvrtko@deuteros:~> cat /proc/mtrr
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
> reg03: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining

This IGP has a sideport memory, above sideport plus UMA was enabled in BIOS. If I limit it to
only 128Mb of sideport framebuffer then it looks like this:

reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
reg03: base=0x0f0000000 ( 3840MB), size=  128MB, count=1: write-combining

Still looks like from 3328MB to 3840MB is of status unknown?

dmesg in that case:

[    0.000000] Linux version 2.6.32 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #2 SMP PREEMPT Sat 
Dec 12 20:44:59 GMT 2009
[    0.000000] Command line: root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" 
splash=silent quiet vga=0x31a 3
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
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
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
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff90000 page 4k
[    0.000000] kernel direct mapping tables up to cff90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 12000-14000
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
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [0000000000013000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  000000000003afff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000166476c]    TEXT DATA BSS ==> [0001000000 - 000166476c]
[    0.000000]   #3 [00379ea000 - 0037fef00a]          RAMDISK ==> [00379ea000 - 0037fef00a]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0001665000 - 0001665340]              BRK ==> [0001665000 - 0001665340]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff90
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048350
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3823 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833480 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
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
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031223
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" resume=UUID="fc2d8cd0-fed3-4196-
b346-83de887dfcf7" splash=silent quiet vga=0x31a 3
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
[    0.000000] Memory: 4055120k/4980736k available (3519k kernel code, 787336k absent, 138280k reserved, 1987k data, 416k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3013.603 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6027.19 BogoMIPS (lpj=3013599)
[    0.003149] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004159] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004634] Mount-cache hash table entries: 256
[    0.004717] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004718] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004720] CPU 0/0x0 -> Node 0
[    0.004721] tseg: 0000000000
[    0.004728] CPU: Physical Processor ID: 0
[    0.004728] CPU: Processor Core ID: 0
[    0.004730] mce: CPU supports 6 MCE banks
[    0.004735] using C1E aware idle routine
[    0.004744] ACPI: Core revision 20090903
[    0.018034] Setting APIC routing to flat
[    0.019296] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.029302] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.029995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.002999] Initializing CPU#1
[    0.002999] Calibrating delay using timer specific routine.. 6026.83 BogoMIPS (lpj=3013418)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 1/0x1 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 1
[    0.100097] CPU1: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.100102] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.101006] System has AMD C1E enabled
[    0.101014] Switch to broadcast mode on CPU0
[    0.101000] Switch to broadcast mode on CPU1
[    0.102991] Booting processor 2 APIC 0x2 ip 0x6000
[    0.002999] Initializing CPU#2
[    0.002999] Calibrating delay using timer specific routine.. 6026.85 BogoMIPS (lpj=3013426)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 2/0x2 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 2
[    0.174067] CPU2: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.174072] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.174990] Switch to broadcast mode on CPU2
[    0.176979] Booting processor 3 APIC 0x3 ip 0x6000
[    0.002999] Initializing CPU#3
[    0.002999] Calibrating delay using timer specific routine.. 6026.89 BogoMIPS (lpj=3013449)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 3/0x3 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 3
[    0.248059] CPU3: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.248064] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.248985] Brought up 4 CPUs
[    0.248987] Total of 4 processors activated (24107.78 BogoMIPS).
[    0.248984] Switch to broadcast mode on CPU3
[    0.249981] devtmpfs: initialized
[    0.250963] Time:  8:13:20  Date: 12/13/09
[    0.250988] NET: Registered protocol family 16
[    0.251043] node 0 link 0: io port [1000, ffffff]
[    0.251045] TOM: 00000000d0000000 aka 3328M
[    0.251046] Fam 10h mmconf [e0000000, efffffff]
[    0.251048] node 0 link 0: mmio [a0000, bffff]
[    0.251050] node 0 link 0: mmio [d0000000, dfffffff]
[    0.251051] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.251053] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.251055] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.251056] node 0 link 0: mmio [fea00000, ffefffff]
[    0.251058] TOM2: 0000000130000000 aka 4864M
[    0.251059] bus: [00,07] on node 0 link 0
[    0.251060] bus: 00 index 0 io port: [0, ffff]
[    0.251062] bus: 00 index 1 mmio: [a0000, bffff]
[    0.251063] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.251064] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.251065] bus: 00 index 4 mmio: [130000000, fcffffffff]
[    0.251072] ACPI: bus type pci registered
[    0.251107] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.251109] PCI: Not using MMCONFIG.
[    0.251110] PCI: Using configuration type 1 for base access
[    0.251111] PCI: Using configuration type 1 for extended access
[    0.251417] bio: create slab <bio-0> at 0
[    0.252198] ACPI: EC: Look up EC in DSDT
[    0.254505] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
[    0.254509] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
[    0.254613] ACPI: Executed 3 blocks of module-level executable AML code
[    0.271577] ACPI: Interpreter enabled
[    0.271582] ACPI: (supports S0 S1 S3 S4 S5)
[    0.271601] ACPI: Using IOAPIC for interrupt routing
[    0.271647] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.276000] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.280821] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.287175] ACPI Warning: Incorrect checksum in table [OEMB] - 82, should be 7D (20090903/tbutils-314)
[    0.287267] ACPI: No dock devices found.
[    0.287408] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.287511] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.287513] pci 0000:00:07.0: PME# disabled
[    0.287541] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.287542] pci 0000:00:0a.0: PME# disabled
[    0.287585] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.287591] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.287597] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.287603] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.287608] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.287614] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.287660] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe7fe000-0xfe7fefff]
[    0.287708] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe7fd000-0xfe7fdfff]
[    0.287772] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe7ff800-0xfe7ff8ff]
[    0.287818] pci 0000:00:12.2: supports D1 D2
[    0.287820] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.287823] pci 0000:00:12.2: PME# disabled
[    0.287850] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe7fc000-0xfe7fcfff]
[    0.287898] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe7fb000-0xfe7fbfff]
[    0.287967] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.288014] pci 0000:00:13.2: supports D1 D2
[    0.288015] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.288018] pci 0000:00:13.2: PME# disabled
[    0.288122] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.288128] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.288133] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.288139] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.288144] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.288202] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe7f4000-0xfe7f7fff]
[    0.288240] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.288243] pci 0000:00:14.2: PME# disabled
[    0.288336] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe7fa000-0xfe7fafff]
[    0.288443] pci 0000:01:05.0: reg 10 32bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.288446] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.288449] pci 0000:01:05.0: reg 18 32bit mmio: [0xfe9f0000-0xfe9fffff]
[    0.288454] pci 0000:01:05.0: reg 24 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.288463] pci 0000:01:05.0: supports D1 D2
[    0.288476] pci 0000:01:05.1: reg 10 32bit mmio: [0xfe9e8000-0xfe9ebfff]
[    0.288492] pci 0000:01:05.1: supports D1 D2
[    0.288529] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.288531] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
[    0.288534] pci 0000:00:01.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.288571] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.288578] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.288599] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.288607] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.291025] pci 0000:00:07.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.291056] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.291069] pci 0000:03:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.291078] pci 0000:03:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.291083] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfebf0000-0xfebfffff]
[    0.291109] pci 0000:03:00.0: supports D1 D2
[    0.291110] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.291113] pci 0000:03:00.0: PME# disabled
[    0.295020] pci 0000:00:0a.0: bridge io port: [0xe000-0xefff]
[    0.295022] pci 0000:00:0a.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.295025] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.295077] pci 0000:00:14.4: transparent bridge
[    0.295096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.295244] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.295302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.295349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.295408] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.299181] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.299274] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.299365] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.299456] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.299546] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.299637] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.299728] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.299819] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.299888] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.299890] vgaarb: loaded
[    0.299940] SCSI subsystem initialized
[    0.304957] libata version 3.00 loaded.
[    0.304977] usbcore: registered new interface driver usbfs
[    0.304977] usbcore: registered new interface driver hub
[    0.304980] usbcore: registered new device driver usb
[    0.304980] PCI: Using ACPI for IRQ routing
[    0.305085] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.305089] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.307973] hpet: hpet2 irq 24 for MSI
[    0.309958] Switching to clocksource tsc
[    0.312055] pnp: PnP ACPI init
[    0.312064] ACPI: bus type pnp registered
[    0.315883] pnp: PnP ACPI: found 14 devices
[    0.315884] ACPI: ACPI bus type pnp unregistered
[    0.315896] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.315898] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.315902] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.315904] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.315905] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.315907] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.315909] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.315910] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.315912] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.315913] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.315915] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.315917] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.315918] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.315920] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.315921] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.315923] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.315925] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.315926] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.315928] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.315930] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.315932] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.315933] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.315935] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.315937] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.315939] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.315941] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.315944] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.315946] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.315947] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.315949] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.315952] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.315955] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.315956] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.315958] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.315960] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
[    0.315962] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.320642] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.320644] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.320646] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe9fffff
[    0.320649] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    0.320652] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.320653] pci 0000:00:07.0:   IO window: disabled
[    0.320655] pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
[    0.320657] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.320667] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
[    0.320668] pci 0000:00:0a.0:   IO window: 0xe000-0xefff
[    0.320670] pci 0000:00:0a.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.320672] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.320675] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.320676] pci 0000:00:14.4:   IO window: disabled
[    0.320680] pci 0000:00:14.4:   MEM window: disabled
[    0.320683] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.320694] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.320696] pci 0000:00:07.0: setting latency timer to 64
[    0.320701] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.320703] pci 0000:00:0a.0: setting latency timer to 64
[    0.320709] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.320711] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.320712] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.320714] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe9fffff]
[    0.320715] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
[    0.320717] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.320719] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.320720] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.320722] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.320723] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.320725] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.320744] NET: Registered protocol family 2
[    0.320840] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.321489] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.323394] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.323637] TCP: Hash tables configured (established 524288 bind 65536)
[    0.323639] TCP reno registered
[    0.323706] NET: Registered protocol family 1
[    0.451893] pci 0000:01:05.0: Boot video device
[    0.451927] Unpacking initramfs...
[    0.536266] Freeing initrd memory: 6164k freed
[    0.537598] PCI-DMA: Disabling AGP.
[    0.537688] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.537690] PCI-DMA: using GART IOMMU.
[    0.537692] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.539507] Scanning for low memory corruption every 60 seconds
[    0.539786] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.540557] VFS: Disk quotas dquot_6.5.2
[    0.540589] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.540757] msgmni has been set to 7932
[    0.540823] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.540824] io scheduler noop registered
[    0.540826] io scheduler anticipatory registered
[    0.540827] io scheduler deadline registered
[    0.540846] io scheduler cfq registered (default)
[    0.540961] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    0.540965] pcieport 0000:00:07.0: setting latency timer to 64
[    0.541052] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.541056] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.541210] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90011100000, using 5120k, total 16384k
[    0.541212] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.541213] vesafb: scrolling: redraw
[    0.541215] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.548080] Console: switching to colour frame buffer device 160x64
[    0.554475] fb0: VESA VGA frame buffer device
[    0.555162] Non-volatile memory driver v1.3
[    0.555164] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.555256] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.555428] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.555562] ahci 0000:00:11.0: version 3.0
[    0.555578] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.555689] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.555692] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.555942] scsi0 : ahci
[    0.556003] scsi1 : ahci
[    0.556032] scsi2 : ahci
[    0.556060] scsi3 : ahci
[    0.556091] scsi4 : ahci
[    0.556120] scsi5 : ahci
[    0.556142] ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00 irq 22
[    0.556145] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    0.556148] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    0.556150] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    0.556152] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00 irq 22
[    0.556155] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80 irq 22
[    0.556216] Fixed MDIO Bus: probed
[    0.556221] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.556253] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.556263] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.556277] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.556305] ehci_hcd 0000:00:12.2: debug port 1
[    0.556321] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.562211] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.562224] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.562226] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.562228] usb usb1: Product: EHCI Host Controller
[    0.562229] usb usb1: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.562230] usb usb1: SerialNumber: 0000:00:12.2
[    0.562269] usb usb1: configuration #1 chosen from 1 choice
[    0.562286] hub 1-0:1.0: USB hub found
[    0.562290] hub 1-0:1.0: 6 ports detected
[    0.562353] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.562361] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.562367] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.562388] ehci_hcd 0000:00:13.2: debug port 1
[    0.562403] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.568208] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.568214] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.568216] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.568218] usb usb2: Product: EHCI Host Controller
[    0.568219] usb usb2: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.568220] usb usb2: SerialNumber: 0000:00:13.2
[    0.568247] usb usb2: configuration #1 chosen from 1 choice
[    0.568261] hub 2-0:1.0: USB hub found
[    0.568264] hub 2-0:1.0: 6 ports detected
[    0.568303] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.568327] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.568335] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.568340] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.568357] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.623231] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.623233] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.623234] usb usb3: Product: OHCI Host Controller
[    0.623235] usb usb3: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.623237] usb usb3: SerialNumber: 0000:00:12.0
[    0.623265] usb usb3: configuration #1 chosen from 1 choice
[    0.623277] hub 3-0:1.0: USB hub found
[    0.623285] hub 3-0:1.0: 3 ports detected
[    0.623374] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.623381] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.623386] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.623397] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.678225] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.678226] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.678228] usb usb4: Product: OHCI Host Controller
[    0.678229] usb usb4: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.678230] usb usb4: SerialNumber: 0000:00:12.1
[    0.678258] usb usb4: configuration #1 chosen from 1 choice
[    0.678270] hub 4-0:1.0: USB hub found
[    0.678276] hub 4-0:1.0: 3 ports detected
[    0.678363] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.678371] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.678376] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.678392] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.733220] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.733221] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.733223] usb usb5: Product: OHCI Host Controller
[    0.733224] usb usb5: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.733225] usb usb5: SerialNumber: 0000:00:13.0
[    0.733253] usb usb5: configuration #1 chosen from 1 choice
[    0.733265] hub 5-0:1.0: USB hub found
[    0.733271] hub 5-0:1.0: 3 ports detected
[    0.733358] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.733365] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.733371] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.733382] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.788219] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.788220] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.788222] usb usb6: Product: OHCI Host Controller
[    0.788223] usb usb6: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.788224] usb usb6: SerialNumber: 0000:00:13.1
[    0.788253] usb usb6: configuration #1 chosen from 1 choice
[    0.788265] hub 6-0:1.0: USB hub found
[    0.788272] hub 6-0:1.0: 3 ports detected
[    0.788362] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.788369] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.788375] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.788387] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    0.843216] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.843218] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.843219] usb usb7: Product: OHCI Host Controller
[    0.843220] usb usb7: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.843222] usb usb7: SerialNumber: 0000:00:14.5
[    0.843248] usb usb7: configuration #1 chosen from 1 choice
[    0.843261] hub 7-0:1.0: USB hub found
[    0.843267] hub 7-0:1.0: 2 ports detected
[    0.843312] Initializing USB Mass Storage driver...
[    0.843336] usbcore: registered new interface driver usb-storage
[    0.843338] USB Mass Storage support registered.
[    0.843355] usbcore: registered new interface driver libusual
[    0.843361] usbcore: registered new interface driver ums-alauda
[    0.843366] usbcore: registered new interface driver ums-cypress
[    0.843375] usbcore: registered new interface driver ums-datafab
[    0.843381] usbcore: registered new interface driver ums-freecom
[    0.843386] usbcore: registered new interface driver ums-isd200
[    0.843391] usbcore: registered new interface driver ums-jumpshot
[    0.843396] usbcore: registered new interface driver ums-karma
[    0.843402] usbcore: registered new interface driver ums-onetouch
[    0.843408] usbcore: registered new interface driver ums-sddr09
[    0.843413] usbcore: registered new interface driver ums-sddr55
[    0.843419] usbcore: registered new interface driver ums-usbat
[    0.843442] PNP: No PS/2 controller found. Probing ports directly.
[    0.843769] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.843773] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.843816] mice: PS/2 mouse device common for all mice
[    0.843826] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.843844] rtc_cmos 00:03: RTC can wake from S4
[    0.843863] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.843884] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.843895] cpuidle: using governor ladder
[    0.843896] cpuidle: using governor menu
[    0.844028] usbcore: registered new interface driver hiddev
[    0.844035] usbcore: registered new interface driver usbhid
[    0.844036] usbhid: v2.6:USB HID core driver
[    0.844211] TCP cubic registered
[    0.844274] NET: Registered protocol family 10
[    0.844532] lo: Disabled Privacy Extensions
[    0.844745] PM: Checking image partition UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7"
[    0.861213] ata5: SATA link down (SStatus 0 SControl 300)
[    0.861877] ata4: SATA link down (SStatus 0 SControl 300)
[    0.861903] ata6: SATA link down (SStatus 0 SControl 300)
[    0.861927] ata1: SATA link down (SStatus 0 SControl 300)
[    0.865870] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    0.984478] usb 1-3: New USB device found, idVendor=05e3, idProduct=0606
[    0.984480] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    0.984481] usb 1-3: Product: USB2.0 Hub
[    0.984512] usb 1-3: configuration #1 chosen from 1 choice
[    0.984888] hub 1-3:1.0: USB hub found
[    0.985343] hub 1-3:1.0: 4 ports detected
[    1.014188] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.015841] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.016178] ata2.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.016181] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.018192] ata3.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.018194] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.018217] ata2.00: configured for UDMA/133
[    1.020161] ata3.00: configured for UDMA/133
[    1.029913] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.030000] sd 1:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.030019] sd 1:0:0:0: [sda] Write Protect is off
[    1.030020] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.030030] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.030095]  sda:
[    1.031910] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.031973] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.032001] sd 2:0:0:0: [sdb] Write Protect is off
[    1.032002] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.032012] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.032074]  sdb: sda1 sda2
[    1.097229]  sdb1 sdb2
[    1.097333] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.097365] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.097367] PM: Resume from disk failed.
[    1.097370] registered taskstats version 1
[    1.097612]   Magic number: 5:29:220
[    1.097635] dmi id: hash matches
[    1.097660] rtc_cmos 00:03: setting system clock to 2009-12-13 08:13:21 UTC (1260692001)
[    1.097685] Freeing unused kernel memory: 416k freed
[    1.097760] Write protecting the kernel read-only data: 5040k
[    1.118759] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.118778] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.118826] scsi6 : pata_atiixp
[    1.118861] scsi7 : pata_atiixp
[    1.119887] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.119889] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.290679] ata7.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
[    1.296625] ata7.00: configured for UDMA/33
[    1.298109] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
[    1.302244] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.449321] usb 4-2: New USB device found, idVendor=046a, idProduct=0021
[    1.449324] usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.449365] usb 4-2: configuration #1 chosen from 1 choice
[    1.453857] processor LNXCPU:00: registered as cooling_device0
[    1.454257] processor LNXCPU:01: registered as cooling_device1
[    1.454594] processor LNXCPU:02: registered as cooling_device2
[    1.454935] processor LNXCPU:03: registered as cooling_device3
[    1.458332] udev: starting version 146
[    1.458337] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input0
[    1.458374] generic-usb 0003:046A:0021.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-2/input0
[    1.468258] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input1
[    1.468311] generic-usb 0003:046A:0021.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-2/input1
[    1.695625] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.847379] usb 4-3: New USB device found, idVendor=046d, idProduct=c521
[    1.847381] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.847383] usb 4-3: Product: USB Receiver
[    1.847384] usb 4-3: Manufacturer: Logitech
[    1.847441] usb 4-3: configuration #1 chosen from 1 choice
[    1.858503] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
[    1.858548] generic-usb 0003:046D:C521.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    1.869305] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
[    1.869363] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:12.1-3/input1
[    1.933244] usb 1-3.1: new high speed USB device using ehci_hcd and address 5
[    2.014482] usb 1-3.1: New USB device found, idVendor=058f, idProduct=6362
[    2.014484] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.014486] usb 1-3.1: Product: Mass Storage Device
[    2.014487] usb 1-3.1: Manufacturer: Generic
[    2.014488] usb 1-3.1: SerialNumber: 058F312D81B
[    2.014532] usb 1-3.1: configuration #1 chosen from 1 choice
[    2.014767] scsi8 : SCSI emulation for USB Mass Storage devices
[    2.014838] usb-storage: device found at 5
[    2.014839] usb-storage: waiting for device to settle before scanning
[    7.014982] usb-storage: device scan complete
[    7.016093] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    7.017212] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    7.018298] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    7.019337] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    7.417161] sd 8:0:0:2: [sde] Attached SCSI removable disk
[    7.418327] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[    7.419416] sd 8:0:0:1: [sdd] 3915072 512-byte logical blocks: (2.00 GB/1.86 GiB)
[    7.425892] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    7.429924] sd 8:0:0:1: [sdd] Write Protect is off
[    7.429926] sd 8:0:0:1: [sdd] Mode Sense: 03 00 00 00
[    7.429928] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.436920] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.436972]  sdd: sdd1 sdd2
[    7.441654] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.441706] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[    8.872119] EXT4-fs (sdd2): mounted filesystem with ordered data mode
[   12.501014] udev: starting version 146
[   12.838669] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   12.838688] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   12.838709] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[   12.838726] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   12.838742] sd 8:0:0:1: Attached scsi generic sg4 type 0
[   12.838761] sd 8:0:0:2: Attached scsi generic sg5 type 0
[   12.838779] sd 8:0:0:3: Attached scsi generic sg6 type 0
[   12.871910] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   12.871926] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.871978] r8169 0000:03:00.0: setting latency timer to 64
[   12.872021] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[   12.872373] eth0: RTL8168d/8111d at 0xffffc9001172c000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 27
[   12.872446] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[   12.872476] ACPI: Power Button [PWRB]
[   12.872506] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   12.872521] ACPI: Power Button [PWRF]
[   12.917262] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[   12.917342] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.058806] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   13.619915] sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
[   13.619917] Uniform CD-ROM driver Revision: 3.20
[   13.619977] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   13.733692] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   13.733698] firewire_ohci 0000:02:00.0: setting latency timer to 64
[   13.793232] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI version 1.10
[   13.825819] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.878756] ALSA sound/pci/hda/hda_codec.c:3881: autoconfig: line_outs=4 (0x1c/0x19/0x22/0x23/0x0)
[   13.878759] ALSA sound/pci/hda/hda_codec.c:3885:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.878761] ALSA sound/pci/hda/hda_codec.c:3889:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
[   13.878764] ALSA sound/pci/hda/hda_codec.c:3890:    mono: mono_out=0x0
[   13.878765] ALSA sound/pci/hda/hda_codec.c:3893:    dig-out=0x20/0x21
[   13.878767] ALSA sound/pci/hda/hda_codec.c:3901:    inputs: mic=0x1a, fmic=0x1e, line=0x1b, fline=0x0, cd=0x0, aux=0x0
[   13.880810] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.880835] HDA Intel 0000:01:05.1: setting latency timer to 64
[   14.173206] Adding 2097144k swap on /dev/sda1.  Priority:-1 extents:1 across:2097144k 
[   14.178782] Adding 2097144k swap on /dev/sdb1.  Priority:-2 extents:1 across:2097144k 
[   14.293289] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[   15.268805] device-mapper: uevent: version 1.0.3
[   15.269096] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   15.396107] md: md0 stopped.
[   15.396736] md: bind<sdb2>
[   15.396831] md: bind<sda2>
[   15.404997] md: raid0 personality registered for level 0
[   15.405141] raid0: looking at sda2
[   15.405143] raid0:   comparing sda2(308387392)
[   15.405144]  with sda2(308387392)
[   15.405145] raid0:   END
[   15.405146] raid0:   ==> UNIQUE
[   15.405146] raid0: 1 zones
[   15.405170] raid0: looking at sdb2
[   15.405171] raid0:   comparing sdb2(308387392)
[   15.405173]  with sda2(308387392)
[   15.405173] raid0:   EQUAL
[   15.405174] raid0: FINAL 1 zones
[   15.405176] raid0: done.
[   15.405177] raid0 : md_size is 616774784 sectors.
[   15.405178] ******* md0 configuration *********
[   15.405179] zone0=[sda2/sdb2/]
[   15.405181]         zone offset=0kb device offset=0kb size=308387392kb
[   15.405182] **********************************
[   15.405183] 
[   15.405188] md0: detected capacity change from 0 to 315788689408
[   15.406122]  md0: unknown partition table
[   21.677637] loop: module loaded
[   22.095573] EXT4-fs (dm-3): mounted filesystem with ordered data mode
[   22.123168] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[   22.143324] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[   22.173477] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[   22.307593] fuse init (API version 7.13)
[   24.174251] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor processors (4 cpu cores) (version 2.20.00)
[   24.174285] powernow-k8:    0 : pstate 0 (3000 MHz)
[   24.174286] powernow-k8:    1 : pstate 1 (2300 MHz)
[   24.174287] powernow-k8:    2 : pstate 2 (1800 MHz)
[   24.174288] powernow-k8:    3 : pstate 3 (800 MHz)
[   24.882886] r8169: eth0: link up
[   24.882895] r8169: eth0: link up
[   25.419199] Slow work thread pool: Starting up
[   25.419283] Slow work thread pool: Ready
[   28.214517] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   28.619211] it87: Found IT8712F chip at 0x290, revision 8
[   28.619223] it87: in3 is VCC (+5V)
[   28.619227] it87: in7 is VCCH (+5V Stand-By)
[   28.619562] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SIOE [0x290-0x2af]
[   28.619576] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   35.216333] eth0: no IPv6 routers present
[   69.209643] [drm] Initialized drm 1.1.0 20060810
[   69.588893] [drm] radeon defaulting to userspace modesetting.
[   69.589334] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   69.589338] pci 0000:01:05.0: setting latency timer to 64
[   69.589469] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
[   69.706932] [drm] Setting GART location based on new memory map
[   69.707052] [drm] Loading RS780 CP Microcode
[   69.707055] platform r600_cp.0: firmware: requesting radeon/RS780_pfp.bin
[   69.733296] platform r600_cp.0: firmware: requesting radeon/RS780_me.bin
[   69.786493] [drm] Resetting GPU
[   69.786553] [drm] writeback test succeeded in 1 usecs
