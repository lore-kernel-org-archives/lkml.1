Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZK3Q3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZK3Q3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZK3Q32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:29:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50283 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZK3Q31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:29:27 -0500
Date: Mon, 30 Nov 2009 17:29:17 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Ogness <john.ogness@linutronix.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] MXC: set GPIO IRQ handler
Message-ID: <20091130162917.GA22072@pengutronix.de>
References: <807htelb5d.fsf@merkur.tec.linutronix.de> <20091126075724.GA12179@pengutronix.de> <alpine.LFD.2.00.0911280005010.24119@localhost.localdomain> <20091129202721.GA22137@pengutronix.de> <alpine.LFD.2.00.0911300948140.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0911300948140.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Mon, Nov 30, 2009 at 10:32:50AM +0100, Thomas Gleixner wrote:
> On Sun, 29 Nov 2009, Uwe Kleine-König wrote:
> > > > Can you please test with 060d20d if your breakage still occurs and
> > > > if it is still valid report some details (for me and the commit log)?
> > > 
> > > Could you please provide useful details, i.e. a short explanation why
> > > that commit is the superior fix, instead of forcing people to clone a
> > > git tree to figure out what you are (not) talking about ?
> > As I misread John's commit log I thought that he already has looked at
> > the imx tree.  (Which seems natural when working with that platform.)
> > I just noticed that the tree isn't listed in MAINTAINERS, I will send a
> > patch for that.
> > 
> > Having the commit log of 060d20d I don't consider it too hard to work
> > out why my commit should fix John's problem, too.
> 
> Do you actually read, what people write ?
> 
> 1) I asked you to add that information into your reply and not request
>    people to clone a git tree to figure out what you are talking about
After you having quoted my commit log, I didn't feel that repeating it
adds much to the discussion.
 
> 2) I said your changelog is crap. And again:
> 
> > >     imx/gpio: Use handle_level_irq
> > >     
> > >     According to Russell King handle_edge_irq is only useful for "edge-based
> > >     inputs where the controller does not remember transitions with the input
> > >     masked."
> > >
> > >     So using handle_edge_irq unconditionally for both edge and level irqs is
> > >     wrong. 
> 
> It's not wrong because Russell explained when to use handle_edge_irq.
> 
> It's fundamentally wrong to use handle_edge_irq for level type
> interrupts. And that's the bug in the current code.
For my (admittedly German) feeling for the English language the
grammatical construct in the first and second paragraph (after the
subject) is OK.  Pointing out that using handle_edge_irq for level
triggered interrupts which have bottom-halves simply doesn't work would
have been nice, that's right.

I suggest you compose a better commit log and work out with Sascha if
and when he takes the improved commit.

> The natural adhoc fix for this is what John posted with an
> understandable explanation.
> 
> Now the better solution is to use handle_level_irq for both types
> because the interrupt controller is well designed.
Ack.  This is at least the second time you point that out.  I wonder
what exactly makes you think I don't agree.
 
> > > That does not make John's patch incorrect. Using handle_level_irq for
> > > both is merily an optimization which would be even more understandable
> > > if there would be an useful comment in the code.
> > I didn't say that John's patch is wrong.  And instead of documenting
> > that handle_level_irq (which is named a bit misleading) is capable of
> > handling edge irqs on imx, too, what about creating a handler with a
> > better name (say handle_generic_irq?---open for better suggestions) and
> > making handle_level_irq a deprecated wrapper for it?
> 
> Come on, such a name change is pretty useless as it does not explain
> why you can use it for both edge and level on imx. 
It was only a suggestion.  I was sure you will say it if you don't
consider it a good idea :-)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
