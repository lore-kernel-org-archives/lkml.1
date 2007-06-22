Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbXFVOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbXFVOcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXFVOb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:31:56 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:34870 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbXFVObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:31:55 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622131250.GA18729@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <20070622070948.GA21291@infradead.org>
	 <1182515542.5493.20.camel@localhost.localdomain>
	 <20070622123805.GA9770@elte.hu>
	 <1182517124.5493.38.camel@localhost.localdomain>
	 <20070622131250.GA18729@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:27:22 -0400
Message-Id: <1182522442.5493.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 15:12 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> yes, the softirq based tasklet implementation with workqueue based 
> implementation, but the tasklet API itself should still stay.

done.

> 
> ok, enough idle talking, lets see the next round of patches? :)

Still need to run through testing, and I still don't have distcc
working. So it may take a while ;-)

> 
> please remove all the pr_debug() lines as well - they are handy for 
> development but are quite unnecessary for something headed 

done (but I did keep one).

> upstream-wards. And please replace all the BUG_ON()s with WARN_ON_ONCE() 

I had two BUG_ON's and they were both for not having the ktaskletd_wq
allocated. If we just put a WARN_ON, we will right afterward get a BUG
from a bad memory reference, and put the system into an unknown state.
Are you sure you still want me to convert them to WARN_ON?

-- Steve


