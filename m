Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXEPCEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXEPCEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbXEPCEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:04:16 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:41762 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbXEPCEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:04:16 -0400
Message-ID: <464A6698.3080400@bigpond.net.au>
Date: Wed, 16 May 2007 12:04:08 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu>
In-Reply-To: <20070513153853.GA19846@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06ps.mx.bigpond.com from [138.130.234.53] using ID pwil3058@bigpond.net.au at Wed, 16 May 2007 02:04:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm pleased to announce release -v12 of the CFS scheduler patchset.
> 
> The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be 
> downloaded from the usual place:
>   
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> -v12 fixes the '3D bug' that caused trivial latencies in 3D games: it 
> turns out that the problem was not resulting out of any core quality of 
> CFS, it was caused by 3D userspace growing dependent on the current 
> inefficiency of the vanilla scheduler's sys_sched_yield() 
> implementation, and CFS's "make yield work well" changes broke it.
> 
> Even a simple 3D app like glxgears does a sys_sched_yield() for every 
> frame it generates (!) on certain 3D cards, which in essence punishes 
> any scheduler that implements sys_sched_yield() in a sane manner. This 
> interaction of CFS's yield implementation with this user-space bug could 
> be the main reason why some testers reported SD to be handling 3D games 
> better than CFS. (SD uses a yield implementation similar to the vanilla 
> scheduler.)
> 
> So i've added a yield workaround to -v12, which makes it work similar to 
> how the vanilla scheduler and SD does it. (Xorg has been notified and 
> this bug should be fixed there too. This took some time to debug because 
> the 3D driver i'm using for testing does not use sys_sched_yield().) The 
> workaround is activated by default so -v12 should work 'out of the box'.
> 
> Mike Galbraith has fixed a bug related to nice levels - the fix should 
> make negative nice levels more potent again.
> 
> Changes since -v10:
> 
>  - nice level calculation fixes (Mike Galbraith)
> 
>  - load-balancing improvements (this should fix the SMP performance 
>    problem reported by Michael Gerdau)
> 
>  - remove the sched_sleep_history_max tunable.
> 
>  - more debugging fields.
> 
>  - various cleanups, fixlets and code reorganization
> 
> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome,

Load balancing appears to be badly broken in this version.  When I 
started 4 hard spinners on my 2 CPU machine one ended up on one CPU and 
the other 3 on the other CPU and they stayed there.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
