Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbYB2VtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbYB2VtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbYB2VtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:49:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760300AbYB2VtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:49:13 -0500
Date: Fri, 29 Feb 2008 13:33:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Pearson <devnull.port@googlemail.com>
Cc: sziwan@hell.org.pl, julia@diku.dk, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       lenb@kernel.org
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Message-Id: <20080229133320.1ec95e84.akpm@linux-foundation.org>
In-Reply-To: <47C849B8.1000902@googlemail.com>
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
	<7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
	<47C5ABFB.3050607@googlemail.com>
	<20080228215503.b942bb3c.akpm@linux-foundation.org>
	<47C849B8.1000902@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 19:06:48 +0100
Mark Pearson <devnull.port@googlemail.com> wrote:

> Andrew Morton wrote:
> >> Seems an odd way of doing:
> >>
> >> 	led_out ^= 0x01;
> > 
> > It does.
> > 
> >> It this due to some optimisation?
> > 
> > Surely not ;)
> >
> ;) Thought so - one doesn't like to be too presumptuous ;)
> 
> > That code has been there for many years.
> > 
> > I changed the patch to this:
> > 
> > --- a/drivers/acpi/asus_acpi.c~drivers-acpi-asus_acpic-correct-use-of-and
> > +++ a/drivers/acpi/asus_acpi.c
> > @@ -610,7 +610,7 @@ write_led(const char __user * buffer, un
> >  	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
> >  
> >  	if (invert)		/* invert target value */
> > -		led_out = !led_out & 0x1;
> > +		led_out = !led_out;
> >  
> >  	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
> >  		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
> > _
> > 
> > 
> 
> Is the ! operator architecture/compiler dependent?

It shouldn't be.

> or can one always say that
> !NON_ZERO_VALUE == 0 and !0 == 1?
> 

I always have ;)  I expect it's in the C standard somewhere.
