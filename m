Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbZJIK7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbZJIK7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbZJIK7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:59:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:17519 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760640AbZJIK7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,531,1249282800"; 
   d="scan'208";a="196995249"
Date: Fri, 9 Oct 2009 18:58:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>, Jan Kara <jack@suse.cz>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: account IO throttling wait as iowait
Message-ID: <20091009105847.GA16235@localhost>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com> <20091008015822.GB14224@localhost> <1254989316.26976.260.camel@twins> <20091008083609.GA9228@kernel.dk> <20091009025235.GA28640@localhost> <20091009104105.GY9228@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009104105.GY9228@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 06:41:05PM +0800, Jens Axboe wrote:
> > ---
> > writeback: account IO throttling wait as iowait
> > 
> > It makes sense to do IOWAIT when someone is blocked
> > due to IO throttle, as suggested by Kame and Peter.
> > 
> > There is an old comment for not doing IOWAIT on throttle,
> > however it has been mismatching the code for a long time.
> > 
> > If we stop accounting IOWAIT for 2.6.32, it could be an
> > undesirable behavior change. So restore the io_schedule.
> 
> Thanks, queued up.

Thank you. Would you also pick up this one if it's OK to you?

Thanks,
Fengguang

---
writeback: kill space in debugfs item name

The space is not script friendly, kill it.

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/backing-dev.c	2009-10-09 10:05:27.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-09 18:55:27.000000000 +0800
@@ -92,7 +92,7 @@ static int bdi_debug_stats_show(struct s
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
-		   "WriteBack threads:%8lu\n"
+		   "WritebackThreads: %8lu\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
