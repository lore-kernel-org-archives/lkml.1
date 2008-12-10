Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYLJSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYLJSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYLJSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:53:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52838 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYLJSxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:53:11 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 10:53:04 -0800
Message-Id: <1228935184.9737.91.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 18:27 +0000, Catalin Marinas wrote:
> @@ -3195,6 +3203,8 @@ static inline void *____cache_alloc(struct
> kmem_cache *cachep, gfp_t flags)
>                 STATS_INC_ALLOCMISS(cachep);
>                 objp = cache_alloc_refill(cachep, flags);
>         }
> +       /* avoid false negatives */
> +       memleak_erase(&ac->entry[ac->avail]);
>         return objp;
>  }

It would be really nice here to say *how* it is avoiding false
negatives. :)

How about:

/* Don't let the pointer from the slab itself count as referencing */

-- Dave

