Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZCKTsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZCKTsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZCKTsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:48:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZCKTsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:48:38 -0400
Date: Wed, 11 Mar 2009 20:47:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
Message-ID: <20090311194739.GB10393@elte.hu>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com> <1236754764.22914.3680.camel@twins> <20090311182656.GA23739@elte.hu> <alpine.DEB.2.00.0903111431080.3062@gandalf.stny.rr.com> <1236800711.8192.707.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236800711.8192.707.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-03-11 at 14:32 -0400, Steven Rostedt wrote:
> > On Wed, 11 Mar 2009, Ingo Molnar wrote:
> > 
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Tue, 2009-03-10 at 21:26 -0400, Steven Rostedt wrote:
> > > > 
> > > > > commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
> > > > > Author: Steven Rostedt <srostedt@redhat.com>
> > > > > Date:   Tue Mar 10 17:16:35 2009 -0400
> > > > > 
> > > > >     tracing: use raw spinlocks for trace_vprintk
> > > > >     
> > > > >     Impact: prevent locking up by lockdep tracer
> > > > >     
> > > > >     The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
> > > > >     call back into lockdep without locking up.
> > > > 
> > > > Hmm, I did this when I posted the lockdep tracepoints, so someone then
> > > > did a bad copy/paste job when renaming ftrace_printk or something?
> > > > 
> > > > See efed792d6738964f399a508ef9e831cd60fa4657
> > > 
> > > What's the conclusion in this thread? I'm holding the pull 
> > > until there's agreement.
> > 
> > I believe the conclusion is that Peter's changes got removed when Frederic 
> > removed the old printk version. But his new version did not have the 
> > changes.
> > 
> > My changes are basically the same as Peter's except that I did not do 
> > anything with the local_irq_save, since I do not think those are needed.
> > 
> > Peter,
> > 
> > Are you fine with the change? I guess it's up to you now.
> 
> Yeah, although I'd rather see the raw_local_irq_save() there too, but
> the patch as it stands solves the problem.

Pulled - thanks guys!

	Ingo
