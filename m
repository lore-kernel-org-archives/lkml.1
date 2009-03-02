Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZCBXHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZCBXHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZCBXHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:07:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCBXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:07:16 -0500
Subject: Re: lockdep and threaded IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, dbrownell@users.sourceforge.net,
       tglx@linutronix.de, me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <20090302145757.38a44307.akpm@linux-foundation.org>
References: <1236030106.5330.1553.camel@laptop>
	 <200903021409.21344.david-b@pacbell.net>
	 <1236032371.5330.1654.camel@laptop>
	 <20090302.144647.116847598.davem@davemloft.net>
	 <20090302145757.38a44307.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 00:07:01 +0100
Message-Id: <1236035221.5330.1798.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:57 -0800, Andrew Morton wrote:
> On Mon, 02 Mar 2009 14:46:47 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Mon, 02 Mar 2009 23:19:31 +0100
> > 
> > > I state that every !IRQF_DISABLED usage is a bug, either due to broken
> > > hardware or broken drivers.
> > 
> > We'll send you the bill to have everyone's hardware
> > replaced :-)
> 
> yes, but with what?
> 
> No matter how fast all our interrupt handlers are, running them with
> local interrupts disabled has to worsen the worst-case interrupt
> latency.
> 
> I don't see how removing !IRQF_DISABLED improves the kernel - in fact
> there's a latency argument for making !IRQF_DISABLED the default.

On preempt-rt all we do in the hardirq path is mask the interrupt line
and wake up a thread. That's the extreme end of low latency interrupts.

Arguably there is a middle way that works for !-rt.

However, striving to enable interrupts in all interrupt handlers is
asking for stack overruns. Interrupt nesting just isn't really helpful.

