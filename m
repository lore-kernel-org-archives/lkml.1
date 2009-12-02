Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZLBJzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZLBJzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZLBJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:55:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48648 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbZLBJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:55:00 -0500
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 2/2] slab, kmemleak, bugfix, pass the correct pointer to kmemleak_erase()
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
	<1259740550-10394-3-git-send-email-hooanon05@yahoo.co.jp>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 02 Dec 2009 09:55:03 +0000
In-Reply-To: <1259740550-10394-3-git-send-email-hooanon05@yahoo.co.jp> (J. R. Okajima's message of "Wed\,  2 Dec 2009 16\:55\:50 +0900")
Message-ID: <tnxmy214s5k.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Dec 2009 09:55:05.0281 (UTC) FILETIME=[860B0310:01CA7335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> In ____cache_alloc(), the variable 'ac' may be changed after
> cache_alloc_refill() and the following kmemleak_erase() may get an
> incorrect pointer.
> Update 'ac' after cache_alloc_refill() unconditionally.
> cf. http://marc.info/?l=linux-kernel&m=125873373124187&w=2
>     and its thread.
>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
>
> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> ---
>  mm/slab.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 4e61449..66e9047 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3103,6 +3103,11 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  	} else {
>  		STATS_INC_ALLOCMISS(cachep);
>  		objp = cache_alloc_refill(cachep, flags);
> +		/*
> +		 * the 'ac' may be updated by cache_alloc_refill(),
> +		 * and kmemleak_erase() requires its correct value.
> +		 */
> +		ac = cpu_cache_get(cachep);
>  	}
>  	/*
>  	 * To avoid a false negative, if an object that is in one of the

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

-- 
Catalin
