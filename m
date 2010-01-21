Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953Ab0AURHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0AURHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728Ab0AURHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:07:20 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:41148 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657Ab0AURHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:07:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAFcXWEuuWOiG/2dsb2JhbACBRthihDwE
Date: Thu, 21 Jan 2010 12:02:15 -0500
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
Message-ID: <20100121170215.GC15761@Krystal>
References: <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com> <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop> <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop> <20100121160729.GB12842@Krystal> <1264090331.31321.212.camel@gandalf.stny.rr.com> <20100121162249.GA15761@Krystal> <1264091529.31321.223.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264091529.31321.223.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:02:08 up 36 days,  1:20,  5 users,  load average: 0.05, 0.13,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-21 at 11:22 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> > > You may also need spin_lock_irqsave, et al. variants too.
> > 
> > Yep, or we simply use the local_irq_save/restore separately. That could
> > be a good idea given that only few specialized sites are affected.
> 
> If it gets used more often, then we need to consider RT. RT modifies
> spin_lock_irqsave into a standard mutex that does not disable
> interrupts. But if something does:
> 
> 	local_irq_save(flags);
> 	spin_lock_mb(&lock);
> 	[...]
> 
> Then it will break RT (if lock is to be converted).

Good point !

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
