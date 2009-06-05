Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZFESWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZFESWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZFESWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:22:03 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:38557 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbZFESWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:22:02 -0400
X-Trace: 210087082/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.42.194/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.42.194
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMCACj/KEpQKSrC/2dsb2JhbAAI0VaCP4FLBQ
X-IronPort-AV: E=Sophos;i="4.41,312,1241391600"; 
   d="scan'208";a="210087082"
Date: Fri, 5 Jun 2009 19:05:54 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH][mmtom] remove file arguement of swap_readpage
In-Reply-To: <1244212423-18629-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <Pine.LNX.4.64.0906051904060.14826@sister.anvils>
References: <1244212423-18629-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Minchan Kim wrote:

> The file argument resulted from address_space's readpage
> long time ago.
> 
> Now we don't use it any more. Let's remove unnecessary
> argement.
> 
> This patch cleans up swap_readpage.
> It doesn't affect behavior of function.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Rik van Riel <riel@redhat.com>

Okay, yes: but don't be surprised if someone sends in a patch
to put it back, as in the other readpage()s.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  include/linux/swap.h |    2 +-
>  mm/page_io.c         |    2 +-
>  mm/swap_state.c      |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2dedc2d..c88b366 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -256,7 +256,7 @@ extern void swap_unplug_io_fn(struct backing_dev_info *, struct page *);
>  
>  #ifdef CONFIG_SWAP
>  /* linux/mm/page_io.c */
> -extern int swap_readpage(struct file *, struct page *);
> +extern int swap_readpage(struct page *);
>  extern int swap_writepage(struct page *page, struct writeback_control *wbc);
>  extern void end_swap_bio_read(struct bio *bio, int err);
>  
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3023c47..c6f3e50 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -120,7 +120,7 @@ out:
>  	return ret;
>  }
>  
> -int swap_readpage(struct file *file, struct page *page)
> +int swap_readpage(struct page *page)
>  {
>  	struct bio *bio;
>  	int ret = 0;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b62e7f5..42cd38e 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -313,7 +313,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  			 * Initiate read into locked page and return.
>  			 */
>  			lru_cache_add_anon(new_page);
> -			swap_readpage(NULL, new_page);
> +			swap_readpage(new_page);
>  			return new_page;
>  		}
>  		ClearPageSwapBacked(new_page);
> -- 
> 1.5.6.5
> 
