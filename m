Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYIGVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYIGVHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 17:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbYIGVHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 17:07:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:46093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYIGVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 17:07:46 -0400
Date: Sun, 7 Sep 2008 14:07:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: Re: update on hrtimer based select/poll and range-hrtimers
Message-ID: <20080907140746.3de99747@infradead.org>
In-Reply-To: <1220820399.8687.103.camel@twins.programming.kicks-ass.net>
References: <20080907111137.76a10b1e@infradead.org>
	<1220820399.8687.103.camel@twins.programming.kicks-ass.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Sep 2008 22:46:39 +0200
Peter Zijlstra <peterz@infradead.org> wrote:
> > "0.1% of the time" for not-nice, not realtime tasks
> > "0.5% of the time" for nice, not realtime tasks
> > with a cap of 100msec for both.
> > 
> > I would like to request feedback on this approach; I think this is
> > better than the "hardcoded steps" as before, but maybe someone can
> > come up with an ever better idea....
> 
> logarithms pop to mind (again :-)

and it still doesn't strike me as "oh yeah"

how would you see this work? Can you give a numeric example?

> 
> > static unsigned long __estimate_accuracy(struct timespec *tv)
> > {
> >         unsigned long slack;
> >         int divfactor = 1000;
> >   
> >         if (task_nice(current))
> 
> This triggers for both -nice and +nice tasks, it might be worth
> differentiating between those.

good spotting; will fix.


> > 
> >         if (current->policy == SCHED_FIFO ||
> >                 current->policy == SCHED_RR)
> >                 return 0;
> 
> rt_task(current) ?

hmm that's not exactly equivalent.. I can see either but still.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
