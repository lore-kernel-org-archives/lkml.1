Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZHGP6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZHGP6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZHGP6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:58:01 -0400
Received: from relais.videotron.ca ([24.201.245.36]:37609 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZHGP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:58:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Aug 2009 11:57:34 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Dhaval Vasa <dhaval.vasa@einfochips.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rabeeh Khoury <rabeeh@marvell.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Base board support added to
 v2.6.31-rc5
In-reply-to: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com>
Message-id: <alpine.LFD.2.00.0908071149460.16073@xanadu.home>
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ arm-linux mailing list added to CC ]

On Thu, 6 Aug 2009, Dhaval Vasa wrote:

> reference:
> http://open-rd.org
> http://code.google.com/p/openrd
> 
> This patch is tested for:
> 1. Boot from DRAM/NAND flash
> 2. NAND read/write/erase
> 3. GbE0
> 4. USB read/write
> 
> FIXME:
> 1. SD/UART1 selection
> 2. MPP configuration (currently, default)
> 3. PEX
> 
> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>

Comments below.

> diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
> new file mode 100644
> index 0000000..26b6e58
> --- /dev/null
> +++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
> @@ -0,0 +1,79 @@
> +/*
> + * arch/arm/mach-kirkwood/openrd_base-setup.c
> + *
> + * Marvell OpenRD Base Board Setup
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/partitions.h>
> +#include <linux/mv643xx_eth.h>
> +#include <linux/gpio.h>
> +#include <linux/leds.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/kirkwood.h>
> +#include <plat/mvsdio.h>
> +#include "common.h"
> +#include "mpp.h"

The leds.h include appears to be unneeded.

> +
> +static struct mtd_partition openrd_base_nand_parts[] = {
> +	{
> +		.name = "u-boot",
> +		.offset = 0,
> +		.size = SZ_1M
> +	}, {
> +		.name = "uImage",
> +		.offset = MTDPART_OFS_NXTBLK,
> +		.size = SZ_4M
> +	}, {
> +		.name = "root",
> +		.offset = MTDPART_OFS_NXTBLK,
> +		.size = MTDPART_SIZ_FULL
> +	},
> +};
> +
> +static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
> +	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
> +};
> +
> +static struct mvsdio_platform_data openrd_base_mvsdio_data = {
> +	.gpio_card_detect = MPP29_GPIO,	/* MPP29 used as SD card detect */
> +};

You should use a literal number here, like .gpio_card_detect = 29.

> +static unsigned int openrd_base_mpp_config[] __initdata = {
> +	0
> +};

Here belongs the MPP29_GPIO.


Nicolas
