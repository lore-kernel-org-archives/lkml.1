Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXKNHgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXKNHgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXKNHgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:36:42 -0500
Received: from ro-out-1112.google.com ([72.14.202.176]:26633 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXKNHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aPQzjJ4eI6aw2gdkh8Qiffze4jVneHjPuXW3Xgr5S2PdpGPECuonO8TuqXm6n1vozc3RDdMFQCfzqKvyI5jCg6ljh1steYILbsvEt8zhvZmlmwAKGJ7ljR1KCsJgX334O6zsi8+e85G5R5U4ooBUB2I76WP4AHeutuPZia144Qs=
Message-ID: <f17812d70711132336x11190c67xd8cf20efbe914809@mail.gmail.com>
Date: Wed, 14 Nov 2007 15:36:39 +0800
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
In-Reply-To: <200711132319.48821.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711132036.14927.david-b@pacbell.net>
	 <f17812d70711132251l7d37042es999c079378992f3b@mail.gmail.com>
	 <200711132319.48821.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Y, the IRQ <--> GPIO mapping is another thing I'm concerned about. Other than
that, all the other part of the gpiolib is a great work, actually,
I've been waiting
for this for quite a long time and just don't have time for a hands-on until
recently.

So let's get more feedback on this.

On Nov 14, 2007 3:19 PM, David Brownell <david-b@pacbell.net> wrote:
>
> > > >  struct gpio_desc {
> > > >       struct gpio_chip *chip;
> > > >       unsigned is_out:1;
> > > > +     unsigned requested:1;
> > > > +#ifdef CONFIG_DEBUG_FS
> > > > +     const char *requested_str;
> > > > +#endif
> > >
> > > Note that this means (on typical 32-bit embedded hardware)
> > > twelve bytes per GPIO, which if you assume 256 GPIOs means
> > > an extra 3 KB static memory compared to the patch I sent.
>
> Actually, 2K is a more accurate number -- ignore DEBUG_FS.
>
>
> > Note this reduces the memory in gpio_chip, so it consumes almost same
> > memory as the patch you sent.
>
> No; the amount of space shaved from a typical (32-bit banks)
> gpio_chip is *exactly* the cost of one gpio_desc:  two words.
> In one case, two bitmaps.  In the other, a pointer, two bits,
> and internal struct padding.
>
> So unless each bank has only a single GPIO, this approach
> does cost more memory.  Both for the extra memory associated
> with each gpio_chip that's used, and for unused gpio_desc.
>
> That's not necessarily a bad thing, though it's always worth
> avoiding bloat.
>

Well, absolutely agree on this.

> - Dave
>



-- 
Cheers
- eric
