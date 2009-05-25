Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZEYUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZEYUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZEYUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:05:34 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:46286 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbZEYUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:05:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQHACeVGkpMQW1W/2dsb2JhbACBT5ZttBCECwU
Date: Mon, 25 May 2009 16:05:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525200531.GC22651@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal> <20090525193414.GB3667@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525193414.GB3667@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:03:10 up 86 days, 16:29,  9 users,  load average: 0.22, 0.12,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Mon, May 25, 2009 at 01:29:55PM -0400, Mathieu Desnoyers wrote:
> > Basically, to make sure we don't forget anything, someone should go
> > through all the atomic_ops.txt document once more and audit all ARM
> > primitives.
> 
> That's easy to say - it took me more than half an hour of reading through
> atomic_ops.txt to work out what was required for things like cmpxchg,
> xchg, etc because it's _very_ waffley and verbose, and directs you to
> other parts of the document.
> 
> For example, for atomic_cmpxchg it directs you to 'cas' but cas doesn't
> really say what the barrier requirements are - reading it leaves me
> to expect that provided spinlocks are serializing themselves, it's
> fine if 'cas' itself isn't.
> 
> Maybe if someone has a few days to translate atomic_ops.txt into a
> succinct set of requirements, and get _that_ reviewed, then we could
> properly audit this stuff.

I thought atomic_ops.txt was already a more succinct read than going back
into mailing list threads, other architecture implementations, papers by
Paul McKenney on LWN, etc...

(papers from Paul :
Memory Ordering in Modern Microprocessors parts 1/2
http://www.linuxjournal.com/article/8211
http://www.linuxjournal.com/article/8212)

Well, we'll see if getting something even more succinct is a task
someone is willing to tackle, given saying that getting memory barriers
correctly is an easy and straightforward task would be a gross
understatement. You might want to start by the sites I've identified as
a first cut at adding proper memory barriers. I'm just not guaranteeing
I've got them all.

Let's add a few more people who dug in other architecture's memory
barriers in CC so they might bring interesting thoughts about current
SMP state in recent ARM.

BTW I just noticed that my assembler (GNU assembler (GNU Binutils)
2.18.50.20070820) refuses to deal with "dmb st" (which would be useful
for wmb(), but supports the heavier dsb st), although the assembler
reference says it exists
(http://www.keil.com/support/man/docs/armasm/armasm_cihjfgfe.htm). Who
is the contact for binutils ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
