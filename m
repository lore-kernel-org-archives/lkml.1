Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZHRI7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZHRI7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZHRI7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:59:31 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61723 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZHRI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:59:30 -0400
Date: Tue, 18 Aug 2009 10:59:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Wu Zhangjin <wuzj@lemote.com>, linux-next@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [S390] ftrace: update system call tracer support
Message-ID: <20090818105927.30f6a140@skybase>
In-Reply-To: <20090818085110.GA2074@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
	<20090812091133.GA21655@elte.hu>
	<20090818004654.GA4402@linux-sh.org>
	<20090818073211.GA26670@elte.hu>
	<20090818085110.GA2074@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 10:51:10 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > [ Adding to Cc everyone that now has a broken tree thanks to this .. ]
> > > 
> > > On Wed, Aug 12, 2009 at 11:11:33AM +0200, Ingo Molnar wrote:
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > This pull request integrate one cleanup/fix for ftrace and an 
> > > > > update for syscall tracing: the migration from old-style tracer to 
> > > > > individual tracepoints/trace_events and the support for perf 
> > > > > counter.
> > > > > 
> > > > > I've tested it with success either with ftrace (every syscall 
> > > > > tracepoints enabled at the same time without problems) and with 
> > > > > perfcounter.
> > > > > 
> > > > > May be one drawback: it creates so much trace events that the 
> > > > > ftrace selftests can take some time :-)
> > > > 
> > > > Pulled, thanks a lot!
> > > 
> > > And this has now subsequently broken every single SH and S390 
> > > configuration, [...]
> > 
> > I test SH cross-builds regularly. I just checked the SH defconfig 
> > and it builds just fine here:
> > 
> > $ make -j32 CROSS_COMPILE=sh3-linux- ARCH=sh vmlinux
> 
> The s390 build indeed broke. (This got masked by the s390 toolchain 
> i'm using not having been able to build Linus's tree - i fixed 
> that.)
> 
> Could you try the fix below? It does the trick here.
> 
> Martin, Heiko - does the fix look good to you? regs->gprs[2] seems 
> to be the register used for both the syscall number (enter 
> callback) and for the return code (exit callback).

Correct, for do_syscall_trace_{enter,exit} the code in entry.S stores
the system call number in regs->gprs[2]. The fix is fine.
Thanks Ingo.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

