Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZISH2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZISH2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZISH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:28:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbZISH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:28:32 -0400
Date: Sat, 19 Sep 2009 09:28:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/2] tracing: Document HAVE_FTRACE_SYSCALLS needs
Message-ID: <20090919072827.GD15292@elte.hu>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253338757-5918-3-git-send-email-fweisbec@gmail.com> <20090919071712.GB15292@elte.hu> <20090919072249.GA5226@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919072249.GA5226@nowhere>
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

> On Sat, Sep 19, 2009 at 09:17:12AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Document the arch needed requirements to get the support for syscalls
> > > tracing.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > > Cc: Jason Baron <jbaron@redhat.com>
> > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > Cc: Paul Mundt <lethal@linux-sh.org>
> > > ---
> > >  Documentation/trace/ftrace-design.txt |   11 ++++++++++-
> > >  1 files changed, 10 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
> > > index 7003e10..04ab61c 100644
> > > --- a/Documentation/trace/ftrace-design.txt
> > > +++ b/Documentation/trace/ftrace-design.txt
> > > @@ -216,7 +216,16 @@ If you can't trace NMI functions, then skip this option.
> > >  HAVE_FTRACE_SYSCALLS
> > >  ---------------------
> > >  
> > > -<details to be filled>
> > > +You need very few things to get the syscalls tracing in an arch.
> > > +
> > > +- Have a NR_syscalls variable in <asm/unistd.h> that provides the number
> > > +  of syscalls supported by the arch.
> > > +- Implement arch_syscall_addr() that resolves a syscall address from a
> > > +  syscall number.
> > > +- Support the TIF_SYSCALL_TRACEPOINT thread flags
> > > +- Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
> > > +  in the ptrace syscalls tracing path.
> > > +- Tag this arch as HAVE_FTRACE_SYSCALLS.
> > 
> > HAVE_FTRACE_SYSCALLS is not actually used anywhere.
> > 
> > 	Ingo
> 
> Ah, that has been renamed HAVE_SYSCALL_TRACEPOINTS recently. What do 
> you prefer? A delta patch or a rebase?

We need the acks from Martin/Heiko so lets wait for that and do a new 
tree then?

	Ingo
