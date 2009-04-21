Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZDUHnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZDUHnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZDUHn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:43:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57967 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZDUHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:43:27 -0400
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
 once
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-12-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-12-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:43:25 +0300
Message-Id: <1240299805.771.46.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> GFP mask is checked for __GFP_COLD has been specified when deciding which
> end of the PCP lists to use. However, it is happening multiple times per
> allocation, at least once per zone traversed. Calculate it once.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |   35 ++++++++++++++++++-----------------
>  1 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1506cd5..51e1ded 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1066,11 +1066,10 @@ void split_page(struct page *page, unsigned int order)
>   */
>  static struct page *buffered_rmqueue(struct zone *preferred_zone,
>  			struct zone *zone, int order, gfp_t gfp_flags,
> -			int migratetype)
> +			int migratetype, int cold)
>  {
>  	unsigned long flags;
>  	struct page *page;
> -	int cold = !!(gfp_flags & __GFP_COLD);
>  	int cpu;
>  
>  again:

Is this a measurable win? And does gcc inline all this nicely or does
this change actually increase kernel text size?

