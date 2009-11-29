Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZK2K0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZK2K0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 05:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZK2K0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 05:26:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46700 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZK2K0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 05:26:54 -0500
Date: Sun, 29 Nov 2009 11:26:35 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED
	registered with setup_irq
Message-ID: <20091129102635.GA22653@pengutronix.de>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain> <20091129023118.GA21529@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091129023118.GA21529@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Nov 29, 2009 at 02:31:18AM +0000, Jamie Lokier wrote:
> Thomas Gleixner wrote:
> > What about analysing the code and verifying that the setup order is
> > correct ?
> > 
> > Adding save/restore_irq just because you have no clue what the code
> > does is utter nonsense.
> 
> Wouldn't it be quite a lot nicer if generic setup moved the
> IRQF_DISABLED handler to be first in the list, if that actually works
> in a useful way rather than simply being a quirk that irqs are
> disabled for the first one?
Hmm, what happens if an ISR runs with irqs disabled even though it
doesn't expect it?  I wouldn't bet that nothing breaks.

IMHO the best is if a warning is printed or registering fails if shared
irq actions don't agree about wanting IRQF_DISABLED.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
