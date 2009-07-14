Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZGNCOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZGNCOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZGNCOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:14:32 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44554 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZGNCOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:14:31 -0400
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 04:14:28 +0200
Message-Id: <1247537668.4549.7.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> 1. add intel's sdio vendor id to sdio_ids.h
> 2. move iwmc3200 sdio devices ids to sdio_ids.h

this needs a better commit message since you are touching three
subsystems right now.

Please explain what you are doing. Sounds maybe too obvious, but it is
important that we have clear commit message. Especially when it is
touching more than one subsystem and people have to resolve merge
conflicts.

> This patch is against 2.6.31-rc2
> 7638d5322bd89d49e013a03fe2afaeb6d214fabd

This should not be part of the commit message.

> Cc:inaky.perez-gonzalez@intel.com
> Cc:cindy.h.kao@intel.com
> Cc:samuel.ortiz@intel.com
> Cc:yi.zhu@intel.com
> Cc:drzeus-list@drzeus.cx
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wimax/i2400m/sdio.c          |   10 ++++------
>  drivers/net/wireless/iwmc3200wifi/sdio.c |    4 +++-
>  drivers/net/wireless/iwmc3200wifi/sdio.h |    3 ---
>  include/linux/mmc/sdio_ids.h             |    5 +++++
>  4 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/sdio.c b/drivers/net/wimax/i2400m/sdio.c
> index 2538825..3dc1990 100644
> --- a/drivers/net/wimax/i2400m/sdio.c
> +++ b/drivers/net/wimax/i2400m/sdio.c
> @@ -58,6 +58,7 @@
>   */
>  
>  #include <linux/debugfs.h>
> +#include <linux/mmc/sdio_ids.h>
>  #include <linux/mmc/sdio.h>
>  #include <linux/mmc/sdio_func.h>
>  #include "i2400m-sdio.h"
> @@ -501,14 +502,11 @@ void i2400ms_remove(struct sdio_func *func)
>  	d_fnend(3, dev, "SDIO func %p\n", func);
>  }
>  
> -enum {
> -	I2400MS_INTEL_VID = 0x89,
> -};
> -
>  static
>  const struct sdio_device_id i2400ms_sdio_ids[] = {
> -	/* Intel: i2400m WiMAX over SDIO */
> -	{ SDIO_DEVICE(I2400MS_INTEL_VID, 0x1402) },
> +	/* Intel: i2400m WiMAX (iwm3200) over SDIO */
> +	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL,
> +	  SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX) },
>  	{ }, 			/* end: all zeroes */

for readability, please indent the SDIO_DEVICE_ID_INTEL...

Otherwise you easily assume you have two SDIO_DEVICE() statement.

>  };
>  MODULE_DEVICE_TABLE(sdio, i2400ms_sdio_ids);
> diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
> index 9166818..995a3f6 100644
> --- a/drivers/net/wireless/iwmc3200wifi/sdio.c
> +++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
> @@ -65,6 +65,7 @@
>  #include <linux/kernel.h>
>  #include <linux/netdevice.h>
>  #include <linux/debugfs.h>
> +#include <linux/mmc/sdio_ids.h>
>  #include <linux/mmc/sdio.h>
>  #include <linux/mmc/sdio_func.h>
>  
> @@ -492,7 +493,8 @@ static void iwm_sdio_remove(struct sdio_func *func)
>  }
>  
>  static const struct sdio_device_id iwm_sdio_ids[] = {
> -	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL, SDIO_DEVICE_ID_IWM) },
> +	{ SDIO_DEVICE(SDIO_VENDOR_ID_INTEL,
> +	  SDIO_DEVICE_ID_INTEL_IWMC3200WIFI) },
>  	{ /* end: all zeroes */	},

Same here.

>  };
>  MODULE_DEVICE_TABLE(sdio, iwm_sdio_ids);
> diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.h b/drivers/net/wireless/iwmc3200wifi/sdio.h
> index b3c156b..aab6b68 100644
> --- a/drivers/net/wireless/iwmc3200wifi/sdio.h
> +++ b/drivers/net/wireless/iwmc3200wifi/sdio.h
> @@ -39,9 +39,6 @@
>  #ifndef __IWM_SDIO_H__
>  #define __IWM_SDIO_H__
>  
> -#define SDIO_VENDOR_ID_INTEL 0x89
> -#define SDIO_DEVICE_ID_IWM   0x1403
> -
>  #define IWM_SDIO_DATA_ADDR           0x0
>  #define IWM_SDIO_INTR_ENABLE_ADDR    0x14
>  #define IWM_SDIO_INTR_STATUS_ADDR    0x13
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 39751c8..b46a57a 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -22,6 +22,11 @@
>  /*
>   * Vendors and devices.  Sort key: vendor first, device next.
>   */
> +#define SDIO_VENDOR_ID_INTEL			0x0089
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200WIFI	0x1403
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200TOP        0x1404
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200BT		0x1406

While you are touching files all over, what about GPS?
 
>  #define SDIO_VENDOR_ID_MARVELL			0x02df
>  #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103

Regards

Marcel


