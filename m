Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZERClV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZERClV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZERClL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:41:11 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:63958 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZERClL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=cSyGJLWNVfTf55PcJzB4X2sOlrBiwJHvUfRytJlX3fzPBDQ5DTLUb032FJobG742pR
         Vypp+fcRzRyF+Q8X+tHRc4hzCq523azocFgFEPmUZVZaFyAdZ9Da0Bfl/MC2tumdw1v/
         lGNto6TEAh511UYUiAwmV2KUByc2Qc+/wLq+c=
Date: Mon, 18 May 2009 11:40:53 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in
 case of no swap space V3
Message-Id: <20090518114053.ed5af657.minchan.kim@barrios-desktop>
In-Reply-To: <20090518023404.GB5869@localhost>
References: <20090514231555.f52c81eb.minchan.kim@gmail.com>
	<20090518023404.GB5869@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 10:34:04 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, May 14, 2009 at 11:15:55PM +0900, MinChan Kim wrote:
>  
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 2f9d555..621708f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >  	 * Even if we did not try to evict anon pages at all, we want to
> >  	 * rebalance the anon lru active/inactive ratio.
> >  	 */
> > -	if (inactive_anon_is_low(zone, sc))
> > +	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> >  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> 
> There's another "if (inactive_anon_is_low) shrink_active_list;"
> occurrence to be fixed in balance_pgdat()? Otherwise:

I add Rik's comment. Of course, I agree his opinion. 

"If we are close to running out of swap space, with
swapins freeing up swap space on a regular basis,
I believe we do want to do aging on the active
pages, just so we can pick a decent page to swap
out next time swap space becomes available."

> Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks for spending your time for my patch. Wu Fengguang :)

-- 
Kinds Regards
Minchan Kim
