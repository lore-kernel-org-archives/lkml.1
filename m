Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567Ab0A2RNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0A2RNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350Ab0A2RNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:13:20 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:34926 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab0A2RNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:13:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikFAH6lYktGGNtq/2dsb2JhbACBNNknhEIE
Date: Fri, 29 Jan 2010 12:08:17 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
	CONFIG_PREEMPT=y
Message-ID: <20100129170817.GA2283@Krystal>
References: <4B5E476C.9030303@redhat.com> <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com> <20100129092135.GE10878@elte.hu> <4B62F61D.5060203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B62F61D.5060203@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:05:31 up 44 days,  1:23,  5 users,  load average: 0.11, 0.15,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Disable kprobe booster when CONFIG_PREEMPT=y, because it can't ensure that 
> >> all kernel threads preempted on kprobe's boosted slot run out from the slot 
> >> even using freeze_processes().
> > 
> > hm, this really sucks as it makes preemptible kernels perform worse. Is there 
> > no better solution?
> > 
> >> The booster on preemptive kernel will be resumed if synchronize_tasks() or 
> >> something like that is introduced.
> > 
> > such as this one?
> 
> Yes, I think this synchronize_tasks(), which just (sleeping) wait until
> all currently preempted tasks are wake up and scheduled, can ensure safety

If a task is set as stopped, and the preempted before calling schedule,
can this result in a preempted task staying in that state for an
arbitrary long period of time ? Or is there some mechanism prohibiting
that in the scheduler ?

Thanks,

Mathieu

> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
