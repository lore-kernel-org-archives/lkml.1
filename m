Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYLDPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYLDPgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYLDPfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:35:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbYLDPfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:35:47 -0500
Date: Thu, 4 Dec 2008 16:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] tracing: fix typo and missing inline function
Message-ID: <20081204153524.GA18293@elte.hu>
References: <20081204052638.425740534@goodmis.org> <20081204081008.GC32594@elte.hu> <20081204083059.GA8131@elte.hu> <20081204083419.GA8918@elte.hu> <alpine.DEB.1.10.0812040815350.5240@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812040815350.5240@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 4 Dec 2008, Ingo Molnar wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > small fixlet below.
> > 
> > updated.
> > 
> > --------------->
> > >From 6b2539302bee8e88c99e3c7d80c16a04dbe5e2ad Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 4 Dec 2008 09:18:28 +0100
> > Subject: [PATCH] tracing: fix typo and missing inline function
> > 
> > Impact: fix build bugs
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/trace/trace.h |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 8b81b4d..b4b7b73 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -529,7 +529,11 @@ static inline int ftrace_graph_addr(unsigned long addr)
> >  #else
> >  static inline int ftrace_trace_addr(unsigned long addr)
> >  {
> > -	return 1
> > +	return 1;
> > +}
> > +static inline int ftrace_graph_addr(unsigned long addr)
> > +{
> > +	return 1;
> >  }
> >  #endif /* CONFIG_DYNAMIC_FTRACE */
> 
> Thanks! I guess I need to test the "off" cases ;-)

As long as we are free of runtime bugs, we'll be just fine ;-)

	Ingo
