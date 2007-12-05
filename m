Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXLEJxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXLEJxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXLEJww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:52:52 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60975 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751455AbXLEJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:52:50 -0500
Date: Wed, 5 Dec 2007 10:52:48 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Milton Miller <miltonm@bga.com>, Andrew Morton <akpm@linux-foundation.org>
cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
In-Reply-To: <b91f94dd5b35247fecf52090c0b3890f@bga.com>
Message-ID: <Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be>
References: <47537F2E.2070204@am.sony.com> <b91f94dd5b35247fecf52090c0b3890f@bga.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-2084528321-1196848358=:28855"
Content-ID: <Pine.LNX.4.62.0712051052440.28855@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-2084528321-1196848358=:28855
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0712051052441.28855@pademelon.sonytel.be>

On Mon, 3 Dec 2007, Milton Miller wrote:
> On Dec 2, 2007, at 9:59 PM, Geoff Levand wrote:
> > ps3_mm_add_memory:317: start_addr 740320000000h, start_pfn 740320000h,
> > nr_pages 17000h
> > <4>swapper: page allocation failure. order:12, mode:0x80d0
> > Call Trace:
> > [c000000006047820] [c00000000000e700] .show_stack+0x68/0x1b0 (unreliable)
> > [c0000000060478c0] [c000000000089eb4] .__alloc_pages+0x358/0x3ac
> > [c0000000060479b0] [c0000000000a3964] .vmemmap_alloc_block+0x6c/0xf4
> > [c000000006047a40] [c000000000026544] .vmemmap_populate+0x74/0x100
> > [c000000006047ae0] [c0000000000a385c] .sparse_mem_map_populate+0x38/0x5c
> > [c000000006047b70] [c0000000000a36e4] .sparse_add_one_section+0x64/0x128
> > [c000000006047c20] [c0000000000aa74c] .__add_pages+0xac/0x18c
> > [c000000006047cd0] [c000000000025fd4] .arch_add_memory+0x44/0x60
> > [c000000006047d60] [c0000000000aa5b0] .add_memory+0xd4/0x124
> > [c000000006047e00] [c000000000452544] .ps3_mm_add_memory+0x8c/0x108
> > [c000000006047ea0] [c0000000004417c4] .kernel_init+0x1f4/0x3b8
> > [c000000006047f90] [c000000000021d88] .kernel_thread+0x4c/0x68
> > Mem-info:
> > DMA per-cpu:
> > CPU    0: Hot: hi:   42, btch:   7 usd:   0   Cold: hi:   14, btch:   3 usd:
> > 0
> > CPU    1: Hot: hi:   42, btch:   7 usd:   0   Cold: hi:   14, btch:   3 usd:
> > 0
> > Active:0 inactive:0 dirty:0 writeback:0 unstable:0
> >  free:18094 slab:122 mapped:0 pagetables:0 bounce:0
> > DMA free:72376kB min:0kB low:0kB high:0kB active:0kB inactive:0kB
> > present:129280kB pages_scanned:0 all_unreclaimable? no
> > lowmem_reserve[]: 0 0 0
> > DMA: 8*4kB 5*8kB 5*16kB 7*32kB 3*64kB 5*128kB 4*256kB 3*512kB 5*1024kB
> > 3*2048kB 4*4096kB 5*8192kB 0*16384kB = 72376kB
> > Swap cache: add 0, delete 0, find 0/0, race 0+0
> > Free swap  = 0kB
> > Total swap = 0kB
> > Free swap:            0kB
> > 32768 pages of RAM
> > 10403 reserved pages
> > 0 pages shared
> > 0 pages swap cached
> 
> The kernel is using 16MB pages for the linear mapping and, since its in the
> same region, the sparse virtural memmap.  PS3 uses hotplug for all most all of
> its memory.   In this case, its trying to allocate an additional page to cover
> a new region of the memory map.   However, the initial 128 MB is fragmented,
> we have 8 8M chunks but no 16MB ones.
> 
> > <1>Unable to handle kernel paging request for data at address
> > 0xcf0001960b000010
> > <1>Faulting instruction address: 0xc000000000087340
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=2 PS3
> > Modules linked in:
> > NIP: c000000000087340 LR: c00000000008733c CTR: 0000000000000000
> > REGS: c000000006047900 TRAP: 0300   Not tainted
> > (2.6.24-rc3-ps3-linux-dev-g91428d55-dirty)
> > MSR: 8000000000008032 <EE,IR,DR>  CR: 22004444  XER: 00000000
> > DAR: cf0001960b000010, DSISR: 0000000042000000
> > TASK = c000000006041080[1] 'swapper' THREAD: c000000006044000 CPU: 1
> > <6>GPR00: 0000000000000000 c000000006047b80 c00000000052b410
> > c000000006001b40
> > <6>GPR04: 0000000000000001 0000000000000003 0000000000000008
> > 0000000000000000
> > <6>GPR08: 0000000000000002 cf0001960b000008 c000000006051240
> > 0000000000000003
> > <6>GPR12: 0000000000000003 c000000000484080 00000000100d0000
> > 0000000000bc5000
> > <6>GPR16: 0000000007fff000 0000000000000001 00000000100a0000
> > 00000000100d0000
> > <6>GPR20: 0000000000000000 00000000100df628 00000000100df458
> > 00000000100df678
> > <6>GPR24: 0000000000740336 c000000000492c00 0000000000000000
> > 0000000000000001
> > <6>GPR28: 0000000740325000 0000000740324924 c0000000004ce9a8
> > cf0001960affffe0
> > NIP [c000000000087340] .memmap_init_zone+0xf0/0x134
> > LR [c00000000008733c] .memmap_init_zone+0xec/0x134
> > Call Trace:
> > [c000000006047b80] [c0000000001da530] .add_memory_block+0xd8/0x108
> > (unreliable)
> > [c000000006047c20] [c0000000000aa7ac] .__add_pages+0x10c/0x18c
> > [c000000006047cd0] [c000000000025fd4] .arch_add_memory+0x44/0x60
> > [c000000006047d60] [c0000000000aa5b0] .add_memory+0xd4/0x124
> > [c000000006047e00] [c000000000452544] .ps3_mm_add_memory+0x8c/0x108
> > [c000000006047ea0] [c0000000004417c4] .kernel_init+0x1f4/0x3b8
> > [c000000006047f90] [c000000000021d88] .kernel_thread+0x4c/0x68
> > Instruction dump:
> > 901f000c 38000400 7d20f8a8 7d290378 7d20f9ad 40a2fff4 7ba00521 7fe3fb78
> > 38800002 41820008 4bffff0d 393f0028 <f9290008> f93f0028 3bbd0001 3bff0038
> > <0>Kernel panic - not syncing: Attempted to kill init!
> 
> Instead of detecting the fail and aborting the add, we proceed to dereference
> the memory map.

sparse_add_one_section() does:

    memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);

but doesn't check whether the allocation succeeded.

Patch to make it continue booting below (but this doesn't fix the issue that
you need 16 MiB of contiguous memory before you can add a new memory region).

--------------------------------------------------------------------------------
Subject: sparsemem: sparse_add_one_section() may fail to allocate memory

sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
whether the allocation succeeded before proceeding to touch the allocated
memory.

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
FIXME There are still some possible memory leaks in sparse_add_one_section():
  - usemap is never deallocated
  - __kfree_section_memmap() is a not yet implemented dummy

 mm/sparse.c |    3 +++
 1 files changed, 3 insertions(+)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -391,6 +391,9 @@ int sparse_add_one_section(struct zone *
 	 */
 	sparse_index_init(section_nr, pgdat->node_id);
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	if (!memmap)
+		return -ENOMEM;
+
 	usemap = __kmalloc_section_usemap();
 
 	pgdat_resize_lock(pgdat, &flags);


With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-2084528321-1196848358=:28855--
