Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750Ab0ARRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0ARRuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725Ab0ARRuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:50:15 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60923 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0ARRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:50:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LRwP7RJozSXOVGZmspjAE4rxtxUgSMqq0HZUvE5YiNn2ZBYwiBI2we0z5ABurKL7m6
         b95ThNhuacsUzj883AUYqiq7bdE4tRcvuOLtAewhcE18+3Y4rz5EeiDKsOiFx4gm606B
         fhkSp7qHEmmedGGc2qbfBXJBGYpDA2rV+DIaM=
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100118172002.GB6889@rakim.wolfsonmicro.main>
References: <1263830523.3632.22.camel@realization>
	 <20100118163212.GA32045@rakim.wolfsonmicro.main>
	 <1263834473.3632.31.camel@realization>
	 <20100118172002.GB6889@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 18:50:04 +0100
Message-ID: <1263837004.3632.52.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-01-18 at 17:20 +0000, Mark Brown wrote:
> On Mon, Jan 18, 2010 at 06:07:53PM +0100, Alberto Panizzo wrote:
> 
> > Something like this?
> > 	if (mask & MC13783_REG_POWERMISC_PWGTSPI_M) {
> > 		u32 new_state = (val & MC13783_REG_POWERMISC_PWGTSPI_M) ^ mask;
> > 
> > 		mc13783_state_powermisc_pwgt =
> > 			(mc13783_state_powermisc_pwgt & ~mask) | new_state;
> > 	}
> 
> Yes, that's clearer.
> 
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	valread = (valread & ~mask) | val;
> > > > +
> > > > +	/* Re propose the stored state for Power Gates */
> > > > +	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> > > > +						mc13783_state_powermisc_pwgt;
> > > 
> > > ...and this further mainpulation.
> 
> > What is obscure in this? it is the same operation as the previous
> > MC13783_REG_POWERMISC_PWGTSPI_M is the mask for PWGT1 and 2 bits and in 
> > mc13783_state_powermisc_pwgt there is the stored state for those two bits.
> 
> Part of it is the fact that the first bit was almost completely opaque
> but even so it would be less surprising if you first worked out the
> value you wanted to set, then did whatever manipulation was required to
> translate into the format that actually gets written.

Maybe I not deep explained what's going on..
In POWERMISC register there are other controls bits than PWGTxEN that follow
the convention of 1= enable 0= disable and for those bits read and write value
are consistent: what is written could be read.

So, for all these bits the way to manipulate is the normal:
	valread = (valread & ~mask) | val;

where the mask can indicate the manipulation of not only one bit.
As "mask" could contain manipulation of PWGTxEN bits, what I do is to overwrite
those with the previously updated value:
	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
						mc13783_state_powermisc_pwgt;

mc13783_state_powermisc_pwgt is maintained to be 0 in bits other than 
MC13783_REG_POWERMISC_PWGTSPI_M mask.
I got me much clear?
I misunderstood the question?

Sorry my English please.. :)
Thanks!

Alberto.


