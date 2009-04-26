Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZDZKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZDZKs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZDZKsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:48:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39304 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZDZKsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:48:18 -0400
Date: Sun, 26 Apr 2009 12:47:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090426104747.GA5983@elte.hu>
References: <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424182821.8263f445.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 25 Apr 2009 02:37:03 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > I discovered it with this tracer. Then it brought me to
> > write this patch:
> > 
> > http://lkml.org/lkml/2009/1/31/184
> > 
> > ...
> > 
> > Still with these same observations, I wrote this another one:
> > 
> > http://lkml.org/lkml/2009/1/26/363
> 
> OK, it's great that you're working to improve the workqueue code.  
> But does this justify permanently adding debug code to the core 
> workqueue code? [...]

Andrew - but this is not what you asked originally. Here's the 
exchange, not cropped:

> > > So this latest patchset provides all these required 
> > > informations on the events tracing level.
> >  Well.. required by who?
> >
> > I don't recall ever seeing any problems of this nature, nor 
> > patches to solve any such problems.

And Frederic replied that there's three recent examples of various 
patches and problem reports resulting out of the workqueue 
tracepoints.

Now you argue 'yes, there might have been an advantage but it's not 
permanent' - which appears to be a somewhat shifting position 
really. I dont think _our_ position has shifted in any way - please 
correct me if i'm wrong ;-)

And i'm, as the original author of the kernel/workqueue.c code 
(heck, i even coined the 'workqueue' term - if that matters) agree 
with Frederic here: more transparency in seeing what goes on in a 
subsystem brings certain advantages:

 - it spurs development
 - it helps the fixing of bugs
 - and generally it helps people understand the kernel better

weighed against the cost of maintaining (and seeing) those 
tracepoints.

In the scheduler we have more than 60 distinct points of 
instrumentation.

The patches we are discussing here add 6 new tracepoints to 
kernel/workqueue.c - and i'd argue they are pretty much the maximum 
we'd ever want to have there.

I've been maintaining the scheduler instrumentation for years, and 
its overhead is, in hindsight, rather low - and the advantage is 
significant. As long as tracing and statistics instrumentation has a 
very standard and low-key "function call" visual form, i dont even 
notice them most of the time.

And the thing is, the workqueue code has been pretty problematic 
lately - with lockups and other regressions. It's a pretty 'opaque' 
facility that _hides_ what goes on in it - so more transparency 
might be a good answer just on that basis alone.

> [...]  In fact, because you've discovered these problem, the 
> reasons for adding the debug code have lessened!
> 
> What we need are curious developers looking into how well 
> subsystems are performing and how well callers are using them.  
> Adding fairly large amounts of permanent debug code into the core 
> subsystems is a peculiar way of encouraging such activity.

but this - which you call peculiar - is exactly what happened when 
the first set of tracepoints were added.

Secondly, if we discount the (fairly standard) off-site tracepoints, 
is not "large amount of debug code" - the tracepoints are completely 
off site and are not a worry as long as the tracepoint arguments are 
kept intact. The bits in kernel/workqueue.c are on the 26 lines flux 
range:

 workqueue.c             |   26 ++++++++++++++++++++------

	Ingo
