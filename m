Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXDPJZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXDPJZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXDPJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:25:10 -0400
Received: from qsrv01sl.mx.bigpond.com ([144.140.92.181]:16975 "EHLO
	qsrv01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250AbXDPJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:25:08 -0400
X-Greylist: delayed 6167 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 05:25:07 EDT
Message-ID: <462339C0.3070603@bigpond.net.au>
Date: Mon, 16 Apr 2007 18:54:24 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415153933.GB6623@elte.hu> <46230950.8000005@bigpond.net.au> <4623166A.3080500@bigpond.net.au> <46231A77.8030600@bigpond.net.au> <20070416073258.GB17444@elte.hu>
In-Reply-To: <20070416073258.GB17444@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 08:54:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>> One more quick comment.  The claim that there is no concept of time 
>> slice in the new scheduler is only true in the sense of the rather 
>> arcane implementation of time slices extant in the O(1) scheduler.
> 
> yeah. AFAIK most other mainstream OSs also still often use similarly 
> 'arcane' concepts (i'm here ignoring literature, you can find everything 
> and its opposite suggested in literature) so i felt the need to point 
> out the difference ;) After all Linux is about doing a better mainstream 
> OS, it is not about beating the OS literature at lunacy ;-)
> 
> The precise statement would be: "there's no concept of giving out a 
> time-slice to a task and sticking to it unless a higher-prio task comes 
> along,

I would have said "no concept of using tile slices to implement nice" 
which always seemed strange to me.

If it really does what you just said then a (malicious or otherwise) CPU 
intensive task that never sleeps, once it got the CPU, would completely 
hog the CPU.

> nor is there a concept of having a low-res granularity 
> ->time_slice thing. There is accurate accounting of how much CPU time a 
> task used up, and there is a granularity setting that together gives the 
> current task a fairness advantage of a given amount of nanoseconds - 
> which has similar [but not equivalent] effects to traditional timeslices 
> that most mainstream OSs use".

Most traditional OSes have more or less fixed time slices and do the 
scheduling by fiddling the dynamic priority.

Using total CPU used will also come to grief when used for long running 
tasks.  Eventually, even very low bandwidth tasks will accumulate enough 
total CPU to look busy.  The CPU bandwidth the task is using is what 
needs to be controlled.

Or have I not looked closely enough at what sched_granularity_ns does? 
Is it really a control for the decay rate of a CPU usage bandwidth metric?

> 
>> Your new parameter sched_granularity_ns is equivalent to the concept 
>> of time slice in most other kernels that I've peeked inside and 
>> computing literature in general (going back over several decades e.g. 
>> the magic garden).
> 
> note that you can set it to 0 and the box still functions - so 
> sched_granularity_ns, while useful for performance/bandwidth workloads, 
> isnt truly inherent to the design.

Just like my SPA schedulers.  But if you set it to zero you'll get a 
fairly high context switch rate with associated overhead, won't you?

> 
> So in the announcement i just opted for a short sentence: "there's no 
> concept of timeslices", albeit like most short stentences it's not a 
> technically 100% accurate statement - but still it conveyed the intended 
> information more effectively to the interested lkml reader than the 
> longer version could ever have =B-)

I hope that I implied that I was being picky :-) (I meant to -- imply I 
was being picky, that is).

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
