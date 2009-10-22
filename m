Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZJVQdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZJVQdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbZJVQdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:33:05 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:33765 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756278AbZJVQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:33:03 -0400
X-Sender-Authentication: net64
Date: Thu, 22 Oct 2009 18:33:03 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/5] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-Id: <20091022183303.2448942d.skraw@ithnet.com>
In-Reply-To: <1256221356-26049-3-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
	<1256221356-26049-3-git-send-email-mel@csn.ul.ie>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 15:22:33 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

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
> 

Is it correct that this one applies offset -54 lines in 2.6.31.4 ? 

-- 
Regards,
Stephan
