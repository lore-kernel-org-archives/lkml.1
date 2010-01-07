Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106Ab0AGPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0AGPK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026Ab0AGPK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:10:27 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:45576 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0AGPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:10:27 -0500
Date: Thu, 7 Jan 2010 10:10:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107151025.GB14259@Krystal>
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <1262874458.28171.3728.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1262874458.28171.3728.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:08:15 up 21 days, 23:26,  6 users,  load average: 0.16, 0.20,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-07 at 01:19 -0500, Mathieu Desnoyers wrote:
> 
> > I see your point.
> 
> Actually you are missing the point ;-)
> 
> > 
> > This would probably be good for machines with very large number of cpus
> > and without IPI broadcast support, running processes with only few
> > threads. I really start to think that we should have some way to compare
> > the number of threads belonging to a process and choose between the
> > broadcast IPI and the per-cpu IPI depending if we are over or under an
> > arbitrary threshold.
> 
> 
> This has nothing to do with performance. It has to do with a thread
> should not interfere with a thread belonging to another process. We
> really don't care how long the sys_membarrier() takes (it's the slow
> path anyway). We do care that a critical RT task is being interrupted by
> some java thread sending thousands of IPIs.

Yes, PeterZ scheme seems (and yours) seems to address this problem by
only impacting the CPUs running threads belonging to the current
process. I'll go with this instead of the broadcast IPI, which, as you,
Josh and Peter clearly pointed out, is a no-go in terms of real-time.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
