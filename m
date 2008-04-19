Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbYDSO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbYDSO5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYDSO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:57:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYDSO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:57:38 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20080419141351.GA20841@Krystal>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins>
	 <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins>
	 <20080419141351.GA20841@Krystal>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 16:56:57 +0200
Message-Id: <1208617017.6452.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-19 at 10:13 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Thu, 2008-04-17 at 18:02 -0400, Frank Ch. Eigler wrote:
> > > Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> > > 
> > > > [...]
> > > >> If we were to log just the futex_ops, just as you had suggested,
> > > >> "Just log:
> > > >>  
> > > >>   futex: <uaddr> wait
> > > >>   futex: <uaddr> wakeup"
> > > >> [...]
> > > >> If you can specifically point me to information you think would be
> > > >> absolutely unnecessary, I can get them out of the trace_mark().
> > > >
> > > > I'm thinking everything is superflous; you're basically logging what
> > > > strace already gives you
> > > 
> > > But we don't want to run strace just for this stuff.  As you probably
> > > know, strace involves invasive user-space context-switching between
> > > the target and the tracer.
> > > 
> > > > except worse by encoding local variable names and exposing kernel
> > > > pointers.
> > > 
> > > The pointers are probably excessive, the and the names don't really
> > > matter.
> > 
> > Then what do we do when someone comes along and changes one of those
> > names; do we go around changing the markers and then requiring all tools
> > to change as well?
> > 
> 
> We should really think about what we are doing before we add a marker in
> the kernel code. The information extracted should be both useful and
> expected not to change too much between versions. Ideally,
> implementation details should not be exported. Exporting useless
> information "just because we can" would indeed put pressure on
> maintainers. That's where I expect them to be the best persons to tell
> what is an implementation detail likely to change, and what is a more
> "conceptually stable" information. e.g. a context switch is a context
> switch, this does not change with the underlying implementation.
> 
> I think that whenever we can add a more "generic" marker which solves
> many special cases, we should do so. In this case, using the system call
> instrumentation found in my architecture specific instrumentation
> patchset would comprehend futex instrumentation. By adding extraction of
> all system call parameters, things such as futexes should be covered.
> However, we would still need to instrument read() or exec() to extract
> the file names. Otherwise, we would have to start doing
> architecture-specific code which would "know" what arguments are passed
> to each system call. I guess we could do that if it lessens
> instrumentation intrusiveness, but we would have to deal with a system
> call tracing infrastructure tied closely to system call parameters.
> System call audit code seems to already do that, so I guess we could go
> that way.
> 
> Then, I think we should turn to inner-kernel instrumentation only when
> the information extracted from the stable kernel ABI (e.g. system calls)
> is not complete enough to understand how things work. That would be the
> case for block I/O tracing for instance.

Agreed - so this futex instrumentation will not go anywhere. Prasad
could perhaps help out with your arch specific syscall tracer.

