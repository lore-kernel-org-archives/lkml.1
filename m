Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYDZR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYDZR2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYDZR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:28:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:21269 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYDZR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BVOWvGcNkdMyz/dlL25ntpLHFAJumx0tL0CQ7I3kuIM0iunTCGAgj9k6kjOJDXmPqT00/f4l6Z7LbIqXxBEflBIVP8vCmQh5j3FUo8bpGAR5Xo8ZbyQgo7I0H0Oe2+MnQHgiOmExMgKMYkN8+H7EQfN/+ytGjGV3biH6G96ds7c=
Message-ID: <4813660E.8080609@googlemail.com>
Date: Sat, 26 Apr 2008 19:27:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
References: <48133A64.7020702@googlemail.com>
In-Reply-To: <48133A64.7020702@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi all,
> 
> On an kernel ( tested 2.6.25 , linux-next and latest -git ) with DMAR enabled my box won't boot unless I disable it with intel_iommu=off.
> 
> It hangs very early on boot and not even the reset button works anymore , all I get is an black screen , no message or alike and the box hangs.
> Also it does not make any difference when enabling / disabling  DMAR_GFX_WA.
> 
> I would like to debug the problem but I have no idea on how to do it.
> 
> Also this box has an ASUS P5E-VM DO motherboard , latest BIOS , Q9300 Quad CPU and 4G RAM.
> 
> lspci :
> 
> 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
> 00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
> 00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
> 00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
> 00:1f.6 Signal processing controller: Intel Corporation Thermal Subsystem (rev 02)
> 
> 
> dmesg:
> 
> [    0.000000] Linux version 2.6.25-05096-gb1721d0-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #783 SMP PREEMPT Sat Apr 26 14:00:11 CEST 2008
> [    0.000000] Command line: root=/dev/sdb1 ro debug vga=792 apic=verbose intel_iommu=off
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
> [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
> [    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
> [    0.000000] max_pfn_mapped = 1228800
> [    0.000000] x86: PAT support disabled.
> [    0.000000] init_memory_mapping
> [    0.000000] DMI 2.4 present.
> [    0.000000] ACPI: RSDP 000F9A80, 0024 (r2 ACPIAM)
> [    0.000000] ACPI: XSDT CF550100, 0064 (r1 A_M_I_ OEMXSDT   3000820 MSFT       97)
> [    0.000000] ACPI: FACP CF550290, 00F4 (r3 A_M_I_ OEMFACP   3000820 MSFT       97)
> [    0.000000] ACPI: DSDT CF5505C0, 843B (r1  A0869 A0869001        1 INTL 20060113)
> [    0.000000] ACPI: FACS CF55E000, 0040
> [    0.000000] ACPI: APIC CF550390, 006C (r1 A_M_I_ OEMAPIC   3000820 MSFT       97)
> [    0.000000] ACPI: MCFG CF550400, 003C (r1 A_M_I_ OEMMCFG   3000820 MSFT       97)
> [    0.000000] ACPI: OEMB CF55E040, 0081 (r1 A_M_I_ AMI_OEM   3000820 MSFT       97)
> [    0.000000] ACPI: HPET CF558A00, 0038 (r1 A_M_I_ OEMHPET   3000820 MSFT       97)
> [    0.000000] ACPI: GSCI CF55E0D0, 2024 (r1 A_M_I_ GMCHSCI   3000820 MSFT       97)
> [    0.000000] ACPI: iEIT CF560100, 00B0 (r1 A_M_I_ EITTABLE  3000820 MSFT       97)
> [    0.000000] ACPI: DMAR CF5601B0, 0158 (r1    AMI  OEMDMAR        1 MSFT       97)
> [    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
> [    0.000000] early res: 0 [0-fff] BIOS data page
> [    0.000000] early res: 1 [6000-7fff] TRAMPOLINE
> [    0.000000] early res: 2 [200000-ae5233] TEXT DATA BSS
> [    0.000000] early res: 3 [9ec00-fffff] BIOS reserved
> [    0.000000] early res: 4 [8000-dfff] PGTABLE
> [    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
> [    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
> [    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
> [    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
> [    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
> [    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
> [    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
> [    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
> [    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
> [    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
> [    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
> [    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
> [    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff81000c200000 on node 0
> [    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff81000c600000 on node 0
> [    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff81000ca00000 on node 0
> [    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff81000ce00000 on node 0
> [    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff81000d200000 on node 0
> [    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff81000d600000 on node 0
> [    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff81000da00000 on node 0
> [    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff81000de00000 on node 0
> [    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff81000e200000 on node 0
> [    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff81000e600000 on node 0
> [    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff81000ea00000 on node 0
> [    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff81000ee00000 on node 0
> [    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff81000f200000 on node 0
> [    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff81000f600000 on node 0
> [    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff81000fa00000 on node 0
> [    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff81000fe00000 on node 0
> [    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810010200000 on node 0
> [    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810010600000 on node 0
> [    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810010a00000 on node 0
> [    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810010e00000 on node 0
> [    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810011200000 on node 0
> [    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810011600000 on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1228800
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0:        0 ->      158
> [    0.000000]     0:      256 ->   849232
> [    0.000000]     0:  1048576 ->  1228800
> [    0.000000] On node 0 totalpages: 1029358
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 2385 pages reserved
> [    0.000000]   DMA zone: 1557 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 830856 pages, LIFO batch:31
> [    0.000000]   Normal zone: 2464 pages used for memmap
> [    0.000000]   Normal zone: 177760 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
> [    0.000000] mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000cf550000 - 00000000cf55e000
> [    0.000000] PM: Registered nosave memory: 00000000cf55e000 - 00000000cf5e0000
> [    0.000000] PM: Registered nosave memory: 00000000cf5e0000 - 00000000cf600000
> [    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
> [    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 43908 bytes of per cpu data
> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010173
> [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=792 apic=verbose intel_iommu=off
> [    0.000000] Intel-IOMMU: disabled
> [    0.000000] Initializing CPU#0
> [    0.000000] Preemptible RCU implementation.
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] TSC calibrated against PM_TIMER
> [    0.000016] time.c: Detected 2499.955 MHz processor.
> [    0.000030] Console: colour dummy device 80x25
> [    0.000032] console [tty0] enabled
> [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000999] Checking aperture...
> [    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.000999] Placing software IO TLB between 0x4000000 - 0x8000000
> [    0.000999] Memory: 3965308k/4915200k available (3646k kernel code, 151404k reserved, 1709k data, 324k init)
> [    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
> [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
> [    0.000999] hpet clockevent registered
> [    0.059992] Calibrating delay using timer specific routine.. 5002.55 BogoMIPS (lpj=2501279)
> [    0.060020] Security Framework initialized
> [    0.060031] Capability LSM initialized
> [    0.060040] Mount-cache hash table entries: 256
> [    0.060148] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.060155] CPU: L2 cache: 3072K
> [    0.060160] CPU: Physical Processor ID: 0
> [    0.060164] CPU: Processor Core ID: 0
> [    0.060173] CPU0: Thermal monitoring enabled (TM2)
> [    0.060178] using mwait in idle threads.
> [    0.060846] ACPI: Core revision 20070126
> [    0.070021] enabled ExtINT on CPU#0
> [    0.071092] ENABLING IO-APIC IRQs
> [    0.071095] init IO_APIC IRQs
> [    0.071099]  IO-APIC (apicid-pin) 4-0 not connected.
> [    0.071107] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
> [    0.071117] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
> [    0.071126] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
> [    0.071135] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
> [    0.071144] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
> [    0.071153] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
> [    0.071162] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
> [    0.071171] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
> [    0.071180] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
> [    0.071189] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
> [    0.071198] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
> [    0.071207] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
> [    0.071216] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
> [    0.071225] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
> [    0.071234] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
> [    0.071242]  IO-APIC (apicid-pin) 4-16, 4-17, 4-18, 4-19, 4-20, 4-21, 4-22, 4-23 not connected.
> [    0.071405] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.081423] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.081431] Using local APIC timer interrupts.
> [    0.081988] APIC timer calibration result 12657227
> [    0.081993] Detected 12.657 MHz APIC timer.
> [    0.082069] Booting processor 1/1 ip 6000
> [    0.082069] Initializing CPU#1
> [    0.082069] masked ExtINT on CPU#1
> [    0.082069] Calibrating delay using timer specific routine.. 3037.71 BogoMIPS (lpj=1518859)
> [    0.082069] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.082069] CPU: L2 cache: 3072K
> [    0.082069] CPU: Physical Processor ID: 0
> [    0.082069] CPU: Processor Core ID: 1
> [    0.082069] CPU1: Thermal monitoring enabled (TM2)
> [    0.082069] x86: PAT support disabled.
> [    0.161305] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.161363] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.162043] Booting processor 2/2 ip 6000
> [    0.162043] Initializing CPU#2
> [    0.162043] masked ExtINT on CPU#2
> [    0.162043] Calibrating delay using timer specific routine.. 3037.74 BogoMIPS (lpj=1518871)
> [    0.162043] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.162043] CPU: L2 cache: 3072K
> [    0.162043] CPU: Physical Processor ID: 0
> [    0.162043] CPU: Processor Core ID: 2
> [    0.162043] CPU2: Thermal monitoring enabled (TM2)
> [    0.162043] x86: PAT support disabled.
> [    0.241240] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.241299] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> [    0.242012] Booting processor 3/3 ip 6000
> [    0.242012] Initializing CPU#3
> [    0.242012] masked ExtINT on CPU#3
> [    0.242012] Calibrating delay using timer specific routine.. 3037.74 BogoMIPS (lpj=1518870)
> [    0.242012] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.242012] CPU: L2 cache: 3072K
> [    0.242012] CPU: Physical Processor ID: 0
> [    0.242012] CPU: Processor Core ID: 3
> [    0.242012] CPU3: Thermal monitoring enabled (TM2)
> [    0.242012] x86: PAT support disabled.
> [    0.321257] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.321316] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> [    0.321958] Brought up 4 CPUs
> [    0.321963] Total of 4 processors activated (14115.75 BogoMIPS).
> [    0.323016] net_namespace: 960 bytes
> [    0.323023] Booting paravirtualized kernel on bare hardware
> [    0.323194] xor: automatically using best checksumming function: generic_sse
> [    0.327951]    generic_sse:  5620.000 MB/sec
> [    0.327955] xor: using function: generic_sse (5620.000 MB/sec)
> [    0.327978] NET: Registered protocol family 16
> [    0.328206] No dock devices found.
> [    0.328331] ACPI: bus type pci registered
> [    0.328422] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> [    0.328430] PCI: Not using MMCONFIG.
> [    0.328435] PCI: Using configuration type 1
> [    0.335991] ACPI: EC: Look up EC in DSDT
> [    0.346074] ACPI: Interpreter enabled
> [    0.346084] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.346102] ACPI: Using IOAPIC for interrupt routing
> [    0.360431] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.361963] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    0.361973] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
> [    0.362157] PCI: Transparent bridge - 0000:00:1e.0
> [    0.362175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.362320] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.391015] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.391146] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.391266] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [    0.391392] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.391509] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.392022] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.392139] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.392256] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
> [    0.392463] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  D2, should be CD [20070126]
> [    0.393981] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    0.394029] pnp: PnP ACPI init
> [    0.394038] ACPI: bus type pnp registered
> [    0.394404] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
> [    0.394517] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
> [    0.396280] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
> [    0.398429] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
> [    0.399115] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
> [    0.399276] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
> [    0.400950] pnp: PnP ACPI: found 16 devices
> [    0.400956] ACPI: ACPI bus type pnp unregistered
> [    0.401196] SCSI subsystem initialized
> [    0.401295] libata version 3.00 loaded.
> [    0.401481] usbcore: registered new interface driver usbfs
> [    0.401520] usbcore: registered new interface driver hub
> [    0.401983] usbcore: registered new device driver usb
> [    0.402292] PCI: Using ACPI for IRQ routing
> [    0.402299] number of MP IRQ sources: 15.
> [    0.402305] number of IO-APIC #4 registers: 24.
> [    0.402310] testing the IO APIC.......................
> [    0.402320] 
> [    0.402323] IO APIC #4......
> [    0.402327] .... register #00: 04000000
> [    0.402332] .......    : physical APIC id: 04
> [    0.402338] .... register #01: 00170020
> [    0.402343] .......     : max redirection entries: 0017
> [    0.402349] .......     : PRQ implemented: 0
> [    0.402354] .......     : IO APIC version: 0020
> [    0.402360] .... register #02: 00170020
> [    0.402365] .......     : arbitration: 00
> [    0.402370] .... IRQ redirection table:
> [    0.402375]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
> [    0.402385]  00 000 1    0    0   0   0    0    0    00
> [    0.402395]  01 00F 0    0    0   0   0    1    1    31
> [    0.402405]  02 00F 0    0    0   0   0    1    1    30
> [    0.402418]  03 00F 0    0    0   0   0    1    1    33
> [    0.402426]  04 00F 0    0    0   0   0    1    1    34
> [    0.402434]  05 00F 0    0    0   0   0    1    1    35
> [    0.402442]  06 00F 0    0    0   0   0    1    1    36
> [    0.402449]  07 00F 0    0    0   0   0    1    1    37
> [    0.402457]  08 00F 0    0    0   0   0    1    1    38
> [    0.402465]  09 00F 0    1    0   0   0    1    1    39
> [    0.402473]  0a 00F 0    0    0   0   0    1    1    3A
> [    0.402480]  0b 00F 0    0    0   0   0    1    1    3B
> [    0.402488]  0c 00F 0    0    0   0   0    1    1    3C
> [    0.402496]  0d 00F 0    0    0   0   0    1    1    3D
> [    0.402503]  0e 00F 0    0    0   0   0    1    1    3E
> [    0.402511]  0f 00F 0    0    0   0   0    1    1    3F
> [    0.402519]  10 000 1    0    0   0   0    0    0    00
> [    0.402527]  11 000 1    0    0   0   0    0    0    00
> [    0.402535]  12 000 1    0    0   0   0    0    0    00
> [    0.402542]  13 000 1    0    0   0   0    0    0    00
> [    0.402945]  14 000 1    0    0   0   0    0    0    00
> [    0.402953]  15 000 1    0    0   0   0    0    0    00
> [    0.402961]  16 000 1    0    0   0   0    0    0    00
> [    0.402969]  17 010 1    0    0   0   0    0    2    75
> [    0.402974] IRQ to pin mappings:
> [    0.402978] IRQ0 -> 0:2
> [    0.402982] IRQ1 -> 0:1
> [    0.402985] IRQ3 -> 0:3
> [    0.402989] IRQ4 -> 0:4
> [    0.402992] IRQ5 -> 0:5
> [    0.402996] IRQ6 -> 0:6
> [    0.402999] IRQ7 -> 0:7
> [    0.403003] IRQ8 -> 0:8
> [    0.403006] IRQ9 -> 0:9
> [    0.403010] IRQ10 -> 0:10
> [    0.403014] IRQ11 -> 0:11
> [    0.403017] IRQ12 -> 0:12
> [    0.403021] IRQ13 -> 0:13
> [    0.403025] IRQ14 -> 0:14
> [    0.403028] IRQ15 -> 0:15
> [    0.403033] .................................... done.
> [    0.410952] PCI-GART: No AMD northbridge found.
> [    0.410961] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.410971] hpet0: 4 64-bit timers, 14318180 Hz
> [    0.411954] ACPI: RTC can wake from S4
> [    0.423951] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [    0.423965] system 00:07: ioport range 0x290-0x297 has been reserved
> [    0.423976] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    0.423984] system 00:08: ioport range 0x800-0x87f has been reserved
> [    0.423992] system 00:08: ioport range 0x480-0x4bf has been reserved
> [    0.424000] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.424009] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.424017] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
> [    0.424025] system 00:08: iomem range 0xfed08000-0xfed08fff has been reserved
> [    0.424039] system 00:08: iomem range 0xff800000-0xffbfffff has been reserved
> [    0.424046] system 00:08: iomem range 0xffe80000-0xffefffff could not be reserved
> [    0.424054] system 00:08: iomem range 0xffc00000-0xffffffff could not be reserved
> [    0.424064] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
> [    0.424071] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
> [    0.424081] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.424090] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
> [    0.424096] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
> [    0.424102] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
> [    0.424109] system 00:0f: iomem range 0x100000-0xcf5fffff could not be reserved
> [    0.424116] system 00:0f: iomem range 0x0-0x0 could not be reserved
> [    0.425060] PCI: Bridge: 0000:00:1e.0
> [    0.425066]   IO window: disabled.
> [    0.425073]   MEM window: disabled.
> [    0.425079]   PREFETCH window: disabled.
> [    0.425095] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [    0.425124] NET: Registered protocol family 2
> [    0.457968] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.458237] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    0.460391] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.461206] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.461213] TCP reno registered
> [    0.473021] NET: Registered protocol family 1
> [    0.473021] audit: initializing netlink socket (disabled)
> [    0.473039] type=2000 audit(1209218717.450:1): initialized
> [    0.478960] async_tx: api initialized (async)
> [    0.479002] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.479013] io scheduler noop registered
> [    0.479018] io scheduler anticipatory registered
> [    0.479024] io scheduler deadline registered
> [    0.479094] io scheduler cfq registered (default)
> [    0.479112] pci 0000:00:02.0: Boot video device
> [    0.480124] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 6144k, total 8128k
> [    0.480134] vesafb: mode is 1024x768x32, linelength=4096, pages=1
> [    0.480140] vesafb: scrolling: redraw
> [    0.480145] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.480145] Switched to high resolution mode on CPU 2
> [    0.483012] Switched to high resolution mode on CPU 1
> [    0.497852] Switched to high resolution mode on CPU 3
> [    0.500926] Switched to high resolution mode on CPU 0
> [    0.500926] Console: switching to colour frame buffer device 128x48
> [    0.500926] fb0: VESA VGA frame buffer device
> [    0.522669] hpet_resources: 0xfed00000 is busy
> [    0.522972] Linux agpgart interface v0.103
> [    0.523133] agpgart: Detected an Intel Q35 Chipset.
> [    0.524253] agpgart: Detected 6140K stolen memory.
> [    0.536746] agpgart: AGP aperture is 256M @ 0xd0000000
> [    0.537017] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
> [    0.537407] intelfb: Version 0.9.4
> [    0.537583] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> [    0.537975] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.539001] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.540175] brd: module loaded
> [    0.540396] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
> [    0.540626] e1000e: Copyright (c) 1999-2008 Intel Corporation.
> [    0.540877] IOAPIC[0]: Set routing entry (4-20 -> 0x49 -> IRQ 20 Mode:1 Active:1)
> [    0.541164] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
> [    0.541631] PCI: Setting latency timer of device 0000:00:19.0 to 64
> [    0.716280] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:8c:7b:c8:bc
> [    0.716508] eth0: Intel(R) PRO/1000 Network Connection
> [    0.720673] eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
> [    0.725022] Fixed MDIO Bus: probed
> [    0.729744] Driver 'sd' needs updating - please use bus_type methods
> [    0.734446] ahci 0000:00:1f.2: version 3.0
> [    0.739181] IOAPIC[0]: Set routing entry (4-22 -> 0x51 -> IRQ 22 Mode:1 Active:1)
> [    0.744227] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 22
> [    1.749065] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> [    1.754458] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
> [    1.760149] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    1.766173] scsi0 : ahci
> [    1.772142] scsi1 : ahci
> [    1.778194] scsi2 : ahci
> [    1.784250] scsi3 : ahci
> [    1.790327] scsi4 : ahci
> [    1.796418] scsi5 : ahci
> [    1.802586] ata1: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79900 irq 511
> [    1.808999] ata2: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79980 irq 511
> [    1.815436] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 511
> [    1.822094] ata4: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79a80 irq 511
> [    1.828894] ata5: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79b00 irq 511
> [    1.835704] ata6: SATA max UDMA/133 abar m2048@0xfeb79800 port 0xfeb79b80 irq 511
> [    2.283675] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.295775] ata1.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    2.302705] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.315006] ata1.00: configured for UDMA/133
> [    2.778939] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.791414] ata2.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    2.798815] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.811499] ata2.00: configured for UDMA/133
> [    3.692582] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.700915] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100, ATAPI AN
> [    3.709706] ata3.00: configured for UDMA/100
> [    4.021092] ata4: SATA link down (SStatus 0 SControl 300)
> [    4.485402] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.498458] ata5.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
> [    4.506017] ata5.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.519852] ata5.00: configured for UDMA/133
> [    4.830888] ata6: SATA link down (SStatus 0 SControl 300)
> [    4.852884] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    4.860616] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [    4.868287] sd 0:0:0:0: [sda] Write Protect is off
> [    4.875868] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.883434] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.891147] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [    4.898765] sd 0:0:0:0: [sda] Write Protect is off
> [    4.906229] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.913623] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.921196]  sda: sda1 sda2 sda3 sda4
> [    4.936233] sd 0:0:0:0: [sda] Attached SCSI disk
> [    4.943831] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    4.951443] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    4.959194] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
> [    4.966829] sd 1:0:0:0: [sdb] Write Protect is off
> [    4.974287] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    4.981604] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.989103] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
> [    4.996499] sd 1:0:0:0: [sdb] Write Protect is off
> [    5.003780] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    5.011166] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.018885]  sdb: sdb1 sdb2 sdb3 sdb4
> [    5.040209] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    5.048288] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    5.057072] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  SB00 PQ: 0 ANSI: 5
> [    5.065408] scsi 2:0:0:0: Attached scsi generic sg2 type 5
> [    5.073786] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
> [    5.082274] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [    5.090649] sd 4:0:0:0: [sdc] Write Protect is off
> [    5.099081] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    5.107585] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.116286] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> [    5.124928] sd 4:0:0:0: [sdc] Write Protect is off
> [    5.133481] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    5.141897] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    5.150476]  sdc: sdc1 sdc2 sdc3 sdc4
> [    5.179004] sd 4:0:0:0: [sdc] Attached SCSI disk
> [    5.187672] sd 4:0:0:0: Attached scsi generic sg3 type 0
> [    5.197420] IOAPIC[0]: Set routing entry (4-18 -> 0x61 -> IRQ 18 Mode:1 Active:1)
> [    5.206078] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
> [    5.215549] PCI: Setting latency timer of device 0000:00:1a.7 to 64
> [    5.224190] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    5.232902] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    5.246238] ehci_hcd 0000:00:1a.7: debug port 1
> [    5.254826] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
> [    5.263572] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfeb7b800
> [    5.281838] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    5.290536] usb usb1: configuration #1 chosen from 1 choice
> [    5.299321] hub 1-0:1.0: USB hub found
> [    5.307908] hub 1-0:1.0: 6 ports detected
> [    5.416701] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.425312] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.433889] usb usb1: Product: EHCI Host Controller
> [    5.442318] usb usb1: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
> [    5.450889] usb usb1: SerialNumber: 0000:00:1a.7
> [    5.459455] IOAPIC[0]: Set routing entry (4-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
> [    5.468112] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [    5.476751] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    5.485426] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    5.494198] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    5.506971] ehci_hcd 0000:00:1d.7: debug port 1
> [    5.515520] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> [    5.524220] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfeb7b400
> [    5.606010] usb 1-4: new high speed USB device using ehci_hcd and address 2
> [    5.631722] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    5.640508] usb usb2: configuration #1 chosen from 1 choice
> [    5.649378] hub 2-0:1.0: USB hub found
> [    5.658209] hub 2-0:1.0: 6 ports detected
> [    5.733115] usb 1-4: configuration #1 chosen from 1 choice
> [    5.735694] usb 1-4: New USB device found, idVendor=1307, idProduct=0163
> [    5.744526] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    5.767345] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.767347] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.767348] usb usb2: Product: EHCI Host Controller
> [    5.767349] usb usb2: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
> [    5.767350] usb usb2: SerialNumber: 0000:00:1d.7
> [    5.767388] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.767436] USB Universal Host Controller Interface driver v3.0
> [    5.767459] IOAPIC[0]: Set routing entry (4-16 -> 0x71 -> IRQ 16 Mode:1 Active:1)
> [    5.767461] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    5.767466] PCI: Setting latency timer of device 0000:00:1a.0 to 64
> [    5.767468] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    5.767510] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    5.767531] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e400
> [    5.767649] usb usb3: configuration #1 chosen from 1 choice
> [    5.768329] hub 3-0:1.0: USB hub found
> [    5.768333] hub 3-0:1.0: 2 ports detected
> [    5.868821] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.868822] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.868824] usb usb3: Product: UHCI Host Controller
> [    5.868825] usb usb3: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    5.868826] usb usb3: SerialNumber: 0000:00:1a.0
> [    5.868843] IOAPIC[0]: Set routing entry (4-21 -> 0x79 -> IRQ 21 Mode:1 Active:1)
> [    5.868844] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
> [    5.868848] PCI: Setting latency timer of device 0000:00:1a.1 to 64
> [    5.868850] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    5.868892] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    5.868921] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e480
> [    5.869034] usb usb4: configuration #1 chosen from 1 choice
> [    5.869073] hub 4-0:1.0: USB hub found
> [    5.869077] hub 4-0:1.0: 2 ports detected
> [    5.969670] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.969672] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.969673] usb usb4: Product: UHCI Host Controller
> [    5.969674] usb usb4: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    5.969675] usb usb4: SerialNumber: 0000:00:1a.1
> [    5.969692] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    5.969696] PCI: Setting latency timer of device 0000:00:1a.2 to 64
> [    5.969698] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    5.969737] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    5.969758] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e800
> [    5.969886] usb usb5: configuration #1 chosen from 1 choice
> [    5.969925] hub 5-0:1.0: USB hub found
> [    5.969929] hub 5-0:1.0: 2 ports detected
> [    6.070519] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.070521] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.070522] usb usb5: Product: UHCI Host Controller
> [    6.070523] usb usb5: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.070524] usb usb5: SerialNumber: 0000:00:1a.2
> [    6.070541] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [    6.070545] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    6.070547] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    6.070589] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    6.070608] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
> [    6.070728] usb usb6: configuration #1 chosen from 1 choice
> [    6.070767] hub 6-0:1.0: USB hub found
> [    6.070771] hub 6-0:1.0: 2 ports detected
> [    6.171372] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.171374] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.171375] usb usb6: Product: UHCI Host Controller
> [    6.171376] usb usb6: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.171377] usb usb6: SerialNumber: 0000:00:1d.0
> [    6.171394] IOAPIC[0]: Set routing entry (4-19 -> 0x81 -> IRQ 19 Mode:1 Active:1)
> [    6.171395] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [    6.171399] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    6.171401] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    6.171443] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    6.171471] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e000
> [    6.171586] usb usb7: configuration #1 chosen from 1 choice
> [    6.171624] hub 7-0:1.0: USB hub found
> [    6.171628] hub 7-0:1.0: 2 ports detected
> [    6.272221] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.272222] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.272223] usb usb7: Product: UHCI Host Controller
> [    6.272224] usb usb7: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.272225] usb usb7: SerialNumber: 0000:00:1d.1
> [    6.272241] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    6.272245] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    6.272247] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    6.272287] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    6.272308] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e080
> [    6.272434] usb usb8: configuration #1 chosen from 1 choice
> [    6.272473] hub 8-0:1.0: USB hub found
> [    6.272477] hub 8-0:1.0: 2 ports detected
> [    6.373073] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.373074] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.373076] usb usb8: Product: UHCI Host Controller
> [    6.373077] usb usb8: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
> [    6.373078] usb usb8: SerialNumber: 0000:00:1d.2
> [    6.373120] Initializing USB Mass Storage driver...
> [    6.492410] usb 1-4: Product: USB Mass Storage Device
> [    6.500328] usb 1-4: Manufacturer: USBest Technology
> [    6.508172] usb 1-4: SerialNumber: 08021600009235
> [    6.538622] scsi6 : SCSI emulation for USB Mass Storage devices
> [    6.538622] usb-storage: device found at 2
> [    6.546180] usb-storage: waiting for device to settle before scanning
> [    6.669962] hub 2-0:1.0: unable to enumerate USB device on port 5
> [    6.986483] usb 8-1: new low speed USB device using uhci_hcd and address 2
> [    7.174035] usb 8-1: configuration #1 chosen from 1 choice
> [    7.199052] usb 8-1: New USB device found, idVendor=099a, idProduct=7202
> [    7.206910] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.214775] usb 8-1: Product: WirelessUSB
> [    7.222546] usb 8-1: Manufacturer: Cypress
> [    7.230318] usbcore: registered new interface driver usb-storage
> [    7.238233] USB Mass Storage support registered.
> [    7.246149] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    7.256548] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    7.264509] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    7.272440] mice: PS/2 mouse device common for all mice
> [    7.333311] I2O subsystem v1.325
> [    7.340923] i2o: max drivers = 8
> [    7.348627] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    7.356167] rtc0: alarms up to one month, y3k
> [    7.363629] i2c /dev entries driver
> [    7.371091] md: linear personality registered for level -1
> [    7.378571] md: raid0 personality registered for level 0
> [    7.386014] md: raid1 personality registered for level 1
> [    7.393335] md: raid10 personality registered for level 10
> [    7.417647] raid6: int64x1   2347 MB/s
> [    7.441676] raid6: int64x2   3046 MB/s
> [    7.466612] raid6: int64x4   2867 MB/s
> [    7.490407] raid6: int64x8   2125 MB/s
> [    7.515105] raid6: sse2x1    4226 MB/s
> [    7.538635] raid6: sse2x2    4988 MB/s
> [    7.561998] raid6: sse2x4    7089 MB/s
> [    7.568314] raid6: using algorithm sse2x4 (7089 MB/s)
> [    7.574619] md: raid6 personality registered for level 6
> [    7.580950] md: raid5 personality registered for level 5
> [    7.587168] md: raid4 personality registered for level 4
> [    7.593255] md: multipath personality registered for level -4
> [    7.599528] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> [    7.606116] cpuidle: using governor ladder
> [    7.612573] cpuidle: using governor menu
> [    7.619003] Advanced Linux Sound Architecture Driver Version 1.0.16.
> [    7.625517] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    7.632052] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    7.648100] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> [    7.679592] ALSA device list:
> [    7.686231]   #0: HDA Intel at 0xfeb70000 irq 22
> [    7.693119] IPv4 over IPv4 tunneling driver
> [    7.699999] GRE over IPv4 tunneling driver
> [    7.706836] TCP cubic registered
> [    7.713381] TCP hybla registered
> [    7.719821] NET: Registered protocol family 17
> [    7.726339] registered taskstats version 1
> [    7.732728] rtc_cmos 00:03: setting system clock to 2008-04-26 14:05:24 UTC (1209218724)
> [    7.739238] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
> [    7.746084] md: Autodetecting RAID arrays.
> [    7.894964] md: Scanned 11 and added 11 devices.
> [    7.901175] md: autorun ...
> [    7.907471] md: considering sdc4 ...
> [    7.913706] md:  adding sdc4 ...
> [    7.919826] md: sdc3 has different UUID to sdc4
> [    7.925884] md: sdc2 has different UUID to sdc4
> [    7.931724] md: sdc1 has different UUID to sdc4
> [    7.937554] md:  adding sdb4 ...
> [    7.943299] md: sdb3 has different UUID to sdc4
> [    7.949056] md: sdb2 has different UUID to sdc4
> [    7.954759] md:  adding sda4 ...
> [    7.960338] md: sda3 has different UUID to sdc4
> [    7.965918] md: sda2 has different UUID to sdc4
> [    7.971379] md: sda1 has different UUID to sdc4
> [    7.976796] md: created md3
> [    7.982095] md: bind<sda4>
> [    7.987407] md: bind<sdb4>
> [    7.992617] md: bind<sdc4>
> [    7.997678] md: running: <sdc4><sdb4><sda4>
> [    8.002963] md3: setting max_sectors to 128, segment boundary to 32767
> [    8.008373] raid0: looking at sdc4
> [    8.013834] raid0:   comparing sdc4(1028096) with sdc4(1028096)
> [    8.019494] raid0:   END
> [    8.025124] raid0:   ==> UNIQUE
> [    8.030788] raid0: 1 zones
> [    8.036317] raid0: looking at sdb4
> [    8.041798] raid0:   comparing sdb4(1028096) with sdc4(1028096)
> [    8.047489] raid0:   EQUAL
> [    8.053169] raid0: looking at sda4
> [    8.058791] raid0:   comparing sda4(1028096) with sdc4(1028096)
> [    8.064385] raid0:   EQUAL
> [    8.069762] raid0: FINAL 1 zones
> [    8.075154] raid0: done.
> [    8.080424] raid0 : md_size is 3084288 blocks.
> [    8.085646] raid0 : conf->hash_spacing is 3084288 blocks.
> [    8.090798] raid0 : nb_zone is 1.
> [    8.095784] raid0 : Allocating 8 bytes for hash.
> [    8.100738] md: considering sdc3 ...
> [    8.105691] md:  adding sdc3 ...
> [    8.110570] md: sdc2 has different UUID to sdc3
> [    8.115482] md: sdc1 has different UUID to sdc3
> [    8.120301] md:  adding sdb3 ...
> [    8.125157] md: sdb2 has different UUID to sdc3
> [    8.130009] md:  adding sda3 ...
> [    8.134795] md: sda2 has different UUID to sdc3
> [    8.139482] md: sda1 has different UUID to sdc3
> [    8.144015] md: created md2
> [    8.148434] md: bind<sda3>
> [    8.152777] md: bind<sdb3>
> [    8.157017] md: bind<sdc3>
> [    8.161199] md: running: <sdc3><sdb3><sda3>
> [    8.165550] md2: setting max_sectors to 128, segment boundary to 32767
> [    8.169992] raid0: looking at sdc3
> [    8.174464] raid0:   comparing sdc3(111330368) with sdc3(111330368)
> [    8.179201] raid0:   END
> [    8.183857] raid0:   ==> UNIQUE
> [    8.188470] raid0: 1 zones
> [    8.193044] raid0: looking at sdb3
> [    8.197613] raid0:   comparing sdb3(111330368) with sdc3(111330368)
> [    8.202337] raid0:   EQUAL
> [    8.207070] raid0: looking at sda3
> [    8.211869] raid0:   comparing sda3(111330368) with sdc3(111330368)
> [    8.216839] raid0:   EQUAL
> [    8.221768] raid0: FINAL 1 zones
> [    8.226753] raid0: done.
> [    8.231742] raid0 : md_size is 333991104 blocks.
> [    8.236816] raid0 : conf->hash_spacing is 333991104 blocks.
> [    8.241873] raid0 : nb_zone is 1.
> [    8.246802] raid0 : Allocating 8 bytes for hash.
> [    8.251755] md: considering sdc2 ...
> [    8.256704] md:  adding sdc2 ...
> [    8.261637] md: sdc1 has different UUID to sdc2
> [    8.266669] md:  adding sdb2 ...
> [    8.271692] md:  adding sda2 ...
> [    8.276587] md: sda1 has different UUID to sdc2
> [    8.281504] md: created md1
> [    8.286402] md: bind<sda2>
> [    8.291175] md: bind<sdb2>
> [    8.295830] md: bind<sdc2>
> [    8.300453] md: running: <sdc2><sdb2><sda2>
> [    8.305244] md1: setting max_sectors to 128, segment boundary to 32767
> [    8.310148] raid0: looking at sdc2
> [    8.314969] raid0:   comparing sdc2(97659008) with sdc2(97659008)
> [    8.319931] raid0:   END
> [    8.324807] raid0:   ==> UNIQUE
> [    8.329587] raid0: 1 zones
> [    8.334310] raid0: looking at sdb2
> [    8.339005] raid0:   comparing sdb2(97659008) with sdc2(97659008)
> [    8.343937] raid0:   EQUAL
> [    8.348793] raid0: looking at sda2
> [    8.353633] raid0:   comparing sda2(97659008) with sdc2(97659008)
> [    8.359469] raid0:   EQUAL
> [    8.364378] raid0: FINAL 1 zones
> [    8.369340] raid0: done.
> [    8.374220] raid0 : md_size is 292977024 blocks.
> [    8.379234] raid0 : conf->hash_spacing is 292977024 blocks.
> [    8.384390] raid0 : nb_zone is 1.
> [    8.389579] raid0 : Allocating 8 bytes for hash.
> [    8.394856] md: considering sdc1 ...
> [    8.400078] md:  adding sdc1 ...
> [    8.405161] md:  adding sda1 ...
> [    8.410102] md: created md0
> [    8.414928] md: bind<sda1>
> [    8.419762] md: bind<sdc1>
> [    8.424511] md: running: <sdc1><sda1>
> [    8.429420] raid1: raid set md0 active with 2 out of 2 mirrors
> [    8.434407] md: ... autorun DONE.
> [    8.464802] kjournald starting.  Commit interval 5 seconds
> [    8.464802] EXT3-fs: mounted filesystem with ordered data mode.
> [    8.464816] VFS: Mounted root (ext3 filesystem) readonly.
> [    8.464829] Freeing unused kernel memory: 324k freed
> [    9.220219] EXT3 FS on sdb1, internal journal
> [    9.657772] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
> [    9.691809] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    9.695838] ACPI: Power Button (FF) [PWRF]
> [    9.695912] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    9.701916] ACPI: Power Button (CM) [PWRB]
> [    9.709034] Driver 'sr' needs updating - please use bus_type methods
> [    9.741273] parport_pc 00:06: reported by Plug and Play ACPI
> [    9.741381] parport0: PC-style at 0x378 (0x778), irq 7sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    9.741381] Uniform CD-ROM driver Revision: 3.20
> [    9.741438] sr 2:0:0:0: Attached scsi CD-ROM sr0
> [    9.741800] , dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
> [    9.786795] usbcore: registered new interface driver hiddev
> [    9.799191] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input2
> [    9.805029] input,hidraw0: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1d.2-1
> [    9.838543] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input3
> [    9.850076] input,hiddev0,hidraw1: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1d.2-1
> [    9.850093] usbcore: registered new interface driver usbhid
> [    9.850096] usbhid: v2.6:USB HID core driver
> [    9.931519] ppdev: user-space parallel port driver
> [   11.257191] EXT3 FS on sdb1, internal journal
> [   11.564421] usb-storage: device scan complete
> [   11.564421] scsi 6:0:0:0: Direct-Access     Ut163    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
> [   11.572932] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors (1011 MB)
> [   11.580614] sd 6:0:0:0: [sdd] Write Protect is off
> [   11.587640] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
> [   11.587645] sd 6:0:0:0: [sdd] Assuming drive cache: write through
> [   11.598270] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors (1011 MB)
> [   11.606383] sd 6:0:0:0: [sdd] Write Protect is off
> [   11.613424] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
> [   11.613426] sd 6:0:0:0: [sdd] Assuming drive cache: write through
> [   11.620547]  sdd: sdd1
> [   11.721531] sd 6:0:0:0: [sdd] Attached SCSI removable disk
> [   11.728267] sd 6:0:0:0: Attached scsi generic sg4 type 0
> [   11.967797] lp0: using parport0 (interrupt-driven).
> [   11.967800] lp0: console ready
> [   11.980677] loop: module loaded
> [   12.722321] kjournald starting.  Commit interval 5 seconds
> [   12.722321] EXT3 FS on md1, internal journal
> [   12.722330] EXT3-fs: mounted filesystem with ordered data mode.
> [   12.756835] kjournald starting.  Commit interval 5 seconds
> [   12.756974] EXT3 FS on md2, internal journal
> [   12.756980] EXT3-fs: mounted filesystem with ordered data mode.
> [   12.891495] Adding 3084280k swap on /dev/md3.  Priority:-1 extents:1 across:3084280k
> [   16.212658] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> [   16.212660] eth0: 10/100 speed: disabling TSO
> [   19.580143] eth0: changing MTU from 1500 to 1492
> [   21.006209] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> [   21.006214] eth0: 10/100 speed: disabling TSO
> [   24.002041] [drm] Initialized drm 1.1.0 20060810
> [   24.011746] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   24.011754] PCI: Setting latency timer of device 0000:00:02.0 to 64
> [   24.012694] [drm] Initialized i915 1.6.0 20060119 on minor 0
> [   24.175500] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [   24.423740] set status page addr 0x00033000
> 
> 
> dsdt.dsl can be found there :
> 
> http://frugalware.org/~crazy/ASUS_P5E-VM_DO/dsdt.dsl
> 
> Please let me know if you need more infos.


