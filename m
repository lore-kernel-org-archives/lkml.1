Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0CHQJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:09:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48174 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0CHQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:09:38 -0500
Date: Mon, 8 Mar 2010 16:09:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
Message-ID: <20100308160920.GA13788@csn.ul.ie>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:21:04AM +0100, Thomas Gleixner wrote:
> __zone_pcp_update() iterates over NR_CPUS instead of limiting the
> access to the possible cpus. This might result in access to
> uninitialized areas as the per cpu allocator only populates the per
> cpu memory for possible cpus.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks good.

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -3224,7 +3224,7 @@ static int __zone_pcp_update(void *data)
>  	int cpu;
>  	unsigned long batch = zone_batchsize(zone), flags;
>  
> -	for (cpu = 0; cpu < NR_CPUS; cpu++) {
> +	for_each_possible_cpu(cpu) {
>  		struct per_cpu_pageset *pset;
>  		struct per_cpu_pages *pcp;
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
