Return-Path: <linux-kernel-owner+w=401wt.eu-S1765831AbYBGA4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765831AbYBGA4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbYBGAvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:51:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933091AbYBGAvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:51:45 -0500
Date: Wed, 6 Feb 2008 16:50:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: fmayhar@google.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
Message-Id: <20080206165045.89b809cc.akpm@linux-foundation.org>
In-Reply-To: <bug-9906-10286@http.bugzilla.kernel.org/>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Feb 2008 16:33:20 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9906
> 
>            Summary: Weird hang with NPTL and SIGPROF.
>            Product: Process Management
>            Version: 2.5
>      KernelVersion: 2.6.24-rc4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Scheduler
>         AssignedTo: mingo@elte.hu
>         ReportedBy: fmayhar@google.com
> 
> 
> Latest working kernel version: None
> Earliest failing kernel version: 2.6.18
> Distribution: Ubuntu
> Hardware Environment: Any
> Problem Description:
> I have a testcase that demonstrates a strange hang of the latest kernel
> (as well as previous ones).  In the process of investigating the NPTL,
> we wrote a test that just creates a bunch of threads, then does a
> barrier wait to synchronize them all, after which everybody exits.
> That's all it does.
> 
> This works fine under most circumstances.  Unfortunately, we also want
> to do profiling, so we catch SIGPROF and turn on ITIMER_PROF.  In this
> case, at somewhere between 4000 and 4500 threads, and using the NPTL,
> the system hangs.  It's not a hard hang, interrupts are still working
> and clocks are ticking, but nothing is making progress.  It becomes
> noticeable when the softlockup_tick() warning goes off after the
> watchdog has been starved long enough.
> 
> Sometimes the system recovers and gets going again.  Other times it
> doesn't.  I've examined the state of things several times with kdb and
> there's certainly nothing obvious going on.  Something, perhaps having
> to do with the scheduler, is certainly getting into a bad state, but I
> haven't yet been able to figure out what that is.  I've even run it with
> KFT and have seen nothing obvious there, either, except for the fact
> that when it hangs it becomes obvious that it stops making progress and
> it begins to fill up with smp_apic_timer_interrupt() and do_softirq()
> entries.  I've also seen smp_apic_timer_interrupt() appear twice or more
> on the stack, as if the previous run(s) didn't finish before the next
> tick happened.
> 
> Steps to reproduce:
> 
> I'll attach a testcase shortly.
> 

It's probably better to handle this one via email, so please send that
testcase vie reply-to-all to this email, thanks.

