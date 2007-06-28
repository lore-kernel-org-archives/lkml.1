Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXF1FtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXF1FtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 01:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbXF1FtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 01:49:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46124 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXF1FtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 01:49:06 -0400
Message-ID: <46834BB8.1020007@garzik.org>
Date: Thu, 28 Jun 2007 01:48:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu>
In-Reply-To: <20070622215953.GA22917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> so how about the following, different approach: anyone who has a tasklet 
> in any performance-sensitive codepath, please yell now. We'll also do a 
> proactive search for such places. We can convert those places to 
> softirqs, or move them back into hardirq context. Once this is done - 
> and i doubt it will go beyond 1-2 places - we can just mass-convert the 
> other 110 places to the lame but compatible solution of doing them in a 
> global thread context.


Color me unconvinced.

Tasklets fill a niche not filled by either workqueues (slower, requiring 
context switches, and possibly much latency is all wq's processes are 
active) or softirqs (limited number of them, not flexible at all). 
Sure, tasklets kick over to ksoftirqd, but not immediately, and therein 
lies their value.

And moving code -back- into hardirq is just the wrong thing to do, usually.

This proposal is ENTIRELY derived from "not convenient to my project" 
logic AFAICS, rather than the more sound "not needed in the kernel."

	Jeff



