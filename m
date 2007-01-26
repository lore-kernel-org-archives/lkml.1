Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbXAZVoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbXAZVoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXAZVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:44:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbXAZVoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:44:37 -0500
Date: Fri, 26 Jan 2007 13:25:45 -0800
From: Andrew Morton <akpm@osdl.org>
To: dipankar@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [mm PATCH 4/6] RCU: preemptible RCU
Message-Id: <20070126132545.722c787c.akpm@osdl.org>
In-Reply-To: <20070126210017.GC17134@in.ibm.com>
References: <20070115191909.GA32238@in.ibm.com>
	<20070115192858.GE32238@in.ibm.com>
	<20070123163259.0d1d5ffc.akpm@osdl.org>
	<20070126210017.GC17134@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 02:30:17 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> > > As a consequence of keeping track of RCU readers, the readers
> > > have a slight overhead (optimizations in the paper).
> > > This implementation co-exists with the "classic" RCU
> > > implementations and can be switched to at compiler.
> > 
> > That's yet another question we need to ask people when their kernel dies,
> > and yet another deviation between the kernels which we all test, causing
> > more dilution of testing efforts.  It would be much better if we could
> > remove classic RCU.  You say this would incur extra cost, but the magnitude
> > of that cost is not clear.  Please help us make that decision.
> 
> See the Table 2, page 10 of the paper mentioned above.

argh.

Seems I have to wade through half the paper to understand Table 2.

> There is a
> ~100ns cost per read-side critical section involved in the preemptible
> version of RCU at the moment. Until, we are sure that we don't have
> an impact on common workloads, we need to keep the "classic" 
> implementation around.

Ratios, please..  that 100ns appears to be a 100% increase.  ie 100ns -> 200ns.

There are a couple of ways of working out how much that really matters: a)
run a workload or b) instrument a kernel, work out how many times/sec the
kernel runs rcu_read_lock().  I suspect b) would be more useful and
informative.

Either way, please always prepare such info up-front and summarise in the
changelog?  It's kinda important...
