Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZJPIsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZJPIsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZJPIsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:48:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbZJPIse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:48:34 -0400
Date: Fri, 16 Oct 2009 10:47:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091016084745.GB11174@elte.hu>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org> <20091011085345.GE14995@elte.hu> <20091011122129.GA16701@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011122129.GA16701@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Oct 11, 2009 at 10:53:45AM +0200, Ingo Molnar wrote:
> > And you were full of it back then and you are full of it now as well.
> 
> Beeing nice today, eh? :)

Yeah, being reciprocal to you ;-)

> > Of course tools/perf/ can be dependent on the kernel source, as long 
> > as it's all exposed cleanly. Runtime exposure of information is 
> > better of course in many cases, but there's a balance to be 
> > stricken.
> > 
> > We already have deep and good dependencies between kernel code and 
> > tools/perf: for example we use the kernel's list.h and lib/rbtree.c 
> > in perf and those facilities are God-sent over user-space crap that 
> > for example Glist is.
> 
> Re-using code is no problem at all.  If you look at typical lowlevel 
> userspace code written by kernel developers you'll notice that they 
> usually use the kernel data structures, too.  And yeah, glib is quite 
> horrible.
> 
> The problem is run-time depdency on the kernel it was built with.  
> It's not practival or desirable to have one perf binary per kernel 
> version.

But we release a new version of perf per kernel release. So we have a 
perf binary per kernel release _already_.

Yes, it's good to avoid coupling but it's not nearly as much of a 
problem as you make it out to be. You seem to argue in favor of some 
sort of inflexible, rigid cage for instrumentation apps and that's 
simply the wrong mindset. That kind of rigidity and isolation kept Linux 
instrumentation poor for a decade to begin with.

> > I tend to agree that softirq names might make sense to expose 
> > runtime as well, but that is totally independent of your _idiotic_ 
> > argument that this issue somehow talks against perf being part of 
> > the kernel source.
> 
> It is directly related.  If you ship perf as part of the kernel source 
> these kinds of thing slip in easily, just because people don't think 
> about it enough.  If you have a separate source tree it's much more 
> clear that you can't depend on internal implementation details.

Exactly where is the problem? You say things like 'bad' and 'mess', 
without actually articulating a single practical disadvantage.

Sure if you go back to an old kernel with new instrumentation binary you 
might get the wrong softirq names. It doesnt really matter in practice: 
'perf' can be built in any past kernel and can be used there.

Fact is, using information from the kernel source has its clear 
advantages. There's lots of details we dont want to guarantee in the ABI 
sense yet. Amongst them are the softirq names. They get changed all the 
time and softirqs might even go away entirely. It's good for tools to 
have _some_ notion about them - but to guarantee it until eternity? No 
way is that an unconditionally good thing.

	Ingo
