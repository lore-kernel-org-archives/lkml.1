Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbZHMLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbZHMLXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZHMLXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:23:20 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61303 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZHMLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:23:20 -0400
Date: Thu, 13 Aug 2009 13:23:16 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC][patch 10/12] move NTP adjusted clock multiplier to struct
 timekeeper
Message-ID: <20090813132316.04f91bb3@skybase>
In-Reply-To: <63386a3d0908130415x76993440ifd38e4bcb6a1d07e@mail.gmail.com>
References: <20090729134125.313191633@de.ibm.com>
	<20090729134231.515027738@de.ibm.com>
	<63386a3d0908130415x76993440ifd38e4bcb6a1d07e@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 13:15:06 +0200
Linus Walleij <linus.ml.walleij@gmail.com> wrote:

> 2009/7/29 Martin Schwidefsky <schwidefsky@de.ibm.com>:
> 
> > Index: linux-2.6/arch/arm/plat-omap/common.c
> > ===================================================================
> > --- linux-2.6.orig/arch/arm/plat-omap/common.c
> > +++ linux-2.6/arch/arm/plat-omap/common.c
> > @@ -256,7 +256,7 @@ unsigned long long sched_clock(void)
> >        unsigned long long ret;
> >
> >        ret = (unsigned long long)clocksource_32k.read(&clocksource_32k);
> > -       ret = (ret * clocksource_32k.mult_orig) >> clocksource_32k.shift;
> > +       ret = (ret * clocksource_32k.mult) >> clocksource_32k.shift;
> 
> Doesn't the overall effect of your patch mean that the above can simply be
> replaced by
> 
> ret = cyc2ns(&clocksource_32k, ret);
> 
> Or clocksource_cyc2ns() if that was renamed (I don't have the entire
> picture here...)
> 
> >        return ret;
> >  }

Yes, you can do that. More specifically it will be

  clocksource_cyc2ns(ret, clocksource_32k.mult, clocksource_32k.shift)

after all patches are applied.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

