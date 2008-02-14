Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYBNGI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYBNGI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 01:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYBNGIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 01:08:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYBNGIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 01:08:15 -0500
Date: Thu, 14 Feb 2008 07:07:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Latency issues with x86.git
Message-ID: <20080214060758.GC29509@elte.hu>
References: <47B39577.3020603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B39577.3020603@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Hi Ingo,
> 
> I have encountered (a handful of times in the past few months) some 
> real interactivity problems on my system.  Moving the mouse or typing 
> a key on the keyboard takes around a second to show any response.  
> Once I perform a reboot, the problem is gone again.  I am currently 
> running x86.git mm branch, but I switch between that branch, mainline 
> git, and mm kernels, so I cannot guarantee on which trees I have or 
> have not seen the problem.

please try sched-devel.git, which has both the latest scheduler fixes, 
and also the new "ftrace" latency tracing framework that can be used to 
trace various latency problems. You can pick up sched-devel.git via:

   http://people.redhat.com/mingo/sched-devel.git/README

firstly, there's a chance that sched-devel.git solves the problem - in 
that case please report it.

if it doesnt, then you can trace various latencies via these:

 CONFIG_FTRACE=y
 CONFIG_IRQSOFF_TRACER=y
 CONFIG_SCHED_TRACER=y
 CONFIG_CONTEXT_SWITCH_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y

just enable them, boot into the new kernel and mount debugfs:

   mount -t debugfs nodev /debug

and then you can select one of the tracers (that have been enabled in 
the .config) via /debug/tracing/* files. The usage of these files should 
be self-explaining - if any of them wasnt then please let us know and 
we'll make the "first quick glance experience" better :)

the one interesting to you would be the "wakeup" tracer. Enable it, and 
if you echo 0 into /debug/tracing/tracing_max_latency it starts tracking 
the worst-case delay experienced on your system and should start 
reporting them to the syslog.

if you encounter any problems during these steps then please let us know 
- this code is quite fresh so expect some rough edges.

	Ingo
