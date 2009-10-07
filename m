Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZJGXRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZJGXRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZJGXRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:17:34 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35846 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756014AbZJGXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:17:33 -0400
Date: Wed, 7 Oct 2009 19:10:38 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 5/7] this_cpu: Remove slub kmem_cache fields
In-Reply-To: <20091007211052.991681263@gentwo.org>
Message-ID: <alpine.DEB.1.10.0910071907160.3379@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.991681263@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, cl@linux-foundation.org wrote:

> @@ -2387,8 +2364,11 @@ static int kmem_cache_open(struct kmem_c
>  	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
>  		goto error;
>
> -	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
> +	if (!alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
> +
> +	if (s->cpu_slab)
>  		return 1;
> +
>  	free_kmem_cache_nodes(s);

Argh. I goofed while fixing a diff problem shortly before release.

The following patch fixes the patch:

---
 mm/slub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-10-07 18:00:06.000000000 -0500
+++ linux-2.6/mm/slub.c	2009-10-07 18:03:05.000000000 -0500
@@ -2364,9 +2364,7 @@ static int kmem_cache_open(struct kmem_c
 	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		goto error;

-	if (!alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
-
-	if (s->cpu_slab)
+	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
 		return 1;

 	free_kmem_cache_nodes(s);
