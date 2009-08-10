Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZHJMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZHJMuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZHJMut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:50:49 -0400
Received: from us.einfochips.com ([74.54.47.34]:47504 "EHLO us.einfochips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZHJMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:50:49 -0400
Message-ID: <4A8017FD.40405@einfochips.com>
Date: Mon, 10 Aug 2009 18:22:13 +0530
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Ron <ron@debian.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rabeeh Khoury <rabeeh@marvell.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] [ARM] Kirkwood: Initialise SATA for OpenRD-Base
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com> <alpine.LFD.2.00.0908071149460.16073@xanadu.home> <20090807223851.GR11898@audi.shelbyville.oz>
In-Reply-To: <20090807223851.GR11898@audi.shelbyville.oz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sending v2 patch for this; based on my updated base v2 patch.

- Dhaval

Ron wrote:
> Signed-off-by: Ron Lee <ron@debian.org>
> ---
> 
> Please include this patch in with that set also.  I can confirm this
> enables me to boot an OpenRD-Base board from SATA with 2.6.31-rc5.
> 
>  arch/arm/mach-kirkwood/openrd_base-setup.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
> index 6e290fd..d8c846d 100644
> --- a/arch/arm/mach-kirkwood/openrd_base-setup.c
> +++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/mtd/partitions.h>
> +#include <linux/ata_platform.h>
>  #include <linux/mv643xx_eth.h>
>  #include <linux/gpio.h>
>  #include <linux/leds.h>
> @@ -42,6 +43,10 @@ static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
>  	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
>  };
>  
> +static struct mv_sata_platform_data openrd_base_sata_data = {
> +	.n_ports	= 2,
> +};
> +
>  static struct mvsdio_platform_data openrd_base_mvsdio_data = {
>  	.gpio_card_detect = MPP29_GPIO,	/* MPP29 used as SD card detect */
>  };
> @@ -64,6 +69,7 @@ static void __init openrd_base_init(void)
>  	kirkwood_ehci_init();
>  
>  	kirkwood_ge00_init(&openrd_base_ge00_data);
> +	kirkwood_sata_init(&openrd_base_sata_data);
>  	kirkwood_sdio_init(&openrd_base_mvsdio_data);
>  }
>  
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
