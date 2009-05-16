Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZEPJ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZEPJ1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZEPJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:27:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:50698 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbZEPJ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,204,1241420400"; 
   d="scan'208";a="143512651"
Date: Sat, 16 May 2009 17:26:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090516092645.GA11652@localhost>
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025058.GA7518@localhost> <4A09778B.5030809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09778B.5030809@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:20:11PM +0800, Rik van Riel wrote:
> Wu Fengguang wrote:
> 
> >> Also, the change makes this comment:
> >>
> >> 	spin_lock_irq(&zone->lru_lock);
> >> 	/*
> >> 	 * Count referenced pages from currently used mappings as
> >> 	 * rotated, even though they are moved to the inactive list.
> >> 	 * This helps balance scan pressure between file and anonymous
> >> 	 * pages in get_scan_ratio.
> >> 	 */
> >> 	reclaim_stat->recent_rotated[!!file] += pgmoved;
> >>
> >> inaccurate.
> > 
> > Good catch, I'll just remove the stale "even though they are moved to
> > the inactive list".
> 
> Well, it is still true for !VM_EXEC pages.

This comment?

        Count referenced pages from currently used mappings as rotated, even
        though only some of them are actually re-activated. This helps...

Thanks,
Fengguang
