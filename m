Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXJTEJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXJTEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXJTEJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:09:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:39111 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXJTEJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:09:21 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <1192853044.17235.32.camel@pasglop>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200402.43106.maximlevitsky@gmail.com>
	 <alpine.LFD.0.999.0710191924520.3794@woody.linux-foundation.org>
	 <1192853044.17235.32.camel@pasglop>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 14:09:10 +1000
Message-Id: <1192853350.17235.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >  - even when you ignore the interrupt (because the driver doesn't care, 
> >    it's suspending), you need to make sure the hardware gets shut up by 
> >    reading (or writing) the proper interrupt status register.
> >
> >    Otherwise, with a level interrupt, the interrupt will continue to be 
> >    held active ("screaming") and the CPU will get interrupted over and 
> >    over again, until the irq subsystem will just turn the irq off 
> >    entirely.
> 
> His suspend routine wrote to the IRQ mask (or equivalent) register in
> his code example, thus the HW should shut up eventually, thus that isn't
> strictly necessary, the IRQ in that case is just a "short
> interrupt" (noticed by the PIC and delivered but possibly not asserted
> anymore at this stage or about to go down).

In fact, he -must not- ack it. Because is the HW is really down (in D3),
got knows what accessing the ACK register will do. I can give you
ideas... from nothing on most x86 desktops to machine checks on most
powerpc machines, though I could imagine some cards bad enough to lock
your bus up if you try to access a register while they are in D3 (I've
seen some of those critters and it seems not all bridges timeout on
cards that just keep sending retries).

Cheers,
Ben.

