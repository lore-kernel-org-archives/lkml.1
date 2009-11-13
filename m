Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZKMFYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZKMFYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 00:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZKMFYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 00:24:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53208 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZKMFYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 00:24:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/5] page allocator: Do not allow interrupts to use ALLOC_HARDER
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1258054235-3208-3-git-send-email-mel@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <1258054235-3208-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20091113142328.33B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 14:24:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.

ditto.
afaik, this patch have been sent to linus.


> 
> [rientjes@google.com: Spotted the problem]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 250d055..2bc2ac6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
>  		 */
>  		alloc_flags &= ~ALLOC_CPUSET;
> -	} else if (unlikely(rt_task(p)))
> +	} else if (unlikely(rt_task(p)) && !in_interrupt())
>  		alloc_flags |= ALLOC_HARDER;
>  
>  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> -- 
> 1.6.5
> 



