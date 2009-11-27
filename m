Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZK0G3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZK0G3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZK0G3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:29:08 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38638 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZK0G3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:29:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091127143307.A7E1.A69D9226@jp.fujitsu.com>
References: <20091126141738.GE13095@csn.ul.ie> <20091127143307.A7E1.A69D9226@jp.fujitsu.com>
Message-Id: <20091127152824.A7EA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 15:29:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead, PF_MEMALLOC is good idea?

This patch was obviously wrong. please forget it. i'm sorry.

> 
> 
> Subject: [PATCH] cfq: Do not limit the async queue depth while memory reclaim
> 
> Not-Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (I haven't test this)
> ---
>  block/cfq-iosched.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index aa1e953..9546f64 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1308,7 +1308,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	 * We also ramp up the dispatch depth gradually for async IO,
>  	 * based on the last sync IO we serviced
>  	 */
> -	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency) {
> +	if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency &&
> +	    !(current->flags & PF_MEMALLOC)) {
>  		unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
>  		unsigned int depth;
>  
> -- 
> 1.6.5.2
> 
> 
> 
> 
> 
> 



