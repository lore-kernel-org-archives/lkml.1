Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZHRLGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZHRLGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbZHRLGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:06:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60453 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZHRLGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:06:49 -0400
Date: Tue, 18 Aug 2009 13:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
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
Message-ID: <20090818110616.GA20070@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090818004654.GA4402@linux-sh.org> <20090818102507.GA5231@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818102507.GA5231@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Aug 18, 2009 at 09:46:55AM +0900, Paul Mundt wrote:
> > [ Adding to Cc everyone that now has a broken tree thanks to this .. ]
> > 
> > On Wed, Aug 12, 2009 at 11:11:33AM +0200, Ingo Molnar wrote:
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > This pull request integrate one cleanup/fix for ftrace and an 
> > > > update for syscall tracing: the migration from old-style tracer to 
> > > > individual tracepoints/trace_events and the support for perf 
> > > > counter.
> > > > 
> > > > I've tested it with success either with ftrace (every syscall 
> > > > tracepoints enabled at the same time without problems) and with 
> > > > perfcounter.
> > > > 
> > > > May be one drawback: it creates so much trace events that the 
> > > > ftrace selftests can take some time :-)
> > > 
> > > Pulled, thanks a lot!
> > 
> > And this has now subsequently broken every single SH and S390 
> > configuration, and anyone else unfortunate enough to be 
> > supporting ftrace syscall tracing that isn't x86, without so 
> > much as a Cc, well done!
> > 
> > The s390 case can be fixed up in-tree as support has already 
> > been merged, but in the SH case we had ftrace syscall tracing 
> > queued up for 2.6.32, so it doesn't show up in -tip, but the 
> > end result in -next is now completely broken.
> > 
> > I'm not sure how we should handle this, if tracing/core in -tip 
> > isn't rebased, should I just pull the topic-branch in to my 
> > tree, fix up the sh support on top of that, and push the end 
> > result out? This seems like the easiest option at least, but I 
> > don't know what other dependencies exist for tracing/core. 
> > Alternative suggestions welcome.
> > 
> > This happens again and again with ftrace and -tip, where people 
> > just randomly change existing interfaces, break all of the 
> > existing users, and then fail to tell anyone about it until it 
> > shows up in -next. Even if we had pushed all of the sh ftrace 
> > bits to the -tip tree early on it would not have changed 
> > anything, evident by the fact that s390 and all of the non 
> > ftrace syscall architectures were broken by this change as well 
> > (the latter case was at least caught and corrected, although 
> > not by the original authors of this patch series). Is it really 
> > that much to task that people who are running around breaking 
> > ftrace interfaces actually bother to Cc the architectures that 
> > are using it?
> 
> I've just retrieved the concerned commit in the sh tree:
> 
> sh: Add ftrace syscall tracing support 
> (c652d780c9cf7f860141de232b37160fe013feca)
> 
> Was I cc'ed on this one? I can't find it in my inbox. Unless I'm 
> wrong and I missed it, how could I guess I had to cc you and how 
> am I supposed to fix something I'm even not aware of?
> 
> I can't find the s390 patch in my inbox either (was I cc'ed ?) 
> ([S390] ftrace: add system call tracer support) but we should 
> have fixed this one because it was already upstream and a 
> git-grep ftrace_syscall_enter would have warned us about that.
> 
> I didn't know another arch was supporting syscall tracing (except 
> mips because I was cc'ed, but it doesn't seem upstream nor in the 
> mips tree).

Yes, and note that Paul Mundt has not even done the minimal 
courtesy of describing/pasting the build failure he was seeing. But 
he had time for a 4-paragraph rant about how others are supposed to 
do their work... And then he complains about us not having 
considered a change he never Cc:-ed to us. How nice.

( I have meanwhile fixed the bug in s390 and have posted that fix -
  the SH fix should be an analogous twoliner. )

This reply from Paul Mundt shows an _incredibly_ arrogant attitude 
towards core kernel facilities: he almost never contributes to them 
(i just checked the logs from v2.6.12 to v2.6.31-rc6) but _THEY_ 
must do everything to keep SH running smoothly.

And he expects that work to benefit SH to happen regardless of how 
many actual Linux users use, develop on and report bugs from SH. 
Where's the many SH crash reports on kerneloops.org? I see _not a 
single SH report_, out of more than 200,000 kernel oopses reported 
and categorized ... Why?

The thing is, as things stand today SH is basically freeloding on 
the hard work, testing and core kernel work of other architectures 
- which is fine in itself - what is not fine is to is to then 
complain in an unacceptable tone about bugs that affect SH.

Of course SH never causes core kernel bugs because it essentially 
does no core kernel work at all!

Paul seems to think that freeloading upon 10 million lines of code 
coupled with loud, self-sure demands for instant fixes is fine, and 
dare anyone trying to advance Linux break the build of a single 
architecture out of 22!

Other architectures, powerpc, s390, sparc, x86 etc. all do lots of 
core kernel work and make sure it's all nicely reciprocal and 
friendly. SH needs to stop the whining and needs to start helping 
out for real - or it can get unmerged and go out of tree if it does 
not want to participate in the development process.

Thanks,

	Ingo
