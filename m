Return-Path: <linux-kernel-owner+w=401wt.eu-S936871AbYBWIT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936871AbYBWIT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764195AbYBWIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765815AbYBWII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:57 -0500
Date: Sat, 23 Feb 2008 00:05:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 08/28] mm: system wide ALLOC_NO_WATERMARK
Message-Id: <20080223000557.82125b3c.akpm@linux-foundation.org>
In-Reply-To: <20080220150306.297640000@chello.nl>
References: <20080220144610.548202000@chello.nl>
	<20080220150306.297640000@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:46:18 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Change ALLOC_NO_WATERMARK page allocation such that the reserves are system
> wide - which they are per setup_per_zone_pages_min(), when we scrape the
> barrel, do it properly.
> 

The changelog is fairly incomprehensible.

>  mm/page_alloc.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1552,6 +1552,12 @@ restart:
>  rebalance:
>  	if (alloc_flags & ALLOC_NO_WATERMARKS) {
>  nofail_alloc:
> +		/*
> +		 * break out of mempolicy boundaries
> +		 */
> +		zonelist = NODE_DATA(numa_node_id())->node_zonelists +
> +			gfp_zone(gfp_mask);
> +
>  		/* go through the zonelist yet again, ignoring mins */
>  		page = get_page_from_freelist(gfp_mask, order, zonelist,
>  				ALLOC_NO_WATERMARKS);

As is the patch.  People who care about mempolicies will want a better
explanation, please, so they can check that we're not busting their stuff.

