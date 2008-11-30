Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYK3QZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYK3QZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 11:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYK3QZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 11:25:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYK3QZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 11:25:00 -0500
Date: Sun, 30 Nov 2008 17:24:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/branch-tracer: include missing irqflags.h
Message-ID: <20081130162448.GA25745@elte.hu>
References: <4930B32E.6060403@gmail.com> <20081129091647.GA25109@elte.hu> <20081130125001.GA4239@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130125001.GA4239@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Nov 29, 2008 at 10:16:47AM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Impact: fix build error on branch tracer
> > > 
> > > This should fix a build error reported on alpha in linux-next:
> > > 
> > >  CC      kernel/trace/trace_branch.o
> > > kernel/trace/trace_branch.c: In function 'probe_likely_condition':
> > > kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
> > > kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'
> > 
> > applied to tip/tracing
> > 
> > > Unfortunately, I can't test it since I don't have any Alpha build 
> > > environment.
> > 
> > it does not trigger with an Alpha defconfig - we do test that.
> > 
> > And the thing is, lockdep (which introduced irqflags tracing) has 
> > been introduced upstream two years ago - and Alpha still does not 
> > have it implemented. The architecture should be marked CONFIG_BROKEN 
> > if it continues to cause problems like this.
> 
> Or people can, horror, cross-compile stuff in relevant configurations.

Alpha does not have ftrace enabled in its defconfig, so unless you define 
"relevant configurations" as "dozens and dozens of stupid configs nobody 
uses and that do not matter to 99.9% of the users" i dont see the point.

And the thing is, even if someone wanted to waste serious amount of time 
on crossbuilding to all architectures, a consistent set of crosscompilers 
is not readily available. They are not packaged up properly for distros 
and it's not clear which architecture wants what crosscompiler version 
and binutils setup.

Nor is it clear why kernel developers should slow down their testing 
critical path twenty fold (or more), while it's at most 3 architectures 
that really matter.

> > Alexey, you seem to be using and relying on the Alpha architecture,
> 
> No, just alpha is first on the list ('a'), so nastygrams get sent 
> first.

Basically via your "nastygrams" you are artificially inflating the 
importance of certain bugreports, well beyond their true importance. You 
are indirectly re-weighting and wasting developer resources that way.

It would be far more important and far more relevant to go over the lists 
on kerneloops.org, or over the bugs in bugzilla.kernel.org than to 
complain that some tree broke Alpha 'again'. Alpha is a stale 
architecture and it shows.

	Ingo
