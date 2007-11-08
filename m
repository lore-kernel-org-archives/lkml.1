Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbXKHGGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbXKHGGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXKHGGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:06:35 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:22002 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXKHGGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:06:34 -0500
Date: Thu, 8 Nov 2007 08:06:31 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <12o3l@tiscali.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix incorrect test in trident_ac97_set(); sound/oss/trident.c
Message-ID: <20071108060631.GD30021@rhun.ibm.com>
References: <47320533.4020400@tiscali.nl> <2c0942db0711071043p7cd31f6di9031816c1fed81ca@mail.gmail.com> <473208ED.9000707@tiscali.nl> <2c0942db0711071104x4360c38s930f6f9d494d4bb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0711071104x4360c38s930f6f9d494d4bb6@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:04:41AM -0800, Ray Lee wrote:

> On Nov 7, 2007 10:50 AM, Roel Kluin <12o3l@tiscali.nl> wrote:

> > If count reaches zero, the loop ends, but the postfix decrement
> > still subtracts: testing for 'count == 0' will not work.
> >
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > ---
> > diff --git a/sound/oss/trident.c b/sound/oss/trident.c
> > index 96adc47..6959ee1 100644
> > --- a/sound/oss/trident.c
> > +++ b/sound/oss/trident.c
> > @@ -2935,7 +2935,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
> >         do {
> >                 if ((inw(TRID_REG(card, address)) & busy) == 0)
> >                         break;
> > -       } while (count--);
> > +       } while (--count);
> >
> >         data |= (mask | (reg & AC97_REG_ADDR));
> >
> > @@ -2996,7 +2996,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
> >                 data = inl(TRID_REG(card, address));
> >                 if ((data & busy) == 0)
> >                         break;
> > -       } while (count--);
> > +       } while (--count);
> >
> >         spin_unlock_irqrestore(&card->lock, flags);
> >
> >         if (count == 0) {
> >
> 
> Thanks, much better. In the future, please also CC: the appropriate
> maintainers, or Andrew Morton if you're at a loss...

Indeed.

> Reviewed-by: Ray Lee <ray-lk@madrabbit.org>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Andrew, can you please push to Linus?

Thanks,
Muli
