Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0BAQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:58:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0BAQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:58:15 -0500
Date: Mon, 1 Feb 2010 08:56:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task switch
 at runqueue lock/unlock
In-Reply-To: <20100201164856.GA3486@Krystal>
Message-ID: <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
 <20100201164856.GA3486@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> 
> What we have to be careful about here is that it's not enough to just
> rely on switch_mm() containing a memory barrier. What we really need to
> enforce is that switch_mm() issues memory barriers both _before_ and
> _after_ mm_cpumask modification. The "after" part is usually dealt with
> by the TLB context switch, but the "before" part usually isn't.

Ok, whatever. I vote for not doing anything at all, because this just all 
sounds like some totally crazy crap. You haven't explained the actual 
races, you haven't explained anything at all, you're apparently just 
randomly sprinkling smp_mb's around until you think it's all fine.

Show the actual memory ordering constraints as it is related to the kernel 
data structures. I'm totally uninterested in general handwaving and "we 
must have smp_mb's here and here" without very explicit explanations of 
exactly WHAT the memory orderings are.

		Linus
