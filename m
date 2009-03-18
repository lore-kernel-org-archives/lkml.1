Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZCRIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZCRIvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZCRIvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:51:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:45730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZCRIvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:51:00 -0400
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
From: Peter Zijlstra <peterz@infradead.org>
To: Luis Henriques <henrix@sapo.pt>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090318002327.GA2382@hades.domain.com>
References: <20090318000343.GA2189@hades.domain.com>
	 <1237334969.5189.1242.camel@laptop>
	 <20090318002327.GA2382@hades.domain.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:50:48 +0100
Message-Id: <1237366248.5069.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 00:23 +0000, Luis Henriques wrote:
> On Wed, Mar 18, 2009 at 01:09:29AM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-03-18 at 00:03 +0000, Luis Henriques wrote:
> > > Since they are used on in statistics and are always set to zero, the following
> > > frields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> > > yld_both_empty.
> > > 
> > > Signed-off-by: Luis Henriques <henrix@sapo.pt>
> > > ---
> > 
> > > +++ b/kernel/sched_stats.h
> > > @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
> > >  
> > >  		/* runqueue-specific stats */
> > >  		seq_printf(seq,
> > > -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
> > > -		    cpu, rq->yld_both_empty,
> > > -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
> > > +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> > > +		    cpu, rq->yld_count,
> > >  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
> > >  		    rq->ttwu_count, rq->ttwu_local,
> > >  		    rq->rq_cpu_time,
> > 
> > I think this bit is ABI, so you either have to bump the version number
> > or emit 0s, iirc gregory touched some of that last -- or at least wrote
> > userspace for it..
> 
> Hmm... you're right.  I should have though about that.  Anyway, what is the
> the best approach here?
> 
> I know that changes in ABI shall not break anything, but just increasing the
> version number will really solve the issue?  Will userspace care for this?
> On the other hand, just writting 0s does not sound interesting either...

I really don't know, Greg, do you as a schedstat user have an opinion?

There is a 3rd option though, you could figure out what they were
supposed to count and see if that can be mapped on the current code.

Not at all sure that's worth the trouble though -- but for completeness
sake, I felt the need to mention it :-)

