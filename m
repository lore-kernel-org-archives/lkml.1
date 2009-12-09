Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZLIJfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZLIJfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZLIJfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:35:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZLIJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:35:13 -0500
Date: Wed, 9 Dec 2009 10:35:18 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] irq: handle irq0 special only on x86
Message-ID: <20091209093518.GC23236@pengutronix.de>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 09, 2009 at 05:28:09PM +0800, Américo Wang wrote:
> 2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > I just noticed this when digging in the irq handling.  At least for arm
> > this doesn't make sense.  Not sure if x86 is the only arch this test
> > is valid for, but probably it is.
> 
> No, it is not.
> 
> Try grep -Inr 'irq0' arch/*/kernel.
Some hits are unrelated, some others are usage of an irq0.  AFAIK irq0
is reported on x86 for misrouted irqs[1].  I think on other archs it's just
an ordinary irq.  If you still think I missed something in the output of
your grep, please be a bit more specific.

Thanks
Uwe

[1] I don't really know x86, so this might be complete non-sense.

> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > ---
> >  kernel/irq/spurious.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> > index 22b0a6e..4996b66 100644
> > --- a/kernel/irq/spurious.c
> > +++ b/kernel/irq/spurious.c
> > @@ -199,8 +199,10 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
> >        if (irqfixup < 2)
> >                return 0;
> >
> > +#if defined(CONFIG_ARCH_X86)
> >        if (!irq)
> >                return 1;
> > +#endif
> >
> >        /*
> >         * Since we don't get the descriptor lock, "action" can
> 

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
