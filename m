Return-Path: <linux-kernel-owner+w=401wt.eu-S1763869AbZEADLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763869AbZEADLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZEADLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:11:09 -0400
Received: from ultra7.eskimo.com ([204.122.16.70]:2805 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZEADLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:11:08 -0400
Date: Thu, 30 Apr 2009 20:09:16 -0700
From: Elladan <elladan@eskimo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Elladan <elladan@eskimo.com>, riel@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
Message-ID: <20090501030916.GA25905@eskimo.com>
References: <20090428044426.GA5035@eskimo.com> <20090428192907.556f3a34@bree.surriel.com> <1240987349.4512.18.camel@laptop> <20090429114708.66114c03@cuia.bos.redhat.com> <20090430072057.GA4663@eskimo.com> <20090430174536.d0f438dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430174536.d0f438dd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 05:45:36PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 00:20:58 -0700
> Elladan <elladan@eskimo.com> wrote:
> 
> > > Elladan, does this smaller patch still work as expected?
> > 
> > Rik, since the third patch doesn't work on 2.6.28 (without disabling a lot of
> > code), I went ahead and tested this patch.
> > 
> > The system does seem relatively responsive with this patch for the most part,
> > with occasional lag.  I don't see much evidence at least over the course of a
> > few minutes that it pages out applications significantly.  It seems about
> > equivalent to the first patch.
> > 
> > Given Andrew Morton's request that I track the Mapped: field in /proc/meminfo,
> > I went ahead and did that with this patch built into a kernel.  Compared to the
> > standard Ubuntu kernel, this patch keeps significantly more Mapped memory
> > around, and it shrinks at a slower rate after the test runs for a while.
> > Eventually, it seems to reach a steady state.
> > 
> > For example, with your patch, Mapped will often go for 30 seconds without
> > changing significantly.  Without your patch, it continuously lost about
> > 500-1000K every 5 seconds, and then jumped up again significantly when I
> > touched Firefox or other applications.  I do see some of that behavior with
> > your patch too, but it's much less significant.
> 
> Were you able to tell whether altering /proc/sys/vm/swappiness appropriately
> regulated the rate at which the mapped page count decreased?

I don't believe so.  I tested with swappiness=0 and =60, and in each case the
mapped pages continued to decrease.  I don't know at what rate though.  If
you'd like more precise data, I can rerun the test with appropriate logging.  I
admit my "Hey, latency is terrible and mapped pages is decreasing" testing is
somewhat unscientific.

I get the impression that VM regressions happen fairly regularly.  Does anyone
have good unit tests for this?  Is seems like a difficult problem, since it's
partly based on pattern and partly timing.

-J
