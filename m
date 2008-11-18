Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYKRQVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYKRQVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYKRQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:20:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30768 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYKRQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:20:36 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=yYlPK8d0lwwXzHoF0sEA:9 a=eknf7IuqZzQZhs8veDAA:7 a=EXT7JpkkqbFt5yRQsL5Lk3Zq4TgA:4 a=jEp0ucaQiEUA:10
Message-ID: <4922EB4F.8040802@shaw.ca>
Date: Tue, 18 Nov 2008 10:20:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrey Vul <andrey.vul@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, David.Woodhouse@intel.com,
       suresh.b.siddha@intel.com
Subject: Re: jfs problem
References: <e38d12ff0811171408k2e77cf9bt6f89e448194ebe32@mail.gmail.com> <49225703.7060905@shaw.ca> <e38d12ff0811172259s7e75ec68u2a57d3a7ec6ec848@mail.gmail.com>
In-Reply-To: <e38d12ff0811172259s7e75ec68u2a57d3a7ec6ec848@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vul wrote:
> On Tue, Nov 18, 2008 at 00:47, Robert Hancock <hancockr@shaw.ca> wrote:
>> Andrey Vul wrote:
>>> I have a JFS problem occuring randomly. The hardware that this happens
>>> on is an Asus M50VM laptop.
>>>
>>> /dev/sda5 is mounted on /
>>>
>>> Kernel version is 2.6.27.4 with dm-bbr (device mapper - bad block
>>> relocation), fbcondecor, and squashfs patches.
>>>
>>> dmesg:
>>> [  130.405776] DMAR:[DMA Write] Request device [00:1f.2] fault addr
>>> fff9f000
>>> [  130.405780] DMAR:[fault reason 05] PTE Write access is not set
>>> [  130.405828] ERROR: (device sda5): diRead: i_ino != di_number
>>> [  130.406133] ERROR: (device sda5): remounting filesystem as read-only
>>> [  130.406136]
>>> [  130.406146] jfs_lookup: iget failed on inum 188808
>>> [  131.212899] DMAR:[DMA Write] Request device [00:1f.2] fault addr
>>> fff9f000
>>> [  131.212903] DMAR:[fault reason 05] PTE Write access is not set
>>> [  131.212962] ERROR: (device sda5): stack overrun in dtSearch!
>>> [  131.212968] btstack dump:
>>> [  131.212972] bn = 0, index = 0
>>> [  131.212975] bn = 5402c5, index = 0
>>> [  131.212979] bn = 0, index = 0
>>> [  131.212982] bn = 5402c5, index = 0
>>> [  131.212985] bn = 0, index = 0
>>> [  131.212988] bn = 5402c5, index = 0
>>> [  131.212991] bn = 0, index = 0
>>> [  131.212995] bn = fffffffffffffff4, index = 7336
>>> [  131.213015] jfs_lookup: dtSearch returned -5
>> This doesn't look like any JFS problem, more like DMAR is blocking a write
>> request from a controller to an area that it doesn't think should be
>> writable. Can you post dmesg and lspci -vv from bootup?
>>

Well, it's definitely the AHCI SATA controller that's doing the write.. 
CCing some people.


> 00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI
> Controller (rev 03) (prog-if 01 [AHCI 1.0])
>         Subsystem: ASUSTeK Computer Inc. Device 1897
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 374
>         I/O ports at b000 [size=8]
>         I/O ports at ac00 [size=4]
>         I/O ports at a880 [size=8]
>         I/O ports at a800 [size=4]
>         I/O ports at a480 [size=32]
>         Memory at f9fff000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Count=1/16 Enable+
>         Capabilities: [70] Power Management version 3
>         Capabilities: [a8] SATA HBA <?>
>         Capabilities: [b0] PCIe advanced features <?>
>         Kernel driver in use: ahci

