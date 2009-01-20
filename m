Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZATJS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZATJS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZATJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:18:41 -0500
Received: from ns.suse.de ([195.135.220.2]:54252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZATJSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:18:39 -0500
Date: Tue, 20 Jan 2009 10:18:37 +0100
From: Nick Piggin <npiggin@suse.de>
To: venkatesh.pallipadi@intel.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86 warnings in arch/x86/mm/pageattr.c:560
Message-ID: <20090120091837.GC19505@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been getting this warning intermittently since the merge window
opened. Considering that track_pfn_vma_new is called before the ptes
are set up in remap_pfn_range (and remap_pfn_range contains a warning
if the ptes *are* nonzero), I don't know how this is supposed to work?

Anyway, I can of course test patches.

------------[ cut here ]------------
WARNING: at arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0x9ef/0xa00()
Hardware name: empty
CPA: called for zero pte. vaddr = ffff8800cff4e000 cpa->vaddr = ffff8800cff4e000
Modules linked in:
Pid: 2311, comm: mcelog Not tainted 2.6.29-rc2-00013-gf3b8436 #75
Call Trace:
 [<ffffffff8024053a>] warn_slowpath+0xea/0x160
 [<ffffffff803ab692>] mix_pool_bytes_extract+0x52/0x160
 [<ffffffff803abc63>] extract_buf+0x83/0xf0
 [<ffffffff8028c65d>] zone_statistics+0x7d/0x80
 [<ffffffff80280686>] get_page_from_freelist+0x4b6/0x690
 [<ffffffff80280a57>] __alloc_pages_internal+0xe7/0x4d0
 [<ffffffff8022e9ff>] __change_page_attr_set_clr+0x9ef/0xa00
 [<ffffffff8029bad4>] __purge_vmap_area_lazy+0x104/0x180
 [<ffffffff8029d3ce>] vm_unmap_aliases+0x17e/0x190
 [<ffffffff8022eaea>] change_page_attr_set_clr+0xda/0x380
 [<ffffffff8022eeed>] _set_memory_wb+0x1d/0x30
 [<ffffffff802305a6>] reserve_pfn_range+0x126/0x300
 [<ffffffff8022eaea>] change_page_attr_set_clr+0xda/0x380
 [<ffffffff80292510>] remap_pfn_range+0xa0/0x3d0
 [<ffffffff80230c33>] phys_mem_access_prot_allowed+0xf3/0x1e0
 [<ffffffff8028be48>] vma_prio_tree_insert+0x28/0x110
 [<ffffffff803ab1f6>] mmap_mem+0x96/0xc0
 [<ffffffff80297887>] mmap_region+0x247/0x670
 [<ffffffff80297f94>] do_mmap_pgoff+0x2e4/0x3f0
 [<ffffffff80210905>] sys_mmap+0x115/0x140
 [<ffffffff8020b91b>] system_call_fastpath+0x16/0x1b
---[ end trace 488160a0a7b56966 ]---
mcelog:2311 reserve_pfn_range ioremap_change_attr failed write-back for cff4e000-cff50000

