Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYLDKdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYLDKdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYLDKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:33:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYLDKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:33:39 -0500
Date: Thu, 4 Dec 2008 11:33:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, oliver@hartkopp.net
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
Message-ID: <20081204103316.GB19494@elte.hu>
References: <1227613431.4259.1537.camel@twins> <1228385830.5092.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228385830.5092.43.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
> > Hi,
> > 
> > This is an attempt at removing some of the hrtimer complexity by
> > reducing the number of callback modes to 1.
> > 
> > This means that all hrtimer callback functions will be ran from HARD-irq
> > context.
> > 
> > I went through all the 30 odd hrtimer callback functions in the kernel
> > and saw only one that I'm not quite sure of, which is the one in
> > net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
> > 
> > Furthermore, the hrtimer core now calls callbacks directly with IRQs
> > disabled in case you try to enqueue an expired timer. If this timer is a
> > periodic timer (which should use hrtimer_forward() to advance its time)
> > then it might be possible to end up in an inf. recursive loop due to the
> > fact that hrtimer_forward() doesn't round up to the next timer
> > granularity, and therefore keeps on calling the callback - obviously
> > this needs a fix.
> > 
> > Aside from that, this seems to compile and actually boot on my dual core
> > test box - although I'm sure there are some bugs in, me not hitting any
> > makes me certain :-)
> > 
> > Not-Quite-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ingo, this addition fixes the hotplug issue on my machine

thanks, applied - i also reactivated the tip/timers/hrtimer topic branch 
- lets see how it goes now.

	Ingo