> dmesg from bootup:
> [    0.000000] Linux version 2.6.27-gentoo-r2 (root@andrey-laptop)
> (gcc version 4.3.2 (Gentoo 4.3.2 p1.1) ) #6 SMP PREEMPT Mon Nov 17
> 12:51:55 EST 2008
> [    0.000000] Command line: root=/dev/sda5 vga=0x31b ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e1000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff80000 (usable)
> [    0.000000]  BIOS-e820: 00000000bff80000 - 00000000bff8e800 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bff8e800 - 00000000bffe0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bffe0000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> [    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] last_pfn = 0xbff80 max_arch_pfn = 0x3ffffffff
> [    0.000000] init_memory_mapping
> [    0.000000]  0000000000 - 00bfe00000 page 2M
> [    0.000000]  00bfe00000 - 00bff80000 page 4k
> [    0.000000] kernel direct mapping tables up to bff80000 @ 8000-d000
> [    0.000000] last_map_addr: bff80000 end: bff80000
> [    0.000000] init_memory_mapping
> [    0.000000]  0100000000 - 0140000000 page 2M
> [    0.000000] kernel direct mapping tables up to 140000000 @ b000-11000
> [    0.000000] last_map_addr: 140000000 end: 140000000
> [    0.000000] DMI 2.5 present.
> [    0.000000] ACPI: RSDP 000F9370, 0024 (r2 ACPIAM)
> [    0.000000] ACPI: XSDT BFF80100, 0084 (r1 _ASUS_ Notebook 20080701
> MSFT       97)
> [    0.000000] ACPI: FACP BFF80290, 00F4 (r3 070108 FACP1731 20080701
> MSFT       97)
> [    0.000000] ACPI: DSDT BFF80680, BD06 (r1  M50V0 M50V0204      204
> INTL 20051117)
> [    0.000000] ACPI: FACS BFF8E800, 0040
> [    0.000000] ACPI: APIC BFF80390, 005C (r1 070108 APIC1731 20080701
> MSFT       97)
> [    0.000000] ACPI: MCFG BFF80430, 003C (r1 070108 OEMMCFG  20080701
> MSFT       97)
> [    0.000000] ACPI: SLIC BFF80470, 0176 (r1 _ASUS_ Notebook 20080701
> MSFT       97)
> [    0.000000] ACPI: ECDT BFF80620, 0054 (r1 070108 OEMECDT  20080701
> MSFT       97)
> [    0.000000] ACPI: DBGP BFF803F0, 0034 (r1 070108 DBGP1731 20080701
> MSFT       97)
> [    0.000000] ACPI: BOOT BFF805F0, 0028 (r1 070108 BOOT1731 20080701
> MSFT       97)
> [    0.000000] ACPI: OEMB BFF8E840, 0071 (r1 070108 OEMB1731 20080701
> MSFT       97)
> [    0.000000] ACPI: HPET BFF8C390, 0038 (r1 070108 OEMHPET  20080701
> MSFT       97)
> [    0.000000] ACPI: DMAR BFF8E8C0, 0108 (r1 070108 DMAR1731 20080701
> MSFT       97)
> [    0.000000] ACPI: ATKG BFF8EBD0, 8024 (r1 022008  OEMATKG 20080220
> MSFT       97)
> [    0.000000] ACPI: SSDT BFF97720, 04F0 (r1  PmRef    CpuPm     3000
> INTL 20051117)
> [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 0140000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
> [0000006000 - 0000008000]
> [    0.000000]   #2 [0001000000 - 00017a68bc]    TEXT DATA BSS ==>
> [0001000000 - 00017a68bc]
> [    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==>
> [000009ec00 - 0000100000]
> [    0.000000]   #4 [0000008000 - 000000b000]          PGTABLE ==>
> [0000008000 - 000000b000]
> [    0.000000]   #5 [000000b000 - 000000c000]          PGTABLE ==>
> [000000b000 - 000000c000]
> [    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
> [    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD ->
> [ffff880028200000-ffff88002c7fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00140000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009e
> [    0.000000]     0: 0x00000100 -> 0x000bff80
> [    0.000000]     0: 0x00100000 -> 0x00140000
> [    0.000000] On node 0 totalpages: 1048350
> [    0.000000]   DMA zone: 3836 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 767928 pages, LIFO batch:31
> [    0.000000]   Normal zone: 258560 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e1000
> [    0.000000] PM: Registered nosave memory: 00000000000e1000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000bff80000 - 00000000bff8e000
> [    0.000000] PM: Registered nosave memory: 00000000bff8e000 - 00000000bff8f000
> [    0.000000] PM: Registered nosave memory: 00000000bff8f000 - 00000000bffe0000
> [    0.000000] PM: Registered nosave memory: 00000000bffe0000 - 00000000c0000000
> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
> [    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at c4000000 (gap:
> c0000000:3ee00000)
> [    0.000000] PERCPU: Allocating 46496 bytes of per cpu data
> [    0.000000] NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 1030324
> [    0.000000] Kernel command line: root=/dev/sda5 vga=0x31b ro
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] TSC: PIT calibration confirmed by PMTIMER.
> [    0.000000] TSC: using PMTIMER calibration value
> [    0.000000] Detected 2527.260 MHz processor.
> [    0.000999] Console: colour dummy device 80x25
> [    0.000999] console [tty0] enabled
> [    0.000999] Dentry cache hash table entries: 524288 (order: 10,
> 4194304 bytes)
> [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000999] Checking aperture...
> [    0.000999] No AGP bridge found
> [    0.000999] Memory: 4106568k/5242880k available (4434k kernel code,
> 85988k reserved, 2271k data, 360k init)
> [    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
> [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
> CPUs=2, Nodes=1
> [    0.000999] hpet clockevent registered
> [    0.000999] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 5054.52 BogoMIPS (lpj=2527260)
> [    0.000999] Security Framework initialized
> [    0.000999] Mount-cache hash table entries: 256
> [    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.000999] CPU: L2 cache: 6144K
> [    0.000999] CPU: Physical Processor ID: 0
> [    0.000999] CPU: Processor Core ID: 0
> [    0.000999] using mwait in idle threads.
> [    0.000999] ACPI: Core revision 20080609
> [    0.016394] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.027130] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
> [    0.027137] Using local APIC timer interrupts.
> [    0.027997] APIC timer calibration result 16626689
> [    0.027998] Detected 16.626 MHz APIC timer.
> [    0.028096] Booting processor 1/1 ip 6000
> [    0.000999] Initializing CPU#1
> [    0.000999] Calibrating delay using timer specific routine..
> 7076.06 BogoMIPS (lpj=3538034)
> [    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.000999] CPU: L2 cache: 6144K
> [    0.000999] CPU: Physical Processor ID: 0
> [    0.000999] CPU: Processor Core ID: 1
> [    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.100581] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
> [    0.100622] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.100998] Brought up 2 CPUs
> [    0.101002] Total of 2 processors activated (12130.58 BogoMIPS).
> [    0.101072] khelper used greatest stack depth: 6016 bytes left
> [    0.101072] net_namespace: 1504 bytes
> [    0.102037] Time:  1:38:58  Date: 11/18/08
> [    0.102060] NET: Registered protocol family 16
> [    0.102078] No dock devices found.
> [    0.102091] ACPI FADT declares the system doesn't support PCIe
> ASPM, so disable it
> [    0.102097] ACPI: bus type pci registered
> [    0.102108] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.102108] PCI: Not using MMCONFIG.
> [    0.102108] PCI: Using configuration type 1 for base access
> [    0.105602] ACPI: EC: EC description table is found, configuring boot EC
> [    0.110214] ACPI: BIOS _OSI(Linux) query ignored
> [    0.110219] ACPI: DMI System Vendor: ASUSTeK Computer Inc.
> [    0.110224] ACPI: DMI Product Name: M50Vm
> [    0.110227] ACPI: DMI Product Version: 1.0
> [    0.110231] ACPI: DMI Board Name: M50Vm
> [    0.110234] ACPI: DMI BIOS Vendor: American Megatrends Inc.
> [    0.110238] ACPI: DMI BIOS Date: 07/01/2008
> [    0.110242] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
> [    0.110246] ACPI: If "acpi_osi=Linux" works better, please notify
> linux-acpi@vger.kernel.org
> [    0.115167] ACPI: Interpreter enabled
> [    0.115172] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.115194] ACPI: Using IOAPIC for interrupt routing
> [    0.115305] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.119137] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.123452] PCI: Using MMCONFIG at e0000000 - efffffff
> [    0.134137] ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
> [    0.134143] ACPI: EC: driver started in poll mode
> [    0.134177] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.135050] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.135057] pci 0000:00:01.0: PME# disabled
> [    0.135150] PCI: 0000:00:1a.0 reg 20 io port: [bc00, bc1f]
> [    0.135235] PCI: 0000:00:1a.1 reg 20 io port: [b880, b89f]
> [    0.135320] PCI: 0000:00:1a.2 reg 20 io port: [b800, b81f]
> [    0.135404] PCI: 0000:00:1a.7 reg 10 32bit mmio: [f9fffc00, f9ffffff]
> [    0.135463] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.135470] pci 0000:00:1a.7: PME# disabled
> [    0.135517] PCI: 0000:00:1b.0 reg 10 64bit mmio: [f9ff8000, f9ffbfff]
> [    0.135569] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.135576] pci 0000:00:1b.0: PME# disabled
> [    0.135645] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.135653] pci 0000:00:1c.0: PME# disabled
> [    0.135722] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.135729] pci 0000:00:1c.1: PME# disabled
> [    0.135798] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.135805] pci 0000:00:1c.2: PME# disabled
> [    0.135874] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.135882] pci 0000:00:1c.3: PME# disabled
> [    0.135985] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.135993] pci 0000:00:1c.4: PME# disabled
> [    0.136061] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.136068] pci 0000:00:1c.5: PME# disabled
> [    0.136130] PCI: 0000:00:1d.0 reg 20 io port: [b480, b49f]
> [    0.136214] PCI: 0000:00:1d.1 reg 20 io port: [b400, b41f]
> [    0.136298] PCI: 0000:00:1d.2 reg 20 io port: [b080, b09f]
> [    0.136382] PCI: 0000:00:1d.7 reg 10 32bit mmio: [f9fff800, f9fffbff]
> [    0.136440] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.136447] pci 0000:00:1d.7: PME# disabled
> [    0.136653] PCI: 0000:00:1f.2 reg 10 io port: [b000, b007]
> [    0.136661] PCI: 0000:00:1f.2 reg 14 io port: [ac00, ac03]
> [    0.136668] PCI: 0000:00:1f.2 reg 18 io port: [a880, a887]
> [    0.136675] PCI: 0000:00:1f.2 reg 1c io port: [a800, a803]
> [    0.136682] PCI: 0000:00:1f.2 reg 20 io port: [a480, a49f]
> [    0.136690] PCI: 0000:00:1f.2 reg 24 32bit mmio: [f9fff000, f9fff7ff]
> [    0.136723] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.136730] pci 0000:00:1f.2: PME# disabled
> [    0.136810] PCI: 0000:01:00.0 reg 10 32bit mmio: [fc000000, fcffffff]
> [    0.136824] PCI: 0000:01:00.0 reg 14 32bit mmio: [d0000000, dfffffff]
> [    0.136850] PCI: 0000:01:00.0 reg 1c 64bit mmio: [fa000000, fbffffff]
> [    0.136865] PCI: 0000:01:00.0 reg 24 io port: [cc00, cc7f]
> [    0.136878] PCI: 0000:01:00.0 reg 30 32bit mmio: [0, 7ffff]
> [    0.136964] PCI: bridge 0000:00:01.0 io port: [c000, cfff]
> [    0.136967] PCI: bridge 0000:00:01.0 32bit mmio: [fa000000, fdefffff]
> [    0.136971] PCI: bridge 0000:00:01.0 64bit mmio pref: [d0000000, dfffffff]
> [    0.137147] PCI: 0000:03:00.0 reg 10 64bit mmio: [fdffe000, fdffffff]
> [    0.137264] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.137278] pci 0000:03:00.0: PME# disabled
> [    0.137331] PCI: bridge 0000:00:1c.1 32bit mmio: [fdf00000, fdffffff]
> [    0.137393] PCI: bridge 0000:00:1c.2 io port: [d000, dfff]
> [    0.137398] PCI: bridge 0000:00:1c.2 32bit mmio: [fe000000, fe9fffff]
> [    0.137405] PCI: bridge 0000:00:1c.2 64bit mmio pref: [f6000000, f8efffff]
> [    0.137691] PCI: 0000:08:00.0 reg 10 io port: [e800, e8ff]
> [    0.137738] PCI: 0000:08:00.0 reg 18 32bit mmio: [f8fff000, f8ffffff]
> [    0.137785] PCI: 0000:08:00.0 reg 20 32bit mmio: [f8fe0000, f8feffff]
> [    0.137839] PCI: 0000:08:00.0 reg 30 32bit mmio: [feaf0000, feafffff]
> [    0.137947] pci 0000:08:00.0: supports D1
> [    0.137948] pci 0000:08:00.0: supports D2
> [    0.137949] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.137967] pci 0000:08:00.0: PME# disabled
> [    0.138020] PCI: bridge 0000:00:1c.5 io port: [e000, efff]
> [    0.138024] PCI: bridge 0000:00:1c.5 32bit mmio: [fea00000, feafffff]
> [    0.138032] PCI: bridge 0000:00:1c.5 64bit mmio pref: [f8f00000, f8ffffff]
> [    0.138074] PCI: 0000:09:01.0 reg 10 32bit mmio: [febff800, febfffff]
> [    0.138127] pci 0000:09:01.0: PME# supported from D0 D3hot D3cold
> [    0.138134] pci 0000:09:01.0: PME# disabled
> [    0.138170] PCI: 0000:09:01.1 reg 10 32bit mmio: [febff400, febff4ff]
> [    0.138222] pci 0000:09:01.1: supports D1
> [    0.138223] pci 0000:09:01.1: supports D2
> [    0.138225] pci 0000:09:01.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.138232] pci 0000:09:01.1: PME# disabled
> [    0.138268] PCI: 0000:09:01.2 reg 10 32bit mmio: [febff000, febff0ff]
> [    0.138320] pci 0000:09:01.2: supports D1
> [    0.138321] pci 0000:09:01.2: supports D2
> [    0.138323] pci 0000:09:01.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.138330] pci 0000:09:01.2: PME# disabled
> [    0.138366] PCI: 0000:09:01.3 reg 10 32bit mmio: [febfec00, febfecff]
> [    0.138417] pci 0000:09:01.3: supports D1
> [    0.138418] pci 0000:09:01.3: supports D2
> [    0.138420] pci 0000:09:01.3: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.138427] pci 0000:09:01.3: PME# disabled
> [    0.138481] pci 0000:00:1e.0: transparent bridge
> [    0.138490] PCI: bridge 0000:00:1e.0 32bit mmio: [feb00000, febfffff]
> [    0.138541] bus 00 -> node 0
> [    0.138549] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.138850] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.138977] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
> [    0.139095] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.139248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> [    0.139387] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [    0.139503] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
> [    0.167118] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12)
> [    0.167287] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 10 12)
> [    0.167452] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
> [    0.168091] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 12)
> [    0.168258] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
> [    0.168424] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 12)
> [    0.168590] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 12)
> [    0.168756] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 12)
> [    0.171548] ACPI Warning (tbutils-0217): Incorrect checksum in
> table [ATKG] - CC, should be E5 [20080609]
> [    0.171599] ACPI: WMI: Mapper loaded
> [    0.171599] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    0.171599] pnp: PnP ACPI init
> [    0.171599] ACPI: bus type pnp registered
> [    0.175197] pnp: PnP ACPI: found 16 devices
> [    0.175201] ACPI: ACPI bus type pnp unregistered
> [    0.175213] SCSI subsystem initialized
> [    0.175213] libata version 3.00 loaded.
> [    0.175213] usbcore: registered new interface driver usbfs
> [    0.175213] usbcore: registered new interface driver hub
> [    0.175213] usbcore: registered new device driver usb
> [    0.175213] PCI: Using ACPI for IRQ routing
> [    0.184979] NetLabel: Initializing
> [    0.184983] NetLabel:  domain hash size = 128
> [    0.184986] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.184998] NetLabel:  unlabeled traffic allowed by default
> [    0.185003] DMAR:Host address width 36
> [    0.185007] DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
> [    0.185012] DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
> [    0.185017] DMAR:RMRR base: 0x00000000000e1000 end: 0x00000000000e3fff
> [    0.185025] DMAR:RMRR base: 0x00000000bfff0000 end: 0x00000000bfffffff
> [    0.185069] IOMMU: Setting identity map for device 0000:00:1d.0
> [0xbfff0000 - 0xc0000000]
> [    0.185101] IOMMU: Setting identity map for device 0000:00:1d.1
> [0xbfff0000 - 0xc0000000]
> [    0.185125] IOMMU: Setting identity map for device 0000:00:1d.2
> [0xbfff0000 - 0xc0000000]
> [    0.185149] IOMMU: Setting identity map for device 0000:00:1d.7
> [0xbfff0000 - 0xc0000000]
> [    0.185173] IOMMU: Setting identity map for device 0000:00:1a.0
> [0xbfff0000 - 0xc0000000]
> [    0.185196] IOMMU: Setting identity map for device 0000:00:1a.1
> [0xbfff0000 - 0xc0000000]
> [    0.185220] IOMMU: Setting identity map for device 0000:00:1a.2
> [0xbfff0000 - 0xc0000000]
> [    0.185243] IOMMU: Setting identity map for device 0000:00:1a.7
> [0xbfff0000 - 0xc0000000]
> [    0.185266] IOMMU: Setting identity map for device 0000:00:1d.0
> [0xe1000 - 0xe4000]
> [    0.185279] IOMMU: Setting identity map for device 0000:00:1d.1
> [0xe1000 - 0xe4000]
> [    0.185292] IOMMU: Setting identity map for device 0000:00:1d.2
> [0xe1000 - 0xe4000]
> [    0.185305] IOMMU: Setting identity map for device 0000:00:1d.7
> [0xe1000 - 0xe4000]
> [    0.185323] IOMMU: Setting identity map for device 0000:00:1a.0
> [0xe1000 - 0xe4000]
> [    0.185337] IOMMU: Setting identity map for device 0000:00:1a.1
> [0xe1000 - 0xe4000]
> [    0.185350] IOMMU: Setting identity map for device 0000:00:1a.2
> [0xe1000 - 0xe4000]
> [    0.185363] IOMMU: Setting identity map for device 0000:00:1a.7
> [0xe1000 - 0xe4000]
> [    0.185387] IOMMU: gfx device 0000:01:00.0 1-1 mapping
> [    0.185391] IOMMU: Setting identity map for device 0000:01:00.0
> [0x0 - 0x9e000]
> [    0.185455] IOMMU: Setting identity map for device 0000:01:00.0
> [0x100000 - 0xbff80000]
> [    0.401687] IOMMU: Setting identity map for device 0000:01:00.0
> [0x100000000 - 0x140000000]
> [    0.474350] IOMMU: Prepare 0-16M unity mapping for LPC
> [    0.474357] IOMMU: Setting identity map for device 0000:00:1f.0
> [0x0 - 0x1000000]
> [    0.475528] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> [    0.475551] PCI-GART: No AMD northbridge found.
> [    0.475560] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.475567] hpet0: 4 64-bit timers, 14318180 Hz
> [    0.476973] ACPI: RTC can wake from S4
> [    0.481942] system 00:01: iomem range 0xfed10000-0xfed19fff has been reserved
> [    0.481956] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    0.481962] system 00:08: ioport range 0x800-0x87f has been reserved
> [    0.481967] system 00:08: ioport range 0x400-0x41f has been reserved
> [    0.481972] system 00:08: ioport range 0x500-0x57f has been reserved
> [    0.481978] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.481983] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.481989] system 00:08: iomem range 0xfed45000-0xfed89fff has been reserved
> [    0.481994] system 00:08: iomem range 0xfed90000-0xfed90fff has been reserved
> [    0.482000] system 00:08: iomem range 0xfed91000-0xfed91fff has been reserved
> [    0.482005] system 00:08: iomem range 0xfed92000-0xfed92fff has been reserved
> [    0.482011] system 00:08: iomem range 0xfed93000-0xfed93fff has been reserved
> [    0.482017] system 00:08: iomem range 0xffb00000-0xffbfffff could
> not be reserved
> [    0.482023] system 00:08: iomem range 0xfff00000-0xffffffff could
> not be reserved
> [    0.482033] system 00:0a: iomem range 0xffa00000-0xffbfffff could
> not be reserved
> [    0.482039] system 00:0a: iomem range 0xffe00000-0xffffffff could
> not be reserved
> [    0.482048] system 00:0b: iomem range 0xffc00000-0xffdfffff could
> not be reserved
> [    0.482057] system 00:0c: ioport range 0x250-0x253 has been reserved
> [    0.482062] system 00:0c: ioport range 0x256-0x25f has been reserved
> [    0.482067] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
> [    0.482073] system 00:0c: iomem range 0xfee00000-0xfee00fff could
> not be reserved
> [    0.482079] system 00:0c: iomem range 0xfec10000-0xfec17fff has been reserved
> [    0.482090] system 00:0c: iomem range 0xfec18000-0xfec1ffff has been reserved
> [    0.482096] system 00:0c: iomem range 0xfec20000-0xfec27fff has been reserved
> [    0.482101] system 00:0c: iomem range 0xfec28000-0xfec2ffff has been reserved
> [    0.482107] system 00:0c: iomem range 0xfec30000-0xfec37fff has been reserved
> [    0.482112] system 00:0c: iomem range 0xfec38000-0xfec3ffff has been reserved
> [    0.482121] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.482130] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
> [    0.482135] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
> [    0.482141] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
> [    0.482146] system 00:0f: iomem range 0x100000-0xbfffffff could not
> be reserved
> [    0.486875] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    0.486881] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
> [    0.486887] pci 0000:00:01.0:   MEM window: 0xfa000000-0xfdefffff
> [    0.486893] pci 0000:00:01.0:   PREFETCH window:
> 0x000000d0000000-0x000000dfffffff
> [    0.486901] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
> [    0.486905] pci 0000:00:1c.0:   IO window: disabled
> [    0.486913] pci 0000:00:1c.0:   MEM window: disabled
> [    0.486920] pci 0000:00:1c.0:   PREFETCH window: disabled
> [    0.486932] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
> [    0.486936] pci 0000:00:1c.1:   IO window: disabled
> [    0.486944] pci 0000:00:1c.1:   MEM window: 0xfdf00000-0xfdffffff
> [    0.486952] pci 0000:00:1c.1:   PREFETCH window: disabled
> [    0.486961] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
> [    0.486967] pci 0000:00:1c.2:   IO window: 0xd000-0xdfff
> [    0.486976] pci 0000:00:1c.2:   MEM window: 0xfe000000-0xfe9fffff
> [    0.486983] pci 0000:00:1c.2:   PREFETCH window:
> 0x000000f6000000-0x000000f8efffff
> [    0.486995] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:06
> [    0.486999] pci 0000:00:1c.3:   IO window: disabled
> [    0.487007] pci 0000:00:1c.3:   MEM window: disabled
> [    0.487013] pci 0000:00:1c.3:   PREFETCH window: disabled
> [    0.487023] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
> [    0.487028] pci 0000:00:1c.4:   IO window: disabled
> [    0.487035] pci 0000:00:1c.4:   MEM window: disabled
> [    0.487042] pci 0000:00:1c.4:   PREFETCH window: disabled
> [    0.487052] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
> [    0.487058] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
> [    0.487066] pci 0000:00:1c.5:   MEM window: 0xfea00000-0xfeafffff
> [    0.487074] pci 0000:00:1c.5:   PREFETCH window:
> 0x000000f8f00000-0x000000f8ffffff
> [    0.487086] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
> [    0.487090] pci 0000:00:1e.0:   IO window: disabled
> [    0.487098] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
> [    0.487105] pci 0000:00:1e.0:   PREFETCH window: disabled
> [    0.487123] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.487129] pci 0000:00:01.0: setting latency timer to 64
> [    0.487137] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.487144] pci 0000:00:1c.0: setting latency timer to 64
> [    0.487154] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    0.487161] pci 0000:00:1c.1: setting latency timer to 64
> [    0.487169] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.487177] pci 0000:00:1c.2: setting latency timer to 64
> [    0.487186] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    0.487194] pci 0000:00:1c.3: setting latency timer to 64
> [    0.487202] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.487209] pci 0000:00:1c.4: setting latency timer to 64
> [    0.487218] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    0.487225] pci 0000:00:1c.5: setting latency timer to 64
> [    0.487233] pci 0000:00:1e.0: setting latency timer to 64
> [    0.487237] bus: 00 index 0 io port: [0, ffff]
> [    0.487240] bus: 00 index 1 mmio: [0, ffffffffffffffff]
> [    0.487245] bus: 01 index 0 io port: [c000, cfff]
> [    0.487249] bus: 01 index 1 mmio: [fa000000, fdefffff]
> [    0.487253] bus: 01 index 2 mmio: [d0000000, dfffffff]
> [    0.487257] bus: 01 index 3 mmio: [0, 0]
> [    0.487260] bus: 02 index 0 mmio: [0, 0]
> [    0.487264] bus: 02 index 1 mmio: [0, 0]
> [    0.487267] bus: 02 index 2 mmio: [0, 0]
> [    0.487270] bus: 02 index 3 mmio: [0, 0]
> [    0.487274] bus: 03 index 0 mmio: [0, 0]
> [    0.487277] bus: 03 index 1 mmio: [fdf00000, fdffffff]
> [    0.487281] bus: 03 index 2 mmio: [0, 0]
> [    0.487284] bus: 03 index 3 mmio: [0, 0]
> [    0.487288] bus: 04 index 0 io port: [d000, dfff]
> [    0.487292] bus: 04 index 1 mmio: [fe000000, fe9fffff]
> [    0.487296] bus: 04 index 2 mmio: [f6000000, f8efffff]
> [    0.487300] bus: 04 index 3 mmio: [0, 0]
> [    0.487303] bus: 06 index 0 mmio: [0, 0]
> [    0.487307] bus: 06 index 1 mmio: [0, 0]
> [    0.487310] bus: 06 index 2 mmio: [0, 0]
> [    0.487314] bus: 06 index 3 mmio: [0, 0]
> [    0.487317] bus: 07 index 0 mmio: [0, 0]
> [    0.487320] bus: 07 index 1 mmio: [0, 0]
> [    0.487324] bus: 07 index 2 mmio: [0, 0]
> [    0.487327] bus: 07 index 3 mmio: [0, 0]
> [    0.487330] bus: 08 index 0 io port: [e000, efff]
> [    0.487334] bus: 08 index 1 mmio: [fea00000, feafffff]
> [    0.487338] bus: 08 index 2 mmio: [f8f00000, f8ffffff]
> [    0.487342] bus: 08 index 3 mmio: [0, 0]
> [    0.487346] bus: 09 index 0 mmio: [0, 0]
> [    0.487349] bus: 09 index 1 mmio: [feb00000, febfffff]
> [    0.487353] bus: 09 index 2 mmio: [0, 0]
> [    0.487357] bus: 09 index 3 io port: [0, ffff]
> [    0.487360] bus: 09 index 4 mmio: [0, ffffffffffffffff]
> [    0.487371] NET: Registered protocol family 2
> [    0.498964] IP route cache hash table entries: 131072 (order: 8,
> 1048576 bytes)
> [    0.499248] TCP established hash table entries: 262144 (order: 10,
> 4194304 bytes)
> [    0.500207] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.500500] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.500505] TCP reno registered
> [    0.500589] Switched to high resolution mode on CPU 1
> [    0.500929] Switched to high resolution mode on CPU 0
> [    0.503062] NET: Registered protocol family 1
> [    0.503183] Simple Boot Flag at 0x51 set to 0x1
> [    0.503700] IA-32 Microcode Update Driver: v1.14a
> <tigran@aivazian.fsnet.co.uk>
> [    0.504106] audit: initializing netlink socket (disabled)
> [    0.504123] type=2000 audit(1226972338.504:1): initialized
> [    0.504438] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.506368] VFS: Disk quotas dquot_6.5.1
> [    0.506432] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.507125] fuse init (API version 7.9)
> [    0.507376] JFS: nTxBlock = 8192, nTxLock = 65536
> [    0.510247] msgmni has been set to 8022
> [    0.510495] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 253)
> [    0.510502] io scheduler noop registered
> [    0.510505] io scheduler anticipatory registered
> [    0.510509] io scheduler deadline registered
> [    0.510565] io scheduler cfq registered (default)
> [    0.510585] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
> [    0.510587] pci 0000:00:1a.0: Performing full reset
> [    0.510606] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
> [    0.510607] pci 0000:00:1a.1: Performing full reset
> [    0.510626] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
> [    0.510628] pci 0000:00:1a.2: Performing full reset
> [    0.510675] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
> [    0.510677] pci 0000:00:1d.0: Performing full reset
> [    0.510695] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
> [    0.510697] pci 0000:00:1d.1: Performing full reset
> [    0.510715] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
> [    0.510717] pci 0000:00:1d.2: Performing full reset
> [    0.510782] pci 0000:01:00.0: Boot video device
> [    0.510881] pcieport-driver 0000:00:01.0: setting latency timer to 64
> [    0.510908] pcieport-driver 0000:00:01.0: found MSI capability
> [    0.510937] pci_express 0000:00:01.0:pcie00: allocate port service
> [    0.510971] pci_express 0000:00:01.0:pcie02: allocate port service
> [    0.511003] pci_express 0000:00:01.0:pcie03: allocate port service
> [    0.511081] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    0.511126] pcieport-driver 0000:00:1c.0: found MSI capability
> [    0.511174] pci_express 0000:00:1c.0:pcie00: allocate port service
> [    0.511207] pci_express 0000:00:1c.0:pcie03: allocate port service
> [    0.511309] pcieport-driver 0000:00:1c.1: setting latency timer to 64
> [    0.511353] pcieport-driver 0000:00:1c.1: found MSI capability
> [    0.511402] pci_express 0000:00:1c.1:pcie00: allocate port service
> [    0.511433] pci_express 0000:00:1c.1:pcie03: allocate port service
> [    0.511533] pcieport-driver 0000:00:1c.2: setting latency timer to 64
> [    0.511579] pcieport-driver 0000:00:1c.2: found MSI capability
> [    0.511627] pci_express 0000:00:1c.2:pcie00: allocate port service
> [    0.511659] pci_express 0000:00:1c.2:pcie02: allocate port service
> [    0.511690] pci_express 0000:00:1c.2:pcie03: allocate port service
> [    0.511787] pcieport-driver 0000:00:1c.3: setting latency timer to 64
> [    0.511833] pcieport-driver 0000:00:1c.3: found MSI capability
> [    0.511881] pci_express 0000:00:1c.3:pcie00: allocate port service
> [    0.511911] pci_express 0000:00:1c.3:pcie02: allocate port service
> [    0.511942] pci_express 0000:00:1c.3:pcie03: allocate port service
> [    0.512040] pcieport-driver 0000:00:1c.4: setting latency timer to 64
> [    0.512083] pcieport-driver 0000:00:1c.4: found MSI capability
> [    0.512133] pci_express 0000:00:1c.4:pcie00: allocate port service
> [    0.512166] pci_express 0000:00:1c.4:pcie03: allocate port service
> [    0.512267] pcieport-driver 0000:00:1c.5: setting latency timer to 64
> [    0.512310] pcieport-driver 0000:00:1c.5: found MSI capability
> [    0.512358] pci_express 0000:00:1c.5:pcie00: allocate port service
> [    0.512389] pci_express 0000:00:1c.5:pcie03: allocate port service
> [    0.512540] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.512993] pciehp: HPC vendor_id 8086 device_id 2a41 ss_vid 0 ss_did 0
> [    0.513068] hpdriver 0000:00:01.0:pcie02: service driver hpdriver loaded
> [    0.513279] pciehp: HPC vendor_id 8086 device_id 2944 ss_vid 0 ss_did 0
> [    0.513334] hpdriver 0000:00:1c.2:pcie02: service driver hpdriver loaded
> [    0.513538] pciehp: HPC vendor_id 8086 device_id 2946 ss_vid 0 ss_did 0
> [    0.513593] hpdriver 0000:00:1c.3:pcie02: service driver hpdriver loaded
> [    0.513622] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.515966] hpet_resources: 0xfed00000 is busy
> [    0.516068] Non-volatile memory driver v1.2
> [    0.516072] Linux agpgart interface v0.103
> [    0.516410] vesafb: framebuffer at 0xfb000000, mapped to
> 0xffffc20010680000, using 10240k, total 14336k
> [    0.516417] vesafb: mode is 1280x1024x32, linelength=5120, pages=1
> [    0.516422] vesafb: scrolling: redraw
> [    0.516426] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.576794] Console: switching to colour frame buffer device 160x64
> [    0.633370] fb0: VESA VGA frame buffer device
> [    0.633844] ACPI: AC Adapter [AC0] (on-line)
> [    1.456203] ACPI: EC: non-query interrupt received, switching to
> interrupt mode
> [    1.469922] ACPI: Battery Slot [BAT0] (battery present)
> [    1.470488] input: Power Button (FF) as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    1.476005] ACPI: Power Button (FF) [PWRF]
> [    1.476420] input: Sleep Button (CM) as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
> [    1.481050] ACPI: Sleep Button (CM) [SLPB]
> [    1.481512] input: Lid Switch as
> /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
> [    1.486412] ACPI: Lid Switch [LID]
> [    1.487156] ACPI: SSDT BFF96CD0, 0248 (r1  PmRef  Cpu0Ist     3000
> INTL 20051117)
> [    1.488259] ACPI: SSDT BFF96FB0, 0765 (r1  PmRef  Cpu0Cst     3001
> INTL 20051117)
> [    1.489589] Monitor-Mwait will be used to enter C-1 state
> [    1.489591] Monitor-Mwait will be used to enter C-3 state
> [    1.489622] ACPI: CPU0 (power states: C1[C1] C2[C3])
> [    1.490057] processor ACPI0007:00: registered as cooling_device0
> [    1.490475] ACPI: Processor [P001] (supports 8 throttling states)
> [    1.491272] ACPI: SSDT BFF96C00, 00CC (r1  PmRef  Cpu1Ist     3000
> INTL 20051117)
> [    1.492227] ACPI: SSDT BFF96F20, 0085 (r1  PmRef  Cpu1Cst     3000
> INTL 20051117)
> [    1.493651] ACPI: CPU1 (power states: C1[C1] C2[C3])
> [    1.494079] processor ACPI0007:01: registered as cooling_device1
> [    1.494503] ACPI: Processor [P002] (supports 8 throttling states)
> [    1.504047] ACPI: Expecting a [Reference] package element, found type C
> [    1.504599] thermal LNXTHERM:01: registered as thermal_zone0
> [    1.506963] ACPI: Thermal Zone [THRM] (49 C)
> [    1.507322] [drm] Initialized drm 1.1.0 20060810
> [    1.507646] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> [    1.509552] brd: module loaded
> [    1.510308] loop: module loaded
> [    1.510567] asus-laptop: Asus Laptop Support version 0.42
> [    1.514847] asus-laptop:   M50Vm model detected
> [    1.528742] Registered led device: asus::mail
> [    1.529077] Registered led device: asus::touchpad
> [    1.529611] Loading iSCSI transport class v2.0-870.
> [    1.530117] Driver 'sd' needs updating - please use bus_type methods
> [    1.530587] Driver 'sr' needs updating - please use bus_type methods
> [    1.542242] ahci 0000:00:1f.2: version 3.0
> [    1.542255] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.554330] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3
> Gbps 0x23 impl SATA mode
> [    1.566782] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
> clo pio slum part ems
> [    1.579572] ahci 0000:00:1f.2: setting latency timer to 64
> [    1.579794] scsi0 : ahci
> [    1.592686] scsi1 : ahci
> [    1.605609] scsi2 : ahci
> [    1.618583] scsi3 : ahci
> [    1.631607] scsi4 : ahci
> [    1.644660] scsi5 : ahci
> [    1.657907] ata1: SATA max UDMA/133 abar m2048@0xf9fff000 port
> 0xf9fff100 irq 374
> [    1.671638] ata2: SATA max UDMA/133 abar m2048@0xf9fff000 port
> 0xf9fff180 irq 374
> [    1.685394] ata3: DUMMY
> [    1.699184] ata4: DUMMY
> [    1.713029] ata5: DUMMY
> [    1.726918] ata6: SATA max UDMA/133 abar m2048@0xf9fff000 port
> 0xf9fff380 irq 374
> [    2.046022] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.062219] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [    2.077572] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
> [    2.077756] ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
> [    2.078633] ata1.00: ATA-8: Hitachi HTS545050KTA300, BKFOC60G, max UDMA/133
> [    2.094186] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.111574] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> [    2.127949] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
> [    2.128135] ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
> [    2.129017] ata1.00: configured for UDMA/133
> [    2.879016] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.900632] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
> [    2.901094] ata2.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
> [    2.906126] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-T50N, RR04, max
> UDMA/133, ATAPI AN
> [    2.928780] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
> [    2.929241] ata2.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
> [    2.934222] ata2.00: configured for UDMA/133
> [    3.267014] ata6: SATA link down (SStatus 0 SControl 300)
> [    3.295079] scsi 0:0:0:0: Direct-Access     ATA      Hitachi
> HTS54505 BKFO PQ: 0 ANSI: 5
> [    3.312700] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
> [    3.330155] sd 0:0:0:0: [sda] Write Protect is off
> [    3.347349] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.347372] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.364799] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
> [    3.382013] sd 0:0:0:0: [sda] Write Protect is off
> [    3.398892] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.398914] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.415912]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> [    3.502852] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.519449] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.538858] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM
> GSA-T50N  RR04 PQ: 0 ANSI: 5
> [    3.779055] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [    3.796077] Uniform CD-ROM driver Revision: 3.20
> [    3.813015] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.813082] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    3.830136] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
> [    3.830154] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    3.847158] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    3.847161] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    3.864269] drivers/usb/core/inode.c: creating file 'devices'
> [    3.864272] drivers/usb/core/inode.c: creating file '001'
> [    3.864313] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
> bus number 1
> [    3.881436] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1
> cc=3 pcc=2 ordered !ppc ports=6
> [    3.881439] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7
> uframes 1024 64 bit addr
> [    3.881473] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0
> ithresh=8 period=1024 Reset HALT
> [    3.885368] ehci_hcd 0000:00:1a.7: debug port 1
> [    3.902246] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    3.902248] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
> [    3.902259] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
> [    3.919065] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0
> ithresh=8 period=1024 Reset HALT
> [    3.922956] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0
> ithresh=1 period=1024 RUN
> [    3.928006] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00,
> driver 10 Dec 2004
> [    3.944865] usb usb1: default language 0x0409
> [    3.944894] usb usb1: uevent
> [    3.944921] usb usb1: usb_probe_device
> [    3.944923] usb usb1: configuration #1 chosen from 1 choice
> [    3.961714] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [    3.961727] usb 1-0:1.0: uevent
> [    3.961753] hub 1-0:1.0: usb_probe_interface
> [    3.961755] hub 1-0:1.0: usb_probe_interface - got id
> [    3.961757] hub 1-0:1.0: USB hub found
> [    3.978380] hub 1-0:1.0: 6 ports detected
> [    3.994935] hub 1-0:1.0: standalone hub
> [    3.994936] hub 1-0:1.0: no power switching (usb 1.0)
> [    3.994938] hub 1-0:1.0: individual port over-current protection
> [    3.994939] hub 1-0:1.0: power on to power good time: 20ms
> [    3.994943] hub 1-0:1.0: local power source is good
> [    3.994945] hub 1-0:1.0: trying to enable port power on non-switchable hub
> [    4.095019] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001803
> POWER sig=j CSC CONNECT
> [    4.095022] hub 1-0:1.0: port 6: status 0501 change 0001
> [    4.196011] hub 1-0:1.0: state 7 ports 6 chg 0040 evt 0000
> [    4.196072] drivers/usb/core/inode.c: creating file '001'
> [    4.196087] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
> [    4.196124] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.212911] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    4.229736] usb usb1: Product: EHCI Host Controller
> [    4.246607] usb usb1: Manufacturer: Linux 2.6.27-gentoo-r2 ehci_hcd
> [    4.247486] ehci_hcd 0000:00:1a.7: port 6 full speed --> companion
> [    4.247489] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003801
> POWER OWNER sig=j CONNECT
> [    4.247492] hub 1-0:1.0: port 6 not reset yet, waiting 50ms
> [    4.263771] usb usb1: SerialNumber: 0000:00:1a.7
> [    4.280720] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    4.297942] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    4.297945] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    4.298256] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 003002
> POWER OWNER sig=se0 CSC
> [    4.315283] drivers/usb/core/inode.c: creating file '002'
> [    4.315320] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
> bus number 2
> [    4.332789] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1
> cc=3 pcc=2 ordered !ppc ports=6
> [    4.332792] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7
> uframes 1024 64 bit addr
> [    4.332817] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
> ithresh=8 period=1024 Reset HALT
> [    4.336703] ehci_hcd 0000:00:1d.7: debug port 1
> [    4.353902] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    4.353904] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
> [    4.353914] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
> [    4.371349] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
> ithresh=8 period=1024 Reset HALT
> [    4.375238] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0
> ithresh=1 period=1024 RUN
> [    4.380006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
> driver 10 Dec 2004
> [    4.397461] usb usb2: default language 0x0409
> [    4.397489] usb usb2: uevent
> [    4.397515] usb usb2: usb_probe_device
> [    4.397517] usb usb2: configuration #1 chosen from 1 choice
> [    4.414848] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [    4.414860] usb 2-0:1.0: uevent
> [    4.414886] hub 2-0:1.0: usb_probe_interface
> [    4.414888] hub 2-0:1.0: usb_probe_interface - got id
> [    4.414889] hub 2-0:1.0: USB hub found
> [    4.432042] hub 2-0:1.0: 6 ports detected
> [    4.448984] hub 2-0:1.0: standalone hub
> [    4.448985] hub 2-0:1.0: no power switching (usb 1.0)
> [    4.448987] hub 2-0:1.0: individual port over-current protection
> [    4.448988] hub 2-0:1.0: power on to power good time: 20ms
> [    4.448992] hub 2-0:1.0: local power source is good
> [    4.448993] hub 2-0:1.0: trying to enable port power on non-switchable hub
> [    4.549019] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803
> POWER sig=j CSC CONNECT
> [    4.549022] hub 2-0:1.0: port 5: status 0501 change 0001
> [    4.650009] hub 2-0:1.0: state 7 ports 6 chg 0020 evt 0000
> [    4.650048] drivers/usb/core/inode.c: creating file '001'
> [    4.650057] hub 2-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
> [    4.650096] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    4.667507] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    4.685221] usb usb2: Product: EHCI Host Controller
> [    4.701517] ehci_hcd 0000:00:1d.7: port 5 high speed
> [    4.701519] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005
> POWER sig=se0 PE CONNECT
> [    4.703278] usb usb2: Manufacturer: Linux 2.6.27-gentoo-r2 ehci_hcd
> [    4.721462] usb usb2: SerialNumber: 0000:00:1d.7
> [    4.739790] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
> (OHCI) Driver
> [    4.739792] ohci_hcd: block sizes: ed 80 td 96
> [    4.739831] USB Universal Host Controller Interface driver v3.0
> [    4.752257] usb 2-5: new high speed USB device using ehci_hcd and address 2
> [    4.777041] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    4.795926] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    4.795929] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    4.814889] drivers/usb/core/inode.c: creating file '003'
> [    4.814934] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
> bus number 3
> [    4.827520] ehci_hcd 0000:00:1d.7: port 5 high speed
> [    4.827522] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005
> POWER sig=se0 PE CONNECT
> [    4.834406] uhci_hcd 0000:00:1a.0: detected 2 ports
> [    4.853392] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
> [    4.853394] uhci_hcd 0000:00:1a.0: Performing full reset
> [    4.853408] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
> [    4.853418] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bc00
> [    4.872279] usb usb3: default language 0x0409
> [    4.872306] usb usb3: uevent
> [    4.872332] usb usb3: usb_probe_device
> [    4.872334] usb usb3: configuration #1 chosen from 1 choice
> [    4.891180] usb usb3: adding 3-0:1.0 (config #1, interface 0)
> [    4.891192] usb 3-0:1.0: uevent
> [    4.891221] hub 3-0:1.0: usb_probe_interface
> [    4.891222] hub 3-0:1.0: usb_probe_interface - got id
> [    4.891224] hub 3-0:1.0: USB hub found
> [    4.909928] hub 3-0:1.0: 2 ports detected
> [    4.928407] hub 3-0:1.0: standalone hub
> [    4.928409] usb 2-5: skipped 1 descriptor after configuration
> [    4.928411] usb 2-5: skipped 5 descriptors after interface
> [    4.928413] usb 2-5: skipped 1 descriptor after endpoint
> [    4.928415] hub 3-0:1.0: no power switching (usb 1.0)
> [    4.928416] hub 3-0:1.0: individual port over-current protection
> [    4.928418] hub 3-0:1.0: power on to power good time: 2ms
> [    4.928420] usb 2-5: skipped 10 descriptors after interface
> [    4.928421] hub 3-0:1.0: local power source is good
> [    4.928423] hub 3-0:1.0: trying to enable port power on non-switchable hub
> [    4.928529] usb 2-5: default language 0x0409
> [    4.928678] usb 2-5: uevent
> [    4.928707] usb 2-5: usb_probe_device
> [    4.928709] usb 2-5: configuration #1 chosen from 1 choice
> [    4.947280] usb 2-5: adding 2-5:1.0 (config #1, interface 0)
> [    4.947296] usb 2-5:1.0: uevent
> [    4.947359] usb 2-5: adding 2-5:1.1 (config #1, interface 1)
> [    4.947375] usb 2-5:1.1: uevent
> [    4.947436] drivers/usb/core/inode.c: creating file '002'
> [    4.947483] usb 2-5: New USB device found, idVendor=04f2, idProduct=b033
> [    4.966104] usb 2-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    4.984709] usb 2-5: Product: USB2.0 1.3M UVC WebCam
> [    5.029047] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    5.029057] drivers/usb/core/inode.c: creating file '001'
> [    5.029103] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.047603] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.066100] usb usb3: Product: UHCI Host Controller
> [    5.084365] usb usb3: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    5.102570] usb usb3: SerialNumber: 0000:00:1a.0
> [    5.120671] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    5.138975] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    5.138978] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    5.156993] drivers/usb/core/inode.c: creating file '004'
> [    5.157034] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
> bus number 4
> [    5.175155] uhci_hcd 0000:00:1a.1: detected 2 ports
> [    5.175159] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
> [    5.175160] uhci_hcd 0000:00:1a.1: Performing full reset
> [    5.175175] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
> [    5.175185] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
> [    5.175222] usb usb4: default language 0x0409
> [    5.175250] usb usb4: uevent
> [    5.175278] usb usb4: usb_probe_device
> [    5.175280] usb usb4: configuration #1 chosen from 1 choice
> [    5.175284] usb usb4: adding 4-0:1.0 (config #1, interface 0)
> [    5.175297] usb 4-0:1.0: uevent
> [    5.175323] hub 4-0:1.0: usb_probe_interface
> [    5.175324] hub 4-0:1.0: usb_probe_interface - got id
> [    5.175326] hub 4-0:1.0: USB hub found
> [    5.175332] hub 4-0:1.0: 2 ports detected
> [    5.175333] hub 4-0:1.0: standalone hub
> [    5.175334] hub 4-0:1.0: no power switching (usb 1.0)
> [    5.175335] hub 4-0:1.0: individual port over-current protection
> [    5.175336] hub 4-0:1.0: power on to power good time: 2ms
> [    5.175339] hub 4-0:1.0: local power source is good
> [    5.175341] hub 4-0:1.0: trying to enable port power on non-switchable hub
> [    5.276044] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    5.276055] drivers/usb/core/inode.c: creating file '001'
> [    5.276105] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.293537] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.310875] usb usb4: Product: UHCI Host Controller
> [    5.328165] usb usb4: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    5.345430] usb usb4: SerialNumber: 0000:00:1a.1
> [    5.362610] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    5.380053] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    5.380056] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    5.380092] drivers/usb/core/inode.c: creating file '005'
> [    5.380139] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
> bus number 5
> [    5.380145] uhci_hcd 0000:00:1a.2: detected 2 ports
> [    5.380149] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
> [    5.380151] uhci_hcd 0000:00:1a.2: Performing full reset
> [    5.380165] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
> [    5.380175] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
> [    5.380215] usb usb5: default language 0x0409
> [    5.380244] usb usb5: uevent
> [    5.380272] usb usb5: usb_probe_device
> [    5.380274] usb usb5: configuration #1 chosen from 1 choice
> [    5.380277] usb usb5: adding 5-0:1.0 (config #1, interface 0)
> [    5.380289] usb 5-0:1.0: uevent
> [    5.380317] hub 5-0:1.0: usb_probe_interface
> [    5.380318] hub 5-0:1.0: usb_probe_interface - got id
> [    5.380320] hub 5-0:1.0: USB hub found
> [    5.380325] hub 5-0:1.0: 2 ports detected
> [    5.380326] hub 5-0:1.0: standalone hub
> [    5.380327] hub 5-0:1.0: no power switching (usb 1.0)
> [    5.380329] hub 5-0:1.0: individual port over-current protection
> [    5.380330] hub 5-0:1.0: power on to power good time: 2ms
> [    5.380333] hub 5-0:1.0: local power source is good
> [    5.380334] hub 5-0:1.0: trying to enable port power on non-switchable hub
> [    5.481013] uhci_hcd 0000:00:1a.2: port 2 portsc 0093,00
> [    5.481015] hub 5-0:1.0: port 2: status 0101 change 0001
> [    5.582040] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
> [    5.582051] drivers/usb/core/inode.c: creating file '001'
> [    5.582086] hub 5-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
> [    5.582112] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.599296] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.616420] usb usb5: Product: UHCI Host Controller
> [    5.633457] usb usb5: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    5.650635] usb usb5: SerialNumber: 0000:00:1a.2
> [    5.667639] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    5.684873] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    5.684876] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    5.701970] drivers/usb/core/inode.c: creating file '006'
> [    5.702009] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
> bus number 6
> [    5.719246] uhci_hcd 0000:00:1d.0: detected 2 ports
> [    5.736389] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
> [    5.736391] uhci_hcd 0000:00:1d.0: Performing full reset
> [    5.736405] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
> [    5.736408] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b480
> [    5.753588] usb usb6: default language 0x0409
> [    5.753617] usb usb6: uevent
> [    5.753627] usb 5-2: new full speed USB device using uhci_hcd and address 2
> [    5.770814] usb usb6: usb_probe_device
> [    5.770816] usb usb6: configuration #1 chosen from 1 choice
> [    5.787970] usb usb6: adding 6-0:1.0 (config #1, interface 0)
> [    5.787983] usb 6-0:1.0: uevent
> [    5.788016] hub 6-0:1.0: usb_probe_interface
> [    5.788017] hub 6-0:1.0: usb_probe_interface - got id
> [    5.788019] hub 6-0:1.0: USB hub found
> [    5.805183] hub 6-0:1.0: 2 ports detected
> [    5.822107] hub 6-0:1.0: standalone hub
> [    5.822108] hub 6-0:1.0: no power switching (usb 1.0)
> [    5.822110] hub 6-0:1.0: individual port over-current protection
> [    5.822111] hub 6-0:1.0: power on to power good time: 2ms
> [    5.822115] hub 6-0:1.0: local power source is good
> [    5.822117] hub 6-0:1.0: trying to enable port power on non-switchable hub
> [    5.905004] usb 5-2: ep0 maxpacket = 8
> [    5.923057] drivers/usb/core/inode.c: creating file '001'
> [    5.923102] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.940308] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.942225] usb 5-2: default language 0x0409
> [    5.957485] usb usb6: Product: UHCI Host Controller
> [    5.974545] usb usb6: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    5.974567] usb 5-2: uevent
> [    5.991713] usb usb6: SerialNumber: 0000:00:1d.0
> [    5.991733] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    5.991738] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    5.991741] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    5.991795] drivers/usb/core/inode.c: creating file '007'
> [    5.991840] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
> bus number 7
> [    5.991846] uhci_hcd 0000:00:1d.1: detected 2 ports
> [    5.991850] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
> [    5.991852] uhci_hcd 0000:00:1d.1: Performing full reset
> [    5.991867] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
> [    5.991870] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
> [    5.991916] usb usb7: default language 0x0409
> [    5.991949] usb usb7: uevent
> [    5.991977] usb usb7: usb_probe_device
> [    5.991979] usb usb7: configuration #1 chosen from 1 choice
> [    5.991983] usb usb7: adding 7-0:1.0 (config #1, interface 0)
> [    5.991994] usb 7-0:1.0: uevent
> [    5.992027] hub 7-0:1.0: usb_probe_interface
> [    5.992029] hub 7-0:1.0: usb_probe_interface - got id
> [    5.992030] hub 7-0:1.0: USB hub found
> [    5.992037] hub 7-0:1.0: 2 ports detected
> [    5.992038] hub 7-0:1.0: standalone hub
> [    5.992039] hub 7-0:1.0: no power switching (usb 1.0)
> [    5.992040] hub 7-0:1.0: individual port over-current protection
> [    5.992042] hub 7-0:1.0: power on to power good time: 2ms
> [    5.992045] hub 7-0:1.0: local power source is good
> [    5.992046] hub 7-0:1.0: trying to enable port power on non-switchable hub
> [    6.093059] drivers/usb/core/inode.c: creating file '001'
> [    6.093115] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.093117] usb usb7: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    6.093118] usb usb7: Product: UHCI Host Controller
> [    6.093119] usb usb7: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    6.093121] usb usb7: SerialNumber: 0000:00:1d.1
> [    6.093139] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    6.093145] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    6.093148] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    6.093183] drivers/usb/core/inode.c: creating file '008'
> [    6.093227] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
> bus number 8
> [    6.093234] uhci_hcd 0000:00:1d.2: detected 2 ports
> [    6.093238] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
> [    6.093239] uhci_hcd 0000:00:1d.2: Performing full reset
> [    6.093253] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
> [    6.093256] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b080
> [    6.093301] usb usb8: default language 0x0409
> [    6.093329] usb usb8: uevent
> [    6.093357] usb usb8: usb_probe_device
> [    6.093358] usb usb8: configuration #1 chosen from 1 choice
> [    6.093362] usb usb8: adding 8-0:1.0 (config #1, interface 0)
> [    6.093375] usb 8-0:1.0: uevent
> [    6.093403] hub 8-0:1.0: usb_probe_interface
> [    6.093404] hub 8-0:1.0: usb_probe_interface - got id
> [    6.093405] hub 8-0:1.0: USB hub found
> [    6.093414] hub 8-0:1.0: 2 ports detected
> [    6.093415] hub 8-0:1.0: standalone hub
> [    6.093416] hub 8-0:1.0: no power switching (usb 1.0)
> [    6.093417] hub 8-0:1.0: individual port over-current protection
> [    6.093418] hub 8-0:1.0: power on to power good time: 2ms
> [    6.093421] hub 8-0:1.0: local power source is good
> [    6.093422] hub 8-0:1.0: trying to enable port power on non-switchable hub
> [    6.143524] usb 5-2: usb_probe_device
> [    6.143526] usb 5-2: configuration #1 chosen from 1 choice
> [    6.194008] uhci_hcd 0000:00:1d.2: port 1 portsc 0082,00
> [    6.204010] usb usb3: suspend_rh (auto-stop)
> [    6.204066] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
> [    6.204078] usb 5-2:1.0: uevent
> [    6.204195] drivers/usb/core/inode.c: creating file '002'
> [    6.204244] usb 5-2: New USB device found, idVendor=08ff, idProduct=1600
> [    6.204246] usb 5-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    6.204247] usb 5-2: Product: Fingerprint Sensor
> [    6.204249] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    6.204252] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    6.295040] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [    6.295054] drivers/usb/core/inode.c: creating file '001'
> [    6.295110] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.295111] usb usb8: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    6.295113] usb usb8: Product: UHCI Host Controller
> [    6.295114] usb usb8: Manufacturer: Linux 2.6.27-gentoo-r2 uhci_hcd
> [    6.295115] usb usb8: SerialNumber: 0000:00:1d.2
> [    6.295198] usbcore: registered new interface driver usblp
> [    6.295200] Initializing USB Mass Storage driver...
> [    6.295244] usbcore: registered new interface driver usb-storage
> [    6.295246] USB Mass Storage support registered.
> [    6.295292] usbcore: registered new interface driver libusual
> [    6.295375] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
> 0x60,0x64 irq 1,12
> [    6.379009] i8042.c: Detected active multiplexing controller, rev 1.1.
> [    6.380360] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    6.380364] serio: i8042 AUX0 port at 0x60,0x64 irq 12
> [    6.380365] serio: i8042 AUX1 port at 0x60,0x64 irq 12
> [    6.380367] serio: i8042 AUX2 port at 0x60,0x64 irq 12
> [    6.380368] serio: i8042 AUX3 port at 0x60,0x64 irq 12
> [    6.380407] mice: PS/2 mouse device common for all mice
> [    6.454011] usb usb4: suspend_rh (auto-stop)
> [    6.727586] hub 1-0:1.0: hub_suspend
> [    6.727589] usb usb1: bus auto-suspend
> [    6.727590] ehci_hcd 0000:00:1a.7: suspend root hub
> [    6.778025] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input3
> [    6.801908] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    6.818563] rtc0: alarms up to one month, y3k, hpet irqs
> [    6.835361] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
> initialised: dm-devel@redhat.com
> [    6.852559] cpuidle: using governor ladder
> [    6.856252] Marking TSC unstable due to TSC halts in idle
> [    6.887258] cpuidle: using governor menu
> [    6.904526] usbcore: registered new interface driver hiddev
> [    6.921771] usbcore: registered new interface driver usbhid
> [    6.938560] usbhid: v2.6:USB HID core driver
> [    6.955689] Advanced Linux Sound Architecture Driver Version 1.0.17.
> [    6.973081] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
> low) -> IRQ 22
> [    6.990485] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    7.000348] hda_codec: Unknown model for ALC662, trying auto-probe
> from BIOS...
> [    7.026392] hda-codec: No codec parser is available
> [    7.044445] hda-codec: No codec parser is available
> [    7.089073] ALSA device list:
> [    7.105889]   #0: HDA Intel at 0xf9ff8000 irq 22
> [    7.122988] Netfilter messages via NETLINK v0.30.
> [    7.140060] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    7.157363] ctnetlink v0.93: registering with nfnetlink.
> [    7.175166] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    7.192410] TCP cubic registered
> [    7.209580] Initializing XFRM netlink socket
> [    7.227100] usb usb6: suspend_rh (auto-stop)
> [    7.227123] usb usb7: suspend_rh (auto-stop)
> [    7.227227] NET: Registered protocol family 10
> [    7.245047] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    7.262354] IPv6 over IPv4 tunneling driver
> [    7.280015] NET: Registered protocol family 17
> [    7.298051] RPC: Registered udp transport module.
> [    7.314995] RPC: Registered tcp transport module.
> [    7.333858] registered taskstats version 1
> [    7.350570]   Magic number: 0:68:610
> [    7.371959] rtc_cmos 00:03: setting system clock to 2008-11-18
> 01:39:06 UTC (1226972346)
> [    7.454162] usb usb8: suspend_rh (auto-stop)
> [    7.500142] Clocksource tsc unstable (delta = -121800701 ns)
> [    7.704202] hub 3-0:1.0: hub_suspend
> [    7.704210] usb usb3: bus auto-suspend
> [    7.704215] usb usb3: suspend_rh
> [    7.704238] hub 4-0:1.0: hub_suspend
> [    7.704243] usb usb4: bus auto-suspend
> [    7.704247] usb usb4: suspend_rh
> [    7.916795] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x280b1,
> caps: 0xb04711/0x60040d
> [    8.003516] input: SynPS/2 Synaptics TouchPad as
> /devices/platform/i8042/serio4/input/input4
> [    8.100587] md: Autodetecting RAID arrays.
> [    8.144671] md: Scanned 0 and added 0 devices.
> [    8.188667] md: autorun ...
> [    8.232000] md: ... autorun DONE.
> [    8.293513] UDF-fs: No VRS found
> [    8.370976] VFS: Mounted root (jfs filesystem) readonly.
> [    8.413811] Freeing unused kernel memory: 360k freed
> [    8.456918] Write protecting the kernel read-only data: 6212k
> [    8.550700] khelper used greatest stack depth: 4704 bytes left
> [    8.704145] hub 6-0:1.0: hub_suspend
> [    8.704153] usb usb6: bus auto-suspend
> [    8.704158] usb usb6: suspend_rh
> [    8.704182] hub 7-0:1.0: hub_suspend
> [    8.704187] usb usb7: bus auto-suspend
> [    8.704191] usb usb7: suspend_rh
> [    8.704213] hub 8-0:1.0: hub_suspend
> [    8.704219] usb usb8: bus auto-suspend
> [    8.704222] usb usb8: suspend_rh
> [   10.789507] cp used greatest stack depth: 4488 bytes left
> [   11.864380] usb usb3: uevent
> [   11.864420] usb 3-0:1.0: uevent
> [   11.864604] usb usb4: uevent
> [   11.864641] usb 4-0:1.0: uevent
> [   11.864875] usb usb5: uevent
> [   11.864917] usb 5-0:1.0: uevent
> [   11.864990] usb 5-2: uevent
> [   11.865044] usb 5-2:1.0: uevent
> [   11.865291] usb usb1: uevent
> [   11.865328] usb 1-0:1.0: uevent
> [   11.866612] usb usb6: uevent
> [   11.866649] usb 6-0:1.0: uevent
> [   11.866834] usb usb7: uevent
> [   11.866871] usb 7-0:1.0: uevent
> [   11.867074] usb usb8: uevent
> [   11.867111] usb 8-0:1.0: uevent
> [   11.867299] usb usb2: uevent
> [   11.867335] usb 2-0:1.0: uevent
> [   11.867405] usb 2-5: uevent
> [   11.867443] usb 2-5:1.0: uevent
> [   11.867515] usb 2-5:1.1: uevent
> [   12.140398] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [   12.262431] sdhci: Secure Digital Host Controller Interface driver
> [   12.262438] sdhci: Copyright(c) Pierre Ossman
> [   12.270722] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [   12.270754] r8169 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   12.270793] r8169 0000:08:00.0: setting latency timer to 64
> [   12.271544] eth0: RTL8168c/8111c at 0xffffc20000062000,
> 00:22:15:37:1b:b5, XID 3c4000c0 IRQ 373
> [   12.283806] sdhci-pci 0000:09:01.1: SDHCI controller found
> [1180:0822] (rev 22)
> [   12.283818] sdhci-pci 0000:09:01.1: PCI INT B -> GSI 17 (level,
> low) -> IRQ 17
> [   12.286728] Registered led device: mmc0
> [   12.288538] mmc0: SDHCI controller on PCI [0000:09:01.1] using PIO
> [   12.329384] ohci1394 0000:09:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   12.383467] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> Linux, 1.3.27ks
> [   12.383469] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> [   12.388350] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[16]
> MMIO=[febff800-febfffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [   12.392557] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   12.392569] iwlagn 0000:03:00.0: setting latency timer to 64
> [   12.392607] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
> [   12.425516] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   12.426413] iwlagn 0000:03:00.0: PCI INT A disabled
> [   12.426988] phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   12.464145] Linux video capture interface: v2.00
> [   12.632134] uvcvideo 2-5:1.0: usb_probe_interface
> [   12.632142] uvcvideo 2-5:1.0: usb_probe_interface - got id
> [   12.632172] uvcvideo: Found UVC 1.00 device USB2.0 1.3M UVC WebCam
> (04f2:b033)
> [   12.632906] input: USB2.0 1.3M UVC WebCam as
> /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input6
> [   12.638132] usb 2-5: link qh32-0001/ffff88013dcf5140 start 31 [1/0 us]
> [   12.638196] usbcore: registered new interface driver uvcvideo
> [   12.638202] USB Video Class driver (v0.1.0)
> [   13.082388] nvidia: module license 'NVIDIA' taints kernel.
> [   13.337205] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   13.337225] nvidia 0000:01:00.0: setting latency timer to 64
> [   13.337446] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.80
> Wed Oct  1 14:43:46 PDT 2008
> [   13.650787] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c000006ae53]
> [   17.003302] mount used greatest stack depth: 4368 bytes left
> [   19.650434] ip used greatest stack depth: 4264 bytes left
> [   20.104395] r8169: eth0: link up
> [   20.104436] r8169: eth0: link up
> [   27.397203] Adding 4000744k swap on /dev/sda2.  Priority:-1
> extents:1 across:4000744k
> [   29.949701] usb usb3: uevent
> [   29.949828] usb 3-0:1.0: uevent
> [   29.950406] usb usb4: uevent
> [   29.950525] usb 4-0:1.0: uevent
> [   29.951052] usb usb5: uevent
> [   29.951172] usb 5-0:1.0: uevent
> [   29.951387] usb 5-2: uevent
> [   29.951570] usb 5-2:1.0: uevent
> [   29.952379] usb usb1: uevent
> [   29.952502] usb 1-0:1.0: uevent
> [   29.956335] usb usb6: uevent
> [   29.956459] usb 6-0:1.0: uevent
> [   29.956988] usb usb7: uevent
> [   29.957107] usb 7-0:1.0: uevent
> [   29.957649] usb usb8: uevent
> [   29.957769] usb 8-0:1.0: uevent
> [   29.958334] usb usb2: uevent
> [   29.958499] usb 2-0:1.0: uevent
> [   29.958699] usb 2-5: uevent
> [   29.958821] usb 2-5:1.0: uevent
> [   29.959447] usb 2-5:1.1: uevent
> [   30.125010] eth0: no IPv6 routers present
> [   45.806346] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 2905.812299] pciehp: Card present on Slot(16)
> [ 2980.507310] CE: hpet increasing min_delta_ns to 22500 nsec
> [ 3883.654112] CE: hpet increasing min_delta_ns to 33750 nsec
> [ 3884.391118] CE: hpet increasing min_delta_ns to 50624 nsec
> 
