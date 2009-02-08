Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZBHX3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZBHX3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBHX3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:29:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3004 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZBHX3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:29:43 -0500
Date: Sun, 8 Feb 2009 23:29:23 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090208232922.GA16966@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902081037.06645.david-b@pacbell.net>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 10:37:06AM -0800, David Brownell wrote:

> +/*
> + * We list regulators here if systems need some level of
> + * software control over them after boot.
> + */
> +static struct twlreg_info twl4030_regs[] = {

> +	/*
> +	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
> +	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
> +	*/

Minor nit, but I guess the comment would be a bit more accurate if the
comment said that the regulators that aren't likely to be changed have
been commented out (it required that little extra bit of thinking).

> +	/* Constrain board-specific capabilities according to what
> +	 * this driver and the chip itself can actually do.
> +	 */
> +	c = &initdata->constraints;
> +	if (!c->min_uV || c->min_uV < min_uV)
> +		c->min_uV = min_uV;

If we're going to do this I think it'd be better to push it into the
core and let the regulators pass in a set of constraints so that the
behaviour will be consistent between drivers.

I'd also expect to have the registration fail or at least issue a
warning if the code kicks in since that indicates that the board
constraints have been set up incorrectly.  There's a reasonable chance
that the fixed up constraints will still need to be changed for the
board to be configured properly and things may end up being driven out
of spec, potentially causing damage.
