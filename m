Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZGHJre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZGHJre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZGHJr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:47:27 -0400
Received: from cmpxchg.org ([85.214.51.133]:49639 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbZGHJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:47:27 -0400
Date: Wed, 8 Jul 2009 11:46:44 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem allocator
Message-ID: <20090708094643.GA1956@cmpxchg.org>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com> <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com> <1246950530.24285.7.camel@penberg-laptop> <20090707165350.GA2782@cmpxchg.org> <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:09:46PM +0100, Catalin Marinas wrote:

> It seems that alloc_bootmem_core() is central to all the bootmem
> allocations. Is it OK to place the kmemleak_alloc hook only in this
> function?
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 5a649a0..74cbb34 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -520,6 +520,7 @@ find_block:
>  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
>  				start_off);
>  		memset(region, 0, size);
> +		kmemleak_alloc(region, size, 1, 0);
>  		return region;
>  	}

Yes, that should work.

> > > > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > 
> > These GFP_KERNEL startled me.  We know for sure that this code runs in
> > earlylog mode only and gfp is unused, right?  Can you perhaps just
> > pass 0 for gfp instead?
> 
> Yes, indeed.

Thank you.

	Hannes
