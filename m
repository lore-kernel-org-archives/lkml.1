Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXDPHd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXDPHd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXDPHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:33:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52119 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXDPHd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:33:26 -0400
Date: Mon, 16 Apr 2007 09:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416073258.GB17444@elte.hu>
References: <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415153933.GB6623@elte.hu> <46230950.8000005@bigpond.net.au> <4623166A.3080500@bigpond.net.au> <46231A77.8030600@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46231A77.8030600@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> One more quick comment.  The claim that there is no concept of time 
> slice in the new scheduler is only true in the sense of the rather 
> arcane implementation of time slices extant in the O(1) scheduler.

yeah. AFAIK most other mainstream OSs also still often use similarly 
'arcane' concepts (i'm here ignoring literature, you can find everything 
and its opposite suggested in literature) so i felt the need to point 
out the difference ;) After all Linux is about doing a better mainstream 
OS, it is not about beating the OS literature at lunacy ;-)

The precise statement would be: "there's no concept of giving out a 
time-slice to a task and sticking to it unless a higher-prio task comes 
along, nor is there a concept of having a low-res granularity 
->time_slice thing. There is accurate accounting of how much CPU time a 
task used up, and there is a granularity setting that together gives the 
current task a fairness advantage of a given amount of nanoseconds - 
which has similar [but not equivalent] effects to traditional timeslices 
that most mainstream OSs use".

> Your new parameter sched_granularity_ns is equivalent to the concept 
> of time slice in most other kernels that I've peeked inside and 
> computing literature in general (going back over several decades e.g. 
> the magic garden).

note that you can set it to 0 and the box still functions - so 
sched_granularity_ns, while useful for performance/bandwidth workloads, 
isnt truly inherent to the design.

So in the announcement i just opted for a short sentence: "there's no 
concept of timeslices", albeit like most short stentences it's not a 
technically 100% accurate statement - but still it conveyed the intended 
information more effectively to the interested lkml reader than the 
longer version could ever have =B-)

	Ingo
