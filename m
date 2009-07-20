Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZGTTmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZGTTmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZGTTmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:42:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZGTTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:42:13 -0400
Date: Mon, 20 Jul 2009 15:42:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: Provide iowait counters
In-Reply-To: <1248117369.23509.33.camel@laptop>
Message-ID: <alpine.DEB.2.00.0907201540550.26208@gandalf.stny.rr.com>
References: <4A64B813.1080506@linux.intel.com> <1248117369.23509.33.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Jul 2009, Peter Zijlstra wrote:
> 
> > +++ b/kernel/sched_fair.c
> > @@ -633,6 +633,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >   		se->block_start = 0;
> >   		se->sum_sleep_runtime += delta;
> > 
> > +		if (tsk->in_iowait) {
> > +			se->iowait_sum += delta;
> > +			se->iowait_count++;
> > +		}
> > +
> >   		/*
> >   		 * Blocking time is in units of nanosecs, so shift by 20 to
> >   		 * get a milliseconds-range estimation of the amount of
> 
> It might be nice to put a tracepoint there as well, now if there was a
> way to specify perf counter attributes in the TRACE_EVENT() magic so
> that we can feed stuff into perf_tpcounter_event().
> 
> TP_perf_addr()  -- defaults to 0 when not specified
> TP_perf_count() -- defaults to 1 when not specified.
> 
> Steve, Frederic, is there any way to make that happen?
> 
> Failing that we could put an actual swcounter in there I suppose.
> 
> That way we could profile applications based on IO-wait, which would be
> cool.

How would you imagine an interface for this? Could you come up with 
something that you would like to see, and then I could see if we could 
implement it. 

How would the TRACE_EVENT look exactly? Would there be anything different 
in the trace point location itself?

Thanks,

-- Steve

