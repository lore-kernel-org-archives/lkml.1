Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbZLJQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbZLJQ0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbZLJQ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:26:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbZLJQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:26:48 -0500
Date: Thu, 10 Dec 2009 17:26:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091210162645.GG19454@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208213727.GA4164@elf.ucw.cz>
 <4B1ECAC2.5090009@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1ECAC2.5090009@bluewatersys.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> +#define DREAM_INT_TO_BANK(n) ((n - DREAM_INT_START) / DREAM_INT_BANK0_COUNT)
> >>> +#define DREAM_INT_TO_MASK(n) (1U << ((n - DREAM_INT_START) & 7))
> >>> +#define DREAM_BANK_TO_MASK_REG(bank) \
> >>> +	(bank ? DREAM_GPIO_INT_MASK1_REG : DREAM_GPIO_INT_MASK0_REG)
> >>> +#define DREAM_BANK_TO_STAT_REG(bank) \
> >>> +	(bank ? DREAM_GPIO_INT_STAT1_REG : DREAM_GPIO_INT_STAT0_REG)
> >> Are these needed outside of the gpiolib code? If not, they should be
> >> moved there. I also think they should have lower case names since they
> >> act like a function, and make the code where they are used nicer to
> >> read.
> > 
> > I guess these logically belong here.
> > 
> > No, macros are macros, that means upcase.
> 
> container_of, min, swap, etc are macros too. It is easier to read this
> if they are lower case because they are typically used for initialising
> variables, ie:
> 
> 	int bank = dream_int_to_bank(irq);
> 
> Is easier (IMHO) to read than:
> 	
> 	int bank = DREAM_INT_TO_BANK(irq);

I disagree here. I could convert it to inline function, but I guess it
is okay as it is.

> >  static void __init dream_init(void)
> >  {
> > +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> > +        mdelay(300);
> > +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> > +        mdelay(300);
> > +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> > +	mdelay(300);
> > +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> > +	mdelay(300);
> > +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> > +        mdelay(300);
> > +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> > +        mdelay(300);
> > +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> > +        mdelay(300);
> > +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> > +        mdelay(300);
> > +
> 
> Indentation looks screwy here. Also, is this meant to blink the leds?
> There is a 2.4 second hard delay here, which is horrible.

Yep, that was my debugging code, not meant for upstream. And yes, its
blinking.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
