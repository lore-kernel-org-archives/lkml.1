Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZDMX2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZDMX2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZDMX2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:28:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZDMX2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:28:21 -0400
Date: Tue, 14 Apr 2009 01:28:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to
	include/linux/boottrace.h
Message-ID: <20090413232807.GE817@elte.hu>
References: <49E2B763.8060706@cn.fujitsu.com> <20090413142531.GC5977@nowhere> <20090413222436.GF8514@elte.hu> <alpine.DEB.2.00.0904131907020.3041@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904131907020.3041@gandalf.stny.rr.com>
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
> On Tue, 14 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Mon, Apr 13, 2009 at 11:54:11AM +0800, Zhaolei wrote:
> > > > Impact: refactor code, no functionality changed
> > > > 
> > > > Files in include/trace/ should be definition of tracepoints, and header
> > > > file for boot trace should put to include/linux/.
> > > > 
> > > > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > > ---
> > > 
> > > Until now I had the opinion that it's good to let every tracing 
> > > headers to be placed in include/trace/* because they are not 
> > > useful for anything else than the tracer itself so that we don't 
> > > encumber include/linux for private things.
> > > 
> > > So that we have both tracepoints/trace_events plus the low-level 
> > > tracers headers in include/trace/*
> > > 
> > > I'm not opposite to this change, but seeing this patch and the 
> > > recent divide of kmemtrace headers, I would like to know the 
> > > opinion of Ingo and Steven about the strict role of 
> > > include/trace/* Is it only for tracepoints-like bits, or oslo 
> > > intended for every private tracing purposes?
> > 
> > The header split itself is probably good to do - to keep the 'pure' 
> > portions of tracepoint definitions cleanly separated from more 
> > functional details like kmem tracer initialization.
> > 
> > The move to include/linux/ is indeed more debatable. I think if a 
> > header says 'footrace.h' in its name, it could easily be in 
> > include/trace/foo.h instead? Makes for a tidier structure - 
> > include/linux/ is massively over-crowded already.
> > 
> > Steve, what do you think?
> 
> We actually discussed this a little at the Linux Collaboration 
> Summit. The idea was to keep only the tracepoints aka TRACE_EVENT 
> code in include/trace/ and perhaps special headers that work with 
> the TRACE_EVENT macros. But the infrastructure of the tracers 
> would stay in include/linux.
> 
> The rational is that we have a separate directory reserved only 
> for trace points / trace events. Adding more headers into that 
> directory would make it a bit harder to see right away what trace 
> events where defined for a particular kernel source.

Hm, i have to say that is true committee design ;-)

The sane thing would be to put event headers into 
include/trace/events/ and put more generic/utility headers into 
include/trace/.

Reserving a full subdirectory for one singular purpose is a needless 
waste of a nice (and unique) name-space resource.

	Ingo
