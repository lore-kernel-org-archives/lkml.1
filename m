Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYKFV4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYKFV4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYKFV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:56:42 -0500
Received: from waste.org ([66.93.16.53]:51612 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYKFV4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:56:41 -0500
Subject: Re: [patch] sched: fix single-depth wchan output
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081106061125.GA6384@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
	 <20081106061125.GA6384@elte.hu>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 15:56:11 -0600
Message-Id: <1226008571.3023.20.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 07:11 +0100, Ingo Molnar wrote:
> * Ken Chen <kenchen@google.com> wrote:
> 
> > To get a meaningful /proc/<pid>/wchan, one is required to turn on 
> > full frame pointer when compile kernel/sched.c on x86 arch.  The 
> > enabling of frame pointer applies to entire kernel/sched.c and 
> > affects lots of other core scheduler functions that aren't related 
> > to wchan's call stack unwind.  This causes unnecessary expansion of 
> > stack pointer push and pop on the stack for scheduler functions.  To 
> > cut down the cost of frame pointer push/pop, one can use compile 
> > time config option 'single-depth wchan'.  However, the 
> > 'single-depth' option is broken on x86 due to lack of stack frame 
> > marker and simple stack unwind doesn't work, i.e., wchan always 
> > produces '0'.
> > 
> > This patch adds call site location explicitly in thread_struct for 
> > schedule() function so that get_wchan() can reliably get the data 
> > and at the same time not to overly burden the entire kernel/sched.c 
> > with frame pointer generation.  The remove of frame pointer 
> > dependency allows compiler to generate better and faster core 
> > scheduler code on x86_64.
> 
> hm, this adds overhead - and the thing is that WCHAN is rather 
> uninformative to begin with (because it's a single dimension), so we 
> should phase it out, not expand it.

WCHAN is a long-standing public interface and isn't a Linuxism. I don't
think phasing it out is a good idea.

> How about adding a /proc/<PID>/stacktrace file that gives us the stack 
> trace of any task in the system? That would be useful for a number of 
> other purposes as well, and about 100 times more useful than wchan. 
> (often it would be more useful than sysrq-t dumps)

But this is a great idea, of course.

-- 
Mathematics is the supreme nostalgia of our time.

