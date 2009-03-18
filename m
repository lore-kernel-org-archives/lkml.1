Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZCRAc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZCRAc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZCRAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:32:20 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:58937 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752676AbZCRAcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:32:19 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 00:23:27 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318002327.GA2382@hades.domain.com>
References: <20090318000343.GA2189@hades.domain.com> <1237334969.5189.1242.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237334969.5189.1242.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 01:09:29AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-03-18 at 00:03 +0000, Luis Henriques wrote:
> > Since they are used on in statistics and are always set to zero, the following
> > frields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> > yld_both_empty.
> > 
> > Signed-off-by: Luis Henriques <henrix@sapo.pt>
> > ---
> 
> > +++ b/kernel/sched_stats.h
> > @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
> >  
> >  		/* runqueue-specific stats */
> >  		seq_printf(seq,
> > -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
> > -		    cpu, rq->yld_both_empty,
> > -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
> > +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> > +		    cpu, rq->yld_count,
> >  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
> >  		    rq->ttwu_count, rq->ttwu_local,
> >  		    rq->rq_cpu_time,
> 
> I think this bit is ABI, so you either have to bump the version number
> or emit 0s, iirc gregory touched some of that last -- or at least wrote
> userspace for it..

Hmm... you're right.  I should have though about that.  Anyway, what is the
the best approach here?

I know that changes in ABI shall not break anything, but just increasing the
version number will really solve the issue?  Will userspace care for this?
On the other hand, just writting 0s does not sound interesting either...

-- 
Luis Henriques
