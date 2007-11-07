Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbXKGD06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbXKGD06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXKGD0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:26:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53075 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757406AbXKGD0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:26:47 -0500
Date: Wed, 7 Nov 2007 04:26:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 09/23] SLUB: Add get() and kick() methods
Message-ID: <20071107032622.GV26163@stusta.de>
References: <20071107011130.382244340@sgi.com> <20071107011228.605750914@sgi.com> <20071107023709.GU26163@stusta.de> <Pine.LNX.4.64.0711061906290.5565@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711061906290.5565@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 07:07:15PM -0800, Christoph Lameter wrote:
> On Wed, 7 Nov 2007, Adrian Bunk wrote:
> 
> > A static inline dummy function for CONFIG_SLUB=n seems to be missing?
> 
> Correct. This patch is needed so that building with SLAB will work.
> 
> Slab defrag: Provide empty kmem_cache_setup_defrag function for SLAB.
> 
> Provide an empty function to satisfy dependencies for Slab defrag.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>?
> 
> ---
>  mm/slab.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6/mm/slab.c
> ===================================================================
> --- linux-2.6.orig/mm/slab.c	2007-11-06 18:57:22.000000000 -0800
> +++ linux-2.6/mm/slab.c	2007-11-06 18:58:40.000000000 -0800
> @@ -2535,6 +2535,13 @@ static int __cache_shrink(struct kmem_ca
>  	return (ret ? 1 : 0);
>  }
>  
> +void kmem_cache_setup_defrag(struct kmem_cache *s,
> +	void *(*get)(struct kmem_cache *, int nr, void **),
> +	void (*kick)(struct kmem_cache *, int nr, void **, void *private))
> +{
> +}
> +EXPORT_SYMBOL(kmem_cache_setup_defrag);
> +

- this misses slob
- this wastes memory

An empty static inline function in slab.h would be better.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

