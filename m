Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZEHSZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZEHSZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZEHSZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:25:44 -0400
Received: from waste.org ([66.93.16.53]:51174 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZEHSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:25:44 -0400
Date: Fri, 8 May 2009 13:24:29 -0500
From: Matt Mackall <mpm@selenic.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       penberg@cs.helsinki.fi
Subject: Re: [PATCH 2/7] slob: use PG_slab for identifying SLOB pages
Message-ID: <20090508182428.GW31071@waste.org>
References: <20090507012116.996644836@intel.com> <20090507014914.067348097@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507014914.067348097@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 09:21:19AM +0800, Wu Fengguang wrote:
> For the sake of consistency.
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Matt Mackall <mpm@selenic.com>

Pekka, please take this one directly.

> ---
>  include/linux/page-flags.h |    2 --
>  mm/slob.c                  |    6 +++---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> --- linux.orig/include/linux/page-flags.h
> +++ linux/include/linux/page-flags.h
> @@ -120,7 +120,6 @@ enum pageflags {
>  	PG_savepinned = PG_dirty,
>  
>  	/* SLOB */
> -	PG_slob_page = PG_active,
>  	PG_slob_free = PG_private,
>  
>  	/* SLUB */
> @@ -203,7 +202,6 @@ PAGEFLAG(SavePinned, savepinned);			/* X
>  PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
>  PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
>  
> -__PAGEFLAG(SlobPage, slob_page)
>  __PAGEFLAG(SlobFree, slob_free)
>  
>  __PAGEFLAG(SlubFrozen, slub_frozen)
> --- linux.orig/mm/slob.c
> +++ linux/mm/slob.c
> @@ -132,17 +132,17 @@ static LIST_HEAD(free_slob_large);
>   */
>  static inline int is_slob_page(struct slob_page *sp)
>  {
> -	return PageSlobPage((struct page *)sp);
> +	return PageSlab((struct page *)sp);
>  }
>  
>  static inline void set_slob_page(struct slob_page *sp)
>  {
> -	__SetPageSlobPage((struct page *)sp);
> +	__SetPageSlab((struct page *)sp);
>  }
>  
>  static inline void clear_slob_page(struct slob_page *sp)
>  {
> -	__ClearPageSlobPage((struct page *)sp);
> +	__ClearPageSlab((struct page *)sp);
>  }
>  
>  static inline struct slob_page *slob_page(const void *addr)
> 
> -- 

-- 
Mathematics is the supreme nostalgia of our time.
