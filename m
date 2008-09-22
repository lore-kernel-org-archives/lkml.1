Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYIVQTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYIVQTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYIVQTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:19:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYIVQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:19:04 -0400
Subject: Re: documentation about scheduling policies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200809221729.06870.ms@teamix.de>
References: <200809221729.06870.ms@teamix.de>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 18:18:55 +0200
Message-Id: <1222100335.16700.46.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 17:29 +0200, Martin Steigerwald wrote:
> Please CC to me as I am not subscribed to linux-kernel.
> 
> 
> Hi!
> 
> I wonder about scheduling policies in CFS. I find these:
> 
> ms@mango> grep "case SCHED_" sched.c sched_fair.c | sort | uniq 
> ~/lokal/Kernel/linux-2.6.26/kernel
> sched.c:        case SCHED_BATCH:
> sched.c:        case SCHED_FIFO:
> sched.c:        case SCHED_IDLE:
> sched.c:        case SCHED_NORMAL:
> sched.c:        case SCHED_RR:
> 
> sched_fair.c seems to differentiate SCHED_PATCH only:
> 
> ms@mango> egrep "(SCHED_I|SCHED_B)" sched_fair.c                       
> ~/lokal/Kernel/linux-2.6.26/kernel
>  * Completely Fair Scheduling (CFS) Class (SCHED_NORMAL/SCHED_BATCH)
>         if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) 
> {
>         if (unlikely(p->policy == SCHED_BATCH))
> 
> 
> The documentation on scheduling policies in Documentation/scheduler appears 
> rather scarse to me.

> I am willing to create documentation patches provided someone explains these 
> to me ;-).

SCHED_NORMAL (traditionally called SCHED_OTHER)
SCHED_BATCH
SCHED_IDLE

are all implemented in sched_fair.c which constitute a proportional fair
scheduler.

SCHED_BATCH differentiates itself by not preempting nearly as often as
regular tasks would, thereby allowing tasks to run longer and make
better use of caches but at the cost of interactivity.

SCHED_IDLE is basically an even weaker nice 19, its not a true idle time
scheduler because we can easily get into priority inversion problems
with that which would deadlock the machine.

SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
POSIX.

