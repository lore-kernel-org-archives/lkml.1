Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYHRKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYHRKIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYHRKII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:08:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40556 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYHRKIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:08:07 -0400
Date: Mon, 18 Aug 2008 11:08:04 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: mminit_loglevel cannot be __meminitdata anymore
Message-ID: <20080818100803.GA32113@csn.ul.ie>
References: <20080815210216.GA14783@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080815210216.GA14783@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/08/08 23:02), Marcin Slusarz didst pronounce:
> mminit_loglevel is now used from mminit_verify_zonelist <- build_all_zonelists <-
> 
> 1. online_pages <- memory_block_action <- memory_block_change_state <- store_mem_state (sys handler)
> 2. numa_zonelist_order_handler (proc handler)
> 
> so it cannot be annotated __meminit - drop it
> 
> fixes following section mismatch warning:
> WARNING: vmlinux.o(.text+0x71628): Section mismatch in reference from the function mminit_verify_zonelist() to the variable .meminit.data:mminit_loglevel
> The function mminit_verify_zonelist() references
> the variable __meminitdata mminit_loglevel.
> This is often because mminit_verify_zonelist lacks a __meminitdata
> annotation or the annotation of mminit_loglevel is wrong.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/mm_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 936ef2e..4e0e265 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -12,7 +12,7 @@
>  #include "internal.h"
>  
>  #ifdef CONFIG_DEBUG_MEMORY_INIT
> -int __meminitdata mminit_loglevel;
> +int mminit_loglevel;
>  
>  #ifndef SECTIONS_SHIFT
>  #define SECTIONS_SHIFT	0
> -- 
> 1.5.4.5
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
