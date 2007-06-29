Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXF2PYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXF2PYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXF2PYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:24:32 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:42357 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751255AbXF2PYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=I6hP5w9p+cSBYDdiOM34187pg60zyypnq3+V+XfH86pzSdwagca14caUBJwRhbQBMrtnJaaFNuqIQhdCmvGYykv9oYNF8gRgK0GaOMt5EvQDrKgpm0oKt52PT+F3r/H7f1Jr9OrGddCWA4oCdE5999Z8MboaJ57IbQQfyawSW3s=;
Date: Fri, 29 Jun 2007 19:23:22 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070629152322.GA6663@ms2.inr.ac.ru>
References: <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629122906.GA13035@elte.hu> <20070629132514.GA19021@ms2.inr.ac.ru> <20070629134303.GA30257@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629134303.GA30257@elte.hu>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> again, there is no reason why this couldnt be done in a hardirq context. 
> If a hardirq preempts another hardirq and the first hardirq already 
> processes the 'softnet work', you dont do it from the second one but 
> queue it with the first one. (into the already existing 
> sd->completion_queue for tx work or queue->poll_list for rx work) It 
> would be a simple additional flag in softnet_data.

This is kind of obvious. It is just description of softnet.


> once we forget about 'hardirq contexts run with irqs disabled', _there 
> is just no technological point for softirqs_. They are an unnecessary 
> abstraction!

The first paragraph describes softirq, nothing else.

I have already understood when you say "technological",
you mean "terminological". "softirq" is just a term to describe
"softnet" workflow in an intelligible way. Call it from inside
irq handler, rather than in irq_exit, this changes _NOTHING_.

I understood that you describe original pre-historic
softnet model. You just want to replace softirq run at irq_exit
with an explicit soft{net,scsi,whatever}_call, which could
execute immediately or can be queued for later. I hope I am wrong,
because this is... mmm... not a progress.


> -rt, local_bh_disable() is a NOP there. How is it done?
...
> Are we talking about the very same thing perhaps, just from a different 
> angle? ;-)

When talking about softnet, yes.

No, when talking about "implementing non-reentrancy via another,
more flexible mechanism". We are not on the same page.
I am afraid even the books are different. :-)

I need to think about this and really read -rt code, this sounds so crazy
that it can be even correct.

Timeout, we are far out of topic anyway.

Alexey
