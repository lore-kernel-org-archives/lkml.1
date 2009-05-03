Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZECDoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZECDoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 23:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZECDoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 23:44:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:4821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZECDo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 23:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,284,1239001200"; 
   d="scan'208";a="138557749"
Date: Sun, 3 May 2009 11:43:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
Message-ID: <20090503034345.GA12283@localhost>
References: <20090430072057.GA4663@eskimo.com> <20090430174536.d0f438dd.akpm@linux-foundation.org> <20090430205936.0f8b29fc@riellaptop.surriel.com> <20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> <20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <20090502232403.3ca10b97@riellaptop.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502232403.3ca10b97@riellaptop.surriel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:24:03AM +0800, Rik van Riel wrote:
> On Sun, 3 May 2009 11:15:39 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Commit 7e9cd484204f(vmscan: fix pagecache reclaim referenced bit
> > check) tries to address scalability problem when every page get
> > mapped and referenced, so that logic(which lowed the priority of
> > mapped pages) could be enabled only on conditions like (priority <
> > DEF_PRIORITY).
> > 
> > Or preferably we can explicitly protect the mapped executables,
> > as illustrated by this patch (a quick prototype).
> 
> Over time, given enough streaming IO and idle applications,
> executables will still be evicted with just this patch.
> 
> However, a combination of your patch and mine might do the
> trick.  I suspect that executables are never a very big
> part of memory, except on small memory systems, so protecting
> just the mapped executables should not be a scalability
> problem.

Yes, that's my intent to take advantage of you patch :-)

There may be programs that embed large amount of static data with
them - think about self-decompression data - but that's fine: this
patch behaves not in a too persistent way. Plus we can apply a size
limit(say 100M) if necessary.

> My patch in combination with your patch should make sure
> that if something gets evicted from the active list, it's
> not executables - meanwhile, lots of the time streaming
> IO will completely leave the active file list alone.
 
They together make
- mapped executable pages the first class citizen;
- streaming IO least intrusive.

I think that would make most desktop users and server administrators
contented and comfortable :-)

Thanks,
Fengguang

