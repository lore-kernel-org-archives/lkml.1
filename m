Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZEYW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZEYW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZEYW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:27:45 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:52234 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZEYW1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:27:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At8EAEK1GkpMQW1W/2dsb2JhbACBT8oJhAsF
Date: Mon, 25 May 2009 18:27:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Broken ARM (and powerpc ?) futex wrt memory barriers
Message-ID: <20090525222744.GA28289@Krystal>
References: <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal> <20090525195656.GC3667@n2100.arm.linux.org.uk> <20090525202210.GD22651@Krystal> <20090525214533.GA26419@Krystal> <20090525215754.GF3667@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525215754.GF3667@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:25:28 up 86 days, 18:51,  6 users,  load average: 0.48, 0.18,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Mon, May 25, 2009 at 05:45:33PM -0400, Mathieu Desnoyers wrote:
> > I think we also have to deal with futexes. See
> > arch/arm/include/asm/futex.h :
> > 
> > 1 - 
> > 
> > #ifdef CONFIG_SMP
> > 
> > #include <asm-generic/futex.h>
> > 
> > #else /* !SMP, we can work around lack of atomic ops by disabling
> > preemption */
> > 
> > (arm-specific code here, seems to deal with futexes)
> > 
> > #endif
> > 
> > -> is it just me or this ifdef condition is the exact opposite of what
> > it should be ? I thought those generic futexes were for UP-only
> > systems...
> 
> No, it is correct.  Look deeper - the generic stuff implements a whole
> load of futex stuff as returning -ENOSYS - it's not implemented.
> 
> What you see in ARM is the UP code implementing the set/add/or/andn/xor
> cmpxchg operations.  However, this code is most certainly not SMP safe
> (and I couldn't persuade the folk writing it to come up with a SMP
> version.)  So, on ARM futex is supported on UP systems, but not SMP
> systems until someone gets around to fixing this.

Ah, yes, you are right. I did not realize ARM SMP support was at such an
early stage. I think there is still some work ahead before those SMP
boards can be fully supported, but I'm glad we're making progress. :)

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
