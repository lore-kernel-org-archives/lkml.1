Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZHRKZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZHRKZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758623AbZHRKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:25:15 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52827 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZHRKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QLOfgcuuuYpPgqTLMoxIH73lkeXK5gH7Ay9a2OK72Qk7AYIbx8uaaLDNQFifxQzPhV
         iir4jiWNUDNOiuGYtXI2tDM3NTpfq1/W8baaaT74br/Tq2B/xTn5vA4wqnaV3M13luXy
         k0rEhcvC3kz1ZWh7aSHnPe5yLNanRKXDwvrus=
Date: Tue, 18 Aug 2009 12:25:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20090818102507.GA5231@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090818004654.GA4402@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818004654.GA4402@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 09:46:55AM +0900, Paul Mundt wrote:
> [ Adding to Cc everyone that now has a broken tree thanks to this .. ]
> 
> On Wed, Aug 12, 2009 at 11:11:33AM +0200, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > This pull request integrate one cleanup/fix for ftrace and an 
> > > update for syscall tracing: the migration from old-style tracer to 
> > > individual tracepoints/trace_events and the support for perf 
> > > counter.
> > > 
> > > I've tested it with success either with ftrace (every syscall 
> > > tracepoints enabled at the same time without problems) and with 
> > > perfcounter.
> > > 
> > > May be one drawback: it creates so much trace events that the 
> > > ftrace selftests can take some time :-)
> > 
> > Pulled, thanks a lot!
> > 
> And this has now subsequently broken every single SH and S390
> configuration, and anyone else unfortunate enough to be supporting ftrace
> syscall tracing that isn't x86, without so much as a Cc, well done!
> 
> The s390 case can be fixed up in-tree as support has already been merged,
> but in the SH case we had ftrace syscall tracing queued up for 2.6.32, so
> it doesn't show up in -tip, but the end result in -next is now completely
> broken.
> 
> I'm not sure how we should handle this, if tracing/core in -tip isn't
> rebased, should I just pull the topic-branch in to my tree, fix up the sh
> support on top of that, and push the end result out? This seems like the
> easiest option at least, but I don't know what other dependencies exist
> for tracing/core. Alternative suggestions welcome.
> 
> This happens again and again with ftrace and -tip, where people just
> randomly change existing interfaces, break all of the existing users, and
> then fail to tell anyone about it until it shows up in -next. Even if we
> had pushed all of the sh ftrace bits to the -tip tree early on it would
> not have changed anything, evident by the fact that s390 and all of the
> non ftrace syscall architectures were broken by this change as well (the
> latter case was at least caught and corrected, although not by the
> original authors of this patch series). Is it really that much to task
> that people who are running around breaking ftrace interfaces actually
> bother to Cc the architectures that are using it?



I've just retrieved the concerned commit in the sh tree:

sh: Add ftrace syscall tracing support (c652d780c9cf7f860141de232b37160fe013feca)

Was I cc'ed on this one? I can't find it in my inbox. Unless I'm wrong
and I missed it, how could I guess I had to cc you and how am I supposed
to fix something I'm even not aware of?


I can't find the s390 patch in my inbox either (was I cc'ed ?)
([S390] ftrace: add system call tracer support) but we should have fixed
this one because it was already upstream and a git-grep ftrace_syscall_enter
would have warned us about that.

I didn't know another arch was supporting syscall tracing (except mips because
I was cc'ed, but it doesn't seem upstream nor in the mips tree).


> 
> If -tip is going to perpetuate this sort of half-assed development
> methodology, it has no place in -next.

