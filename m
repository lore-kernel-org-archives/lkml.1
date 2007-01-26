Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXAZVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXAZVCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXAZVCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:02:16 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49885 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXAZVCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:02:15 -0500
Date: Sat, 27 Jan 2007 02:30:17 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [mm PATCH 4/6] RCU: preemptible RCU
Message-ID: <20070126210017.GC17134@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20070115191909.GA32238@in.ibm.com> <20070115192858.GE32238@in.ibm.com> <20070123163259.0d1d5ffc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123163259.0d1d5ffc.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 04:32:59PM -0800, Andrew Morton wrote:
> On Tue, 16 Jan 2007 00:58:58 +0530
> Dipankar Sarma <dipankar@in.ibm.com> wrote:
> 
> > This patch implements a new version of RCU which allows its read-side
> > critical sections to be preempted.
> 
> Why is it selectable if CONFIG_PREEMPT=n?

It would probably make sense to make CONFIG_RCU_PREEMPT dependent
on CONFIG_PREEMPT. I kept it independent because I wanted to
test rcupreempt as an equivalent RCU implementation not just
for its "preemptibility".

> > It uses a set of counter pairs
> > to keep track of the read-side critical sections and flips them
> > when all tasks exit read-side critical section. The details
> > of this implementation can be found in this paper -
> >
> > http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf
> >
> > This patch was developed as a part of the -rt kernel
> > development and meant to provide better latencies when
> > read-side critical sections of RCU don't disable preemption.
> 
> Does it succeed in that attempt?  Thus far you've given no reason for
> merging this code..
> 
> This is a pile of tricky new core kernel code for us to test, maintain,
> understand, debug, etc.  It needs to provide a substantial benefit.  Does
> it?

I am working to compare some latency numbers between different
implementations. I will have them out soon.


> > As a consequence of keeping track of RCU readers, the readers
> > have a slight overhead (optimizations in the paper).
> > This implementation co-exists with the "classic" RCU
> > implementations and can be switched to at compiler.
> 
> That's yet another question we need to ask people when their kernel dies,
> and yet another deviation between the kernels which we all test, causing
> more dilution of testing efforts.  It would be much better if we could
> remove classic RCU.  You say this would incur extra cost, but the magnitude
> of that cost is not clear.  Please help us make that decision.

See the Table 2, page 10 of the paper mentioned above. There is a
~100ns cost per read-side critical section involved in the preemptible
version of RCU at the moment. Until, we are sure that we don't have
an impact on common workloads, we need to keep the "classic" 
implementation around.

Thanks
Dipankar
