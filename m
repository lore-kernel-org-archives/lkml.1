Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZDWALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZDWALc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZDWALW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:11:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53253 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDWALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:11:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 16/22] Do not setup zonelist cache when there is only one node
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904221333040.14558@chino.kir.corp.google.com>
References: <1240432339.22694.64.camel@lts-notebook> <alpine.DEB.2.00.0904221333040.14558@chino.kir.corp.google.com>
Message-Id: <20090423090704.F6E3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 23 Apr 2009 09:11:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 22 Apr 2009, Lee Schermerhorn wrote:
> 
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 7f45de1..e59bb80 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -1467,8 +1467,11 @@ this_zone_full:
> > > >  		if (NUMA_BUILD)
> > > >  			zlc_mark_zone_full(zonelist, z);
> > > 
> > > If zonelist caching is never used for UMA machines, why should they ever 
> > > call zlc_mark_zone_full()?  It will always dereference 
> > > zonelist->zlcache_ptr and immediately return without doing anything.
> > > 
> > > Wouldn't it better to just add
> > > 
> > > 	if (num_online_nodes() == 1)
> > > 		continue;
> > > 
> > > right before this call to zlc_mark_zone_full()?  This should compile out 
> > > the remainder of the loop for !CONFIG_NUMA kernels anyway.
> > 
> > Shouldn't it already do that?  NUMA_BUILD is defined as 0 when
> > !CONFIG_NUMA to avoid #ifdef's in the code while still allowing compiler
> > error checking in the dead code.
> > 
> 
> Yeah, but adding the check on num_online_nodes() also prevents needlessly 
> calling zlc_mark_zone_full() on CONFIG_NUMA kernels when running on an UMA 
> machine.

I don't like this idea...

In UMA system, zlc_mark_zone_full() isn't so expensive. but In large system
one branch increasing is often costly.



