Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbXF1R1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbXF1R1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbXF1R1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:27:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbXF1R07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:26:59 -0400
Message-ID: <4683EF50.30108@garzik.org>
Date: Thu, 28 Jun 2007 13:26:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
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
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu>
In-Reply-To: <20070628160001.GA15495@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> my argument was: workqueues are more scalable than tasklets in general.

Here is my argument:  that is totally irrelevant to $subject, when it 
comes to dealing with managing existing [network driver] behavior and 
performance.

My overall objection is the attempt to replace apples with oranges.

Network drivers use tasklets TODAY.  Each driver -- in particular 
acenic, ns83820, and the 10Gbps drivers -- has been carefully tuned to 
use tasklets, hardirqs, and perhaps NAPI too.  Changing to workqueue 
WILL affect network driver hot paths, yet I see no analysis or 
measurement at all of the behavior differences.

If hackers are willing to revisit each network driver, rework the 
tasklet code to something more sane [in your opinion], and TEST it, I 
will review the patches and happily ACK away.

Given that I feel that course of action is unlikely (the preferred 
alternative apparently being "I don't use these drivers, but surely my 
changes are OK anyway"), I do not see how this effort can proceed as is.

Lots of time went into tuning these network drivers for the specific 
thread model they use.  Maybe that thread model is no longer in style. 
Maybe modern machine behavior dictates a different approach.  The point 
is... you don't know.

	Jeff


