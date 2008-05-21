Return-Path: <linux-kernel-owner+w=401wt.eu-S935914AbYEUPTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935914AbYEUPTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYEUPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:19:32 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:4435 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757035AbYEUPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:19:31 -0400
Date: Wed, 21 May 2008 19:19:29 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Message-ID: <20080521151928.GA28857@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 01:36:13PM -0600, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> This patch adds support for populating an SPI bus based on data in the
> OF device tree.  This is useful for powerpc platforms which use the
> device tree instead of discrete code for describing platform layout.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
[...]
> diff --git a/drivers/spi/spi_of.c b/drivers/spi/spi_of.c
> new file mode 100644
> index 0000000..b5ae434
> --- /dev/null
> +++ b/drivers/spi/spi_of.c
> @@ -0,0 +1,86 @@
> +/*

I think better placement for this is drivers/of, no?

> + * SPI OF support routines
> + * Copyright (C) 2008 Secret Lab Technologies Ltd.
> + *
> + * Support routines for deriving SPI device attachments from the device
> + * tree.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/spi/spi_of.h>
> +
> +/**
> + * spi_of_register_devices - Register child devices onto the SPI bus
> + * @master:	Pointer to spi_master device
> + * @np:		parent node of SPI device nodes
> + *
> + * Registers an spi_device for each child node of 'np' which has a 'reg'
> + * property.
> + */
> +void spi_of_register_devices(struct spi_master *master, struct device_node *np)
> +{
> +	struct spi_device *spi;
> +	struct device_node *nc;
> +	const u32 *prop;
> +	const char *sprop;
> +	int rc;
> +	int len;
> +
> +	for_each_child_of_node(np, nc) {
> +		/* Alloc an spi_device */
> +		spi = spi_alloc_device(master);
> +		if (!spi) {
> +			dev_err(&master->dev, "spi_device alloc error for %s\n",
> +				np->full_name);
> +			continue;
> +		}
> +
> +		/* Device address */
> +		prop = of_get_property(nc, "reg", &len);
> +		if (!prop || len < sizeof(*prop)) {
> +			dev_err(&master->dev, "%s has no 'reg' property\n",
> +				np->full_name);

Should be nc->full_name.

> +			continue;
> +		}
[...]

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
