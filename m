Return-Path: <linux-kernel-owner+w=401wt.eu-S935811AbXGZSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbXGZSFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934475AbXGZSEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:04:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbXGZSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:04:52 -0400
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known
	regressions with patches]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1185441963.8197.67.camel@twins>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu>  <1185441963.8197.67.camel@twins>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 20:04:37 +0200
Message-Id: <1185473077.15205.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 11:26 +0200, Peter Zijlstra wrote:

> ---
>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c
> +++ linux-2.6/mm/slub.c
> @@ -1131,6 +1131,7 @@ static void __free_slab(struct kmem_cach
>  		slab_pad_check(s, page);
>  		for_each_object(p, s, page_address(page))
>  			check_object(s, page, p, 0);
> +		ClearSlabDebug(page);
>  	}
>  
>  	mod_zone_page_state(page_zone(page),
> @@ -1169,7 +1170,6 @@ static void discard_slab(struct kmem_cac
>  
>  	atomic_long_dec(&n->nr_slabs);
>  	reset_page_mapcount(page);
> -	ClearSlabDebug(page);
>  	__ClearPageSlab(page);
>  	free_slab(s, page);
>  }
> 

Christoph, how about this bit, it looks to me like we clear SlabDebug()
before we hit the last check in __free_slab().

