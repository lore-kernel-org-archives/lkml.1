Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZGGNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZGGNvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZGGNvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:51:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:17612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZGGNvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,362,1243839600"; 
   d="scan'208";a="162315947"
Date: Tue, 7 Jul 2009 21:51:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Message-ID: <20090707135125.GA9444@localhost>
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop> <20090707090509.0C60.A69D9226@jp.fujitsu.com> <20090707101855.0C63.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707101855.0C63.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:19:53AM +0800, KOSAKI Motohiro wrote:
> > > > Index: b/mm/vmscan.c
> > > > ===================================================================
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -1082,6 +1082,7 @@ static unsigned long shrink_inactive_lis
> > > >  						-count[LRU_ACTIVE_ANON]);
> > > >  		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
> > > >  						-count[LRU_INACTIVE_ANON]);
> > > > +		__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
> > > 
> > > Lumpy can reclaim file + anon anywhere.  
> > > How about using count[NR_LRU_LISTS]?
> > 
> > Ah yes, good catch.
> 
> Fixed.
> 
> Subject: [PATCH] add isolate pages vmstat
> 
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
> Unfortunately, current /proc/meminfo and OOM log can't show it.
> 
> This patch provide the way of showing this information.

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

>  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> -		" inactive_file:%lu"
> -		" unevictable:%lu"
> +		" inactive_file:%lu unevictable:%lu\n"
> +		" isolated_anon:%lu isolated_file:%lu\n"

How about 
        active_anon inactive_anon isolated_anon
        active_file inactive_file isolated_file
?

Thanks,
Fengguang
