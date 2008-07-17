Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYGQHCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYGQHCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYGQHCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:02:11 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:33916 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYGQHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:02:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAOCJfkhMRKxB/2dsb2JhbACBWq5b
Date: Thu, 17 Jul 2008 03:02:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 09/17] LTTng instrumentation - filemap
Message-ID: <20080717070207.GA30312@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222748.002421557@polymtl.ca> <200807171625.25302.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807171625.25302.nickpiggin@yahoo.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:58:07 up 42 days, 11:39,  5 users,  load average: 3.19, 1.31,
	1.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> On Wednesday 16 July 2008 08:26, Mathieu Desnoyers wrote:
> > Instrumentation of waits caused by memory accesses on mmap regions.
> >
> > Those tracepoints are used by LTTng.
> >
> > About the performance impact of tracepoints (which is comparable to
> > markers), even without immediate values optimizations, tests done by Hideo
> > Aoki on ia64 show no regression. His test case was using hackbench on a
> > kernel where scheduler instrumentation (about 5 events in code scheduler
> > code) was added. See the "Tracepoints" patch header for performance result
> > detail.
> 
> BTW. this sort of test is practically useless to measure overhead. If
> a modern CPU is executing out of primed insn/data and branch prediction
> cache, then yes this sort of thing is pretty well free.
> 
> I see *real* workloads that have got continually and incrementally slower
> eg from 2.6.5 to 2.6.20+ as "features" get added. Surprisingly, none of
> them ever showed up individually on a microbenchmark.
> 
> OK, for this case if you can configure it out, I guess that's fine. But
> let's not pretend that adding code and branches and function calls are
> ever free.

I never pretended anything like that. Actually, that's what the
"immediate values" are for : they allow to patch load immediate value
instead of a memory read to decrease d-cache impact. They now allow to
patch a jump instead of the memory read/immediate value read + test +
conditional branch to skip the function call with fairly minimal impact.
I agree with you that eating precious d-cache and jump prediction buffer
entries can eventually slow down the system. But this will be _hard_ to
show on a single macro benchmark, and the microbenchmark showing it will
have to be taken in conditions which will exacerbate the d-cache and BPB
impact.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
