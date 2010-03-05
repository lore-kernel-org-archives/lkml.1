Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0CEUa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:30:28 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37038 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750941Ab0CEUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:30:27 -0500
Date: Fri, 5 Mar 2010 23:30:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
Message-ID: <20100305203024.GA28132@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203232.GA1475@oksana.dev.rtsoft.ru>
 <fa686aa41002090916w613efcb9te15e4969a880f724@mail.gmail.com>
 <20100305115918.f6c75b12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100305115918.f6c75b12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 11:59:18AM -0800, Andrew Morton wrote:
[...]
> > > /**
> > > * gpiochip_add() - register a gpio_chip
> > > * @chip: the chip to register, with chip->base initialized
> > > @@ -1103,6 +1107,9 @@ fail:
> > >        pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
> > >            chip->base, chip->base + chip->ngpio - 1,
> > >            chip->label ? : "generic");
> > > +    else
> > > +        blocking_notifier_call_chain(&gpio_notifier,
> > > +                      GPIO_NOTIFY_CHIP_ADDED, chip);
> > 
> > Rather than doing an else block which will need to be reworked if/when
> > any additional code is added to the bottom of this routine, please
> > rework the if() block to bail on failure instead of implicitly falling
> > through to the return statement.
> 
> This still hasn't happened.

It's in your tree already :-)

gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
