Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbYDBROq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbYDBROq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYDBROi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:14:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57032 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbYDBROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:14:38 -0400
Subject: Re: [BUG] 2.6.25-rc8-mm1 kernel panic while bootup on powerpc
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47F3BDD4.1010905@linux.vnet.ibm.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	 <47F326E0.3010604@linux.vnet.ibm.com>
	 <20080401233909.23220623.akpm@linux-foundation.org>
	 <47F330FF.3050806@linux.vnet.ibm.com>
	 <1207120676.7349.11.camel@concordia.ozlabs.ibm.com>
	 <47F3BDD4.1010905@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 10:15:07 -0800
Message-Id: <1207160107.30407.29.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 22:39 +0530, Kamalesh Babulal wrote:
> Michael Ellerman wrote:
> > On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
> >> Andrew Morton wrote:
> >>> On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> >>>
> >>>> Hi Andrew,
> >>>>
> >>>> The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s).
> >>>>
> >>>> [    0.000000] ------------[ cut here ]------------
> >>>> [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
> >>>> [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
> >>>> [    0.000000] SMP NR_CPUS=32 NUMA PowerMac
> >>>> [    0.000000] Modules linked in:
> >>>> [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c00000000002b6ac
> >>>> [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autokern1)
> >>>> [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20000000
> >>>> [    0.000000] TASK = c0000000003f9c90[0] 'swapper' THREAD: c000000000498000 CPU: 0
> >>>> [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989d0 0000000000000001 
> >>>> [    0.000000] GPR04: d59aca40f0000000 000000000b000000 0000000000000010 0000000000000000 
> >>>> [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e520800 c0000000004bf0f0 
> >>>> [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 0000000000000000 0000000000000000 
> >>>> [    0.000000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> >>>> [    0.000000] GPR20: 0000000000000000 0000000000000000 0000000000000000 4000000001400000 
> >>>> [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 0000000000000000 c000000000504000 
> >>>> [    0.000000] GPR28: 0000000000000000 cf000000001f8000 0000000001000000 cf00000000000000 
> >>>> [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
> >>>> [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
> >>>> [    0.000000] Call Trace:
> >>>> [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4 (unreliable)
> >>>> [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_populate+0x38/0x60
> >>>> [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem_map_alloc+0x54/0x94
> >>>> [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0/0x20c
> >>>> [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac/0x218
> >>>> [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe0/0x3fc
> >>>> [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_common+0x54/0xc0
> >>>> [    0.000000] Instruction dump:
> >>>> [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e96289c0 e9090002 
> >>>> [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214 7fbfe840 7fe3fb78 
> >>>> [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
> >>>> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> >>>>
> >>> int __meminit vmemmap_populate(struct page *start_page,
> >>> 					unsigned long nr_pages, int node)
> >>> {
> >>> 	unsigned long mode_rw;
> >>> 	unsigned long start = (unsigned long)start_page;
> >>> 	unsigned long end = (unsigned long)(start_page + nr_pages);
> >>> 	unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
> >>>
> >>> 	mode_rw = _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_COHERENT | PP_RWXX;
> >>>
> >>> 	/* Align to the page size of the linear mapping. */
> >>> 	start = _ALIGN_DOWN(start, page_size);
> >>>
> >>> 	for (; start < end; start += page_size) {
> >>> 		int mapped;
> >>> 		void *p;
> >>>
> >>> 		if (vmemmap_populated(start, page_size))
> >>> 			continue;
> >>>
> >>> 		p = vmemmap_alloc_block(page_size, node);
> >>> 		if (!p)
> >>> 			return -ENOMEM;
> >>>
> >>> 		pr_debug("vmemmap %08lx allocated at %p, physical %08lx.\n",
> >>> 			start, p, __pa(p));
> >>>
> >>> 		mapped = htab_bolt_mapping(start, start + page_size,
> >>> 					__pa(p), mode_rw, mmu_linear_psize,
> >>> 					mmu_kernel_ssize);
> >>> =====>		BUG_ON(mapped < 0);
> >>> 	}
> >>>
> >>> 	return 0;
> >>> }
> >>>
> >>> Beats me.  pseries?  Badari has been diddling with the bolted memory code
> >>> in git-powerpc...
> >> One of the machines is the Power5 and another is PowerMac G5, on which the 
> >> same kernel panic is seen.
> > 
> > Can you enable DEBUG_LOW in arch/powerpc/platforms/pseries/lpar.c, that
> > should show what's happening in hpte_insert().
> > 
> > cheers
> > 
> Just define DEBUG_LOW did not fetch and debug information, so added some printk to
> htab_bolt_mapping () and pSeries_lpar_hpte_insert ()
> 
> [boot]0012 Setup Arch
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 3000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000003000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 4000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000004000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 5000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000005000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 6000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000006000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 8000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000008000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart 9000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=0000000009000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart a000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=000000000a000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart b000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=000000000b000000, rflags=194, vflags=10, psize=4 ssize=0)
> htab_bolt_mapping (vstart cf00000000000000, vend cf00000001000000, pstart c000000,mode 190, psize 4, ssize 0)
> htab_bolt_mapping: calling c000000000888f00
> _hpte_insert(group=252078, va=d59aca40f0000000, pa=000000000c000000, rflags=194, vflags=10, psize=4 ssize=0)
> 
> ------------[ cut here ]------------
> kernel BUG at arch/powerpc/mm/init_64.c:240!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=128 NUMA pSeries
> Modules linked in:
> NIP: c000000000774b88 LR: c000000000774b80 CTR: 0000000000000000
> REGS: c0000000008f7950 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autotest)
> MSR: 8000000000021032 <ME,IR,DR>  CR: 24000088  XER: 00000001
> TASK = c0000000007dffd0[0] 'swapper' THREAD: c0000000008f4000 CPU: 0
> 
> GPR00: c000000000774b80 c0000000008f7bd0 c0000000008f6c00 0000000000000001 
> GPR04: fffffffffffffffa 000000000000005f 000000000000005e 0000000000000477 
> GPR08: 00000009b346bb78 8000000006520800 fffffffffffffffa ffffffffffffffff 
> GPR12: 0000000024000082 c0000000007e0980 0000000000000000 c00000000069ab58 
> GPR16: 4000000001c00000 c0000000006993e8 0000000000000000 00000000002b1000 
> GPR20: 000000000237b450 c00000000077b450 000000000237b6c0 c00000000077b6c0 
> GPR24: c00000000069a5a0 0000000002700000 c0000000009b0000 0000000000000000 
> GPR28: cf000000001f8000 cf00000001000000 0000000001000000 cf00000000000000 
> 
> NIP [c000000000774b88] .vmemmap_populate+0xbc/0x100
> LR [c000000000774b80] .vmemmap_populate+0xb4/0x100
> 
> Call Trace:
> [c0000000008f7bd0] [c000000000774b80] .vmemmap_populate+0xb4/0x100 (unreliable)
> [c0000000008f7c70] [c0000000007757e4] .sparse_mem_map_populate+0x38/0x5c
> [c0000000008f7d00] [c000000000762f14] .sparse_early_mem_map_alloc+0x54/0x94
> [c0000000008f7d90] [c000000000763348] .sparse_init+0x1e8/0x224
> [c0000000008f7e50] [c00000000074f428] .setup_arch+0x1ac/0x218
> [c0000000008f7ee0] [c0000000007466bc] .start_kernel+0xe0/0x414
> [c0000000008f7f90] [c000000000008594] .start_here_common+0x54/0xc0
> 
> Instruction dump:
> 7fe3fb78 7ca02a14 4082000c 3860fff4 48000040 e9228980 e9628988 e8e90002 
> e90b0002 4b8b712d 60000000 78630fe0 <0b030000> 7ffff214 7fbdf214 7fbfe040 
> ---[ end trace 31fd0ba7d8756001 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> 

Kamalesh,

With your config, I am able to reproduce the problem. I haven't touched
that part of code. I can take a look at it. It looks like we are trying
to create mapping for same "vaddr" multiple times and we get failures
after few creates. I am not sure why we are trying to create so many
times with same vaddr.

Thanks,
Badari

