Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788Ab0ARRh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0ARRh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774Ab0ARRh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:37:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49514 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753988Ab0ARRhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:37:25 -0500
Date: Mon, 18 Jan 2010 17:37:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
Message-ID: <20100118173722.GA12689@rakim.wolfsonmicro.main>
References: <1263830523.3632.22.camel@realization>
 <20100118163212.GA32045@rakim.wolfsonmicro.main>
 <1263835570.3632.33.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263835570.3632.33.camel@realization>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I just wrote...

On Mon, Jan 18, 2010 at 06:07:53PM +0100, Alberto Panizzo wrote:

> Something like this?
> 	if (mask & MC13783_REG_POWERMISC_PWGTSPI_M) {
> 		u32 new_state = (val & MC13783_REG_POWERMISC_PWGTSPI_M) ^ mask;
> 
> 		mc13783_state_powermisc_pwgt =
> 			(mc13783_state_powermisc_pwgt & ~mask) | new_state;
> 	}

Yes, that's clearer.

> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	valread = (valread & ~mask) | val;
> > > +
> > > +	/* Re propose the stored state for Power Gates */
> > > +	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> > > +						mc13783_state_powermisc_pwgt;
> > 
> > ...and this further mainpulation.

> What is obscure in this? it is the same operation as the previous
> MC13783_REG_POWERMISC_PWGTSPI_M is the mask for PWGT1 and 2 bits and in 
> mc13783_state_powermisc_pwgt there is the stored state for those two bits.

Part of it is the fact that the first bit was almost completely opaque
but even so it would be less surprising if you first worked out the
value you wanted to set, then did whatever manipulation was required to
translate into the format that actually gets written.
