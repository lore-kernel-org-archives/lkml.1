Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZJHIgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZJHIgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZJHIgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:36:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60327 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbZJHIgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:36:46 -0400
Date: Thu, 8 Oct 2009 10:36:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
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
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
	balance_dirty_pages()
Message-ID: <20091008083609.GA9228@kernel.dk>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com> <20091008015822.GB14224@localhost> <1254989316.26976.260.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254989316.26976.260.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08 2009, Peter Zijlstra wrote:
> On Thu, 2009-10-08 at 09:58 +0800, Wu Fengguang wrote:
> > 
> > > How this runqueue->nr_iowait is handled now ?
> > 
> > Good question. io_schedule() has an old comment for throttling IO wait:
> > 
> >          * But don't do that if it is a deliberate, throttling IO wait (this task
> >          * has set its backing_dev_info: the queue against which it should throttle)
> >          */
> >         void __sched io_schedule(void)
> > 
> > So it looks both Jens' and this patch behaves right in ignoring the
> > iowait accounting for balance_dirty_pages() :)
> 
> Well it is a change in behaviour, and I think IOWAIT makes sense when
> we're blocked due to io throttle..
> 
> Hmm?

Yep agree, if we're deliberately waiting on IO, it should count as
iowait time.

-- 
Jens Axboe

