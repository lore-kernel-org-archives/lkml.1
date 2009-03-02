Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZCBSLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZCBSLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZCBSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:10:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:58186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZCBSKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:10:49 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20090302095553.8204d808.akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop>
	 <20090302095553.8204d808.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 19:10:28 +0100
Message-Id: <1236017428.5330.1021.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 09:55 -0800, Andrew Morton wrote:
> On Mon, 02 Mar 2009 13:21:17 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > 
> > People are playing odd games with IRQF_DISABLED, remove it.
> > 
> > Its not reliable, since shared interrupt lines could disable it for you,
> > and its possible and allowed for archs to disable IRQs to limit IRQ nesting.
> > 
> > Therefore, simply mandate that _ALL_ IRQ handlers are run with IRQs disabled.
> > 
> > [ This _should_ not break anything, since we've mandated that IRQ handlers
> >   _must_ be able to deal with this for a _long_ time ]
> > 
> > IRQ handlers should be fast, no if buts and any other exceptions. We also have
> > plenty instrumentation to find any offending IRQ latency sources.
> 
> Changelog is a bit cruddy.  What are these "odd games" and why are they
> so serious as to warrant a fairly drastic-looking patch?

See for example the stuff David Brownell was trying to pull off.

I was -- naively it turns out -- hoping it would be a simple matter of
cleaning up, as lockdep has been doing this for a long while now.

> Where are these odd games being played, and what are the implications
> to those codesites of having their ball taken away?  etc.

Generation of terrible IRQ latency, or in David's case, more pain for
the abuse of the genirq layer.

> wrt the patch itself - it would make life easier if we were to leave
> the IRQF_DISABLED definition in place for a while.  I'm counting 47 new
> additions of references to IRQF_DISABLED in linux-next/-mm.  It would
> grease the wheels a bit were these things (and out-of-tree drivers) to
> not instabreak.  One could add a nice runtime warning at request_irq()
> time, leave that in place until everything is fixed up.

Sure, can do.

