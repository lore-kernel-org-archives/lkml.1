Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0BAP2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:28:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175Ab0BAP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:28:50 -0500
Date: Mon, 1 Feb 2010 07:27:16 -0800 (PST)
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
In-Reply-To: <20100131210013.446503342@polymtl.ca>
Message-ID: <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Jan 2010, Mathieu Desnoyers wrote:
> 
> Adds no overhead on x86, because LOCK-prefixed atomic operations of the spin
> lock/unlock already imply a full memory barrier.

.. and as Nick pointed out, you're fundamentally incorrect on this. 
unlock on x86 is no memory barrier at all, since the x86 memory ordering 
rules are such that a regular store always has release consistency.

But more importantly, you don't even explain why the addded smp_mb() 
helps.

Why does a smp_mb() at the lock/unlock even matter? Reading accesses by 
the same CPU sure as hell do _not_ matter, so the whole concept seems 
totally broken. There is no way in _hell_ that whatever unlocked thing 
can ever write the variables protected by the lock, only read them. So a 
full memory barrier makes zero sense to begin with.

So what are these magical memory barriers all about?

		Linus
