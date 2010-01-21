Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711Ab0AUQWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0AUQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856Ab0AUQWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:22:52 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:37283 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab0AUQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:22:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAEEKWEuuWOiG/2dsb2JhbACBRtduhDwE
Date: Thu, 21 Jan 2010 11:22:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100121162249.GA15761@Krystal>
References: <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com> <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop> <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop> <20100121160729.GB12842@Krystal> <1264090331.31321.212.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264090331.31321.212.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:21:13 up 36 days, 39 min,  5 users,  load average: 0.35, 0.28,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-21 at 11:07 -0500, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> 
> > We can even create a generic fallback with the following kind of code in
> > the meantime:
> > 
> > static inline void spin_lock_mb(spinlock_t *lock)
> > {
> > 	spin_lock(&lock);
> 
> That would be spin_lock(lock);
> 
> > 	smp_mb();
> > }
> > 
> > static inline void spin_unlock_mb(spinlock_t *lock)
> > {
> > 	smp_mb();
> > 	spin_unlock(&lock);
> 
> and spin_unlock(lock);
> 
> ;-)

Oh, right. I should think of integrating a compiler in my mail client ;)


> 
> > }
> > 
> > How does that sound ?
> 
> You may also need spin_lock_irqsave, et al. variants too.

Yep, or we simply use the local_irq_save/restore separately. That could
be a good idea given that only few specialized sites are affected.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
