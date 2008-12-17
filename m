Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757394AbYLQLkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYLQLkQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLQLkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:40:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYLQLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:39:59 -0500
Subject: Re: [PATCH] mm: kill page_queue_congested()
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081217202547.FF22.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081217202547.FF22.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Dec 2008 12:39:50 +0100
Message-Id: <1229513990.9487.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 20:27 +0900, KOSAKI Motohiro wrote:
> ==
> Subject: [PATCH] mm: kill page_queue_congested()
> 
> page_queue_congested() was introduced at 2002.
> but it is unused until now at all.
> 
> it can be removed.

Or we can hook it up in vmscan, and skip congested pages on high scan
order or something..

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/swapfile.c |   20 --------------------
>  1 file changed, 20 deletions(-)
> 
> Index: b/mm/swapfile.c
> ===================================================================
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1203,26 +1203,6 @@ out:
>  	return ret;
>  }
>  
> -#if 0	/* We don't need this yet */
> -#include <linux/backing-dev.h>
> -int page_queue_congested(struct page *page)
> -{
> -	struct backing_dev_info *bdi;
> -
> -	BUG_ON(!PageLocked(page));	/* It pins the swap_info_struct */
> -
> -	if (PageSwapCache(page)) {
> -		swp_entry_t entry = { .val = page_private(page) };
> -		struct swap_info_struct *sis;
> -
> -		sis = get_swap_info_struct(swp_type(entry));
> -		bdi = sis->bdev->bd_inode->i_mapping->backing_dev_info;
> -	} else
> -		bdi = page->mapping->backing_dev_info;
> -	return bdi_write_congested(bdi);
> -}
> -#endif
> -
>  asmlinkage long sys_swapoff(const char __user * specialfile)
>  {
>  	struct swap_info_struct * p = NULL;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
