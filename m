Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884Ab0AAVLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0AAVLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482Ab0AAVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:11:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:43554 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0AAVLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:11:46 -0500
Subject: Re: [PATCH] HVSI: Fix apparently backwards args to time_before()
 in hvsi.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>, linuxppc-dev@ozlabs.org
In-Reply-To: <201001011915.47849.bzolnier@gmail.com>
References: <alpine.LFD.2.00.1001011226020.24958@localhost>
	 <201001011915.47849.bzolnier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 08:11:19 +1100
Message-ID: <1262380279.2173.240.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 19:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> On Friday 01 January 2010 06:28:03 pm Robert P. J. Day wrote:
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > 
> > ---
> > 
> >   no appropriate subsystem maintainer listed in MAINTAINERS.
> 
> drivers/char/Makefile:
> obj-$(CONFIG_HVC_CONSOLE)       += hvc_vio.o hvsi.o
> 
> so it should belong to:
> 
> HYPERVISOR VIRTUAL CONSOLE DRIVER
> L:      linuxppc-dev@ozlabs.org
> S:      Odd Fixes
> F:      drivers/char/hvc_*
> 
> [ Though maybe Ben would be willing to pick this one up directly
>   as hvsi is PPC specific thingy and patch is obviously correct. ]

Sure, I'll pick that one up.

Cheers,
Ben.

> > diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
> > index 793b236..71c0fcd 100644
> > --- a/drivers/char/hvsi.c
> > +++ b/drivers/char/hvsi.c
> > @@ -711,7 +711,7 @@ static void hvsi_drain_input(struct hvsi_struct *hp)
> >  	uint8_t buf[HVSI_MAX_READ] __ALIGNED__;
> >  	unsigned long end_jiffies = jiffies + HVSI_TIMEOUT;
> > 
> > -	while (time_before(end_jiffies, jiffies))
> > +	while (time_before(jiffies, end_jiffies))
> >  		if (0 == hvsi_read(hp, buf, HVSI_MAX_READ))
> >  			break;
> >  }
> 
> --
> Bartlomiej Zolnierkiewicz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


