Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZJZBPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZJZBPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZJZBPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:15:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZJZBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:15:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/5] page allocator: Do not allow interrupts to use ALLOC_HARDER
Cc: kosaki.motohiro@jp.fujitsu.com, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <1256221356-26049-3-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20091026101420.2F53.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 26 Oct 2009 10:15:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.
> 
> [rientjes@google.com: Spotted the problem]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dfa4362..7f2aa3e 100644
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
> 1.6.3.3

good catch.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




