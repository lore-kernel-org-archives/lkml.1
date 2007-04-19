Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXDSAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXDSAtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030757AbXDSAtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:49:22 -0400
Received: from omta03sl.mx.bigpond.com ([144.140.92.155]:55906 "EHLO
	omta03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030506AbXDSAtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:49:21 -0400
Message-ID: <4626BC88.2050700@bigpond.net.au>
Date: Thu, 19 Apr 2007 10:49:12 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Mark Glines <mark@glines.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Bill Huey <billh@gnuppy.monkey.org>, Mike Galbraith <efault@gmx.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ck] Re: [Announce] [patch] Modular Scheduler Core and Completely
 Fair Scheduler [CFS]
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>	<20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>	<20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>	<20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418104814.2c6fdda7@chirp> <4626713B.1040206@nortel.com>
In-Reply-To: <4626713B.1040206@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Thu, 19 Apr 2007 00:49:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Mark Glines wrote:
> 
>> One minor question: is it even possible to be completely fair on SMP?
>> For instance, if you have a 2-way SMP box running 3 applications, one of
>> which has 2 threads, will the threaded app have an advantage here?  (The
>> current system seems to try to keep each thread on a specific CPU, to
>> reduce cache thrashing, which means threads and processes alike each
>> get 50% of the CPU.)
> 
> I think the ideal in this case would be to have both threads on one cpu, 
> with the other app on the other cpu.  This gives inter-process fairness 
> while minimizing the amount of task migration required.

Solving this sort of issue was one of the reasons for the smpnice patches.

> 
> More interesting is the case of three processes on a 2-cpu system.  Do 
> we constantly migrate one of them back and forth to ensure that each of 
> them gets 66% of a cpu?

Depends how keen you are on fairness.  Unless the process are long term 
continuously active tasks that never sleep it's probably not an issue as 
they'll probably move around enough in the long term for them each to 
get 66% over the long term.

Exact load balancing for real work loads (where tasks are coming and 
going, sleeping and waking semi randomly and over relatively brief 
periods) is probably unattainable because by the time you've work out 
the ideal placement of the currently runnable tasks on the available 
CPUs it's all changed and the solution is invalid.  The best you can 
hope for that change isn't so great as to completely invalidate the 
solution and the changes you make as a result are an improvement on the 
current allocation of processes to CPUs.

The above probably doesn't hold for some systems such as those large 
super computer jobs that run for several days but they're probably best 
served by explicit allocation of processes to CPUs using the process 
affinity mechanism.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
