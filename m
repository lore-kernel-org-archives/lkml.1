Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbXFVV5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbXFVV5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXFVV5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:57:23 -0400
Received: from homer.mvista.com ([63.81.120.158]:20243 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbXFVV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:57:22 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20070622204058.GA11777@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 14:53:21 -0700
Message-Id: <1182549202.3228.78.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 22:40 +0200, Ingo Molnar wrote:

> 
>  - tasklets have certain fairness limitations. (they are executed in
>    softirq context and thus preempt everything, even if there is some
>    potentially more important, high-priority task waiting to be
>    executed.)

Since -rt has been executing tasklets in process context for a long
time, I'm not sure this change would cause to many regressions. However,
it seems like implicit dependencies on "tasklets preempt everything"
might crop up. The other issue is if they don't "preempt
everything" (most of the time), what default priority do we give them
(all of the time)? It seems like Christoph's suggestion of converting
all the tasklets individually might be a better option, to deal with
specific pitfalls.

Daniel

