Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGJKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGJKfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGJKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:35:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48016 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbYGJKfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:35:45 -0400
Date: Thu, 10 Jul 2008 11:02:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710110225.0dd636cf@the-village.bc.nu>
In-Reply-To: <20080710103036.GA32507@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
	<20080710065639.GA16794@digi.com>
	<20080710094641.0c52eaa7@the-village.bc.nu>
	<20080710103036.GA32507@digi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 12:30:36 +0200
Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com> wrote:

> Alan Cox wrote:
> > 
> > > > +       else if (!irq_on && !priv->irq_disabled)
> > > > +               disable_irq(dev_info->irq);
> > > I'm not sure if this is a problem on SMP.  Should you use
> > > disable_irq_nosync here, too?  Probably it's OK.
> > 
> > That one will also deadlock.
> Can you explain why?  I think irqcontrol is only called in task context.
> I only see one possible deadlock and that's disable_irq being called
> while the irq is IRQ_INPROGRESS on the same cpu.  I'm always willing to
> learn.

	CPU0	 (UIO IRQ)		CPU1 (irqcontrol)
	take IRQ
					take spin lock
	spin on spinlock
					disable_irq (blocks)

> I think I didn't understand you right here, with the lock this can
> happen, too, doesn't it?

Actually yes - so it would simplify it without changing behaviour.

Alan
