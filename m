Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbZHXNlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbZHXNlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZHXNlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:41:51 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39787 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZHXNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:41:51 -0400
Date: Mon, 24 Aug 2009 22:41:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090824134151.GB18974@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
	jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811110023.GC4938@nowhere>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 01:00:25PM +0200, Frederic Weisbecker wrote:
> On Mon, Aug 10, 2009 at 04:52:35PM -0400, Jason Baron wrote:
> > update FTRACE_SYSCALL_MAX to the current number of syscalls
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  arch/x86/include/asm/ftrace.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index bd2c651..7113654 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -30,9 +30,9 @@
> >  
> >  /* FIXME: I don't want to stay hardcoded */
> >  #ifdef CONFIG_X86_64
> > -# define FTRACE_SYSCALL_MAX     296
> > +# define FTRACE_SYSCALL_MAX     299
> >  #else
> > -# define FTRACE_SYSCALL_MAX     333
> > +# define FTRACE_SYSCALL_MAX     337
> >  #endif
> 
> 
> I don't remember why we had to use a hardcoded number.
> Is there no way to keep being sync with the current number of
> syscalls? We dwant to avoid patching the kernel each time we
> have a new syscall :-)
> 
I hope you can clarify what the meaning of this is supposed to be
exactly. Is this number supposed to be the last usable syscall, or is it
supposed to be the equivalent of NR_syscalls?

Presently on SH we have this as NR_syscalls - 1, while on s390 I see it
is treated as NR_syscalls directly. s390 opencodes the NR_syscalls
directly and so presently blows up in -next due to a missing
FTRACE_SYSCALL_MAX definition:

	http://kisskb.ellerman.id.au/kisskb/buildresult/1120523/

I was in the process of fixing that up when I noticed this difference.
x86 seems to also treat this as NR_syscalls - 1, but that looks to me
like there is an off-by-1 in arch_init_ftrace_syscalls() causing the last
syscall to be skipped?
