Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYI3IeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYI3IeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYI3IeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:34:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYI3IeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:34:08 -0400
Date: Tue, 30 Sep 2008 10:33:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org
Subject: Re: A style question: repeated return value check
Message-ID: <20080930083352.GA10374@elte.hu>
References: <48E11BFA.1070503@gmail.com> <20080929221439.547d65ec@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929221439.547d65ec@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> >  kernel/trace/trace.c |   77 ++++++++++++++++++++++++++-----------------------
> >  kernel/trace/trace.h |   10 ++++++-
> >  2 files changed, 50 insertions(+), 37 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 6ada059..61f33da 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> [...]
> > @@ -1633,24 +1633,24 @@ static int print_trace_fmt(struct trace_iterator *iter)
> >  
> >  	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
> >  	if (!ret)
> > -		return 0;
> > +		return TRACE_TYPE_PARTIAL_LINE;
> >  	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
> >  	if (!ret)
> > -		return 0;
> > +		return TRACE_TYPE_PARTIAL_LINE;
> >  	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
> >  	if (!ret)
> > -		return 0;
> > +		return TRACE_TYPE_PARTIAL_LINE;
> 
> Off-thread style question: Would it be better or worse to write the 
> above as
> 
> 	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
> 	ret = ret && trace_seq_printf(s, "[%03d] ", iter->cpu);
> 	ret = ret && trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
> 	if (!ret)
> 		return TRACE_TYPE_PARTIAL_LINE;
> 
> which would do exactly the same, but is more compact.
> Good or bad style?

in this particular case it's marginally worse style i think, even 
considering that it makes the code more compact. The reason is that it 
makes the code a tiny bit less obvious: the flow looks a bit unusual and 
when skimming it i'd have to look once more to understand its purpose. 
With the returns its more verbose but also plain obvious. YMMV.

	Ingo
