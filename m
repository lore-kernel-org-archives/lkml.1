Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbXKNHUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbXKNHUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXKNHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:19:52 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:35992 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750998AbXKNHTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:19:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=odXBF9Yu9fH+0Gzc2fwELg9DoD3iZy8D2zKRxUotG0HVvQEb+LWlhWfmWX9tBMCpXPjgYyVNvtNwEBvOFIdGr1lC56DxuubUdvpGRnpFNsgk0Hf2/iX6SUIN1eyIPi5gSFWn/x1RNJAjbdPIJe28VEM8vRXAUGbwYch/iY8cPec=  ;
X-YMail-OSG: fI.1DWYVM1mTEovTisz0DqsnfsfeKFI6uoCPWyW4szr8rfhQuvCHtlLoyXLGNtdEYxL6ttv8eQ--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 23:19:47 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711132036.14927.david-b@pacbell.net> <f17812d70711132251l7d37042es999c079378992f3b@mail.gmail.com>
In-Reply-To: <f17812d70711132251l7d37042es999c079378992f3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132319.48821.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  struct gpio_desc {
> > >       struct gpio_chip *chip;
> > >       unsigned is_out:1;
> > > +     unsigned requested:1;
> > > +#ifdef CONFIG_DEBUG_FS
> > > +     const char *requested_str;
> > > +#endif
> >
> > Note that this means (on typical 32-bit embedded hardware)
> > twelve bytes per GPIO, which if you assume 256 GPIOs means
> > an extra 3 KB static memory compared to the patch I sent.

Actually, 2K is a more accurate number -- ignore DEBUG_FS.


> Note this reduces the memory in gpio_chip, so it consumes almost same
> memory as the patch you sent.

No; the amount of space shaved from a typical (32-bit banks)
gpio_chip is *exactly* the cost of one gpio_desc:  two words.
In one case, two bitmaps.  In the other, a pointer, two bits,
and internal struct padding.

So unless each bank has only a single GPIO, this approach
does cost more memory.  Both for the extra memory associated
with each gpio_chip that's used, and for unused gpio_desc.
 
That's not necessarily a bad thing, though it's always worth
avoiding bloat.

- Dave
