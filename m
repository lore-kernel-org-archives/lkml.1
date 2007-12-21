Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbXLUKmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbXLUKmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXLUKmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:42:16 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46031 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbXLUKmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:42:15 -0500
Date: Fri, 21 Dec 2007 13:41:28 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ville Syrjala <syrjala@sci.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver
Message-ID: <20071221104127.GA28474@2ka.mipt.ru>
References: <1198222441690-git-send-email-syrjala@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198222441690-git-send-email-syrjala@sci.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville.

On Fri, Dec 21, 2007 at 09:34:01AM +0200, Ville Syrjala (syrjala@sci.fi) wrote:
> Add a GPIO 1-wire bus master driver. The driver used the GPIO API to
> control the wire and the GPIO pin can be specified using platform data
> similar to i2c-gpio. The driver was tested with AT91SAM9260 + DS2401.

This looks ok, only a minor nit about codying style below.

> Signed-off-by: Ville Syrjala <syrjala@sci.fi>

ACK.

> +static int __init w1_gpio_probe(struct platform_device *pdev)
> +{
> +	struct w1_bus_master *master;
> +	struct w1_gpio_platform_data *pdata;
> +	int err;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata)
> +		return -ENXIO;
> +
> +	master = kzalloc(sizeof *master, GFP_KERNEL);
> +	if (!master)
> +		return -ENOMEM;

I think sizeof(struct w1_bus_master) is a better way.

> new file mode 100644
> index 0000000..3b80bb2
> --- /dev/null
> +++ b/include/linux/w1-gpio.h

Does anyone use this file except driver itself?

-- 
	Evgeniy Polyakov
