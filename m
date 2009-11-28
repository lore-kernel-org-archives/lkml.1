Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZK1VvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZK1VvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 16:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZK1VvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 16:51:01 -0500
Received: from www.tglx.de ([62.245.132.106]:46800 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZK1VvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 16:51:00 -0500
Date: Sat, 28 Nov 2009 22:50:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered
 with setup_irq
In-Reply-To: <20091128200344.GA1272@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2044321886-1259445005=:24119"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2044321886-1259445005=:24119
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 28 Nov 2009, Uwe Kleine-König wrote:

> On Fri, Nov 27, 2009 at 11:18:00PM +0100, Thomas Gleixner wrote:
> > On Fri, 27 Nov 2009, Uwe Kleine-König wrote:
> > 
> > > IRQF_DISABLED is not guaranteed on shared irqs.  There is already a
> > > warning in place for irqs registered with request_irq (introduced in
> > > 470c66239ef03).  Move it to __setup_irq, this way it triggers for both
> > > request_irq and setup_irq.
> > > 
> > > One irq that is now warned about is the timer tick on at91 (ARCH=arm).
> > 
> > And how does that help ? The interrupt is shared between the timer and
> > the debug port. There is nothing you can do about that.
> > 
> > The interupt handlers are called in order of setup. The AT91 timer
> > irq is set up first and if that's not the case then it needs to be
> > fixed and the only way to catch it is in the affected interrupt
> > handler.
>
> Russell already suggests to save (and restore) irqs in the handler
> before (and after resp.) calling the clockevent functions.

What about analysing the code and verifying that the setup order is
correct ?

Adding save/restore_irq just because you have no clue what the code
does is utter nonsense.

Thanks,

	tglx
--8323328-2044321886-1259445005=:24119--
