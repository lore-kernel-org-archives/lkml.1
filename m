Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbXEASKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbXEASKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXEASKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:10:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45552 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbXEASKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:10:54 -0400
Date: Tue, 1 May 2007 19:10:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 01 May 2007 18:10:43.0958 (UTC) FILETIME=[08E58160:01C78C1C]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Andrew Morton wrote:
> 
>  i386-use-page-allocator-to-allocate-thread_info-structure.patch
>  slub-core.patch
> 
> slub.  Or part thereof.  This is another patch series which got messed up by
> poor patch sequencing.
> 
>  make-page-private-usable-in-compound-pages-v1.patch
>  optimize-compound_head-by-avoiding-a-shared-page.patch
>  add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
>  slub-fix-object-tracking.patch
>  slub-enable-tracking-of-full-slabs.patch
>  slub-validation-of-slabs-metadata-and-guard-zones.patch
>  slub-add-min_partial.patch
>  slub-add-ability-to-list-alloc--free-callers-per-slab.patch
>  slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
>  slub-remove-object-activities-out-of-checking-functions.patch
>  slub-user-documentation.patch
>  slub-add-slabinfo-tool.patch
> 
> Most of the rest of slub.  Will merge it all.

Merging slub already?  I'm surprised.  That's a very key piece of
infrastructure, and I doubt it's had the exposure it needs yet.

Just what has it been widely tested on so far?  x86_64.  Not many
of us have ia64, but I guess SGI people will have been trying it
on that.  Not i386, that's excluded.

Not powerpc - hmm, I thought that was known, but looking I see no
ARCH_USES_SLAB_PAGE_STRUCT there: just built and tried to run it up,
crashes in slab_free from pgtable_free_tlb frpm free_pte_range from
free_pgd_range from free_pgtables from unmap_region form do_munmap.
That's 2.6.21-rc7-mm2.

slob has a justified place at the low end, but do we want some
people running with slab and some with slub?  I'd expected slub
to stay in 2.6.22-mm, and have all the architectures cut over to
it in that time, before advancing to mainline.

I've nothing against slub in itself, though I'm wary of its
cache merging (more scope for one corrupting another) (and
sometimes I think Christoph spent one life uglifying slab for
NUMA, then another life ripping that all out to make slub ;)

Hugh
