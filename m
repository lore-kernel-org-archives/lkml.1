Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZGPBC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZGPBC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbZGPBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:02:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39907 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbZGPBC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:02:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] page-allocator: Allow too high-order warning messages to be suppressed with __GFP_NOWARN
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1247656992-19846-2-git-send-email-mel@csn.ul.ie>
References: <1247656992-19846-1-git-send-email-mel@csn.ul.ie> <1247656992-19846-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20090716100217.9D13.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 10:02:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The page allocator warns once when an order >= MAX_ORDER is specified.
> This is to catch callers of the allocator that are always falling back
> to their worst-case when it was not expected. However, there are cases
> where the caller is behaving correctly but cannot suppress the warning.
> This patch allows the warning to be suppressed by the callers by
> specifying __GFP_NOWARN.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index caa9268..b469a05 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1740,8 +1740,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 * be using allocators in order of preference for an area that is
>  	 * too large.
>  	 */
> -	if (WARN_ON_ONCE(order >= MAX_ORDER))
> +	if (order >= MAX_ORDER) {
> +		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
>  		return NULL;
> +	}

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


