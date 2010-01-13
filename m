Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881Ab0AMGIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0AMGIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109Ab0AMGIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:08:54 -0500
Received: from jgarrett.org ([64.5.53.252]:48649 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0AMGIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:08:49 -0500
X-Greylist: delayed 1754 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 01:08:48 EST
Date: Tue, 12 Jan 2010 23:37:36 -0600
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
Subject: 2.6.33-rc3: pci host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100113053736.GA6720@jgarrett.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: jeff@jgarrett.org (Jeff Garrett)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Took a stab at getting the right emails.  If I missed anyone, sorry...

I have a desktop machine with a radeon HD 4850, and on recent kernels
the radeon driver has failed with the message "No valid linear
framebuffer address".  lspci on the broken configuration showed the
first memory region at d0000000 of the radeon card to be ignored.  dmesg
showed there to be a host bridge window at that address which was also
ignored.

I haven't quantified "recent" kernel.  I was using the Ubuntu/lucid
kernels and it broke in the 2.6.32-* timeline, at which point I switched
to vanilla 2.6.33-rc3 to see if that worked.  I could probably bisect it
in a day or two when I get a little time.

Following dmesg's instructions, setting pci=use_crs causes the region
not to be ignored, and my video works again.

I'm attaching a dmesg from the broken & working configurations, lspci
-vvv output from the working configuration, and the output of acpidump.

(Between the failed/working, I also applied the patch at
http://bugzilla.kernel.org/show_bug.cgi?id=14954
to get rid of the ACPI-parsing oops.  But that only fixed the oops.)

-Jeff Garrett

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.failed"

[    0.000000] Linux version 2.6.33-rc3 (root@korrek) (gcc version 4.4.3 20100108 (prerelease) (Ubuntu 4.4.2-9ubuntu1) ) #1 SMP Fri Jan 8 22:02:58 CST 2010
[    0.000000] Command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000340000000
[    0.000000]  0100000000 - 0340000000 page 2M
[    0.000000] kernel direct mapping tables up to 340000000 @ 19000-27000
[    0.000000] RAMDISK: 34914000 - 37feffde
[    0.000000] ACPI: RSDP 00000000000f9ce0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bf790000 00044 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790200 00084 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf790660 056A7 (v01  1AAAA 1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0008C (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790420 0003C (v01 DELL   OEMMCFG  20090415 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf790460 00176 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf7905e0 00080 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 00072 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf798660 00038 (v01 DELL   OEMHPET  20090415 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79f670 01298 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000340000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000340000000
[    0.000000]   NODE_DATA [0000000000022000 - 0000000000026fff]
[    0.000000]   bootmap [0000000000027000 -  000000000008efff] pages 68
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 0340000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001c05a58]    TEXT DATA BSS ==> [0001000000 - 0001c05a58]
[    0.000000]   #2 [0034914000 - 0037feffde]          RAMDISK ==> [0034914000 - 0037feffde]
[    0.000000]   #3 [0001c06000 - 0001c060fc]              BRK ==> [0001c06000 - 0001c060fc]
[    0.000000]   #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #6 [000009fc00 - 00000fcee0]    BIOS reserved ==> [000009fc00 - 00000fcee0]
[    0.000000]   #7 [00000fd074 - 00000ff780]    BIOS reserved ==> [00000fd074 - 00000ff780]
[    0.000000]   #8 [00000fcee0 - 00000fd074]     MP-table mpc ==> [00000fcee0 - 00000fd074]
[    0.000000]   #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #11 [0000016000 - 0000019000]          PGTABLE ==> [0000016000 - 0000019000]
[    0.000000]   #12 [0000019000 - 0000022000]          PGTABLE ==> [0000019000 - 0000022000]
[    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00340000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000] On node 0 totalpages: 3143456
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 114 pages reserved
[    0.000000]   DMA zone: 3814 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 32256 pages used for memmap
[    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s83608 r8192 d22888 u262144
[    0.000000] pcpu-alloc: s83608 r8192 d22888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096750
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 12266088k/13631488k available (4557k kernel code, 1057664k absent, 307736k reserved, 6285k data, 584k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2660.259 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.51 BogoMIPS (lpj=26602590)
[    0.000018] Security Framework initialized
[    0.000021] Smack:  Initializing.
[    0.000875] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.003781] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.005019] Mount-cache hash table entries: 256
[    0.005119] CPU: Physical Processor ID: 0
[    0.005120] CPU: Processor Core ID: 0
[    0.005125] mce: CPU supports 9 MCE banks
[    0.005133] CPU0: Thermal monitoring enabled (TM1)
[    0.005136] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.005143] using mwait in idle threads.
[    0.005144] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.005148] ... version:                3
[    0.005149] ... bit width:              48
[    0.005150] ... generic registers:      4
[    0.005151] ... value mask:             0000ffffffffffff
[    0.005152] ... max period:             000000007fffffff
[    0.005153] ... fixed-purpose events:   3
[    0.005154] ... event mask:             000000070000000f
[    0.005168] ACPI: Core revision 20091214
[    0.034232] Setting APIC routing to flat
[    0.034545] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.134311] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.278330] APIC calibration not consistent with PM-Timer: 129ms instead of 100ms
[    0.278332] APIC delta adjusted to PM-Timer: 831248 (1080618)
[    0.278421] Booting Node   0, Processors  #1
[    0.437949] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.458041]  #2
[    0.617494] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.637553]  #3
[    0.797040] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.817063] Brought up 4 CPUs
[    0.817065] Total of 4 processors activated (21280.23 BogoMIPS).
[    0.818386] regulator: core version 0.5
[    0.818408] Time: 21:49:30  Date: 01/09/10
[    0.818436] NET: Registered protocol family 16
[    0.818516] ACPI: bus type pci registered
[    0.818569] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.818571] PCI: not using MMCONFIG
[    0.818573] PCI: Using configuration type 1 for base access
[    0.819230] bio: create slab <bio-0> at 0
[    0.820048] ACPI: EC: Look up EC in DSDT
[    0.821938] ACPI: Executed 1 blocks of module-level executable AML code
[    0.828917] ACPI: SSDT 00000000bf79e0c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.829293] ACPI: SSDT 00000000bf79f100 003B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.829833] ACPI: SSDT 00000000bf79e4d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    0.830135] ACPI: SSDT 00000000bf79f4c0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    0.830674] ACPI: SSDT 00000000bf79e8e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
[    0.830978] ACPI: SSDT 00000000bf79f550 00085 (v01  PmRef  P003Cst 00003000 INTL 20051117)
[    0.831520] ACPI: SSDT 00000000bf79ecf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
[    0.831827] ACPI: SSDT 00000000bf79f5e0 00085 (v01  PmRef  P004Cst 00003000 INTL 20051117)
[    0.832297] ------------[ cut here ]------------
[    0.832303] WARNING: at mm/page_alloc.c:1812 __alloc_pages_nodemask+0x14c/0x5da()
[    0.832304] Hardware name: Studio XPS 435MT
[    0.832305] Modules linked in:
[    0.832308] Pid: 1, comm: swapper Not tainted 2.6.33-rc3 #1
[    0.832309] Call Trace:
[    0.832314]  [<ffffffff8103d596>] warn_slowpath_common+0x77/0x8f
[    0.832317]  [<ffffffff8103d5bd>] warn_slowpath_null+0xf/0x11
[    0.832319]  [<ffffffff810993b9>] __alloc_pages_nodemask+0x14c/0x5da
[    0.832323]  [<ffffffff810bcddd>] alloc_page_interleave+0x34/0x81
[    0.832325]  [<ffffffff810bce94>] alloc_pages_current+0x6a/0xb2
[    0.832330]  [<ffffffff81216f59>] ? acpi_ex_system_memory_space_handler+0x0/0x1df
[    0.832332]  [<ffffffff810988f0>] __get_free_pages+0x9/0x46
[    0.832335]  [<ffffffff810c3312>] __kmalloc+0x42/0x11d
[    0.832338]  [<ffffffff812129f9>] acpi_os_allocate+0x20/0x22
[    0.832340]  [<ffffffff81212b66>] acpi_ex_load_op+0xd8/0x260
[    0.832342]  [<ffffffff8121543e>] acpi_ex_opcode_1A_1T_0R+0x25/0x4b
[    0.832345]  [<ffffffff8120cbf0>] acpi_ds_exec_end_op+0xea/0x3d6
[    0.832348]  [<ffffffff8121f04b>] acpi_ps_parse_loop+0x7d9/0x95e
[    0.832350]  [<ffffffff8120d4b2>] ? acpi_ds_call_control_method+0x161/0x1cf
[    0.832352]  [<ffffffff8121e16d>] acpi_ps_parse_aml+0x9a/0x2b9
[    0.832355]  [<ffffffff8121f84a>] acpi_ps_execute_method+0x1c8/0x29a
[    0.832357]  [<ffffffff8121aabd>] acpi_ns_evaluate+0xe1/0x1a8
[    0.832359]  [<ffffffff8121a518>] acpi_evaluate_object+0xf9/0x1f2
[    0.832363]  [<ffffffff81058111>] ? spin_unlock_irqrestore+0x9/0xb
[    0.832366]  [<ffffffff81205ccf>] acpi_processor_set_pdc+0x1be/0x1e8
[    0.832369]  [<ffffffff81205d02>] early_init_pdc+0x9/0xf
[    0.832371]  [<ffffffff8121c5ea>] acpi_ns_walk_namespace+0xb9/0x187
[    0.832373]  [<ffffffff81205cf9>] ? early_init_pdc+0x0/0xf
[    0.832375]  [<ffffffff81205cf9>] ? early_init_pdc+0x0/0xf
[    0.832377]  [<ffffffff8121a35c>] acpi_walk_namespace+0x85/0xbf
[    0.832380]  [<ffffffff81205a8e>] acpi_early_processor_set_pdc+0x3a/0x3c
[    0.832383]  [<ffffffff81ad36e4>] acpi_bus_init+0xb5/0x1de
[    0.832386]  [<ffffffff811c41fb>] ? kobject_create_and_add+0x37/0x68
[    0.832388]  [<ffffffff81ad380d>] ? acpi_init+0x0/0x12f
[    0.832390]  [<ffffffff81ad380d>] ? acpi_init+0x0/0x12f
[    0.832392]  [<ffffffff81ad387e>] acpi_init+0x71/0x12f
[    0.832394]  [<ffffffff81ad380d>] ? acpi_init+0x0/0x12f
[    0.832398]  [<ffffffff810001ef>] do_one_initcall+0x59/0x149
[    0.832402]  [<ffffffff81aad64f>] kernel_init+0x147/0x19d
[    0.832404]  [<ffffffff81003694>] kernel_thread_helper+0x4/0x10
[    0.832407]  [<ffffffff81aad508>] ? kernel_init+0x0/0x19d
[    0.832409]  [<ffffffff81003690>] ? kernel_thread_helper+0x0/0x10
[    0.832413] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.832416] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P005._OSC] (Node ffff88033e4499a0), AE_NO_MEMORY
[    0.832439] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P005._PDC] (Node ffff88033e449980), AE_NO_MEMORY
[    0.832722] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P006._OSC] (Node ffff88033e449a20), AE_NO_MEMORY
[    0.832744] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P006._PDC] (Node ffff88033e449a00), AE_NO_MEMORY
[    0.833025] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P007._OSC] (Node ffff88033e449aa0), AE_NO_MEMORY
[    0.833047] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P007._PDC] (Node ffff88033e449a80), AE_NO_MEMORY
[    0.833327] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P008._OSC] (Node ffff88033e449b20), AE_NO_MEMORY
[    0.833349] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P008._PDC] (Node ffff88033e449b00), AE_NO_MEMORY
[    0.833384] ACPI: Interpreter enabled
[    0.833387] ACPI: (supports S0 S3 S4 S5)
[    0.833403] ACPI: Using IOAPIC for interrupt routing
[    0.833443] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.835028] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.847327] ACPI: No dock devices found.
[    0.847449] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.847470] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.847693] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.847695] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.847697] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.847699] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.847701] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
[    0.847703] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff] (ignored)
[    0.847752] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.847755] pci 0000:00:00.0: PME# disabled
[    0.847809] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.847812] pci 0000:00:01.0: PME# disabled
[    0.847864] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.847867] pci 0000:00:03.0: PME# disabled
[    0.847920] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.847923] pci 0000:00:07.0: PME# disabled
[    0.848025] IOH bus: [00, fb]
[    0.848026] IOH bus: 00 index 0 io port: [0, ffff]
[    0.848028] IOH bus: 00 index 1 mmio: [e0000000, fdffffff]
[    0.848198] pci 0000:00:19.0: reg 10: [mem 0xfbcc0000-0xfbcdffff]
[    0.848203] pci 0000:00:19.0: reg 14: [mem 0xfbcf4000-0xfbcf4fff]
[    0.848208] pci 0000:00:19.0: reg 18: [io  0xa080-0xa09f]
[    0.848242] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.848246] pci 0000:00:19.0: PME# disabled
[    0.848287] pci 0000:00:1a.0: reg 20: [io  0xa400-0xa41f]
[    0.848345] pci 0000:00:1a.1: reg 20: [io  0xa480-0xa49f]
[    0.848403] pci 0000:00:1a.2: reg 20: [io  0xa800-0xa81f]
[    0.848460] pci 0000:00:1a.7: reg 10: [mem 0xfbcf6000-0xfbcf63ff]
[    0.848509] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.848512] pci 0000:00:1a.7: PME# disabled
[    0.848542] pci 0000:00:1b.0: reg 10: [mem 0xfbcf8000-0xfbcfbfff 64bit]
[    0.848579] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.848582] pci 0000:00:1b.0: PME# disabled
[    0.848639] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.848642] pci 0000:00:1c.0: PME# disabled
[    0.848702] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.848705] pci 0000:00:1c.1: PME# disabled
[    0.848753] pci 0000:00:1d.0: reg 20: [io  0xa880-0xa89f]
[    0.848810] pci 0000:00:1d.1: reg 20: [io  0xac00-0xac1f]
[    0.848867] pci 0000:00:1d.2: reg 20: [io  0xb000-0xb01f]
[    0.848924] pci 0000:00:1d.7: reg 10: [mem 0xfbcfc000-0xfbcfc3ff]
[    0.848973] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.848976] pci 0000:00:1d.7: PME# disabled
[    0.849079] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.849082] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.849085] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.849129] pci 0000:00:1f.2: reg 10: [io  0xbc00-0xbc07]
[    0.849134] pci 0000:00:1f.2: reg 14: [io  0xb880-0xb883]
[    0.849139] pci 0000:00:1f.2: reg 18: [io  0xb800-0xb807]
[    0.849144] pci 0000:00:1f.2: reg 1c: [io  0xb480-0xb483]
[    0.849148] pci 0000:00:1f.2: reg 20: [io  0xb400-0xb40f]
[    0.849153] pci 0000:00:1f.2: reg 24: [io  0xb080-0xb08f]
[    0.849193] pci 0000:00:1f.3: reg 10: [mem 0xfbcffc00-0xfbcffcff 64bit]
[    0.849205] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.849238] pci 0000:00:1f.5: reg 10: [io  0xcc00-0xcc07]
[    0.849243] pci 0000:00:1f.5: reg 14: [io  0xc880-0xc883]
[    0.849247] pci 0000:00:1f.5: reg 18: [io  0xc800-0xc807]
[    0.849252] pci 0000:00:1f.5: reg 1c: [io  0xc480-0xc483]
[    0.849257] pci 0000:00:1f.5: reg 20: [io  0xc400-0xc40f]
[    0.849261] pci 0000:00:1f.5: reg 24: [io  0xc080-0xc08f]
[    0.849289] PCI: peer root bus 00 res updated from pci conf
[    0.849309] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.849334] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.849361] pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.849369] pci 0000:04:00.0: reg 18: [mem 0xfbee0000-0xfbeeffff 64bit]
[    0.849374] pci 0000:04:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.849381] pci 0000:04:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    0.849398] pci 0000:04:00.0: supports D1 D2
[    0.849423] pci 0000:04:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.849454] pci 0000:04:00.1: supports D1 D2
[    0.849481] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.849484] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.849487] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.849491] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.849523] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.849577] pci 0000:02:00.0: reg 10: [mem 0xfbdff800-0xfbdfffff 64bit]
[    0.849587] pci 0000:02:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.849653] pci 0000:02:00.0: supports D2
[    0.849654] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    0.849660] pci 0000:02:00.0: PME# disabled
[    0.849708] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.849712] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.849715] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.849761] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.849790] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.850093] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.850142] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.850198] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.850246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.850299] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.872262] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.872353] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.872440] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.872529] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.872618] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.872708] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.872797] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.872886] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.872963] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.872966] vgaarb: loaded
[    0.873033] SCSI subsystem initialized
[    0.873082] libata version 3.00 loaded.
[    0.873129] usbcore: registered new interface driver usbfs
[    0.873139] usbcore: registered new interface driver hub
[    0.873155] usbcore: registered new device driver usb
[    0.873234] ACPI: WMI: Mapper loaded
[    0.873236] PCI: Using ACPI for IRQ routing
[    0.873237] PCI: pci_cache_line_size set to 64 bytes
[    0.873240] pci 0000:00:07.0: no compatible bridge window for [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.873285] pci 0000:00:07.0: can't reserve window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.873324] pci 0000:04:00.0: no compatible bridge window for [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.873367] pci 0000:04:00.0: can't reserve [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.873465] Bluetooth: Core ver 2.15
[    0.873485] NET: Registered protocol family 31
[    0.873486] Bluetooth: HCI device and connection manager initialized
[    0.873488] Bluetooth: HCI socket layer initialized
[    0.873489] NetLabel: Initializing
[    0.873490] NetLabel:  domain hash size = 128
[    0.873491] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.873500] NetLabel:  unlabeled traffic allowed by default
[    0.873504] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.873508] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.873511] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.886894] Switching to clocksource tsc
[    0.888145] pnp: PnP ACPI init
[    0.888152] ACPI: bus type pnp registered
[    0.889767] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:04:00.0 BAR 0 [mem 0x00000000-0x0fffffff 64bit pref]
[    0.889770] pnp 00:0d: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:04:00.0 BAR 0 [mem 0x00000000-0x0fffffff 64bit pref]
[    0.889773] pnp 00:0d: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:04:00.0 BAR 0 [mem 0x00000000-0x0fffffff 64bit pref]
[    0.889776] pnp 00:0d: disabling [mem 0x00100000-0xbfffffff] because it overlaps 0000:04:00.0 BAR 0 [mem 0x00000000-0x0fffffff 64bit pref]
[    0.890041] pnp: PnP ACPI: found 14 devices
[    0.890042] ACPI: ACPI bus type pnp unregistered
[    0.890051] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.890053] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.890055] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.890057] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.890060] system 00:01: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.890062] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.890066] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    0.890068] system 00:06: [io  0x0a10-0x0a1f] has been reserved
[    0.890070] system 00:06: [io  0x0a20-0x0a2f] has been reserved
[    0.890072] system 00:06: [io  0x0a30-0x0a3f] has been reserved
[    0.890076] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.890078] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.890080] system 00:07: [io  0x0500-0x057f] could not be reserved
[    0.890082] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.890085] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.890087] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.890091] system 00:0a: [mem 0xffc00000-0xffefffff] has been reserved
[    0.890094] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.890097] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.890100] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.890104] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.894785] pci 0000:00:07.0: BAR 15: can't assign mem pref (size 0x10000000)
[    0.894788] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf01fffff]
[    0.894790] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.894792] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.894795] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.894797] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.894798] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.894801] pci 0000:00:01.0:   bridge window [mem disabled]
[    0.894804] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.894808] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.894809] pci 0000:00:03.0:   bridge window [io  disabled]
[    0.894812] pci 0000:00:03.0:   bridge window [mem disabled]
[    0.894815] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    0.894820] pci 0000:04:00.0: BAR 0: can't assign mem pref (size 0x10000000)
[    0.894822] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.894824] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.894827] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.894830] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.894834] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.894837] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.894841] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.894844] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.894849] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.894851] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.894855] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.894859] pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.894863] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.894865] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.894868] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.894871] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.894881] pci 0000:00:01.0: setting latency timer to 64
[    0.894888] pci 0000:00:03.0: setting latency timer to 64
[    0.894894] pci 0000:00:07.0: setting latency timer to 64
[    0.894900] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.894903]   alloc irq_desc for 17 on node -1
[    0.894904]   alloc kstat_irqs on node -1
[    0.894909] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.894912] pci 0000:00:1c.0: setting latency timer to 64
[    0.894918]   alloc irq_desc for 16 on node -1
[    0.894919]   alloc kstat_irqs on node -1
[    0.894922] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.894925] pci 0000:00:1c.1: setting latency timer to 64
[    0.894930] pci 0000:00:1e.0: setting latency timer to 64
[    0.894932] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.894934] pci_bus 0000:00: resource 1 [mem 0xe0000000-0xfdffffff]
[    0.894936] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.894938] pci_bus 0000:04: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.894939] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.894941] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf01fffff]
[    0.894943] pci_bus 0000:03: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.894944] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.894946] pci_bus 0000:02: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.894948] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.894950] pci_bus 0000:01: resource 3 [io  0x0000-0xffff]
[    0.894951] pci_bus 0000:01: resource 4 [mem 0xe0000000-0xfdffffff]
[    0.894966] NET: Registered protocol family 2
[    0.895225] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.896138] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.897381] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.897518] TCP: Hash tables configured (established 524288 bind 65536)
[    0.897519] TCP reno registered
[    0.897537] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.897597] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.897714] NET: Registered protocol family 1
[    0.897871] pci 0000:04:00.0: Boot video device
[    0.897879] PCI: CLS 64 bytes, default 64
[    0.897914] Trying to unpack rootfs image as initramfs...
[    1.836810] Freeing initrd memory: 56175k freed
[    1.844531] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.844534] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    1.844536] software IO TLB at phys 0x20000000 - 0x24000000
[    1.844798] Scanning for low memory corruption every 60 seconds
[    1.845418] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.846390] VFS: Disk quotas dquot_6.5.2
[    1.846424] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.846822] fuse init (API version 7.13)
[    1.846876] msgmni has been set to 24066
[    1.847031] alg: No test for stdrng (krng)
[    1.847069] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.847071] io scheduler noop registered
[    1.847072] io scheduler deadline registered
[    1.847114] io scheduler cfq registered (default)
[    1.847191] pcieport 0000:00:01.0: setting latency timer to 64
[    1.847216]   alloc irq_desc for 24 on node -1
[    1.847217]   alloc kstat_irqs on node -1
[    1.847224] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.847274] pcieport 0000:00:03.0: setting latency timer to 64
[    1.847297]   alloc irq_desc for 25 on node -1
[    1.847298]   alloc kstat_irqs on node -1
[    1.847303] pcieport 0000:00:03.0: irq 25 for MSI/MSI-X
[    1.847350] pcieport 0000:00:07.0: setting latency timer to 64
[    1.847373]   alloc irq_desc for 26 on node -1
[    1.847374]   alloc kstat_irqs on node -1
[    1.847379] pcieport 0000:00:07.0: irq 26 for MSI/MSI-X
[    1.847430] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.847456]   alloc irq_desc for 27 on node -1
[    1.847458]   alloc kstat_irqs on node -1
[    1.847463] pcieport 0000:00:1c.0: irq 27 for MSI/MSI-X
[    1.847520] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.847546]   alloc irq_desc for 28 on node -1
[    1.847547]   alloc kstat_irqs on node -1
[    1.847553] pcieport 0000:00:1c.1: irq 28 for MSI/MSI-X
[    1.847617] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.847622] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.847626] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.847639] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.847692] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.847794] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.847797] ACPI: Power Button [PWRB]
[    1.847831] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.847833] ACPI: Power Button [PWRF]
[    1.848456] Monitor-Mwait will be used to enter C-1 state
[    1.848472] Monitor-Mwait will be used to enter C-2 state
[    1.848485] Monitor-Mwait will be used to enter C-3 state
[    1.852175] Linux agpgart interface v0.103
[    1.852200] [drm] Initialized drm 1.1.0 20060810
[    1.852210] [drm] radeon defaulting to userspace modesetting.
[    1.852603] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.852607] pci 0000:04:00.0: setting latency timer to 64
[    1.852673] [drm] Initialized radeon 1.31.0 20080528 for 0000:04:00.0 on minor 0
[    1.852836] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.853675] brd: module loaded
[    1.853982] loop: module loaded
[    1.854032] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.854104] ata_piix 0000:00:1f.2: version 2.13
[    1.854112]   alloc irq_desc for 19 on node -1
[    1.854113]   alloc kstat_irqs on node -1
[    1.854117] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.854121] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.854149] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.854184] scsi0 : ata_piix
[    1.854227] scsi1 : ata_piix
[    1.855645] ata1: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    1.855650] ata2: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    1.855665] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.855669] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.855692] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.855714] scsi2 : ata_piix
[    1.855747] scsi3 : ata_piix
[    1.856813] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    1.856816] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    1.857349] Fixed MDIO Bus: probed
[    1.857373] PPP generic driver version 2.4.2
[    1.857419] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.857432]   alloc irq_desc for 18 on node -1
[    1.857434]   alloc kstat_irqs on node -1
[    1.857438] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.857447] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.857449] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.857486] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.857506] ehci_hcd 0000:00:1a.7: debug port 1
[    1.861377] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.861386] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbcf6000
[    1.884549] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.884650] hub 1-0:1.0: USB hub found
[    1.884653] hub 1-0:1.0: 6 ports detected
[    1.884697]   alloc irq_desc for 23 on node -1
[    1.884698]   alloc kstat_irqs on node -1
[    1.884702] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.884711] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.884713] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.884733] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.884751] ehci_hcd 0000:00:1d.7: debug port 1
[    1.888621] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.888630] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbcfc000
[    1.904496] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.904585] hub 2-0:1.0: USB hub found
[    1.904588] hub 2-0:1.0: 6 ports detected
[    1.904629] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.904639] uhci_hcd: USB Universal Host Controller Interface driver
[    1.904673] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.904678] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.904680] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.904702] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.904729] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a400
[    1.904794] hub 3-0:1.0: USB hub found
[    1.904797] hub 3-0:1.0: 2 ports detected
[    1.904828]   alloc irq_desc for 21 on node -1
[    1.904829]   alloc kstat_irqs on node -1
[    1.904833] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.904837] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.904840] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.904859] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.904885] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a480
[    1.904948] hub 4-0:1.0: USB hub found
[    1.904951] hub 4-0:1.0: 2 ports detected
[    1.904980] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.904985] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.904987] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.905007] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.905028] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a800
[    1.905092] hub 5-0:1.0: USB hub found
[    1.905094] hub 5-0:1.0: 2 ports detected
[    1.905125] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.905129] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.905132] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.905153] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.905176] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a880
[    1.905239] hub 6-0:1.0: USB hub found
[    1.905241] hub 6-0:1.0: 2 ports detected
[    1.905271] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.905276] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.905278] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.905302] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.905323] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ac00
[    1.905391] hub 7-0:1.0: USB hub found
[    1.905393] hub 7-0:1.0: 2 ports detected
[    1.905424] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.905428] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.905430] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.905449] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.905469] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b000
[    1.905532] hub 8-0:1.0: USB hub found
[    1.905534] hub 8-0:1.0: 2 ports detected
[    1.905595] PNP: No PS/2 controller found. Probing ports directly.
[    1.905932] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.905938] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.905977] mice: PS/2 mouse device common for all mice
[    1.906016] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    1.906033] rtc_cmos 00:03: RTC can wake from S4
[    1.906054] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.906076] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.906156] device-mapper: uevent: version 1.0.3
[    1.906208] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    1.906260] device-mapper: multipath: version 1.1.1 loaded
[    1.906262] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.906429] cpuidle: using governor ladder
[    1.906558] cpuidle: using governor menu
[    1.906580] oprofile: using NMI interrupt.
[    1.906761] TCP cubic registered
[    1.906859] NET: Registered protocol family 10
[    1.907140] lo: Disabled Privacy Extensions
[    1.907285] NET: Registered protocol family 17
[    1.907295] Bluetooth: L2CAP ver 2.14
[    1.907296] Bluetooth: L2CAP socket layer initialized
[    1.907298] Bluetooth: SCO (Voice Link) ver 0.6
[    1.907299] Bluetooth: SCO socket layer initialized
[    1.907316] Bluetooth: RFCOMM TTY layer initialized
[    1.907318] Bluetooth: RFCOMM socket layer initialized
[    1.907319] Bluetooth: RFCOMM ver 1.11
[    1.908663] PM: Resume from disk failed.
[    1.908933]   Magic number: 10:659:853
[    1.909021] rtc_cmos 00:03: setting system clock to 2010-01-09 21:49:32 UTC (1263073772)
[    1.909023] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.909024] EDD information not available.
[    2.214631] ata3: SATA link down (SStatus 0 SControl 300)
[    2.225391] ata4: SATA link down (SStatus 0 SControl 300)
[    2.393379] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    2.712671] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.712688] ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.722637] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.722651] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.722663] ata2.01: link offline, clearing class 3 to NONE
[    2.742760] ata2.00: ATAPI: TSSTcorpDVD-ROM TS-H353B, D700, max UDMA/33
[    2.752957] ata1.00: ATA-7: Hitachi HUA721010KLA330, GKAOA9RA, max UDMA/133
[    2.752961] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.752999] ata1.01: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    2.772470] usb 2-2: new high speed USB device using ehci_hcd and address 3
[    2.782687] ata2.00: configured for UDMA/33
[    2.794168] ata1.00: configured for UDMA/133
[    2.832648] ata1.01: configured for UDMA/100
[    2.833109] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    2.833243] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.833921] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.834645] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    2.834684] sd 0:0:0:0: [sda] Write Protect is off
[    2.834688] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.834714] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.836512] sr0: scsi3-mmc drive: 125x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.836515] Uniform CD-ROM driver Revision: 3.20
[    2.836604] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    2.836606]  sda:
[    2.836653] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.837946] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD-ROM TS-H353B D700 PQ: 0 ANSI: 5
[    2.843730] sr1: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
[    2.843819] sr 1:0:0:0: Attached scsi CD-ROM sr1
[    2.843861] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    2.846478]  sda1 sda2 < sda5 >
[    2.866077] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.866120] Freeing unused kernel memory: 584k freed
[    2.866209] Write protecting the kernel read-only data: 10240k
[    2.866655] Freeing unused kernel memory: 1564k freed
[    2.867071] Freeing unused kernel memory: 1508k freed
[    2.925997] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    2.925999] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    2.926033]   alloc irq_desc for 20 on node -1
[    2.926034]   alloc kstat_irqs on node -1
[    2.926039] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.926045] e1000e 0000:00:19.0: setting latency timer to 64
[    2.926140]   alloc irq_desc for 29 on node -1
[    2.926141]   alloc kstat_irqs on node -1
[    2.926148] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    2.929718] Initializing USB Mass Storage driver...
[    2.931772] ohci1394 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.931779] ohci1394 0000:02:00.0: setting latency timer to 64
[    2.931842] scsi4 : usb-storage 1-4:1.0
[    2.931899] usbcore: registered new interface driver usb-storage
[    2.931901] USB Mass Storage support registered.
[    2.933144] hub 2-2:1.0: USB hub found
[    2.933232] hub 2-2:1.0: 2 ports detected
[    2.985850] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fbdff800-fbdfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.067169] EXT3-fs (sda1): recovery required on readonly filesystem
[    3.067174] EXT3-fs (sda1): write access will be enabled during recovery
[    3.211408] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    3.247963] kjournald starting.  Commit interval 5 seconds
[    3.247973] EXT3-fs (sda1): orphan cleanup on readonly fs
[    3.247980] ext3_orphan_cleanup: deleting unreferenced inode 37920784
[    3.248005] ext3_orphan_cleanup: deleting unreferenced inode 37896199
[    3.248015] ext3_orphan_cleanup: deleting unreferenced inode 37896197
[    3.248022] ext3_orphan_cleanup: deleting unreferenced inode 37896196
[    3.248028] ext3_orphan_cleanup: deleting unreferenced inode 37896195
[    3.248034] ext3_orphan_cleanup: deleting unreferenced inode 37896194
[    3.248039] EXT3-fs (sda1): 6 orphan inodes deleted
[    3.248042] EXT3-fs (sda1): recovery complete
[    3.254172] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    3.463331] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:e8:08:87:ea
[    3.463334] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.463356] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    3.670934] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    3.855141] hub 4-1:1.0: USB hub found
[    3.857103] hub 4-1:1.0: 3 ports detected
[    4.139205] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    4.300221] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0024e880000887ea]
[    4.459114] usb 2-2.1: new high speed USB device using ehci_hcd and address 4
[    4.569367] hub 2-2.1:1.0: USB hub found
[    4.569465] hub 2-2.1:1.0: 4 ports detected
[    4.650147] usb 4-1.1: new full speed USB device using uhci_hcd and address 3
[    4.868604] usb 4-1.2: new full speed USB device using uhci_hcd and address 4
[    5.098039] usb 4-1.3: new full speed USB device using uhci_hcd and address 5
[    5.346431] usb 2-2.1.1: new high speed USB device using ehci_hcd and address 5
[    5.546028] scsi5 : usb-storage 2-2.1.1:1.0
[    7.920555] scsi 4:0:0:0: Direct-Access     DELL     USB   HS-CF Card 7.08 PQ: 0 ANSI: 0
[    7.924403] scsi 4:0:0:1: Direct-Access     DELL     USB   HS-xD/SM   7.08 PQ: 0 ANSI: 0
[    7.928019] scsi 4:0:0:2: Direct-Access     DELL     USB   HS-MS Card 7.08 PQ: 0 ANSI: 0
[    7.931268] scsi 4:0:0:3: Direct-Access     DELL     USB   HS-SD Card 7.08 PQ: 0 ANSI: 0
[    7.931920] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    7.932054] sd 4:0:0:1: Attached scsi generic sg4 type 0
[    7.932186] sd 4:0:0:2: Attached scsi generic sg5 type 0
[    7.932314] sd 4:0:0:3: Attached scsi generic sg6 type 0
[    7.944324] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    7.957312] sd 4:0:0:1: [sdc] Attached SCSI removable disk
[    7.961808] sd 4:0:0:2: [sdd] Attached SCSI removable disk
[    7.965911] sd 4:0:0:3: [sde] Attached SCSI removable disk
[   10.543965] scsi 5:0:0:0: Direct-Access     Generic  Flash HS-CF      5.39 PQ: 0 ANSI: 0
[   10.547208] scsi 5:0:0:1: Direct-Access     Generic  Flash HS-COMBO   5.39 PQ: 0 ANSI: 0
[   10.547595] sd 5:0:0:0: Attached scsi generic sg7 type 0
[   10.547734] sd 5:0:0:1: Attached scsi generic sg8 type 0
[   10.559311] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[   10.563300] sd 5:0:0:1: [sdg] Attached SCSI removable disk
[   13.028822] udev: starting version 149
[   13.062673] Adding 36041788k swap on /dev/sda5.  Priority:-1 extents:1 across:36041788k 
[   13.178784] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   13.238560] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   13.240361] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.073139] EXT3-fs (sda1): using internal journal
[   14.083315] lp: driver loaded but no devices found
[   14.281734] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   14.281825] usbcore: registered new interface driver btusb
[   14.327179] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   14.450858] usbcore: registered new interface driver hiddev
[   14.465922] input: DELL DELL USB Laser Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[   14.466004] generic-usb 0003:046D:C063.0001: input,hidraw0: USB HID v1.10 Mouse [DELL DELL USB Laser Mouse] on usb-0000:00:1a.0-1/input0
[   14.496314] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[   14.496375] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input0
[   14.536105] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.1/input/input5
[   14.536161] generic-usb 0003:0D62:2106.0003: input,hidraw2: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input1
[   14.541866] input: Logitech BT Mini-Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.2/4-1.2:1.0/input/input6
[   14.541928] generic-usb 0003:046D:C718.0004: input,hidraw3: USB HID v1.11 Keyboard [Logitech BT Mini-Receiver] on usb-0000:00:1a.1-1.2/input0
[   14.551065] input: Logitech BT Mini-Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.3/4-1.3:1.0/input/input7
[   14.551181] generic-usb 0003:046D:C719.0005: input,hiddev96,hidraw4: USB HID v1.11 Mouse [Logitech BT Mini-Receiver] on usb-0000:00:1a.1-1.3/input0
[   14.551214] usbcore: registered new interface driver usbhid
[   14.551217] usbhid: USB HID core driver
[   14.865808]   alloc irq_desc for 22 on node -1
[   14.865812]   alloc kstat_irqs on node -1
[   14.865820] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   14.865976]   alloc irq_desc for 30 on node -1
[   14.865978]   alloc kstat_irqs on node -1
[   14.865988] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   14.866014] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.025815] hda_codec: ALC1200: BIOS auto-probing.
[   15.027263] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   15.032223] HDA Intel 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.032297]   alloc irq_desc for 31 on node -1
[   15.032300]   alloc kstat_irqs on node -1
[   15.032310] HDA Intel 0000:04:00.1: irq 31 for MSI/MSI-X
[   15.032334] HDA Intel 0000:04:00.1: setting latency timer to 64
[   16.173892] mv[3409]: segfault at 7ffe5171dd78 ip 00007fdfbfcf5305 sp 00007ffe5171dd80 error 6 in libattr.so.1.1.0[7fdfbfcf3000+4000]
[   16.322519] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   16.324289] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.817869] Xorg[3608]: segfault at 88 ip 0000000000467ab4 sp 00007fff01154ce0 error 4 in Xorg[400000+1bb000]
[   17.817882] Process 3608(Xorg) has RLIMIT_CORE set to 0
[   17.817884] Aborting core
[   18.003201] Xorg[3700]: segfault at 88 ip 0000000000467ab4 sp 00007fffdabe1320 error 4 in Xorg[400000+1bb000]
[   18.003209] Process 3700(Xorg) has RLIMIT_CORE set to 0
[   18.003210] Aborting core
[   18.452339] Xorg[3811]: segfault at 88 ip 0000000000467ab4 sp 00007fff6c618b20 error 4 in Xorg[400000+1bb000]
[   18.452347] Process 3811(Xorg) has RLIMIT_CORE set to 0
[   18.452348] Aborting core
[   18.504405] Xorg[3858]: segfault at 88 ip 0000000000467ab4 sp 00007fff72d3ca60 error 4 in Xorg[400000+1bb000]
[   18.504414] Process 3858(Xorg) has RLIMIT_CORE set to 0
[   18.504415] Aborting core
[   18.549406] Xorg[3863]: segfault at 88 ip 0000000000467ab4 sp 00007fff0d03d860 error 4 in Xorg[400000+1bb000]
[   18.549414] Process 3863(Xorg) has RLIMIT_CORE set to 0
[   18.549415] Aborting core
[   18.596873] Xorg[3870]: segfault at 88 ip 0000000000467ab4 sp 00007fff71859a20 error 4 in Xorg[400000+1bb000]
[   18.596886] Process 3870(Xorg) has RLIMIT_CORE set to 0
[   18.596888] Aborting core
[   18.649221] RPC: Registered udp transport module.
[   18.649224] RPC: Registered tcp transport module.
[   18.649226] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   20.201270] svc: failed to register lockdv1 RPC service (errno 97).
[   22.118310] CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
[   23.738305] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   23.738309] Bluetooth: BNEP filters: protocol multicast
[   24.087451] Bridge firewalling registered
[   25.882159] ppdev: user-space parallel port driver
[   26.788207] eth0: no IPv6 routers present
[   27.023922] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   27.023927] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   27.023932] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   27.023939] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   27.023947] end_request: I/O error, dev sr0, sector 15853096
[   27.023951] Buffer I/O error on device sr0, logical block 3963274
[   27.023955] Buffer I/O error on device sr0, logical block 3963275
[   27.040887] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   27.040892] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   27.040896] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   27.040902] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   27.040910] end_request: I/O error, dev sr0, sector 15853096
[   27.040913] Buffer I/O error on device sr0, logical block 3963274
[   27.040917] Buffer I/O error on device sr0, logical block 3963275
[   27.115980] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   27.115985] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   27.115989] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   27.115995] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   27.116003] end_request: I/O error, dev sr0, sector 15853096
[   27.116006] Buffer I/O error on device sr0, logical block 3963274
[   27.116009] Buffer I/O error on device sr0, logical block 3963275
[   29.116220] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   29.116912] input: Logitech MX5000 Keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.1/4-1.1:1.0/bluetooth/hci0/hci0:11/input9
[   29.116980] generic-bluetooth 0005:046D:B305.0006: input,hidraw5: BLUETOOTH HID v45.03 Keyboard [Logitech MX5000 Keyboard] on 00:1E:4C:CC:9F:99
[   30.394092] Xorg[5169]: segfault at 0 ip 00007f609fb82191 sp 00007fff965d3768 error 4 in libc-2.11.1.so[7f609fb3d000+175000]
[   30.394100] Process 5169(Xorg) has RLIMIT_CORE set to 0
[   30.394101] Aborting core
[   40.086093] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   53.956793] UDF-fs: Partition marked readonly; forcing readonly mount
[   54.003981] UDF-fs INFO UDF: Mounting volume 'NCIS_SEASON_3', timestamp 2007/02/22 18:58 (1e98)
[   55.707283] input: Logitech MX1000 mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.1/4-1.1:1.0/bluetooth/hci0/hci0:12/input10
[   55.707380] generic-bluetooth 0005:046D:B003.0007: input,hidraw6: BLUETOOTH HID v43.20 Mouse [Logitech MX1000 mouse] on 00:1E:4C:CC:9F:99
[  771.332224] CE: hpet increasing min_delta_ns to 15000 nsec

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.working"

