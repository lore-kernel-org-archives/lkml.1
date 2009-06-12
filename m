Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbZFLRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbZFLRdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZFLRds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:33:48 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59548 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751206AbZFLRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:33:47 -0400
Date: Fri, 12 Jun 2009 13:30:33 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
Message-ID: <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Pekka J Enberg wrote:

> @@ -3434,6 +3451,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
>  	unsigned long save_flags;
>  	void *objp;
>
> +	flags &= slab_gfp_mask;
> +
>  	lockdep_trace_alloc(flags);
>
>  	if (slab_should_failslab(cachep, flags))

Adds code to hot code path.

> @@ -1595,6 +1601,8 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
>  	unsigned long flags;
>  	unsigned int objsize;
>
> +	gfpflags &= slab_gfp_mask;
> +
>  	lockdep_trace_alloc(gfpflags);
>  	might_sleep_if(gfpflags & __GFP_WAIT);
>

Adds code to hot code path.

The allocators mask flags passed to the page allocator through
GFP_RECLAIM_MASK|GFP_CONSTRAINT_MASK. This is done outside of the critical
code paths.

The might_sleep issues may be fixed by adding another check to
__might_sleep().


