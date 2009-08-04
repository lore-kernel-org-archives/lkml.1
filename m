Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbZHDUlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbZHDUlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbZHDUlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:41:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40198 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbZHDUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:41:00 -0400
Date: Tue, 4 Aug 2009 21:40:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: lrg@slimlogic.co.uk, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20090804204053.GA29518@sirena.org.uk>
References: <quadros.roger@gmail.com>
 <1249408730-15430-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249408730-15430-1-git-send-email-quadros.roger@gmail.com>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] regulator: Add GPIO enable control to fixed voltage
 regulator driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 08:58:50PM +0300, Roger Quadros wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>

> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.

> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>

Looks good, thanks for taking the time to do this and fixing up the
review comments.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

A couple of small notes that I don't see as blocking merge:

> +
> +		/* FIXME: Remove below print warning
> +		 *
> +		 * config->gpio must be set to -EINVAL by platform code if
> +		 * GPIO control is not required. However, early adopters
> +		 * not requiring GPIO control may forget to initialize
> +		 * config->gpio to -EINVAL. This will cause GPIO 0 to be used
> +		 * for GPIO control.
> +		 *
> +		 * This warning will be removed once there are a couple of users
> +		 * for this driver.

Probably just for 2.6.33 or something; the point here is that this is an
incompatible change in the platform data which we can get away with here
due to the fact that there aren't any current users.

> +		drvdata->is_enabled = config->enabled_at_boot;
> +		ret = drvdata->is_enabled ?
> +				config->enable_high : !config->enable_high;

Might be more legible without the ternery operator but no point spinning
the patch for that.
