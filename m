Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZJFNyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZJFNyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbZJFNx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:53:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbZJFNx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:53:56 -0400
Date: Tue, 6 Oct 2009 15:53:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       hch@infradead.org
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
	scripting
Message-ID: <20091006135311.GB18365@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <20091006090954.GA19325@elte.hu> <1254835554.21044.278.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254835554.21044.278.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-10-06 at 11:09 +0200, Ingo Molnar wrote:
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > Known problems/shortcomings:
> > > 
> > > Probably the biggest problem right now is the sorting hack I added as 
> > > the last patch.  It's just meant as a temporary thing, but is there 
> > > because tracing scripts in general want to see events in the order 
> > > they happened i.e. timestamp order. [...]
> > 
> > Btw., have you seen the -M/--multiplex option to perf record? It 
> > multiplexes all events into a single buffer - making them all ordered. 
> > (The events are in causal ordering in this case even if there's some TSC 
> > asynchronity)
> 
> It also wrecks large machines.. [...]

With millions of events per sec, for sure. It doesnt with a few thousand 
per sec. Right now that's the price of guarantee causality. If you _can_ 
trust your system-wide TSC then it's not needed - but that's only 
possible on a very small subset of machines currently.

> [...] I've been thinking about limiting the number of CPUs you can 
> redirect into a single output stream using the output_fd thing, but 
> then the inherited stuff makes that very hard.
> 
> And we also need a solution for the inhertited counters, the best 
> would be the per-cpu inherited things, where we use both cpu and pid, 
> instead of either.
> 
> In short, -M is nice, but it also has significant down sides, esp. 
> with machines getting more and more cores.

Yeah.

	Ingo
