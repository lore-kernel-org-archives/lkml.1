Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211Ab0ARQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0ARQcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463Ab0ARQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:32:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46774 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199Ab0ARQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:32:15 -0500
Date: Mon, 18 Jan 2010 16:32:12 +0000
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
Message-ID: <20100118163212.GA32045@rakim.wolfsonmicro.main>
References: <1263830523.3632.22.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263830523.3632.22.camel@realization>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 05:02:03PM +0100, Alberto Panizzo wrote:

> +int mc13783_state_powermisc_pwgt;
> +int mc13783_reg_rmw_powermisc(struct mc13783 *mc13783, u32 mask, u32 val)

You're missing some statics here and some whitespace to separate the
function from the variable.

> +	/* Update the stored state for Power Gates.
> +	 * As from specs the meaning is inverted (0: en, 1: dis) */
> +	if (mask & MC13783_REG_POWERMISC_PWGTSPI_M)
> +		mc13783_state_powermisc_pwgt =
> +			(mc13783_state_powermisc_pwgt & ~mask) |
> +			((val ^ mask) & MC13783_REG_POWERMISC_PWGTSPI_M);

Could this code be written in a clearer fashion?  The bit manipluation
isn't entirely obvious, especially given the multiple masks in use...

> +	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
> +	if (ret)
> +		return ret;
> +
> +	valread = (valread & ~mask) | val;
> +
> +	/* Re propose the stored state for Power Gates */
> +	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> +						mc13783_state_powermisc_pwgt;

...and this further mainpulation.
