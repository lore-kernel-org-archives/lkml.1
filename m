Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbXKNGqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbXKNGqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbXKNGqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:46:30 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:45863 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbXKNGq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pKMxWS6IzEZ1NKtcxdMLQKsGe5nDjsNDJz4zZTeG7ltrg7xhfqHzCX7qPv/8PDGFFZOjqr/6kKeofxNO6YDdBdw7QPcmdScWsQ5SFbK4JmTx+2LJRQn6XcBo7zXIp64k9x9Q3FrVxJWV5pf3WX5sOFsKHgMYNmuBNaY2s1R5ozw=
Message-ID: <f17812d70711132246i5e29600cqe96a2f51051a6f8f@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:46:27 +0800
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
In-Reply-To: <200711132018.22995.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com>
	 <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
	 <200711132018.22995.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 12:18 PM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 13 November 2007, eric miao wrote:
> > Here comes the point of "struct gpio_desc"
> >
> > Subject: [PATCH 3/5] use a per GPIO "struct gpio_desc" and chain
> > "gpio_chip" to a list
>
> I see what it does, but don't see the "why" ... surely
> you can come up with a one sentence description of why
> this would be better?
>
> And I'd been so glad to *get rid of* that list, too.

I'll be happy too.

>
>
> > +struct gpio_desc {
> > +     struct gpio_chip *chip;
> > +};
> > +
>
> > -/* gpio_lock protects modification to the table of chips and to
> > - * gpio_chip->requested.  If a gpio is requested, its gpio_chip
> > - * is not removable.
> > - */
>
> But it still protects data.  Don't remove documentation for
> what locks protect ... update it!  Otherwise someonels going
> to come by and make a change which breaks the locking model.
> Usually in some subtle (hard-to-debug) way.

I'd prefer to name it "gpio_desc_lock" instead, which is self-explanatory
and thus requires no comment at all

>
> >
> > -     for (id = 0; id < ARRAY_SIZE(chips); id++) {
> > -             chip = chips[id];
> > -             if (!chip)
> > -                     continue;
> > -
> > +     list_for_each_entry(chip, &gpio_chip_list, node) {
> >               seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
> >                               started ? "\n" : "",
> >                               chip->base, chip->base + chip->ngpio - 1,
>
> Note that this now produces the debug info in a relatively
> random order ... ordered by registration rather than anything
> useful, and hence awkward to read.
>
> It'd be better if you just scanned your new gpio_desc[]
> table in numeric order, and start a new section whenever
> you find a new gpio_chip.
>
> That'd get rid of that otherwise-useless list, too.
>

absolutely, you get the same feeling of mine and since this is for illustration
purpose only, I don't want more patches to fix this...

> - Dave
>



-- 
Cheers
- eric
