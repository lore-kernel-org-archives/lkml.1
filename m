Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbZLJR5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbZLJR5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbZLJR5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:57:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760962AbZLJR5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:57:47 -0500
Date: Thu, 10 Dec 2009 18:57:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210175737.GB5256@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
 <20091210141121.GB1436@elte.hu>
 <1260456803.2146.167.camel@gandalf.stny.rr.com>
 <20091210153845.GA28230@elte.hu>
 <y0md42magc1.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0md42magc1.fsf@fche.csb>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > [...]
> > Just off the top of my head we want to be able to trace:
> >
> >  - max irq service latencies for a given IRQ
> >  - max block IO completion latencies for a app
> >  - max TLB flush latencies in the system
> >  - max sys_open() latencies in a task
> >  - max fork()/exit() latencies in a workload
> >  - max scheduling latencies on a given CPU
> >  - max page fault latencies
> >  - max wakeup latencies for a given task
> >  - max memory allocation latencies
> >
> >  - ... and dozens and dozens of other things where there's a "start"
> >    and a "stop" event and where we want to measure the time between
> >    them.
> > [...]
> 
> FWIW, those who want to collect such measurements today can do so with 
> a few lines of systemtap script for each of the above.

Well, i dont think stap can do workload instrumentation. It can do 
system-wide (and user local / task local) - but can it do per task 
hierarchies?

Also, i dont think stap supports proper separation of per workload 
measurements either. I.e. can you write a script that will work properly 
even if multiple monitoring tools are running, each trying to measure 
latencies?

Also, i personally find built-in kernel functionality more trustable 
than dynamically built stap kernel modules that get inserted.

	Ingo