[    0.000000] Linux version 2.6.33-rc3 (root@korrek) (gcc version 4.4.3 20100108 (prerelease) (Ubuntu 4.4.2-9ubuntu1) ) #2 SMP Sun Jan 10 00:29:47 CST 2010
[    0.000000] Command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 pci=use_crs
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000340000000
[    0.000000]  0100000000 - 0340000000 page 2M
[    0.000000] kernel direct mapping tables up to 340000000 @ 19000-27000
[    0.000000] RAMDISK: 34914000 - 37fefb25
[    0.000000] ACPI: RSDP 00000000000f9ce0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bf790000 00044 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790200 00084 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf790660 056A7 (v01  1AAAA 1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0008C (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790420 0003C (v01 DELL   OEMMCFG  20090415 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf790460 00176 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf7905e0 00080 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 00072 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf798660 00038 (v01 DELL   OEMHPET  20090415 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79f670 01298 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000340000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000340000000
[    0.000000]   NODE_DATA [0000000000022000 - 0000000000026fff]
[    0.000000]   bootmap [0000000000027000 -  000000000008efff] pages 68
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 0340000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001c02e58]    TEXT DATA BSS ==> [0001000000 - 0001c02e58]
[    0.000000]   #2 [0034914000 - 0037fefb25]          RAMDISK ==> [0034914000 - 0037fefb25]
[    0.000000]   #3 [0001c03000 - 0001c030fc]              BRK ==> [0001c03000 - 0001c030fc]
[    0.000000]   #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #6 [000009fc00 - 00000fcee0]    BIOS reserved ==> [000009fc00 - 00000fcee0]
[    0.000000]   #7 [00000fd074 - 00000ff780]    BIOS reserved ==> [00000fd074 - 00000ff780]
[    0.000000]   #8 [00000fcee0 - 00000fd074]     MP-table mpc ==> [00000fcee0 - 00000fd074]
[    0.000000]   #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #11 [0000016000 - 0000019000]          PGTABLE ==> [0000016000 - 0000019000]
[    0.000000]   #12 [0000019000 - 0000022000]          PGTABLE ==> [0000019000 - 0000022000]
[    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00340000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000] On node 0 totalpages: 3143456
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 114 pages reserved
[    0.000000]   DMA zone: 3814 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 32256 pages used for memmap
[    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s83608 r8192 d22888 u262144
[    0.000000] pcpu-alloc: s83608 r8192 d22888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096750
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 pci=use_crs
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 12266100k/13631488k available (4554k kernel code, 1057664k absent, 307724k reserved, 6288k data, 576k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2660.045 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.09 BogoMIPS (lpj=26600450)
[    0.000019] Security Framework initialized
[    0.000021] Smack:  Initializing.
[    0.000873] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.003797] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.005040] Mount-cache hash table entries: 256
[    0.005141] CPU: Physical Processor ID: 0
[    0.005142] CPU: Processor Core ID: 0
[    0.005147] mce: CPU supports 9 MCE banks
[    0.005156] CPU0: Thermal monitoring enabled (TM1)
[    0.005159] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.005165] using mwait in idle threads.
[    0.005167] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.005170] ... version:                3
[    0.005171] ... bit width:              48
[    0.005172] ... generic registers:      4
[    0.005173] ... value mask:             0000ffffffffffff
[    0.005174] ... max period:             000000007fffffff
[    0.005175] ... fixed-purpose events:   3
[    0.005176] ... event mask:             000000070000000f
[    0.005190] ACPI: Core revision 20091214
[    0.034613] Setting APIC routing to flat
[    0.034931] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.134689] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.278332] APIC calibration not consistent with PM-Timer: 129ms instead of 100ms
[    0.278333] APIC delta adjusted to PM-Timer: 831248 (1080618)
[    0.278423] Booting Node   0, Processors  #1
[    0.437951] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.458027]  #2
[    0.617496] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.637619]  #3
[    0.797042] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.817027] Brought up 4 CPUs
[    0.817029] Total of 4 processors activated (21279.80 BogoMIPS).
[    0.818347] regulator: core version 0.5
[    0.818369] Time:  4:29:28  Date: 01/13/10
[    0.818397] NET: Registered protocol family 16
[    0.818477] ACPI: bus type pci registered
[    0.818530] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.818532] PCI: not using MMCONFIG
[    0.818533] PCI: Using configuration type 1 for base access
[    0.819194] bio: create slab <bio-0> at 0
[    0.820005] ACPI: EC: Look up EC in DSDT
[    0.821889] ACPI: Executed 1 blocks of module-level executable AML code
[    0.828446] ACPI: Interpreter enabled
[    0.828448] ACPI: (supports S0 S3 S4 S5)
[    0.828464] ACPI: Using IOAPIC for interrupt routing
[    0.828506] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.830087] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.843045] ACPI: No dock devices found.
[    0.843167] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.843412] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.843414] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.843416] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.843418] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.843420] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.843422] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.843471] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.843474] pci 0000:00:00.0: PME# disabled
[    0.843527] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.843530] pci 0000:00:01.0: PME# disabled
[    0.843582] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.843585] pci 0000:00:03.0: PME# disabled
[    0.843639] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.843641] pci 0000:00:07.0: PME# disabled
[    0.843743] IOH bus: [00, fb]
[    0.843744] IOH bus: 00 index 0 io port: [0, ffff]
[    0.843746] IOH bus: 00 index 1 mmio: [e0000000, fdffffff]
[    0.843915] pci 0000:00:19.0: reg 10: [mem 0xfbcc0000-0xfbcdffff]
[    0.843921] pci 0000:00:19.0: reg 14: [mem 0xfbcf4000-0xfbcf4fff]
[    0.843926] pci 0000:00:19.0: reg 18: [io  0xa080-0xa09f]
[    0.843960] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.843963] pci 0000:00:19.0: PME# disabled
[    0.844005] pci 0000:00:1a.0: reg 20: [io  0xa400-0xa41f]
[    0.844062] pci 0000:00:1a.1: reg 20: [io  0xa480-0xa49f]
[    0.844119] pci 0000:00:1a.2: reg 20: [io  0xa800-0xa81f]
[    0.844176] pci 0000:00:1a.7: reg 10: [mem 0xfbcf6000-0xfbcf63ff]
[    0.844225] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.844228] pci 0000:00:1a.7: PME# disabled
[    0.844258] pci 0000:00:1b.0: reg 10: [mem 0xfbcf8000-0xfbcfbfff 64bit]
[    0.844294] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.844297] pci 0000:00:1b.0: PME# disabled
[    0.844355] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.844358] pci 0000:00:1c.0: PME# disabled
[    0.844417] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.844420] pci 0000:00:1c.1: PME# disabled
[    0.844468] pci 0000:00:1d.0: reg 20: [io  0xa880-0xa89f]
[    0.844525] pci 0000:00:1d.1: reg 20: [io  0xac00-0xac1f]
[    0.844584] pci 0000:00:1d.2: reg 20: [io  0xb000-0xb01f]
[    0.844640] pci 0000:00:1d.7: reg 10: [mem 0xfbcfc000-0xfbcfc3ff]
[    0.844689] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.844693] pci 0000:00:1d.7: PME# disabled
[    0.844795] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.844798] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.844801] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.844845] pci 0000:00:1f.2: reg 10: [io  0xbc00-0xbc07]
[    0.844850] pci 0000:00:1f.2: reg 14: [io  0xb880-0xb883]
[    0.844855] pci 0000:00:1f.2: reg 18: [io  0xb800-0xb807]
[    0.844859] pci 0000:00:1f.2: reg 1c: [io  0xb480-0xb483]
[    0.844864] pci 0000:00:1f.2: reg 20: [io  0xb400-0xb40f]
[    0.844869] pci 0000:00:1f.2: reg 24: [io  0xb080-0xb08f]
[    0.844909] pci 0000:00:1f.3: reg 10: [mem 0xfbcffc00-0xfbcffcff 64bit]
[    0.844921] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.844954] pci 0000:00:1f.5: reg 10: [io  0xcc00-0xcc07]
[    0.844959] pci 0000:00:1f.5: reg 14: [io  0xc880-0xc883]
[    0.844963] pci 0000:00:1f.5: reg 18: [io  0xc800-0xc807]
[    0.844968] pci 0000:00:1f.5: reg 1c: [io  0xc480-0xc483]
[    0.844973] pci 0000:00:1f.5: reg 20: [io  0xc400-0xc40f]
[    0.844978] pci 0000:00:1f.5: reg 24: [io  0xc080-0xc08f]
[    0.845023] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.845049] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.845076] pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.845084] pci 0000:04:00.0: reg 18: [mem 0xfbee0000-0xfbeeffff 64bit]
[    0.845089] pci 0000:04:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.845096] pci 0000:04:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    0.845113] pci 0000:04:00.0: supports D1 D2
[    0.845138] pci 0000:04:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.845169] pci 0000:04:00.1: supports D1 D2
[    0.845196] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.845199] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.845202] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.845206] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.845238] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.845292] pci 0000:02:00.0: reg 10: [mem 0xfbdff800-0xfbdfffff 64bit]
[    0.845301] pci 0000:02:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.845367] pci 0000:02:00.0: supports D2
[    0.845369] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    0.845374] pci 0000:02:00.0: PME# disabled
[    0.845423] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.845426] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.845429] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.845475] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.845504] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.845804] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.845852] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.845908] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.845955] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.846008] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.867998] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.868088] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.868174] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.868263] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.868351] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.868439] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.868527] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.868615] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.868690] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.868693] vgaarb: loaded
[    0.868761] SCSI subsystem initialized
[    0.868811] libata version 3.00 loaded.
[    0.868855] usbcore: registered new interface driver usbfs
[    0.868866] usbcore: registered new interface driver hub
[    0.868880] usbcore: registered new device driver usb
[    0.868963] ACPI: WMI: Mapper loaded
[    0.868965] PCI: Using ACPI for IRQ routing
[    0.868966] PCI: pci_cache_line_size set to 64 bytes
[    0.869098] Bluetooth: Core ver 2.15
[    0.869119] NET: Registered protocol family 31
[    0.869120] Bluetooth: HCI device and connection manager initialized
[    0.869122] Bluetooth: HCI socket layer initialized
[    0.869123] NetLabel: Initializing
[    0.869124] NetLabel:  domain hash size = 128
[    0.869125] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.869134] NetLabel:  unlabeled traffic allowed by default
[    0.869138] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.869142] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.869146] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.886852] Switching to clocksource tsc
[    0.888140] pnp: PnP ACPI init
[    0.888146] ACPI: bus type pnp registered
[    0.890027] pnp: PnP ACPI: found 14 devices
[    0.890028] ACPI: ACPI bus type pnp unregistered
[    0.890035] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.890038] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.890040] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.890042] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.890044] system 00:01: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.890046] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.890051] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    0.890053] system 00:06: [io  0x0a10-0x0a1f] has been reserved
[    0.890055] system 00:06: [io  0x0a20-0x0a2f] has been reserved
[    0.890056] system 00:06: [io  0x0a30-0x0a3f] has been reserved
[    0.890060] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.890062] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.890064] system 00:07: [io  0x0500-0x057f] could not be reserved
[    0.890067] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.890069] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.890071] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.890075] system 00:0a: [mem 0xffc00000-0xffefffff] has been reserved
[    0.890079] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.890081] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.890084] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.890088] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.890090] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.890092] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.890095] system 00:0d: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.890097] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.894780] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.894782] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.894785] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.894787] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.894789] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.894790] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.894793] pci 0000:00:01.0:   bridge window [mem disabled]
[    0.894796] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.894800] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.894801] pci 0000:00:03.0:   bridge window [io  disabled]
[    0.894804] pci 0000:00:03.0:   bridge window [mem disabled]
[    0.894807] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    0.894811] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.894814] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.894817] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.894820] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.894825] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.894827] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.894831] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.894834] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.894839] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.894841] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.894845] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.894849] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.894853] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.894855] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.894858] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.894861] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.894872] pci 0000:00:01.0: setting latency timer to 64
[    0.894878] pci 0000:00:03.0: setting latency timer to 64
[    0.894884] pci 0000:00:07.0: setting latency timer to 64
[    0.894890] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.894893]   alloc irq_desc for 17 on node -1
[    0.894895]   alloc kstat_irqs on node -1
[    0.894899] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.894902] pci 0000:00:1c.0: setting latency timer to 64
[    0.894908]   alloc irq_desc for 16 on node -1
[    0.894909]   alloc kstat_irqs on node -1
[    0.894912] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.894915] pci 0000:00:1c.1: setting latency timer to 64
[    0.894920] pci 0000:00:1e.0: setting latency timer to 64
[    0.894923] pci_bus 0000:00: resource 0 [io  0x0000-0x0cf7]
[    0.894925] pci_bus 0000:00: resource 1 [io  0x0d00-0xffff]
[    0.894926] pci_bus 0000:00: resource 2 [mem 0x000a0000-0x000bffff]
[    0.894928] pci_bus 0000:00: resource 3 [mem 0x000d0000-0x000dffff]
[    0.894930] pci_bus 0000:00: resource 4 [mem 0xc0000000-0xdfffffff]
[    0.894931] pci_bus 0000:00: resource 5 [mem 0xf0000000-0xfed8ffff]
[    0.894933] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.894935] pci_bus 0000:04: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.894937] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.894939] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.894940] pci_bus 0000:03: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.894942] pci_bus 0000:03: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.894944] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.894945] pci_bus 0000:02: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.894947] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.894949] pci_bus 0000:01: resource 3 [io  0x0000-0x0cf7]
[    0.894950] pci_bus 0000:01: resource 4 [io  0x0d00-0xffff]
[    0.894952] pci_bus 0000:01: resource 5 [mem 0x000a0000-0x000bffff]
[    0.894954] pci_bus 0000:01: resource 6 [mem 0x000d0000-0x000dffff]
[    0.894955] pci_bus 0000:01: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.894957] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.894971] NET: Registered protocol family 2
[    0.895231] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.896136] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.897406] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.897534] TCP: Hash tables configured (established 524288 bind 65536)
[    0.897536] TCP reno registered
[    0.897554] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.897614] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.897730] NET: Registered protocol family 1
[    0.897888] pci 0000:04:00.0: Boot video device
[    0.897896] PCI: CLS 64 bytes, default 64
[    0.897930] Trying to unpack rootfs image as initramfs...
[    1.835623] Freeing initrd memory: 56174k freed
[    1.843343] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.843347] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    1.843349] software IO TLB at phys 0x20000000 - 0x24000000
[    1.843598] Scanning for low memory corruption every 60 seconds
[    1.844220] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.845209] VFS: Disk quotas dquot_6.5.2
[    1.845240] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.845638] fuse init (API version 7.13)
[    1.845692] msgmni has been set to 24066
[    1.845845] alg: No test for stdrng (krng)
[    1.845880] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.845883] io scheduler noop registered
[    1.845884] io scheduler deadline registered
[    1.845926] io scheduler cfq registered (default)
[    1.846004] pcieport 0000:00:01.0: setting latency timer to 64
[    1.846030]   alloc irq_desc for 24 on node -1
[    1.846031]   alloc kstat_irqs on node -1
[    1.846038] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.846087] pcieport 0000:00:03.0: setting latency timer to 64
[    1.846110]   alloc irq_desc for 25 on node -1
[    1.846112]   alloc kstat_irqs on node -1
[    1.846116] pcieport 0000:00:03.0: irq 25 for MSI/MSI-X
[    1.846163] pcieport 0000:00:07.0: setting latency timer to 64
[    1.846186]   alloc irq_desc for 26 on node -1
[    1.846187]   alloc kstat_irqs on node -1
[    1.846192] pcieport 0000:00:07.0: irq 26 for MSI/MSI-X
[    1.846243] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.846269]   alloc irq_desc for 27 on node -1
[    1.846270]   alloc kstat_irqs on node -1
[    1.846275] pcieport 0000:00:1c.0: irq 27 for MSI/MSI-X
[    1.846332] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.846358]   alloc irq_desc for 28 on node -1
[    1.846360]   alloc kstat_irqs on node -1
[    1.846365] pcieport 0000:00:1c.1: irq 28 for MSI/MSI-X
[    1.846427] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.846432] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.846436] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.846452] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.846504] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.846606] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.846608] ACPI: Power Button [PWRB]
[    1.846641] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.846643] ACPI: Power Button [PWRF]
[    1.849397] Linux agpgart interface v0.103
[    1.849422] [drm] Initialized drm 1.1.0 20060810
[    1.849431] [drm] radeon defaulting to userspace modesetting.
[    1.849826] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.849830] pci 0000:04:00.0: setting latency timer to 64
[    1.849898] [drm] Initialized radeon 1.31.0 20080528 for 0000:04:00.0 on minor 0
[    1.850062] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.850905] brd: module loaded
[    1.851214] loop: module loaded
[    1.851264] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.851334] ata_piix 0000:00:1f.2: version 2.13
[    1.851341]   alloc irq_desc for 19 on node -1
[    1.851343]   alloc kstat_irqs on node -1
[    1.851347] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.851350] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.851377] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.851415] scsi0 : ata_piix
[    1.851459] scsi1 : ata_piix
[    1.852860] ata1: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    1.852865] ata2: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    1.852879] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.852883] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.852907] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.852929] scsi2 : ata_piix
[    1.852960] scsi3 : ata_piix
[    1.854016] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    1.854019] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    1.854563] Fixed MDIO Bus: probed
[    1.854585] PPP generic driver version 2.4.2
[    1.854632] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.854646]   alloc irq_desc for 18 on node -1
[    1.854647]   alloc kstat_irqs on node -1
[    1.854651] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.854660] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.854663] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.854695] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.854715] ehci_hcd 0000:00:1a.7: debug port 1
[    1.858593] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.858602] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbcf6000
[    1.874475] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.874580] hub 1-0:1.0: USB hub found
[    1.874583] hub 1-0:1.0: 6 ports detected
[    1.874627]   alloc irq_desc for 23 on node -1
[    1.874629]   alloc kstat_irqs on node -1
[    1.874632] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.874641] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.874643] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.874665] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.874683] ehci_hcd 0000:00:1d.7: debug port 1
[    1.878561] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.878571] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbcfc000
[    1.894420] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.894510] hub 2-0:1.0: USB hub found
[    1.894513] hub 2-0:1.0: 6 ports detected
[    1.894553] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.894563] uhci_hcd: USB Universal Host Controller Interface driver
[    1.894596] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.894601] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.894603] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.894626] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.894652] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a400
[    1.894718] hub 3-0:1.0: USB hub found
[    1.894721] hub 3-0:1.0: 2 ports detected
[    1.894753]   alloc irq_desc for 21 on node -1
[    1.894754]   alloc kstat_irqs on node -1
[    1.894758] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.894762] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.894765] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.894784] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.894810] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a480
[    1.894874] hub 4-0:1.0: USB hub found
[    1.894877] hub 4-0:1.0: 2 ports detected
[    1.894906] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.894910] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.894913] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.894931] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.894952] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a800
[    1.895017] hub 5-0:1.0: USB hub found
[    1.895020] hub 5-0:1.0: 2 ports detected
[    1.895051] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.895056] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.895058] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.895078] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.895098] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a880
[    1.895163] hub 6-0:1.0: USB hub found
[    1.895165] hub 6-0:1.0: 2 ports detected
[    1.895196] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.895200] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.895202] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.895226] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.895246] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ac00
[    1.895313] hub 7-0:1.0: USB hub found
[    1.895315] hub 7-0:1.0: 2 ports detected
[    1.895346] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.895351] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.895353] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.895372] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.895392] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b000
[    1.895454] hub 8-0:1.0: USB hub found
[    1.895457] hub 8-0:1.0: 2 ports detected
[    1.895517] PNP: No PS/2 controller found. Probing ports directly.
[    1.895860] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.895864] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.895905] mice: PS/2 mouse device common for all mice
[    1.895945] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    1.895962] rtc_cmos 00:03: RTC can wake from S4
[    1.895981] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.896003] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.896082] device-mapper: uevent: version 1.0.3
[    1.896135] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    1.896190] device-mapper: multipath: version 1.1.1 loaded
[    1.896192] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.896281] cpuidle: using governor ladder
[    1.896282] cpuidle: using governor menu
[    1.896304] oprofile: using NMI interrupt.
[    1.896482] TCP cubic registered
[    1.896582] NET: Registered protocol family 10
[    1.896854] lo: Disabled Privacy Extensions
[    1.896996] NET: Registered protocol family 17
[    1.897006] Bluetooth: L2CAP ver 2.14
[    1.897007] Bluetooth: L2CAP socket layer initialized
[    1.897010] Bluetooth: SCO (Voice Link) ver 0.6
[    1.897011] Bluetooth: SCO socket layer initialized
[    1.897025] Bluetooth: RFCOMM TTY layer initialized
[    1.897027] Bluetooth: RFCOMM socket layer initialized
[    1.897028] Bluetooth: RFCOMM ver 1.11
[    1.897087] PM: Resume from disk failed.
[    1.897355]   Magic number: 10:292:464
[    1.897403] rtc_cmos 00:03: setting system clock to 2010-01-13 04:29:29 UTC (1263356969)
[    1.897405] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.897406] EDD information not available.
[    2.205663] ata3: SATA link down (SStatus 0 SControl 300)
[    2.216372] ata4: SATA link down (SStatus 0 SControl 300)
[    2.373231] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    2.703090] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.703105] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.703116] ata2.01: link offline, clearing class 3 to NONE
[    2.703285] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.703297] ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.722830] ata2.00: ATAPI: TSSTcorpDVD-ROM TS-H353B, D700, max UDMA/33
[    2.742739] ata1.00: ATA-7: Hitachi HUA721010KLA330, GKAOA9RA, max UDMA/133
[    2.742742] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.742773] ata1.01: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    2.752911] usb 2-2: new high speed USB device using ehci_hcd and address 3
[    2.763139] ata2.00: configured for UDMA/33
[    2.783259] ata1.00: configured for UDMA/133
[    2.822963] ata1.01: configured for UDMA/100
[    2.823400] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    2.823477] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.823507] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.824670] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    2.824688] sd 0:0:0:0: [sda] Write Protect is off
[    2.824692] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.824715] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.826368] sr0: scsi3-mmc drive: 125x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.826371] Uniform CD-ROM driver Revision: 3.20
[    2.826441]  sda:
[    2.826449] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    2.826475] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.827650] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD-ROM TS-H353B D700 PQ: 0 ANSI: 5
[    2.831888]  sda1 sda2 <sr1: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
[    2.833318] sr 1:0:0:0: Attached scsi CD-ROM sr1
[    2.833344] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    2.851219]  sda5 >
[    2.851418] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.851430] Freeing unused kernel memory: 576k freed
[    2.851510] Write protecting the kernel read-only data: 10240k
[    2.851714] Freeing unused kernel memory: 1568k freed
[    2.851999] Freeing unused kernel memory: 1512k freed
[    2.883277] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    2.883279] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    2.883314]   alloc irq_desc for 20 on node -1
[    2.883316]   alloc kstat_irqs on node -1
[    2.883321] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.883328] e1000e 0000:00:19.0: setting latency timer to 64
[    2.883397]   alloc irq_desc for 29 on node -1
[    2.883398]   alloc kstat_irqs on node -1
[    2.883405] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    2.896913] Initializing USB Mass Storage driver...
[    2.899308] ohci1394 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.899315] ohci1394 0000:02:00.0: setting latency timer to 64
[    2.901534] scsi4 : usb-storage 1-4:1.0
[    2.901590] usbcore: registered new interface driver usb-storage
[    2.901591] USB Mass Storage support registered.
[    2.903125] hub 2-2:1.0: USB hub found
[    2.903214] hub 2-2:1.0: 2 ports detected
[    2.953857] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fbdff800-fbdfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.078096] kjournald starting.  Commit interval 5 seconds
[    3.078108] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    3.181851] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    3.422958] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:e8:08:87:ea
[    3.422960] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.422980] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    3.721137] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    3.910872] hub 4-1:1.0: USB hub found
[    3.912840] hub 4-1:1.0: 3 ports detected
[    4.189969] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    4.279823] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0024e880000887ea]
[    4.509242] usb 2-2.1: new high speed USB device using ehci_hcd and address 4
[    4.619360] hub 2-2.1:1.0: USB hub found
[    4.619466] hub 2-2.1:1.0: 4 ports detected
[    4.699895] usb 4-1.1: new full speed USB device using uhci_hcd and address 3
[    4.958254] usb 4-1.2: new full speed USB device using uhci_hcd and address 4
[    5.228591] usb 4-1.3: new full speed USB device using uhci_hcd and address 5
[    5.315625] Adding 36041788k swap on /dev/sda5.  Priority:-1 extents:1 across:36041788k 
[    5.476232] usb 2-2.1.1: new high speed USB device using ehci_hcd and address 5
[    5.668934] EXT3-fs (sda1): using internal journal
[    5.674929] scsi5 : usb-storage 2-2.1.1:1.0
[    5.933464] udev: starting version 149
[    7.889758] scsi 4:0:0:0: Direct-Access     DELL     USB   HS-CF Card 7.08 PQ: 0 ANSI: 0
[    7.893368] scsi 4:0:0:1: Direct-Access     DELL     USB   HS-xD/SM   7.08 PQ: 0 ANSI: 0
[    7.896863] scsi 4:0:0:2: Direct-Access     DELL     USB   HS-MS Card 7.08 PQ: 0 ANSI: 0
[    7.900224] scsi 4:0:0:3: Direct-Access     DELL     USB   HS-SD Card 7.08 PQ: 0 ANSI: 0
[    7.900501] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    7.900577] sd 4:0:0:1: Attached scsi generic sg4 type 0
[    7.900660] sd 4:0:0:2: Attached scsi generic sg5 type 0
[    7.900744] sd 4:0:0:3: Attached scsi generic sg6 type 0
[    7.947973] sd 4:0:0:1: [sdc] Attached SCSI removable disk
[    7.956951] sd 4:0:0:2: [sdd] Attached SCSI removable disk
[    7.965429] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    7.969294] sd 4:0:0:3: [sde] Attached SCSI removable disk
[    8.787032] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    9.528725] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    9.528793] usbcore: registered new interface driver btusb
[    9.674282] usbcore: registered new interface driver hiddev
[    9.688538] input: DELL DELL USB Laser Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[    9.688592] generic-usb 0003:046D:C063.0001: input,hidraw0: USB HID v1.10 Mouse [DELL DELL USB Laser Mouse] on usb-0000:00:1a.0-1/input0
[    9.718918] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[    9.718958] generic-usb 0003:0D62:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input0
[    9.758759] input: USB Multimedia Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.1/input/input5
[    9.758798] generic-usb 0003:0D62:2106.0003: input,hidraw2: USB HID v1.10 Device [USB Multimedia Keyboard] on usb-0000:00:1d.0-1/input1
[    9.764503] input: Logitech BT Mini-Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.2/4-1.2:1.0/input/input6
[    9.764539] generic-usb 0003:046D:C718.0004: input,hidraw3: USB HID v1.11 Keyboard [Logitech BT Mini-Receiver] on usb-0000:00:1a.1-1.2/input0
[    9.773630] input: Logitech BT Mini-Receiver as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.3/4-1.3:1.0/input/input7
[    9.773702] generic-usb 0003:046D:C719.0005: input,hiddev96,hidraw4: USB HID v1.11 Mouse [Logitech BT Mini-Receiver] on usb-0000:00:1a.1-1.3/input0
[    9.773723] usbcore: registered new interface driver usbhid
[    9.773725] usbhid: USB HID core driver
[   10.214488] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   10.274230] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   10.275360] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.663664] scsi 5:0:0:0: Direct-Access     Generic  Flash HS-CF      5.39 PQ: 0 ANSI: 0
[   10.666898] scsi 5:0:0:1: Direct-Access     Generic  Flash HS-COMBO   5.39 PQ: 0 ANSI: 0
[   10.667172] sd 5:0:0:0: Attached scsi generic sg7 type 0
[   10.667249] sd 5:0:0:1: Attached scsi generic sg8 type 0
[   10.720632] lp: driver loaded but no devices found
[   10.744075] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[   10.748562] sd 5:0:0:1: [sdg] Attached SCSI removable disk
[   13.328081] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   13.329176] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.909031]   alloc irq_desc for 22 on node -1
[   14.909033]   alloc kstat_irqs on node -1
[   14.909039] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   14.909113]   alloc irq_desc for 30 on node -1
[   14.909114]   alloc kstat_irqs on node -1
[   14.909121] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   14.909142] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.226597] hda_codec: ALC1200: BIOS auto-probing.
[   15.228011] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   15.231931] HDA Intel 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.231975]   alloc irq_desc for 31 on node -1
[   15.231976]   alloc kstat_irqs on node -1
[   15.231983] HDA Intel 0000:04:00.1: irq 31 for MSI/MSI-X
[   15.232002] HDA Intel 0000:04:00.1: setting latency timer to 64
[   16.753711] mv[3654]: segfault at 7ffe5cb53df8 ip 00007f43fc2ee305 sp 00007ffe5cb53e00 error 6 in libattr.so.1.1.0[7f43fc2ec000+4000]
[   21.822187] RPC: Registered udp transport module.
[   21.822189] RPC: Registered tcp transport module.
[   21.822191] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   24.129925] eth0: no IPv6 routers present
[   24.261590] svc: failed to register lockdv1 RPC service (errno 97).
[   32.209451] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   32.209453] Bluetooth: BNEP filters: protocol multicast
[   32.638392] Bridge firewalling registered
[   35.803795] ppdev: user-space parallel port driver
[   37.186381] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   37.186387] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   37.186391] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   37.186398] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   37.186406] end_request: I/O error, dev sr0, sector 15853096
[   37.186410] Buffer I/O error on device sr0, logical block 3963274
[   37.186414] Buffer I/O error on device sr0, logical block 3963275
[   37.195266] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   37.195270] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   37.195274] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   37.195280] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   37.195287] end_request: I/O error, dev sr0, sector 15853096
[   37.195290] Buffer I/O error on device sr0, logical block 3963274
[   37.195294] Buffer I/O error on device sr0, logical block 3963275
[   37.278457] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   37.278461] sr 0:0:1:0: [sr0] Sense Key : Illegal Request [current] 
[   37.278465] sr 0:0:1:0: [sr0] Add. Sense: Read of scrambled sector without authentication
[   37.278471] sr 0:0:1:0: [sr0] CDB: Read(10): 28 00 00 3c 79 8a 00 00 02 00
[   37.278478] end_request: I/O error, dev sr0, sector 15853096
[   37.278482] Buffer I/O error on device sr0, logical block 3963274
[   37.278485] Buffer I/O error on device sr0, logical block 3963275
[   46.376354] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   60.815659] UDF-fs: Partition marked readonly; forcing readonly mount
[   60.867580] UDF-fs INFO UDF: Mounting volume 'NCIS_SEASON_3', timestamp 2007/02/22 18:58 (1e98)
[  223.344278] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  223.344560] input: Logitech MX1000 mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.1/4-1.1:1.0/bluetooth/hci0/hci0:11/input9
[  223.344624] generic-bluetooth 0005:046D:B003.0006: input,hidraw5: BLUETOOTH HID v43.20 Mouse [Logitech MX1000 mouse] on 00:1E:4C:CC:9F:99
[  327.681267] input: Logitech MX5000 Keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1.1/4-1.1:1.0/bluetooth/hci0/hci0:12/input10
[  327.681317] generic-bluetooth 0005:046D:B305.0007: input,hidraw6: BLUETOOTH HID v45.03 Keyboard [Logitech MX5000 Keyboard] on 00:1E:4C:CC:9F:99

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port (rev 12)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable-
		Address: 00000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 12)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
		Address: fee0f00c  Data: 4159
		Masking: 00000003  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 31, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 12)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
		Address: fee0f00c  Data: 4161
		Masking: 00000003  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 33, PowerLimit 25.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 12)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
		Address: fee0f00c  Data: 4169
		Masking: 00000003  Pending: 00000000
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot # 37, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [e0] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [150] Access Controls <?>
	Capabilities: [160] Vendor Specific Information <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0 (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [50] Vendor Specific Information <?>

00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0 (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
			ClockPM- Suprise+ LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 12)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit Network Connection
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at fbcc0000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at fbcf4000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at a080 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0f00c  Data: 41b9
	Capabilities: [e0] PCIe advanced features <?>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at a400 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at a480 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at a800 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20)
	Subsystem: Dell Device 02c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbcf6000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
	Subsystem: Dell Device 02c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 30
	Region 0: Memory at fbcf8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0f00c  Data: 41c9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 02c9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0f00c  Data: 4179
	Capabilities: [90] Subsystem: Dell Device 02c9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at a880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at ac00 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at b000 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20)
	Subsystem: Dell Device 02c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbcfc000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 02c9

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at bc00 [size=8]
	Region 1: I/O ports at b880 [size=4]
	Region 2: I/O ports at b800 [size=8]
	Region 3: I/O ports at b480 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Region 5: I/O ports at b080 [size=16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 15
	Region 0: Memory at fbcffc00 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0400 [size=32]
	Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller (prog-if 85 [Master SecO PriO])
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at c880 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at c480 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: I/O ports at c080 [size=16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. Device 3403 (prog-if 10)
	Subsystem: Dell Device 02c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at fbdff800 (64-bit, non-prefetchable) [size=2K]
	Region 2: I/O ports at d800 [size=256]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [98] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [130] Device Serial Number 00-00-00-ff-ff-a0-21-90
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394

04:00.0 VGA compatible controller: ATI Technologies Inc RV770 [Radeon HD 4850]
	Subsystem: Dell Device 0502
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at fbee0000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at e000 [size=256]
	Expansion ROM at fbec0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Vendor Specific Information <?>

04:00.1 Audio device: ATI Technologies Inc HD48x0 audio
	Subsystem: Dell Device aa30
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 31
	Region 0: Memory at fbefc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0f00c  Data: 41d1
	Capabilities: [100] Vendor Specific Information <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=acpidump

DSDT @ 0xbf790660
  0000: 44 53 44 54 a7 56 00 00 01 b7 31 41 41 41 41 00  DSDT.V....1AAAA.
  0010: 31 41 41 41 41 30 30 30 00 00 00 00 49 4e 54 4c  1AAAA000....INTL
  0020: 17 11 05 20 10 46 0b 5f 50 52 5f 5b 83 0b 50 30  ... .F._PR_[..P0
  0030: 30 31 01 10 08 00 00 06 06 50 30 30 31 43 50 55  01.......P001CPU
  0040: 31 5b 83 0b 50 30 30 32 02 00 00 00 00 00 06 50  1[..P002.......P
  0050: 30 30 32 43 50 55 32 5b 83 0b 50 30 30 33 03 00  002CPU2[..P003..
  0060: 00 00 00 00 06 50 30 30 33 43 50 55 33 5b 83 0b  .....P003CPU3[..
  0070: 50 30 30 34 04 00 00 00 00 00 06 50 30 30 34 43  P004.......P004C
  0080: 50 55 34 5b 83 0b 50 30 30 35 05 00 00 00 00 00  PU4[..P005......
  0090: 06 50 30 30 35 43 50 55 35 5b 83 0b 50 30 30 36  .P005CPU5[..P006
  00a0: 06 00 00 00 00 00 06 50 30 30 36 43 50 55 36 5b  .......P006CPU6[
  00b0: 83 0b 50 30 30 37 07 00 00 00 00 00 06 50 30 30  ..P007.......P00
  00c0: 37 43 50 55 37 5b 83 0b 50 30 30 38 08 00 00 00  7CPU7[..P008....
  00d0: 00 00 06 50 30 30 38 43 50 55 38 08 44 50 38 30  ...P008CPU8.DP80
  00e0: 0a 80 08 44 50 39 30 0a 90 08 53 50 49 4f 0a 2e  ...DP90...SPIO..
  00f0: 08 49 4f 50 42 0b 00 0a 08 49 4f 50 4c 0a 10 08  .IOPB....IOPL...
  0100: 49 4f 45 42 0b 10 0a 08 49 4f 45 4c 0a 10 08 49  IOEB....IOEL...I
  0110: 4f 47 42 0b 20 0a 08 49 4f 47 4c 0a 10 08 49 4f  OGB. ..IOGL...IO
  0120: 53 42 0b 30 0a 08 49 4f 53 4c 0a 10 08 41 50 49  SB.0..IOSL...API
  0130: 43 01 08 53 4d 49 50 0a b2 08 50 4d 42 53 0b 00  C..SMIP...PMBS..
  0140: 08 08 50 4d 4c 4e 0a 80 08 47 50 42 53 0b 00 05  ..PMLN...GPBS...
  0150: 08 47 50 4c 4e 0a 80 08 53 4d 42 53 00 08 53 4d  .GPLN...SMBS..SM
  0160: 42 4c 00 08 50 4d 33 30 0b 30 08 08 53 55 53 57  BL..PM30.0..SUSW
  0170: 0a ff 08 54 50 42 41 0c 00 00 d4 fe 08 54 50 42  ...TPBA......TPB
  0180: 4c 00 08 50 43 49 42 0c 00 00 00 e0 08 50 43 49  L..PCIB......PCI
  0190: 4c 0c 00 00 00 10 5b 80 42 49 4f 53 00 0c 64 e0  L.....[.BIOS..d.
  01a0: 79 bf 0a ff 5b 81 46 0a 42 49 4f 53 01 53 53 31  y...[.F.BIOS.SS1
  01b0: 5f 01 53 53 32 5f 01 53 53 33 5f 01 53 53 34 5f  _.SS2_.SS3_.SS4_
  01c0: 01 00 04 49 4f 53 54 10 54 4f 50 4d 20 52 4f 4d  ...IOST.TOPM ROM
  01d0: 53 20 4d 47 31 42 20 4d 47 31 4c 20 4d 47 32 42  S MG1B MG1L MG2B
  01e0: 20 4d 47 32 4c 20 00 08 44 4d 41 58 08 48 50 54   MG2L ..DMAX.HPT
  01f0: 41 20 43 50 42 30 20 43 50 42 31 20 43 50 42 32  A CPB0 CPB1 CPB2
  0200: 20 43 50 42 33 20 41 53 53 42 08 41 4f 54 42 08   CPB3 ASSB.AOTB.
  0210: 41 41 58 42 20 53 4d 49 46 08 44 54 53 45 08 44  AAXB SMIF.DTSE.D
  0220: 54 53 31 08 44 54 53 32 08 4d 50 45 4e 08 54 50  TS1.DTS2.MPEN.TP
  0230: 4d 46 08 4d 47 33 42 20 4d 47 33 4c 20 4d 48 31  MF.MG3B MG3L MH1
  0240: 42 20 4d 48 31 4c 20 4f 53 54 50 08 14 0f 52 52  B MH1L OSTP...RR
  0250: 49 4f 04 70 0d 52 52 49 4f 00 5b 31 14 0f 52 44  IO.p.RRIO.[1..RD
  0260: 4d 41 03 70 0d 72 44 4d 41 00 5b 31 08 50 49 43  MA.p.rDMA.[1.PIC
  0270: 4d 00 14 1f 5f 50 49 43 01 a0 09 68 70 0a aa 44  M..._PIC...hp..D
  0280: 42 47 38 a1 08 70 0a ac 44 42 47 38 70 68 50 49  BG8..p..DBG8phPI
  0290: 43 4d 08 4f 53 56 52 ff 14 43 0a 4f 53 46 4c 00  CM.OSVR..C.OSFL.
  02a0: a0 0d 92 93 4f 53 56 52 ff a4 4f 53 56 52 08 5f  ....OSVR..OSVR._
  02b0: 54 5f 30 00 70 4f 53 59 53 5f 54 5f 30 a0 0e 93  T_0.pOSYS_T_0...
  02c0: 5f 54 5f 30 01 70 0a 03 4f 53 56 52 a1 4a 06 a0  _T_0.p..OSVR.J..
  02d0: 0e 93 5f 54 5f 30 0a 10 70 01 4f 53 56 52 a1 48  .._T_0..p.OSVR.H
  02e0: 05 a0 0f 93 5f 54 5f 30 0a 11 70 0a 02 4f 53 56  ...._T_0..p..OSV
  02f0: 52 a1 45 04 a0 0f 93 5f 54 5f 30 0a 12 70 0a 04  R.E...._T_0..p..
  0300: 4f 53 56 52 a1 32 a0 0e 93 5f 54 5f 30 0a 13 70  OSVR.2..._T_0..p
  0310: 00 4f 53 56 52 a1 21 a0 0e 93 5f 54 5f 30 0a 14  .OSVR.!..._T_0..
  0320: 70 00 4f 53 56 52 a1 10 a0 0e 93 5f 54 5f 30 0a  p.OSVR....._T_0.
  0330: 15 70 00 4f 53 56 52 a4 4f 53 56 52 14 4e 04 4d  .p.OSVR.OSVR.N.M
  0340: 43 54 48 02 a0 08 95 87 68 87 69 a4 00 72 87 68  CTH.....h.i..r.h
  0350: 01 60 08 42 55 46 30 11 02 60 08 42 55 46 31 11  .`.BUF0..`.BUF1.
  0360: 02 60 70 68 42 55 46 30 70 69 42 55 46 31 a2 1a  .`phBUF0piBUF1..
  0370: 60 76 60 a0 15 92 93 83 88 42 55 46 30 60 00 83  `v`......BUF0`..
  0380: 88 42 55 46 31 60 00 a4 00 a4 01 08 50 52 57 50  .BUF1`......PRWP
  0390: 12 04 02 00 00 14 4b 07 47 50 52 57 02 70 68 88  ......K.GPRW.ph.
  03a0: 50 52 57 50 00 00 70 79 53 53 31 5f 01 00 60 7d  PRWP..pySS1_..`}
  03b0: 60 79 53 53 32 5f 0a 02 00 60 7d 60 79 53 53 33  `ySS2_...`}`ySS3
  03c0: 5f 0a 03 00 60 7d 60 79 53 53 34 5f 0a 04 00 60  _...`}`ySS4_...`
  03d0: a0 11 7b 79 01 69 00 60 00 70 69 88 50 52 57 50  ..{y.i.`.pi.PRWP
  03e0: 01 00 a1 29 7a 60 01 60 a0 18 91 93 4f 53 46 4c  ...)z`.`....OSFL
  03f0: 01 93 4f 53 46 4c 0a 02 81 60 88 50 52 57 50 01  ..OSFL...`.PRWP.
  0400: 00 a1 0a 82 60 88 50 52 57 50 01 00 a4 50 52 57  ....`.PRWP...PRW
  0410: 50 08 57 41 4b 50 12 04 02 00 00 5b 80 44 45 42  P.WAKP.....[.DEB
  0420: 30 01 44 50 38 30 01 5b 81 0b 44 45 42 30 01 44  0.DP80.[..DEB0.D
  0430: 42 47 38 08 5b 80 44 45 42 31 01 44 50 39 30 0a  BG8.[.DEB1.DP90.
  0440: 02 5b 81 0b 44 45 42 31 02 44 42 47 39 10 14 44  .[..DEB1.DBG9..D
  0450: 14 4f 53 59 53 00 70 0a 10 60 a0 41 0c 5b 12 5f  .OSYS.p..`.A.[._
  0460: 4f 53 49 61 a0 17 5f 4f 53 49 0d 57 69 6e 64 6f  OSIa.._OSI.Windo
  0470: 77 73 20 32 30 30 30 00 70 0a 12 60 a0 17 5f 4f  ws 2000.p..`.._O
  0480: 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30 31 00  SI.Windows 2001.
  0490: 70 0a 13 60 a0 1b 5f 4f 53 49 0d 57 69 6e 64 6f  p..`.._OSI.Windo
  04a0: 77 73 20 32 30 30 31 20 53 50 31 00 70 0a 13 60  ws 2001 SP1.p..`
  04b0: a0 1b 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32  .._OSI.Windows 2
  04c0: 30 30 31 20 53 50 32 00 70 0a 13 60 a0 19 5f 4f  001 SP2.p..`.._O
  04d0: 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30 31 2e  SI.Windows 2001.
  04e0: 31 00 70 0a 14 60 a0 1d 5f 4f 53 49 0d 57 69 6e  1.p..`.._OSI.Win
  04f0: 64 6f 77 73 20 32 30 30 31 2e 31 20 53 50 31 00  dows 2001.1 SP1.
  0500: 70 0a 14 60 a0 17 5f 4f 53 49 0d 57 69 6e 64 6f  p..`.._OSI.Windo
  0510: 77 73 20 32 30 30 36 00 70 0a 15 60 a1 44 07 a0  ws 2006.p..`.D..
  0520: 23 4d 43 54 48 5f 4f 53 5f 0d 4d 69 63 72 6f 73  #MCTH_OS_.Micros
  0530: 6f 66 74 20 57 69 6e 64 6f 77 73 20 4e 54 00 70  oft Windows NT.p
  0540: 0a 12 60 a1 4d 04 a0 36 4d 43 54 48 5f 4f 53 5f  ..`.M..6MCTH_OS_
  0550: 0d 4d 69 63 72 6f 73 6f 66 74 20 57 69 6e 64 6f  .Microsoft Windo
  0560: 77 73 4d 45 3a 20 4d 69 6c 6c 65 6e 6e 69 75 6d  wsME: Millennium
  0570: 20 45 64 69 74 69 6f 6e 00 70 0a 11 60 a0 13 4d   Edition.p..`..M
  0580: 43 54 48 5f 4f 53 5f 0d 4c 69 6e 75 78 00 70 01  CTH_OS_.Linux.p.
  0590: 60 a4 60 10 8b 6b 04 5f 53 42 5f 08 50 52 30 30  `.`..k._SB_.PR00
  05a0: 12 46 3b 42 12 0d 04 0c ff ff 0d 00 00 4c 4e 4b  .F;B.........LNK
  05b0: 41 00 12 0d 04 0c ff ff 1f 00 00 4c 4e 4b 43 00  A..........LNKC.
  05c0: 12 0d 04 0c ff ff 1f 00 01 4c 4e 4b 44 00 12 0e  .........LNKD...
  05d0: 04 0c ff ff 1f 00 0a 02 4c 4e 4b 43 00 12 0d 04  ........LNKC....
  05e0: 0c ff ff 1d 00 00 4c 4e 4b 48 00 12 0d 04 0c ff  ......LNKH......
  05f0: ff 1d 00 01 4c 4e 4b 44 00 12 0e 04 0c ff ff 1d  ....LNKD........
  0600: 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c ff ff 1d 00  ...LNKC.........
  0610: 0a 03 4c 4e 4b 41 00 12 0d 04 0c ff ff 1a 00 00  ..LNKA..........
  0620: 4c 4e 4b 41 00 12 0d 04 0c ff ff 1a 00 01 4c 4e  LNKA..........LN
  0630: 4b 46 00 12 0e 04 0c ff ff 1a 00 0a 03 4c 4e 4b  KF...........LNK
  0640: 44 00 12 0e 04 0c ff ff 1a 00 0a 02 4c 4e 4b 43  D...........LNKC
  0650: 00 12 0d 04 0c ff ff 1b 00 00 4c 4e 4b 47 00 12  ..........LNKG..
  0660: 0d 04 0c ff ff 1c 00 00 4c 4e 4b 42 00 12 0d 04  ........LNKB....
  0670: 0c ff ff 1c 00 01 4c 4e 4b 41 00 12 0e 04 0c ff  ......LNKA......
  0680: ff 1c 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c ff ff  .....LNKC.......
  0690: 1c 00 0a 03 4c 4e 4b 44 00 12 0b 04 0b ff ff 00  ....LNKD........
  06a0: 4c 4e 4b 41 00 12 0b 04 0b ff ff 01 4c 4e 4b 42  LNKA........LNKB
  06b0: 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00 12 0c  .........LNKC...
  06c0: 04 0b ff ff 0a 03 4c 4e 4b 44 00 12 0d 04 0c ff  ......LNKD......
  06d0: ff 01 00 00 4c 4e 4b 41 00 12 0d 04 0c ff ff 01  ....LNKA........
  06e0: 00 01 4c 4e 4b 42 00 12 0e 04 0c ff ff 01 00 0a  ..LNKB..........
  06f0: 02 4c 4e 4b 43 00 12 0e 04 0c ff ff 01 00 0a 03  .LNKC...........
  0700: 4c 4e 4b 44 00 12 0d 04 0c ff ff 02 00 00 4c 4e  LNKD..........LN
  0710: 4b 41 00 12 0d 04 0c ff ff 02 00 01 4c 4e 4b 42  KA..........LNKB
  0720: 00 12 0e 04 0c ff ff 02 00 0a 02 4c 4e 4b 43 00  ...........LNKC.
  0730: 12 0e 04 0c ff ff 02 00 0a 03 4c 4e 4b 44 00 12  ..........LNKD..
  0740: 0d 04 0c ff ff 03 00 00 4c 4e 4b 41 00 12 0d 04  ........LNKA....
  0750: 0c ff ff 03 00 01 4c 4e 4b 42 00 12 0e 04 0c ff  ......LNKB......
  0760: ff 03 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c ff ff  .....LNKC.......
  0770: 03 00 0a 03 4c 4e 4b 44 00 12 0d 04 0c ff ff 04  ....LNKD........
  0780: 00 00 4c 4e 4b 41 00 12 0d 04 0c ff ff 04 00 01  ..LNKA..........
  0790: 4c 4e 4b 42 00 12 0e 04 0c ff ff 04 00 0a 02 4c  LNKB...........L
  07a0: 4e 4b 43 00 12 0e 04 0c ff ff 04 00 0a 03 4c 4e  NKC...........LN
  07b0: 4b 44 00 12 0d 04 0c ff ff 05 00 00 4c 4e 4b 41  KD..........LNKA
  07c0: 00 12 0d 04 0c ff ff 05 00 01 4c 4e 4b 42 00 12  ..........LNKB..
  07d0: 0e 04 0c ff ff 05 00 0a 02 4c 4e 4b 43 00 12 0e  .........LNKC...
  07e0: 04 0c ff ff 05 00 0a 03 4c 4e 4b 44 00 12 0d 04  ........LNKD....
  07f0: 0c ff ff 06 00 00 4c 4e 4b 41 00 12 0d 04 0c ff  ......LNKA......
  0800: ff 06 00 01 4c 4e 4b 42 00 12 0e 04 0c ff ff 06  ....LNKB........
  0810: 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c ff ff 06 00  ...LNKC.........
  0820: 0a 03 4c 4e 4b 44 00 12 0d 04 0c ff ff 07 00 00  ..LNKD..........
  0830: 4c 4e 4b 41 00 12 0d 04 0c ff ff 07 00 01 4c 4e  LNKA..........LN
  0840: 4b 42 00 12 0e 04 0c ff ff 07 00 0a 02 4c 4e 4b  KB...........LNK
  0850: 43 00 12 0e 04 0c ff ff 07 00 0a 03 4c 4e 4b 44  C...........LNKD
  0860: 00 12 0d 04 0c ff ff 08 00 00 4c 4e 4b 41 00 12  ..........LNKA..
  0870: 0d 04 0c ff ff 08 00 01 4c 4e 4b 42 00 12 0e 04  ........LNKB....
  0880: 0c ff ff 08 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c  .......LNKC.....
  0890: ff ff 08 00 0a 03 4c 4e 4b 44 00 12 0d 04 0c ff  ......LNKD......
  08a0: ff 09 00 00 4c 4e 4b 41 00 12 0d 04 0c ff ff 09  ....LNKA........
  08b0: 00 01 4c 4e 4b 42 00 12 0e 04 0c ff ff 09 00 0a  ..LNKB..........
  08c0: 02 4c 4e 4b 43 00 12 0e 04 0c ff ff 09 00 0a 03  .LNKC...........
  08d0: 4c 4e 4b 44 00 12 0d 04 0c ff ff 0a 00 00 4c 4e  LNKD..........LN
  08e0: 4b 41 00 12 0d 04 0c ff ff 0a 00 01 4c 4e 4b 42  KA..........LNKB
  08f0: 00 12 0e 04 0c ff ff 0a 00 0a 02 4c 4e 4b 43 00  ...........LNKC.
  0900: 12 0e 04 0c ff ff 0a 00 0a 03 4c 4e 4b 44 00 12  ..........LNKD..
  0910: 0d 04 0c ff ff 16 00 00 4c 4e 4b 41 00 12 0d 04  ........LNKA....
  0920: 0c ff ff 16 00 01 4c 4e 4b 42 00 12 0e 04 0c ff  ......LNKB......
  0930: ff 16 00 0a 02 4c 4e 4b 43 00 12 0e 04 0c ff ff  .....LNKC.......
  0940: 16 00 0a 03 4c 4e 4b 44 00 12 0d 04 0c ff ff 19  ....LNKD........
  0950: 00 00 4c 4e 4b 45 00 08 41 52 30 30 12 46 32 41  ..LNKE..AR00.F2A
  0960: 12 0b 04 0c ff ff 1f 00 00 00 0a 12 12 0b 04 0c  ................
  0970: ff ff 1f 00 01 00 0a 13 12 0c 04 0c ff ff 1f 00  ................
  0980: 0a 02 00 0a 12 12 0b 04 0c ff ff 1d 00 00 00 0a  ................
  0990: 17 12 0b 04 0c ff ff 1d 00 01 00 0a 13 12 0c 04  ................
  09a0: 0c ff ff 1d 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  09b0: 1d 00 0a 03 00 0a 10 12 0b 04 0c ff ff 1a 00 00  ................
  09c0: 00 0a 10 12 0b 04 0c ff ff 1a 00 01 00 0a 15 12  ................
  09d0: 0c 04 0c ff ff 1a 00 0a 03 00 0a 13 12 0c 04 0c  ................
  09e0: ff ff 1a 00 0a 02 00 0a 12 12 0b 04 0c ff ff 1b  ................
  09f0: 00 00 00 0a 16 12 0b 04 0c ff ff 1c 00 00 00 0a  ................
  0a00: 11 12 0b 04 0c ff ff 1c 00 01 00 0a 10 12 0c 04  ................
  0a10: 0c ff ff 1c 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  0a20: 1c 00 0a 03 00 0a 13 12 09 04 0b ff ff 00 00 0a  ................
  0a30: 10 12 09 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff  ................
  0a40: ff 0a 02 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a  ................
  0a50: 13 12 0b 04 0c ff ff 01 00 00 00 0a 10 12 0b 04  ................
  0a60: 0c ff ff 01 00 01 00 0a 11 12 0c 04 0c ff ff 01  ................
  0a70: 00 0a 02 00 0a 12 12 0c 04 0c ff ff 01 00 0a 03  ................
  0a80: 00 0a 13 12 0b 04 0c ff ff 02 00 00 00 0a 10 12  ................
  0a90: 0b 04 0c ff ff 02 00 01 00 0a 11 12 0c 04 0c ff  ................
  0aa0: ff 02 00 0a 02 00 0a 12 12 0c 04 0c ff ff 02 00  ................
  0ab0: 0a 03 00 0a 13 12 0b 04 0c ff ff 03 00 00 00 0a  ................
  0ac0: 10 12 0b 04 0c ff ff 03 00 01 00 0a 11 12 0c 04  ................
  0ad0: 0c ff ff 03 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  0ae0: 03 00 0a 03 00 0a 13 12 0b 04 0c ff ff 04 00 00  ................
  0af0: 00 0a 10 12 0b 04 0c ff ff 04 00 01 00 0a 11 12  ................
  0b00: 0c 04 0c ff ff 04 00 0a 02 00 0a 12 12 0c 04 0c  ................
  0b10: ff ff 04 00 0a 03 00 0a 13 12 0b 04 0c ff ff 05  ................
  0b20: 00 00 00 0a 10 12 0b 04 0c ff ff 05 00 01 00 0a  ................
  0b30: 11 12 0c 04 0c ff ff 05 00 0a 02 00 0a 12 12 0c  ................
  0b40: 04 0c ff ff 05 00 0a 03 00 0a 13 12 0b 04 0c ff  ................
  0b50: ff 06 00 00 00 0a 10 12 0b 04 0c ff ff 06 00 01  ................
  0b60: 00 0a 11 12 0c 04 0c ff ff 06 00 0a 02 00 0a 12  ................
  0b70: 12 0c 04 0c ff ff 06 00 0a 03 00 0a 13 12 0b 04  ................
  0b80: 0c ff ff 07 00 00 00 0a 10 12 0b 04 0c ff ff 07  ................
  0b90: 00 01 00 0a 11 12 0c 04 0c ff ff 07 00 0a 02 00  ................
  0ba0: 0a 12 12 0c 04 0c ff ff 07 00 0a 03 00 0a 13 12  ................
  0bb0: 0b 04 0c ff ff 08 00 00 00 0a 10 12 0b 04 0c ff  ................
  0bc0: ff 08 00 01 00 0a 11 12 0c 04 0c ff ff 08 00 0a  ................
  0bd0: 02 00 0a 12 12 0c 04 0c ff ff 08 00 0a 03 00 0a  ................
  0be0: 13 12 0b 04 0c ff ff 09 00 00 00 0a 10 12 0b 04  ................
  0bf0: 0c ff ff 09 00 01 00 0a 11 12 0c 04 0c ff ff 09  ................
  0c00: 00 0a 02 00 0a 12 12 0c 04 0c ff ff 09 00 0a 03  ................
  0c10: 00 0a 13 12 0b 04 0c ff ff 0a 00 00 00 0a 10 12  ................
  0c20: 0b 04 0c ff ff 0a 00 01 00 0a 11 12 0c 04 0c ff  ................
  0c30: ff 0a 00 0a 02 00 0a 12 12 0c 04 0c ff ff 0a 00  ................
  0c40: 0a 03 00 0a 13 12 0b 04 0c ff ff 16 00 00 00 0a  ................
  0c50: 10 12 0b 04 0c ff ff 16 00 01 00 0a 11 12 0c 04  ................
  0c60: 0c ff ff 16 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  0c70: 16 00 0a 03 00 0a 13 12 0b 04 0c ff ff 19 00 00  ................
  0c80: 00 0a 14 08 50 52 31 31 12 34 04 12 0b 04 0b ff  ....PR11.4......
  0c90: ff 00 4c 4e 4b 41 00 12 0b 04 0b ff ff 01 4c 4e  ..LNKA........LN
  0ca0: 4b 42 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00  KB.........LNKC.
  0cb0: 12 0c 04 0b ff ff 0a 03 4c 4e 4b 44 00 08 41 52  ........LNKD..AR
  0cc0: 31 31 12 2c 04 12 09 04 0b ff ff 00 00 0a 10 12  11.,............
  0cd0: 09 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff ff 0a  ................
  0ce0: 02 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a 13 08  ................
  0cf0: 50 52 31 32 12 34 04 12 0b 04 0b ff ff 00 4c 4e  PR12.4........LN
  0d00: 4b 41 00 12 0b 04 0b ff ff 01 4c 4e 4b 42 00 12  KA........LNKB..
  0d10: 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b  .......LNKC.....
  0d20: ff ff 0a 03 4c 4e 4b 44 00 08 41 52 31 32 12 2c  ....LNKD..AR12.,
  0d30: 04 12 09 04 0b ff ff 00 00 0a 10 12 09 04 0b ff  ................
  0d40: ff 01 00 0a 11 12 0a 04 0b ff ff 0a 02 00 0a 12  ................
  0d50: 12 0a 04 0b ff ff 0a 03 00 0a 13 08 50 52 31 33  ............PR13
  0d60: 12 34 04 12 0b 04 0b ff ff 00 4c 4e 4b 41 00 12  .4........LNKA..
  0d70: 0b 04 0b ff ff 01 4c 4e 4b 42 00 12 0c 04 0b ff  ......LNKB......
  0d80: ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 03  ...LNKC.........
  0d90: 4c 4e 4b 44 00 08 41 52 31 33 12 2c 04 12 09 04  LNKD..AR13.,....
  0da0: 0b ff ff 00 00 0a 10 12 09 04 0b ff ff 01 00 0a  ................
  0db0: 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12 0a 04 0b  ................
  0dc0: ff ff 0a 03 00 0a 13 08 50 52 31 34 12 34 04 12  ........PR14.4..
  0dd0: 0b 04 0b ff ff 00 4c 4e 4b 41 00 12 0b 04 0b ff  ......LNKA......
  0de0: ff 01 4c 4e 4b 42 00 12 0c 04 0b ff ff 0a 02 4c  ..LNKB.........L
  0df0: 4e 4b 43 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 44  NKC.........LNKD
  0e00: 00 08 41 52 31 34 12 2c 04 12 09 04 0b ff ff 00  ..AR14.,........
  0e10: 00 0a 10 12 09 04 0b ff ff 01 00 0a 11 12 0a 04  ................
  0e20: 0b ff ff 0a 02 00 0a 12 12 0a 04 0b ff ff 0a 03  ................
  0e30: 00 0a 13 08 50 52 31 35 12 34 04 12 0b 04 0b ff  ....PR15.4......
  0e40: ff 00 4c 4e 4b 41 00 12 0b 04 0b ff ff 01 4c 4e  ..LNKA........LN
  0e50: 4b 42 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00  KB.........LNKC.
  0e60: 12 0c 04 0b ff ff 0a 03 4c 4e 4b 44 00 08 41 52  ........LNKD..AR
  0e70: 31 35 12 2c 04 12 09 04 0b ff ff 00 00 0a 10 12  15.,............
  0e80: 09 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff ff 0a  ................
  0e90: 02 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a 13 08  ................
  0ea0: 50 52 31 36 12 34 04 12 0b 04 0b ff ff 00 4c 4e  PR16.4........LN
  0eb0: 4b 41 00 12 0b 04 0b ff ff 01 4c 4e 4b 42 00 12  KA........LNKB..
  0ec0: 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b  .......LNKC.....
  0ed0: ff ff 0a 03 4c 4e 4b 44 00 08 41 52 31 36 12 2c  ....LNKD..AR16.,
  0ee0: 04 12 09 04 0b ff ff 00 00 0a 10 12 09 04 0b ff  ................
  0ef0: ff 01 00 0a 11 12 0a 04 0b ff ff 0a 02 00 0a 12  ................
  0f00: 12 0a 04 0b ff ff 0a 03 00 0a 13 08 50 52 31 37  ............PR17
  0f10: 12 34 04 12 0b 04 0b ff ff 00 4c 4e 4b 41 00 12  .4........LNKA..
  0f20: 0b 04 0b ff ff 01 4c 4e 4b 42 00 12 0c 04 0b ff  ......LNKB......
  0f30: ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 03  ...LNKC.........
  0f40: 4c 4e 4b 44 00 08 41 52 31 37 12 2c 04 12 09 04  LNKD..AR17.,....
  0f50: 0b ff ff 00 00 0a 10 12 09 04 0b ff ff 01 00 0a  ................
  0f60: 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12 0a 04 0b  ................
  0f70: ff ff 0a 03 00 0a 13 08 50 52 31 38 12 34 04 12  ........PR18.4..
  0f80: 0b 04 0b ff ff 00 4c 4e 4b 41 00 12 0b 04 0b ff  ......LNKA......
  0f90: ff 01 4c 4e 4b 42 00 12 0c 04 0b ff ff 0a 02 4c  ..LNKB.........L
  0fa0: 4e 4b 43 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 44  NKC.........LNKD
  0fb0: 00 08 41 52 31 38 12 2c 04 12 09 04 0b ff ff 00  ..AR18.,........
  0fc0: 00 0a 10 12 09 04 0b ff ff 01 00 0a 11 12 0a 04  ................
  0fd0: 0b ff ff 0a 02 00 0a 12 12 0a 04 0b ff ff 0a 03  ................
  0fe0: 00 0a 13 08 50 52 31 39 12 34 04 12 0b 04 0b ff  ....PR19.4......
  0ff0: ff 00 4c 4e 4b 41 00 12 0b 04 0b ff ff 01 4c 4e  ..LNKA........LN
  1000: 4b 42 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00  KB.........LNKC.
  1010: 12 0c 04 0b ff ff 0a 03 4c 4e 4b 44 00 08 41 52  ........LNKD..AR
  1020: 31 39 12 2c 04 12 09 04 0b ff ff 00 00 0a 10 12  19.,............
  1030: 09 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff ff 0a  ................
  1040: 02 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a 13 08  ................
  1050: 50 52 31 41 12 34 04 12 0b 04 0b ff ff 00 4c 4e  PR1A.4........LN
  1060: 4b 41 00 12 0b 04 0b ff ff 01 4c 4e 4b 42 00 12  KA........LNKB..
  1070: 0c 04 0b ff ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b  .......LNKC.....
  1080: ff ff 0a 03 4c 4e 4b 44 00 08 41 52 31 41 12 2c  ....LNKD..AR1A.,
  1090: 04 12 09 04 0b ff ff 00 00 0a 10 12 09 04 0b ff  ................
  10a0: ff 01 00 0a 11 12 0a 04 0b ff ff 0a 02 00 0a 12  ................
  10b0: 12 0a 04 0b ff ff 0a 03 00 0a 13 08 50 52 30 34  ............PR04
  10c0: 12 34 04 12 0b 04 0b ff ff 00 4c 4e 4b 41 00 12  .4........LNKA..
  10d0: 0b 04 0b ff ff 01 4c 4e 4b 42 00 12 0c 04 0b ff  ......LNKB......
  10e0: ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 03  ...LNKC.........
  10f0: 4c 4e 4b 44 00 08 41 52 30 34 12 2c 04 12 09 04  LNKD..AR04.,....
  1100: 0b ff ff 00 00 0a 10 12 09 04 0b ff ff 01 00 0a  ................
  1110: 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12 0a 04 0b  ................
  1120: ff ff 0a 03 00 0a 13 08 50 52 30 35 12 34 04 12  ........PR05.4..
  1130: 0b 04 0b ff ff 00 4c 4e 4b 42 00 12 0b 04 0b ff  ......LNKB......
  1140: ff 01 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 02 4c  ..LNKC.........L
  1150: 4e 4b 44 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 41  NKD.........LNKA
  1160: 00 08 41 52 30 35 12 2c 04 12 09 04 0b ff ff 00  ..AR05.,........
  1170: 00 0a 11 12 09 04 0b ff ff 01 00 0a 12 12 0a 04  ................
  1180: 0b ff ff 0a 02 00 0a 13 12 0a 04 0b ff ff 0a 03  ................
  1190: 00 0a 10 08 50 52 30 36 12 34 04 12 0b 04 0b ff  ....PR06.4......
  11a0: ff 00 4c 4e 4b 43 00 12 0b 04 0b ff ff 01 4c 4e  ..LNKC........LN
  11b0: 4b 44 00 12 0c 04 0b ff ff 0a 02 4c 4e 4b 41 00  KD.........LNKA.
  11c0: 12 0c 04 0b ff ff 0a 03 4c 4e 4b 42 00 08 41 52  ........LNKB..AR
  11d0: 30 36 12 2c 04 12 09 04 0b ff ff 00 00 0a 12 12  06.,............
  11e0: 09 04 0b ff ff 01 00 0a 13 12 0a 04 0b ff ff 0a  ................
  11f0: 02 00 0a 10 12 0a 04 0b ff ff 0a 03 00 0a 11 08  ................
  1200: 50 52 30 37 12 34 04 12 0b 04 0b ff ff 00 4c 4e  PR07.4........LN
  1210: 4b 44 00 12 0b 04 0b ff ff 01 4c 4e 4b 41 00 12  KD........LNKA..
  1220: 0c 04 0b ff ff 0a 02 4c 4e 4b 42 00 12 0c 04 0b  .......LNKB.....
  1230: ff ff 0a 03 4c 4e 4b 43 00 08 41 52 30 37 12 2c  ....LNKC..AR07.,
  1240: 04 12 09 04 0b ff ff 00 00 0a 13 12 09 04 0b ff  ................
  1250: ff 01 00 0a 10 12 0a 04 0b ff ff 0a 02 00 0a 11  ................
  1260: 12 0a 04 0b ff ff 0a 03 00 0a 12 08 50 52 30 38  ............PR08
  1270: 12 34 04 12 0b 04 0b ff ff 00 4c 4e 4b 41 00 12  .4........LNKA..
  1280: 0b 04 0b ff ff 01 4c 4e 4b 42 00 12 0c 04 0b ff  ......LNKB......
  1290: ff 0a 02 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 03  ...LNKC.........
  12a0: 4c 4e 4b 44 00 08 41 52 30 38 12 2c 04 12 09 04  LNKD..AR08.,....
  12b0: 0b ff ff 00 00 0a 10 12 09 04 0b ff ff 01 00 0a  ................
  12c0: 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12 0a 04 0b  ................
  12d0: ff ff 0a 03 00 0a 13 08 50 52 30 39 12 34 04 12  ........PR09.4..
  12e0: 0b 04 0b ff ff 00 4c 4e 4b 42 00 12 0b 04 0b ff  ......LNKB......
  12f0: ff 01 4c 4e 4b 43 00 12 0c 04 0b ff ff 0a 02 4c  ..LNKC.........L
  1300: 4e 4b 44 00 12 0c 04 0b ff ff 0a 03 4c 4e 4b 41  NKD.........LNKA
  1310: 00 08 41 52 30 39 12 2c 04 12 09 04 0b ff ff 00  ..AR09.,........
  1320: 00 0a 11 12 09 04 0b ff ff 01 00 0a 12 12 0a 04  ................
  1330: 0b ff ff 0a 02 00 0a 13 12 0a 04 0b ff ff 0a 03  ................
  1340: 00 0a 10 08 50 52 53 41 11 09 0a 06 23 d8 dc 18  ....PRSA....#...
  1350: 79 00 08 50 52 53 42 11 09 0a 06 23 20 00 18 79  y..PRSB....# ..y
  1360: 00 06 50 52 53 41 50 52 53 43 06 50 52 53 41 50  ..PRSAPRSC.PRSAP
  1370: 52 53 44 06 50 52 53 41 50 52 53 45 06 50 52 53  RSD.PRSAPRSE.PRS
  1380: 41 50 52 53 46 06 50 52 53 41 50 52 53 47 06 50  APRSF.PRSAPRSG.P
  1390: 52 53 41 50 52 53 48 5b 82 89 5d 03 50 43 49 30  RSAPRSH[..].PCI0
  13a0: 08 5f 48 49 44 0c 41 d0 0a 08 08 5f 43 49 44 0c  ._HID.A...._CID.
  13b0: 41 d0 0a 03 08 5f 41 44 52 00 14 09 5e 42 4e 30  A...._ADR...^BN0
  13c0: 30 00 a4 00 14 0b 5f 42 42 4e 00 a4 42 4e 30 30  0....._BBN..BN00
  13d0: 08 5f 55 49 44 00 14 16 5f 50 52 54 00 a0 0a 50  ._UID..._PRT...P
  13e0: 49 43 4d a4 41 52 30 30 a4 50 52 30 30 5b 82 4b  ICM.AR00.PR00[.K
  13f0: 06 49 4f 48 5f 08 5f 48 49 44 0c 41 d0 0c 01 08  .IOH_._HID.A....
  1400: 5f 55 49 44 0a 0a 08 5f 43 52 53 11 4e 04 0a 4a  _UID..._CRS.N..J
  1410: 86 09 00 01 00 00 f0 fb 00 00 10 00 86 09 00 01  ................
  1420: 00 00 00 fc 00 00 00 01 86 09 00 01 00 00 00 fd  ................
  1430: 00 00 00 01 86 09 00 01 00 00 00 fe 00 00 c0 00  ................
  1440: 86 09 00 01 00 a0 c8 fe 00 10 00 00 86 09 00 01  ................
  1450: 00 00 d1 fe 00 10 00 00 79 00 14 06 4e 50 54 53  ........y...NPTS
  1460: 01 14 06 4e 57 41 4b 01 5b 82 1f 50 30 50 31 08  ...NWAK.[..P0P1.
  1470: 5f 41 44 52 0c 00 00 1e 00 14 0f 5f 50 52 57 00  _ADR......._PRW.
  1480: a4 47 50 52 57 0a 0b 0a 04 5b 82 8a 49 01 53 42  .GPRW....[..I.SB
  1490: 52 47 08 5f 41 44 52 0c 00 00 1f 00 5b 82 48 0b  RG._ADR.....[.H.
  14a0: 49 45 4c 4b 08 5f 48 49 44 0d 41 57 59 30 30 30  IELK._HID.AWY000
  14b0: 31 00 5b 80 52 58 41 30 02 0a a0 0a 20 5b 81 31  1.[.RXA0.... [.1
  14c0: 52 58 41 30 01 00 09 50 42 4c 56 01 00 46 07 00  RXA0...PBLV..F..
  14d0: 01 50 42 4d 53 01 00 01 50 4d 43 53 01 45 43 4e  .PBMS...PMCS.ECN
  14e0: 53 01 00 03 45 43 54 31 10 45 4c 45 4e 01 00 07  S...ECT1.ELEN...
  14f0: 14 3b 5c 2e 5f 47 50 45 5f 4c 30 41 00 86 5c 2f  .;\._GPE_L0A..\/
  1500: 04 5f 53 42 5f 50 43 49 30 53 42 52 47 49 45 4c  ._SB_PCI0SBRGIEL
  1510: 4b 0a 81 70 01 5c 2f 05 5f 53 42 5f 50 43 49 30  K..p.\/._SB_PCI0
  1520: 53 42 52 47 49 45 4c 4b 50 4d 43 53 14 13 5f 53  SBRGIELKPMCS.._S
  1530: 54 41 00 a0 08 45 4c 45 4e a4 0a 0f a1 03 a4 00  TA...ELEN.......
  1540: 14 06 53 4d 4f 44 01 14 0e 47 50 42 53 00 a4 7f  ..SMOD...GPBS...
  1550: 50 42 4c 56 01 00 14 18 53 50 54 53 01 70 01 50  PBLV....SPTS.p.P
  1560: 53 31 53 70 01 50 53 31 45 70 01 53 4c 50 53 14  S1Sp.PS1Ep.SLPS.
  1570: 32 53 57 41 4b 01 70 00 53 4c 50 53 70 00 50 53  2SWAK.p.SLPSp.PS
  1580: 31 45 a0 09 90 93 68 01 52 54 43 53 a1 15 a0 0a  1E....h.RTCS....
  1590: 90 93 68 0a 03 42 52 54 43 a1 08 86 50 57 52 42  ..h..BRTC...PWRB
  15a0: 0a 02 5b 80 41 50 4d 50 01 53 4d 49 50 0a 02 5b  ..[.APMP.SMIP..[
  15b0: 81 10 41 50 4d 50 01 41 50 4d 43 08 41 50 4d 53  ..APMP.APMC.APMS
  15c0: 08 5b 81 0f 41 50 4d 50 01 00 08 00 01 42 52 54  .[..APMP.....BRT
  15d0: 43 01 5b 80 50 4d 53 30 01 50 4d 42 53 0a 04 5b  C.[.PMS0.PMBS..[
  15e0: 81 1d 50 4d 53 30 01 00 0a 52 54 43 53 01 00 04  ..PMS0...RTCS...
  15f0: 57 41 4b 53 01 00 08 50 57 42 54 01 00 07 5b 80  WAKS...PWBT...[.
  1600: 53 4d 49 45 01 50 4d 33 30 0a 08 5b 81 16 53 4d  SMIE.PM30..[..SM
  1610: 49 45 01 00 04 50 53 31 45 01 00 1f 50 53 31 53  IE...PS1E...PS1S
  1620: 01 00 1b 10 4d 07 5c 5f 53 42 5f 08 53 4c 50 53  ....M.\_SB_.SLPS
  1630: 00 5b 82 4e 06 53 4c 50 42 08 5f 48 49 44 0c 41  .[.N.SLPB._HID.A
  1640: d0 0c 0e 14 15 5f 53 54 41 00 a0 0c 92 93 53 55  ....._STA.....SU
  1650: 53 57 0a ff a4 0a 0f a4 00 14 1c 53 42 45 56 00  SW.........SBEV.
  1660: a0 0c 53 4c 50 53 86 53 4c 50 42 0a 02 a1 08 86  ..SLPS.SLPB.....
  1670: 53 4c 50 42 0a 80 14 1b 5c 2e 5f 47 50 45 5f 4c  SLPB....\._GPE_L
  1680: 31 42 00 5c 2f 03 5f 53 42 5f 53 4c 50 42 53 42  1B.\/._SB_SLPBSB
  1690: 45 56 14 0e 5f 50 52 57 00 a4 12 06 02 0a 1b 0a  EV.._PRW........
  16a0: 04 5b 82 2b 50 49 43 5f 08 5f 48 49 44 0b 41 d0  .[.+PIC_._HID.A.
  16b0: 08 5f 43 52 53 11 18 0a 15 47 01 20 00 20 00 00  ._CRS....G. . ..
  16c0: 02 47 01 a0 00 a0 00 00 02 22 04 00 79 00 5b 82  .G......."..y.[.
  16d0: 4e 04 44 4d 41 44 08 5f 48 49 44 0c 41 d0 02 00  N.DMAD._HID.A...
  16e0: 08 5f 43 52 53 11 38 0a 35 2a 10 04 47 01 00 00  ._CRS.8.5*..G...
  16f0: 00 00 00 10 47 01 81 00 81 00 00 03 47 01 87 00  ....G.......G...
  1700: 87 00 00 01 47 01 89 00 89 00 00 03 47 01 8f 00  ....G.......G...
  1710: 8f 00 00 01 47 01 c0 00 c0 00 00 20 79 00 5b 82  ....G...... y.[.
  1720: 25 54 4d 52 5f 08 5f 48 49 44 0c 41 d0 01 00 08  %TMR_._HID.A....
  1730: 5f 43 52 53 11 10 0a 0d 47 01 40 00 40 00 00 04  _CRS....G.@.@...
  1740: 22 01 00 79 00 5b 82 25 52 54 43 30 08 5f 48 49  "..y.[.%RTC0._HI
  1750: 44 0c 41 d0 0b 00 08 5f 43 52 53 11 10 0a 0d 47  D.A...._CRS....G
  1760: 01 70 00 70 00 00 02 22 00 01 79 00 5b 82 22 53  .p.p..."..y.[."S
  1770: 50 4b 52 08 5f 48 49 44 0c 41 d0 08 00 08 5f 43  PKR._HID.A...._C
  1780: 52 53 11 0d 0a 0a 47 01 61 00 61 00 00 01 79 00  RS....G.a.a...y.
  1790: 5b 82 25 43 4f 50 52 08 5f 48 49 44 0c 41 d0 0c  [.%COPR._HID.A..
  17a0: 04 08 5f 43 52 53 11 10 0a 0d 47 01 f0 00 f0 00  .._CRS....G.....
  17b0: 00 10 22 00 20 79 00 5b 82 42 05 50 53 32 4b 08  ..". y.[.B.PS2K.
  17c0: 5f 48 49 44 0c 41 d0 03 03 08 5f 43 49 44 0c 41  _HID.A...._CID.A
  17d0: d0 03 0b 14 19 5f 53 54 41 00 79 01 0a 0a 60 a0  ....._STA.y...`.
  17e0: 0b 7b 49 4f 53 54 60 00 a4 0a 0f a4 00 08 5f 43  .{IOST`......._C
  17f0: 52 53 11 18 0a 15 47 01 60 00 60 00 00 01 47 01  RS....G.`.`...G.
  1800: 64 00 64 00 00 01 22 02 00 79 00 14 14 2e 50 53  d.d..."..y....PS
  1810: 32 4b 5f 50 52 57 00 a4 47 50 52 57 0a 1d 0a 04  2K_PRW..GPRW....
  1820: 5b 82 49 07 50 53 32 4d 08 5f 48 49 44 0c 41 d0  [.I.PS2M._HID.A.
  1830: 0f 03 08 5f 43 49 44 0c 41 d0 0f 13 14 19 5f 53  ..._CID.A....._S
  1840: 54 41 00 79 01 0a 0c 60 a0 0b 7b 49 4f 53 54 60  TA.y...`..{IOST`
  1850: 00 a4 0a 0f a4 00 08 4d 32 52 30 11 08 0a 05 22  .......M2R0...."
  1860: 00 10 79 00 08 4d 32 52 31 11 10 0a 0d 4b 60 00  ..y..M2R1....K`.
  1870: 01 4b 64 00 01 22 00 10 79 00 14 20 5f 43 52 53  .Kd.."..y.. _CRS
  1880: 00 79 01 0a 0a 60 a0 0d 7b 49 4f 53 54 60 00 a4  .y...`..{IOST`..
  1890: 4d 32 52 30 a1 06 a4 4d 32 52 31 14 14 2e 50 53  M2R0...M2R1...PS
  18a0: 32 4d 5f 50 52 57 00 a4 47 50 52 57 0a 1d 0a 04  2M_PRW..GPRW....
  18b0: 5b 82 46 1b 53 49 4f 52 08 5f 48 49 44 0c 41 d0  [.F.SIOR._HID.A.
  18c0: 0c 02 14 0b 5f 55 49 44 00 a4 53 50 49 4f 08 43  ...._UID..SPIO.C
  18d0: 52 53 5f 11 2d 0a 2a 47 01 00 00 00 00 00 00 47  RS_.-.*G.......G
  18e0: 01 00 00 00 00 00 00 47 01 00 00 00 00 00 00 47  .......G.......G
  18f0: 01 00 00 00 00 00 00 47 01 00 00 00 00 00 00 79  .......G.......y
  1900: 00 14 46 16 5f 43 52 53 00 a0 4d 04 90 92 93 53  ..F._CRS..M....S
  1910: 50 49 4f 0b f0 03 94 53 50 49 4f 0a f0 8b 43 52  PIO....SPIO...CR
  1920: 53 5f 0a 02 47 50 31 30 8b 43 52 53 5f 0a 04 47  S_..GP10.CRS_..G
  1930: 50 31 31 8c 43 52 53 5f 0a 07 47 50 4c 31 70 53  P11.CRS_..GPL1pS
  1940: 50 49 4f 47 50 31 30 70 53 50 49 4f 47 50 31 31  PIOGP10pSPIOGP11
  1950: 70 0a 02 47 50 4c 31 a0 42 04 49 4f 50 42 8b 43  p..GPL1.B.IOPB.C
  1960: 52 53 5f 0a 0a 47 50 32 30 8b 43 52 53 5f 0a 0c  RS_..GP20.CRS_..
  1970: 47 50 32 31 8c 43 52 53 5f 0a 0f 47 50 4c 32 70  GP21.CRS_..GPL2p
  1980: 49 4f 50 42 47 50 32 30 70 49 4f 50 42 47 50 32  IOPBGP20pIOPBGP2
  1990: 31 70 49 4f 50 4c 47 50 4c 32 a0 42 04 49 4f 45  1pIOPLGPL2.B.IOE
  19a0: 42 8b 43 52 53 5f 0a 12 47 50 33 30 8b 43 52 53  B.CRS_..GP30.CRS
  19b0: 5f 0a 14 47 50 33 31 8c 43 52 53 5f 0a 17 47 50  _..GP31.CRS_..GP
  19c0: 4c 33 70 49 4f 45 42 47 50 33 30 70 49 4f 45 42  L3pIOEBGP30pIOEB
  19d0: 47 50 33 31 70 49 4f 45 4c 47 50 4c 33 a0 42 04  GP31pIOELGPL3.B.
  19e0: 49 4f 47 42 8b 43 52 53 5f 0a 1a 47 50 34 30 8b  IOGB.CRS_..GP40.
  19f0: 43 52 53 5f 0a 1c 47 50 34 31 8c 43 52 53 5f 0a  CRS_..GP41.CRS_.
  1a00: 1f 47 50 4c 34 70 49 4f 47 42 47 50 34 30 70 49  .GPL4pIOGBGP40pI
  1a10: 4f 47 42 47 50 34 31 70 49 4f 47 4c 47 50 4c 34  OGBGP41pIOGLGPL4
  1a20: a0 42 04 49 4f 53 42 8b 43 52 53 5f 0a 22 47 50  .B.IOSB.CRS_."GP
  1a30: 35 30 8b 43 52 53 5f 0a 24 47 50 35 31 8c 43 52  50.CRS_.$GP51.CR
  1a40: 53 5f 0a 27 47 50 4c 35 70 49 4f 53 42 47 50 35  S_.'GPL5pIOSBGP5
  1a50: 30 70 49 4f 53 42 47 50 35 31 70 49 4f 53 4c 47  0pIOSBGP51pIOSLG
  1a60: 50 4c 35 a4 43 52 53 5f 08 44 43 41 54 12 2c 16  PL5.CRS_.DCAT.,.
  1a70: 01 0a 02 0a 03 00 0a ff 0a ff 0a ff 0a ff 0a ff  ................
  1a80: 0a ff 0a ff 0a ff 0a ff 0a ff 0a ff 0a ff 0a 0a  ................
  1a90: 0a ff 0a ff 0a ff 0a ff 0a ff 08 49 4b 45 59 12  ...........IKEY.
  1aa0: 16 02 12 09 04 0a 87 01 0a 55 0a 55 12 09 04 0a  .........U.U....
  1ab0: 87 01 0a 55 0a aa 08 4b 42 46 47 01 08 4d 53 46  ...U...KBFG..MSF
  1ac0: 47 01 08 55 52 31 46 01 14 45 04 45 4e 46 47 01  G..UR1F..E.ENFG.
  1ad0: 70 00 61 a0 0b 93 53 50 49 4f 0a 2e 70 00 61 a0  p.a...SPIO..p.a.
  1ae0: 0b 93 53 50 49 4f 0a 4e 70 01 61 70 00 60 a2 19  ..SPIO.Np.ap.`..
  1af0: 92 93 60 0a 04 70 83 88 83 88 49 4b 45 59 61 00  ..`..p....IKEYa.
  1b00: 60 00 49 4e 44 58 75 60 70 68 4c 44 4e 5f 14 14  `.INDXu`phLDN_..
  1b10: 45 58 46 47 00 70 0a 02 49 4e 44 58 70 0a 02 44  EXFG.p..INDXp..D
  1b20: 41 54 41 14 1d 4c 50 54 4d 01 45 4e 46 47 43 47  ATA..LPTM.ENFGCG
  1b30: 4c 44 68 7b 4f 50 54 30 0a 02 60 45 58 46 47 a4  LDh{OPT0..`EXFG.
  1b40: 60 14 2a 55 48 49 44 01 45 4e 46 47 43 47 4c 44  `.*UHID.ENFGCGLD
  1b50: 68 7b 4f 50 54 30 0a 70 60 45 58 46 47 a0 08 60  h{OPT0.p`EXFG..`
  1b60: a4 0c 41 d0 05 10 a4 0c 41 d0 05 01 14 19 4f 52  ..A.....A.....OR
  1b70: 46 30 02 45 4e 46 47 68 7d 4f 50 54 30 69 4f 50  F0.ENFGh}OPT0iOP
  1b80: 54 30 45 58 46 47 14 19 4f 52 46 31 02 45 4e 46  T0EXFG..ORF1.ENF
  1b90: 47 68 7d 4f 50 54 31 69 4f 50 54 31 45 58 46 47  Gh}OPT1iOPT1EXFG
  1ba0: 14 19 4f 52 46 32 02 45 4e 46 47 68 7d 4f 50 54  ..ORF2.ENFGh}OPT
  1bb0: 32 69 4f 50 54 32 45 58 46 47 14 19 41 4e 46 30  2iOPT2EXFG..ANF0
  1bc0: 02 45 4e 46 47 68 7b 4f 50 54 30 69 4f 50 54 30  .ENFGh{OPT0iOPT0
  1bd0: 45 58 46 47 14 19 41 4e 46 32 02 45 4e 46 47 68  EXFG..ANF2.ENFGh
  1be0: 7b 4f 50 54 32 69 4f 50 54 32 45 58 46 47 14 19  {OPT2iOPT2EXFG..
  1bf0: 41 4e 46 34 02 45 4e 46 47 68 7b 4f 50 54 34 69  ANF4.ENFGh{OPT4i
  1c00: 4f 50 54 34 45 58 46 47 14 15 53 54 46 30 02 45  OPT4EXFG..STF0.E
  1c10: 4e 46 47 68 70 69 4f 50 54 30 45 58 46 47 14 15  NFGhpiOPT0EXFG..
  1c20: 53 54 46 31 02 45 4e 46 47 68 70 69 4f 50 54 31  STF1.ENFGhpiOPT1
  1c30: 45 58 46 47 14 4c 0a 53 49 4f 53 01 70 0d 53 49  EXFG.L.SIOS.p.SI
  1c40: 4f 53 00 5b 31 a0 4b 09 95 68 0a 05 45 4e 46 47  OS.[1.K..h..ENFG
  1c50: 0a 04 70 01 41 43 54 52 45 58 46 47 41 4e 46 34  ..p.ACTREXFGANF4
  1c60: 0a 04 0a fc a0 15 4b 42 46 47 4f 52 46 31 0a 04  ......KBFGORF1..
  1c70: 0a 08 4f 52 46 30 0a 04 0a 08 a1 19 41 4e 46 30  ..ORF0......ANF0
  1c80: 0a 04 0a f7 45 4e 46 47 0a 05 70 00 41 43 54 52  ....ENFG..p.ACTR
  1c90: 45 58 46 47 a0 15 4d 53 46 47 4f 52 46 31 0a 04  EXFG..MSFGORF1..
  1ca0: 0a 10 4f 52 46 30 0a 04 0a 10 a1 19 41 4e 46 30  ..ORF0......ANF0
  1cb0: 0a 04 0a ef 45 4e 46 47 0a 06 70 00 41 43 54 52  ....ENFG..p.ACTR
  1cc0: 45 58 46 47 41 4e 46 32 0a 04 0a f0 45 4e 46 47  EXFGANF2....ENFG
  1cd0: 0a 07 7b 4f 50 32 39 0a ef 4f 50 32 39 45 58 46  ..{OP29..OP29EXF
  1ce0: 47 14 40 07 53 49 4f 57 01 70 0d 53 49 4f 57 00  G.@.SIOW.p.SIOW.
  1cf0: 5b 31 53 54 46 30 0a 04 00 53 54 46 31 0a 04 0a  [1STF0...STF1...
  1d00: ff 45 4e 46 47 0a 07 7d 4f 50 32 39 0a 10 4f 50  .ENFG..}OP29..OP
  1d10: 32 39 45 58 46 47 45 4e 46 47 0a 05 7d 41 43 54  29EXFGENFG..}ACT
  1d20: 52 01 41 43 54 52 45 58 46 47 45 4e 46 47 0a 06  R.ACTREXFGENFG..
  1d30: 7d 41 43 54 52 01 41 43 54 52 45 58 46 47 45 4e  }ACTR.ACTREXFGEN
  1d40: 46 47 0a 07 7d 4f 50 46 39 01 4f 50 46 39 45 58  FG..}OPF9.OPF9EX
  1d50: 46 47 14 0f 53 49 4f 48 00 70 0d 53 49 4f 48 00  FG..SIOH.p.SIOH.
  1d60: 5b 31 5b 80 49 4f 49 44 01 53 50 49 4f 0a 02 5b  [1[.IOID.SPIO..[
  1d70: 81 10 49 4f 49 44 01 49 4e 44 58 08 44 41 54 41  ..IOID.INDX.DATA
  1d80: 08 5b 86 4a 06 49 4e 44 58 44 41 54 41 01 00 38  .[.J.INDXDATA..8
  1d90: 4c 44 4e 5f 08 00 48 10 4f 50 32 39 08 00 30 41  LDN_..H.OP29..0A
  1da0: 43 54 52 08 00 48 17 49 4f 41 48 08 49 4f 41 4c  CTR..H.IOAH.IOAL
  1db0: 08 49 4f 48 32 08 49 4f 4c 32 08 00 40 06 49 4e  .IOH2.IOL2..@.IN
  1dc0: 54 52 08 00 18 44 4d 43 48 08 00 48 3d 4f 50 54  TR...DMCH..H=OPT
  1dd0: 30 08 4f 50 54 31 08 4f 50 54 32 08 4f 50 54 33  0.OPT1.OPT2.OPT3
  1de0: 08 4f 50 54 34 08 00 20 4f 50 46 39 08 14 1c 2e  .OPT4.. OPF9....
  1df0: 50 53 32 4b 5f 50 53 57 01 a0 08 68 70 01 4b 42  PS2K_PSW...hp.KB
  1e00: 46 47 a1 07 70 00 4b 42 46 47 14 1c 2e 50 53 32  FG..p.KBFG...PS2
  1e10: 4d 5f 50 53 57 01 a0 08 68 70 01 4d 53 46 47 a1  M_PSW...hp.MSFG.
  1e20: 07 70 00 4d 53 46 47 14 0f 43 47 4c 44 01 a4 83  .p.MSFG..CGLD...
  1e30: 88 44 43 41 54 68 00 14 4e 04 44 53 54 41 01 45  .DCATh..N.DSTA.E
  1e40: 4e 46 47 43 47 4c 44 68 70 41 43 54 52 60 45 58  NFGCGLDhpACTR`EX
  1e50: 46 47 a0 07 93 60 0a ff a4 00 7b 60 01 60 7d 49  FG...`....{`.`}I
  1e60: 4f 53 54 79 60 68 00 49 4f 53 54 a0 05 60 a4 0a  OSTy`h.IOST..`..
  1e70: 0f a1 14 a0 0e 7b 79 01 68 00 49 4f 53 54 00 a4  .....{y.h.IOST..
  1e80: 0a 0d a1 03 a4 00 14 4f 04 44 43 4e 54 02 45 4e  .......O.DCNT.EN
  1e90: 46 47 43 47 4c 44 68 79 49 4f 41 48 0a 08 61 7d  FGCGLDhyIOAH..a}
  1ea0: 49 4f 41 4c 61 61 a0 1c 90 95 44 4d 43 48 0a 04  IOALaa....DMCH..
  1eb0: 92 93 7b 44 4d 43 48 0a 03 61 00 52 44 4d 41 68  ..{DMCH..a.RDMAh
  1ec0: 69 75 61 70 69 41 43 54 52 52 52 49 4f 68 69 61  iuapiACTRRRIOhia
  1ed0: 0a 08 45 58 46 47 08 43 52 53 31 11 13 0a 10 47  ..EXFG.CRS1....G
  1ee0: 01 00 00 00 00 01 00 22 00 00 2a 00 00 79 00 8b  ......."..*..y..
  1ef0: 43 52 53 31 0a 09 49 52 51 4d 8c 43 52 53 31 0a  CRS1..IRQM.CRS1.
  1f00: 0c 44 4d 41 4d 8b 43 52 53 31 0a 02 49 4f 31 31  .DMAM.CRS1..IO11
  1f10: 8b 43 52 53 31 0a 04 49 4f 31 32 8c 43 52 53 31  .CRS1..IO12.CRS1
  1f20: 0a 07 4c 45 4e 31 08 43 52 53 32 11 1b 0a 18 47  ..LEN1.CRS2....G
  1f30: 01 00 00 00 00 01 00 47 01 00 00 00 00 01 00 22  .......G......."
  1f40: 40 00 2a 04 00 79 00 8b 43 52 53 32 0a 11 49 52  @.*..y..CRS2..IR
  1f50: 51 45 8c 43 52 53 32 0a 14 44 4d 41 45 8b 43 52  QE.CRS2..DMAE.CR
  1f60: 53 32 0a 02 49 4f 32 31 8b 43 52 53 32 0a 04 49  S2..IO21.CRS2..I
  1f70: 4f 32 32 8c 43 52 53 32 0a 07 4c 45 4e 32 8b 43  O22.CRS2..LEN2.C
  1f80: 52 53 32 0a 0a 49 4f 33 31 8b 43 52 53 32 0a 0c  RS2..IO31.CRS2..
  1f90: 49 4f 33 32 8c 43 52 53 32 0a 0f 4c 45 4e 33 14  IO32.CRS2..LEN3.
  1fa0: 46 08 44 43 52 53 02 45 4e 46 47 43 47 4c 44 68  F.DCRS.ENFGCGLDh
  1fb0: 79 49 4f 41 48 0a 08 49 4f 31 31 7d 49 4f 41 4c  yIOAH..IO11}IOAL
  1fc0: 49 4f 31 31 49 4f 31 31 70 49 4f 31 31 49 4f 31  IO11IO11pIO11IO1
  1fd0: 32 74 82 49 4f 31 31 00 01 60 79 01 60 4c 45 4e  2t.IO11..`y.`LEN
  1fe0: 31 a0 0f 49 4e 54 52 79 01 49 4e 54 52 49 52 51  1..INTRy.INTRIRQ
  1ff0: 4d a1 07 70 00 49 52 51 4d a0 12 91 94 44 4d 43  M..p.IRQM....DMC
  2000: 48 0a 03 93 69 00 70 00 44 4d 41 4d a1 10 7b 44  H...i.p.DMAM..{D
  2010: 4d 43 48 0a 03 61 79 01 61 44 4d 41 4d 45 58 46  MCH..ay.aDMAMEXF
  2020: 47 a4 43 52 53 31 14 43 0a 44 53 52 53 02 8b 68  G.CRS1.C.DSRS..h
  2030: 0a 09 49 52 51 4d 8c 68 0a 0c 44 4d 41 4d 8b 68  ..IRQM.h..DMAM.h
  2040: 0a 02 49 4f 31 31 45 4e 46 47 43 47 4c 44 69 79  ..IO11ENFGCGLDiy
  2050: 49 4f 41 48 0a 08 61 7d 49 4f 41 4c 61 61 52 52  IOAH..a}IOALaaRR
  2060: 49 4f 69 00 61 0a 08 52 52 49 4f 69 01 49 4f 31  IOi.a..RRIOi.IO1
  2070: 31 0a 08 7b 49 4f 31 31 0a ff 49 4f 41 4c 7a 49  1..{IO11..IOALzI
  2080: 4f 31 31 0a 08 49 4f 41 48 a0 12 49 52 51 4d 82  O11..IOAH..IRQM.
  2090: 49 52 51 4d 60 74 60 01 49 4e 54 52 a1 07 70 00  IRQM`t`.INTR..p.
  20a0: 49 4e 54 52 a0 12 44 4d 41 4d 82 44 4d 41 4d 60  INTR..DMAM.DMAM`
  20b0: 74 60 01 44 4d 43 48 a1 08 70 0a 04 44 4d 43 48  t`.DMCH..p..DMCH
  20c0: 45 58 46 47 44 43 4e 54 69 01 5b 82 4f 20 52 4d  EXFGDCNTi.[.O RM
  20d0: 53 43 08 5f 48 49 44 0c 41 d0 0c 02 08 5f 55 49  SC._HID.A...._UI
  20e0: 44 0a 10 08 43 52 53 5f 11 42 0b 0a ae 47 01 10  D...CRS_.B...G..
  20f0: 00 10 00 00 10 47 01 22 00 22 00 00 1e 47 01 44  .....G."."...G.D
  2100: 00 44 00 00 1c 47 01 62 00 62 00 00 02 47 01 65  .D...G.b.b...G.e
  2110: 00 65 00 00 0b 47 01 72 00 72 00 00 0e 47 01 80  .e...G.r.r...G..
  2120: 00 80 00 00 01 47 01 84 00 84 00 00 03 47 01 88  .....G.......G..
  2130: 00 88 00 00 01 47 01 8c 00 8c 00 00 03 47 01 90  .....G.......G..
  2140: 00 90 00 00 10 47 01 a2 00 a2 00 00 1e 47 01 e0  .....G.......G..
  2150: 00 e0 00 00 10 47 01 d0 04 d0 04 00 02 47 01 00  .....G.......G..
  2160: 00 00 00 00 00 47 01 00 00 00 00 00 00 47 01 00  .....G.......G..
  2170: 00 00 00 00 00 86 09 00 01 00 c0 d1 fe 00 40 00  ..............@.
  2180: 00 86 09 00 01 00 00 00 00 00 00 00 00 86 09 00  ................
  2190: 01 00 00 00 00 00 00 00 00 79 00 14 4f 13 5f 43  .........y..O._C
  21a0: 52 53 00 8b 43 52 53 5f 0a 72 47 50 30 30 8b 43  RS..CRS_.rGP00.C
  21b0: 52 53 5f 0a 74 47 50 30 31 8c 43 52 53 5f 0a 77  RS_.tGP01.CRS_.w
  21c0: 47 50 30 4c 70 50 4d 42 53 47 50 30 30 70 50 4d  GP0LpPMBSGP00pPM
  21d0: 42 53 47 50 30 31 70 50 4d 4c 4e 47 50 30 4c a0  BSGP01pPMLNGP0L.
  21e0: 42 04 53 4d 42 53 8b 43 52 53 5f 0a 7a 47 50 31  B.SMBS.CRS_.zGP1
  21f0: 30 8b 43 52 53 5f 0a 7c 47 50 31 31 8c 43 52 53  0.CRS_.|GP11.CRS
  2200: 5f 0a 7f 47 50 31 4c 70 53 4d 42 53 47 50 31 30  _..GP1LpSMBSGP10
  2210: 70 53 4d 42 53 47 50 31 31 70 53 4d 42 4c 47 50  pSMBSGP11pSMBLGP
  2220: 31 4c a0 42 04 47 50 42 53 8b 43 52 53 5f 0a 82  1L.B.GPBS.CRS_..
  2230: 47 50 32 30 8b 43 52 53 5f 0a 84 47 50 32 31 8c  GP20.CRS_..GP21.
  2240: 43 52 53 5f 0a 87 47 50 32 4c 70 47 50 42 53 47  CRS_..GP2LpGPBSG
  2250: 50 32 30 70 47 50 42 53 47 50 32 31 70 47 50 4c  P20pGPBSGP21pGPL
  2260: 4e 47 50 32 4c 8a 43 52 53 5f 0a 9c 54 4d 4c 31  NGP2L.CRS_..TML1
  2270: 8a 43 52 53 5f 0a 98 54 4d 42 31 8a 43 52 53 5f  .CRS_..TMB1.CRS_
  2280: 0a a8 54 4d 4c 32 8a 43 52 53 5f 0a a4 54 4d 42  ..TML2.CRS_..TMB
  2290: 32 70 0c 00 00 d2 fe 54 4d 42 31 74 54 50 42 41  2p.....TMB1tTPBA
  22a0: 0c 00 00 d2 fe 54 4d 4c 31 a0 12 54 50 4d 46 72  .....TML1..TPMFr
  22b0: 54 50 42 41 54 50 42 4c 54 4d 42 32 a1 0b 72 54  TPBATPBLTMB2..rT
  22c0: 50 42 41 00 54 4d 42 32 74 0c 00 00 d9 fe 54 4d  PBA.TMB2t.....TM
  22d0: 42 32 54 4d 4c 32 a4 43 52 53 5f 5b 82 4c 09 48  B2TML2.CRS_[.L.H
  22e0: 50 45 54 08 5f 48 49 44 0c 41 d0 01 03 08 43 52  PET._HID.A....CR
  22f0: 53 5f 11 11 0a 0e 86 09 00 00 00 00 d0 fe 00 04  S_..............
  2300: 00 00 79 00 5b 80 5e 4c 50 43 52 00 0c 04 f4 d1  ..y.[.^LPCR.....
  2310: fe 0a 04 5b 81 14 4c 50 43 52 00 48 50 54 53 02  ...[..LPCR.HPTS.
  2320: 00 05 48 50 54 45 01 00 18 14 24 5f 53 54 41 00  ..HPTE....$_STA.
  2330: a0 10 93 4f 53 46 4c 00 a0 08 48 50 54 45 a4 0a  ...OSFL...HPTE..
  2340: 0f a1 0a a0 08 48 50 54 45 a4 0a 0b a4 00 14 2a  .....HPTE......*
  2350: 5f 43 52 53 00 8a 43 52 53 5f 0a 04 48 50 54 5f  _CRS..CRS_..HPT_
  2360: 77 48 50 54 53 0b 00 10 60 72 60 0c 00 00 d0 fe  wHPTS...`r`.....
  2370: 48 50 54 5f a4 43 52 53 5f 5b 80 52 58 38 30 02  HPT_.CRS_[.RX80.
  2380: 00 0a ff 5b 81 13 52 58 38 30 01 00 40 40 4c 50  ...[..RX80..@@LP
  2390: 43 44 10 4c 50 43 45 10 08 44 42 50 54 12 4e 04  CD.LPCE..DBPT.N.
  23a0: 04 12 1a 08 0b f8 03 0b f8 02 0b 20 02 0b 28 02  ........... ..(.
  23b0: 0b 38 02 0b e8 02 0b 38 03 0b e8 03 12 1a 08 0b  .8.....8........
  23c0: f8 03 0b f8 02 0b 20 02 0b 28 02 0b 38 02 0b e8  ...... ..(..8...
  23d0: 02 0b 38 03 0b e8 03 12 0b 03 0b 78 03 0b 78 02  ..8........x..x.
  23e0: 0b bc 03 12 08 02 0b f0 03 0b 70 03 08 44 44 4c  ..........p..DDL
  23f0: 54 12 21 04 12 06 02 00 0b f8 ff 12 07 02 0a 04  T.!.............
  2400: 0b 8f ff 12 07 02 0a 08 0b ff fc 12 07 02 0a 0c  ................
  2410: 0b ff ef 14 4b 09 52 52 49 4f 04 a0 4c 05 90 92  ....K.RRIO..L...
  2420: 94 68 0a 03 92 95 68 00 70 89 83 88 44 42 50 54  .h....h.p...DBPT
  2430: 68 00 01 6a 00 00 00 60 a0 3f 92 93 60 ff 70 83  h..j...`.?..`.p.
  2440: 88 83 88 44 44 4c 54 68 00 00 00 61 70 83 88 83  ...DDLTh...ap...
  2450: 88 44 44 4c 54 68 00 01 00 62 79 60 61 60 7b 4c  .DDLTh...by`a`{L
  2460: 50 43 44 62 4c 50 43 44 7d 4c 50 43 44 60 4c 50  PCDbLPCD}LPCD`LP
  2470: 43 44 57 58 38 32 68 69 a0 23 93 68 0a 08 a0 0d  CDWX82hi.#.h....
  2480: 93 6a 0b 00 02 57 58 38 32 0a 08 68 a1 0f a0 0d  .j...WX82..h....
  2490: 93 6a 0b 08 02 57 58 38 32 0a 09 68 a0 12 90 92  .j...WX82..h....
  24a0: 94 68 0a 0d 92 95 68 0a 0a 57 58 38 32 68 69 14  .h....h..WX82hi.
  24b0: 26 57 58 38 32 02 79 01 68 60 a0 0c 69 7d 4c 50  &WX82.y.h`..i}LP
  24c0: 43 45 60 4c 50 43 45 a1 0e 80 60 60 7b 4c 50 43  CE`LPCE...``{LPC
  24d0: 45 60 4c 50 43 45 14 06 52 44 4d 41 03 5b 82 41  E`LPCE..RDMA.[.A
  24e0: 0b 46 57 48 5f 08 5f 48 49 44 0c 25 d4 08 00 08  .FWH_._HID.%....
  24f0: 43 52 53 5f 11 1d 0a 1a 86 09 00 00 00 00 00 00  CRS_............
  2500: 00 00 00 00 86 09 00 00 00 00 00 00 00 00 00 00  ................
  2510: 79 00 8a 43 52 53 5f 0a 04 42 53 30 30 8a 43 52  y..CRS_..BS00.CR
  2520: 53 5f 0a 08 42 4c 30 30 8a 43 52 53 5f 0a 10 42  S_..BL00.CRS_..B
  2530: 53 31 30 8a 43 52 53 5f 0a 14 42 4c 31 30 14 41  S10.CRS_..BL10.A
  2540: 05 5f 43 52 53 00 70 0c 00 00 80 ff 60 82 46 48  ._CRS.p.....`.FH
  2550: 44 30 61 76 61 a0 0a 61 77 61 0c 00 00 08 00 61  D0ava..awa.....a
  2560: 72 60 61 62 70 62 42 53 30 30 72 42 53 30 30 0c  r`abpbBS00rBS00.
  2570: 00 00 40 00 42 53 31 30 74 00 42 53 31 30 42 4c  ..@.BS10t.BS10BL
  2580: 30 30 70 42 4c 30 30 42 4c 31 30 a4 43 52 53 5f  00pBL00BL10.CRS_
  2590: 5b 82 4a 09 46 57 48 45 08 5f 48 49 44 0c 41 d0  [.J.FWHE._HID.A.
  25a0: 0c 02 08 5f 55 49 44 0a 03 08 43 52 53 5f 11 11  ..._UID...CRS_..
  25b0: 0a 0e 86 09 00 00 00 00 00 00 00 00 00 00 79 00  ..............y.
  25c0: 14 4b 06 5f 43 52 53 00 8a 43 52 53 5f 0a 04 42  .K._CRS..CRS_..B
  25d0: 53 30 30 8a 43 52 53 5f 0a 08 42 4c 30 30 a0 19  S00.CRS_..BL00..
  25e0: 93 5e 5e 2e 46 57 48 5f 42 53 30 30 00 5e 5e 2e  .^^.FWH_BS00.^^.
  25f0: 46 57 48 5f 5f 43 52 53 72 5e 5e 2e 46 57 48 5f  FWH__CRSr^^.FWH_
  2600: 42 53 30 30 5e 5e 2e 46 57 48 5f 42 4c 30 30 42  BS00^^.FWH_BL00B
  2610: 53 30 30 74 5e 5e 2e 46 57 48 5f 42 53 31 30 42  S00t^^.FWH_BS10B
  2620: 53 30 30 42 4c 30 30 a4 43 52 53 5f 5b 80 46 48  S00BL00.CRS_[.FH
  2630: 52 30 02 0a d8 0a 02 5b 81 12 46 48 52 30 01 46  R0.....[..FHR0.F
  2640: 48 44 31 04 00 04 46 48 44 30 08 5b 82 43 06 5e  HD1...FHD0.[.C.^
  2650: 50 43 49 45 08 5f 48 49 44 0c 41 d0 0c 02 08 5f  PCIE._HID.A...._
  2660: 55 49 44 0a 11 08 43 52 53 5f 11 11 0a 0e 86 09  UID...CRS_......
  2670: 00 00 00 00 00 e0 00 00 00 10 79 00 14 33 5f 43  ..........y..3_C
  2680: 52 53 00 8a 43 52 53 5f 0a 04 42 41 53 31 8a 43  RS..CRS_..BAS1.C
  2690: 52 53 5f 0a 08 4c 45 4e 31 70 50 43 49 42 42 41  RS_..LEN1pPCIBBA
  26a0: 53 31 70 50 43 49 4c 4c 45 4e 31 a4 43 52 53 5f  S1pPCILLEN1.CRS_
  26b0: 5b 82 4e 12 4f 4d 53 43 08 5f 48 49 44 0c 41 d0  [.N.OMSC._HID.A.
  26c0: 0c 02 08 5f 55 49 44 00 08 43 52 53 5f 11 1d 0a  ..._UID..CRS_...
  26d0: 1a 86 09 00 00 00 00 00 00 00 00 00 00 86 09 00  ................
  26e0: 00 00 00 00 00 00 00 00 00 79 00 08 43 52 53 31  .........y..CRS1
  26f0: 11 25 0a 22 4b 60 00 01 4b 64 00 01 86 09 00 00  .%."K`..Kd......
  2700: 00 00 00 00 00 00 00 00 86 09 00 00 00 00 00 00  ................
  2710: 00 00 00 00 79 00 14 49 0c 5f 43 52 53 00 a0 46  ....y..I._CRS..F
  2720: 0a 41 50 49 43 8a 43 52 53 5f 0a 08 4d 4c 30 31  .APIC.CRS_..ML01
  2730: 8a 43 52 53 5f 0a 04 4d 42 30 31 8a 43 52 53 5f  .CRS_..MB01.CRS_
  2740: 0a 14 4d 4c 30 32 8a 43 52 53 5f 0a 10 4d 42 30  ..ML02.CRS_..MB0
  2750: 32 70 0c 00 00 c0 fe 4d 42 30 31 70 0b 00 10 4d  2p.....MB01p...M
  2760: 4c 30 31 70 0c 00 00 e0 fe 4d 42 30 32 70 0b 00  L01p.....MB02p..
  2770: 10 4d 4c 30 32 8a 43 52 53 31 0a 10 4d 4c 30 33  .ML02.CRS1..ML03
  2780: 8a 43 52 53 31 0a 0c 4d 42 30 33 8a 43 52 53 31  .CRS1..MB03.CRS1
  2790: 0a 1c 4d 4c 30 34 8a 43 52 53 31 0a 18 4d 42 30  ..ML04.CRS1..MB0
  27a0: 34 70 0c 00 00 c0 fe 4d 42 30 33 70 0b 00 10 4d  4p.....MB03p...M
  27b0: 4c 30 33 70 0c 00 00 e0 fe 4d 42 30 34 70 0b 00  L03p.....MB04p..
  27c0: 10 4d 4c 30 34 79 0a 05 0a 0a 60 a0 0d 7b 49 4f  .ML04y....`..{IO
  27d0: 53 54 60 00 a4 43 52 53 5f a1 06 a4 43 52 53 31  ST`..CRS_...CRS1
  27e0: 5b 82 43 14 5e 5e 52 4d 45 4d 08 5f 48 49 44 0c  [.C.^^RMEM._HID.
  27f0: 41 d0 0c 01 08 5f 55 49 44 01 08 43 52 53 5f 11  A...._UID..CRS_.
  2800: 42 04 0a 3e 86 09 00 01 00 00 00 00 00 00 0a 00  B..>............
  2810: 86 09 00 00 00 00 00 00 00 00 00 00 86 09 00 00  ................
  2820: 00 00 0e 00 00 00 02 00 86 09 00 01 00 00 10 00  ................
  2830: 00 00 00 00 86 09 00 00 00 00 00 00 00 00 00 00  ................
  2840: 79 00 14 42 0e 5f 43 52 53 00 8a 43 52 53 5f 0a  y..B._CRS..CRS_.
  2850: 10 42 41 53 31 8a 43 52 53 5f 0a 14 4c 45 4e 31  .BAS1.CRS_..LEN1
  2860: 8a 43 52 53 5f 0a 1c 42 41 53 32 8a 43 52 53 5f  .CRS_..BAS2.CRS_
  2870: 0a 20 4c 45 4e 32 8a 43 52 53 5f 0a 2c 4c 45 4e  . LEN2.CRS_.,LEN
  2880: 33 8a 43 52 53 5f 0a 34 42 41 53 34 8a 43 52 53  3.CRS_.4BAS4.CRS
  2890: 5f 0a 38 4c 45 4e 34 a0 05 4f 53 46 4c a1 41 06  _.8LEN4..OSFL.A.
  28a0: a0 28 4d 47 31 42 a0 22 94 4d 47 31 42 0c 00 00  .(MG1B.".MG1B...
  28b0: 0c 00 70 0c 00 00 0c 00 42 41 53 31 74 4d 47 31  ..p.....BAS1tMG1
  28c0: 42 42 41 53 31 4c 45 4e 31 a1 15 70 0c 00 00 0c  BBAS1LEN1..p....
  28d0: 00 42 41 53 31 70 0c 00 00 02 00 4c 45 4e 31 a0  .BAS1p.....LEN1.
  28e0: 1f 72 4d 47 31 42 4d 47 31 4c 60 70 60 42 41 53  .rMG1BMG1L`p`BAS
  28f0: 32 74 0c 00 00 10 00 42 41 53 32 4c 45 4e 32 74  2t.....BAS2LEN2t
  2900: 4d 47 32 42 0c 00 00 10 00 4c 45 4e 33 70 4d 48  MG2B.....LEN3pMH
  2910: 31 42 42 41 53 34 74 00 42 41 53 34 4c 45 4e 34  1BBAS4t.BAS4LEN4
  2920: a4 43 52 53 5f 5b 82 40 cb 53 41 54 41 08 5f 41  .CRS_[.@.SATA._A
  2930: 44 52 0c 02 00 1f 00 08 5e 4e 41 54 41 12 07 01  DR......^NATA...
  2940: 0c 02 00 1f 00 08 5c 46 5a 54 46 11 0a 0a 07 00  ......\FZTF.....
  2950: 00 00 00 00 00 f5 08 52 45 47 46 01 14 12 5f 52  .......REGF..._R
  2960: 45 47 02 a0 0b 93 68 0a 02 70 69 52 45 47 46 08  EG....h..piREGF.
  2970: 54 49 4d 30 12 48 05 08 12 0b 04 0a 78 0a b4 0a  TIM0.H......x...
  2980: f0 0b 84 03 12 09 04 0a 23 0a 21 0a 10 00 12 09  ........#.!.....
  2990: 04 0a 0b 0a 09 0a 04 00 12 0e 06 0a 78 0a 5a 0a  ............x.Z.
  29a0: 3c 0a 28 0a 1e 0a 14 12 0a 06 00 01 0a 02 01 0a  <.(.............
  29b0: 02 01 12 08 06 00 00 00 01 01 01 12 09 04 0a 04  ................
  29c0: 0a 03 0a 02 00 12 07 04 0a 02 01 00 00 08 54 4d  ..............TM
  29d0: 44 30 11 03 0a 14 8a 54 4d 44 30 00 50 49 4f 30  D0.....TMD0.PIO0
  29e0: 8a 54 4d 44 30 0a 04 44 4d 41 30 8a 54 4d 44 30  .TMD0..DMA0.TMD0
  29f0: 0a 08 50 49 4f 31 8a 54 4d 44 30 0a 0c 44 4d 41  ..PIO1.TMD0..DMA
  2a00: 31 8a 54 4d 44 30 0a 10 43 48 4e 46 5b 80 43 46  1.TMD0..CHNF[.CF
  2a10: 47 32 02 0a 40 0a 20 5b 81 48 0a 43 46 47 32 03  G2..@. [.H.CFG2.
  2a20: 50 4d 50 54 04 50 53 50 54 04 50 4d 52 49 06 00  PMPT.PSPT.PMRI..
  2a30: 02 53 4d 50 54 04 53 53 50 54 04 53 4d 52 49 06  .SMPT.SSPT.SMRI.
  2a40: 00 02 50 53 52 49 04 53 53 52 49 04 00 18 50 4d  ..PSRI.SSRI...PM
  2a50: 33 45 01 50 53 33 45 01 53 4d 33 45 01 53 53 33  3E.PS3E.SM3E.SS3
  2a60: 45 01 00 0c 50 4d 55 54 02 00 02 50 53 55 54 02  E...PMUT...PSUT.
  2a70: 00 02 53 4d 55 54 02 00 02 53 53 55 54 02 00 02  ..SMUT...SSUT...
  2a80: 00 40 04 50 4d 36 45 01 50 53 36 45 01 53 4d 36  .@.PM6E.PS6E.SM6
  2a90: 45 01 53 53 36 45 01 50 4d 43 52 01 50 53 43 52  E.SS6E.PMCR.PSCR
  2aa0: 01 53 4d 43 52 01 53 53 43 52 01 00 04 50 4d 41  .SMCR.SSCR...PMA
  2ab0: 45 01 50 53 41 45 01 53 4d 41 45 01 53 53 41 45  E.PSAE.SMAE.SSAE
  2ac0: 01 08 47 4d 50 54 00 08 47 4d 55 45 00 08 47 4d  ..GMPT..GMUE..GM
  2ad0: 55 54 00 08 47 4d 43 52 00 08 47 53 50 54 00 08  UT..GMCR..GSPT..
  2ae0: 47 53 55 45 00 08 47 53 55 54 00 08 47 53 43 52  GSUE..GSUT..GSCR
  2af0: 00 5b 82 4f 22 43 48 4e 30 08 5f 41 44 52 00 14  .[.O"CHN0._ADR..
  2b00: 49 07 5f 47 54 4d 00 79 50 53 43 52 01 61 7d 50  I._GTM.yPSCR.a}P
  2b10: 4d 43 52 61 60 79 50 4d 41 45 0a 02 63 79 50 4d  MCRa`yPMAE..cyPM
  2b20: 36 45 01 64 7d 63 64 63 7d 50 4d 33 45 63 61 79  6E.d}cdc}PM3Ecay
  2b30: 50 4d 50 54 0a 04 63 7d 61 63 61 79 50 53 41 45  PMPT..c}acayPSAE
  2b40: 0a 02 63 79 50 53 36 45 01 64 7d 63 64 63 7d 50  ..cyPS6E.d}cdc}P
  2b50: 53 33 45 63 62 79 50 53 50 54 0a 04 63 7d 62 63  S3EcbyPSPT..c}bc
  2b60: 62 a4 47 54 4d 5f 50 4d 52 49 61 50 4d 55 54 50  b.GTM_PMRIaPMUTP
  2b70: 53 52 49 62 50 53 55 54 60 14 4e 16 5f 53 54 4d  SRIbPSUT`.N._STM
  2b80: 03 70 68 5b 31 70 68 54 4d 44 30 79 50 4d 41 45  .ph[1phTMD0yPMAE
  2b90: 0a 02 63 79 50 4d 36 45 01 64 7d 63 64 63 7d 50  ..cyPM6E.d}cdc}P
  2ba0: 4d 33 45 63 60 79 50 4d 50 54 0a 04 63 7d 60 63  M3Ec`yPMPT..c}`c
  2bb0: 60 79 50 53 41 45 0a 02 63 79 50 53 36 45 01 64  `yPSAE..cyPS6E.d
  2bc0: 7d 63 64 63 7d 50 53 33 45 63 61 79 50 53 50 54  }cdc}PS3EcayPSPT
  2bd0: 0a 04 63 7d 61 63 61 70 50 4d 52 49 47 4d 50 54  ..c}acapPMRIGMPT
  2be0: 70 60 47 4d 55 45 70 50 4d 55 54 47 4d 55 54 70  p`GMUEpPMUTGMUTp
  2bf0: 50 4d 43 52 47 4d 43 52 70 50 53 52 49 47 53 50  PMCRGMCRpPSRIGSP
  2c00: 54 70 61 47 53 55 45 70 50 53 55 54 47 53 55 54  TpaGSUEpPSUTGSUT
  2c10: 70 50 53 43 52 47 53 43 52 53 54 4d 5f 70 47 4d  pPSCRGSCRSTM_pGM
  2c20: 50 54 50 4d 52 49 70 47 4d 55 45 60 70 47 4d 55  PTPMRIpGMUE`pGMU
  2c30: 54 50 4d 55 54 70 47 4d 43 52 50 4d 43 52 70 47  TPMUTpGMCRPMCRpG
  2c40: 53 55 45 61 70 47 53 55 54 50 53 55 54 70 47 53  SUEapGSUTPSUTpGS
  2c50: 43 52 50 53 43 52 a0 0b 7b 60 01 00 70 01 50 4d  CRPSCR..{`..p.PM
  2c60: 33 45 a1 07 70 00 50 4d 33 45 a0 0c 7b 60 0a 02  3E..p.PM3E..{`..
  2c70: 00 70 01 50 4d 36 45 a1 07 70 00 50 4d 36 45 a0  .p.PM6E..p.PM6E.
  2c80: 0c 7b 60 0a 04 00 70 01 50 4d 41 45 a1 07 70 00  .{`...p.PMAE..p.
  2c90: 50 4d 41 45 a0 0b 7b 61 01 00 70 01 50 53 33 45  PMAE..{a..p.PS3E
  2ca0: a1 07 70 00 50 53 33 45 a0 0c 7b 61 0a 02 00 70  ..p.PS3E..{a...p
  2cb0: 01 50 53 36 45 a1 07 70 00 50 53 36 45 a0 0c 7b  .PS6E..p.PS6E..{
  2cc0: 61 0a 04 00 70 01 50 53 41 45 a1 07 70 00 50 53  a...p.PSAE..p.PS
  2cd0: 41 45 70 47 54 46 5f 00 69 41 54 41 30 70 47 54  AEpGTF_.iATA0pGT
  2ce0: 46 5f 01 6a 41 54 41 31 5b 82 1b 44 52 56 30 08  F_.jATA1[..DRV0.
  2cf0: 5f 41 44 52 00 14 0f 5f 47 54 46 00 a4 52 41 54  _ADR..._GTF..RAT
  2d00: 41 41 54 41 30 5b 82 1b 44 52 56 31 08 5f 41 44  AATA0[..DRV1._AD
  2d10: 52 01 14 0f 5f 47 54 46 00 a4 52 41 54 41 41 54  R..._GTF..RATAAT
  2d20: 41 31 5b 82 4f 22 43 48 4e 31 08 5f 41 44 52 01  A1[.O"CHN1._ADR.
  2d30: 14 49 07 5f 47 54 4d 00 79 53 53 43 52 01 61 7d  .I._GTM.ySSCR.a}
  2d40: 53 4d 43 52 61 60 79 53 4d 41 45 0a 02 63 79 53  SMCRa`ySMAE..cyS
  2d50: 4d 36 45 01 64 7d 63 64 63 7d 53 4d 33 45 63 61  M6E.d}cdc}SM3Eca
  2d60: 79 53 4d 50 54 0a 04 63 7d 61 63 61 79 53 53 41  ySMPT..c}acaySSA
  2d70: 45 0a 02 63 79 53 53 36 45 01 64 7d 63 64 63 7d  E..cySS6E.d}cdc}
  2d80: 53 53 33 45 63 62 79 53 53 50 54 0a 04 63 7d 62  SS3EcbySSPT..c}b
  2d90: 63 62 a4 47 54 4d 5f 53 4d 52 49 61 53 4d 55 54  cb.GTM_SMRIaSMUT
  2da0: 53 53 52 49 62 53 53 55 54 60 14 4e 16 5f 53 54  SSRIbSSUT`.N._ST
  2db0: 4d 03 70 68 5b 31 70 68 54 4d 44 30 79 53 4d 41  M.ph[1phTMD0ySMA
  2dc0: 45 0a 02 63 79 53 4d 36 45 01 64 7d 63 64 63 7d  E..cySM6E.d}cdc}
  2dd0: 53 4d 33 45 63 60 79 53 4d 50 54 0a 04 63 7d 60  SM3Ec`ySMPT..c}`
  2de0: 63 60 79 53 53 41 45 0a 02 63 79 53 53 36 45 01  c`ySSAE..cySS6E.
  2df0: 64 7d 63 64 63 7d 53 53 33 45 63 61 79 53 53 50  d}cdc}SS3EcaySSP
  2e00: 54 0a 04 63 7d 61 63 61 70 53 4d 52 49 47 4d 50  T..c}acapSMRIGMP
  2e10: 54 70 60 47 4d 55 45 70 53 4d 55 54 47 4d 55 54  Tp`GMUEpSMUTGMUT
  2e20: 70 53 4d 43 52 47 4d 43 52 70 53 53 52 49 47 53  pSMCRGMCRpSSRIGS
  2e30: 50 54 70 61 47 53 55 45 70 53 53 55 54 47 53 55  PTpaGSUEpSSUTGSU
  2e40: 54 70 53 53 43 52 47 53 43 52 53 54 4d 5f 70 47  TpSSCRGSCRSTM_pG
  2e50: 4d 50 54 53 4d 52 49 70 47 4d 55 45 60 70 47 4d  MPTSMRIpGMUE`pGM
  2e60: 55 54 53 4d 55 54 70 47 4d 43 52 53 4d 43 52 70  UTSMUTpGMCRSMCRp
  2e70: 47 53 55 45 61 70 47 53 55 54 53 53 55 54 70 47  GSUEapGSUTSSUTpG
  2e80: 53 43 52 53 53 43 52 a0 0b 7b 60 01 00 70 01 53  SCRSSCR..{`..p.S
  2e90: 4d 33 45 a1 07 70 00 53 4d 33 45 a0 0c 7b 60 0a  M3E..p.SM3E..{`.
  2ea0: 02 00 70 01 53 4d 36 45 a1 07 70 00 53 4d 36 45  ..p.SM6E..p.SM6E
  2eb0: a0 0c 7b 60 0a 04 00 70 01 53 4d 41 45 a1 07 70  ..{`...p.SMAE..p
  2ec0: 00 53 4d 41 45 a0 0b 7b 61 01 00 70 01 53 53 33  .SMAE..{a..p.SS3
  2ed0: 45 a1 07 70 00 53 53 33 45 a0 0c 7b 61 0a 02 00  E..p.SS3E..{a...
  2ee0: 70 01 53 53 36 45 a1 07 70 00 53 53 36 45 a0 0c  p.SS6E..p.SS6E..
  2ef0: 7b 61 0a 04 00 70 01 53 53 41 45 a1 07 70 00 53  {a...p.SSAE..p.S
  2f00: 53 41 45 70 47 54 46 5f 00 69 41 54 41 32 70 47  SAEpGTF_.iATA2pG
  2f10: 54 46 5f 01 6a 41 54 41 33 5b 82 1b 44 52 56 30  TF_.jATA3[..DRV0
  2f20: 08 5f 41 44 52 00 14 0f 5f 47 54 46 00 a4 52 41  ._ADR..._GTF..RA
  2f30: 54 41 41 54 41 32 5b 82 1b 44 52 56 31 08 5f 41  TAATA2[..DRV1._A
  2f40: 44 52 01 14 0f 5f 47 54 46 00 a4 52 41 54 41 41  DR..._GTF..RATAA
  2f50: 54 41 33 14 45 13 47 54 4d 5f 0f 70 ff 50 49 4f  TA3.E.GTM_.p.PIO
  2f60: 30 70 ff 50 49 4f 31 70 ff 44 4d 41 30 70 ff 44  0p.PIO1p.DMA0p.D
  2f70: 4d 41 31 70 0a 10 43 48 4e 46 a0 05 52 45 47 46  MA1p..CHNF..REGF
  2f80: a1 06 a4 54 4d 44 30 a0 11 7b 69 0a 20 00 7d 43  ...TMD0..{i. .}C
  2f90: 48 4e 46 0a 02 43 48 4e 46 70 89 83 88 54 49 4d  HNF..CHNFp...TIM
  2fa0: 30 01 00 01 68 00 00 00 66 70 83 88 83 88 54 49  0...h...fp....TI
  2fb0: 4d 30 00 00 66 00 67 70 67 44 4d 41 30 70 67 50  M0..f.gpgDMA0pgP
  2fc0: 49 4f 30 a0 11 7b 6c 0a 20 00 7d 43 48 4e 46 0a  IO0..{l. .}CHNF.
  2fd0: 08 43 48 4e 46 70 89 83 88 54 49 4d 30 0a 02 00  .CHNFp...TIM0...
  2fe0: 01 6b 00 00 00 66 70 83 88 83 88 54 49 4d 30 00  .k...fp....TIM0.
  2ff0: 00 66 00 67 70 67 44 4d 41 31 70 67 50 49 4f 31  .f.gpgDMA1pgPIO1
  3000: a0 3d 7b 69 0a 07 00 70 6a 65 a0 0b 7b 69 0a 02  .={i...pje..{i..
  3010: 00 72 65 0a 02 65 a0 0b 7b 69 0a 04 00 72 65 0a  .re..e..{i...re.
  3020: 04 65 70 83 88 83 88 54 49 4d 30 0a 03 00 65 00  .ep....TIM0...e.
  3030: 44 4d 41 30 7d 43 48 4e 46 01 43 48 4e 46 a0 3e  DMA0}CHNF.CHNF.>
  3040: 7b 6c 0a 07 00 70 6d 65 a0 0b 7b 6c 0a 02 00 72  {l...pme..{l...r
  3050: 65 0a 02 65 a0 0b 7b 6c 0a 04 00 72 65 0a 04 65  e..e..{l...re..e
  3060: 70 83 88 83 88 54 49 4d 30 0a 03 00 65 00 44 4d  p....TIM0...e.DM
  3070: 41 31 7d 43 48 4e 46 0a 04 43 48 4e 46 70 54 4d  A1}CHNF..CHNFpTM
  3080: 44 30 5b 31 a4 54 4d 44 30 14 44 21 53 54 4d 5f  D0[1.TMD0.D!STM_
  3090: 08 a0 4c 20 52 45 47 46 70 00 47 4d 55 45 70 00  ..L REGFp.GMUEp.
  30a0: 47 4d 55 54 70 00 47 53 55 45 70 00 47 53 55 54  GMUTp.GSUEp.GSUT
  30b0: a0 40 07 7b 43 48 4e 46 01 00 70 89 83 88 54 49  .@.{CHNF..p...TI
  30c0: 4d 30 0a 03 00 02 44 4d 41 30 00 00 00 60 a0 09  M0....DMA0...`..
  30d0: 94 60 0a 05 70 0a 05 60 70 83 88 83 88 54 49 4d  .`..p..`p....TIM
  30e0: 30 0a 04 00 60 00 47 4d 55 54 7d 47 4d 55 45 01  0...`.GMUT}GMUE.
  30f0: 47 4d 55 45 a0 10 94 60 0a 02 7d 47 4d 55 45 0a  GMUE...`..}GMUE.
  3100: 02 47 4d 55 45 a0 1b 94 60 0a 04 7b 47 4d 55 45  .GMUE...`..{GMUE
  3110: 0a fd 47 4d 55 45 7d 47 4d 55 45 0a 04 47 4d 55  ..GMUE}GMUE..GMU
  3120: 45 a1 35 a0 33 7d 93 50 49 4f 30 ff 93 50 49 4f  E.5.3}.PIO0..PIO
  3130: 30 00 00 a0 23 7b 95 44 4d 41 30 ff 94 44 4d 41  0...#{.DMA0..DMA
  3140: 30 00 00 70 44 4d 41 30 50 49 4f 30 7d 47 4d 55  0..pDMA0PIO0}GMU
  3150: 45 0a 80 47 4d 55 45 a0 41 07 7b 43 48 4e 46 0a  E..GMUE.A.{CHNF.
  3160: 04 00 70 89 83 88 54 49 4d 30 0a 03 00 02 44 4d  ..p...TIM0....DM
  3170: 41 31 00 00 00 60 a0 09 94 60 0a 05 70 0a 05 60  A1...`...`..p..`
  3180: 70 83 88 83 88 54 49 4d 30 0a 04 00 60 00 47 53  p....TIM0...`.GS
  3190: 55 54 7d 47 53 55 45 01 47 53 55 45 a0 10 94 60  UT}GSUE.GSUE...`
  31a0: 0a 02 7d 47 53 55 45 0a 02 47 53 55 45 a0 1b 94  ..}GSUE..GSUE...
  31b0: 60 0a 04 7b 47 53 55 45 0a fd 47 53 55 45 7d 47  `..{GSUE..GSUE}G
  31c0: 53 55 45 0a 04 47 53 55 45 a1 35 a0 33 7d 93 50  SUE..GSUE.5.3}.P
  31d0: 49 4f 31 ff 93 50 49 4f 31 00 00 a0 23 7b 95 44  IO1..PIO1...#{.D
  31e0: 4d 41 31 ff 94 44 4d 41 31 00 00 70 44 4d 41 31  MA1..DMA1..pDMA1
  31f0: 50 49 4f 31 7d 47 53 55 45 0a 80 47 53 55 45 a0  PIO1}GSUE..GSUE.
  3200: 14 7b 43 48 4e 46 0a 02 00 7d 47 4d 55 45 0a 20  .{CHNF...}GMUE. 
  3210: 47 4d 55 45 a0 14 7b 43 48 4e 46 0a 08 00 7d 47  GMUE..{CHNF...}G
  3220: 53 55 45 0a 20 47 53 55 45 7b 89 83 88 54 49 4d  SUE. GSUE{...TIM
  3230: 30 00 00 04 50 49 4f 30 00 00 00 0a 07 60 70 83  0...PIO0.....`p.
  3240: 88 83 88 54 49 4d 30 01 00 60 00 61 70 61 47 4d  ...TIM0..`.apaGM
  3250: 50 54 a0 10 95 60 0a 03 7d 47 4d 55 45 0a 50 47  PT...`..}GMUE.PG
  3260: 4d 55 45 7b 89 83 88 54 49 4d 30 00 00 04 50 49  MUE{...TIM0...PI
  3270: 4f 31 00 00 00 0a 07 60 70 83 88 83 88 54 49 4d  O1.....`p....TIM
  3280: 30 0a 02 00 60 00 61 70 61 47 53 50 54 a0 10 95  0...`.apaGSPT...
  3290: 60 0a 03 7d 47 53 55 45 0a 50 47 53 55 45 08 41  `..}GSUE.PGSUE.A
  32a0: 54 30 31 11 0a 0a 07 03 00 00 00 00 00 ef 08 41  T01............A
  32b0: 54 30 32 11 0a 0a 07 00 00 00 00 00 00 90 08 41  T02............A
  32c0: 54 30 33 11 0a 0a 07 00 00 00 00 00 00 c6 08 41  T03............A
  32d0: 54 30 34 11 0a 0a 07 00 00 00 00 00 00 91 08 41  T04............A
  32e0: 54 41 30 11 03 0a 1d 08 41 54 41 31 11 03 0a 1d  TA0.....ATA1....
  32f0: 08 41 54 41 32 11 03 0a 1d 08 41 54 41 33 11 03  .ATA2.....ATA3..
  3300: 0a 1d 08 41 54 41 42 11 03 0a 1d 8c 41 54 41 42  ...ATAB.....ATAB
  3310: 00 43 4d 44 43 14 4c 05 47 54 46 42 0b 77 43 4d  .CMDC.L.GTFB.wCM
  3320: 44 43 0a 38 60 72 60 0a 08 61 5b 13 41 54 41 42  DC.8`r`..a[.ATAB
  3330: 61 0a 38 43 4d 44 58 77 43 4d 44 43 0a 07 60 8c  a.8CMDXwCMDC..`.
  3340: 41 54 41 42 72 60 0a 02 00 41 30 30 31 8c 41 54  ATABr`...A001.AT
  3350: 41 42 72 60 0a 06 00 41 30 30 35 70 68 43 4d 44  ABr`...A005phCMD
  3360: 58 70 69 41 30 30 31 70 6a 41 30 30 35 75 43 4d  XpiA001pjA005uCM
  3370: 44 43 14 42 23 47 54 46 5f 0a 70 69 5b 31 70 00  DC.B#GTF_.pi[1p.
  3380: 43 4d 44 43 08 49 44 34 39 0b 00 0c 08 49 44 35  CMDC.ID49....ID5
  3390: 39 00 08 49 44 35 33 0a 04 08 49 44 36 33 0b 00  9..ID53...ID63..
  33a0: 0f 08 49 44 38 38 0b 00 0f 08 49 52 44 59 01 08  ..ID88....IRDY..
  33b0: 50 49 4f 54 00 08 44 4d 41 54 00 a0 4d 05 93 87  PIOT..DMAT..M...
  33c0: 69 0b 00 02 8b 69 0a 62 49 57 34 39 70 49 57 34  i....i.bIW49pIW4
  33d0: 39 49 44 34 39 8b 69 0a 6a 49 57 35 33 70 49 57  9ID49.i.jIW53pIW
  33e0: 35 33 49 44 35 33 8b 69 0a 7e 49 57 36 33 70 49  53ID53.i.~IW63pI
  33f0: 57 36 33 49 44 36 33 8b 69 0a 76 49 57 35 39 70  W63ID63.i.vIW59p
  3400: 49 57 35 39 49 44 35 39 8b 69 0a b0 49 57 38 38  IW59ID59.i..IW88
  3410: 70 49 57 38 38 49 44 38 38 70 0a a0 67 a0 48 05  pIW88ID88p..g.H.
  3420: 68 70 0a b0 67 7b 43 48 4e 46 0a 08 49 52 44 59  hp..g{CHNF..IRDY
  3430: a0 12 7b 43 48 4e 46 0a 10 00 70 50 49 4f 31 50  ..{CHNF...pPIO1P
  3440: 49 4f 54 a1 0a 70 50 49 4f 30 50 49 4f 54 a0 27  IOT..pPIO0PIOT.'
  3450: 7b 43 48 4e 46 0a 04 00 a0 12 7b 43 48 4e 46 0a  {CHNF.....{CHNF.
  3460: 10 00 70 44 4d 41 31 44 4d 41 54 a1 0a 70 44 4d  ..pDMA1DMAT..pDM
  3470: 41 30 44 4d 41 54 a1 27 7b 43 48 4e 46 0a 02 49  A0DMAT.'{CHNF..I
  3480: 52 44 59 70 50 49 4f 30 50 49 4f 54 a0 11 7b 43  RDYpPIO0PIOT..{C
  3490: 48 4e 46 01 00 70 44 4d 41 30 44 4d 41 54 a0 45  HNF..pDMA0DMAT.E
  34a0: 04 90 90 7b 49 44 35 33 0a 04 00 7b 49 44 38 38  ...{ID53...{ID88
  34b0: 0b 00 ff 00 44 4d 41 54 70 89 83 88 54 49 4d 30  ....DMATp...TIM0
  34c0: 0a 03 00 02 44 4d 41 54 00 00 00 61 a0 09 94 61  ....DMAT...a...a
  34d0: 0a 05 70 0a 05 61 47 54 46 42 41 54 30 31 7d 0a  ..p..aGTFBAT01}.
  34e0: 40 61 00 67 a1 42 04 a0 3f 90 7b 49 44 36 33 0b  @a.g.B..?.{ID63.
  34f0: 00 ff 00 50 49 4f 54 7b 89 83 88 54 49 4d 30 00  ...PIOT{...TIM0.
  3500: 00 04 50 49 4f 54 00 00 00 0a 03 60 7d 0a 20 83  ..PIOT.....`}. .
  3510: 88 83 88 54 49 4d 30 0a 07 00 60 00 61 47 54 46  ...TIM0...`.aGTF
  3520: 42 41 54 30 31 61 67 a0 35 49 52 44 59 7b 89 83  BAT01ag.5IRDY{..
  3530: 88 54 49 4d 30 00 00 04 50 49 4f 54 00 00 00 0a  .TIM0...PIOT....
  3540: 07 60 7d 0a 08 83 88 83 88 54 49 4d 30 0a 06 00  .`}......TIM0...
  3550: 60 00 61 47 54 46 42 41 54 30 31 61 67 a1 16 a0  `.aGTFBAT01ag...
  3560: 14 7b 49 44 34 39 0b 00 04 00 47 54 46 42 41 54  .{ID49....GTFBAT
  3570: 30 31 01 67 a0 24 90 7b 49 44 35 39 0b 00 01 00  01.g.$.{ID59....
  3580: 7b 49 44 35 39 0a ff 00 47 54 46 42 41 54 30 33  {ID59...GTFBAT03
  3590: 7b 49 44 35 39 0a ff 00 67 70 41 54 41 42 5b 31  {ID59...gpATAB[1
  35a0: a4 41 54 41 42 14 31 52 41 54 41 01 8c 68 00 43  .ATAB.1RATA..h.C
  35b0: 4d 44 4e 77 43 4d 44 4e 0a 38 60 5b 13 68 0a 08  MDNwCMDN.8`[.h..
  35c0: 60 52 45 54 42 70 52 45 54 42 5b 31 a4 73 52 45  `RETBpRETB[1.sRE
  35d0: 54 42 46 5a 54 46 00 5b 82 41 c9 53 41 54 31 08  TBFZTF.[.A.SAT1.
  35e0: 5f 41 44 52 0c 05 00 1f 00 08 52 45 47 46 01 14  _ADR......REGF..
  35f0: 12 5f 52 45 47 02 a0 0b 93 68 0a 02 70 69 52 45  ._REG....h..piRE
  3600: 47 46 08 54 49 4d 30 12 48 05 08 12 0b 04 0a 78  GF.TIM0.H......x
  3610: 0a b4 0a f0 0b 84 03 12 09 04 0a 23 0a 21 0a 10  ...........#.!..
  3620: 00 12 09 04 0a 0b 0a 09 0a 04 00 12 0e 06 0a 78  ...............x
  3630: 0a 5a 0a 3c 0a 28 0a 1e 0a 14 12 0a 06 00 01 0a  .Z.<.(..........
  3640: 02 01 0a 02 01 12 08 06 00 00 00 01 01 01 12 09  ................
  3650: 04 0a 04 0a 03 0a 02 00 12 07 04 0a 02 01 00 00  ................
  3660: 08 54 4d 44 30 11 03 0a 14 8a 54 4d 44 30 00 50  .TMD0.....TMD0.P
  3670: 49 4f 30 8a 54 4d 44 30 0a 04 44 4d 41 30 8a 54  IO0.TMD0..DMA0.T
  3680: 4d 44 30 0a 08 50 49 4f 31 8a 54 4d 44 30 0a 0c  MD0..PIO1.TMD0..
  3690: 44 4d 41 31 8a 54 4d 44 30 0a 10 43 48 4e 46 5b  DMA1.TMD0..CHNF[
  36a0: 80 43 46 47 32 02 0a 40 0a 20 5b 81 48 0a 43 46  .CFG2..@. [.H.CF
  36b0: 47 32 03 50 4d 50 54 04 50 53 50 54 04 50 4d 52  G2.PMPT.PSPT.PMR
  36c0: 49 06 00 02 53 4d 50 54 04 53 53 50 54 04 53 4d  I...SMPT.SSPT.SM
  36d0: 52 49 06 00 02 50 53 52 49 04 53 53 52 49 04 00  RI...PSRI.SSRI..
  36e0: 18 50 4d 33 45 01 50 53 33 45 01 53 4d 33 45 01  .PM3E.PS3E.SM3E.
  36f0: 53 53 33 45 01 00 0c 50 4d 55 54 02 00 02 50 53  SS3E...PMUT...PS
  3700: 55 54 02 00 02 53 4d 55 54 02 00 02 53 53 55 54  UT...SMUT...SSUT
  3710: 02 00 02 00 40 04 50 4d 36 45 01 50 53 36 45 01  ....@.PM6E.PS6E.
  3720: 53 4d 36 45 01 53 53 36 45 01 50 4d 43 52 01 50  SM6E.SS6E.PMCR.P
  3730: 53 43 52 01 53 4d 43 52 01 53 53 43 52 01 00 04  SCR.SMCR.SSCR...
  3740: 50 4d 41 45 01 50 53 41 45 01 53 4d 41 45 01 53  PMAE.PSAE.SMAE.S
  3750: 53 41 45 01 08 47 4d 50 54 00 08 47 4d 55 45 00  SAE..GMPT..GMUE.
  3760: 08 47 4d 55 54 00 08 47 4d 43 52 00 08 47 53 50  .GMUT..GMCR..GSP
  3770: 54 00 08 47 53 55 45 00 08 47 53 55 54 00 08 47  T..GSUE..GSUT..G
  3780: 53 43 52 00 5b 82 4f 22 43 48 4e 30 08 5f 41 44  SCR.[.O"CHN0._AD
  3790: 52 00 14 49 07 5f 47 54 4d 00 79 50 53 43 52 01  R..I._GTM.yPSCR.
  37a0: 61 7d 50 4d 43 52 61 60 79 50 4d 41 45 0a 02 63  a}PMCRa`yPMAE..c
  37b0: 79 50 4d 36 45 01 64 7d 63 64 63 7d 50 4d 33 45  yPM6E.d}cdc}PM3E
  37c0: 63 61 79 50 4d 50 54 0a 04 63 7d 61 63 61 79 50  cayPMPT..c}acayP
  37d0: 53 41 45 0a 02 63 79 50 53 36 45 01 64 7d 63 64  SAE..cyPS6E.d}cd
  37e0: 63 7d 50 53 33 45 63 62 79 50 53 50 54 0a 04 63  c}PS3EcbyPSPT..c
  37f0: 7d 62 63 62 a4 47 54 4d 5f 50 4d 52 49 61 50 4d  }bcb.GTM_PMRIaPM
  3800: 55 54 50 53 52 49 62 50 53 55 54 60 14 4e 16 5f  UTPSRIbPSUT`.N._
  3810: 53 54 4d 03 70 68 5b 31 70 68 54 4d 44 30 79 50  STM.ph[1phTMD0yP
  3820: 4d 41 45 0a 02 63 79 50 4d 36 45 01 64 7d 63 64  MAE..cyPM6E.d}cd
  3830: 63 7d 50 4d 33 45 63 60 79 50 4d 50 54 0a 04 63  c}PM3Ec`yPMPT..c
  3840: 7d 60 63 60 79 50 53 41 45 0a 02 63 79 50 53 36  }`c`yPSAE..cyPS6
  3850: 45 01 64 7d 63 64 63 7d 50 53 33 45 63 61 79 50  E.d}cdc}PS3EcayP
  3860: 53 50 54 0a 04 63 7d 61 63 61 70 50 4d 52 49 47  SPT..c}acapPMRIG
  3870: 4d 50 54 70 60 47 4d 55 45 70 50 4d 55 54 47 4d  MPTp`GMUEpPMUTGM
  3880: 55 54 70 50 4d 43 52 47 4d 43 52 70 50 53 52 49  UTpPMCRGMCRpPSRI
  3890: 47 53 50 54 70 61 47 53 55 45 70 50 53 55 54 47  GSPTpaGSUEpPSUTG
  38a0: 53 55 54 70 50 53 43 52 47 53 43 52 53 54 4d 5f  SUTpPSCRGSCRSTM_
  38b0: 70 47 4d 50 54 50 4d 52 49 70 47 4d 55 45 60 70  pGMPTPMRIpGMUE`p
  38c0: 47 4d 55 54 50 4d 55 54 70 47 4d 43 52 50 4d 43  GMUTPMUTpGMCRPMC
  38d0: 52 70 47 53 55 45 61 70 47 53 55 54 50 53 55 54  RpGSUEapGSUTPSUT
  38e0: 70 47 53 43 52 50 53 43 52 a0 0b 7b 60 01 00 70  pGSCRPSCR..{`..p
  38f0: 01 50 4d 33 45 a1 07 70 00 50 4d 33 45 a0 0c 7b  .PM3E..p.PM3E..{
  3900: 60 0a 02 00 70 01 50 4d 36 45 a1 07 70 00 50 4d  `...p.PM6E..p.PM
  3910: 36 45 a0 0c 7b 60 0a 04 00 70 01 50 4d 41 45 a1  6E..{`...p.PMAE.
  3920: 07 70 00 50 4d 41 45 a0 0b 7b 61 01 00 70 01 50  .p.PMAE..{a..p.P
  3930: 53 33 45 a1 07 70 00 50 53 33 45 a0 0c 7b 61 0a  S3E..p.PS3E..{a.
  3940: 02 00 70 01 50 53 36 45 a1 07 70 00 50 53 36 45  ..p.PS6E..p.PS6E
  3950: a0 0c 7b 61 0a 04 00 70 01 50 53 41 45 a1 07 70  ..{a...p.PSAE..p
  3960: 00 50 53 41 45 70 47 54 46 5f 00 69 41 54 41 30  .PSAEpGTF_.iATA0
  3970: 70 47 54 46 5f 01 6a 41 54 41 31 5b 82 1b 44 52  pGTF_.jATA1[..DR
  3980: 56 30 08 5f 41 44 52 00 14 0f 5f 47 54 46 00 a4  V0._ADR..._GTF..
  3990: 52 41 54 41 41 54 41 30 5b 82 1b 44 52 56 31 08  RATAATA0[..DRV1.
  39a0: 5f 41 44 52 01 14 0f 5f 47 54 46 00 a4 52 41 54  _ADR..._GTF..RAT
  39b0: 41 41 54 41 31 5b 82 4f 22 43 48 4e 31 08 5f 41  AATA1[.O"CHN1._A
  39c0: 44 52 01 14 49 07 5f 47 54 4d 00 79 53 53 43 52  DR..I._GTM.ySSCR
  39d0: 01 61 7d 53 4d 43 52 61 60 79 53 4d 41 45 0a 02  .a}SMCRa`ySMAE..
  39e0: 63 79 53 4d 36 45 01 64 7d 63 64 63 7d 53 4d 33  cySM6E.d}cdc}SM3
  39f0: 45 63 61 79 53 4d 50 54 0a 04 63 7d 61 63 61 79  EcaySMPT..c}acay
  3a00: 53 53 41 45 0a 02 63 79 53 53 36 45 01 64 7d 63  SSAE..cySS6E.d}c
  3a10: 64 63 7d 53 53 33 45 63 62 79 53 53 50 54 0a 04  dc}SS3EcbySSPT..
  3a20: 63 7d 62 63 62 a4 47 54 4d 5f 53 4d 52 49 61 53  c}bcb.GTM_SMRIaS
  3a30: 4d 55 54 53 53 52 49 62 53 53 55 54 60 14 4e 16  MUTSSRIbSSUT`.N.
  3a40: 5f 53 54 4d 03 70 68 5b 31 70 68 54 4d 44 30 79  _STM.ph[1phTMD0y
  3a50: 53 4d 41 45 0a 02 63 79 53 4d 36 45 01 64 7d 63  SMAE..cySM6E.d}c
  3a60: 64 63 7d 53 4d 33 45 63 60 79 53 4d 50 54 0a 04  dc}SM3Ec`ySMPT..
  3a70: 63 7d 60 63 60 79 53 53 41 45 0a 02 63 79 53 53  c}`c`ySSAE..cySS
  3a80: 36 45 01 64 7d 63 64 63 7d 53 53 33 45 63 61 79  6E.d}cdc}SS3Ecay
  3a90: 53 53 50 54 0a 04 63 7d 61 63 61 70 53 4d 52 49  SSPT..c}acapSMRI
  3aa0: 47 4d 50 54 70 60 47 4d 55 45 70 53 4d 55 54 47  GMPTp`GMUEpSMUTG
  3ab0: 4d 55 54 70 53 4d 43 52 47 4d 43 52 70 53 53 52  MUTpSMCRGMCRpSSR
  3ac0: 49 47 53 50 54 70 61 47 53 55 45 70 53 53 55 54  IGSPTpaGSUEpSSUT
  3ad0: 47 53 55 54 70 53 53 43 52 47 53 43 52 53 54 4d  GSUTpSSCRGSCRSTM
  3ae0: 5f 70 47 4d 50 54 53 4d 52 49 70 47 4d 55 45 60  _pGMPTSMRIpGMUE`
  3af0: 70 47 4d 55 54 53 4d 55 54 70 47 4d 43 52 53 4d  pGMUTSMUTpGMCRSM
  3b00: 43 52 70 47 53 55 45 61 70 47 53 55 54 53 53 55  CRpGSUEapGSUTSSU
  3b10: 54 70 47 53 43 52 53 53 43 52 a0 0b 7b 60 01 00  TpGSCRSSCR..{`..
  3b20: 70 01 53 4d 33 45 a1 07 70 00 53 4d 33 45 a0 0c  p.SM3E..p.SM3E..
  3b30: 7b 60 0a 02 00 70 01 53 4d 36 45 a1 07 70 00 53  {`...p.SM6E..p.S
  3b40: 4d 36 45 a0 0c 7b 60 0a 04 00 70 01 53 4d 41 45  M6E..{`...p.SMAE
  3b50: a1 07 70 00 53 4d 41 45 a0 0b 7b 61 01 00 70 01  ..p.SMAE..{a..p.
  3b60: 53 53 33 45 a1 07 70 00 53 53 33 45 a0 0c 7b 61  SS3E..p.SS3E..{a
  3b70: 0a 02 00 70 01 53 53 36 45 a1 07 70 00 53 53 36  ...p.SS6E..p.SS6
  3b80: 45 a0 0c 7b 61 0a 04 00 70 01 53 53 41 45 a1 07  E..{a...p.SSAE..
  3b90: 70 00 53 53 41 45 70 47 54 46 5f 00 69 41 54 41  p.SSAEpGTF_.iATA
  3ba0: 32 70 47 54 46 5f 01 6a 41 54 41 33 5b 82 1b 44  2pGTF_.jATA3[..D
  3bb0: 52 56 30 08 5f 41 44 52 00 14 0f 5f 47 54 46 00  RV0._ADR..._GTF.
  3bc0: a4 52 41 54 41 41 54 41 32 5b 82 1b 44 52 56 31  .RATAATA2[..DRV1
  3bd0: 08 5f 41 44 52 01 14 0f 5f 47 54 46 00 a4 52 41  ._ADR..._GTF..RA
  3be0: 54 41 41 54 41 33 14 45 13 47 54 4d 5f 0f 70 ff  TAATA3.E.GTM_.p.
  3bf0: 50 49 4f 30 70 ff 50 49 4f 31 70 ff 44 4d 41 30  PIO0p.PIO1p.DMA0
  3c00: 70 ff 44 4d 41 31 70 0a 10 43 48 4e 46 a0 05 52  p.DMA1p..CHNF..R
  3c10: 45 47 46 a1 06 a4 54 4d 44 30 a0 11 7b 69 0a 20  EGF...TMD0..{i. 
  3c20: 00 7d 43 48 4e 46 0a 02 43 48 4e 46 70 89 83 88  .}CHNF..CHNFp...
  3c30: 54 49 4d 30 01 00 01 68 00 00 00 66 70 83 88 83  TIM0...h...fp...
  3c40: 88 54 49 4d 30 00 00 66 00 67 70 67 44 4d 41 30  .TIM0..f.gpgDMA0
  3c50: 70 67 50 49 4f 30 a0 11 7b 6c 0a 20 00 7d 43 48  pgPIO0..{l. .}CH
  3c60: 4e 46 0a 08 43 48 4e 46 70 89 83 88 54 49 4d 30  NF..CHNFp...TIM0
  3c70: 0a 02 00 01 6b 00 00 00 66 70 83 88 83 88 54 49  ....k...fp....TI
  3c80: 4d 30 00 00 66 00 67 70 67 44 4d 41 31 70 67 50  M0..f.gpgDMA1pgP
  3c90: 49 4f 31 a0 3d 7b 69 0a 07 00 70 6a 65 a0 0b 7b  IO1.={i...pje..{
  3ca0: 69 0a 02 00 72 65 0a 02 65 a0 0b 7b 69 0a 04 00  i...re..e..{i...
  3cb0: 72 65 0a 04 65 70 83 88 83 88 54 49 4d 30 0a 03  re..ep....TIM0..
  3cc0: 00 65 00 44 4d 41 30 7d 43 48 4e 46 01 43 48 4e  .e.DMA0}CHNF.CHN
  3cd0: 46 a0 3e 7b 6c 0a 07 00 70 6d 65 a0 0b 7b 6c 0a  F.>{l...pme..{l.
  3ce0: 02 00 72 65 0a 02 65 a0 0b 7b 6c 0a 04 00 72 65  ..re..e..{l...re
  3cf0: 0a 04 65 70 83 88 83 88 54 49 4d 30 0a 03 00 65  ..ep....TIM0...e
  3d00: 00 44 4d 41 31 7d 43 48 4e 46 0a 04 43 48 4e 46  .DMA1}CHNF..CHNF
  3d10: 70 54 4d 44 30 5b 31 a4 54 4d 44 30 14 44 21 53  pTMD0[1.TMD0.D!S
  3d20: 54 4d 5f 08 a0 4c 20 52 45 47 46 70 00 47 4d 55  TM_..L REGFp.GMU
  3d30: 45 70 00 47 4d 55 54 70 00 47 53 55 45 70 00 47  Ep.GMUTp.GSUEp.G
  3d40: 53 55 54 a0 40 07 7b 43 48 4e 46 01 00 70 89 83  SUT.@.{CHNF..p..
  3d50: 88 54 49 4d 30 0a 03 00 02 44 4d 41 30 00 00 00  .TIM0....DMA0...
  3d60: 60 a0 09 94 60 0a 05 70 0a 05 60 70 83 88 83 88  `...`..p..`p....
  3d70: 54 49 4d 30 0a 04 00 60 00 47 4d 55 54 7d 47 4d  TIM0...`.GMUT}GM
  3d80: 55 45 01 47 4d 55 45 a0 10 94 60 0a 02 7d 47 4d  UE.GMUE...`..}GM
  3d90: 55 45 0a 02 47 4d 55 45 a0 1b 94 60 0a 04 7b 47  UE..GMUE...`..{G
  3da0: 4d 55 45 0a fd 47 4d 55 45 7d 47 4d 55 45 0a 04  MUE..GMUE}GMUE..
  3db0: 47 4d 55 45 a1 35 a0 33 7d 93 50 49 4f 30 ff 93  GMUE.5.3}.PIO0..
  3dc0: 50 49 4f 30 00 00 a0 23 7b 95 44 4d 41 30 ff 94  PIO0...#{.DMA0..
  3dd0: 44 4d 41 30 00 00 70 44 4d 41 30 50 49 4f 30 7d  DMA0..pDMA0PIO0}
  3de0: 47 4d 55 45 0a 80 47 4d 55 45 a0 41 07 7b 43 48  GMUE..GMUE.A.{CH
  3df0: 4e 46 0a 04 00 70 89 83 88 54 49 4d 30 0a 03 00  NF...p...TIM0...
  3e00: 02 44 4d 41 31 00 00 00 60 a0 09 94 60 0a 05 70  .DMA1...`...`..p
  3e10: 0a 05 60 70 83 88 83 88 54 49 4d 30 0a 04 00 60  ..`p....TIM0...`
  3e20: 00 47 53 55 54 7d 47 53 55 45 01 47 53 55 45 a0  .GSUT}GSUE.GSUE.
  3e30: 10 94 60 0a 02 7d 47 53 55 45 0a 02 47 53 55 45  ..`..}GSUE..GSUE
  3e40: a0 1b 94 60 0a 04 7b 47 53 55 45 0a fd 47 53 55  ...`..{GSUE..GSU
  3e50: 45 7d 47 53 55 45 0a 04 47 53 55 45 a1 35 a0 33  E}GSUE..GSUE.5.3
  3e60: 7d 93 50 49 4f 31 ff 93 50 49 4f 31 00 00 a0 23  }.PIO1..PIO1...#
  3e70: 7b 95 44 4d 41 31 ff 94 44 4d 41 31 00 00 70 44  {.DMA1..DMA1..pD
  3e80: 4d 41 31 50 49 4f 31 7d 47 53 55 45 0a 80 47 53  MA1PIO1}GSUE..GS
  3e90: 55 45 a0 14 7b 43 48 4e 46 0a 02 00 7d 47 4d 55  UE..{CHNF...}GMU
  3ea0: 45 0a 20 47 4d 55 45 a0 14 7b 43 48 4e 46 0a 08  E. GMUE..{CHNF..
  3eb0: 00 7d 47 53 55 45 0a 20 47 53 55 45 7b 89 83 88  .}GSUE. GSUE{...
  3ec0: 54 49 4d 30 00 00 04 50 49 4f 30 00 00 00 0a 07  TIM0...PIO0.....
  3ed0: 60 70 83 88 83 88 54 49 4d 30 01 00 60 00 61 70  `p....TIM0..`.ap
  3ee0: 61 47 4d 50 54 a0 10 95 60 0a 03 7d 47 4d 55 45  aGMPT...`..}GMUE
  3ef0: 0a 50 47 4d 55 45 7b 89 83 88 54 49 4d 30 00 00  .PGMUE{...TIM0..
  3f00: 04 50 49 4f 31 00 00 00 0a 07 60 70 83 88 83 88  .PIO1.....`p....
  3f10: 54 49 4d 30 0a 02 00 60 00 61 70 61 47 53 50 54  TIM0...`.apaGSPT
  3f20: a0 10 95 60 0a 03 7d 47 53 55 45 0a 50 47 53 55  ...`..}GSUE.PGSU
  3f30: 45 08 41 54 30 31 11 0a 0a 07 03 00 00 00 00 00  E.AT01..........
  3f40: ef 08 41 54 30 32 11 0a 0a 07 00 00 00 00 00 00  ..AT02..........
  3f50: 90 08 41 54 30 33 11 0a 0a 07 00 00 00 00 00 00  ..AT03..........
  3f60: c6 08 41 54 30 34 11 0a 0a 07 00 00 00 00 00 00  ..AT04..........
  3f70: 91 08 41 54 41 30 11 03 0a 1d 08 41 54 41 31 11  ..ATA0.....ATA1.
  3f80: 03 0a 1d 08 41 54 41 32 11 03 0a 1d 08 41 54 41  ....ATA2.....ATA
  3f90: 33 11 03 0a 1d 08 41 54 41 42 11 03 0a 1d 8c 41  3.....ATAB.....A
  3fa0: 54 41 42 00 43 4d 44 43 14 4c 05 47 54 46 42 0b  TAB.CMDC.L.GTFB.
  3fb0: 77 43 4d 44 43 0a 38 60 72 60 0a 08 61 5b 13 41  wCMDC.8`r`..a[.A
  3fc0: 54 41 42 61 0a 38 43 4d 44 58 77 43 4d 44 43 0a  TABa.8CMDXwCMDC.
  3fd0: 07 60 8c 41 54 41 42 72 60 0a 02 00 41 30 30 31  .`.ATABr`...A001
  3fe0: 8c 41 54 41 42 72 60 0a 06 00 41 30 30 35 70 68  .ATABr`...A005ph
  3ff0: 43 4d 44 58 70 69 41 30 30 31 70 6a 41 30 30 35  CMDXpiA001pjA005
  4000: 75 43 4d 44 43 14 42 23 47 54 46 5f 0a 70 69 5b  uCMDC.B#GTF_.pi[
  4010: 31 70 00 43 4d 44 43 08 49 44 34 39 0b 00 0c 08  1p.CMDC.ID49....
  4020: 49 44 35 39 00 08 49 44 35 33 0a 04 08 49 44 36  ID59..ID53...ID6
  4030: 33 0b 00 0f 08 49 44 38 38 0b 00 0f 08 49 52 44  3....ID88....IRD
  4040: 59 01 08 50 49 4f 54 00 08 44 4d 41 54 00 a0 4d  Y..PIOT..DMAT..M
  4050: 05 93 87 69 0b 00 02 8b 69 0a 62 49 57 34 39 70  ...i....i.bIW49p
  4060: 49 57 34 39 49 44 34 39 8b 69 0a 6a 49 57 35 33  IW49ID49.i.jIW53
  4070: 70 49 57 35 33 49 44 35 33 8b 69 0a 7e 49 57 36  pIW53ID53.i.~IW6
  4080: 33 70 49 57 36 33 49 44 36 33 8b 69 0a 76 49 57  3pIW63ID63.i.vIW
  4090: 35 39 70 49 57 35 39 49 44 35 39 8b 69 0a b0 49  59pIW59ID59.i..I
  40a0: 57 38 38 70 49 57 38 38 49 44 38 38 70 0a a0 67  W88pIW88ID88p..g
  40b0: a0 48 05 68 70 0a b0 67 7b 43 48 4e 46 0a 08 49  .H.hp..g{CHNF..I
  40c0: 52 44 59 a0 12 7b 43 48 4e 46 0a 10 00 70 50 49  RDY..{CHNF...pPI
  40d0: 4f 31 50 49 4f 54 a1 0a 70 50 49 4f 30 50 49 4f  O1PIOT..pPIO0PIO
  40e0: 54 a0 27 7b 43 48 4e 46 0a 04 00 a0 12 7b 43 48  T.'{CHNF.....{CH
  40f0: 4e 46 0a 10 00 70 44 4d 41 31 44 4d 41 54 a1 0a  NF...pDMA1DMAT..
  4100: 70 44 4d 41 30 44 4d 41 54 a1 27 7b 43 48 4e 46  pDMA0DMAT.'{CHNF
  4110: 0a 02 49 52 44 59 70 50 49 4f 30 50 49 4f 54 a0  ..IRDYpPIO0PIOT.
  4120: 11 7b 43 48 4e 46 01 00 70 44 4d 41 30 44 4d 41  .{CHNF..pDMA0DMA
  4130: 54 a0 45 04 90 90 7b 49 44 35 33 0a 04 00 7b 49  T.E...{ID53...{I
  4140: 44 38 38 0b 00 ff 00 44 4d 41 54 70 89 83 88 54  D88....DMATp...T
  4150: 49 4d 30 0a 03 00 02 44 4d 41 54 00 00 00 61 a0  IM0....DMAT...a.
  4160: 09 94 61 0a 05 70 0a 05 61 47 54 46 42 41 54 30  ..a..p..aGTFBAT0
  4170: 31 7d 0a 40 61 00 67 a1 42 04 a0 3f 90 7b 49 44  1}.@a.g.B..?.{ID
  4180: 36 33 0b 00 ff 00 50 49 4f 54 7b 89 83 88 54 49  63....PIOT{...TI
  4190: 4d 30 00 00 04 50 49 4f 54 00 00 00 0a 03 60 7d  M0...PIOT.....`}
  41a0: 0a 20 83 88 83 88 54 49 4d 30 0a 07 00 60 00 61  . ....TIM0...`.a
  41b0: 47 54 46 42 41 54 30 31 61 67 a0 35 49 52 44 59  GTFBAT01ag.5IRDY
  41c0: 7b 89 83 88 54 49 4d 30 00 00 04 50 49 4f 54 00  {...TIM0...PIOT.
  41d0: 00 00 0a 07 60 7d 0a 08 83 88 83 88 54 49 4d 30  ....`}......TIM0
  41e0: 0a 06 00 60 00 61 47 54 46 42 41 54 30 31 61 67  ...`.aGTFBAT01ag
  41f0: a1 16 a0 14 7b 49 44 34 39 0b 00 04 00 47 54 46  ....{ID49....GTF
  4200: 42 41 54 30 31 01 67 a0 24 90 7b 49 44 35 39 0b  BAT01.g.$.{ID59.
  4210: 00 01 00 7b 49 44 35 39 0a ff 00 47 54 46 42 41  ...{ID59...GTFBA
  4220: 54 30 33 7b 49 44 35 39 0a ff 00 67 70 41 54 41  T03{ID59...gpATA
  4230: 42 5b 31 a4 41 54 41 42 14 31 52 41 54 41 01 8c  B[1.ATAB.1RATA..
  4240: 68 00 43 4d 44 4e 77 43 4d 44 4e 0a 38 60 5b 13  h.CMDNwCMDN.8`[.
  4250: 68 0a 08 60 52 45 54 42 70 52 45 54 42 5b 31 a4  h..`RETBpRETB[1.
  4260: 73 52 45 54 42 46 5a 54 46 00 5b 82 41 07 55 53  sRETBFZTF.[.A.US
  4270: 42 30 08 5f 41 44 52 0c 00 00 1d 00 5b 80 42 41  B0._ADR.....[.BA
  4280: 52 30 02 0a c4 01 5b 81 0d 42 41 52 30 01 55 53  R0....[..BAR0.US
  4290: 42 57 02 00 06 14 1e 5f 53 33 44 00 a0 12 91 93  BW....._S3D.....
  42a0: 4f 53 46 4c 01 93 4f 53 46 4c 0a 02 a4 0a 02 a1  OSFL..OSFL......
  42b0: 04 a4 0a 03 14 18 5f 50 53 57 01 a0 09 68 70 0a  ......_PSW...hp.
  42c0: 03 55 53 42 57 a1 07 70 00 55 53 42 57 14 0f 5f  .USBW..p.USBW.._
  42d0: 50 52 57 00 a4 47 50 52 57 0a 03 0a 04 5b 82 41  PRW..GPRW....[.A
  42e0: 07 55 53 42 31 08 5f 41 44 52 0c 01 00 1d 00 5b  .USB1._ADR.....[
  42f0: 80 42 41 52 30 02 0a c4 01 5b 81 0d 42 41 52 30  .BAR0....[..BAR0
  4300: 01 55 53 42 57 02 00 06 14 1e 5f 53 33 44 00 a0  .USBW....._S3D..
  4310: 12 91 93 4f 53 46 4c 01 93 4f 53 46 4c 0a 02 a4  ...OSFL..OSFL...
  4320: 0a 02 a1 04 a4 0a 03 14 18 5f 50 53 57 01 a0 09  ........._PSW...
  4330: 68 70 0a 03 55 53 42 57 a1 07 70 00 55 53 42 57  hp..USBW..p.USBW
  4340: 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 04 0a 04  .._PRW..GPRW....
  4350: 5b 82 41 07 55 53 42 32 08 5f 41 44 52 0c 02 00  [.A.USB2._ADR...
  4360: 1d 00 5b 80 42 41 52 30 02 0a c4 01 5b 81 0d 42  ..[.BAR0....[..B
  4370: 41 52 30 01 55 53 42 57 02 00 06 14 1e 5f 53 33  AR0.USBW....._S3
  4380: 44 00 a0 12 91 93 4f 53 46 4c 01 93 4f 53 46 4c  D.....OSFL..OSFL
  4390: 0a 02 a4 0a 02 a1 04 a4 0a 03 14 18 5f 50 53 57  ............_PSW
  43a0: 01 a0 09 68 70 0a 03 55 53 42 57 a1 07 70 00 55  ...hp..USBW..p.U
  43b0: 53 42 57 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a  SBW.._PRW..GPRW.
  43c0: 0c 0a 04 5b 82 41 07 55 53 42 35 08 5f 41 44 52  ...[.A.USB5._ADR
  43d0: 0c 03 00 1d 00 5b 80 42 41 52 30 02 0a c4 01 5b  .....[.BAR0....[
  43e0: 81 0d 42 41 52 30 01 55 53 42 57 02 00 06 14 1e  ..BAR0.USBW.....
  43f0: 5f 53 33 44 00 a0 12 91 93 4f 53 46 4c 01 93 4f  _S3D.....OSFL..O
  4400: 53 46 4c 0a 02 a4 0a 02 a1 04 a4 0a 03 14 18 5f  SFL............_
  4410: 50 53 57 01 a0 09 68 70 0a 03 55 53 42 57 a1 07  PSW...hp..USBW..
  4420: 70 00 55 53 42 57 14 0f 5f 50 52 57 00 a4 47 50  p.USBW.._PRW..GP
  4430: 52 57 0a 20 0a 04 5b 82 1f 45 55 53 42 08 5f 41  RW. ..[..EUSB._A
  4440: 44 52 0c 07 00 1d 00 14 0f 5f 50 52 57 00 a4 47  DR......._PRW..G
  4450: 50 52 57 0a 0d 0a 04 5b 82 41 07 55 53 42 33 08  PRW....[.A.USB3.
  4460: 5f 41 44 52 0c 00 00 1a 00 5b 80 42 41 52 30 02  _ADR.....[.BAR0.
  4470: 0a c4 01 5b 81 0d 42 41 52 30 01 55 53 42 57 02  ...[..BAR0.USBW.
  4480: 00 06 14 1e 5f 53 33 44 00 a0 12 91 93 4f 53 46  ...._S3D.....OSF
  4490: 4c 01 93 4f 53 46 4c 0a 02 a4 0a 02 a1 04 a4 0a  L..OSFL.........
  44a0: 03 14 18 5f 50 53 57 01 a0 09 68 70 0a 03 55 53  ..._PSW...hp..US
  44b0: 42 57 a1 07 70 00 55 53 42 57 14 0f 5f 50 52 57  BW..p.USBW.._PRW
  44c0: 00 a4 47 50 52 57 0a 0e 0a 04 5b 82 41 07 55 53  ..GPRW....[.A.US
  44d0: 42 34 08 5f 41 44 52 0c 01 00 1a 00 5b 80 42 41  B4._ADR.....[.BA
  44e0: 52 30 02 0a c4 01 5b 81 0d 42 41 52 30 01 55 53  R0....[..BAR0.US
  44f0: 42 57 02 00 06 14 1e 5f 53 33 44 00 a0 12 91 93  BW....._S3D.....
  4500: 4f 53 46 4c 01 93 4f 53 46 4c 0a 02 a4 0a 02 a1  OSFL..OSFL......
  4510: 04 a4 0a 03 14 18 5f 50 53 57 01 a0 09 68 70 0a  ......_PSW...hp.
  4520: 03 55 53 42 57 a1 07 70 00 55 53 42 57 14 0f 5f  .USBW..p.USBW.._
  4530: 50 52 57 00 a4 47 50 52 57 0a 05 0a 04 5b 82 41  PRW..GPRW....[.A
  4540: 07 55 53 42 36 08 5f 41 44 52 0c 02 00 1a 00 5b  .USB6._ADR.....[
  4550: 80 42 41 52 30 02 0a c4 01 5b 81 0d 42 41 52 30  .BAR0....[..BAR0
  4560: 01 55 53 42 57 02 00 06 14 1e 5f 53 33 44 00 a0  .USBW....._S3D..
  4570: 12 91 93 4f 53 46 4c 01 93 4f 53 46 4c 0a 02 a4  ...OSFL..OSFL...
  4580: 0a 02 a1 04 a4 0a 03 14 18 5f 50 53 57 01 a0 09  ........._PSW...
  4590: 68 70 0a 03 55 53 42 57 a1 07 70 00 55 53 42 57  hp..USBW..p.USBW
  45a0: 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 20 0a 04  .._PRW..GPRW. ..
  45b0: 5b 82 1f 55 53 42 45 08 5f 41 44 52 0c 07 00 1a  [..USBE._ADR....
  45c0: 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 0d 0a  ..._PRW..GPRW...
  45d0: 04 5b 82 36 50 30 50 34 08 5f 41 44 52 0c 00 00  .[.6P0P4._ADR...
  45e0: 1c 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  45f0: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  4600: 41 52 30 34 a4 50 52 30 34 5b 82 36 50 30 50 35  AR04.PR04[.6P0P5
  4610: 08 5f 41 44 52 0c 01 00 1c 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4620: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  4630: 00 a0 0a 50 49 43 4d a4 41 52 30 35 a4 50 52 30  ...PICM.AR05.PR0
  4640: 35 5b 82 36 50 30 50 36 08 5f 41 44 52 0c 02 00  5[.6P0P6._ADR...
  4650: 1c 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  4660: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  4670: 41 52 30 36 a4 50 52 30 36 5b 82 36 50 30 50 37  AR06.PR06[.6P0P7
  4680: 08 5f 41 44 52 0c 03 00 1c 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4690: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  46a0: 00 a0 0a 50 49 43 4d a4 41 52 30 37 a4 50 52 30  ...PICM.AR07.PR0
  46b0: 37 5b 82 36 50 30 50 38 08 5f 41 44 52 0c 04 00  7[.6P0P8._ADR...
  46c0: 1c 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  46d0: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  46e0: 41 52 30 38 a4 50 52 30 38 5b 82 36 50 30 50 39  AR08.PR08[.6P0P9
  46f0: 08 5f 41 44 52 0c 05 00 1c 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4700: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  4710: 00 a0 0a 50 49 43 4d a4 41 52 30 39 a4 50 52 30  ...PICM.AR09.PR0
  4720: 39 5b 82 36 4e 50 45 31 08 5f 41 44 52 0c 00 00  9[.6NPE1._ADR...
  4730: 01 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  4740: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  4750: 41 52 31 31 a4 50 52 31 31 5b 82 36 4e 50 45 32  AR11.PR11[.6NPE2
  4760: 08 5f 41 44 52 0c 00 00 02 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4770: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  4780: 00 a0 0a 50 49 43 4d a4 41 52 31 32 a4 50 52 31  ...PICM.AR12.PR1
  4790: 32 5b 82 36 4e 50 45 33 08 5f 41 44 52 0c 00 00  2[.6NPE3._ADR...
  47a0: 03 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  47b0: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  47c0: 41 52 31 33 a4 50 52 31 33 5b 82 36 4e 50 45 34  AR13.PR13[.6NPE4
  47d0: 08 5f 41 44 52 0c 00 00 04 00 14 0f 5f 50 52 57  ._ADR......._PRW
  47e0: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  47f0: 00 a0 0a 50 49 43 4d a4 41 52 31 34 a4 50 52 31  ...PICM.AR14.PR1
  4800: 34 5b 82 36 4e 50 45 35 08 5f 41 44 52 0c 00 00  4[.6NPE5._ADR...
  4810: 05 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  4820: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  4830: 41 52 31 35 a4 50 52 31 35 5b 82 36 4e 50 45 36  AR15.PR15[.6NPE6
  4840: 08 5f 41 44 52 0c 00 00 06 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4850: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  4860: 00 a0 0a 50 49 43 4d a4 41 52 31 36 a4 50 52 31  ...PICM.AR16.PR1
  4870: 36 5b 82 36 4e 50 45 37 08 5f 41 44 52 0c 00 00  6[.6NPE7._ADR...
  4880: 07 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  4890: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  48a0: 41 52 31 37 a4 50 52 31 37 5b 82 36 4e 50 45 38  AR17.PR17[.6NPE8
  48b0: 08 5f 41 44 52 0c 00 00 08 00 14 0f 5f 50 52 57  ._ADR......._PRW
  48c0: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  48d0: 00 a0 0a 50 49 43 4d a4 41 52 31 38 a4 50 52 31  ...PICM.AR18.PR1
  48e0: 38 5b 82 36 4e 50 45 39 08 5f 41 44 52 0c 00 00  8[.6NPE9._ADR...
  48f0: 09 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 09  ...._PRW..GPRW..
  4900: 0a 04 14 16 5f 50 52 54 00 a0 0a 50 49 43 4d a4  ...._PRT...PICM.
  4910: 41 52 31 39 a4 50 52 31 39 5b 82 36 4e 50 45 41  AR19.PR19[.6NPEA
  4920: 08 5f 41 44 52 0c 00 00 0a 00 14 0f 5f 50 52 57  ._ADR......._PRW
  4930: 00 a4 47 50 52 57 0a 09 0a 04 14 16 5f 50 52 54  ..GPRW......_PRT
  4940: 00 a0 0a 50 49 43 4d a4 41 52 31 41 a4 50 52 31  ...PICM.AR1A.PR1
  4950: 41 5b 82 1f 47 42 45 5f 08 5f 41 44 52 0c 00 00  A[..GBE_._ADR...
  4960: 19 00 14 0f 5f 50 52 57 00 a4 47 50 52 57 0a 0d  ...._PRW..GPRW..
  4970: 0a 04 10 4d 2b 5c 5f 47 50 45 14 25 5f 4c 30 42  ...M+\_GPE.%_L0B
  4980: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 50 30 50  ..\/._SB_PCI0P0P
  4990: 31 0a 02 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02  1...\._SB_PWRB..
  49a0: 14 19 5f 4c 31 44 00 5c 2f 04 5f 53 42 5f 50 43  .._L1D.\/._SB_PC
  49b0: 49 30 53 42 52 47 53 49 4f 48 14 25 5f 4c 30 33  I0SBRGSIOH.%_L03
  49c0: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42  ..\/._SB_PCI0USB
  49d0: 30 0a 02 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02  0...\._SB_PWRB..
  49e0: 14 25 5f 4c 30 34 00 86 5c 2f 03 5f 53 42 5f 50  .%_L04..\/._SB_P
  49f0: 43 49 30 55 53 42 31 0a 02 86 5c 2e 5f 53 42 5f  CI0USB1...\._SB_
  4a00: 50 57 52 42 0a 02 14 25 5f 4c 30 43 00 86 5c 2f  PWRB...%_L0C..\/
  4a10: 03 5f 53 42 5f 50 43 49 30 55 53 42 32 0a 02 86  ._SB_PCI0USB2...
  4a20: 5c 2e 5f 53 42 5f 50 57 52 42 0a 02 14 37 5f 4c  \._SB_PWRB...7_L
  4a30: 32 30 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55  20..\/._SB_PCI0U
  4a40: 53 42 35 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49  SB5...\/._SB_PCI
  4a50: 30 55 53 42 36 0a 02 86 5c 2e 5f 53 42 5f 50 57  0USB6...\._SB_PW
  4a60: 52 42 0a 02 14 4a 04 5f 4c 30 44 00 86 5c 2f 03  RB...J._L0D..\/.
  4a70: 5f 53 42 5f 50 43 49 30 45 55 53 42 0a 02 86 5c  _SB_PCI0EUSB...\
  4a80: 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 45 0a 02  /._SB_PCI0USBE..
  4a90: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 47 42 45 5f  .\/._SB_PCI0GBE_
  4aa0: 0a 02 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02 14  ...\._SB_PWRB...
  4ab0: 25 5f 4c 30 45 00 86 5c 2f 03 5f 53 42 5f 50 43  %_L0E..\/._SB_PC
  4ac0: 49 30 55 53 42 33 0a 02 86 5c 2e 5f 53 42 5f 50  I0USB3...\._SB_P
  4ad0: 57 52 42 0a 02 14 25 5f 4c 30 35 00 86 5c 2f 03  WRB...%_L05..\/.
  4ae0: 5f 53 42 5f 50 43 49 30 55 53 42 34 0a 02 86 5c  _SB_PCI0USB4...\
  4af0: 2e 5f 53 42 5f 50 57 52 42 0a 02 14 44 13 5f 4c  ._SB_PWRB...D._L
  4b00: 30 39 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 50  09..\/._SB_PCI0P
  4b10: 30 50 34 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49  0P4...\/._SB_PCI
  4b20: 30 50 30 50 35 0a 02 86 5c 2f 03 5f 53 42 5f 50  0P0P5...\/._SB_P
  4b30: 43 49 30 50 30 50 36 0a 02 86 5c 2f 03 5f 53 42  CI0P0P6...\/._SB
  4b40: 5f 50 43 49 30 50 30 50 37 0a 02 86 5c 2f 03 5f  _PCI0P0P7...\/._
  4b50: 53 42 5f 50 43 49 30 50 30 50 38 0a 02 86 5c 2f  SB_PCI0P0P8...\/
  4b60: 03 5f 53 42 5f 50 43 49 30 50 30 50 39 0a 02 86  ._SB_PCI0P0P9...
  4b70: 5c 2f 03 5f 53 42 5f 50 43 49 30 4e 50 45 31 0a  \/._SB_PCI0NPE1.
  4b80: 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 4e 50 45  ..\/._SB_PCI0NPE
  4b90: 32 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 4e  2...\/._SB_PCI0N
  4ba0: 50 45 33 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49  PE3...\/._SB_PCI
  4bb0: 30 4e 50 45 34 0a 02 86 5c 2f 03 5f 53 42 5f 50  0NPE4...\/._SB_P
  4bc0: 43 49 30 4e 50 45 35 0a 02 86 5c 2f 03 5f 53 42  CI0NPE5...\/._SB
  4bd0: 5f 50 43 49 30 4e 50 45 36 0a 02 86 5c 2f 03 5f  _PCI0NPE6...\/._
  4be0: 53 42 5f 50 43 49 30 4e 50 45 37 0a 02 86 5c 2f  SB_PCI0NPE7...\/
  4bf0: 03 5f 53 42 5f 50 43 49 30 4e 50 45 38 0a 02 86  ._SB_PCI0NPE8...
  4c00: 5c 2f 03 5f 53 42 5f 50 43 49 30 4e 50 45 39 0a  \/._SB_PCI0NPE9.
  4c10: 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 4e 50 45  ..\/._SB_PCI0NPE
  4c20: 41 0a 02 86 5c 2e 5f 53 42 5f 50 57 52 42 0a 02  A...\._SB_PWRB..
  4c30: 5b 82 1d 50 57 52 42 08 5f 48 49 44 0c 41 d0 0c  [..PWRB._HID.A..
  4c40: 0c 08 5f 55 49 44 0a aa 08 5f 53 54 41 0a 0b 5b  .._UID..._STA..[
  4c50: 80 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 50  ./._SB_PCI0SBRGP
  4c60: 49 58 30 02 0a 60 0a 0c 5b 81 3f 5c 2f 04 5f 53  IX0..`..[.?\/._S
  4c70: 42 5f 50 43 49 30 53 42 52 47 50 49 58 30 01 50  B_PCI0SBRGPIX0.P
  4c80: 49 52 41 08 50 49 52 42 08 50 49 52 43 08 50 49  IRA.PIRB.PIRC.PI
  4c90: 52 44 08 00 20 50 49 52 45 08 50 49 52 46 08 50  RD.. PIRE.PIRF.P
  4ca0: 49 52 47 08 50 49 52 48 08 10 4e 45 5f 53 42 5f  IRG.PIRH..NE_SB_
  4cb0: 08 42 55 46 41 11 09 0a 06 23 00 80 18 79 00 8b  .BUFA....#...y..
  4cc0: 42 55 46 41 01 49 52 41 30 5b 82 45 08 4c 4e 4b  BUFA.IRA0[.E.LNK
  4cd0: 41 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  A._HID.A...._UID
  4ce0: 01 14 19 5f 53 54 41 00 7b 50 49 52 41 0a 80 60  ..._STA.{PIRA..`
  4cf0: a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52  ..`.........._PR
  4d00: 53 00 a4 50 52 53 41 14 11 5f 44 49 53 00 7d 50  S..PRSA.._DIS.}P
  4d10: 49 52 41 0a 80 50 49 52 41 14 1a 5f 43 52 53 00  IRA..PIRA.._CRS.
  4d20: 7b 50 49 52 41 0a 0f 60 79 01 60 49 52 41 30 a4  {PIRA..`y.`IRA0.
  4d30: 42 55 46 41 14 1b 5f 53 52 53 01 8b 68 01 49 52  BUFA.._SRS..h.IR
  4d40: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 41  A_.IRA_`v`p`PIRA
  4d50: 5b 82 46 08 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0  [.F.LNKB._HID.A.
  4d60: 0c 0f 08 5f 55 49 44 0a 02 14 19 5f 53 54 41 00  ..._UID...._STA.
  4d70: 7b 50 49 52 42 0a 80 60 a0 05 60 a4 0a 09 a1 04  {PIRB..`..`.....
  4d80: a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53 42 14  ....._PRS..PRSB.
  4d90: 11 5f 44 49 53 00 7d 50 49 52 42 0a 80 50 49 52  ._DIS.}PIRB..PIR
  4da0: 42 14 1a 5f 43 52 53 00 7b 50 49 52 42 0a 0f 60  B.._CRS.{PIRB..`
  4db0: 79 01 60 49 52 41 30 a4 42 55 46 41 14 1b 5f 53  y.`IRA0.BUFA.._S
  4dc0: 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60  RS..h.IRA_.IRA_`
  4dd0: 76 60 70 60 50 49 52 42 5b 82 46 08 4c 4e 4b 43  v`p`PIRB[.F.LNKC
  4de0: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  4df0: 03 14 19 5f 53 54 41 00 7b 50 49 52 43 0a 80 60  ..._STA.{PIRC..`
  4e00: a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52  ..`.........._PR
  4e10: 53 00 a4 50 52 53 43 14 11 5f 44 49 53 00 7d 50  S..PRSC.._DIS.}P
  4e20: 49 52 43 0a 80 50 49 52 43 14 1a 5f 43 52 53 00  IRC..PIRC.._CRS.
  4e30: 7b 50 49 52 43 0a 0f 60 79 01 60 49 52 41 30 a4  {PIRC..`y.`IRA0.
  4e40: 42 55 46 41 14 1b 5f 53 52 53 01 8b 68 01 49 52  BUFA.._SRS..h.IR
  4e50: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 43  A_.IRA_`v`p`PIRC
  4e60: 5b 82 46 08 4c 4e 4b 44 08 5f 48 49 44 0c 41 d0  [.F.LNKD._HID.A.
  4e70: 0c 0f 08 5f 55 49 44 0a 04 14 19 5f 53 54 41 00  ..._UID...._STA.
  4e80: 7b 50 49 52 44 0a 80 60 a0 05 60 a4 0a 09 a1 04  {PIRD..`..`.....
  4e90: a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53 44 14  ....._PRS..PRSD.
  4ea0: 11 5f 44 49 53 00 7d 50 49 52 44 0a 80 50 49 52  ._DIS.}PIRD..PIR
  4eb0: 44 14 1a 5f 43 52 53 00 7b 50 49 52 44 0a 0f 60  D.._CRS.{PIRD..`
  4ec0: 79 01 60 49 52 41 30 a4 42 55 46 41 14 1b 5f 53  y.`IRA0.BUFA.._S
  4ed0: 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60  RS..h.IRA_.IRA_`
  4ee0: 76 60 70 60 50 49 52 44 5b 82 46 08 4c 4e 4b 45  v`p`PIRD[.F.LNKE
  4ef0: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  4f00: 05 14 19 5f 53 54 41 00 7b 50 49 52 45 0a 80 60  ..._STA.{PIRE..`
  4f10: a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52  ..`.........._PR
  4f20: 53 00 a4 50 52 53 45 14 11 5f 44 49 53 00 7d 50  S..PRSE.._DIS.}P
  4f30: 49 52 45 0a 80 50 49 52 45 14 1a 5f 43 52 53 00  IRE..PIRE.._CRS.
  4f40: 7b 50 49 52 45 0a 0f 60 79 01 60 49 52 41 30 a4  {PIRE..`y.`IRA0.
  4f50: 42 55 46 41 14 1b 5f 53 52 53 01 8b 68 01 49 52  BUFA.._SRS..h.IR
  4f60: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 45  A_.IRA_`v`p`PIRE
  4f70: 5b 82 46 08 4c 4e 4b 46 08 5f 48 49 44 0c 41 d0  [.F.LNKF._HID.A.
  4f80: 0c 0f 08 5f 55 49 44 0a 06 14 19 5f 53 54 41 00  ..._UID...._STA.
  4f90: 7b 50 49 52 46 0a 80 60 a0 05 60 a4 0a 09 a1 04  {PIRF..`..`.....
  4fa0: a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53 46 14  ....._PRS..PRSF.
  4fb0: 11 5f 44 49 53 00 7d 50 49 52 46 0a 80 50 49 52  ._DIS.}PIRF..PIR
  4fc0: 46 14 1a 5f 43 52 53 00 7b 50 49 52 46 0a 0f 60  F.._CRS.{PIRF..`
  4fd0: 79 01 60 49 52 41 30 a4 42 55 46 41 14 1b 5f 53  y.`IRA0.BUFA.._S
  4fe0: 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60  RS..h.IRA_.IRA_`
  4ff0: 76 60 70 60 50 49 52 46 5b 82 46 08 4c 4e 4b 47  v`p`PIRF[.F.LNKG
  5000: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  5010: 07 14 19 5f 53 54 41 00 7b 50 49 52 47 0a 80 60  ..._STA.{PIRG..`
  5020: a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52  ..`.........._PR
  5030: 53 00 a4 50 52 53 47 14 11 5f 44 49 53 00 7d 50  S..PRSG.._DIS.}P
  5040: 49 52 47 0a 80 50 49 52 47 14 1a 5f 43 52 53 00  IRG..PIRG.._CRS.
  5050: 7b 50 49 52 47 0a 0f 60 79 01 60 49 52 41 30 a4  {PIRG..`y.`IRA0.
  5060: 42 55 46 41 14 1b 5f 53 52 53 01 8b 68 01 49 52  BUFA.._SRS..h.IR
  5070: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 47  A_.IRA_`v`p`PIRG
  5080: 5b 82 46 08 4c 4e 4b 48 08 5f 48 49 44 0c 41 d0  [.F.LNKH._HID.A.
  5090: 0c 0f 08 5f 55 49 44 0a 08 14 19 5f 53 54 41 00  ..._UID...._STA.
  50a0: 7b 50 49 52 48 0a 80 60 a0 05 60 a4 0a 09 a1 04  {PIRH..`..`.....
  50b0: a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53 48 14  ....._PRS..PRSH.
  50c0: 11 5f 44 49 53 00 7d 50 49 52 48 0a 80 50 49 52  ._DIS.}PIRH..PIR
  50d0: 48 14 1a 5f 43 52 53 00 7b 50 49 52 48 0a 0f 60  H.._CRS.{PIRH..`
  50e0: 79 01 60 49 52 41 30 a4 42 55 46 41 14 1b 5f 53  y.`IRA0.BUFA.._S
  50f0: 52 53 01 8b 68 01 49 52 41 5f 82 49 52 41 5f 60  RS..h.IRA_.IRA_`
  5100: 76 60 70 60 50 49 52 48 10 49 25 5f 53 42 5f 08  v`p`PIRH.I%_SB_.
  5110: 58 43 50 44 00 08 58 4e 50 54 01 08 58 43 41 50  XCPD..XNPT..XCAP
  5120: 0a 02 08 58 44 43 50 0a 04 08 58 44 43 54 0a 08  ...XDCP...XDCT..
  5130: 08 58 44 53 54 0a 0a 08 58 4c 43 50 0a 0c 08 58  .XDST...XLCP...X
  5140: 4c 43 54 0a 10 08 58 4c 53 54 0a 12 08 58 53 43  LCT...XLST...XSC
  5150: 50 0a 14 08 58 53 43 54 0a 18 08 58 53 53 54 0a  P...XSCT...XSST.
  5160: 1a 08 58 52 43 54 0a 1c 5b 01 4d 55 54 45 00 14  ..XRCT..[.MUTE..
  5170: 36 52 42 50 45 01 5b 23 4d 55 54 45 e8 03 72 68  6RBPE.[#MUTE..rh
  5180: 50 43 49 42 60 5b 80 50 43 46 47 00 60 01 5b 81  PCIB`[.PCFG.`.[.
  5190: 0b 50 43 46 47 01 58 43 46 47 08 5b 27 4d 55 54  .PCFG.XCFG.['MUT
  51a0: 45 a4 58 43 46 47 14 3f 52 57 50 45 01 5b 23 4d  E.XCFG.?RWPE.[#M
  51b0: 55 54 45 e8 03 7b 68 0c fe ff ff ff 68 72 68 50  UTE..{h.....hrhP
  51c0: 43 49 42 60 5b 80 50 43 46 47 00 60 0a 02 5b 81  CIB`[.PCFG.`..[.
  51d0: 0b 50 43 46 47 02 58 43 46 47 10 5b 27 4d 55 54  .PCFG.XCFG.['MUT
  51e0: 45 a4 58 43 46 47 14 3f 52 44 50 45 01 5b 23 4d  E.XCFG.?RDPE.[#M
  51f0: 55 54 45 e8 03 7b 68 0c fc ff ff ff 68 72 68 50  UTE..{h.....hrhP
  5200: 43 49 42 60 5b 80 50 43 46 47 00 60 0a 04 5b 81  CIB`[.PCFG.`..[.
  5210: 0b 50 43 46 47 03 58 43 46 47 20 5b 27 4d 55 54  .PCFG.XCFG ['MUT
  5220: 45 a4 58 43 46 47 14 37 57 42 50 45 02 5b 23 4d  E.XCFG.7WBPE.[#M
  5230: 55 54 45 ff 0f 72 68 50 43 49 42 60 5b 80 50 43  UTE..rhPCIB`[.PC
  5240: 46 47 00 60 01 5b 81 0b 50 43 46 47 01 58 43 46  FG.`.[..PCFG.XCF
  5250: 47 08 70 69 58 43 46 47 5b 27 4d 55 54 45 14 41  G.piXCFG['MUTE.A
  5260: 04 57 57 50 45 02 5b 23 4d 55 54 45 e8 03 7b 68  .WWPE.[#MUTE..{h
  5270: 0c fe ff ff ff 68 72 68 50 43 49 42 60 5b 80 50  .....hrhPCIB`[.P
  5280: 43 46 47 00 60 0a 02 5b 81 0b 50 43 46 47 02 58  CFG.`..[..PCFG.X
  5290: 43 46 47 10 70 69 58 43 46 47 5b 27 4d 55 54 45  CFG.piXCFG['MUTE
  52a0: 14 41 04 57 44 50 45 02 5b 23 4d 55 54 45 e8 03  .A.WDPE.[#MUTE..
  52b0: 7b 68 0c fc ff ff ff 68 72 68 50 43 49 42 60 5b  {h.....hrhPCIB`[
  52c0: 80 50 43 46 47 00 60 0a 04 5b 81 0b 50 43 46 47  .PCFG.`..[..PCFG
  52d0: 03 58 43 46 47 20 70 69 58 43 46 47 5b 27 4d 55  .XCFG piXCFG['MU
  52e0: 54 45 14 49 04 52 57 44 50 03 5b 23 4d 55 54 45  TE.I.RWDP.[#MUTE
  52f0: e8 03 7b 68 0c fc ff ff ff 68 72 68 50 43 49 42  ..{h.....hrhPCIB
  5300: 60 5b 80 50 43 46 47 00 60 0a 04 5b 81 0b 50 43  `[.PCFG.`..[..PC
  5310: 46 47 03 58 43 46 47 20 7b 58 43 46 47 6a 61 7d  FG.XCFG {XCFGja}
  5320: 61 69 58 43 46 47 5b 27 4d 55 54 45 14 35 52 50  aiXCFG['MUTE.5RP
  5330: 4d 45 01 72 68 0a 84 60 70 52 44 50 45 60 61 a0  ME.rh..`pRDPE`a.
  5340: 06 93 61 ff a4 00 a1 1b a0 17 90 61 0c 00 00 01  ..a........a....
  5350: 00 57 44 50 45 60 7b 61 0c 00 00 01 00 00 a4 01  .WDPE`{a........
  5360: a4 00 10 45 19 5f 53 42 5f 10 4e 18 50 43 49 30  ...E._SB_.N.PCI0
  5370: 08 43 52 53 5f 11 46 0a 0a a2 88 0d 00 02 0c 00  .CRS_.F.........
  5380: 00 00 00 00 ff 00 00 00 00 01 47 01 f8 0c f8 0c  ..........G.....
  5390: 01 08 88 0d 00 01 0c 03 00 00 00 00 f7 0c 00 00  ................
  53a0: f8 0c 88 0d 00 01 0c 03 00 00 00 0d ff ff 00 00  ................
  53b0: 00 f3 87 17 00 00 0c 03 00 00 00 00 00 00 0a 00  ................
  53c0: ff ff 0b 00 00 00 00 00 00 00 02 00 87 17 00 00  ................
  53d0: 0c 03 00 00 00 00 00 00 0c 00 ff ff 0d 00 00 00  ................
  53e0: 00 00 00 00 02 00 87 17 00 00 0c 03 00 00 00 00  ................
  53f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  5400: 87 17 00 00 0c 03 00 00 00 00 00 00 00 00 00 00  ................
  5410: 00 00 00 00 00 00 00 00 00 00 79 00 8a 43 52 53  ..........y..CRS
  5420: 5f 0a 5c 4d 49 4e 35 8a 43 52 53 5f 0a 60 4d 41  _.\MIN5.CRS_.`MA
  5430: 58 35 8a 43 52 53 5f 0a 68 4c 45 4e 35 8a 43 52  X5.CRS_.hLEN5.CR
  5440: 53 5f 0a 76 4d 49 4e 36 8a 43 52 53 5f 0a 7a 4d  S_.vMIN6.CRS_.zM
  5450: 41 58 36 8a 43 52 53 5f 0a 82 4c 45 4e 36 8a 43  AX6.CRS_..LEN6.C
  5460: 52 53 5f 0a 90 4d 49 4e 37 8a 43 52 53 5f 0a 94  RS_..MIN7.CRS_..
  5470: 4d 41 58 37 8a 43 52 53 5f 0a 9c 4c 45 4e 37 14  MAX7.CRS_..LEN7.
  5480: 48 07 5f 43 52 53 00 70 4d 47 31 4c 60 a0 1f 60  H._CRS.pMG1L`..`
  5490: 70 4d 47 31 42 4d 49 4e 35 70 4d 47 31 4c 4c 45  pMG1BMIN5pMG1LLE
  54a0: 4e 35 72 4d 49 4e 35 76 60 4d 41 58 35 70 4d 47  N5rMIN5v`MAX5pMG
  54b0: 32 42 4d 49 4e 36 70 4d 47 32 4c 4c 45 4e 36 70  2BMIN6pMG2LLEN6p
  54c0: 4d 47 32 4c 60 72 4d 49 4e 36 76 60 4d 41 58 36  MG2L`rMIN6v`MAX6
  54d0: 70 4d 47 33 42 4d 49 4e 37 70 4d 47 33 4c 4c 45  pMG3BMIN7pMG3LLE
  54e0: 4e 37 70 4d 47 33 4c 60 72 4d 49 4e 37 76 60 4d  N7pMG3L`rMIN7v`M
  54f0: 41 58 37 a4 43 52 53 5f 08 57 4f 54 42 00 08 57  AX7.CRS_.WOTB..W
  5500: 53 53 42 00 08 57 41 58 42 00 14 40 07 5f 50 54  SSB..WAXB..@._PT
  5510: 53 01 70 68 44 42 47 38 50 54 53 5f 68 70 00 88  S.phDBG8PTS_hp..
  5520: 57 41 4b 50 00 00 70 00 88 57 41 4b 50 01 00 a0  WAKP..p..WAKP...
  5530: 12 90 93 68 0a 04 93 4f 53 46 4c 0a 02 5b 22 0b  ...h...OSFL..[".
  5540: b8 0b 70 41 53 53 42 57 53 53 42 70 41 4f 54 42  ..pASSBWSSBpAOTB
  5550: 57 4f 54 42 70 41 41 58 42 57 41 58 42 70 68 41  WOTBpAAXBWAXBphA
  5560: 53 53 42 70 4f 53 46 4c 41 4f 54 42 70 4f 53 59  SSBpOSFLAOTBpOSY
  5570: 53 4f 53 54 50 70 00 41 41 58 42 14 48 05 5f 57  SOSTPp.AAXB.H._W
  5580: 41 4b 01 79 68 0a 04 44 42 47 38 57 41 4b 5f 68  AK.yh..DBG8WAK_h
  5590: a0 20 41 53 53 42 70 57 53 53 42 41 53 53 42 70  . ASSBpWSSBASSBp
  55a0: 57 4f 54 42 41 4f 54 42 70 57 41 58 42 41 41 58  WOTBAOTBpWAXBAAX
  55b0: 42 a0 12 83 88 57 41 4b 50 00 00 70 00 88 57 41  B....WAKP..p..WA
  55c0: 4b 50 01 00 a1 0a 70 68 88 57 41 4b 50 01 00 a4  KP....ph.WAKP...
  55d0: 57 41 4b 50 08 5f 53 30 5f 12 06 04 00 00 00 00  WAKP._S0_.......
  55e0: a0 11 53 53 31 5f 08 5f 53 31 5f 12 06 04 01 00  ..SS1_._S1_.....
  55f0: 00 00 a0 12 53 53 33 5f 08 5f 53 33 5f 12 07 04  ....SS3_._S3_...
  5600: 0a 05 00 00 00 a0 12 53 53 34 5f 08 5f 53 34 5f  .......SS4_._S4_
  5610: 12 07 04 0a 06 00 00 00 08 5f 53 35 5f 12 07 04  ........._S5_...
  5620: 0a 07 00 00 00 14 42 04 50 54 53 5f 01 a0 3a 68  ......B.PTS_..:h
  5630: 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 53  \/._SB_PCI0SBRGS
  5640: 49 4f 53 68 5c 2f 03 5f 53 42 5f 50 43 49 30 4e  IOSh\/._SB_PCI0N
  5650: 50 54 53 68 5c 2f 04 5f 53 42 5f 50 43 49 30 53  PTSh\/._SB_PCI0S
  5660: 42 52 47 53 50 54 53 68 14 3e 57 41 4b 5f 01 5c  BRGSPTSh.>WAK_.\
  5670: 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 53 49  /._SB_PCI0SBRGSI
  5680: 4f 57 68 5c 2f 03 5f 53 42 5f 50 43 49 30 4e 57  OWh\/._SB_PCI0NW
  5690: 41 4b 68 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42  AKh\/._SB_PCI0SB
  56a0: 52 47 53 57 41 4b 68                             RGSWAKh

FACS @ 0xbf79e000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0xbf790200
  0000: 46 41 43 50 84 00 00 00 01 30 44 45 4c 4c 20 20  FACP.....0DELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 00 e0 79 bf 60 06 79 bf 01 00 09 00  ......y.`.y.....
  0030: b2 00 00 00 e1 1e 00 e2 00 08 00 00 00 00 00 00  ................
  0040: 04 08 00 00 00 00 00 00 50 08 00 00 08 08 00 00  ........P.......
  0050: 20 08 00 00 00 00 00 00 04 02 01 04 10 00 00 e3   ...............
  0060: 65 00 e9 03 00 04 10 00 01 00 0d 00 32 03 00 00  e...........2...
  0070: a5 00 00 00 01 08 00 00 f9 0c 00 00 00 00 00 00  ................
  0080: 06 00 00 00                                      ....

APIC @ 0xbf790390
  0000: 41 50 49 43 8c 00 00 00 01 07 44 45 4c 4c 20 20  APIC......DELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 00 00 e0 fe 01 00 00 00 00 08 01 00  ................
  0030: 01 00 00 00 00 08 02 02 01 00 00 00 00 08 03 04  ................
  0040: 01 00 00 00 00 08 04 06 01 00 00 00 00 08 05 84  ................
  0050: 00 00 00 00 00 08 06 85 00 00 00 00 00 08 07 86  ................
  0060: 00 00 00 00 00 08 08 87 00 00 00 00 01 0c 07 00  ................
  0070: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0080: 00 00 02 0a 00 09 09 00 00 00 0d 00              ............

MCFG @ 0xbf790420
  0000: 4d 43 46 47 3c 00 00 00 01 35 44 45 4c 4c 20 20  MCFG<....5DELL  
  0010: 4f 45 4d 4d 43 46 47 20 15 04 09 20 4d 53 46 54  OEMMCFG ... MSFT
  0020: 97 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0  ................
  0030: 00 00 00 00 00 00 00 ff 00 00 00 00              ............

SLIC @ 0xbf790460
  0000: 53 4c 49 43 76 01 00 00 01 df 44 45 4c 4c 20 20  SLICv.....DELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 00 00 00 00 9c 00 00 00 06 02 00 00  ................
  0030: 00 24 00 00 52 53 41 31 00 04 00 00 01 00 01 00  .$..RSA1........
  0040: 7f f6 c1 05 be 5c 57 63 a5 8a 68 f3 6e 8f 06 fa  .....\Wc..h.n...
  0050: af b4 9f 68 82 23 ec 50 40 5a 73 7f ec e4 07 cb  ...h.#.P@Zs.....
  0060: dc 25 1a 9c e3 e3 66 11 e0 a5 98 06 c5 80 0a fa  .%....f.........
  0070: 42 93 86 98 e7 d5 1b d4 d7 3a a4 0b ee e2 7d be  B........:....}.
  0080: 5f 5b 15 0c ab d0 21 de bf e9 b5 6e a4 57 b9 8c  _[....!....n.W..
  0090: 0c d2 ba 3a 69 30 76 94 71 a2 64 d7 4c d8 85 bf  ...:i0v.q.d.L...
  00a0: df a5 6a c8 dc 45 d5 4d 8c b8 8c 05 2f fc 2e 23  ..j..E.M..../..#
  00b0: c4 29 c5 6f 3f 29 6c 6d 57 79 0e b6 75 ed 21 95  .).o?)lmWy..u.!.
  00c0: 01 00 00 00 b6 00 00 00 00 00 02 00 44 45 4c 4c  ............DELL
  00d0: 20 20 46 58 30 39 20 20 20 00 57 49 4e 44 4f 57    FX09   .WINDOW
  00e0: 53 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00  S ..............
  00f0: 00 00 00 00 00 00 76 c9 ff bd 36 ef ad 55 34 02  ......v...6..U4.
  0100: f0 0e 8f 66 61 d1 3b 53 b5 3e 74 fc 17 ff 99 46  ...fa.;S.>t....F
  0110: dd d5 90 37 f6 a7 b1 fb b0 94 00 ea 69 7e 60 2d  ...7........i~`-
  0120: f2 03 0e 9f 0f 94 09 17 25 c4 a2 72 cf 94 d4 ea  ........%..r....
  0130: cf b4 7f c4 2d b5 53 d9 c4 47 29 fe 98 f8 4a 20  ....-.S..G)...J 
  0140: 75 89 14 2b d2 fe 8c bf 4f 11 08 20 00 64 eb e9  u..+....O.. .d..
  0150: 91 3a 23 4d 84 5a e5 52 0b 83 db 52 ef da 64 60  .:#M.Z.R...R..d`
  0160: ff 9e b9 50 c6 dd b9 21 64 93 fa 85 53 71 29 0a  ...P...!d...Sq).
  0170: 65 2f 37 ad 11 24                                e/7..$

OSFR @ 0xbf7905e0
  0000: 4f 53 46 52 80 00 00 00 01 6a 44 45 4c 4c 20 20  OSFR.....jDELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

OEMB @ 0xbf79e040
  0000: 4f 45 4d 42 72 00 00 00 01 90 44 45 4c 4c 20 20  OEMBr.....DELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 0c 00 00 00 00 00 c0 00 00 f0 ff 00  ................
  0030: 00 0d 00 00 00 01 00 00 00 00 c0 00 00 00 20 00  .............. .
  0040: 8b c0 4f 0e 00 00 00 00 00 00 00 00 00 00 00 00  ..O.............
  0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060: 00 00 00 00 f0 00 00 d9 0e 00 00 d9 fe 00 00 00  ................
  0070: 00 00                                            ..

HPET @ 0xbf798660
  0000: 48 50 45 54 38 00 00 00 01 f9 44 45 4c 4c 20 20  HPET8.....DELL  
  0010: 4f 45 4d 48 50 45 54 20 15 04 09 20 4d 53 46 54  OEMHPET ... MSFT
  0020: 97 00 00 00 ff ff ff ff 00 08 00 00 00 00 d0 fe  ................
  0030: 00 00 00 00 00 ee 37 00                          ......7.

SSDT @ 0xbf79f670
  0000: 53 53 44 54 98 12 00 00 01 b3 44 70 67 50 6d 6d  SSDT......DpgPmm
  0010: 43 70 75 50 6d 00 00 00 12 00 00 00 49 4e 54 4c  CpuPm.......INTL
  0020: 17 11 05 20 10 43 27 5c 00 08 53 53 44 54 12 43  ... .C'\..SSDT.C
  0030: 0a 18 0d 43 50 55 30 49 53 54 20 00 0c c0 e0 79  ...CPU0IST ....y
  0040: bf 0c 03 04 00 00 0d 43 50 55 31 49 53 54 20 00  .......CPU1IST .
  0050: 0c d0 e4 79 bf 0c 03 04 00 00 0d 43 50 55 32 49  ...y.......CPU2I
  0060: 53 54 20 00 0c e0 e8 79 bf 0c 03 04 00 00 0d 43  ST ....y.......C
  0070: 50 55 33 49 53 54 20 00 0c f0 ec 79 bf 0c 03 04  PU3IST ....y....
  0080: 00 00 0d 43 50 55 34 49 53 54 20 00 0c 00 00 00  ...CPU4IST .....
  0090: 80 0c 00 00 00 80 0d 43 50 55 35 49 53 54 20 00  .......CPU5IST .
  00a0: 0c 00 00 00 80 0c 00 00 00 80 0d 43 50 55 36 49  ...........CPU6I
  00b0: 53 54 20 00 0c 00 00 00 80 0c 00 00 00 80 0d 43  ST ............C
  00c0: 50 55 37 49 53 54 20 00 0c 00 00 00 80 0c 00 00  PU7IST .........
  00d0: 00 80 08 43 53 44 54 12 43 0a 18 0d 43 50 55 30  ...CSDT.C...CPU0
  00e0: 43 53 54 20 00 0c 00 f1 79 bf 0c b2 03 00 00 0d  CST ....y.......
  00f0: 43 50 55 31 43 53 54 20 00 0c c0 f4 79 bf 0c 85  CPU1CST ....y...
  0100: 00 00 00 0d 43 50 55 32 43 53 54 20 00 0c 50 f5  ....CPU2CST ..P.
  0110: 79 bf 0c 85 00 00 00 0d 43 50 55 33 43 53 54 20  y.......CPU3CST 
  0120: 00 0c e0 f5 79 bf 0c 85 00 00 00 0d 43 50 55 34  ....y.......CPU4
  0130: 43 53 54 20 00 0c 00 00 00 80 0c 00 00 00 80 0d  CST ............
  0140: 43 50 55 35 43 53 54 20 00 0c 00 00 00 80 0c 00  CPU5CST ........
  0150: 00 00 80 0d 43 50 55 36 43 53 54 20 00 0c 00 00  ....CPU6CST ....
  0160: 00 80 0c 00 00 00 80 0d 43 50 55 37 43 53 54 20  ........CPU7CST 
  0170: 00 0c 00 00 00 80 0c 00 00 00 80 08 43 46 47 44  ............CFGD
  0180: 0c 72 04 20 00 08 4e 43 50 55 0c 04 00 00 00 08  .r. ..NCPU......
  0190: 4e 50 43 50 0c 01 00 00 00 08 50 44 43 30 0c 00  NPCP......PDC0..
  01a0: 00 00 80 08 50 44 43 31 0c 00 00 00 80 08 50 44  ....PDC1......PD
  01b0: 43 32 0c 00 00 00 80 08 50 44 43 33 0c 00 00 00  C2......PDC3....
  01c0: 80 08 50 44 43 34 0c 00 00 00 80 08 50 44 43 35  ..PDC4......PDC5
  01d0: 0c 00 00 00 80 08 50 44 43 36 0c 00 00 00 80 08  ......PDC6......
  01e0: 50 44 43 37 0c 00 00 00 80 08 54 42 4c 30 0a 00  PDC7......TBL0..
  01f0: 08 54 42 4c 31 0a 00 08 54 42 4c 32 0a 00 08 54  .TBL1...TBL2...T
  0200: 42 4c 33 0a 00 08 54 42 4c 34 0a 00 08 54 42 4c  BL3...TBL4...TBL
  0210: 35 0a 00 08 54 42 4c 36 0a 00 08 54 42 4c 37 0a  5...TBL6...TBL7.
  0220: 00 08 43 54 42 30 0a 00 08 43 54 42 31 0a 00 08  ..CTB0...CTB1...
  0230: 43 54 42 32 0a 00 08 43 54 42 33 0a 00 08 43 54  CTB2...CTB3...CT
  0240: 42 34 0a 00 08 43 54 42 35 0a 00 08 43 54 42 36  B4...CTB5...CTB6
  0250: 0a 00 08 43 54 42 37 0a 00 5b 80 50 4d 52 47 01  ...CTB7..[.PMRG.
  0260: 0b 00 08 0a 50 5b 81 31 50 4d 52 47 01 00 48 20  ....P[.1PMRG..H 
  0270: 44 45 56 34 01 44 45 56 35 01 44 45 56 36 01 44  DEV4.DEV5.DEV6.D
  0280: 45 56 37 01 53 54 53 34 01 53 54 53 35 01 53 54  EV7.STS4.STS5.ST
  0290: 53 36 01 53 54 53 37 01 10 4f 1f 5c 2e 5f 50 52  S6.STS7..O.\._PR
  02a0: 5f 50 30 30 31 08 48 49 30 5f 0a 00 08 48 43 30  _P001.HI0_...HC0
  02b0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  02c0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  02d0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  02e0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  02f0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0300: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0310: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0320: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0330: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0340: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0350: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0360: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0370: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0380: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0390: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  03a0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  03b0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  03c0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  03d0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  03e0: 00 00 a4 6b 7d 7b 50 44 43 30 0c ff ff ff 7f 00  ...k}{PDC0......
  03f0: 43 41 50 30 50 44 43 30 a0 4e 04 90 90 93 7b 50  CAP0PDC0.N....{P
  0400: 44 43 30 0a 09 00 0a 09 93 54 42 4c 30 00 93 7b  DC0......TBL0..{
  0410: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 30 0a 01  CFGD.....}TBL0..
  0420: 54 42 4c 30 5b 80 47 56 30 30 00 83 88 53 53 44  TBL0[.GV00...SSD
  0430: 54 0a 01 00 83 88 53 53 44 54 0a 02 00 5b 20 47  T.....SSDT...[ G
  0440: 56 30 30 48 49 30 5f a0 4e 04 90 90 93 7b 50 44  V00HI0_.N....{PD
  0450: 43 30 0a 18 00 0a 18 93 43 54 42 30 00 93 7b 43  C0......CTB0..{C
  0460: 46 47 44 0a 20 00 0a 20 7d 43 54 42 30 0a 01 43  FGD. .. }CTB0..C
  0470: 54 42 30 5b 80 43 54 30 30 00 83 88 43 53 44 54  TB0[.CT00...CSDT
  0480: 0a 01 00 83 88 43 53 44 54 0a 02 00 5b 20 43 54  .....CSDT...[ CT
  0490: 30 30 48 43 30 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  00HC0_.k.O.\._PR
  04a0: 5f 50 30 30 32 08 48 49 31 5f 0a 00 08 48 43 31  _P002.HI1_...HC1
  04b0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  04c0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  04d0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  04e0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  04f0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0500: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0510: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0520: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0530: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0540: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0550: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0560: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0570: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0580: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0590: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  05a0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  05b0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  05c0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  05d0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  05e0: 00 00 a4 6b 7d 7b 50 44 43 31 0c ff ff ff 7f 00  ...k}{PDC1......
  05f0: 43 41 50 30 50 44 43 31 a0 4e 04 90 90 93 7b 50  CAP0PDC1.N....{P
  0600: 44 43 31 0a 09 00 0a 09 93 54 42 4c 31 00 93 7b  DC1......TBL1..{
  0610: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 31 0a 01  CFGD.....}TBL1..
  0620: 54 42 4c 31 5b 80 47 56 30 31 00 83 88 53 53 44  TBL1[.GV01...SSD
  0630: 54 0a 04 00 83 88 53 53 44 54 0a 05 00 5b 20 47  T.....SSDT...[ G
  0640: 56 30 31 48 49 31 5f a0 4e 04 90 90 93 7b 50 44  V01HI1_.N....{PD
  0650: 43 31 0a 18 00 0a 18 93 43 54 42 31 00 93 7b 43  C1......CTB1..{C
  0660: 46 47 44 0a 20 00 0a 20 7d 43 54 42 31 0a 01 43  FGD. .. }CTB1..C
  0670: 54 42 31 5b 80 43 54 30 31 00 83 88 43 53 44 54  TB1[.CT01...CSDT
  0680: 0a 04 00 83 88 43 53 44 54 0a 05 00 5b 20 43 54  .....CSDT...[ CT
  0690: 30 31 48 43 31 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  01HC1_.k.O.\._PR
  06a0: 5f 50 30 30 33 08 48 49 32 5f 0a 00 08 48 43 32  _P003.HI2_...HC2
  06b0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  06c0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  06d0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  06e0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  06f0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0700: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0710: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0720: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0730: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0740: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0750: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0760: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0770: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0780: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0790: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  07a0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  07b0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  07c0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  07d0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  07e0: 00 00 a4 6b 7d 7b 50 44 43 32 0c ff ff ff 7f 00  ...k}{PDC2......
  07f0: 43 41 50 30 50 44 43 32 a0 4e 04 90 90 93 7b 50  CAP0PDC2.N....{P
  0800: 44 43 32 0a 09 00 0a 09 93 54 42 4c 32 00 93 7b  DC2......TBL2..{
  0810: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 32 0a 01  CFGD.....}TBL2..
  0820: 54 42 4c 32 5b 80 47 56 30 32 00 83 88 53 53 44  TBL2[.GV02...SSD
  0830: 54 0a 07 00 83 88 53 53 44 54 0a 08 00 5b 20 47  T.....SSDT...[ G
  0840: 56 30 32 48 49 32 5f a0 4e 04 90 90 93 7b 50 44  V02HI2_.N....{PD
  0850: 43 32 0a 18 00 0a 18 93 43 54 42 32 00 93 7b 43  C2......CTB2..{C
  0860: 46 47 44 0a 20 00 0a 20 7d 43 54 42 32 0a 01 43  FGD. .. }CTB2..C
  0870: 54 42 32 5b 80 43 54 30 32 00 83 88 43 53 44 54  TB2[.CT02...CSDT
  0880: 0a 07 00 83 88 43 53 44 54 0a 08 00 5b 20 43 54  .....CSDT...[ CT
  0890: 30 32 48 43 32 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  02HC2_.k.O.\._PR
  08a0: 5f 50 30 30 34 08 48 49 33 5f 0a 00 08 48 43 33  _P004.HI3_...HC3
  08b0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  08c0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  08d0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  08e0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  08f0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0900: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0910: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0920: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0930: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0940: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0950: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0960: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0970: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0980: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0990: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  09a0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  09b0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  09c0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  09d0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  09e0: 00 00 a4 6b 7d 7b 50 44 43 33 0c ff ff ff 7f 00  ...k}{PDC3......
  09f0: 43 41 50 30 50 44 43 33 a0 4e 04 90 90 93 7b 50  CAP0PDC3.N....{P
  0a00: 44 43 33 0a 09 00 0a 09 93 54 42 4c 33 00 93 7b  DC3......TBL3..{
  0a10: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 33 0a 01  CFGD.....}TBL3..
  0a20: 54 42 4c 33 5b 80 47 56 30 33 00 83 88 53 53 44  TBL3[.GV03...SSD
  0a30: 54 0a 0a 00 83 88 53 53 44 54 0a 0b 00 5b 20 47  T.....SSDT...[ G
  0a40: 56 30 33 48 49 33 5f a0 4e 04 90 90 93 7b 50 44  V03HI3_.N....{PD
  0a50: 43 33 0a 18 00 0a 18 93 43 54 42 33 00 93 7b 43  C3......CTB3..{C
  0a60: 46 47 44 0a 20 00 0a 20 7d 43 54 42 33 0a 01 43  FGD. .. }CTB3..C
  0a70: 54 42 33 5b 80 43 54 30 33 00 83 88 43 53 44 54  TB3[.CT03...CSDT
  0a80: 0a 0a 00 83 88 43 53 44 54 0a 0b 00 5b 20 43 54  .....CSDT...[ CT
  0a90: 30 33 48 43 33 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  03HC3_.k.O.\._PR
  0aa0: 5f 50 30 30 35 08 48 49 34 5f 0a 00 08 48 43 34  _P005.HI4_...HC4
  0ab0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  0ac0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  0ad0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  0ae0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  0af0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0b00: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0b10: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0b20: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0b30: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0b40: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0b50: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0b60: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0b70: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0b80: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0b90: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  0ba0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  0bb0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  0bc0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  0bd0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  0be0: 00 00 a4 6b 7d 7b 50 44 43 34 0c ff ff ff 7f 00  ...k}{PDC4......
  0bf0: 43 41 50 30 50 44 43 34 a0 4e 04 90 90 93 7b 50  CAP0PDC4.N....{P
  0c00: 44 43 34 0a 09 00 0a 09 93 54 42 4c 34 00 93 7b  DC4......TBL4..{
  0c10: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 34 0a 01  CFGD.....}TBL4..
  0c20: 54 42 4c 34 5b 80 47 56 30 34 00 83 88 53 53 44  TBL4[.GV04...SSD
  0c30: 54 0a 0d 00 83 88 53 53 44 54 0a 0e 00 5b 20 47  T.....SSDT...[ G
  0c40: 56 30 34 48 49 34 5f a0 4e 04 90 90 93 7b 50 44  V04HI4_.N....{PD
  0c50: 43 34 0a 18 00 0a 18 93 43 54 42 34 00 93 7b 43  C4......CTB4..{C
  0c60: 46 47 44 0a 20 00 0a 20 7d 43 54 42 34 0a 01 43  FGD. .. }CTB4..C
  0c70: 54 42 34 5b 80 43 54 30 34 00 83 88 43 53 44 54  TB4[.CT04...CSDT
  0c80: 0a 0d 00 83 88 43 53 44 54 0a 0e 00 5b 20 43 54  .....CSDT...[ CT
  0c90: 30 34 48 43 34 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  04HC4_.k.O.\._PR
  0ca0: 5f 50 30 30 36 08 48 49 35 5f 0a 00 08 48 43 35  _P006.HI5_...HC5
  0cb0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  0cc0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  0cd0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  0ce0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  0cf0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0d00: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0d10: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0d20: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0d30: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0d40: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0d50: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0d60: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0d70: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0d80: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0d90: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  0da0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  0db0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  0dc0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  0dd0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  0de0: 00 00 a4 6b 7d 7b 50 44 43 35 0c ff ff ff 7f 00  ...k}{PDC5......
  0df0: 43 41 50 30 50 44 43 35 a0 4e 04 90 90 93 7b 50  CAP0PDC5.N....{P
  0e00: 44 43 35 0a 09 00 0a 09 93 54 42 4c 35 00 93 7b  DC5......TBL5..{
  0e10: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 35 0a 01  CFGD.....}TBL5..
  0e20: 54 42 4c 35 5b 80 47 56 30 35 00 83 88 53 53 44  TBL5[.GV05...SSD
  0e30: 54 0a 10 00 83 88 53 53 44 54 0a 11 00 5b 20 47  T.....SSDT...[ G
  0e40: 56 30 35 48 49 35 5f a0 4e 04 90 90 93 7b 50 44  V05HI5_.N....{PD
  0e50: 43 35 0a 18 00 0a 18 93 43 54 42 35 00 93 7b 43  C5......CTB5..{C
  0e60: 46 47 44 0a 20 00 0a 20 7d 43 54 42 35 0a 01 43  FGD. .. }CTB5..C
  0e70: 54 42 35 5b 80 43 54 30 35 00 83 88 43 53 44 54  TB5[.CT05...CSDT
  0e80: 0a 10 00 83 88 43 53 44 54 0a 11 00 5b 20 43 54  .....CSDT...[ CT
  0e90: 30 35 48 43 35 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  05HC5_.k.O.\._PR
  0ea0: 5f 50 30 30 37 08 48 49 36 5f 0a 00 08 48 43 36  _P007.HI6_...HC6
  0eb0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  0ec0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  0ed0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  0ee0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  0ef0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  0f00: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  0f10: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  0f20: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  0f30: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  0f40: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  0f50: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  0f60: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  0f70: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  0f80: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  0f90: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  0fa0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  0fb0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  0fc0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  0fd0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  0fe0: 00 00 a4 6b 7d 7b 50 44 43 36 0c ff ff ff 7f 00  ...k}{PDC6......
  0ff0: 43 41 50 30 50 44 43 36 a0 4e 04 90 90 93 7b 50  CAP0PDC6.N....{P
  1000: 44 43 36 0a 09 00 0a 09 93 54 42 4c 36 00 93 7b  DC6......TBL6..{
  1010: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 36 0a 01  CFGD.....}TBL6..
  1020: 54 42 4c 36 5b 80 47 56 30 36 00 83 88 53 53 44  TBL6[.GV06...SSD
  1030: 54 0a 13 00 83 88 53 53 44 54 0a 14 00 5b 20 47  T.....SSDT...[ G
  1040: 56 30 36 48 49 36 5f a0 4e 04 90 90 93 7b 50 44  V06HI6_.N....{PD
  1050: 43 36 0a 18 00 0a 18 93 43 54 42 36 00 93 7b 43  C6......CTB6..{C
  1060: 46 47 44 0a 20 00 0a 20 7d 43 54 42 36 0a 01 43  FGD. .. }CTB6..C
  1070: 54 42 36 5b 80 43 54 30 36 00 83 88 43 53 44 54  TB6[.CT06...CSDT
  1080: 0a 13 00 83 88 43 53 44 54 0a 14 00 5b 20 43 54  .....CSDT...[ CT
  1090: 30 36 48 43 36 5f a4 6b 10 4f 1f 5c 2e 5f 50 52  06HC6_.k.O.\._PR
  10a0: 5f 50 30 30 38 08 48 49 37 5f 0a 00 08 48 43 37  _P008.HI7_...HC7
  10b0: 5f 0a 00 14 48 06 5f 50 44 43 01 8a 68 0a 00 52  _...H._PDC..h..R
  10c0: 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70  EVS.h..SIZEp.h`p
  10d0: 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00  t`...a[.h.@wa...
  10e0: 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00  TEMP.STS0.......
  10f0: 00 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11  .sSTS0TEMPb_OSC.
  1100: 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58  .....w@.).G...pX
  1110: 71 39 53 52 45 56 53 53 49 5a 45 62 14 4b 17 5f  q9SREVSSIZEb.K._
  1120: 4f 53 43 04 8a 6b 0a 00 53 54 53 30 8a 6b 0a 04  OSC..k..STS0.k..
  1130: 43 41 50 30 8a 68 0a 00 49 49 44 30 8a 68 0a 04  CAP0.h..IID0.h..
  1140: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  1150: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  1160: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  1170: 44 30 0a 00 45 49 44 30 8a 55 49 44 30 0a 04 45  D0..EID0.UID0..E
  1180: 49 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55  ID1.UID0..EID2.U
  1190: 49 44 30 0a 0c 45 49 44 33 a0 36 92 90 90 93 49  ID0..EID3.6....I
  11a0: 49 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31  ID0EID0.IID1EID1
  11b0: 90 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45  ..IID2EID2.IID3E
  11c0: 49 44 33 70 0a 06 88 53 54 53 30 0a 00 00 a4 6b  ID3p...STS0....k
  11d0: a0 13 92 93 69 0a 01 70 0a 0a 88 53 54 53 30 0a  ....i..p...STS0.
  11e0: 00 00 a4 6b 7d 7b 50 44 43 37 0c ff ff ff 7f 00  ...k}{PDC7......
  11f0: 43 41 50 30 50 44 43 37 a0 4e 04 90 90 93 7b 50  CAP0PDC7.N....{P
  1200: 44 43 37 0a 09 00 0a 09 93 54 42 4c 37 00 93 7b  DC7......TBL7..{
  1210: 43 46 47 44 0a 02 00 0a 02 7d 54 42 4c 37 0a 01  CFGD.....}TBL7..
  1220: 54 42 4c 37 5b 80 47 56 30 37 00 83 88 53 53 44  TBL7[.GV07...SSD
  1230: 54 0a 16 00 83 88 53 53 44 54 0a 17 00 5b 20 47  T.....SSDT...[ G
  1240: 56 30 37 48 49 37 5f a0 4e 04 90 90 93 7b 50 44  V07HI7_.N....{PD
  1250: 43 37 0a 18 00 0a 18 93 43 54 42 37 00 93 7b 43  C7......CTB7..{C
  1260: 46 47 44 0a 20 00 0a 20 7d 43 54 42 37 0a 01 43  FGD. .. }CTB7..C
  1270: 54 42 37 5b 80 43 54 30 37 00 83 88 43 53 44 54  TB7[.CT07...CSDT
  1280: 0a 16 00 83 88 43 53 44 54 0a 17 00 5b 20 43 54  .....CSDT...[ CT
  1290: 30 37 48 43 37 5f a4 6b                          07HC7_.k

RSDT @ 0xbf790000
  0000: 52 53 44 54 44 00 00 00 01 75 44 45 4c 4c 20 20  RSDTD....uDELL  
  0010: 46 58 30 39 20 20 20 00 15 04 09 20 4d 53 46 54  FX09   .... MSFT
  0020: 97 00 00 00 00 02 79 bf 90 03 79 bf 20 04 79 bf  ......y...y. .y.
  0030: 60 04 79 bf e0 05 79 bf 40 e0 79 bf 60 86 79 bf  `.y...y.@.y.`.y.
  0040: 70 f6 79 bf                                      p.y.

RSD PTR @ 0xf9ce0
  0000: 52 53 44 20 50 54 52 20 fe 41 43 50 49 41 4d 00  RSD PTR .ACPIAM.
  0010: 00 00 79 bf                                      ..y.


--CE+1k2dSO48ffgeK--
