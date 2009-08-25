Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZHYQZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZHYQZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZHYQZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:25:49 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:62047 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbZHYQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:25:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFACink0pMROOX/2dsb2JhbACBU9ZZhBoF
Date: Tue, 25 Aug 2009 12:25:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josht@linux.vnet.ibm.com, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug
	CPU
Message-ID: <20090825162549.GB25058@Krystal>
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825080047.GA16139@elte.hu> <20090825161208.GE6616@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825161208.GE6616@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:22:14 up 7 days,  3:11,  2 users,  load average: 0.02, 0.19,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Aug 25, 2009 at 10:00:47AM +0200, Ingo Molnar wrote:
> > 
> > btw., i'm still seeing crashes with the latest RCU bits:
> > 
> > [   20.621740] Testing event sys_enter_futex: OK
> > [   20.629738] Testing event sys_exit_futex: OK
> > [   20.637737] Testing event lock_acquire: [reboot]
> > 
> > Possibly due to infinite recursion as well. Config attached.
> 
> Color me confused...
> 
> Unless someone has a better idea, I will send in a patch that adds
> "notrace" to every RCU API member used by any file in the kernel
> that has "trace" in its name (excluding ptrace.c and rcutree_trace.c,
> of course).  This list is as follows:
> 
> 	call_rcu()
> 	call_rcu_sched()
> 	rcu_read_lock()
> 	rcu_read_unlock()
> 
> So, any better ideas?

Tracers using RCU should use the _notrace() version of read_lock/unlock.
I think the callers should be fixed rather than RCU.

Tracepoints have been designed to use the _notrace variant on the
instrumentation site. The core of tracepoint management use
call_rcu_sched(), which can be traced without any problem.

I have not followed the late tracing development as closely though, so
errors might have crept in.

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
