Return-Path: <linux-kernel-owner+w=401wt.eu-S1763621AbZD3Oe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621AbZD3Oe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762849AbZD3OeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:34:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762424AbZD3OeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:34:14 -0400
Date: Thu, 30 Apr 2009 16:32:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <cl@linux.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430143215.GE14696@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <20090430135005.GA5922@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430135005.GA5922@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Christoph Lameter <cl@linux.com> wrote:
> > 
> > > On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
> > > 
> > > > to have a good look at the memory accounting code. We could 
> > > > probably benefit of Christoph Lameter's cpu ops (using segment 
> > > > registers to address per-cpu variables with atomic inc/dec) in 
> > > > there. Or at least removing interrupt disabling by using preempt 
> > > > disable and local_t variables for the per-cpu counters could 
> > > > bring some benefit.
> > > 
> > > Guess we are ready for atomic per cpu ops now that the new per cpu 
> > > allocator is in? Segment register issues with the PDA are also 
> > > solved right?
> > 
> > it's all done, implemented and upstream already. You are a bit late 
> > to the party ;-)
> > 
> > 	Ingo
> 
> Or way too early, depending on the point of view. :-)
> 
> e.g.
> http://lkml.org/lkml/2008/5/30/3
> 
> I think Christoph deserves credits for pioneering this area with fresh
> ideas.

Ok, i didnt want to go there - but let me correct this version of 
history.

Christoph's zero-based x86 percpu patches were incomplete and never 
worked reliably - Christoph unfortunately never addressed the 
bugs/crashes i reported. (and Mike Travis and me injected quite a 
bit of testing into it) There were two failed attempts to productize 
them and the patches just bitrotted for more than a year.

Tejun on the other hand fixed those problems (four of Christoph's 
patches survived more or less and were credited to Christoph) and 
did more than 50 highly delicate patches of far larger complexity to 
solve the _whole_ problem range - within a two months timeframe.

Ideas and half-done patches covering <10% of the work needed are not 
enough. Being able to implement it and productize it is the real 
deal, in my book.

Thanks goes to Christoph (and Rusty) for coming up with the idea, 
but it would be manifestly unfair to not send 90% of the kudos to 
Tejun for turning it all into reality and fixing all the other 
problems and redesigning almost all the x86 percpu code in the 
process! ;-)

	Ingo
