Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZG3PjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZG3PjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZG3PjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:39:11 -0400
Received: from cmpxchg.org ([85.214.51.133]:37066 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZG3PjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:39:10 -0400
Date: Thu, 30 Jul 2009 17:36:58 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: Add kmalloc NULL tests
Message-ID: <20090730153658.GA22986@cmpxchg.org>
References: <Pine.LNX.4.64.0907301608350.8734@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907301608350.8734@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Julia,

On Thu, Jul 30, 2009 at 04:10:22PM +0200, Julia Lawall wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index 7b5d4de..972e427 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1502,6 +1502,7 @@ void __init kmem_cache_init(void)
>  
>  		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
>  
> +		BUG_ON(!ptr);
>  		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
>  		memcpy(ptr, cpu_cache_get(&cache_cache),
>  		       sizeof(struct arraycache_init));

This does not change the end result when the allocation fails: you get
a stacktrace and a kernel panic.  Leaving it as is saves a line of
code.

> @@ -1514,6 +1515,7 @@ void __init kmem_cache_init(void)
>  
>  		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
>  
> +		BUG_ON(!ptr);
>  		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)
>  		       != &initarray_generic.cache);
>  		memcpy(ptr, cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep),

	Hannes
