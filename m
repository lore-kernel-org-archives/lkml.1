Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYD2BUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYD2BUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYD2BUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:20:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:24077 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYD2BUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Goq1LZVEZjlh328qThRXDItc6c66mlQi4Bn4/U+Tpvk5DqlrS5QTB/q0hiS0vwSdXtjybCqEOeKqIGvXmFkDnj/WeyC3iRcTpOtoPP9OtyxN43ttbkomLuSd6dqnfL8CFg/bQ3uU3YPsPxcDuNqZIZACHe0046EjAAn8QNcIc60=
Message-ID: <481677D3.5070800@googlemail.com>
Date: Tue, 29 Apr 2008 03:20:19 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: mgross@linux.intel.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
References: <48133A64.7020702@googlemail.com> <4813660E.8080609@googlemail.com> <20080429002901.GC31157@linux.intel.com>
In-Reply-To: <20080429002901.GC31157@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark gross wrote:
> On Sat, Apr 26, 2008 at 07:27:42PM +0200, Gabriel C wrote:
>> Gabriel C wrote:
>>> Hi all,
>>>
>>> On an kernel ( tested 2.6.25 , linux-next and latest -git ) with DMAR enabled my box won't boot unless I disable it with intel_iommu=off.
>>>
>>> It hangs very early on boot and not even the reset button works anymore , all I get is an black screen , no message or alike and the box hangs.
>>> Also it does not make any difference when enabling / disabling  DMAR_GFX_WA.
>>>
>>> I would like to debug the problem but I have no idea on how to do it.
>>>
>>> Also this box has an ASUS P5E-VM DO motherboard , latest BIOS , Q9300 Quad CPU and 4G RAM.
>>>
>>> lspci :
>>>
>>> 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
>>> 00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics Controller (rev 02)
>>> 00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
>>> 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
>>> 00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
>>> 00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
>>> 00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
>>> 00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
>>> 00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
>>> 00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
>>> 00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
>>> 00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
>>> 00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
>>> 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
>>> 00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller (rev 02)
>>> 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
>>> 00:1f.6 Signal processing controller: Intel Corporation Thermal Subsystem (rev 02)
>>>
>>>
>>> dmesg:
>>>
> 
> schannip 
> 
>>> http://frugalware.org/~crazy/ASUS_P5E-VM_DO/dsdt.dsl
>>>
>>> Please let me know if you need more infos.
>>
>> Got more infos on that.
>>
>> After poking a lot around I found out the boot problem occurs when I
>> have *any* usb devices inserted on boot ( really does not matter which
>> ).
>>
> 
> wha?  Do you have any dmesg traces from when this event happens?  Is it
> just another black screen at early boot or do you get somewhere before
> it stops?

I don't have any log so far , is really early on boot some who. 
Yes just an black screen and box hangs.
 
>  
>> Removing these on boot ( mouse , keyboard and an 1G stick ) made it
>> boot but I got an OOps on loading the parport_pc modules and box died
>> :/
>>
> 
> very strange.

Also as said removing all external USB devices like mouse , keyboard etc box boots up fine.
They do work fine also when I plug all back after the box is up.

