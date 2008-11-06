Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYKFGLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYKFGLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYKFGLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:11:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYKFGLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:11:33 -0500
Date: Thu, 6 Nov 2008 07:11:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
Message-ID: <20081106061125.GA6384@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> To get a meaningful /proc/<pid>/wchan, one is required to turn on 
> full frame pointer when compile kernel/sched.c on x86 arch.  The 
> enabling of frame pointer applies to entire kernel/sched.c and 
> affects lots of other core scheduler functions that aren't related 
> to wchan's call stack unwind.  This causes unnecessary expansion of 
> stack pointer push and pop on the stack for scheduler functions.  To 
> cut down the cost of frame pointer push/pop, one can use compile 
> time config option 'single-depth wchan'.  However, the 
> 'single-depth' option is broken on x86 due to lack of stack frame 
> marker and simple stack unwind doesn't work, i.e., wchan always 
> produces '0'.
> 
> This patch adds call site location explicitly in thread_struct for 
> schedule() function so that get_wchan() can reliably get the data 
> and at the same time not to overly burden the entire kernel/sched.c 
> with frame pointer generation.  The remove of frame pointer 
> dependency allows compiler to generate better and faster core 
> scheduler code on x86_64.

hm, this adds overhead - and the thing is that WCHAN is rather 
uninformative to begin with (because it's a single dimension), so we 
should phase it out, not expand it.

How about adding a /proc/<PID>/stacktrace file that gives us the stack 
trace of any task in the system? That would be useful for a number of 
other purposes as well, and about 100 times more useful than wchan. 
(often it would be more useful than sysrq-t dumps)

Hm?

	Ingo
