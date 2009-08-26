Return-Path: <linux-kernel-owner+w=401wt.eu-S1750879AbZHZHsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbZHZHsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZHZHsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:48:02 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:56726 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZHZHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:48:01 -0400
Date: Wed, 26 Aug 2009 09:47:36 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826074735.GB4749@osiris.boeblingen.de.ibm.com>
References: <cover.1249932670.git.jbaron@redhat.com>
 <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com>
 <20090825125027.GE4639@cetus.boeblingen.de.ibm.com>
 <20090825214020.GF8215@nowhere>
 <20090825220900.GA9953@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825220900.GA9953@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:09:01AM +0200, Frederic Weisbecker wrote:
> On Tue, Aug 25, 2009 at 11:40:21PM +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > > Most arch syscall_get_nr() implementations returns -1 if the syscall
> > > number is not valid.  Accessing the bit field without a check might
> > > result in a kernel oops (at least I saw it on s390 for ftrace selftest).
> > > 
> > > Before this change, this problem did not occur, because the invalid
> > > syscall number (-1) caused syscall_nr_to_meta() to return NULL.
> > > 
> > > There are at least two scenarios where syscall_get_nr() can return -1:
> > > 
> > > 1. For example, ptrace stores an invalid syscall number, and thus,
> > >    tracing code resets it.
> > >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > > 
> > > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> > >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> > >    kernel threads.
> > >    However, the ftrace selftest triggers a kernel oops when testing syscall
> > >    trace points:
> > >       - The kernel thread is started as ususal (do_fork()),
> > >       - tracing code sets TIF_SYSCALL_FTRACE,
> > >       - the ret_from_fork() function is triggered and starts
> > > 	ftrace_syscall_exit() with an invalid syscall number.
> > > 
> > > To avoid these scenarios, I suggest to check the syscall_nr.
> > > 
> > > [...]
> > > 
> > > Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> > 
> > 
> > 
> > I'm queueing this one for .32
> > 
> > Thanks.
> 
> Btw it would be nice to have an ack from s390 maintainers.
> Martin, Heiko, no problem with this patch?

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
