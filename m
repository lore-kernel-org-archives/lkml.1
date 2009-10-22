Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZJVT5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZJVT5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZJVT5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:57:51 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:52999 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbZJVT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:57:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAChW4EpGGN1W/2dsb2JhbACBUtp2hD8EgV17
Date: Thu, 22 Oct 2009 15:57:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David S. Miller" <davem@davemloft.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu
Subject: Sparc64 support added to Userspace RCU
Message-ID: <20091022195753.GA27253@Krystal>
References: <20091022183242.GA19307@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091022183242.GA19307@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:51:26 up 65 days,  6:40,  4 users,  load average: 0.29, 0.27,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, I just added sparc64 support to the Userspace RCU library,
available at: git://lttng.org/userspace-rcu.git

Interesting files concerning sparc64 are:

urcu/arch_sparc64.h
urcu/uatomic_arch_sparc64.h

Direct links:
http://www.lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=blob;f=urcu/arch_sparc64.h;hb=HEAD
http://www.lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=blob;f=urcu/uatomic_arch_sparc64.h;hb=HEAD

Please note that this code targets user-space, not kernel-space.

Feedback is welcome,

Thanks,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi David,
> 
> I took a look at the current sparc64 cmpxchg implementation in the Linux
> kernel and stumbled on this commit:
> 
> commit 293666b7a17cb7a389fc274980439212386a19c4
> Author: David S. Miller <davem@davemloft.net>
> Date:   Sat Nov 15 13:33:25 2008 -0800
> 
>     sparc64: Stop using memory barriers for atomics and locks.
>     
>     The kernel always executes in the TSO memory model now,
>     so none of this stuff is necessary any more.
>     
>     With helpful feedback from Nick Piggin.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Reading p. 152 A.9 Compare and Swap, I see that the cas instruction does
> not imply a memory barrier.
> 
> Reading http://docs.sun.com/app/docs/doc/801-6678/6i11oelck?a=view
> 
> I see that:
> 
> "TSO guarantees that the store, FLUSH, and atomic load-store
> instructions of all processors appear to be executed by memory serially
> in a single order called the memory order. Furthermore, the sequence of
> store, FLUSH, and atomic load-store instructions in the memory order for
> a given processor is identical to the sequence in which they were issued
> by the processor."
> 
> So it provides no guarantee whatsoever wrt loads. However, reading
> Documentation/memory-barriers.txt:
> 
> "Whilst they are technically interprocessor interaction considerations,
> atomic operations are noted specially as some of them imply full memory
> barriers and some don't, but they're very heavily relied on as a group
> throughout the kernel." -> cmpxchg is part of them.
> 
> The same applies to the other atomic instructions we find in this list.
> How is the correct ordering of loads wrt to cmxchg (and other atomic
> ops) still ensured by this modification?
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
