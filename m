Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZIXRjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZIXRjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZIXRjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:39:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34155 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZIXRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:39:10 -0400
Date: Thu, 24 Sep 2009 10:39:05 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20090924173904.GA9082@sirena.org.uk>
References: <1253798645-9493-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253798645-9493-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 72.254.11.239
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: add driver for MAX8660/8661
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 03:24:05PM +0200, Wolfram Sang wrote:
> Tested with a MX25-based custom board.

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

This looks good - thanks!  A couple of little comments below:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	if (MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP > max_uV)
> +		return -EINVAL;

Not important but using list_voltage() here would be a little nicer.

> +static struct regulator_ops max8660_dcdc_ops = {
> +	.is_enabled = max8660_dcdc_is_enabled,
> +	.list_voltage = max8660_dcdc_list,
> +	.set_voltage = max8660_dcdc_set,
> +	.get_voltage = max8660_dcdc_get,
> +	/* no set_mode() & friends: forced PWM does not save any power */

Forced PWM is normally a power loss - the benefit it gives is the
ability to respond to sudden spikes in load without voltage droops.  The
power benefit from not having it enabled is usually only apparent at
lower loads.
