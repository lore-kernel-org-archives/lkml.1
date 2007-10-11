Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXJKGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXJKGxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXJKGxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:53:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbXJKGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:53:12 -0400
Date: Wed, 10 Oct 2007 23:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix printk format strings
Message-Id: <20071010235306.c71afe66.akpm@linux-foundation.org>
In-Reply-To: <1192085221.26648.31.camel@grianne>
References: <1192085221.26648.31.camel@grianne>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 08:47:01 +0200 Vegard Nossum <vegard.nossum@gmail.com> wrote:

> This makes sure printk format strings contain no more than a single
> line.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  mm/page_alloc.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1a8c595..96f0b33 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -198,13 +198,15 @@ static inline int bad_range(struct zone *zone, struct page *page)
>  
>  static void bad_page(struct page *page)
>  {
> -	printk(KERN_EMERG "Bad page state in process '%s'\n"
> -		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
> -		KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
> -		KERN_EMERG "Backtrace:\n",
> -		current->comm, page, (int)(2*sizeof(unsigned long)),
> -		(unsigned long)page->flags, page->mapping,
> +	printk(KERN_EMERG "Bad page state in process '%s'\n", current->comm);
> +	printk(KERN_EMERG
> +		"page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
> +		page, (int) (2 * sizeof(unsigned long)),
> +		(unsigned long) page->flags, page->mapping,
>  		page_mapcount(page), page_count(page));
> +	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
> +	printk(KERN_EMERG "Backtrace:\n");
> +
>  	dump_stack();
>  	page->flags &= ~(1 << PG_lru	|
>  			1 << PG_private |
> @@ -1575,13 +1577,13 @@ void show_free_areas(void)
>  		}
>  	}
>  
> -	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
> -		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> +	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n",
>  		global_page_state(NR_ACTIVE),
>  		global_page_state(NR_INACTIVE),
>  		global_page_state(NR_FILE_DIRTY),
>  		global_page_state(NR_WRITEBACK),
> -		global_page_state(NR_UNSTABLE_NFS),
> +		global_page_state(NR_UNSTABLE_NFS));
> +	printk(" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
>  		global_page_state(NR_FREE_PAGES),
>  		global_page_state(NR_SLAB_RECLAIMABLE) +
>  			global_page_state(NR_SLAB_UNRECLAIMABLE),

I don't understand the reason for this change.

