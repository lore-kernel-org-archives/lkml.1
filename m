Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbZHXOHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbZHXOHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZHXOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZHXOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:07:51 -0400
Date: Mon, 24 Aug 2009 10:06:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090824140629.GA2656@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere> <20090824134151.GB18974@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824134151.GB18974@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:41:52PM +0900, Paul Mundt wrote:
> > On Mon, Aug 10, 2009 at 04:52:35PM -0400, Jason Baron wrote:
> > > update FTRACE_SYSCALL_MAX to the current number of syscalls
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  arch/x86/include/asm/ftrace.h |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > > index bd2c651..7113654 100644
> > > --- a/arch/x86/include/asm/ftrace.h
> > > +++ b/arch/x86/include/asm/ftrace.h
> > > @@ -30,9 +30,9 @@
> > >  
> > >  /* FIXME: I don't want to stay hardcoded */
> > >  #ifdef CONFIG_X86_64
> > > -# define FTRACE_SYSCALL_MAX     296
> > > +# define FTRACE_SYSCALL_MAX     299
> > >  #else
> > > -# define FTRACE_SYSCALL_MAX     333
> > > +# define FTRACE_SYSCALL_MAX     337
> > >  #endif
> > 
> > 
> > I don't remember why we had to use a hardcoded number.
> > Is there no way to keep being sync with the current number of
> > syscalls? We dwant to avoid patching the kernel each time we
> > have a new syscall :-)
> > 
> I hope you can clarify what the meaning of this is supposed to be
> exactly. Is this number supposed to be the last usable syscall, or is it
> supposed to be the equivalent of NR_syscalls?
> 

I am using as the equivalent of NR_syscalls.

> Presently on SH we have this as NR_syscalls - 1, while on s390 I see it
> is treated as NR_syscalls directly. s390 opencodes the NR_syscalls
> directly and so presently blows up in -next due to a missing
> FTRACE_SYSCALL_MAX definition:
> 
> 	http://kisskb.ellerman.id.au/kisskb/buildresult/1120523/
> 
> I was in the process of fixing that up when I noticed this difference.
> x86 seems to also treat this as NR_syscalls - 1, but that looks to me
> like there is an off-by-1 in arch_init_ftrace_syscalls() causing the last
> syscall to be skipped?

I don't see how its used as 'NR_syscalls - 1' on x86,
arch_init_ftrace_syscalls() does:

        for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
                meta = find_syscall_meta(psys_syscall_table[i]);
                syscalls_metadata[i] = meta;
        }

So the last syscall should not be skipped.

We should probably convert *all* the arches to be using NR_syscalls
directly.

thanks,

-Jason



