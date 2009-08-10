Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZHJLeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZHJLeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZHJLeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:34:21 -0400
Received: from us.einfochips.com ([74.54.47.34]:46288 "EHLO us.einfochips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZHJLeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:34:20 -0400
Message-ID: <4A800610.4060106@einfochips.com>
Date: Mon, 10 Aug 2009 17:05:44 +0530
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rabeeh Khoury <rabeeh@marvell.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Base board support added
 to v2.6.31-rc5
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com> <alpine.LFD.2.00.0908071149460.16073@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.0908071149460.16073@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> [ arm-linux mailing list added to CC ]
> 
> On Thu, 6 Aug 2009, Dhaval Vasa wrote:
> 
>> reference:
>> http://open-rd.org
>> http://code.google.com/p/openrd
>>
>> This patch is tested for:
>> 1. Boot from DRAM/NAND flash
>> 2. NAND read/write/erase
>> 3. GbE0
>> 4. USB read/write
>>
>> FIXME:
>> 1. SD/UART1 selection
>> 2. MPP configuration (currently, default)
>> 3. PEX
>>
>> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
> 
> Comments below.
> 
>> diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
>> new file mode 100644
>> index 0000000..26b6e58
>> --- /dev/null
>> +++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
>> @@ -0,0 +1,79 @@
>> +/*
>> + * arch/arm/mach-kirkwood/openrd_base-setup.c
>> + *
>> + * Marvell OpenRD Base Board Setup
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mtd/partitions.h>
>> +#include <linux/mv643xx_eth.h>
>> +#include <linux/gpio.h>
>> +#include <linux/leds.h>
>> +#include <asm/mach-types.h>
>> +#include <asm/mach/arch.h>
>> +#include <mach/kirkwood.h>
>> +#include <plat/mvsdio.h>
>> +#include "common.h"
>> +#include "mpp.h"
> 
> The leds.h include appears to be unneeded.
> 
>> +
>> +static struct mtd_partition openrd_base_nand_parts[] = {
>> +	{
>> +		.name = "u-boot",
>> +		.offset = 0,
>> +		.size = SZ_1M
>> +	}, {
>> +		.name = "uImage",
>> +		.offset = MTDPART_OFS_NXTBLK,
>> +		.size = SZ_4M
>> +	}, {
>> +		.name = "root",
>> +		.offset = MTDPART_OFS_NXTBLK,
>> +		.size = MTDPART_SIZ_FULL
>> +	},
>> +};
>> +
>> +static struct mv643xx_eth_platform_data openrd_base_ge00_data = {
>> +	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
>> +};
>> +
>> +static struct mvsdio_platform_data openrd_base_mvsdio_data = {
>> +	.gpio_card_detect = MPP29_GPIO,	/* MPP29 used as SD card detect */
>> +};
> 
> You should use a literal number here, like .gpio_card_detect = 29.

patch v2 will close this review comment.

> 
>> +static unsigned int openrd_base_mpp_config[] __initdata = {
>> +	0
>> +};
> 
> Here belongs the MPP29_GPIO.

patch v2 will close this review comment.


Thanks for review.

- Dhaval
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
 
