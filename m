Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbYDBWYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbYDBWYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYDBWYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:24:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:22842 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYDBWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V/MO3n3K5W5KZqiyDmdYllmwW1v7ADAJ/xYsWZQK1vDATBn7WKCOaz9HjmRsMw6C4qU6N4n5MIuT3VGWYoMK+smVchWBCzuLCrgUzwYGGpZ63zaNnqijEqXr7q4REb+vG3jcqkm36mncPYx7tau2GZi8xKEMENmLP+rMDyix9C8=
Message-ID: <86802c440804021524r3e930f4aoffe8e43a4c1bb9d0@mail.gmail.com>
Date: Wed, 2 Apr 2008 15:24:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [BUG] 2.6.25-rc8-mm1 kernel panic while bootup on powerpc
Cc: michael@ellerman.id.au, "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1207164127.30407.36.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	 <47F326E0.3010604@linux.vnet.ibm.com>
	 <20080401233909.23220623.akpm@linux-foundation.org>
	 <47F330FF.3050806@linux.vnet.ibm.com>
	 <1207120676.7349.11.camel@concordia.ozlabs.ibm.com>
	 <1207164127.30407.36.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 12:22 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>
> On Wed, 2008-04-02 at 18:17 +1100, Michael Ellerman wrote:
>  > On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
>  > > Andrew Morton wrote:
>  > > > On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>  > > >
>  > > >> Hi Andrew,
>  > > >>
>  > > >> The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s).
>  > > >>
>  > > >> [    0.000000] ------------[ cut here ]------------
>  > > >> [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
>  > > >> [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
>  > > >> [    0.000000] SMP NR_CPUS=32 NUMA PowerMac
>  > > >> [    0.000000] Modules linked in:
>  > > >> [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c00000000002b6ac
>  > > >> [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autokern1)
>  > > >> [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20000000
>  > > >> [    0.000000] TASK = c0000000003f9c90[0] 'swapper' THREAD: c000000000498000 CPU: 0
>  > > >> [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989d0 0000000000000001
>  > > >> [    0.000000] GPR04: d59aca40f0000000 000000000b000000 0000000000000010 0000000000000000
>  > > >> [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e520800 c0000000004bf0f0
>  > > >> [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 0000000000000000 0000000000000000
>  > > >> [    0.000000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  > > >> [    0.000000] GPR20: 0000000000000000 0000000000000000 0000000000000000 4000000001400000
>  > > >> [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 0000000000000000 c000000000504000
>  > > >> [    0.000000] GPR28: 0000000000000000 cf000000001f8000 0000000001000000 cf00000000000000
>  > > >> [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
>  > > >> [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
>  > > >> [    0.000000] Call Trace:
>  > > >> [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4 (unreliable)
>  > > >> [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_populate+0x38/0x60
>  > > >> [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem_map_alloc+0x54/0x94
>  > > >> [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0/0x20c
>  > > >> [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac/0x218
>  > > >> [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe0/0x3fc
>  > > >> [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_common+0x54/0xc0
>  > > >> [    0.000000] Instruction dump:
>  > > >> [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e96289c0 e9090002
>  > > >> [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214 7fbfe840 7fe3fb78
>  > > >> [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
>  > > >> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>  > > >>
>  > > >
>  > > > int __meminit vmemmap_populate(struct page *start_page,
>  > > >                                   unsigned long nr_pages, int node)
>  > > > {
>  > > >   unsigned long mode_rw;
>  > > >   unsigned long start = (unsigned long)start_page;
>  > > >   unsigned long end = (unsigned long)(start_page + nr_pages);
>  > > >   unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
>  > > >
>  > > >   mode_rw = _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_COHERENT | PP_RWXX;
>  > > >
>  > > >   /* Align to the page size of the linear mapping. */
>  > > >   start = _ALIGN_DOWN(start, page_size);
>  > > >
>  > > >   for (; start < end; start += page_size) {
>  > > >           int mapped;
>  > > >           void *p;
>  > > >
>  > > >           if (vmemmap_populated(start, page_size))
>  > > >                   continue;
>  > > >
>  > > >           p = vmemmap_alloc_block(page_size, node);
>  > > >           if (!p)
>  > > >                   return -ENOMEM;
>  > > >
>  > > >           pr_debug("vmemmap %08lx allocated at %p, physical %08lx.\n",
>  > > >                   start, p, __pa(p));
>  > > >
>  > > >           mapped = htab_bolt_mapping(start, start + page_size,
>  > > >                                   __pa(p), mode_rw, mmu_linear_psize,
>  > > >                                   mmu_kernel_ssize);
>  > > > =====>            BUG_ON(mapped < 0);
>  > > >   }
>  > > >
>  > > >   return 0;
>  > > > }
>  > > >
>  > > > Beats me.  pseries?  Badari has been diddling with the bolted memory code
>  > > > in git-powerpc...
>  > >
>  > > One of the machines is the Power5 and another is PowerMac G5, on which the
>  > > same kernel panic is seen.
>  >
>  > Can you enable DEBUG_LOW in arch/powerpc/platforms/pseries/lpar.c, that
>  > should show what's happening in hpte_insert().
>  >
>  > cheers
>  >
>
>  Okay. Found it.
>
>  Root cause is:
>
>  mm-make-mem_map-allocation-continuous.patch
>  and its friends in -mm.
>
>  You have to call sparse_init_one_section() on each pmap and usemap
>  as we allocate - since valid_section() depends on it (which is needed
>  by vmemmap_populate() to check if the section is populated or not).
>  On ppc, we need to call htab_bolted_mapping() on each section and
>  we need to skip existing sections.
>
>  These patches tried to group all allocations together and then later
>  calls sparse_init_one_section() - which is not good :(
>

http://lkml.org/lkml/2008/4/2/592

Thanks

YH