> 
>> After blacklisting parport_pc box was up. Strange thing is now I can
>> insert my USB devices and everything is working.
>>
>> The OOPs is reproducible with modprobe too. 
>>
>> New dmesg output : 
>> ...
>>
>>
>> [    0.000000] Linux version 2.6.25-05096-gb1721d0-dirty (crazy@thor) (gcc version 4.3.0 (Frugalware Linux) ) #793 SMP PREEMPT Sat Apr 26 18:07:59 CEST 2008
>> [    0.000000] Command line: root=/dev/sdb1 ro debug vga=792 3
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>> [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>> [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>> [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>> [    0.000000] max_pfn_mapped = 1228800
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] init_memory_mapping
>> [    0.000000] DMI 2.4 present.
>> [    0.000000] ACPI: RSDP 000F9A80, 0024 (r2 ACPIAM)
>> [    0.000000] ACPI: XSDT CF550100, 0064 (r1 A_M_I_ OEMXSDT   3000820 MSFT       97)
>> [    0.000000] ACPI: FACP CF550290, 00F4 (r3 A_M_I_ OEMFACP   3000820 MSFT       97)
>> [    0.000000] ACPI: DSDT CF5505C0, 843B (r1  A0869 A0869001        1 INTL 20060113)
>> [    0.000000] ACPI: FACS CF55E000, 0040
>> [    0.000000] ACPI: APIC CF550390, 006C (r1 A_M_I_ OEMAPIC   3000820 MSFT       97)
>> [    0.000000] ACPI: MCFG CF550400, 003C (r1 A_M_I_ OEMMCFG   3000820 MSFT       97)
>> [    0.000000] ACPI: OEMB CF55E040, 0081 (r1 A_M_I_ AMI_OEM   3000820 MSFT       97)
>> [    0.000000] ACPI: HPET CF558A00, 0038 (r1 A_M_I_ OEMHPET   3000820 MSFT       97)
>> [    0.000000] ACPI: GSCI CF55E0D0, 2024 (r1 A_M_I_ GMCHSCI   3000820 MSFT       97)
>> [    0.000000] ACPI: iEIT CF560100, 00B0 (r1 A_M_I_ EITTABLE  3000820 MSFT       97)
>> [    0.000000] ACPI: DMAR CF5601B0, 0168 (r1    AMI  OEMDMAR        1 MSFT       97)
>> [    0.000000] Entering add_active_range(0, 0, 156) 0 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 256, 849232) 1 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 1048576, 1228800) 2 entries of 256 used
>> [    0.000000] early res: 0 [0-fff] BIOS data page
>> [    0.000000] early res: 1 [6000-7fff] TRAMPOLINE
>> [    0.000000] early res: 2 [200000-8c2533] TEXT DATA BSS
>> [    0.000000] early res: 3 [9cc00-fffff] BIOS reserved
>> [    0.000000] early res: 4 [8000-dfff] PGTABLE
>> [    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
>> [    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
>> [    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
>> [    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
>> [    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
>> [    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
>> [    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
>> [    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
>> [    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
>> [    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
>> [    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
>> [    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
>> [    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff81000c200000 on node 0
>> [    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff81000c600000 on node 0
>> [    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff81000ca00000 on node 0
>> [    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff81000ce00000 on node 0
>> [    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff81000d200000 on node 0
>> [    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff81000d600000 on node 0
>> [    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff81000da00000 on node 0
>> [    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff81000de00000 on node 0
>> [    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff81000e200000 on node 0
>> [    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff81000e600000 on node 0
>> [    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff81000ea00000 on node 0
>> [    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff81000ee00000 on node 0
>> [    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff81000f200000 on node 0
>> [    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff81000f600000 on node 0
>> [    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff81000fa00000 on node 0
>> [    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff81000fe00000 on node 0
>> [    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810010200000 on node 0
>> [    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810010600000 on node 0
>> [    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810010a00000 on node 0
>> [    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810010e00000 on node 0
>> [    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810011200000 on node 0
>> [    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810011600000 on node 0
>> [    0.000000] Zone PFN ranges:
>> [    0.000000]   DMA             0 ->     4096
>> [    0.000000]   DMA32        4096 ->  1048576
>> [    0.000000]   Normal    1048576 ->  1228800
>> [    0.000000] Movable zone start PFN for each node
>> [    0.000000] early_node_map[3] active PFN ranges
>> [    0.000000]     0:        0 ->      156
>> [    0.000000]     0:      256 ->   849232
>> [    0.000000]     0:  1048576 ->  1228800
>> [    0.000000] On node 0 totalpages: 1029356
>> [    0.000000]   DMA zone: 56 pages used for memmap
>> [    0.000000]   DMA zone: 1840 pages reserved
>> [    0.000000]   DMA zone: 2100 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 14280 pages used for memmap
>> [    0.000000]   DMA32 zone: 830856 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 2464 pages used for memmap
>> [    0.000000]   Normal zone: 177760 pages, LIFO batch:31
>> [    0.000000]   Movable zone: 0 pages used for memmap
>> [    0.000000] ACPI: PM-Timer IO Port: 0x808
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Setting APIC routing to flat
>> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
>> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
>> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
>> [    0.000000] PM: Registered nosave memory: 00000000cf550000 - 00000000cf55e000
>> [    0.000000] PM: Registered nosave memory: 00000000cf55e000 - 00000000cf5e0000
>> [    0.000000] PM: Registered nosave memory: 00000000cf5e0000 - 00000000cf600000
>> [    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000fee00000
>> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
>> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
>> [    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
>> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
>> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
>> [    0.000000] PERCPU: Allocating 43908 bytes of per cpu data
>> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010716
>> [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=792 3
>> [    0.000000] Initializing CPU#0
>> [    0.000000] Preemptible RCU implementation.
>> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
>> [    0.000000] Extended CMOS year: 2000
>> [    0.000000] TSC calibrated against PM_TIMER
>> [    0.000016] time.c: Detected 2499.949 MHz processor.
>> [    0.000030] Console: colour dummy device 80x25
>> [    0.000032] console [tty0] enabled
>> [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>> [    0.000999] Checking aperture...
>> [    0.000999] Memory: 4033444k/4915200k available (3595k kernel code, 83264k reserved, 1637k data, 292k init)
>> [    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
>> [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
>> [    0.000999] hpet clockevent registered
>> [    0.059992] Calibrating delay using timer specific routine.. 5002.53 BogoMIPS (lpj=2501266)
>> [    0.060021] Security Framework initialized
>> [    0.060032] Capability LSM initialized
>> [    0.060041] Mount-cache hash table entries: 256
>> [    0.060147] CPU: L1 I cache: 32K, L1 D cache: 32K
>> [    0.060154] CPU: L2 cache: 3072K
>> [    0.060159] CPU: Physical Processor ID: 0
>> [    0.060163] CPU: Processor Core ID: 0
>> [    0.060171] CPU0: Thermal monitoring enabled (TM2)
>> [    0.060176] using mwait in idle threads.
>> [    0.060191] ACPI: Core revision 20070126
>> [    0.081250] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
>> [    0.081259] Using local APIC timer interrupts.
>> [    0.081988] APIC timer calibration result 20832892
>> [    0.081993] Detected 20.832 MHz APIC timer.
>> [    0.082066] Booting processor 1/1 ip 6000
>> [    0.082066] Initializing CPU#1
>> [    0.082066] Calibrating delay using timer specific routine.. 4999.71 BogoMIPS (lpj=2499858)
>> [    0.082066] CPU: L1 I cache: 32K, L1 D cache: 32K
>> [    0.082066] CPU: L2 cache: 3072K
>> [    0.082066] CPU: Physical Processor ID: 0
>> [    0.082066] CPU: Processor Core ID: 1
>> [    0.082066] CPU1: Thermal monitoring enabled (TM2)
>> [    0.082066] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
>> [    0.154136] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
>> [    0.154193] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>> [    0.155042] Booting processor 2/2 ip 6000
>> [    0.155042] Initializing CPU#2
>> [    0.155042] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499867)
>> [    0.155042] CPU: L1 I cache: 32K, L1 D cache: 32K
>> [    0.155042] CPU: L2 cache: 3072K
>> [    0.155042] CPU: Physical Processor ID: 0
>> [    0.155042] CPU: Processor Core ID: 2
>> [    0.155042] CPU2: Thermal monitoring enabled (TM2)
>> [    0.155042] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
>> [    0.227150] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
>> [    0.227206] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
>> [    0.228014] Booting processor 3/3 ip 6000
>> [    0.228014] Initializing CPU#3
>> [    0.228014] Calibrating delay using timer specific routine.. 4999.73 BogoMIPS (lpj=2499869)
>> [    0.228014] CPU: L1 I cache: 32K, L1 D cache: 32K
>> [    0.228014] CPU: L2 cache: 3072K
>> [    0.228014] CPU: Physical Processor ID: 0
>> [    0.228014] CPU: Processor Core ID: 3
>> [    0.228014] CPU3: Thermal monitoring enabled (TM2)
>> [    0.228014] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
>> [    0.300145] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
>> [    0.300199] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
>> [    0.300961] Brought up 4 CPUs
>> [    0.300966] Total of 4 processors activated (20001.72 BogoMIPS).
>> [    0.301291] net_namespace: 960 bytes
>> [    0.301424] xor: automatically using best checksumming function: generic_sse
>> [    0.305954]    generic_sse:  9264.000 MB/sec
>> [    0.305959] xor: using function: generic_sse (9264.000 MB/sec)
>> [    0.305983] NET: Registered protocol family 16
>> [    0.306205] No dock devices found.
>> [    0.306325] ACPI: bus type pci registered
>> [    0.306414] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
>> [    0.306422] PCI: Not using MMCONFIG.
>> [    0.306427] PCI: Using configuration type 1
>> [    0.310700] ACPI: EC: Look up EC in DSDT
>> [    0.316785] ACPI: Interpreter enabled
>> [    0.316795] ACPI: (supports S0 S1 S3 S4 S5)
>> [    0.316813] ACPI: Using IOAPIC for interrupt routing
>> [    0.325015] ACPI: PCI Root Bridge [PCI0] (0000:00)
>> [    0.325916] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
>> [    0.325925] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
>> [    0.326109] PCI: Transparent bridge - 0000:00:1e.0
>> [    0.326127] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [    0.326271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
>> [    0.343978] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
>> [    0.344106] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
>> [    0.344220] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
>> [    0.344334] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
>> [    0.344450] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
>> [    0.344563] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
>> [    0.344676] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 *14 15)
>> [    0.344789] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
>> [    0.344979] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  E2, should be DD [20070126]
>> [    0.344996] Overlap at 0xcf550000-0xcf559000
>> [    0.345656] Overlap at 0xcf55e000-0xcf561000
>> [    0.345677] Overlap at 0xcf55e000-0xcf561000
>> [    0.345711] Linux Plug and Play Support v0.97 (c) Adam Belay
>> [    0.345757] pnp: PnP ACPI init
>> [    0.345766] ACPI: bus type pnp registered
>> [    0.349698] pnp: PnP ACPI: found 15 devices
>> [    0.349703] ACPI: ACPI bus type pnp unregistered
>> [    0.349942] SCSI subsystem initialized
>> [    0.350036] libata version 3.00 loaded.
>> [    0.350236] usbcore: registered new interface driver usbfs
>> [    0.350277] usbcore: registered new interface driver hub
>> [    0.350344] usbcore: registered new device driver usb
>> [    0.350619] PCI: Using ACPI for IRQ routing
>> [    0.357951] DMAR:Host address width 36
>> [    0.357958] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
>> [    0.357967] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
>> [    0.357976] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed92000
>> [    0.357986] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
>> [    0.357994] DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
>> [    0.358011] DMAR:RMRR base: 0x00000000cf600000 end: 0x00000000cfffffff
>> [    0.358020] DMAR:RMRR base: 0x00000000cf5e0000 end: 0x00000000cf5effff
>> [    0.358078] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358107] IOMMU: Setting identity map for device 0000:00:1d.1 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358129] IOMMU: Setting identity map for device 0000:00:1d.2 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358151] IOMMU: Setting identity map for device 0000:00:1d.7 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358176] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358198] IOMMU: Setting identity map for device 0000:00:1a.1 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358232] IOMMU: Setting identity map for device 0000:00:1a.2 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358260] IOMMU: Setting identity map for device 0000:00:1a.7 [0xcf5e0000 - 0xcf5f0000]
>> [    0.358284] IOMMU: Setting identity map for device 0000:00:02.0 [0xcf600000 - 0xd0000000]
>> [    0.358842] IOMMU: Setting identity map for device 0000:00:1d.0 [0xed000 - 0xf0000]
>> [    0.358856] IOMMU: Setting identity map for device 0000:00:1d.1 [0xed000 - 0xf0000]
>> [    0.358869] IOMMU: Setting identity map for device 0000:00:1d.2 [0xed000 - 0xf0000]
>> [    0.358883] IOMMU: Setting identity map for device 0000:00:1d.7 [0xed000 - 0xf0000]
>> [    0.358900] IOMMU: Setting identity map for device 0000:00:1a.0 [0xed000 - 0xf0000]
>> [    0.358913] IOMMU: Setting identity map for device 0000:00:1a.1 [0xed000 - 0xf0000]
>> [    0.358926] IOMMU: Setting identity map for device 0000:00:1a.2 [0xed000 - 0xf0000]
>> [    0.358939] IOMMU: Setting identity map for device 0000:00:1a.7 [0xed000 - 0xf0000]
>> [    0.358954] IOMMU: gfx device 0000:00:02.0 1-1 mapping
>> [    0.358959] IOMMU: Setting identity map for device 0000:00:02.0 [0x0 - 0x9cc00]
>> [    0.359005] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000 - 0xcf550000]
>> [    0.542673] IOMMU: Setting identity map for device 0000:00:02.0 [0x100000000 - 0x12c000000]
>> [    0.581575] IOMMU: Prepare 0-16M unity mapping for LPC
>> [    0.581583] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
>> [    0.581583] DMAR:[DMA Write] Request device [00:02.0] fault addr ffffff000 
>> [    0.581584] DMAR:[fault reason 05] PTE Write access is not set
>> [    0.582922] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>> [    0.582937] PCI-GART: No AMD northbridge found.
>> [    0.582946] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
>> [    0.582954] hpet0: 4 64-bit timers, 14318180 Hz
>> [    0.583956] ACPI: RTC can wake from S4
>> [    0.584915] Switched to high resolution mode on CPU 0
>> [    0.584915] Switched to high resolution mode on CPU 1
>> [    0.584915] Switched to high resolution mode on CPU 2
>> [    0.584915] Switched to high resolution mode on CPU 3
>> [    0.595930] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
>> [    0.595947] system 00:07: ioport range 0x290-0x297 has been reserved
>> [    0.595958] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
>> [    0.595966] system 00:08: ioport range 0x800-0x87f has been reserved
>> [    0.595974] system 00:08: ioport range 0x480-0x4bf has been reserved
>> [    0.595982] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
>> [    0.595990] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
>> [    0.595998] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
>> [    0.596007] system 00:08: iomem range 0xfed08000-0xfed08fff has been reserved
>> [    0.596019] system 00:08: iomem range 0xff800000-0xffbfffff has been reserved
>> [    0.596026] system 00:08: iomem range 0xffe80000-0xffefffff could not be reserved
>> [    0.596033] system 00:08: iomem range 0xffc00000-0xffffffff could not be reserved
>> [    0.596045] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
>> [    0.596052] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
>> [    0.596063] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
>> [    0.596073] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
>> [    0.596079] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
>> [    0.596085] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
>> [    0.596092] system 00:0e: iomem range 0x100000-0xcf5fffff could not be reserved
>> [    0.596099] system 00:0e: iomem range 0x0-0x0 could not be reserved
>> [    0.596712] PCI: Bridge: 0000:00:1e.0
>> [    0.596717]   IO window: disabled.
>> [    0.596724]   MEM window: disabled.
>> [    0.596730]   PREFETCH window: disabled.
>> [    0.596762] PCI: Setting latency timer of device 0000:00:1e.0 to 64
>> [    0.596776] NET: Registered protocol family 2
>> [    0.628946] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
>> [    0.629185] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
>> [    0.630378] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>> [    0.630794] TCP: Hash tables configured (established 262144 bind 65536)
>> [    0.630801] TCP reno registered
>> [    0.641998] NET: Registered protocol family 1
>> [    0.642237] audit: initializing netlink socket (disabled)
>> [    0.642253] type=2000 audit(1209236264.642:1): initialized
>> [    0.645619] async_tx: api initialized (sync-only)
>> [    0.645655] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
>> [    0.645663] io scheduler noop registered
>> [    0.645667] io scheduler anticipatory registered
>> [    0.645672] io scheduler deadline registered
>> [    0.645739] io scheduler cfq registered (default)
>> [    0.645753] pci 0000:00:02.0: Boot video device
>> [    0.646363] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 6144k, total 8128k
>> [    0.646373] vesafb: mode is 1024x768x32, linelength=4096, pages=1
>> [    0.646378] vesafb: scrolling: redraw
>> [    0.646383] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
>> [    0.665697] Console: switching to colour frame buffer device 128x48
>> [    0.684995] fb0: VESA VGA frame buffer device
>> [    0.708412] hpet_resources: 0xfed00000 is busy
>> [    0.708712] Linux agpgart interface v0.103
>> [    0.708890] agpgart: Detected an Intel Q35 Chipset.
>> [    0.709952] agpgart: Detected 6140K stolen memory.
>> [    0.722120] agpgart: AGP aperture is 256M @ 0xd0000000
>> [    0.722393] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
>> [    0.722783] intelfb: Version 0.9.4
>> [    0.722965] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
>> [    0.723450] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    0.724446] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> [    0.724810] ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
>> [    0.725205] 0000:00:03.3: ttyS1 at I/O 0xe880 (irq = 17) is a 16550A
>> [    0.726257] brd: module loaded
>> [    0.726515] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.1
>> [    0.726722] e1000e: Copyright (c) 1999-2008 Intel Corporation.
>> [    0.726960] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
>> [    0.727253] PCI: Setting latency timer of device 0000:00:19.0 to 64
>> [    0.906988] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:8c:7b:c8:bc
>> [    0.907217] eth0: Intel(R) PRO/1000 Network Connection
>> [    0.907424] eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
>> [    0.907689] Fixed MDIO Bus: probed
>> [    0.908380] Driver 'sd' needs updating - please use bus_type methods
>> [    0.913064] ahci 0000:00:1f.2: version 3.0
>> [    0.917745] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 22
>> [    1.921983] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
>> [    1.927194] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
>> [    1.932633] PCI: Setting latency timer of device 0000:00:1f.2 to 64
>> [    1.939441] scsi0 : ahci
>> [    1.945166] scsi1 : ahci
>> [    1.950902] scsi2 : ahci
>> [    1.956648] scsi3 : ahci
>> [    1.962423] scsi4 : ahci
>> [    1.969172] scsi5 : ahci
>> [    1.975028] ata1: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78900 irq 507
>> [    1.981154] ata2: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78980 irq 507
>> [    1.987282] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 507
>> [    1.993615] ata4: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78a80 irq 507
>> [    2.000103] ata5: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78b00 irq 507
>> [    2.006613] ata6: SATA max UDMA/133 abar m2048@0xfeb78800 port 0xfeb78b80 irq 507
>> [    2.465272] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.477249] ata1.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
>> [    2.484035] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    2.496348] ata1.00: configured for UDMA/133
>> [    2.960584] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    2.973162] ata2.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
>> [    2.980602] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    2.993366] ata2.00: configured for UDMA/133
>> [    3.875224] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    3.883533] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100, ATAPI AN
>> [    3.892263] ata3.00: configured for UDMA/100
>> [    4.203735] ata4: SATA link down (SStatus 0 SControl 300)
>> [    4.668043] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    4.681041] ata5.00: ATA-7: SAMSUNG HD250HJ, FH100-06, max UDMA7
>> [    4.688593] ata5.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>> [    4.701388] ata5.00: configured for UDMA/133
>> [    5.012533] ata6: SATA link down (SStatus 0 SControl 300)
>> [    5.026550] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
>> [    5.034190] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.041731] sd 0:0:0:0: [sda] Write Protect is off
>> [    5.049125] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    5.056469] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.064037] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.071593] sd 0:0:0:0: [sda] Write Protect is off
>> [    5.078991] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    5.086284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.093729]  sda: sda1 sda2 sda3 sda4
>> [    5.109261] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    5.116755] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    5.124275] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
>> [    5.131914] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.139481] sd 1:0:0:0: [sdb] Write Protect is off
>> [    5.146878] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    5.154145] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.161586] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.168927] sd 1:0:0:0: [sdb] Write Protect is off
>> [    5.176171] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    5.183491] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.191142]  sdb: sdb1 sdb2 sdb3 sdb4
>> [    5.207529] sd 1:0:0:0: [sdb] Attached SCSI disk
>> [    5.215466] sd 1:0:0:0: Attached scsi generic sg1 type 0
>> [    5.224095] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  SB00 PQ: 0 ANSI: 5
>> [    5.233283] scsi 2:0:0:0: Attached scsi generic sg2 type 5
>> [    5.241496] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD250HJ  FH10 PQ: 0 ANSI: 5
>> [    5.249830] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.258063] sd 4:0:0:0: [sdc] Write Protect is off
>> [    5.266307] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> [    5.274643] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.283175] sd 4:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
>> [    5.291656] sd 4:0:0:0: [sdc] Write Protect is off
>> [    5.300041] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> [    5.308364] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    5.316872]  sdc: sdc1 sdc2 sdc3 sdc4
>> [    5.329321] sd 4:0:0:0: [sdc] Attached SCSI disk
>> [    5.337821] sd 4:0:0:0: Attached scsi generic sg3 type 0
>> [    5.346459] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
>> [    5.354952] PCI: Setting latency timer of device 0000:00:1a.7 to 64
>> [    5.363371] ehci_hcd 0000:00:1a.7: EHCI Host Controller
>> [    5.371815] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
>> [    5.384553] ehci_hcd 0000:00:1a.7: debug port 1
>> [    5.392909] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
>> [    5.401420] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfeb7a800
>> [    5.419532] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>> [    5.428169] usb usb1: configuration #1 chosen from 1 choice
>> [    5.436771] hub 1-0:1.0: USB hub found
>> [    5.445188] hub 1-0:1.0: 6 ports detected
>> [    5.553394] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    5.561795] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    5.570259] usb usb1: Product: EHCI Host Controller
>> [    5.578624] usb usb1: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
>> [    5.587022] usb usb1: SerialNumber: 0000:00:1a.7
>> [    5.595361] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
>> [    5.603933] PCI: Setting latency timer of device 0000:00:1d.7 to 64
>> [    5.612451] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>> [    5.620905] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
>> [    5.634171] ehci_hcd 0000:00:1d.7: debug port 1
>> [    5.642618] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
>> [    5.651162] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfeb7a400
>> [    5.669260] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>> [    5.677841] usb usb2: configuration #1 chosen from 1 choice
>> [    5.686499] hub 2-0:1.0: USB hub found
>> [    5.694975] hub 2-0:1.0: 6 ports detected
>> [    5.804123] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>> [    5.812583] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    5.821099] usb usb2: Product: EHCI Host Controller
>> [    5.829519] usb usb2: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty ehci_hcd
>> [    5.837935] usb usb2: SerialNumber: 0000:00:1d.7
>> [    5.846361] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    5.855016] USB Universal Host Controller Interface driver v3.0
>> [    5.863608] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
>> [    5.872261] PCI: Setting latency timer of device 0000:00:1a.0 to 64
>> [    5.880888] uhci_hcd 0000:00:1a.0: UHCI Host Controller
>> [    5.889497] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
>> [    5.898170] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d480
>> [    5.906922] usb usb3: configuration #1 chosen from 1 choice
>> [    5.915537] hub 3-0:1.0: USB hub found
>> [    5.923981] hub 3-0:1.0: 2 ports detected
>> [    6.032781] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>> [    6.041340] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    6.049832] usb usb3: Product: UHCI Host Controller
>> [    6.058175] usb usb3: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    6.066662] usb usb3: SerialNumber: 0000:00:1a.0
>> [    6.075153] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
>> [    6.083721] PCI: Setting latency timer of device 0000:00:1a.1 to 64
>> [    6.092251] uhci_hcd 0000:00:1a.1: UHCI Host Controller
>> [    6.100775] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
>> [    6.109378] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
>> [    6.118942] usb usb4: configuration #1 chosen from 1 choice
>> [    6.127440] hub 4-0:1.0: USB hub found
>> [    6.135779] hub 4-0:1.0: 2 ports detected
>> [    6.244388] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>> [    6.252719] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    6.261050] usb usb4: Product: UHCI Host Controller
>> [    6.269423] usb usb4: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    6.277871] usb usb4: SerialNumber: 0000:00:1a.1
>> [    6.286262] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
>> [    6.294776] PCI: Setting latency timer of device 0000:00:1a.2 to 64
>> [    6.303261] uhci_hcd 0000:00:1a.2: UHCI Host Controller
>> [    6.311776] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
>> [    6.320296] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000d880
>> [    6.328784] usb usb5: configuration #1 chosen from 1 choice
>> [    6.337144] hub 5-0:1.0: USB hub found
>> [    6.345412] hub 5-0:1.0: 2 ports detected
>> [    6.454076] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>> [    6.462363] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    6.470580] usb usb5: Product: UHCI Host Controller
>> [    6.478758] usb usb5: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    6.486985] usb usb5: SerialNumber: 0000:00:1a.2
>> [    6.495169] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
>> [    6.504374] PCI: Setting latency timer of device 0000:00:1d.0 to 64
>> [    6.512755] uhci_hcd 0000:00:1d.0: UHCI Host Controller
>> [    6.521194] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
>> [    6.529656] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d000
>> [    6.539050] usb usb6: configuration #1 chosen from 1 choice
>> [    6.547401] hub 6-0:1.0: USB hub found
>> [    6.555583] hub 6-0:1.0: 2 ports detected
>> [    6.663491] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
>> [    6.671587] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    6.679624] usb usb6: Product: UHCI Host Controller
>> [    6.687566] usb usb6: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    6.695657] usb usb6: SerialNumber: 0000:00:1d.0
>> [    6.703692] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
>> [    6.712692] PCI: Setting latency timer of device 0000:00:1d.1 to 64
>> [    6.720875] uhci_hcd 0000:00:1d.1: UHCI Host Controller
>> [    6.729186] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
>> [    6.738513] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
>> [    6.746864] usb usb7: configuration #1 chosen from 1 choice
>> [    6.755116] hub 7-0:1.0: USB hub found
>> [    6.763222] hub 7-0:1.0: 2 ports detected
>> [    6.871985] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
>> [    6.880083] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    6.888108] usb usb7: Product: UHCI Host Controller
>> [    6.896042] usb usb7: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    6.904124] usb usb7: SerialNumber: 0000:00:1d.1
>> [    6.912159] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
>> [    6.921133] PCI: Setting latency timer of device 0000:00:1d.2 to 64
>> [    6.929322] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> [    6.937625] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
>> [    6.945949] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d400
>> [    6.954302] usb usb8: configuration #1 chosen from 1 choice
>> [    6.962572] hub 8-0:1.0: USB hub found
>> [    6.970670] hub 8-0:1.0: 2 ports detected
>> [    7.078487] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
>> [    7.086571] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    7.094589] usb usb8: Product: UHCI Host Controller
>> [    7.102520] usb usb8: Manufacturer: Linux 2.6.25-05096-gb1721d0-dirty uhci_hcd
>> [    7.110583] usb usb8: SerialNumber: 0000:00:1d.2
>> [    7.118638] Initializing USB Mass Storage driver...
>> [    7.126700] usbcore: registered new interface driver usb-storage
>> [    7.134788] USB Mass Storage support registered.
>> [    7.142992] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
>> [    7.151158] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
>> [    7.160874] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    7.169270] mice: PS/2 mouse device common for all mice
>> [    7.199187] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
>> [    7.214816] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>> [    7.223295] rtc0: alarms up to one month, y3k
>> [    7.232650] i2c /dev entries driver
>> [    7.240966] md: linear personality registered for level -1
>> [    7.249291] md: raid0 personality registered for level 0
>> [    7.257598] md: raid1 personality registered for level 1
>> [    7.265769] md: raid10 personality registered for level 10
>> [    7.290934] raid6: int64x1   2371 MB/s
>> [    7.316129] raid6: int64x2   3050 MB/s
>> [    7.341158] raid6: int64x4   2882 MB/s
>> [    7.367086] raid6: int64x8   2132 MB/s
>> [    7.392838] raid6: sse2x1    4207 MB/s
>> [    7.417456] raid6: sse2x2    4937 MB/s
>> [    7.441924] raid6: sse2x4    7121 MB/s
>> [    7.449228] raid6: using algorithm sse2x4 (7121 MB/s)
>> [    7.456479] md: raid6 personality registered for level 6
>> [    7.463714] md: raid5 personality registered for level 5
>> [    7.470863] md: raid4 personality registered for level 4
>> [    7.477856] md: multipath personality registered for level -4
>> [    7.485997] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
>> [    7.493236] cpuidle: using governor ladder
>> [    7.500466] cpuidle: using governor menu
>> [    7.507609] Advanced Linux Sound Architecture Driver Version 1.0.16.
>> [    7.515867] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
>> [    7.523151] PCI: Setting latency timer of device 0000:00:1b.0 to 64
>> [    7.540879] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
>> [    7.573201] ALSA device list:
>> [    7.580378]   #0: HDA Intel at 0xfeb70000 irq 22
>> [    7.587717] IPv4 over IPv4 tunneling driver
>> [    7.594942] GRE over IPv4 tunneling driver
>> [    7.602163] TCP cubic registered
>> [    7.609114] TCP hybla registered
>> [    7.615931] NET: Registered protocol family 17
>> [    7.622895] registered taskstats version 1
>> [    7.629863] rtc_cmos 00:03: setting system clock to 2008-04-26 18:57:52 UTC (1209236272)
>> [    7.636911] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
>> [    7.644301] md: Autodetecting RAID arrays.
>> [    7.756832] md: Scanned 11 and added 11 devices.
>> [    7.763699] md: autorun ...
>> [    7.770408] md: considering sdc4 ...
>> [    7.777086] md:  adding sdc4 ...
>> [    7.783647] md: sdc3 has different UUID to sdc4
>> [    7.790195] md: sdc2 has different UUID to sdc4
>> [    7.796591] md: sdc1 has different UUID to sdc4
>> [    7.802752] md:  adding sdb4 ...
>> [    7.808689] md: sdb3 has different UUID to sdc4
>> [    7.814636] md: sdb2 has different UUID to sdc4
>> [    7.820350] md:  adding sda4 ...
>> [    7.825845] md: sda3 has different UUID to sdc4
>> [    7.831331] md: sda2 has different UUID to sdc4
>> [    7.836721] md: sda1 has different UUID to sdc4
>> [    7.842069] md: created md3
>> [    7.847303] md: bind<sda4>
>> [    7.852541] md: bind<sdb4>
>> [    7.857667] md: bind<sdc4>
>> [    7.862660] md: running: <sdc4><sdb4><sda4>
>> [    7.867857] md3: setting max_sectors to 128, segment boundary to 32767
>> [    7.873278] raid0: looking at sdc4
>> [    7.873280] raid0:   comparing sdc4(1028096) with sdc4(1028096)
>> [    7.873281] raid0:   END
>> [    7.873282] raid0:   ==> UNIQUE
>> [    7.873283] raid0: 1 zones
>> [    7.873284] raid0: looking at sdb4
>> [    7.873285] raid0:   comparing sdb4(1028096) with sdc4(1028096)
>> [    7.873286] raid0:   EQUAL
>> [    7.873287] raid0: looking at sda4
>> [    7.873288] raid0:   comparing sda4(1028096) with sdc4(1028096)
>> [    7.873289] raid0:   EQUAL
>> [    7.873290] raid0: FINAL 1 zones
>> [    7.873291] raid0: done.
>> [    7.873292] raid0 : md_size is 3084288 blocks.
>> [    7.873292] raid0 : conf->hash_spacing is 3084288 blocks.
>> [    7.873293] raid0 : nb_zone is 1.
>> [    7.873294] raid0 : Allocating 8 bytes for hash.
>> [    7.879825] md: considering sdc3 ...
>> [    7.879829] md:  adding sdc3 ...
>> [    7.879832] md: sdc2 has different UUID to sdc3
>> [    7.879834] md: sdc1 has different UUID to sdc3
>> [    7.879837] md:  adding sdb3 ...
>> [    7.879840] md: sdb2 has different UUID to sdc3
>> [    7.879843] md:  adding sda3 ...
>> [    7.879845] md: sda2 has different UUID to sdc3
>> [    7.879848] md: sda1 has different UUID to sdc3
>> [    7.879899] md: created md2
>> [    7.879900] md: bind<sda3>
>> [    7.879907] md: bind<sdb3>
>> [    7.879914] md: bind<sdc3>
>> [    7.879923] md: running: <sdc3><sdb3><sda3>
>> [    7.879968] md2: setting max_sectors to 128, segment boundary to 32767
>> [    7.879969] raid0: looking at sdc3
>> [    7.879970] raid0:   comparing sdc3(111330368) with sdc3(111330368)
>> [    7.879971] raid0:   END
>> [    7.879972] raid0:   ==> UNIQUE
>> [    7.879973] raid0: 1 zones
>> [    7.879973] raid0: looking at sdb3
>> [    7.879974] raid0:   comparing sdb3(111330368) with sdc3(111330368)
>> [    7.879975] raid0:   EQUAL
>> [    7.879976] raid0: looking at sda3
>> [    7.879977] raid0:   comparing sda3(111330368) with sdc3(111330368)
>> [    7.879978] raid0:   EQUAL
>> [    7.879979] raid0: FINAL 1 zones
>> [    7.879980] raid0: done.
>> [    7.879981] raid0 : md_size is 333991104 blocks.
>> [    7.879981] raid0 : conf->hash_spacing is 333991104 blocks.
>> [    7.879982] raid0 : nb_zone is 1.
>> [    7.879983] raid0 : Allocating 8 bytes for hash.
>> [    7.880016] md: considering sdc2 ...
>> [    7.880020] md:  adding sdc2 ...
>> [    7.880022] md: sdc1 has different UUID to sdc2
>> [    7.880025] md:  adding sdb2 ...
>> [    7.880029] md:  adding sda2 ...
>> [    7.880031] md: sda1 has different UUID to sdc2
>> [    7.880079] md: created md1
>> [    7.880081] md: bind<sda2>
>> [    7.880088] md: bind<sdb2>
>> [    7.880096] md: bind<sdc2>
>> [    7.880102] md: running: <sdc2><sdb2><sda2>
>> [    7.880139] md1: setting max_sectors to 128, segment boundary to 32767
>> [    7.880141] raid0: looking at sdc2
>> [    7.880142] raid0:   comparing sdc2(97659008) with sdc2(97659008)
>> [    7.880144] raid0:   END
>> [    7.880144] raid0:   ==> UNIQUE
>> [    7.880145] raid0: 1 zones
>> [    7.880146] raid0: looking at sdb2
>> [    7.880147] raid0:   comparing sdb2(97659008) with sdc2(97659008)
>> [    7.880149] raid0:   EQUAL
>> [    7.880149] raid0: looking at sda2
>> [    7.880151] raid0:   comparing sda2(97659008) with sdc2(97659008)
>> [    7.880152] raid0:   EQUAL
>> [    7.880153] raid0: FINAL 1 zones
>> [    7.880154] raid0: done.
>> [    7.880155] raid0 : md_size is 292977024 blocks.
>> [    7.880156] raid0 : conf->hash_spacing is 292977024 blocks.
>> [    7.880157] raid0 : nb_zone is 1.
>> [    7.880158] raid0 : Allocating 8 bytes for hash.
>> [    7.880191] md: considering sdc1 ...
>> [    7.880194] md:  adding sdc1 ...
>> [    7.880196] md:  adding sda1 ...
>> [    7.880197] md: created md0
>> [    7.880198] md: bind<sda1>
>> [    7.880206] md: bind<sdc1>
>> [    7.880211] md: running: <sdc1><sda1>
>> [    7.880295] raid1: raid set md0 active with 2 out of 2 mirrors
>> [    7.880334] md: ... autorun DONE.
>> [    8.317316] kjournald starting.  Commit interval 5 seconds
>> [    8.321797] EXT3-fs: mounted filesystem with ordered data mode.
>> [    8.326366] VFS: Mounted root (ext3 filesystem) readonly.
>> [    8.330926] Freeing unused kernel memory: 292k freed
>> [    9.024187] EXT3 FS on sdb1, internal journal
>> [    9.537581] Driver 'sr' needs updating - please use bus_type methods
>> [    9.547189] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
>> [    9.552624] Uniform CD-ROM driver Revision: 3.20
>> [    9.552673] sr 2:0:0:0: Attached scsi CD-ROM sr0
>> [    9.552673] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
>> [    9.552673] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    9.565184] ACPI: Power Button (FF) [PWRF]
>> [    9.565270] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
>> [    9.578184] ACPI: Power Button (CM) [PWRB]
>> [    9.585244] ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 18 (level, low) -> IRQ 18
>> [    9.585276] PCI: Setting latency timer of device 0000:00:03.2 to 64
>> [    9.585287] ACPI: PCI interrupt for device 0000:00:03.2 disabled
>> [   11.169594] EXT3 FS on sdb1, internal journal
>> [   11.897997] loop: module loaded
>> [   12.566072] kjournald starting.  Commit interval 5 seconds
>> [   12.566072] EXT3 FS on md1, internal journal
>> [   12.566078] EXT3-fs: mounted filesystem with ordered data mode.
>> [   12.605071] kjournald starting.  Commit interval 5 seconds
>> [   12.605200] EXT3 FS on md2, internal journal
>> [   12.605203] EXT3-fs: mounted filesystem with ordered data mode.
>> [   12.741719] Adding 3084280k swap on /dev/md3.  Priority:-1 extents:1 across:3084280k
>> [   15.356972] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
>> [   15.356975] eth0: 10/100 speed: disabling TSO
>> [   18.176393] eth0: changing MTU from 1500 to 1492
>> [   19.684275] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
>> [   19.684279] eth0: 10/100 speed: disabling TSO
>> [   21.030925] fuse init (API version 7.9)
>> [  118.660390] ppdev: user-space parallel port driver
>> [  138.724111] lp: driver loaded but no devices found
>> [  178.888281] parport_pc 00:06: reported by Plug and Play ACPI
>> [  178.888385] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
>> [  178.888968] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>> [  178.890214] IP: [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
>> [  178.890214] PGD 128f5a067 PUD 1274e1067 PMD 0 
>> [  178.890214] Oops: 0000 [1] PREEMPT SMP 
>> [  178.890214] CPU 0 
>> [  178.890214] Modules linked in: parport_pc(+) lp ppdev parport fuse loop pata_acpi button i2c_i801 sr_mod evdev
>> [  178.890214] Pid: 4286, comm: modprobe Not tainted 2.6.25-05096-gb1721d0-dirty #793
>> [  178.890214] RIP: 0010:[<ffffffff80365eaf>]  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
> 
> I'm on the stack :(
> 
> It feels like something outside of the IOMMU code is messing up here.
> If pci_find_upstream_pcie_bridge is getting a bad pdev, I think
> something is odd because the intel-iommu code doesn't do anything but
> pass through the value's in the dev thats setup by the other code.

Hmm but I can only reproduce with DMAR* enabled , it does not OOPs when DMAR is disabled.


> 
> --mgross
> 
> 
>> [  178.890214] RSP: 0018:ffff8101274c5ab8  EFLAGS: 00010246
>> [  178.890214] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> [  178.890214] RDX: 0000000000000000 RSI: 0000000000000030 RDI: ffff81012be17f80
>> [  178.890214] RBP: 0000000000001000 R08: 0000000000000000 R09: ffff810128f99000
>> [  178.890214] R10: 0000000000000000 R11: ffffffff8036fd80 R12: 0000000000000030
>> [  178.890214] R13: ffff81012be17f80 R14: ffff81012be18000 R15: ffff81012be17f80
>> [  178.890214] FS:  00007f66267e76f0(0000) GS:ffffffff8071d000(0000) knlGS:0000000000000000
>> [  178.890214] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [  178.890214] CR2: 0000000000000038 CR3: 0000000129719000 CR4: 00000000000006e0
>> [  178.890214] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  178.890214] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [  178.890214] Process modprobe (pid: 4286, threadinfo ffff8101274c4000, task ffff81012a452000)
>> [  178.890214] Stack:  000000002700205d ffffffff8036e708 0000000000000001 ffffffff80783f40
>> [  178.896962]  0000000000000001 0000004400000001 000210d000000000 ffffffff806b0a28
>> [  178.896969]  0000000000000002 ffffffff806afd80 0000000000000000 0000000000000000
>> [  178.896973] Call Trace:
>> [  178.896976]  [<ffffffff8036e708>] ? get_domain_for_dev+0x78/0x6b0
>> [  178.896979]  [<ffffffff8036f077>] ? get_valid_domain_for_dev+0x17/0x150
>> [  178.896981]  [<ffffffff8036fc5d>] ? intel_map_single+0x3d/0x160
>> [  178.896982]  [<ffffffff8036fdfe>] ? intel_alloc_coherent+0x7e/0xc0
>> [  178.896987]  [<ffffffffa00434b9>] ? :parport_pc:parport_pc_probe_port+0x799/0xe20
>> [  178.896991]  [<ffffffffa0043c3f>] ? :parport_pc:parport_pc_pnp_probe+0xff/0x140
>> [  178.896993]  [<ffffffff803a828d>] ? pnp_device_probe+0x9d/0x130
>> [  178.896996]  [<ffffffff803ddcee>] ? driver_probe_device+0x9e/0x1d0
>> [  178.896998]  [<ffffffff803ddeab>] ? __driver_attach+0x8b/0x90
>> [  178.897000]  [<ffffffff803dde20>] ? __driver_attach+0x0/0x90
>> [  178.897002]  [<ffffffff803dd48b>] ? bus_for_each_dev+0x5b/0x80
>> [  178.897005]  [<ffffffff802a4267>] ? kmem_cache_alloc+0x67/0xa0
>> [  178.897007]  [<ffffffff803dcd58>] ? bus_add_driver+0x208/0x280
>> [  178.897008]  [<ffffffff803de04f>] ? driver_register+0x3f/0x100
>> [  178.897011]  [<ffffffffa004e648>] ? :parport_pc:parport_pc_init+0x5a3/0x5ba
>> [  178.897014]  [<ffffffff8025f274>] ? sys_init_module+0x184/0x1da0
>> [  178.897018]  [<ffffffff8023dd00>] ? __request_region+0x0/0x120
>> [  178.897020]  [<ffffffff802a9bc8>] ? vfs_read+0xc8/0x180
>> [  178.897023]  [<ffffffff8020b80b>] ? system_call_after_swapgs+0x7b/0x80
>> [  178.897025] 
>> [  178.897025] 
>> [  178.897026] Code: 94 c0 0f b6 c0 c3 66 0f 1f 44 00 00 48 83 ec 08 f6 87 61 05 00 00 08 75 33 31 d2 eb 0a 0f 1f 80 00 00 00 00 48 89 fa 48 8b 47 10 <48> 8b 78 38 48 85 ff 74 28 f6 87 61 05 00 00 08 74 e7 48 89 f8 
>> [  178.897037] RIP  [<ffffffff80365eaf>] pci_find_upstream_pcie_bridge+0x1f/0x90
>> [  178.897039]  RSP <ffff8101274c5ab8>
>> [  178.897040] CR2: 0000000000000038
>> [  178.897052] ---[ end trace 7b6f6a98638f4938 ]---
>> [  284.698121] hub 2-0:1.0: unable to enumerate USB device on port 5
>> [  284.955475] usb 8-1: new low speed USB device using uhci_hcd and address 2
>> [  284.981012] usb 8-1: configuration #1 chosen from 1 choice
>> [  285.136760] usb 8-1: New USB device found, idVendor=099a, idProduct=7202
>> [  285.137019] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [  285.137303] usb 8-1: Product: WirelessUSB
>> [  285.137463] usb 8-1: Manufacturer: Cypress
>> [  285.137463] usbcore: registered new interface driver hiddev
>> [  285.149652] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input3
>> [  285.173438] input,hidraw0: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1d.2-1
>> [  285.226367] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input4
>> [  285.262793] input,hiddev0,hidraw1: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1d.2-1
>> [  285.263207] usbcore: registered new interface driver usbhid
>> [  285.263424] usbhid: v2.6:USB HID core driver
>> [  306.234631] [drm] Initialized drm 1.1.0 20060810
>> [  306.247214] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
>> [  306.247220] PCI: Setting latency timer of device 0000:00:02.0 to 64
>> [  306.247548] [drm] Initialized i915 1.6.0 20060119 on minor 0
>> [  306.637408] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
>> [  306.886778] set status page addr 0x00033000
>> [  306.886792] Overlap at 0xd0000000-0xe0000000
>>
>>
>> ...
>>
>> It seems parport* is orphaned , I will add Andrew to CC , maybe he knows someone who still cares about =)
>>
>>
>> Regards,
>>
>> Gabriel
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
