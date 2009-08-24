Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZHXOhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZHXOhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZHXOhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:37:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34352 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZHXOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:37:45 -0400
Date: Mon, 24 Aug 2009 23:37:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090824143745.GA20338@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
	jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com> <20090811110023.GC4938@nowhere> <20090824134151.GB18974@linux-sh.org> <20090824140629.GA2656@redhat.com> <20090824141539.GA19978@linux-sh.org> <20090824143417.GB6130@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824143417.GB6130@nowhere>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:34:20PM +0200, Frederic Weisbecker wrote:
> On Mon, Aug 24, 2009 at 11:15:39PM +0900, Paul Mundt wrote:
> > On Mon, Aug 24, 2009 at 10:06:29AM -0400, Jason Baron wrote:
> > > I don't see how its used as 'NR_syscalls - 1' on x86,
> > > arch_init_ftrace_syscalls() does:
> > > 
> > >         for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
> > >                 meta = find_syscall_meta(psys_syscall_table[i]);
> > >                 syscalls_metadata[i] = meta;
> > >         }
> > > 
> > > So the last syscall should not be skipped.
> > > 
> > 
> > In today's -next:
> > 
> > #ifdef CONFIG_X86_64
> > # define FTRACE_SYSCALL_MAX     299
> > #else
> > # define FTRACE_SYSCALL_MAX     337
> > #endif
> > 
> > unistd_32.h:
> > 
> > #define __NR_reflinkat          337
> > 
> > unistd_64.h:
> > 
> > #define __NR_reflinkat          299
> > 
> > The first syscall starts at 0, but I don't see how this last syscall is
> > handled. If there were a __NR_syscalls 300 and 338 respectively, that
> > would seem to do the right thing. Or am I missing something?
> 
> 
> Yeah, I guess what we need here is NR_syscalls + 1.
> 
No, just NR_syscalls. NR_syscalls has always been last valid + 1. At
least this is how all architectures are using it, it just seems to have
gone missing from x86.

So having said that, it looks like s390 got it right, while x86 has an
off-by-1, and sh foolishly followed x86 ;-)
