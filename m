Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYGXLQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYGXLQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYGXLPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:15:52 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:44193 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYGXLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:15:51 -0400
X-SourceIP: 62.163.52.83
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080724040954.6402e73f.akpm@linux-foundation.org>
References: <20080721153804.GA26072@elte.hu>
	 <1216657892.2294.34.camel@dhcp32.mvista.com>
	 <1216668182.7257.80.camel@twins>
	 <1216671393.2294.49.camel@dhcp32.mvista.com>
	 <1216896193.7257.267.camel@twins>
	 <20080724040954.6402e73f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 13:15:43 +0200
Message-Id: <1216898143.7257.297.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 04:09 -0700, Andrew Morton wrote:
> On Thu, 24 Jul 2008 12:43:13 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Mon, 2008-07-21 at 13:16 -0700, Daniel Walker wrote:
> > > On Mon, 2008-07-21 at 21:23 +0200, Peter Zijlstra wrote:
> > > 
> > > > Does this work for you?
> > > > 
> > > 
> > > Yours removed the warning .. I made an alternate one below only compile
> > > tested, your choice..
> > 
> > How about this one - it seems there is a whole scala of new division
> > instructions these days... :-)
> > 
> 
> ain't life grand.
> 
> > 
> > 
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index 47ceac9..3c38686 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -253,7 +253,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
> >  
> >  		diff = iter->rt_runtime - iter->rt_time;
> >  		if (diff > 0) {
> > -			do_div(diff, weight);
> > +			diff = div_u64((u64)diff, weight);
> 
> Can't use div_s64() here?

I guess we could, but since we already established >0, I thought using
the u64 version might be slightly cheaper - but what do I know..

> >  			if (rt_rq->rt_runtime + diff > rt_period)
> >  				diff = rt_period - rt_rq->rt_runtime;
> >  			iter->rt_runtime -= diff;
> > 

