Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZH0PkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZH0PkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZH0PkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:40:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:45163 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZH0PkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SByZlK3mGhwcywYz0l3wzS19Xww853gjKsN09N1I3t6SyfIiDnEgh36Jn5oqpZsyPI
         D1J/B1SGLYvHurOuaTVKzD83Bc1ho2GlVPzZ/tXE24TqcXTIXDgUKidEJXs3MhyyCErx
         RBCRGThVUJ0dabD2xS6hbxoqV/YXyVU8LiZ/M=
Date: Thu, 27 Aug 2009 17:40:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL v2] tracing/kprobes: v1 + two fixes
Message-ID: <20090827154007.GG6058@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-1-git-send-email-fweisbec@gmail.com> <20090827152438.GA32553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827152438.GA32553@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 05:24:38PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > This v2 can be either pulled after tracing/kprobes (the v1) or can 
> > be pulled alone, it is based on the previous one and addresses 
> > reviews from Li Zefan.
> > 
> > Thanks,
> > Frederic.
> > 
> > The following changes since commit 24851d2447830e6cba4c4b641cb73e713f312373:
> >   Frederic Weisbecker (1):
> >         tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> > 	tracing/kprobes-2
> > 
> > Frederic Weisbecker (2):
> >       tracing: Restore the const qualifier for field names and types definition
> >       tracing: Remove unneeded pointer casts
> > 
> >  include/linux/ftrace_event.h  |    6 +++---
> >  kernel/trace/trace_events.c   |    4 ++--
> >  kernel/trace/trace_syscalls.c |    8 ++++----
> >  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> I've pulled it into a staging branch (not yet in tip:master either 
> and not yet on the road to upstream either), thanks guys!
> 
> I have done some brief testing. One hickup is this build failure on 
> x86, caused by the kprobes instruction decoder self-test:
> 
>    CHK     include/linux/compile.h
>    TEST    posttest
>  Error: 41001024:        a1 08 30 c9 41          mov    
>  0x41c93008,%eax
>  Error: objdump says 5 bytes, but insn_get_length() says 9 (attr:40000)



I can't help for this one :)

 
> another one is this build warning:
> 
>  In file included from include/trace/events/napi.h:5,
>                   from net/core/net-traces.c:28:
>  include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
>  In file included from include/trace/define_trace.h:61,
>                   from include/trace/events/skb.h:40,
>                   from net/core/net-traces.c:27:
>  include/trace/ftrace.h:50:1: warning: this is the location of the previous definition
> 
> config attached.



Oh, that looks like the site that includes two trace events headers.
I wonder if it also happens in -tip master without kprobes.

I'll check that, thanks.

