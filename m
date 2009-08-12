Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZHLQmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZHLQmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZHLQmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:42:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZHLQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:42:52 -0400
Date: Wed, 12 Aug 2009 17:42:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>,
       Luotao Fu <l.fu@pengutronix.de>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [lm-sensors] [PATCH 3/5] [hwmon] add Freescale MC13783 adc
	driver
Message-ID: <20090812164252.GE11227@sirena.org.uk>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
X-Cookie: One FISHWICH coming up!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 05:05:29PM +0200, Sascha Hauer wrote:

> ---
>  drivers/hwmon/Kconfig       |    6 ++
>  drivers/hwmon/Makefile      |    1 +
>  drivers/hwmon/mc13783-adc.c |  181 +++++++++++++++++++++++++++++++++++++++++++

Ideally there should be a Documentation/hwmon describing the chip and
the hwmon features it has.

> +	for (i = 0; i < entries; i++) {
> +		ret = device_create_file(&pdev->dev,
> +				&mc13783_adc_ctl[i].dev_attr);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"device_create_file failed with %d.\n", ret);
> +			goto out_err;
> +		}
> +	}

Could use sysfs_create_group() here.
