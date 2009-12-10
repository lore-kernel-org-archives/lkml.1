Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZLJSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZLJSEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761158AbZLJSEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761084AbZLJSEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:04:37 -0500
Date: Thu, 10 Dec 2009 13:04:12 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210180412.GB30999@redhat.com>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu> <20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu> <1260456803.2146.167.camel@gandalf.stny.rr.com> <20091210153845.GA28230@elte.hu> <y0md42magc1.fsf@fche.csb> <20091210175737.GB5256@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210175737.GB5256@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


> > FWIW, those who want to collect such measurements today can do so with 
> > a few lines of systemtap script for each of the above.
> 
> Well, i dont think stap can do workload instrumentation. It can do 
> system-wide (and user local / task local) - but can it do per task 
> hierarchies?

It can track the evolution of task hierarchies by listening to process
forking events, and filter other kernel/user events according to
then-current hierarchy data.  One primitive implementation of this is
in the target_set.stp tapset, but it's easy to script up other
policies.


> Also, i dont think stap supports proper separation of per workload 
> measurements either. I.e. can you write a script that will work properly 
> even if multiple monitoring tools are running, each trying to measure 
> latencies?

Sure, always has.  You can run many scripts concurrently, each with its
own internal state.  (Overheads accumulate, sadly & naturally.)


> Also, i personally find built-in kernel functionality more trustable
> than dynamically built stap kernel modules that get inserted.

I understand.  In the absence of a suitable bytecode engine in the
kernel, this was the only practical way to do everything we needed.


- FChE
