Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbYKNBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbYKNBNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKNBNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:13:41 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:49093 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353AbYKNBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:13:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HO2PW1aTxdJDKhSFJBhjacN8Y+22WYlJh1WNkaYaYNDvVLPlxSPqsaOUjSsOgMraL2OQVcRs/o2etKhiLUCr6i3JXRHyUyyizjmv+s4MQY74A1udAR+1q/u8VHQC3djb6t7ZPU0zrNheOv8jZkp7Ns6TP3NU4al38TjSNVkxHG0=  ;
X-YMail-OSG: 7En5Cr4VM1lRidVmH1I0MAGBV_1QM0R_vQJyGFfNxL.8jOgMDmPZAlO_iVKl1OqNIyyqpGxH10FvMowHIU0usU4JDoWx0Dcd_mTdQMRplRnpZd8pZj4MRFeyytK4ieLh0GH_lqvYrVpM2MX1QInWhM8ishVZJXcPlWjBegSOwX4BpcR6HoRiuww8AVNRT1.1_0biYr90h7YUVXWhHs6Re1yFLs7lDl2OZr8fkdvN2w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.28-rc4] gpiolib: extend gpio label column width in debugfs file
Date: Thu, 13 Nov 2008 17:13:38 -0800
User-Agent: KMail/1.9.10
Cc: Jarkko Nikula <jarkko.nikula@nokia.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <1226472973-16271-1-git-send-email-jarkko.nikula@nokia.com> <20081113170211.23bf0343.akpm@linux-foundation.org>
In-Reply-To: <20081113170211.23bf0343.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131713.38340.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008, Andrew Morton wrote:
> On Wed, 12 Nov 2008 08:56:13 +0200
> Jarkko Nikula <jarkko.nikula@nokia.com> wrote:
> 
> > There are already various drivers having bigger label than 12 bytes. Most
> > of them fit well under 20 bytes but make column width exact so that
> > oversized labels don't mess up output alignment.
> 
> Please provide before-and-after example output for this sort of change
> so that we can better understand its effect.
> 
> > Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>

I meant to send:

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... thanks Jarkko.


> > ---
> >  drivers/gpio/gpiolib.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index faa1cc6..82020ab 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1134,7 +1134,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> >  			continue;
> >  
> >  		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
> > -		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
> > +		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
> >  			gpio, gdesc->label,
> >  			is_out ? "out" : "in ",
> >  			chip->get
> 
> This is a non-backward-compatible change to a userspace interface.  It
> looks like a pretty safe one, but this is always a fairly big deal.

Not really; this is for debugfs, and formats for debug data
are not ABI-suitable.  Developers need the flexibility to
change that stuff ... for example, they can *already* override
the default format to show pullups/pulldowns, drive strength,
polarity inversion, debouncing, and other hardware-specific goodies.
 

> If we're going to make this change then we should backport it to
> 2.6.27.x, 2.6.26.x and to 2.6.25.x to minimise the chance that someone
> will write a parser which works on one kernel version and fails on
> another.
> 
> David?  Thoughts?

This is explicitly not supported for ABI-ish purposes.

If they aren't even using those parenthesis to delimit things, I'd
really need to question what happened to their grey cells!

- Dave




