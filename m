Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbXDREfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbXDREfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDREfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:35:44 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:53873 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXDREfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:35:43 -0400
Message-ID: <46259FEF.9090300@cosmosbay.com>
Date: Wed, 18 Apr 2007 06:34:55 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: clameter@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] slab: resize the alien caches too
References: <20070418004418.GA30721@linux-os.sc.intel.com>
In-Reply-To: <20070418004418.GA30721@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 18 Apr 2007 06:35:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B a écrit :
> Christoph,
> 
> While going through the slab code, I observed that alien caches are
> not getting resized, when user changes the slab tunables. Appended patch
> tries to fix this. Please review and let me know if I missed anything.
> 
> thanks,
> suresh
> ---
> 
> Resize the alien caches too based on the slab tunables.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 4cbac24..e0dd9af 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3823,6 +3823,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
>  		l3 = cachep->nodelists[node];
>  		if (l3) {
>  			struct array_cache *shared = l3->shared;
> +			struct array_cache **alien = l3->alien;
>  
>  			spin_lock_irq(&l3->list_lock);
>  

Christoph already rejected the patch, but I have one further comment : 
l3->alien should be fetched after spin_lock_irq() of course.

It's true that the :
if (limit > 1) limit = 12;
from alloc_alien_cache() is quite disturbing and could be cleaned up.


