Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZCUM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZCUM6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZCUM6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:58:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZCUM6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:58:40 -0400
Date: Sat, 21 Mar 2009 08:57:06 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321125706.GB3566@redhat.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321050422.d1d99eec.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Mar 21, 2009 at 05:04:22AM -0700, Andrew Morton wrote:
> [...]
> > There have been many mixed messages from LKML on the topic - sometimes
> > mentioning systemtap is forbidden, other times necessary.  Sorry about
> > that.
> 
> heh.  We all love systemtap and want it to get better.

Great!


> [...]
> I have strong memories of being traumatised by reading the uprobes
> code.  What's the story on all of that nowadays?

uprobes, being a layer upon utrace that provides a kprobes-like
breakpointing API for user threads, is being refactored into several
parts.  I don't know about the aesthetics of it all, but I believe the
general future plan is this:

One piece would perform machine code analysis (to classify
instructions for ideal/safe placement of breakpoints or for code
patching), and another thin layer that uses this and utrace to manage
user-space breakpoints.  (Systemtap would interface at this point.)
Then a user-space syscallish interface could come along to expose this
to a super-ptrace client (to speed up gdb; perhaps to allow multiple
debuggers).  Plus one might as well add an ftrace-engine for it
(directly analogous to the recent kprobe-based one that ftrace people
found "cool".)


> > > Actually it seems that the whole utrace-ftrace thing is a big
> > > distraction and could/should just be omitted.  This is a systemtap
> > > feature and should be viewed as such. [...]
> > 
> > utrace is a better way to perform user thread management than what is
> > there now, and the utrace-ftrace widget shows how to *hook* thread
> > events such as syscalls in a lighter weight / more managed way than
> > the first one proposed.  (That's one reason we've been participating
> > in the ftrace discussions.)  Of course it can be made to use the fine
> > syscall pretty-printing code recently added.
> 
> eh.  Boring.  Let's fix systemtap?

There are several constituencies here, some of which find the above
exciting.  That's OK and we'd like to help them too.


- FChE
