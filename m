Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZLBJyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZLBJyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZLBJyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:54:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48580 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbZLBJyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:54:23 -0500
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 1/2] slab, kmemleak, minor, stop calling kmemleak_erase() unconditionally
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
	<1259740550-10394-2-git-send-email-hooanon05@yahoo.co.jp>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 02 Dec 2009 09:54:25 +0000
In-Reply-To: <1259740550-10394-2-git-send-email-hooanon05@yahoo.co.jp> (J. R. Okajima's message of "Wed\,  2 Dec 2009 16\:55\:49 +0900")
Message-ID: <tnxr5rd4s6m.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Dec 2009 09:54:27.0204 (UTC) FILETIME=[6F58EC40:01CA7335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> When the gotten object is NULL (probably due to ENOMEM),
> kmemleak_erase() is unnecessary here, It just sets NULL to where already
> is NULL.
> Add a condition.
>
> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> ---
>  mm/slab.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 7dfa481..4e61449 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3109,7 +3109,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
>  	 * treat the array pointers as a reference to the object.
>  	 */
> -	kmemleak_erase(&ac->entry[ac->avail]);
> +	if (objp)
> +		kmemleak_erase(&ac->entry[ac->avail]);
>  	return objp;
>  }

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
