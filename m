Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXFVWBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXFVWBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXFVWBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:01:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbXFVWBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:01:12 -0400
Date: Fri, 22 Jun 2007 23:59:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622215953.GA22917@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> If the numbers say that there is no performance difference (or even 
> better: that the new code performs better or fixes some latency issue 
> or whatever), I'll be very happy. But if the numbers say that it's 
> worse, no amount of cleanliness really changes that.

Most of the tasklet uses are in rarely used or arcane drivers - in fact 
none of my 10 test-boxes utilizes _any_ tasklet in any way that could 
even get close to mattering to performance. In other words: i just 
cannot test this, nor do i think that others will really test this. I.e. 
if we dont approach this problem in some other way, nothing will happen 
and Steve's patch will be stalled forever and will live in -rt forever. 
(which might be a correct end result too, but i'm just not giving up 
this easily :-)

so how about the following, different approach: anyone who has a tasklet 
in any performance-sensitive codepath, please yell now. We'll also do a 
proactive search for such places. We can convert those places to 
softirqs, or move them back into hardirq context. Once this is done - 
and i doubt it will go beyond 1-2 places - we can just mass-convert the 
other 110 places to the lame but compatible solution of doing them in a 
global thread context.

[ and on a similar notion, i still havent given up on seeing all BKL use 
  gone from the kernel. I expect it to happen any decade now ;-) ]

	Ingo
