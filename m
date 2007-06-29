Return-Path: <linux-kernel-owner+w=401wt.eu-S1765538AbXF2OZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765538AbXF2OZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbXF2OZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:25:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57696 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXF2OZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:25:25 -0400
Message-ID: <46851635.2070201@garzik.org>
Date: Fri, 29 Jun 2007 10:24:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> I had very little hope for this magic switch to get into mainline. (maybe
> get it into -mm)  But the thing was is that tasklets IMHO are over used.
> As Ingo said, there are probably only 2 or 3 places in the kernel that a
> a switch to work queue conversion couldn't solve.

This is purely a guess, backed by zero evidence.

These network drivers were hand-tuned to use tasklets.  Sure it will 
WORK as a workqueue, but that says nothing equivalence.


> Those places could then
> probably be solved by a different design (yes that would take work).

Network driver patches welcome :)


> Tasklets are there because there
> wasn't work queues or kthreads at the time of solving the solution that
> tasklets solved.

Completely false, at least in network driver land.  Threads existed and 
were used (proof: 8139too, among others).

Kernel threads were not used for hot path network packet shovelling 
because they were too damn slow.  Tasklets were single-threaded, fast, 
simple and immediate.  Workqueues today are simple and almost-fast.

	Jeff


