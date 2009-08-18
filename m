Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZHRL4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZHRL4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbZHRL4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:56:22 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36714 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZHRL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:56:21 -0400
Date: Tue, 18 Aug 2009 20:56:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Wu Zhangjin <wuzj@lemote.com>, linux-next@vger.kernel.org
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090818115620.GA16502@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jason Baron <jbaron@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Wu Zhangjin <wuzj@lemote.com>, linux-next@vger.kernel.org
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090818004654.GA4402@linux-sh.org> <20090818102507.GA5231@nowhere> <20090818110616.GA20070@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818110616.GA20070@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:06:16PM +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I've just retrieved the concerned commit in the sh tree:
> > 
> > sh: Add ftrace syscall tracing support 
> > (c652d780c9cf7f860141de232b37160fe013feca)
> > 
> > Was I cc'ed on this one? I can't find it in my inbox. Unless I'm 
> > wrong and I missed it, how could I guess I had to cc you and how 
> > am I supposed to fix something I'm even not aware of?
> > 
> > I can't find the s390 patch in my inbox either (was I cc'ed ?) 
> > ([S390] ftrace: add system call tracer support) but we should 
> > have fixed this one because it was already upstream and a 
> > git-grep ftrace_syscall_enter would have warned us about that.
> > 
> > I didn't know another arch was supporting syscall tracing (except 
> > mips because I was cc'ed, but it doesn't seem upstream nor in the 
> > mips tree).
> 
> Yes, and note that Paul Mundt has not even done the minimal 
> courtesy of describing/pasting the build failure he was seeing. But 
> he had time for a 4-paragraph rant about how others are supposed to 
> do their work... And then he complains about us not having 
> considered a change he never Cc:-ed to us. How nice.
> 
I explained that all -next builds had broken due to that tree being
pulled in, which I assumed was sufficient. None of my initial post was
suggesting that there was a problem with making changes to the interfaces
or that I expected anyone else to fix them up for me, it is more just
general frustration at how often people blindly push things out to -next
without checking what impact that is going to have on the already merged
trees. This is not just -tip specific, and indeed most of my posts to the
-next list are fixing up these sorts of build bugs caused by other
people's trees.

> This reply from Paul Mundt shows an _incredibly_ arrogant attitude 
> towards core kernel facilities: he almost never contributes to them 
> (i just checked the logs from v2.6.12 to v2.6.31-rc6) but _THEY_ 
> must do everything to keep SH running smoothly.
> 
I don't think that's a fair generalization. Naturally the vast majority
of my work is in my own architecture, and I send patches for core bits
when we run in to trouble, have to extend certain parts of
infrastructure, discover something is broken whilst wiring up support for
a few feature, etc, etc. And this actually happens quite regularly, so
I'm unsure as to where you get your statistics from.

> And he expects that work to benefit SH to happen regardless of how 
> many actual Linux users use, develop on and report bugs from SH. 
> Where's the many SH crash reports on kerneloops.org? I see _not a 
> single SH report_, out of more than 200,000 kernel oopses reported 
> and categorized ... Why?
> 
I have enough trouble getting people to submit oopses at all, and the
ones that we do get are most often in the architecture code, so there's
little interest to kerneloops.org. Likewise, issues that we hit with
common code during development we try to debug and send patches for long
before it becomes anyone elses problem.

> The thing is, as things stand today SH is basically freeloding on 
> the hard work, testing and core kernel work of other architectures 
> - which is fine in itself - what is not fine is to is to then 
> complain in an unacceptable tone about bugs that affect SH.
> 
This is complete and utter nonsense. SH is one of the only embedded
architectures that aggressively implements and tests new kernel features,
and we send out patches for any issues we run in to on a pretty much
constant basis. Beyond that, most of the patches I send to -next are
fixing up issues introduced by other people that have negative
implications for architectures, and I try to subsequently take care of
those as quickly as possible. The core kernel work we do focus on happens
within that particular subsystem itself, so perhaps there is not so much
visibility outside of that context.

Regarding the ftrace syscall stuff, you did not just break one
architecture, you effectively broke all of them that weren't x86, and
this tends to be unfortunately more of a common trend than an odd
exception. Of course that is a natural part of development, and as long
as things are gradually fixed up it's really not that big of a deal. No
one expects instant fixes all around, the issue is more that no one is
paying attention to what impact these changes will have on others. In
this case we could have Cced you on the ftrace changes we made in the
sh tree so you had been aware of it, but this largely ignores the point.
I don't Cc people when we add new features on the architecture side as
for the most part, and I expect this is the case for most architecture
maintainers. How many times are architecture people told to grovel
around some -tip topic branch before making any changes in their own
trees? If architecture people have to poke around -tip to try and keep
things moving along, I don't think its unrealistic to expect -tip people
to pay attention to the things that are already on-going in linux-next
before merging things.

My "hostility" towards core kernel features tends to be inversely
proportional to how embedded architectures are treated by core kernel
people. We effectively have to fight for every minor change, and are
either dismissed out of hand or regarded with contempt when attempting to
push core changes through. One hardly has to look very long to find your
postings that routinely throw this 95% figure around for example. Folks
complain about embedded architectures not contributing, and then when
they do, this is the end result. As an embedded architecture maintainer I
resigned myself years ago to the fact that I would spend most of my time
outside of my own architecture directory fixing up other peoples code,
and it's only the rare times when this results in opposition -- largely
involving the -tip tree as of late. I even asked you directly how we can
fix this workflow issue in my initial mail, which you completely ignored.

In any event, if all of this constitutes freeloading, then there seems to
be very little point in carrying on dialogue. I'll just pull in the
tracing/core bits in to a topic branch and fix my platform up, as usual.
