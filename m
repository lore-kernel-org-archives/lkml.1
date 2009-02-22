Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZBVKjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZBVKjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 05:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZBVKj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 05:39:27 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:47833 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZBVKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 05:39:26 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected) [bug
	12465]
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090215100454.GA30314@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
	 <ROx6X68CGJG.A.54H.w40lJB@chimera>
	 <1234691284.4967.23.camel@kulgan.wumi.org.au>
	 <20090215100454.GA30314@elte.hu>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Sun, 22 Feb 2009 21:09:14 +1030
Message-Id: <1235299155.5021.6.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 11:04 +0100, Ingo Molnar wrote:
> qemu-sy-4237 has been scheduled away, and the system appeared to have done
> nothing in the meantime. That's not something that really looks like a
> scheduler regression - there is nothing the scheduler can do if KVM
> decides to block a task.
> 
> It would be nice to enhance this single-CPU trace some more - to more
> surgically see what is going on. Firstly, absolute timestamps would be
> nice:
> 
>   echo funcgraph-abstime  > trace_options
>   echo funcgraph-proc     > trace_options
> 
> as it's a bit hard to see the global timescale of events.

I was going to try and grab the trace with absolute timestamps tonight,
but that option doesn't seem to be available in Linus' current kernel.

flexo:/sys/kernel/debug/tracing# echo 0 > tracing_enabled
flexo:/sys/kernel/debug/tracing# echo function_graph > current_tracer
flexo:/sys/kernel/debug/tracing# echo funcgraph-proc > trace_options
flexo:/sys/kernel/debug/tracing# echo funcgraph-abstime  > trace_options
-su: echo: write error: Invalid argument
flexo:/sys/kernel/debug/tracing# cat trace_options 
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock
nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch
annotate nouserstacktrace nosym-userobj noprintk-msg-only
nofuncgraph-overrun funcgraph-cpu funcgraph-overhead funcgraph-proc 
flexo:/sys/kernel/debug/tracing# uname -a
Linux flexo 2.6.29-rc5-00299-gadfafef #6 SMP Sun Feb 22 20:09:37 CST
2009 x86_64 GNU/Linux

What am I missing?

Cheers,
Kevin.


