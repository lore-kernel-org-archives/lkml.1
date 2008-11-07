Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYKGVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYKGVci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKGVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:32:28 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:46347 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYKGVc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:32:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAMM8FElMQWxa/2dsb2JhbACBdsh4g1Y
Date: Fri, 7 Nov 2008 16:27:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107212723.GB2654@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.DEB.1.10.0811071459130.3711@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811071459130.3711@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:17:24 up 156 days,  1:57,  7 users,  load average: 0.55, 0.52,
	0.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
> > 
> > I want to make sure
> > 
> >   __m_cnt_hi
> >  is read before
> >   mmio cnt_lo read
> 
> Hmm, let me make sure I understand why there is no wmb.
> 
> Paul, can you verify this?
> 
> Mathieu, you do the following:
> 
>    read a
>    smp_rmb
>    reab b
>    if (test b)
>       write a
> 
> So the idea is that you must read b to test it. And since we must read a 
> before reading b we can see that we write a before either?
> 
> The question remains, can the write happen before either of the reads?
> 

write a cannot happen before read a (same variable).
write a must happen after read b because it depends on the b value. It
makes sure the the side-effect of "write a" is seen by other CPUs
*after* we have read the b value.

> But since the read b is reading the hw clock, perhaps that just implies a
> wmb on the hardware side?
> 

It makes sense. The hardware clock has no cache coherency problem.. so
it could be seen as doing wmb() after each data update.

Mathieu

> -- Steve

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
