Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZD1JjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZD1JjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZD1JjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:39:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZD1JjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:39:14 -0400
Date: Tue, 28 Apr 2009 11:38:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428093833.GE21085@elte.hu>
References: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com> <20090428092918.GC21085@elte.hu> <20090428183237.EBDE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428183237.EBDE.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > I have no idea how expensive tracepoints are but I suspect they 
> > > don't make too much sense for this particular scenario. After all, 
> > > kmemtrace is mainly interested in _allocation patterns_ whereas 
> > > this patch seems to be more interested in "memory layout" type of 
> > > things.
> > 
> > My point is that the allocation patterns can be derived from dynamic 
> > events. We can build a map of everything if we know all the events 
> > that led up to it. Doing:
> > 
> >   echo 3 > /proc/sys/vm/drop_caches
> > 
> > will clear 99% of the memory allocations, so we can build a new map 
> > from scratch just about anytime. (and if boot allocations are 
> > interesting they can be traced too)
> > 
> > _And_ via this angle we'll also have access to the dynamic events, 
> > in a different 'view' of the same tracepoints - which is obviously 
> > very useful for different purposes.
> 
> I am one of most strongly want guys to MM tracepoint. but No, many 
> cunstomer never permit to use drop_caches.

See my other mail i just sent: it would be a natural extension of 
tracing to also dump all current object state when tracing is turned 
on. That way no drop_caches is needed at all.

But it has to be expressed in one framework that cares about the 
totality of the kernel - not just these splintered bits of 
instrumentation and pieces of statistics.

	Ingo
