Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbZKZSMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbZKZSMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZKZSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:12:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZKZSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:12:08 -0500
Date: Thu, 26 Nov 2009 19:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
Message-ID: <20091126181205.GA18670@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
 <1259224390.21397.87.camel@gandalf.stny.rr.com>
 <20091126084039.GA15919@elte.hu>
 <1259246730.21397.97.camel@gandalf.stny.rr.com>
 <20091126175548.GC4997@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126175548.GC4997@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Nov 26, 2009 at 09:45:30AM -0500, Steven Rostedt wrote:
> > On Thu, 2009-11-26 at 09:40 +0100, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > 
> > > > I would like to hear what others think about this change before we go 
> > > > ahead and implement it.
> > > 
> > > You mean TRACE_EVENT() -> DEFINE_SINGLE_EVENT()? Sure, we want todo it 
> > > in a more quiet moment of the kernel cycle, not now.
> > > 
> > > (TRACE_EVENT_TEMPLATE OTOH has existed for just a few days so it's not a 
> > > problem.)
> > 
> > Yes the template name is new, I'm not talking about that on
> > particularly.
> 
> I personally don't mind much about the name, especially between class 
> and template. Both make equally sense to me.
> 
> But DECLARE sounds like a misnomer here (like DEFINE_EVENT somehow) as 
> TRACE_EVENT, DEFINE_EVENT and TRACE_EVENT_TEMPLATE all behave either 
> as a declaration or a definition, depending on the CREATE_TRACE_POINT 
> macro.

DECLARE_EVENT_CLASS() doesnt really define an event visible to the user 
yet though. It defines functions internally (to be used by the real 
definition of the event) - but not visible externally really.

So the real 'definition' of an event happens with DEFINE_EVENT() - in 
the logical model of this.

So the logical model is clear:

   DECLARE_EVENT_CLASS(class);

    DEFINE_EVENT(class, event1);
    DEFINE_EVENT(class, event2);
    DEFINE_EVENT(class, event3);
    ...

  # later:
  # DEFINE_STANDALONE_EVENT(event)

And the logical model is what matters: that's what developers will use. 
They'll use these constructs based on the logical model, nobody sane 
will look into the CPP magic ;-)

And yes, we occasionally have to revisit our naming choices - especially 
when mistakes/misnomers become apparent.

Thanks,

	Ingo
