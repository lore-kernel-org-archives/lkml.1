Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZBZXMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZBZXMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZBZXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:12:30 -0500
Received: from www.tglx.de ([62.245.132.106]:41680 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZBZXMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:12:30 -0500
Date: Fri, 27 Feb 2009 00:11:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       arjan@infradead.org, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 3/4] genirq: add a quick check handler
In-Reply-To: <20090226150340.976f4381.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0902270008410.9135@localhost.localdomain>
References: <20090226131336.423054348@linutronix.de> <20090226131719.640887792@linutronix.de> <20090226150340.976f4381.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Andrew Morton wrote:
> >  enum irqreturn {
> >  	IRQ_NONE,
> >  	IRQ_HANDLED,
> > +	IRQ_NEEDS_HANDLING,
> >  };
> 
> The enquiring mind is wondering which of these values the quickcheck
> handler can return.  IRQ_NEEDS_HANDLING or IRQ_NONE?  Or can it
> legitimately return IRQ_HANDLED?  If so, what would that semantically
> mean?

Yes it can return IRQ_HANDLED as well. That means no further action
(calling the slow path handler) is needed.
 
> I mean, an IRQ handler could easily have a super-fast-path and a slow
> path.  It could decide to do the super-fast operation in hard irq
> context and return IRQ_HANDLED, and return IRQ_NEEDS_HANDLING if
> slow-path handling is needed?
> 
> It's all a bit unclear and deserves documenting and thinking about.

Yep, I need to sit down and write up documentation.
 
> > + *      @quick_check_handler: Function called before the real interrupt
> > + *			handler. It checks if the interrupt originated
> > + *			from the device. This can be NULL.
> 
> So what semantics are implemented if this pointer is NULL?  We just
> assume IRQ_NEEDS_HANDLING?

Correct.

	tglx