Got more infos on that.

After poking a lot around I found out the boot problem occurs when I have *any* usb devices inserted on boot ( really does not matter which ).

Removing these on boot ( mouse , keyboard and an 1G stick ) made it boot but I got an OOps on loading the parport_pc modules and box died :/

After blacklisting parport_pc box was up. Strange thing is now I can insert my USB devices and everything is working.

The OOPs is reproducible with modprobe too. 

New dmesg output : 
...


[    0.000000] Linux version 2.6.25-05096-gb1721d0-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #793 SMP PREEMPT Sat Apr 26 18:07:59 CEST 2008
[    0.000000] Command line: root=/dev/sdb1 ro debug vga=792 3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
[    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
[    0.000000] max_pfn_mapped = 1228800
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F9A80, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT CF550100, 0064 (r1 A_M_I_ OEMXSDT   3000820 MSFT       97)
[    0.000000] ACPI: FACP CF550290, 00F4 (r3 A_M_I_ OEMFACP   3000820 MSFT       97)
[    0.000000] ACPI: DSDT CF5505C0, 843B (r1  A0869 A0869001        1 INTL 20060113)
[    0.000000] ACPI: FACS CF55E000, 0040
[    0.000000] ACPI: APIC CF550390, 006C (r1 A_M_I_ OEMAPIC   3000820 MSFT       97)
[    0.000000] ACPI: MCFG CF550400, 003C (r1 A_M_I_ OEMMCFG   3000820 MSFT       97)
[    0.000000] ACPI: OEMB CF55E040, 0081 (r1 A_M_I_ AMI_OEM   3000820 MSFT       97)
[    0.000000] ACPI: HPET CF558A00, 0038 (r1 A_M_I_ OEMHPET   3000820 MSFT       97)
[    0.000000] ACPI: GSCI CF55E0D0, 2024 (r1 A_M_I_ GMCHSCI   3000820 MSFT       97)
[    0.000000] ACPI: iEIT CF560100, 00B0 (r1 A_M_I_ EITTABLE  3000820 MSFT       97)
[    0.000000] ACPI: DMAR CF5601B0, 0168 (r1    AMI  OEMDMAR        1 MSFT       97)
[    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000] early res: 2 [200000-8c2533] TEXT DATA BSS
[    0.000000] early res: 3 [9cc00-fffff] BIOS reserved
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff81000c200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff81000c600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff81000ca00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff81000ce00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff81000d200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff81000d600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff81000da00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff81000de00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff81000e200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff81000e600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff81000ea00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff81000ee00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff81000f200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff81000f600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff81000fa00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff81000fe00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810010200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810010600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810010a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810010e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810011200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810011600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1228800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      156
[    0.000000]     0:      256 ->   849232
[    0.000000]     0:  1048576 ->  1228800
[    0.000000] On node 0 totalpages: 1029356
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1840 pages reserved
[    0.000000]   DMA zone: 2100 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 830856 pages, LIFO batch:31
[    0.000000]   Normal zone: 2464 pages used for memmap
[    0.000000]   Normal zone: 177760 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cf550000 - 00000000cf55e000
[    0.000000] PM: Registered nosave memory: 00000000cf55e000 - 00000000cf5e0000
[    0.000000] PM: Registered nosave memory: 00000000cf5e0000 - 00000000cf600000
[    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 43908 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010716
[    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=792 3
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000016] time.c: Detected 2499.949 MHz processor.
[    0.000030] Console: colour dummy device 80x25
[    0.000032] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000999] Checking aperture...
[    0.000999] Memory: 4033444k/4915200k available (3595k kernel code, 83264k reserved, 1637k data, 292k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[    0.000999] hpet clockevent registered
[    0.059992] Calibrating delay using timer specific routine.. 5002.53 BogoMIPS (lpj=2501266)
[    0.060021] Security Framework initialized
[    0.060032] Capability LSM initialized
[    0.060041] Mount-cache hash table entries: 256
[    0.060147] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.060154] CPU: L2 cache: 3072K
[    0.060159] CPU: Physical Processor ID: 0
[    0.060163] CPU: Processor Core ID: 0
[    0.060171] CPU0: Thermal monitoring enabled (TM2)
[    0.060176] using mwait in idle threads.
[    0.060191] ACPI: Core revision 20070126
[    0.081250] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.081259] Using local APIC timer interrupts.
[    0.081988] APIC timer calibration result 20832892
[    0.081993] Detected 20.832 MHz APIC timer.
[    0.082066] Booting processor 1/1 ip 6000
[    0.082066] Initializing CPU#1
[    0.082066] Calibrating delay using timer specific routine.. 4999.71 BogoMIPS (lpj=2499858)
[    0.082066] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.082066] CPU: L2 cache: 3072K
[    0.082066] CPU: Physical Processor ID: 0
[    0.082066] CPU: Processor Core ID: 1
[    0.082066] CPU1: Thermal monitoring enabled (TM2)
[    0.082066] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.154136] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.154193] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.155042] Booting processor 2/2 ip 6000
[    0.155042] Initializing CPU#2
[    0.155042] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499867)
[    0.155042] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.155042] CPU: L2 cache: 3072K
[    0.155042] CPU: Physical Processor ID: 0
[    0.155042] CPU: Processor Core ID: 2
[    0.155042] CPU2: Thermal monitoring enabled (TM2)
[    0.155042] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.227150] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.227206] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.228014] Booting processor 3/3 ip 6000
[    0.228014] Initializing CPU#3
[    0.228014] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499869)
[    0.228014] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.228014] CPU: L2 cache: 3072K
[    0.228014] CPU: Physical Processor ID: 0
[    0.228014] CPU: Processor Core ID: 3
[    0.228014] CPU3: Thermal monitoring enabled (TM2)
[    0.228014] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.300145] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.300199] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.300961] Brought up 4 CPUs
[    0.300966] Total of 4 processors activated (20001.72 BogoMIPS).
[    0.301291] net_namespace: 960 bytes
[    0.301424] xor: automatically using best checksumming function: generic_sse
[    0.305954]    generic_sse:  9264.000 MB/sec
[    0.305959] xor: using function: generic_sse (9264.000 MB/sec)
[    0.305983] NET: Registered protocol family 16
[    0.306205] No dock devices found.
[    0.306325] ACPI: bus type pci registered
[    0.306414] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.306422] PCI: Not using MMCONFIG.
[    0.306427] PCI: Using configuration type 1
[    0.310700] ACPI: EC: Look up EC in DSDT
[    0.316785] ACPI: Interpreter enabled
[    0.316795] ACPI: (supports S0 S1 S3 S4 S5)
[    0.316813] ACPI: Using IOAPIC for interrupt routing
[    0.325015] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.325916] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.325925] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.326109] PCI: Transparent bridge - 0000:00:1e.0
[    0.326127] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.326271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.343978] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.344106] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.344220] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.344334] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.344450] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.344563] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.344676] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.344789] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.344979] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  E2, should be DD [20070126]
[    0.344996] Overlap at 0xcf550000-0xcf559000
[    0.345656] Overlap at 0xcf55e000-0xcf561000
[    0.345677] Overlap at 0xcf55e000-0xcf561000
[    0.345711] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.345757] pnp: PnP ACPI init
[    0.345766] ACPI: bus type pnp registered
[    0.349698] pnp: PnP ACPI: found 15 devices
[    0.349703] ACPI: ACPI bus type pnp unregistered
[    0.349942] SCSI subsystem initialized
[    0.350036] libata version 3.00 loaded.
[    0.350236] usbcore: registered new interface driver usbfs
[    0.350277] usbcore: registered new interface driver hub
[    0.350344] usbcore: registered new device driver usb
[    0.350619] PCI: Using ACPI for IRQ routing
[    0.357951] DMAR:Host address width 36
[    0.357958] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
[    0.357967] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
[    0.357976] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed92000
[    0.357986] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
[    0.357994] DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
[    0.358011] DMAR:RMRR base: 0x00000000cf600000 end: 0x00000000cfffffff
[    0.358020] DMAR:RMRR base: 0x00000000cf5e0000 end: 0x00000000cf5effff
[    0.358078] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcf5e0000 - 0xcf5f0000]
[    0.358107] IOMMU: Setting identity map for device 0000:00:1d.1 [0xcf5e0000 - 0xcf5f0000]
[    0.358129] IOMMU: Setting identity map for device 0000:00:1d.2 [0xcf5e0000 - 0xcf5f0000]
[    0.358151] IOMMU: Setting identity map for device 0000:00:1d.7 [0xcf5e0000 - 0xcf5f0000]
[    0.358176] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcf5e0000 - 0xcf5f0000]
[    0.358198] IOMMU: Setting identity map for device 0000:00:1a.1 [0xcf5e0000 - 0xcf5f0000]
[    0.358232] IOMMU: Setting identity map for device 0000:00:1a.2 [0xcf5e0000 - 0xcf5f0000]
[    0.358260] IOMMU: Setting identity map for device 0000:00:1a.7 [0xcf5e0000 - 0xcf5f0000]
[    0.358284] IOMMU: Setting identity map for device 0000:00:02.0 [0xcf600000 - 0xd0000000]
[    0.358842] IOMMU: Setting identity map for device 0000:00:1d.0 [0xed000 - 0xf0000]
[    0.358856] IOMMU: Setting identity map for device 0000:00:1d.1 [0xed000 - 0xf0000]
[    0.358869] IOMMU: Setting identity map for device 0000:00:1d.2 [0xed000 - 0xf0000]
[    0.358883] IOMMU: Setting identity map for device 0000:00:1d.7 [0xed000 - 0xf0000]
[    0.358900] IOMMU: Setting identity map for device 0000:00:1a.0 [0xed000 - 0xf0000]
[    0.358913] IOMMU: Setting identity map for device 0000:00:1a.1 [0xed000 - 0xf0000]
[    0.358926] IOMMU: Setting identity map for device 0000:00:1a.2 [0xed000 - 0xf0000]
[    0.358939] IOMMU: Setting identity map for device 0000:00:1a.7 [0xed000 - 0xf0000]
[    0.358954] IOMMU: gfx device 0000:00:02.0 1-1 mapping
[    0.358959] IOMMU: Setting identity map for device 0000:00:02.0 [0x0 - 0x9cc00]
[    0.359005] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000 - 0xcf550000]
[    0.542673] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000000 - 0x12c000000]
[    0.581575] IOMMU: Prepare 0-16M unity mapping for LPC
[    0.581583] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    0.581583] DMAR:[DMA Write] Request device [00:02.0] fault addr ffffff000 
[    0.581584] DMAR:[fault reason 05] PTE Write access is not set
[    0.582922] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.582937] PCI-GART: No AMD northbridge found.
[    0.582946] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.582954] hpet0: 4 64-bit timers, 14318180 Hz
[    0.583956] ACPI: RTC can wake from S4
[    0.584915] Switched to high resolution mode on CPU 0
[    0.584915] Switched to high resolution mode on CPU 1
[    0.584915] Switched to high resolution mode on CPU 2
[    0.584915] Switched to high resolution mode on CPU 3
[    0.595930] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.595947] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.595958] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.595966] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.595974] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.595982] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.595990] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.595998] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.596007] system 00:08: iomem range 0xfed08000-0xfed08fff has been reserved
[    0.596019] system 00:08: iomem range 0xff800000-0xffbfffff has been reserved
[    0.596026] system 00:08: iomem range 0xffe80000-0xffefffff could not be reserved
[    0.596033] system 00:08: iomem range 0xffc00000-0xffffffff could not be reserved
[    0.596045] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.596052] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.596063] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.596073] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.596079] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.596085] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.596092] system 00:0e: iomem range 0x100000-0xcf5fffff could not be reserved
[    0.596099] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.596712] PCI: Bridge: 0000:00:1e.0
[    0.596717]   IO window: disabled.
[    0.596724]   MEM window: disabled.
[    0.596730]   PREFETCH window: disabled.
[    0.596762] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.596776] NET: Registered protocol family 2
[    0.628946] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.629185] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.630378] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.630794] TCP: Hash tables configured (established 262144 bind 65536)
[    0.630801] TCP reno registered
[    0.641998] NET: Registered protocol family 1
[    0.642237] audit: initializing netlink socket (disabled)
[    0.642253] type=2000 audit(1209236264.642:1): initialized
[    0.645619] async_tx: api initialized (sync-only)
[    0.645655] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.645663] io scheduler noop registered
[    0.645667] io scheduler anticipatory registered
[    0.645672] io scheduler deadline registered
[    0.645739] io scheduler cfq registered (default)
[    0.645753] pci 0000:00:02.0: Boot video device
[    0.646363] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 6144k, total 8128k
[    0.646373] vesafb: mode is 1024x768x32, linelength=4096, pages=1
[    0.646378] vesafb: scrolling: redraw
[    0.646383] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.665697] Console: switching to colour frame buffer device 128x48
[    0.684995] fb0: VESA VGA frame buffer device
[    0.708412] hpet_resources: 0xfed00000 is busy
[    0.708712] Linux agpgart interface v0.103
[    0.708890] agpgart: Detected an Intel Q35 Chipset.
[    0.709952] agpgart: Detected 6140K stolen memory.
[    0.722120] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.722393] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
[    0.722783] intelfb: Version 0.9.4
[    0.722965] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.723450] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.724446] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.724810] ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
[    0.725205] 0000:00:03.3: ttyS1 at I/O 0xe880 (irq = 17) is a 16550A
[    0.726257] brd: module loaded
[    0.726515] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
[    0.726722] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.726960] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.727253] PCI: Setting latency timer of device 0000:00:19.0 to 64
[    0.906988] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:8c:7b:c8:bc
[    0.907217] eth0: Intel(R) PRO/1000 Network Connection
[    0.907424] eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
[    0.907689] Fixed MDIO Bus: probed
[    0.908380] Driver 'sd' needs updating - please use bus_type methods
[    0.913064] ahci 0000:00:1f.2: version 3.0
[    0.917745] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 22
[    1.921983] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.927194] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
[    1.932633] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.939441] scsi0 : ahci
[    1.945166] scsi1 : ahci
[    1.950902] scsi2 : ahci
[    1.956648] scsi3 : ahci
[    1.962423] scsi4 : ahci
[    1.969172] scsi5 : ahci
[    1.975028] ata1: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78900 irq 507
[    1.981154] ata2: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78980 irq 507
[    1.987282] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 507
[    1.993615] ata4: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78a80 irq 507
[    2.000103] ata5: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78b00 irq 507
[    2.006613] ata6: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78b80 irq 507
[    2.465272] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.477249] ata1.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
[    2.484035] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.496348] ata1.00: configured for UDMA/133
[    2.960584] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.973162] ata2.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
[    2.980602] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.993366] ata2.00: configured for UDMA/133
[    3.875224] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.883533] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100, ATAPI AN
[    3.892263] ata3.00: configured for UDMA/100
[    4.203735] ata4: SATA link down (SStatus 0 SControl 300)
[    4.668043] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.681041] ata5.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
[    4.688593] ata5.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.701388] ata5.00: configured for UDMA/133
[    5.012533] ata6: SATA link down (SStatus 0 SControl 300)
[    5.026550] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
[    5.034190] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    5.041731] sd 0:0:0:0: [sda] Write Protect is off
[    5.049125] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.056469] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.064037] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    5.071593] sd 0:0:0:0: [sda] Write Protect is off
[    5.078991] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.086284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.093729]  sda: sda1 sda2 sda3 sda4
[    5.109261] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.116755] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.124275] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
[    5.131914] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[    5.139481] sd 1:0:0:0: [sdb] Write Protect is off
[    5.146878] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.154145] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.161586] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[    5.168927] sd 1:0:0:0: [sdb] Write Protect is off
[    5.176171] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.183491] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.191142]  sdb: sdb1 sdb2 sdb3 sdb4
[    5.207529] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.215466] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.224095] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  SB00 PQ: 0 ANSI: 5
[    5.233283] scsi 2:0:0:0: Attached scsi generic sg2 type 5
[    5.241496] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
[    5.249830] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[    5.258063] sd 4:0:0:0: [sdc] Write Protect is off
[    5.266307] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.274643] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.283175] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[    5.291656] sd 4:0:0:0: [sdc] Write Protect is off
[    5.300041] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.308364] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.316872]  sdc: sdc1 sdc2 sdc3 sdc4
[    5.329321] sd 4:0:0:0: [sdc] Attached SCSI disk
[    5.337821] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    5.346459] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    5.354952] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    5.363371] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.371815] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.384553] ehci_hcd 0000:00:1a.7: debug port 1
[    5.392909] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    5.401420] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfeb7a800
[    5.419532] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.428169] usb usb1: configuration #1 chosen from 1 choice
[    5.436771] hub 1-0:1.0: USB hub found
[    5.445188] hub 1-0:1.0: 6 ports detected
[    5.553394] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.561795] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.570259] usb usb1: Product: EHCI Host Controller
[    5.578624] usb usb1: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
[    5.587022] usb usb1: SerialNumber: 0000:00:1a.7
[    5.595361] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    5.603933] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.612451] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.620905] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.634171] ehci_hcd 0000:00:1d.7: debug port 1
[    5.642618] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.651162] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfeb7a400
[    5.669260] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.677841] usb usb2: configuration #1 chosen from 1 choice
[    5.686499] hub 2-0:1.0: USB hub found
[    5.694975] hub 2-0:1.0: 6 ports detected
[    5.804123] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.812583] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.821099] usb usb2: Product: EHCI Host Controller
[    5.829519] usb usb2: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
[    5.837935] usb usb2: SerialNumber: 0000:00:1d.7
[    5.846361] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.855016] USB Universal Host Controller Interface driver v3.0
[    5.863608] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    5.872261] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    5.880888] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.889497] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.898170] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d480
[    5.906922] usb usb3: configuration #1 chosen from 1 choice
[    5.915537] hub 3-0:1.0: USB hub found
[    5.923981] hub 3-0:1.0: 2 ports detected
[    6.032781] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.041340] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.049832] usb usb3: Product: UHCI Host Controller
[    6.058175] usb usb3: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    6.066662] usb usb3: SerialNumber: 0000:00:1a.0
[    6.075153] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[    6.083721] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    6.092251] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.100775] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.109378] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[    6.118942] usb usb4: configuration #1 chosen from 1 choice
[    6.127440] hub 4-0:1.0: USB hub found
[    6.135779] hub 4-0:1.0: 2 ports detected
[    6.244388] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.252719] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.261050] usb usb4: Product: UHCI Host Controller
[    6.269423] usb usb4: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    6.277871] usb usb4: SerialNumber: 0000:00:1a.1
[    6.286262] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
[    6.294776] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[    6.303261] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.311776] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.320296] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000d880
[    6.328784] usb usb5: configuration #1 chosen from 1 choice
[    6.337144] hub 5-0:1.0: USB hub found
[    6.345412] hub 5-0:1.0: 2 ports detected
[    6.454076] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.462363] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.470580] usb usb5: Product: UHCI Host Controller
[    6.478758] usb usb5: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    6.486985] usb usb5: SerialNumber: 0000:00:1a.2
[    6.495169] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    6.504374] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    6.512755] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.521194] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.529656] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d000
[    6.539050] usb usb6: configuration #1 chosen from 1 choice
[    6.547401] hub 6-0:1.0: USB hub found
[    6.555583] hub 6-0:1.0: 2 ports detected
[    6.663491] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.671587] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.679624] usb usb6: Product: UHCI Host Controller
[    6.687566] usb usb6: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    6.695657] usb usb6: SerialNumber: 0000:00:1d.0
[    6.703692] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    6.712692] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    6.720875] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.729186] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.738513] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
[    6.746864] usb usb7: configuration #1 chosen from 1 choice
[    6.755116] hub 7-0:1.0: USB hub found
[    6.763222] hub 7-0:1.0: 2 ports detected
[    6.871985] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.880083] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.888108] usb usb7: Product: UHCI Host Controller
[    6.896042] usb usb7: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    6.904124] usb usb7: SerialNumber: 0000:00:1d.1
[    6.912159] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    6.921133] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    6.929322] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.937625] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.945949] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d400
[    6.954302] usb usb8: configuration #1 chosen from 1 choice
[    6.962572] hub 8-0:1.0: USB hub found
[    6.970670] hub 8-0:1.0: 2 ports detected
[    7.078487] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    7.086571] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.094589] usb usb8: Product: UHCI Host Controller
[    7.102520] usb usb8: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
[    7.110583] usb usb8: SerialNumber: 0000:00:1d.2
[    7.118638] Initializing USB Mass Storage driver...
[    7.126700] usbcore: registered new interface driver usb-storage
[    7.134788] USB Mass Storage support registered.
[    7.142992] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    7.151158] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    7.160874] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.169270] mice: PS/2 mouse device common for all mice
[    7.199187] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    7.214816] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    7.223295] rtc0: alarms up to one month, y3k
[    7.232650] i2c /dev entries driver
[    7.240966] md: linear personality registered for level -1
[    7.249291] md: raid0 personality registered for level 0
[    7.257598] md: raid1 personality registered for level 1
[    7.265769] md: raid10 personality registered for level 10
[    7.290934] raid6: int64x1   2371 MB/s
[    7.316129] raid6: int64x2   3050 MB/s
[    7.341158] raid6: int64x4   2882 MB/s
[    7.367086] raid6: int64x8   2132 MB/s
[    7.392838] raid6: sse2x1    4207 MB/s
[    7.417456] raid6: sse2x2    4937 MB/s
[    7.441924] raid6: sse2x4    7121 MB/s
[    7.449228] raid6: using algorithm sse2x4 (7121 MB/s)
[    7.456479] md: raid6 personality registered for level 6
[    7.463714] md: raid5 personality registered for level 5
[    7.470863] md: raid4 personality registered for level 4
[    7.477856] md: multipath personality registered for level -4
[    7.485997] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    7.493236] cpuidle: using governor ladder
[    7.500466] cpuidle: using governor menu
[    7.507609] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    7.515867] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    7.523151] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    7.540879] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    7.573201] ALSA device list:
[    7.580378]   #0: HDA Intel at 0xfeb70000 irq 22
[    7.587717] IPv4 over IPv4 tunneling driver
[    7.594942] GRE over IPv4 tunneling driver
[    7.602163] TCP cubic registered
[    7.609114] TCP hybla registered
[    7.615931] NET: Registered protocol family 17
[    7.622895] registered taskstats version 1
[    7.629863] rtc_cmos 00:03: setting system clock to 2008-04-26 18:57:52 UTC (1209236272)
[    7.636911] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    7.644301] md: Autodetecting RAID arrays.
[    7.756832] md: Scanned 11 and added 11 devices.
[    7.763699] md: autorun ...
[    7.770408] md: considering sdc4 ...
[    7.777086] md:  adding sdc4 ...
[    7.783647] md: sdc3 has different UUID to sdc4
[    7.790195] md: sdc2 has different UUID to sdc4
[    7.796591] md: sdc1 has different UUID to sdc4
[    7.802752] md:  adding sdb4 ...
[    7.808689] md: sdb3 has different UUID to sdc4
[    7.814636] md: sdb2 has different UUID to sdc4
[    7.820350] md:  adding sda4 ...
[    7.825845] md: sda3 has different UUID to sdc4
[    7.831331] md: sda2 has different UUID to sdc4
[    7.836721] md: sda1 has different UUID to sdc4
[    7.842069] md: created md3
[    7.847303] md: bind<sda4>
[    7.852541] md: bind<sdb4>
[    7.857667] md: bind<sdc4>
[    7.862660] md: running: <sdc4><sdb4><sda4>
[    7.867857] md3: setting max_sectors to 128, segment boundary to 32767
[    7.873278] raid0: looking at sdc4
[    7.873280] raid0:   comparing sdc4(1028096) with sdc4(1028096)
[    7.873281] raid0:   END
[    7.873282] raid0:   ==> UNIQUE
[    7.873283] raid0: 1 zones
[    7.873284] raid0: looking at sdb4
[    7.873285] raid0:   comparing sdb4(1028096) with sdc4(1028096)
[    7.873286] raid0:   EQUAL
[    7.873287] raid0: looking at sda4
[    7.873288] raid0:   comparing sda4(1028096) with sdc4(1028096)
[    7.873289] raid0:   EQUAL
[    7.873290] raid0: FINAL 1 zones
[    7.873291] raid0: done.
[    7.873292] raid0 : md_size is 3084288 blocks.
[    7.873292] raid0 : conf->hash_spacing is 3084288 blocks.
[    7.873293] raid0 : nb_zone is 1.
[    7.873294] raid0 : Allocating 8 bytes for hash.
[    7.879825] md: considering sdc3 ...
[    7.879829] md:  adding sdc3 ...
[    7.879832] md: sdc2 has different UUID to sdc3
[    7.879834] md: sdc1 has different UUID to sdc3
[    7.879837] md:  adding sdb3 ...
[    7.879840] md: sdb2 has different UUID to sdc3
[    7.879843] md:  adding sda3 ...
[    7.879845] md: sda2 has different UUID to sdc3
[    7.879848] md: sda1 has different UUID to sdc3
[    7.879899] md: created md2
[    7.879900] md: bind<sda3>
[    7.879907] md: bind<sdb3>
[    7.879914] md: bind<sdc3>
[    7.879923] md: running: <sdc3><sdb3><sda3>
[    7.879968] md2: setting max_sectors to 128, segment boundary to 32767
[    7.879969] raid0: looking at sdc3
[    7.879970] raid0:   comparing sdc3(111330368) with sdc3(111330368)
[    7.879971] raid0:   END
[    7.879972] raid0:   ==> UNIQUE
[    7.879973] raid0: 1 zones
[    7.879973] raid0: looking at sdb3
[    7.879974] raid0:   comparing sdb3(111330368) with sdc3(111330368)
[    7.879975] raid0:   EQUAL
[    7.879976] raid0: looking at sda3
[    7.879977] raid0:   comparing sda3(111330368) with sdc3(111330368)
[    7.879978] raid0:   EQUAL
[    7.879979] raid0: FINAL 1 zones
[    7.879980] raid0: done.
[    7.879981] raid0 : md_size is 333991104 blocks.
[    7.879981] raid0 : conf->hash_spacing is 333991104 blocks.
[    7.879982] raid0 : nb_zone is 1.
[    7.879983] raid0 : Allocating 8 bytes for hash.
[    7.880016] md: considering sdc2 ...
[    7.880020] md:  adding sdc2 ...
[    7.880022] md: sdc1 has different UUID to sdc2
[    7.880025] md:  adding sdb2 ...
[    7.880029] md:  adding sda2 ...
[    7.880031] md: sda1 has different UUID to sdc2
[    7.880079] md: created md1
[    7.880081] md: bind<sda2>
[    7.880088] md: bind<sdb2>
[    7.880096] md: bind<sdc2>
[    7.880102] md: running: <sdc2><sdb2><sda2>
[    7.880139] md1: setting max_sectors to 128, segment boundary to 32767
[    7.880141] raid0: looking at sdc2
[    7.880142] raid0:   comparing sdc2(97659008) with sdc2(97659008)
[    7.880144] raid0:   END
[    7.880144] raid0:   ==> UNIQUE
[    7.880145] raid0: 1 zones
[    7.880146] raid0: looking at sdb2
[    7.880147] raid0:   comparing sdb2(97659008) with sdc2(97659008)
[    7.880149] raid0:   EQUAL
[    7.880149] raid0: looking at sda2
[    7.880151] raid0:   comparing sda2(97659008) with sdc2(97659008)
[    7.880152] raid0:   EQUAL
[    7.880153] raid0: FINAL 1 zones
[    7.880154] raid0: done.
[    7.880155] raid0 : md_size is 292977024 blocks.
[    7.880156] raid0 : conf->hash_spacing is 292977024 blocks.
[    7.880157] raid0 : nb_zone is 1.
[    7.880158] raid0 : Allocating 8 bytes for hash.
[    7.880191] md: considering sdc1 ...
[    7.880194] md:  adding sdc1 ...
[    7.880196] md:  adding sda1 ...
[    7.880197] md: created md0
[    7.880198] md: bind<sda1>
[    7.880206] md: bind<sdc1>
[    7.880211] md: running: <sdc1><sda1>
[    7.880295] raid1: raid set md0 active with 2 out of 2 mirrors
[    7.880334] md: ... autorun DONE.
[    8.317316] kjournald starting.  Commit interval 5 seconds
[    8.321797] EXT3-fs: mounted filesystem with ordered data mode.
[    8.326366] VFS: Mounted root (ext3 filesystem) readonly.
[    8.330926] Freeing unused kernel memory: 292k freed
[    9.024187] EXT3 FS on sdb1, internal journal
[    9.537581] Driver 'sr' needs updating - please use bus_type methods
[    9.547189] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    9.552624] Uniform CD-ROM driver Revision: 3.20
[    9.552673] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    9.552673] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
[    9.552673] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    9.565184] ACPI: Power Button (FF) [PWRF]
[    9.565270] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    9.578184] ACPI: Power Button (CM) [PWRB]
[    9.585244] ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 18 (level, low) -> IRQ 18
[    9.585276] PCI: Setting latency timer of device 0000:00:03.2 to 64
[    9.585287] ACPI: PCI interrupt for device 0000:00:03.2 disabled
[   11.169594] EXT3 FS on sdb1, internal journal
[   11.897997] loop: module loaded
[   12.566072] kjournald starting.  Commit interval 5 seconds
[   12.566072] EXT3 FS on md1, internal journal
[   12.566078] EXT3-fs: mounted filesystem with ordered data mode.
[   12.605071] kjournald starting.  Commit interval 5 seconds
[   12.605200] EXT3 FS on md2, internal journal
[   12.605203] EXT3-fs: mounted filesystem with ordered data mode.
[   12.741719] Adding 3084280k swap on /dev/md3.  Priority:-1 extents:1 across:3084280k
[   15.356972] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   15.356975] eth0: 10/100 speed: disabling TSO
[   18.176393] eth0: changing MTU from 1500 to 1492
[   19.684275] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   19.684279] eth0: 10/100 speed: disabling TSO
[   21.030925] fuse init (API version 7.9)
[  118.660390] ppdev: user-space parallel port driver
[  138.724111] lp: driver loaded but no devices found
[  178.888281] parport_pc 00:06: reported by Plug and Play ACPI
[  178.888385] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[  178.888968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[  178.890214] IP: [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
[  178.890214] PGD 128f5a067 PUD 1274e1067 PMD 0 
[  178.890214] Oops: 0000 [1] PREEMPT SMP 
[  178.890214] CPU 0 
[  178.890214] Modules linked in: parport_pc(+) lp ppdev parport fuse loop pata_acpi button i2c_i801 sr_mod evdev
[  178.890214] Pid: 4286, comm: modprobe Not tainted 2.6.25-05096-gb1721d0-dirty #793
[  178.890214] RIP: 0010:[<ffffffff80365eaf>]  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
[  178.890214] RSP: 0018:ffff8101274c5ab8  EFLAGS: 00010246
[  178.890214] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  178.890214] RDX: 0000000000000000 RSI: 0000000000000030 RDI: ffff81012be17f80
[  178.890214] RBP: 0000000000001000 R08: 0000000000000000 R09: ffff810128f99000
[  178.890214] R10: 0000000000000000 R11: ffffffff8036fd80 R12: 0000000000000030
[  178.890214] R13: ffff81012be17f80 R14: ffff81012be18000 R15: ffff81012be17f80
[  178.890214] FS:  00007f66267e76f0(0000) GS:ffffffff8071d000(0000) knlGS:0000000000000000
[  178.890214] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  178.890214] CR2: 0000000000000038 CR3: 0000000129719000 CR4: 00000000000006e0
[  178.890214] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  178.890214] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  178.890214] Process modprobe (pid: 4286, threadinfo ffff8101274c4000, task ffff81012a452000)
[  178.890214] Stack:  000000002700205d ffffffff8036e708 0000000000000001 ffffffff80783f40
[  178.896962]  0000000000000001 0000004400000001 000210d000000000 ffffffff806b0a28
[  178.896969]  0000000000000002 ffffffff806afd80 0000000000000000 0000000000000000
[  178.896973] Call Trace:
[  178.896976]  [<ffffffff8036e708>] ? get_domain_for_dev+0x78/0x6b0
[  178.896979]  [<ffffffff8036f077>] ? get_valid_domain_for_dev+0x17/0x150
[  178.896981]  [<ffffffff8036fc5d>] ? intel_map_single+0x3d/0x160
[  178.896982]  [<ffffffff8036fdfe>] ? intel_alloc_coherent+0x7e/0xc0
[  178.896987]  [<ffffffffa00434b9>] ? :parport_pc:parport_pc_probe_port+0x799/0xe20
[  178.896991]  [<ffffffffa0043c3f>] ? :parport_pc:parport_pc_pnp_probe+0xff/0x140
[  178.896993]  [<ffffffff803a828d>] ? pnp_device_probe+0x9d/0x130
[  178.896996]  [<ffffffff803ddcee>] ? driver_probe_device+0x9e/0x1d0
[  178.896998]  [<ffffffff803ddeab>] ? __driver_attach+0x8b/0x90
[  178.897000]  [<ffffffff803dde20>] ? __driver_attach+0x0/0x90
[  178.897002]  [<ffffffff803dd48b>] ? bus_for_each_dev+0x5b/0x80
[  178.897005]  [<ffffffff802a4267>] ? kmem_cache_alloc+0x67/0xa0
[  178.897007]  [<ffffffff803dcd58>] ? bus_add_driver+0x208/0x280
[  178.897008]  [<ffffffff803de04f>] ? driver_register+0x3f/0x100
[  178.897011]  [<ffffffffa004e648>] ? :parport_pc:parport_pc_init+0x5a3/0x5ba
[  178.897014]  [<ffffffff8025f274>] ? sys_init_module+0x184/0x1da0
[  178.897018]  [<ffffffff8023dd00>] ? __request_region+0x0/0x120
[  178.897020]  [<ffffffff802a9bc8>] ? vfs_read+0xc8/0x180
[  178.897023]  [<ffffffff8020b80b>] ? system_call_after_swapgs+0x7b/0x80
[  178.897025] 
[  178.897025] 
[  178.897026] Code: 94 c0 0f b6 c0 c3 66 0f 1f 44 00 00 48 83 ec 08 f6 87 61 05 00 00 08 75 33 31 d2 eb 0a 0f 1f 80 00 00 00 00 48 89 fa 48 8b 47 10 <48> 8b 78 38 48 85 ff 74 28 f6 87 61 05 00 00 08 74 e7 48 89 f8 
[  178.897037] RIP  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
[  178.897039]  RSP <ffff8101274c5ab8>
[  178.897040] CR2: 0000000000000038
[  178.897052] ---[ end trace 7b6f6a98638f4938 ]---
[  284.698121] hub 2-0:1.0: unable to enumerate USB device on port 5
[  284.955475] usb 8-1: new low speed USB device using uhci_hcd and address 2
[  284.981012] usb 8-1: configuration #1 chosen from 1 choice
[  285.136760] usb 8-1: New USB device found, idVendor=099a, idProduct=7202
[  285.137019] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  285.137303] usb 8-1: Product: WirelessUSB
[  285.137463] usb 8-1: Manufacturer: Cypress
[  285.137463] usbcore: registered new interface driver hiddev
[  285.149652] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input3
[  285.173438] input,hidraw0: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1d.2-1
[  285.226367] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input4
[  285.262793] input,hiddev0,hidraw1: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1d.2-1
[  285.263207] usbcore: registered new interface driver usbhid
[  285.263424] usbhid: v2.6:USB HID core driver
[  306.234631] [drm] Initialized drm 1.1.0 20060810
[  306.247214] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[  306.247220] PCI: Setting latency timer of device 0000:00:02.0 to 64
[  306.247548] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  306.637408] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[  306.886778] set status page addr 0x00033000
[  306.886792] Overlap at 0xd0000000-0xe0000000


...

It seems parport* is orphaned , I will add Andrew to CC , maybe he knows someone who still cares about =)


Regards,

Gabriel



