Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYHGMnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYHGMnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYHGMnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:43:23 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47156 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbYHGMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:43:22 -0400
Date: Thu, 7 Aug 2008 13:42:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Adrian Bunk <bunk@kernel.org>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] make mm/rmap.c:anon_vma_cachep static
In-Reply-To: <20080806211013.GB1702@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0808071338260.10229@blonde.site>
References: <20080806211013.GB1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Adrian Bunk wrote:
> This patch makes the needlessly global anon_vma_cachep static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Rik van Riel <riel@redhat.com>

Yes, it's much better your way, thanks Adrian: I guess there must have
been some reason during development why those went in rmap.h instead of
rmap.c, but I can't see any good reason since it hit the tree in 2.6.7.

Acked-by: Hugh Dickins <hugh@veritas.com>

> 
> ---
> 
> This patch has been sent on:
> - 5 May 2008
> - 22 Apr 2008
> - 14 Apr 2008
> - 31 Mar 2008
> - 25 Feb 2008
> 
>  include/linux/rmap.h |   12 ------------
>  mm/rmap.c            |   12 +++++++++++-
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> 8d2d63d71ecbf2db78f31025acb136c9dd4db6a2 diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 1383692..8a8dbb9 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -31,18 +31,6 @@ struct anon_vma {
>  
>  #ifdef CONFIG_MMU
>  
> -extern struct kmem_cache *anon_vma_cachep;
> -
> -static inline struct anon_vma *anon_vma_alloc(void)
> -{
> -	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> -}
> -
> -static inline void anon_vma_free(struct anon_vma *anon_vma)
> -{
> -	kmem_cache_free(anon_vma_cachep, anon_vma);
> -}
> -
>  static inline void anon_vma_lock(struct vm_area_struct *vma)
>  {
>  	struct anon_vma *anon_vma = vma->anon_vma;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 8fd527c..ef6bb36 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -52,7 +52,17 @@
>  
>  #include <asm/tlbflush.h>
>  
> -struct kmem_cache *anon_vma_cachep;
> +static struct kmem_cache *anon_vma_cachep;
> +
> +static inline struct anon_vma *anon_vma_alloc(void)
> +{
> +	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> +}
> +
> +static inline void anon_vma_free(struct anon_vma *anon_vma)
> +{
> +	kmem_cache_free(anon_vma_cachep, anon_vma);
> +}
>  
>  /* This must be called under the mmap_sem. */
>  int anon_vma_prepare(struct vm_area_struct *vma)
