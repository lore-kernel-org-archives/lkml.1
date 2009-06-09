Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZFIJ3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZFIJ3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZFIJ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:29:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39567 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbZFIJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:29:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
In-Reply-To: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090609181745.DD88.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 18:29:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't know
     ^^^^^^
     lumpy?

> from which LRU "cursor" page came from. Then, putback it to "src" list is BUG.
> Just leave it as it is.
> (And I think rotate here is overkilling even if "src" is correct.)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Yes, thanks great catch!

lumpy reclaimed neighbor pages doesn't need to ratate, it because
neighbor pages doesn't stay in head of lru list.


   Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> ---
>  mm/vmscan.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: mmotm-2.6.30-Jun4/mm/vmscan.c
> ===================================================================
> --- mmotm-2.6.30-Jun4.orig/mm/vmscan.c
> +++ mmotm-2.6.30-Jun4/mm/vmscan.c
> @@ -940,10 +940,9 @@ static unsigned long isolate_lru_pages(u
>  				nr_taken++;
>  				scan++;
>  				break;
> -
>  			case -EBUSY:
> -				/* else it is being freed elsewhere */
> -				list_move(&cursor_page->lru, src);
> +				/* Do nothing because we don't know where
> + 				   cusrsor_page comes from */
>  			default:
>  				break;	/* ! on LRU or wrong list */
>  			}
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



