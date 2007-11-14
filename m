Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbXKNGvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbXKNGvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbXKNGvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:51:24 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:39895 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431AbXKNGvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:51:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oZ6Q8PAwuAVndVt6ec9PzWkQYp5mXZQNSkulsk5QnsKjl1oCK9uC1s4DyaZQeQJFF68gso9aOPT28GPIVIfJicbcY6GnSavzaYRDfVHsqr1OfeaZN9qXa6roCTn2yV41TgCjVYo0ZiCTGVvZOpD08/kd1d3oNF0cvQpL5xZdYWI=
Message-ID: <f17812d70711132251l7d37042es999c079378992f3b@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:51:22 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <200711132036.14927.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com>
	 <f17812d70711131704l6b0562ffmec6e7e1981130898@mail.gmail.com>
	 <200711132036.14927.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 12:36 PM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 13 November 2007, eric miao wrote:
> > Subject: [PATCH 5/5] move per GPIO "requested" to "struct gpio_desc"
> >
>
> >  struct gpio_desc {
> >       struct gpio_chip *chip;
> >       unsigned is_out:1;
> > +     unsigned requested:1;
> > +#ifdef CONFIG_DEBUG_FS
> > +     const char *requested_str;
> > +#endif
>
> A better name for this would be "label", matching what's
> passed from gpio_request().  Ndls abrviatns r bd.
>

Fine.

>
> Note that this means (on typical 32-bit embedded hardware)
> twelve bytes per GPIO, which if you assume 256 GPIOs means
> an extra 3 KB static memory compared to the patch I sent.
>

Note this reduces the memory in gpio_chip, so it consumes almost same
memory as the patch you sent.

>
> > @@ -43,20 +43,19 @@ static inline int gpio_is_onchip(unsigned gpio,
> > struct gpio_chip *chip)
> >  /* Warn when drivers omit gpio_request() calls -- legal but
> >   * ill-advised when setting direction, and otherwise illegal.
> >   */
> > -static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
> > +static void gpio_ensure_requested(unsigned gpio)
>
> Simpler to pass a gpio_desc pointer ...
>
>
> >       if (!requested)
> > -             printk(KERN_DEBUG "GPIO-%d autorequested\n",
> > -                             chip->base + offset);
> > +             pr_debug("GPIO-%d autorequested\n", gpio);
>
> Leave the printk in ... this is the sort of thing we want
> to see fixed, which becomes unlikely once you hide such
> diagnostics.  And for that matter, what would be enabling
> the "-DDEBUG" that would trigger a pr_debug() message?
>

line length issue, just ignore this if you prefer.

>
>
> ... overall the main downside of these patches seems to
> be that it consumes more static memory.
>

Not really, since it reduces the holes. That all depend on your
ARCH_NR_GPIOS.

-- 
Cheers
- eric
