Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZEPNr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZEPNr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZEPNrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:47:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:17772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZEPNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,204,1241420400"; 
   d="scan'208";a="143550747"
Date: Sat, 16 May 2009 21:47:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] vmscan: merge duplicate code in
	shrink_active_list()
Message-ID: <20090516134718.GA15263@localhost>
References: <20090516090005.916779788@intel.com> <20090516090448.535217680@intel.com> <20090516133950.GA5775@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516133950.GA5775@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 09:39:50PM +0800, Johannes Weiner wrote:
> On Sat, May 16, 2009 at 05:00:08PM +0800, Wu Fengguang wrote:
> > The "move pages to active list" and "move pages to inactive list"
> > code blocks are mostly identical and can be served by a function.
> > 
> > Thanks to Andrew Morton for pointing this out.
> > 
> > Note that buffer_heads_over_limit check will also be carried out
> > for re-activated pages, which is slightly different from pre-2.6.28
> > kernels. Also, Rik's "vmscan: evict use-once pages first" patch
> > could totally stop scans of active list when memory pressure is low.
> > So the net effect could be, the number of buffer heads is now more
> > likely to grow large.
> 
> I don't think that this could be harmful.  We just preserve the buffer
> mappings of what we consider the working set and with low memory
> pressure, as you say, this set is not big.
> 
> As to stripping of reactivated pages: the only pages we re-activate
> for now are those VM_EXEC mapped ones.  Since we don't expect IO from
> or to these pages, removing the buffer mappings in case they grow too
> large should be okay, I guess.

Agreed - and good analyzes, thanks!

Fengguang

> > CC: Rik van Riel <riel@redhat.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
