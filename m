Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZJMHJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZJMHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbZJMHJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:09:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933529AbZJMHJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:09:56 -0400
Date: Tue, 13 Oct 2009 09:08:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
Message-ID: <20091013070853.GA13175@elte.hu>
References: <4A7F8B2B.5020908@cn.fujitsu.com> <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org> <1255404309.7113.948.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255404309.7113.948.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2009-09-02 at 12:18 +0000, tip-bot for Xiao Guangrong wrote:
> 
> > +/**
> > + * hrtimer_start - called when the hrtimer is started
> > + * @timer: pointer to struct hrtimer
> > + */
> > +TRACE_EVENT(hrtimer_start,
> > +
> > +	TP_PROTO(struct hrtimer *timer),
> > +
> > +	TP_ARGS(timer),
> > +
> > +	TP_STRUCT__entry(
> > +		__field( void *,	timer		)
> > +		__field( void *,	function	)
> > +		__field( s64,		expires		)
> > +		__field( s64,		softexpires	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->timer		= timer;
> > +		__entry->function	= timer->function;
> > +		__entry->expires	= hrtimer_get_expires(timer).tv64;
> > +		__entry->softexpires	= hrtimer_get_softexpires(timer).tv64;
> > +	),
> > +
> > +	TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
> > +		  __entry->timer, __entry->function,
> > +		  (unsigned long long)ktime_to_ns((ktime_t) {
> > +				  .tv64 = __entry->expires }),
> > +		  (unsigned long long)ktime_to_ns((ktime_t) {
> > +				  .tv64 = __entry->softexpires }))
> > +);
> > +
> 
> I was just fixing up the trace-cmd parser (which is also used for perf)
> and came across this code. That TP_printk shows up in the format file
> as:
> 
> print fmt: "hrtimer %p, func %pf, expires %llu, softexpires %llu", REC->timer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64), (unsigned long long)(((ktime_t) { .tv64 = REC->softexpires }).tv64)
> 
> Now I'm trying to parse this with a tool so that we can have something
> that can read the binary output, and be able to easily figure it out by
> reading the format files. But trying to parse:
> 
> (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> 
> Is not easy. It's basically implementing a C interpreter :-(

Btw., what i suggested quite some time ago was that we should bind 
tracepoints by emitting C source code stubs, which tools can then build 
and link in, using gcc.

	Ingo
