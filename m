Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZDUJwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZDUJwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZDUJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:52:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46292 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZDUJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:52:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 13/25] Inline __rmqueue_smallest()
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
In-Reply-To: <1240266011-11140-14-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-14-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421185025.F156.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 18:52:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Inline __rmqueue_smallest by altering flow very slightly so that there
> is only one call site. This allows the function to be inlined without
> additional text bloat.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/page_alloc.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b13fc29..91a2cdb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -665,7 +665,8 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
>   * Go through the free lists for the given migratetype and remove
>   * the smallest available page from the freelists
>   */
> -static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> +static inline
> +struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>  						int migratetype)

"only one caller" is one of keypoint of this patch, I think.
so, commenting is better? but it isn't blocking reason at all.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



