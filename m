Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZDUJ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZDUJ5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZDUJ4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:56:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46494 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZDUJ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:56:52 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 15/25] Inline __rmqueue_fallback()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-16-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-16-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421185626.F15C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 18:56:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> __rmqueue_fallback() is in the slow path but has only one call site. It
> actually reduces text if it's inlined.

ditto. I hope to write size command output.


> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2dfe3aa..83da463 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -775,8 +775,8 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>  }
>  
>  /* Remove an element from the buddy allocator from the fallback list */
> -static struct page *__rmqueue_fallback(struct zone *zone, int order,
> -						int start_migratetype)
> +static inline struct page *
> +__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  {
>  	struct free_area * area;
>  	int current_order;
> -- 
> 1.5.6.5
> 



