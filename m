Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYJQVaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYJQVaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYJQV3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:29:44 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12708 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754736AbYJQV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:29:43 -0400
Date: Sat, 18 Oct 2008 01:29:42 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081017212942.GA1919@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081016171259.GD5515@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810171324.42650.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:24:42PM -0700, David Brownell wrote:
> On Thursday 16 October 2008, Anton Vorontsov wrote:
> > +/*
> > + * Platforms can define their own __dev_ versions to glue gpio_chips with the
> > + * architecture-specific code.
> > + */
> > +#ifndef __dev_gpiochip_add
> > +#define __dev_gpiochip_add __dev_gpiochip_add
> > +static inline int __dev_gpiochip_add(struct device *dev,
> > +                                    struct gpio_chip *chip)
> > +{
> > +       chip->dev = dev;
> > +       return gpiochip_add(chip);
> > +}
> > +#endif /* __dev_gpiochip_add */
> 
> This is pretty ugly, especially the implication that *EVERY* gpio_chip
> provider needs modification to use these calls.

Anyway most of them need some modifications to work with OF...

> Surely it would be a lot simpler to just add platform-specific hooks
> to gpiochip_{add,remove}(), [...]

We have printk and dev_printk. kzalloc and devm_kzalloc (though I
aware that devm_ are different than just dev_).  So I thought that
dev_gpiochip_* would be logical order of things...

If you don't like it, I can readily implement hooks for
gpiochip_{add,remove}().


Thanks for the comments,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
