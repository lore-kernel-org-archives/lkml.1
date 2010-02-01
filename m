Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0BASiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:38:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397Ab0BASiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:38:15 -0500
Date: Mon, 1 Feb 2010 10:36:21 -0800 (PST)
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
In-Reply-To: <20100201174500.GA13744@Krystal>
Message-ID: <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> <20100201164856.GA3486@Krystal>
 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain> <20100201174500.GA13744@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> 
> Here is the detailed execution scenario showing the race.

No. You've added random smp_mb() calls, but you don't actually show what 
the f*ck they are protecting against.

For example

> First sys_membarrier smp_mb():

I'm not AT ALL interested in the sys_membarrier() parts. You can hav ea 
million memory barriers there, and I won't care. I'm interested in what 
you think the memory barriers elsewhere protect against. It's a barrier 
between _which_ two operations? 

You can't say it's a barrier "around" the

	cpumask_clear(mm_cpumask, cpu);

because a barrier is between two things. So if you want to add two 
barriers around that mm_cpumask acces, you need to describe the _three_ 
events you're barriers between in that call-path (with mm_cpumask being 
just one of them)

And then, once you've described _those_ three events, you describe what 
the sys_membarrier interaction is, and how mm_cpumask is involved there.

I'm not interested in the user-space code. Don't even quote it. It's 
irrelevant apart from the actual semantics you want to guarantee for the 
new membarrier() system call. So don't quote the code, just explain what 
the actual barriers are.

			Linus
