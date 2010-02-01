Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0BAQqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:46:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0BAQqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:46:38 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=J6GmQWa78p2acjr9fz0A:9 a=TvS7dI-tTUSSMBtiBmcA:7 a=8JOd2zdngfjlYASXqSKyQs-n-_0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <1265041774.24455.209.camel@laptop>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <1265041477.29013.54.camel@gandalf.stny.rr.com>
	 <1265041774.24455.209.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 11:46:35 -0500
Message-ID: <1265042795.29013.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added linux-arch ]

On Mon, 2010-02-01 at 17:29 +0100, Peter Zijlstra wrote:
> On Mon, 2010-02-01 at 11:24 -0500, Steven Rostedt wrote:
> > 
> > Doesn't set_bit imply a wmb()? If so couldn't we do:
> 
> Nope, that's what we have smp_mb__{before,after}_set_bit() for.
> 
> On x86 its a LOCK'ed op, so sure it implies a full membarrier, but not
> in generic.
> 
> on x86 we have plenty serializing instructions before and after rq->curr
> is set so none of the crazyness is needed at all. The only thing is !
> x86.
> 

So if we go with Linus's approach and make all archs guarantee that
switch_mm() implies a full mb(), then we can simplify the
sys_membarrier() code?

That looks like the best approach.

-- Steve



