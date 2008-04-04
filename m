Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbYDDJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbYDDJ1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYDDJ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:27:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3899 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYDDJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:27:03 -0400
Date: Fri, 4 Apr 2008 10:24:22 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [BUG] 2.6.25-rc8-mm1 kernel panic while bootup on powerpc
Message-ID: <20080404092422.GB17993@shadowen.org>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F326E0.3010604@linux.vnet.ibm.com> <20080401233909.23220623.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401233909.23220623.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 11:39:09PM -0700, Andrew Morton wrote:
> On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s).
> > 
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
> > [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
> > [    0.000000] SMP NR_CPUS=32 NUMA PowerMac
> > [    0.000000] Modules linked in:
> > [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c00000000002b6ac
> > [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autokern1)
> > [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20000000
> > [    0.000000] TASK = c0000000003f9c90[0] 'swapper' THREAD: c000000000498000 CPU: 0
> > [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989d0 0000000000000001 
> > [    0.000000] GPR04: d59aca40f0000000 000000000b000000 0000000000000010 0000000000000000 
> > [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e520800 c0000000004bf0f0 
> > [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 0000000000000000 0000000000000000 
> > [    0.000000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> > [    0.000000] GPR20: 0000000000000000 0000000000000000 0000000000000000 4000000001400000 
> > [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 0000000000000000 c000000000504000 
> > [    0.000000] GPR28: 0000000000000000 cf000000001f8000 0000000001000000 cf00000000000000 
> > [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
> > [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
> > [    0.000000] Call Trace:
> > [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4 (unreliable)
> > [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_populate+0x38/0x60
> > [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem_map_alloc+0x54/0x94
> > [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0/0x20c
> > [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac/0x218
> > [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe0/0x3fc
> > [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_common+0x54/0xc0
> > [    0.000000] Instruction dump:
> > [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e96289c0 e9090002 
> > [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214 7fbfe840 7fe3fb78 
> > [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
> > [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> 
> int __meminit vmemmap_populate(struct page *start_page,
> 					unsigned long nr_pages, int node)
> {
> 	unsigned long mode_rw;
> 	unsigned long start = (unsigned long)start_page;
> 	unsigned long end = (unsigned long)(start_page + nr_pages);
> 	unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
> 
> 	mode_rw = _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_COHERENT | PP_RWXX;
> 
> 	/* Align to the page size of the linear mapping. */
> 	start = _ALIGN_DOWN(start, page_size);
> 
> 	for (; start < end; start += page_size) {
> 		int mapped;
> 		void *p;
> 
> 		if (vmemmap_populated(start, page_size))
> 			continue;
> 
> 		p = vmemmap_alloc_block(page_size, node);
> 		if (!p)
> 			return -ENOMEM;
> 
> 		pr_debug("vmemmap %08lx allocated at %p, physical %08lx.\n",
> 			start, p, __pa(p));
> 
> 		mapped = htab_bolt_mapping(start, start + page_size,
> 					__pa(p), mode_rw, mmu_linear_psize,
> 					mmu_kernel_ssize);
> =====>		BUG_ON(mapped < 0);
> 	}
> 
> 	return 0;
> }
> 
> Beats me.  pseries?  Badari has been diddling with the bolted memory code
> in git-powerpc...

It does look like this is resolved with the patch below, if my testing
is to be believed (results out on TKO):

    [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
    From: Yinghai Lu <yhlu.kernel@gmail.com>

Andrew, I believe you just sucked that up into -mm.

-apw
