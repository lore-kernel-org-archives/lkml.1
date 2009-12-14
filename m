Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZLNKlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZLNKlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZLNKlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:41:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45054 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbZLNKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CARJcrcbY+yQismIFLIQ0MdAobfpGbwgHE49sX0WJNt0H3A+ChcYn7JWi5QBWpAcAl
         6nq3MKz+sBPygKpm80pZ/w8NW9w7V8mevMXntfZZhnKQ5MezH1nFjHvdKhI1cDYCI+fW
         Ln37r5Mr/ZEuvMtFoXmcgwFvMIr61MVKBhJMg=
Subject: Re: [PATCH 3/4] regulator: add voltage selection capability to
 mc13783 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091213200142.GC14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby>
	 <1260636523.2054.28.camel@climbing-alby>
	 <1260636819.2054.33.camel@climbing-alby>
	 <1260636976.2054.36.camel@climbing-alby>
	 <20091213200142.GC14024@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 11:41:38 +0100
Message-ID: <1260787298.2022.55.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno dom, 13/12/2009 alle 21.01 +0100, Uwe Kleine-König ha scritto:
> On Sat, Dec 12, 2009 at 05:56:16PM +0100, Alberto Panizzo wrote:
> > This patch, complete the mc13783 regulator subsystem driver with 
> > voltage selecting capability.
> > Main Switches (SW1AB, SW2AB) are not supported yet.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > ---
> >  drivers/regulator/mc13783-regulator.c |  375 ++++++++++++++++++++++++++++++---
> >  1 files changed, 348 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
> > index 9f99862..ed78137 100644
> > --- a/drivers/regulator/mc13783-regulator.c
> > +++ b/drivers/regulator/mc13783-regulator.c
> > @@ -2,6 +2,7 @@
> >   * Regulator Driver for Freescale MC13783 PMIC
> >   *
> >   * Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
> > + * Copyright 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License version 2 as
> > @@ -18,9 +19,47 @@
> >  
> >  #define MC13783_REG_SWITCHERS4			28
> >  #define MC13783_REG_SWITCHERS4_PLLEN			(1 << 18)
> > +#define MC13783_REG_SWITCHERS4_PLLVSEL			(1 << 19)
> > +#define MC13783_REG_SWITCHERS4_PLLVSEL_M		(7 << 19)
> >  
> >  #define MC13783_REG_SWITCHERS5			29
> >  #define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
> > +#define MC13783_REG_SWITCHERS5_SW3VSEL			18
> This looks inconsitent:
> 	MC13783_REG_SWITCHERS4_PLLVSEL	(1 << 19)
> 	MC13783_REG_SWITCHERS5_SW3VSEL	18
> 
> I didn't check the rest of the patch though it would be great if you
> wouldn't need all those arrays as they occupy much memory.
> 
> Best regards
> Uwe
> 

Yes this is a mistake and.. I'm not sure to embrace SWITCHERS4_PLL in
the regulators stuff at all.
The code that I propose can enable/disable and set the multiplication
factor for the PLL but this is not a voltage regulator!

Maybe the PLL must be initialised and controlled via another driver, 
in the audio codec?

For the arrays, also for me it is not the better code that I wrote
but voltages values have no regular stepping and this way is a great 
self explain way.
Look at tables 4-18 and 4-19 of the mc13783 information for GPL drivers..

The other ways are:
- Compress arrays in different phases, with complex initialisation.
- Write as many function as different regulators there are, increasing
  the driver complexity and also the text instead of data memory..

Sure, I have to correct all the coding style issues asserted by Mark!

Alberto.


