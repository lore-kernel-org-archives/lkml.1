Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZEIXEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZEIXEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 19:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZEIXEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 19:04:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52630 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZEIXE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 19:04:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Sun, 10 May 2009 01:03:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905092337.39906.rjw@sisk.pl> <alpine.DEB.2.00.0905091536250.6272@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905091536250.6272@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905100103.23815.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009, David Rientjes wrote:
> On Sat, 9 May 2009, Rafael J. Wysocki wrote:
> 
> > > This has been changed in the latest mmotm with Mel's page alloactor 
> > > patches (and I think yours should be based on mmotm).  Specifically, 
> > > page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch.
> > > 
> > > Before his patchset, zonelists that had ZONE_OOM_LOCKED set for at least 
> > > one of their zones would unconditionally goto restart.  Now, if
> > > order > PAGE_ALLOC_COSTLY_ORDER, it gives up and returns NULL.  Otherwise, 
> > > it does goto restart.
> > > 
> > > So if your allocation has order > PAGE_ALLOC_COSTLY_ORDER,
> > 
> > It doesn't.  All of my allocations are of order 0.
> > 
> 
> All order 0 allocations are implicitly __GFP_NOFAIL and will loop 
> endlessly unless they can't block.  So if you want to simply prohibit the 
> oom killer from being invoked and not change the retry behavior, setting 
> ZONE_OOM_LOCKED for all zones will do that.  If your machine hangs, it 
> means nothing can be reclaimed and you can't free memory via oom killing, 
> so there's nothing else the page allocator can do.

But I want it to give up in this case instead of looping forever.

Look.  I have a specific problem at hand that I want to solve and the approach
you suggested _clearly_ _doesn't_ _work_.  I have also tried to explain to you
why it doesn't work, but you're ingnoring it, so I really don't know what else
I can say.

OTOH, the approach suggested by Andrew _does_ _work_ regardless of your
opinion about it.  It's been tested and it's done the job 100% of the time.  Go
figure.  And please stop beating the dead horse.

Thanks,
Rafael
