Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZGGBsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZGGBsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZGGBsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:48:13 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:49078 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZGGBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=f/ZO2St6QTgFjJZAmHC3aJqlDnbObdYmN1UAu2SkT9GrJyeX6zYqKJxZe0ewYvDn6P
         i+7mP2+oAbdmiBIgJTH7WsVR6/D0KhLtr5FwL2Cic/D4COW4iv697cMRo3oN6YZSorm9
         ImZCqf/9DQwoTJgzVOIeT1gdAAvipD/khgW+U=
Date: Tue, 7 Jul 2009 10:48:06 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Message-Id: <20090707104806.6706ac4a.minchan.kim@barrios-desktop>
In-Reply-To: <20090707101855.0C63.A69D9226@jp.fujitsu.com>
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop>
	<20090707090509.0C60.A69D9226@jp.fujitsu.com>
	<20090707101855.0C63.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks good to me. 
Thanks for your effort. I added my review sign. :)

Let remain one side note. 
This accounting feature results from direct reclaim bomb. 
If we prevent direct reclaim bomb, I think this feature can be removed. 

As I know, Rik or Wu is making patch for throttling direct reclaim. 

On Tue,  7 Jul 2009 10:19:53 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

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
> 
> 
> reproduce way
> -----------------------
> % ./hackbench 140 process 1000
>    => couse OOM
> 
> Active_anon:146 active_file:41 inactive_anon:0
>  inactive_file:0 unevictable:0
>  isolated_anon:49245 isolated_file:113
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  dirty:0 writeback:0 buffer:49 unstable:0
>  free:184 slab_reclaimable:276 slab_unreclaimable:5492
>  mapped:87 pagetables:28239 bounce:0
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
