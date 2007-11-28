Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXK1Jx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXK1Jx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXK1Jxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:53:42 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:33802 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759401AbXK1Jxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:53:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W7VaYRh8IlkFi0Cbl/pUcyIS12fPfh9OBL5kq54maQQOjwmSdZRR7rrOnqdcpyJ5pSaBHBvf9hTRSdKmm8bReogQfIZV8eXMGUP+z3eogFJ3k9oRkJZhynvXauKPLc0WnpNTNap3vtY70fWkwBu8SpvYHt0rhzH15JEmegMksVQ=  ;
X-YMail-OSG: HkamsYAVM1kh1YMch4ik9ybz3A4Hg5Y20YeZhKjhNr2Wrr_XW88605hy1qhEhIMWpeZkfzuejw--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 2.6.24-rc3-mm] gpiolib grows a gpio_desc
Date: Wed, 28 Nov 2007 01:53:38 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>, "Nicolas Pitre" <nico@cam.org>
References: <200710291809.29936.david-b@pacbell.net> <200711271915.26096.david-b@pacbell.net> <f17812d70711280110k4f0e08a4lf4f7f6c9a4aa63a7@mail.gmail.com>
In-Reply-To: <f17812d70711280110k4f0e08a4lf4f7f6c9a4aa63a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711280153.38964.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007, eric miao wrote:
> > +static void gpio_ensure_requested(struct gpio_desc *desc)
> >  {
> > -       int             requested;
> > -
> > +       if (!desc->requested) {
> > +               desc->requested = 1;
> > +               pr_warning("GPIO-%ld autorequested\n", gpio_desc - desc);
> 
> produces a warning here about %ld,

It uses "%ld" since I got a warning with "%d".  :(

Evidently a cast will be needed.


> and maybe you mean desc - gpio_desc??

Maybe.  Either that or the "GPIO-" should be "GPIO"!


> Except for the above, I feel OK overall.

