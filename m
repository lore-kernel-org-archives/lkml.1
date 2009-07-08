Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZGHLrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZGHLrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZGHLrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:47:10 -0400
Received: from cmpxchg.org ([85.214.51.133]:51447 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZGHLrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:47:09 -0400
Date: Wed, 8 Jul 2009 13:46:26 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem allocator
Message-ID: <20090708114626.GA6151@cmpxchg.org>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com> <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com> <1246950530.24285.7.camel@penberg-laptop> <20090707165350.GA2782@cmpxchg.org> <1247004586.5710.16.camel@pc1117.cambridge.arm.com> <1247035701.15919.35.camel@penberg-laptop> <1247046231.6595.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247046231.6595.14.camel@pc1117.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 10:43:51AM +0100, Catalin Marinas wrote:

> kmemleak: Add callbacks to the bootmem allocator
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> This patch adds kmemleak_alloc/free callbacks to the bootmem allocator.
> This would allow scanning of such blocks and help avoiding a whole class
> of false positives and more kmemleak annotations.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/bootmem.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index d2a9ce9..90f3ed0 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -335,6 +335,8 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  {
>  	unsigned long start, end;
>  
> +	kmemleak_free_part(__va(physaddr), size);
> +
>  	start = PFN_UP(physaddr);
>  	end = PFN_DOWN(physaddr + size);
>  
> @@ -354,6 +356,8 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
>  {
>  	unsigned long start, end;
>  
> +	kmemleak_free_part(__va(addr), size);
> +
>  	start = PFN_UP(addr);
>  	end = PFN_DOWN(addr + size);
>  
> @@ -516,6 +520,7 @@ find_block:
>  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
>  				start_off);
>  		memset(region, 0, size);
> +		kmemleak_alloc(region, size, 1, 0);
>  		return region;
>  	}
