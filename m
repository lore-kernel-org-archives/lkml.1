Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZCFRDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZCFRDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZCFRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:02:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:59461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbZCFRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:02:42 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1236335049.6326.114.camel@laptop>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
	 <1236329922.7260.127.camel@pasglop>  <1236330733.6326.15.camel@laptop>
	 <1236333543.7260.138.camel@pasglop>  <1236335049.6326.114.camel@laptop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 18:02:24 +0100
Message-Id: <1236358944.6326.538.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 11:24 +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-06 at 20:59 +1100, Benjamin Herrenschmidt wrote:
> > > If you have distinct interrupt priorities, you can
> > > 
> > > 1) provide an interrupt stack for each priority
> > > 2) mask all lower priorities when handling one
> > > 
> > > Would that not work?
> > 
> > The PIC does that already. IE. it will only interrupt again before
> > ->eoi() for an interrupt of a higher priority. But by using
> > IRQF_DISABLED, you mask interrupts in the core, and thus effectively
> > completely prevents the whole thing.
> > 
> > > The problems with enabling irqs in hardirq handlers are that you get
> > > unlimited irq nesting, which is bad for your stack, furthermore, somehow
> > > people thing it makes things 'faster' because the irq-off latency goes
> > > down.
> > 
> > No, you don't get unlimited IRQ nesting, at least not on sane archs with
> > a decent PIC that does things like what I described above :-)
> 
> Right, welcome to x86 ;-)

Ok, people put me straight here. Since linux not support interrupt
priorities, wouldn't it simply be a matter of implementing
local_irq_en/dis-able() as masking the lowest level you use to run
normal interrupts on?

That will leave your other interrupt level available as NMI/debug
thingies.

