Return-Path: <linux-kernel-owner+w=401wt.eu-S1764013AbXF2McN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764013AbXF2McN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXF2Maf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:30:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376AbXF2Mad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:30:33 -0400
Date: Fri, 29 Jun 2007 14:29:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629122906.GA13035@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629113423.GA9042@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> wrote:

> > also, the "be afraid of the hardirq or the process context" mantra 
> > is overblown as well. If something is too heavy for a hardirq, _it's 
> > too heavy for a tasklet too_. Most hardirqs are (or should be) 
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > running with interrupts enabled, which makes their difference to 
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > softirqs miniscule.
    ^^^^^^^^^^^^^^^^^^
> 
> Incorrect.
> 
> The difference between softirqs and hardirqs lays not in their 
> "heavyness". It is in reentrancy protection, which has to be done with 
> local_irq_disable(), unless networking is not isolated from hardirqs. 

i know that pretty well ;)

> That's all. Networking is too hairy to allow to be executed with 
> disabled hardirqs. And moving this hairyiness to process context 
> requires <irony mode> a little </> more efforts than conversion 
> tasklets to work queues.

as i said above (see the underlined sentence), hardirq contexts already 
run just fine with hardirqs enabled. So your dismissal of executing that 
'hairy' bit in hardirq context is not that automatically true as you 
seem to assume i think.

also, network softirq locking dependencies arent all that magic or 
complex either: they do not operate on sockets that are already locked 
by a user context, they are per CPU and they are not preempted by 
'themselves', nor are they preempted by certain other softirqs (such as 
they are not preempted by the timer softirq). Am i missing some point of 
yours?

	Ingo
