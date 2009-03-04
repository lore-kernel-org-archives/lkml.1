Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZCDCGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZCDCGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZCDCFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:05:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:59262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbZCDCFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:05:51 -0500
Message-ID: <49ADE201.7010506@kernel.org>
Date: Wed, 04 Mar 2009 11:05:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: 32bit panic on 4 sockets
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com> <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
In-Reply-To: <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 02:05:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a genuine bootmem bug.  Cc'ing Johannes and
quoting whole body.

Yinghai Lu wrote:
> linus tree is broken too, it is one 4 sockets system and every sockets
> hold 2g ram...
> other system with more than 4g on every socket, works well.
> maybe it never work...
> 
> 
> Initializing cgroup subsys cpuset.....
> Linux version 2.6.29-rc6-00305-g2450cf5 (yhlu@linux-mstp) (gcc version 4.3.2 [gc
> c-4_3-branch revision 141291] (SUSE Linux) ) #696 SMP Tue Mar 3 17:42:09 PST 200
> 9
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
>  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
>  BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (usable)
>  BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
>  BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
>  BIOS-e820: 00000000d7ff0000 - 00000000d8000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
>  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000228000000 (usable)
> Early serial console at I/O port 0x3f8 (options '115200n8')
> console [uart0] enabled
> DMI present.
> AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> last_pfn = 0x228000 max_arch_pfn = 0x1000000
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> kernel direct mapping tables up to b73fe000 @ 10000-1b000
> NX (Execute Disable) protection: active
> RAMDISK: 7ea35000 - 7ffffe57
> ACPI: RSDP 000FA570, 0014 (r0 ACPIAM)
> ACPI: RSDT D7FB0000, 005C (r1 SUN    X4x40          52 MSFT       97)
> ACPI: FACP D7FB0200, 0084 (r2 SUN    X4x40          52 MSFT       97)
> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
> ACPI: DSDT D7FB05D0, 7EB4 (r1 SUN    X4x40          52 INTL 20051117)
> ACPI: FACS D7FBE000, 0040
> ACPI: APIC D7FB0390, 00EC (r1 SUN    X4x40          52 MSFT       97)
> ACPI: SPCR D7FB0480, 0050 (r1 SUN    X4x40          52 MSFT       97)
> ACPI: MCFG D7FB04D0, 003C (r1 SUN    OEMMCFG        52 MSFT       97)
> ACPI: SLIT D7FB0540, 003C (r1 SUN    OEMSLIT        52 MSFT       97)
> ACPI: SPMI D7FB0580, 0041 (r1 SUN    OEMSPMI        52 MSFT       97)
> ACPI: OEMB D7FBE040, 00AE (r1 SUN    X4x40          52 MSFT       97)
> ACPI: SRAT D7FB8490, 0220 (r1 AMD    FAM_F_10        2 AMD         1)
> ACPI: HPET D7FB86B0, 0038 (r1 SUN    OEMHPET0       52 MSFT       97)
> ACPI: EINJ D7FB86F0, 0130 (r1  AMIER AMI_EINJ 10000815 MSFT       97)
> ACPI: BERT D7FB8880, 0030 (r1  AMIER AMI_BERT 10000815 MSFT       97)
> ACPI: ERST D7FB88B0, 01B0 (r1  AMIER AMI_ERST 10000815 MSFT       97)
> ACPI: HEST D7FB8A60, 00A8 (r1  AMIER AMI_HEST 10000815 MSFT       97)
> ACPI: SSDT D7FB8B10, 21C4 (r1 A M I  POWERNOW        1 AMD         1)
> ACPI: Local APIC address 0xfee00000
> CPU 04 in proximity domain 00
> CPU 05 in proximity domain 00
> CPU 06 in proximity domain 00
> CPU 07 in proximity domain 00
> CPU 08 in proximity domain 01
> CPU 09 in proximity domain 01
> CPU 0a in proximity domain 01
> CPU 0b in proximity domain 01
> CPU 0c in proximity domain 02
> CPU 0d in proximity domain 02
> CPU 0e in proximity domain 02
> CPU 0f in proximity domain 02
> CPU 10 in proximity domain 03
> CPU 11 in proximity domain 03
> CPU 12 in proximity domain 03
> CPU 13 in proximity domain 03
> Memory range 00000000 to 000000a0 in proximity domain 00 enabled
> Memory range 00000100 to 00080000 in proximity domain 00 enabled
> Memory range 00080000 to 000d8000 in proximity domain 01 enabled
> Memory range 00100000 to 00128000 in proximity domain 01 enabled
> Memory range 00128000 to 001a8000 in proximity domain 02 enabled
> Memory range 001a8000 to 00228000 in proximity domain 03 enabled
> pxm bitmap: 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  00 00 00 00 00 00 00 00 00
> Number of logical nodes in system = 4
> Number of memory chunks in system = 6
> chunk 0 nid 0 start_pfn 00000000 end_pfn 000000a0
> chunk 1 nid 0 start_pfn 00000100 end_pfn 00080000
> chunk 2 nid 1 start_pfn 00080000 end_pfn 000d8000
> chunk 3 nid 1 start_pfn 00100000 end_pfn 00128000
> chunk 4 nid 2 start_pfn 00128000 end_pfn 001a8000
> chunk 5 nid 3 start_pfn 001a8000 end_pfn 00228000
> node 0 pfn: [0 - 80000]
> Reserving 4608 pages of KVA for lmem_map of node 0 at 7d800
> remove_active_range (0, 514048, 518656)
> node 1 pfn: [80000 - 128000]
> Reserving 5632 pages of KVA for lmem_map of node 1 at 126a00
> remove_active_range (1, 1206784, 1212416)
> node 2 pfn: [128000 - 1a8000]
> Reserving 4608 pages of KVA for lmem_map of node 2 at 1a6e00
> remove_active_range (2, 1732096, 1736704)
> node 3 pfn: [1a8000 - 228000]
> Reserving 4608 pages of KVA for lmem_map of node 3 at 226e00
> remove_active_range (3, 2256384, 2260992)
> Reserving total of 4c00 pages for numa KVA remap
> kva_start_pfn ~ 80000 max_low_pfn ~ b73fe
> max_pfn = 228000
> 5900MB HIGHMEM available.
> 2931MB LOWMEM available.
> max_low_pfn = b73fe, highstart_pfn = b73fe
> Low memory ends at vaddr f73fe000
> node 0 will remap to vaddr c0000000 - c1200000
> allocate_pgdat: node 0 NODE_DATA c0000000
> node 1 will remap to vaddr c1200000 - c2800000
> allocate_pgdat: node 1 NODE_DATA c1200000
> node 2 will remap to vaddr c2800000 - c3a00000
> allocate_pgdat: node 2 NODE_DATA c2800000
> node 3 will remap to vaddr c3a00000 - c4c00000
> allocate_pgdat: node 3 NODE_DATA c3a00000
> remap_numa_kva: node 0
> remap_numa_kva: c0000000 to pfn 0007d800
> remap_numa_kva: c0200000 to pfn 0007da00
> remap_numa_kva: c0400000 to pfn 0007dc00
> remap_numa_kva: c0600000 to pfn 0007de00
> remap_numa_kva: c0800000 to pfn 0007e000
> remap_numa_kva: c0a00000 to pfn 0007e200
> remap_numa_kva: c0c00000 to pfn 0007e400
> remap_numa_kva: c0e00000 to pfn 0007e600
> remap_numa_kva: c1000000 to pfn 0007e800
> remap_numa_kva: node 1
> remap_numa_kva: c1200000 to pfn 00126a00
> remap_numa_kva: c1400000 to pfn 00126c00
> remap_numa_kva: c1600000 to pfn 00126e00
> remap_numa_kva: c1800000 to pfn 00127000
> remap_numa_kva: c1a00000 to pfn 00127200
> remap_numa_kva: c1c00000 to pfn 00127400
> remap_numa_kva: c1e00000 to pfn 00127600
> remap_numa_kva: c2000000 to pfn 00127800
> remap_numa_kva: c2200000 to pfn 00127a00
> remap_numa_kva: c2400000 to pfn 00127c00
> remap_numa_kva: c2600000 to pfn 00127e00
> remap_numa_kva: node 2
> remap_numa_kva: c2800000 to pfn 001a6e00
> remap_numa_kva: c2a00000 to pfn 001a7000
> remap_numa_kva: c2c00000 to pfn 001a7200
> remap_numa_kva: c2e00000 to pfn 001a7400
> remap_numa_kva: c3000000 to pfn 001a7600
> remap_numa_kva: c3200000 to pfn 001a7800
> remap_numa_kva: c3400000 to pfn 001a7a00
> remap_numa_kva: c3600000 to pfn 001a7c00
> remap_numa_kva: c3800000 to pfn 001a7e00
> remap_numa_kva: node 3
> remap_numa_kva: c3a00000 to pfn 00226e00
> remap_numa_kva: c3c00000 to pfn 00227000
> remap_numa_kva: c3e00000 to pfn 00227200
> remap_numa_kva: c4000000 to pfn 00227400
> remap_numa_kva: c4200000 to pfn 00227600
> remap_numa_kva: c4400000 to pfn 00227800
> remap_numa_kva: c4600000 to pfn 00227a00
> remap_numa_kva: c4800000 to pfn 00227c00
> remap_numa_kva: c4a00000 to pfn 00227e00
> High memory starts at vaddr f73fe000
>   mapped low ram: 0 - b73fe000
>   low ram: 00000000 - b73fe000
>   bootmap 00016000 - 0002ce80
> Pid: 0, comm: swapper Not tainted 2.6.29-rc6-00305-g2450cf5 #696
> Call Trace:
>  [<40c62315>] ? mark_bootmem_node+0x44/0x7d
>  [<40c62449>] ? free_bootmem_node+0x20/0x24
>  [<40c63047>] ? free_bootmem_with_active_regions+0x63/0x94
>  [<40c5d688>] ? setup_bootmem_allocator+0xe4/0x12e
>  [<40c5e75d>] ? initmem_init+0x60e/0x620
>  [<40c69bb6>] ? acpi_table_parse+0x55/0x5c
>  [<40c5188d>] ? setup_arch+0x756/0x957
>  [<4023eb9c>] ? up+0x2b/0x2f
>  [<40c53aef>] ? __reserve_early+0xe4/0xf8
>  [<40c4b5a1>] ? start_kernel+0x6d/0x2d6
>  [<40c4b085>] ? __init_begin+0x85/0x8d
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
tejun
