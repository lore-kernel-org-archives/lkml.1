Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXK1X1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXK1X1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXK1X1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:27:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:26083 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXK1X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:27:42 -0500
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling
	can/will stall forever
From: Daniel Walker <dwalker@mvista.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Remy Bohmer <linux@bohmer.net>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071128230331.GA31730@flint.arm.linux.org.uk>
References: <1196176294.13982.58.camel@localhost.localdomain>
	 <1196177122.23808.7.camel@imap.mvista.com>
	 <1196178834.23808.11.camel@imap.mvista.com>
	 <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
	 <20071128172509.GA30173@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com>
	 <20071128200550.GA3494@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
	 <1196282672.27964.32.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0711281608490.26365@gandalf.stny.rr.com>
	 <20071128230331.GA31730@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 15:19:14 -0800
Message-Id: <1196291955.27964.47.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 23:03 +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 28, 2007 at 04:13:07PM -0500, Steven Rostedt wrote:
> > 
> > 
> > On Wed, 28 Nov 2007, Daniel Walker wrote:
> > 
> > >
> > > Ignoring the ARM side of things for a sec, handle_simple_irq() will
> > > mask() the interrupt in the special case that an interrupt is already in
> > > the processes of being handled.. handle_simple_irq() also unmasks when
> > > it finishes handling an interrupt (something real time adds for some
> > > reason) ..
> > >
> > > In terms of threading the irq everything is the same except there is no
> > > unmask() call when the thread finishes ..
> > >
> > 
> > OK, to be honest, I never fully understood the concept of this
> > "simple_irq". I figured it was because of the ARM architecture.
> 
> If you read what I said compared with what Daniel said, you'll see that
> adding the mask/unmask is _pointless_ because for the case where the
> simple handler should be used, there is _no_ hardware masking available
> except via the parent interrupt signal.
> 
> So actually Daniel's argument misses the basic point - that using
> handle_simple_irq for non-simple IRQs is just WRONG.

Well we've got at least two ARM boards which need the additional unmask
to work correctly with interrupt threading .. So there must be at least
two ARM boards using handle_simple_irq incorrectly .. It sounds like you
would prefer we send patches to move those handle_simple_irq users into
another method ?

Daniel

