Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZGGCMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZGGCMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbZGGCMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:12:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZGGCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:12:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090707104806.6706ac4a.minchan.kim@barrios-desktop>
References: <20090707101855.0C63.A69D9226@jp.fujitsu.com> <20090707104806.6706ac4a.minchan.kim@barrios-desktop>
Message-Id: <20090707111030.0C69.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  7 Jul 2009 11:12:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks good to me. 
> Thanks for your effort. I added my review sign. :)
> 
> Let remain one side note. 
> This accounting feature results from direct reclaim bomb. 
> If we prevent direct reclaim bomb, I think this feature can be removed. 

Hmmm. I disagree.
isolated pages can become more than >1GB on server systems.
Who want >1GB unaccountable memory?



> 
> As I know, Rik or Wu is making patch for throttling direct reclaim. 
> 
> On Tue,  7 Jul 2009 10:19:53 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > > > Index: b/mm/vmscan.c
> > > > > ===================================================================
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -1082,6 +1082,7 @@ static unsigned long shrink_inactive_lis
> > > > >  						-count[LRU_ACTIVE_ANON]);
> > > > >  		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
> > > > >  						-count[LRU_INACTIVE_ANON]);
> > > > > +		__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
> > > > 
> > > > Lumpy can reclaim file + anon anywhere.  
> > > > How about using count[NR_LRU_LISTS]?
> > > 
> > > Ah yes, good catch.
> > 
> > Fixed.
> > 
> > Subject: [PATCH] add isolate pages vmstat
> > 
> > If the system have plenty threads or processes, concurrent reclaim can
> > isolate very much pages.
> > Unfortunately, current /proc/meminfo and OOM log can't show it.
> > 
> > This patch provide the way of showing this information.
> > 
> > 
> > reproduce way
> > -----------------------
> > % ./hackbench 140 process 1000
> >    => couse OOM
> > 
> > Active_anon:146 active_file:41 inactive_anon:0
> >  inactive_file:0 unevictable:0
> >  isolated_anon:49245 isolated_file:113
> >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  dirty:0 writeback:0 buffer:49 unstable:0
> >  free:184 slab_reclaimable:276 slab_unreclaimable:5492
> >  mapped:87 pagetables:28239 bounce:0
> > 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



