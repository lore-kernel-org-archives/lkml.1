Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZK3JdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZK3JdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZK3JdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:33:06 -0500
Received: from www.tglx.de ([62.245.132.106]:36819 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZK3JdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:33:05 -0500
Date: Mon, 30 Nov 2009 10:32:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: John Ogness <john.ogness@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] MXC: set GPIO IRQ handler
In-Reply-To: <20091129202721.GA22137@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0911300948140.24119@localhost.localdomain>
References: <807htelb5d.fsf@merkur.tec.linutronix.de> <20091126075724.GA12179@pengutronix.de> <alpine.LFD.2.00.0911280005010.24119@localhost.localdomain> <20091129202721.GA22137@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1670605057-1259573571=:24119"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1670605057-1259573571=:24119
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Uwe,

On Sun, 29 Nov 2009, Uwe Kleine-König wrote:
> > > Can you please test with 060d20d if your breakage still occurs and
> > > if it is still valid report some details (for me and the commit log)?
> > 
> > Could you please provide useful details, i.e. a short explanation why
> > that commit is the superior fix, instead of forcing people to clone a
> > git tree to figure out what you are (not) talking about ?
> As I misread John's commit log I thought that he already has looked at
> the imx tree.  (Which seems natural when working with that platform.)
> I just noticed that the tree isn't listed in MAINTAINERS, I will send a
> patch for that.
> 
> Having the commit log of 060d20d I don't consider it too hard to work
> out why my commit should fix John's problem, too.

Do you actually read, what people write ?

1) I asked you to add that information into your reply and not request
   people to clone a git tree to figure out what you are talking about

2) I said your changelog is crap. And again:

> >     imx/gpio: Use handle_level_irq
> >     
> >     According to Russell King handle_edge_irq is only useful for "edge-based
> >     inputs where the controller does not remember transitions with the input
> >     masked."
> >
> >     So using handle_edge_irq unconditionally for both edge and level irqs is
> >     wrong. 

It's not wrong because Russell explained when to use handle_edge_irq.

It's fundamentally wrong to use handle_edge_irq for level type
interrupts. And that's the bug in the current code.

The natural adhoc fix for this is what John posted with an
understandable explanation.

Now the better solution is to use handle_level_irq for both types
because the interrupt controller is well designed.

> > That does not make John's patch incorrect. Using handle_level_irq for
> > both is merily an optimization which would be even more understandable
> > if there would be an useful comment in the code.
> I didn't say that John's patch is wrong.  And instead of documenting
> that handle_level_irq (which is named a bit misleading) is capable of
> handling edge irqs on imx, too, what about creating a handler with a
> better name (say handle_generic_irq?---open for better suggestions) and
> making handle_level_irq a deprecated wrapper for it?

Come on, such a name change is pretty useless as it does not explain
why you can use it for both edge and level on imx. The reason why you
can do so is that the irq controller is not discarding edge
transitions when the interrupt is masked.

Thanks,

	tglx
--8323328-1670605057-1259573571=:24119--
