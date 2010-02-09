Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0BITGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:06:42 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:52812 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751489Ab0BITGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:06:40 -0500
Date: Tue, 9 Feb 2010 22:06:38 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100209190638.GA16013@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203236.GC1475@oksana.dev.rtsoft.ru>
 <fa686aa41002090908tbeed469k417af2a59757f8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41002090908tbeed469k417af2a59757f8a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 10:08:00AM -0700, Grant Likely wrote:
> On Fri, Feb 5, 2010 at 1:32 PM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
> > GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
> > attached to the OpenFirmware subsystem. Which means that now we can handle
> > I2C and SPI GPIO chips almost* transparently.
[...]
> One concern.
> 
> How does an OF-aware GPIO driver override these settings?  What is to
> be done when a GPIO chip requires a different xlate hook?  Or a
> different number of gpio_cells?

A lot of options...

1. They can hook up onto a notifier chain, ensure that their callback
   will be called after OF GPIO subsystem (using notifiers' priority
   mechanism), and fixup needed stuff.

2. They can write their own full fledged OF bindings, i.e. they will
   need to allocate of_gc struct and save it into np->data.
   of_gpiochip_register_simple() won't touch np->data if it's already
   used.

   If/when needed, we can write some helper function, i.e.
   of_gpiochip_register(gpiochip, node, xlate_callback).

3. Or of/gpio.c code will handle this by itself, iff the xlate and
   gpio-cells scheme seems generic enough.

4. May be more...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
