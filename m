Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDPGlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDPGlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXDPGlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:41:18 -0400
Received: from omta02ps.mx.bigpond.com ([144.140.83.154]:58820 "EHLO
	omta02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXDPGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:41:18 -0400
X-Greylist: delayed 4405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 02:41:17 EDT
Message-ID: <46231A77.8030600@bigpond.net.au>
Date: Mon, 16 Apr 2007 16:40:55 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415153933.GB6623@elte.hu> <46230950.8000005@bigpond.net.au> <4623166A.3080500@bigpond.net.au>
In-Reply-To: <4623166A.3080500@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 06:41:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Peter Williams wrote:
>>
>> Are your new patches available somewhere for easy download or do I 
>> have to try to dig them out of the mailing list archive?  Or could you 
>> mail them to me separately?  I'm keen to see how you new scheduler 
>> proposal works.
> 
> Forget about this.  I found the patch.
> 
> After a quick look, I like a lot of what I see especially the removal of 
> the dual arrays in the run queue.
> 
> Some minor suggestions:
> 
> 1. having defined DEFAULT_PRIO in sched.h shouldn't you use it to 
> initialize the task structure in init_task.h.
> 2. the on_rq field in the task structure is unnecessary as many years of 
> experience with ingosched in plugsched indicates that 
> !list_empty(&(p)->run_list does the job provided list_del_init() is used 
> when dequeueing and there is no noticeable overhead incurred so there's 
> no gain by caching the result.  Also it removes the possibility of 
> errors creeping in due the value of on_rq being inconsistent with the 
> task's actual state.
> 3. having modular load balancing is a good idea but it should be 
> decoupled form the scheduler and provided as a separate interface.  This 
> would enable different schedulers to use the same load balancer if they 
> desired.
> 4. why rename SCHED_OTHER to SCHED_FAIR?  SCHED_OTHER's supposed to be 
> fair(ish) anyway.

One more quick comment.  The claim that there is no concept of time 
slice in the new scheduler is only true in the sense of the rather 
arcane implementation of time slices extant in the O(1) scheduler.  Your 
new parameter sched_granularity_ns is equivalent to the concept of time 
slice in most other kernels that I've peeked inside and computing 
literature in general (going back over several decades e.g. the magic 
garden).

Welcome to the mainstream,
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
