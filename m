Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZISQxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZISQxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZISQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:53:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZISQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:53:07 -0400
Date: Sat, 19 Sep 2009 18:52:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Allocate the ftrace event
	profile buffer dynamically
Message-ID: <20090919165247.GA9914@elte.hu>
References: <tip-31dcbc09033bd90190e90d943863d7ef9f39b93b@git.kernel.org> <1253367914.20020.338.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253367914.20020.338.camel@gandalf.stny.rr.com>
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

> On Sat, 2009-09-19 at 07:58 +0000, tip-bot for Frederic Weisbecker
> wrote:
> 
> > +/*
> > + * We can't use a size but a type in alloc_percpu()
> > + * So let's create a dummy type that matches the desired size
> > + */
> > +typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
> > +
> >  static int ftrace_profile_enable_event(struct ftrace_event_call *event)
> >  {
> > +	char *buf;
> > +	int ret;
> > +
> >  	if (atomic_inc_return(&event->profile_count))
> >  		return 0;
> >  
> > -	return event->profile_enable();
> > +	buf = (char *)alloc_percpu(profile_buf_t);
> > +	if (!buf)
> > +		return -ENOMEM;
> 
> Ingo,
> 
> Did you pull in the version that allocates a buffer for each event? I 
> thought Frederic made just a global per cpu buffer that all events can 
> use. The buffer is just a temporary storage that will be too big to 
> put on the stack.

Yeah - i had v1 briefly - then pulled in the later (v3) one.

	Ingo
