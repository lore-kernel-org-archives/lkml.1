Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYGBKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYGBKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763248AbYGBKJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:09:40 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:64566 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762650AbYGBKJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:09:39 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-6.tower-161.messagelabs.com!1214993377!10959371!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 2 Jul 2008 12:09:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080702100927.GB5342@digi.com>
References: <20080625131101.GA6205@digi.com> <20080702091757.GA1144@digi.com> <20080702024926.59488cc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080702024926.59488cc7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Jul 2008 10:09:31.0388 (UTC) FILETIME=[B84DF3C0:01C8DC2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Andrew Morton wrote:
> On Wed, 2 Jul 2008 11:17:57 +0200 Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com> wrote:
> 
> > Hello,
> >
> > [extending the Cc: list]
> >
> > Uwe Kleine-K__nig wrote:
> > > set_type returns an int but currently setup_irq ignores that.
> > >
> > > To save me from undoing some changes setting the IRQ_NO_BALANCING bit in
> > > desc->flags, setting IRQ_PER_CPU in desc->status and adding the new
> > > action to desc is only done after set_type succeeded.
> > >
> > > Signed-off-by: Uwe Kleine-K__nig <Uwe.Kleine-Koenig@digi.com>
> > > ---
> > > Hello,
> > >
> > > in my case set_type returns an error because gpio-key tries to use
> > > IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and my irq-chip can only do
> > > one of these.
> >
> > up to now I didn't get any response for this patch.  It addresses a real
> > problem for my platform so I really like to have a fix in.
> >
> > In mmotm of 2008-07-01-21-57 kernel/irq/manage.c is touched[1],
> > too, but git was able to automerge the change correctly when applying it
> > on top of mmotm.
> >
> > For your convenience you can find the patch again at the end of this
> > mail.
> >
> > Andrew:  Do you can take this patch into mm?
> >
> 
> >From a brief squint the patch seems to be reasonable.  But the
> changelog is a bit mangled.  Perhaps you could have another go when
> resending it.  Explan more clearly under what circumststances your
> ->set_type() implementation can fail and why you require the core code
> to handle this.
OK.

> Perhaps we want a dump_stack() on the error path so we can see who
> goofed.  Or a print_symbol() of desc->chip->set_type.  Or perhaps not.
I thought about a dump_stack() but considered it as too much.
print_symbol() is a nice idea though.
 
> Did you check that all the current ->set_type() implementations are
> returning zero?
No, I don't.  But for example orion5x_gpio_set_irq_type might return
-EINVAL.  txx9_irq_set_type seems to have the same limitation as ns9xxx
and returns -EINVAL if more than one trigger type is requested.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
