Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZBVR2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZBVR2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZBVR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:28:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZBVR2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:28:20 -0500
Date: Sun, 22 Feb 2009 18:27:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected) [bug
	12465]
Message-ID: <20090222172758.GH6570@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.54H.w40lJB@chimera> <1234691284.4967.23.camel@kulgan.wumi.org.au> <20090215100454.GA30314@elte.hu> <1235299155.5021.6.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235299155.5021.6.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> On Sun, 2009-02-15 at 11:04 +0100, Ingo Molnar wrote:
> > qemu-sy-4237 has been scheduled away, and the system appeared to have done
> > nothing in the meantime. That's not something that really looks like a
> > scheduler regression - there is nothing the scheduler can do if KVM
> > decides to block a task.
> > 
> > It would be nice to enhance this single-CPU trace some more - to more
> > surgically see what is going on. Firstly, absolute timestamps would be
> > nice:
> > 
> >   echo funcgraph-abstime  > trace_options
> >   echo funcgraph-proc     > trace_options
> > 
> > as it's a bit hard to see the global timescale of events.
> 
> I was going to try and grab the trace with absolute timestamps 
> tonight, but that option doesn't seem to be available in 
> Linus' current kernel.
> 
> flexo:/sys/kernel/debug/tracing# echo 0 > tracing_enabled
> flexo:/sys/kernel/debug/tracing# echo function_graph > current_tracer
> flexo:/sys/kernel/debug/tracing# echo funcgraph-proc > trace_options
> flexo:/sys/kernel/debug/tracing# echo funcgraph-abstime  > trace_options
> -su: echo: write error: Invalid argument
> flexo:/sys/kernel/debug/tracing# cat trace_options 
> print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock
> nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch
> annotate nouserstacktrace nosym-userobj noprintk-msg-only
> nofuncgraph-overrun funcgraph-cpu funcgraph-overhead funcgraph-proc 
> flexo:/sys/kernel/debug/tracing# uname -a
> Linux flexo 2.6.29-rc5-00299-gadfafef #6 SMP Sun Feb 22 20:09:37 CST
> 2009 x86_64 GNU/Linux
> 
> What am I missing?

(replying here too - replied in the bugzilla already)

that's a feature of the latest tracing tree, so if you try -tip 
you'll have it.

	Ingo
