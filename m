Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZDUJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZDUJ4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbZDUJ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:56:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34168 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZDUJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:56:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 14/25] Inline buffered_rmqueue()
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
In-Reply-To: <1240266011-11140-15-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-15-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421185442.F159.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 18:56:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> buffered_rmqueue() is in the fast path so inline it. Because it only has
> one call site, this actually should reduce text bloat instead of
> increase it.

nit: please append size command output.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 91a2cdb..2dfe3aa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1077,7 +1077,8 @@ void split_page(struct page *page, unsigned int order)
>   * we cheat by calling it from here, in the order > 0 path.  Saves a branch
>   * or two.
>   */
> -static struct page *buffered_rmqueue(struct zone *preferred_zone,
> +static inline
> +struct page *buffered_rmqueue(struct zone *preferred_zone,
>  			struct zone *zone, int order, gfp_t gfp_flags,
>  			int migratetype, int cold)
>  {
> -- 
> 1.5.6.5
> 



