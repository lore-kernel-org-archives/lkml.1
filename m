Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0BKReg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:34:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38766 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab0BKRef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:34:35 -0500
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'kishore kadiyala'" <kishore.kadiyala@ti.com>,
       <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <jarkko.lavinen@nokia.com>
References: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
Subject: RE: [PATCH] OMAP: Fix for bus width which improves SD card's      peformance.
Date: Thu, 11 Feb 2010 11:34:05 -0600
Message-ID: <004701caab40$68b576e0$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcqrJVpDmCh/wNfHTj24As+RGSm+HwAGrtEQ
In-Reply-To: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kishore kadiyala [mailto:kishore.kadiyala@ti.com]
> Sent: Thursday, February 11, 2010 8:20 AM
> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: jarkko.lavinen@nokia.com; madhu.cr@ti.com
> Subject: [PATCH] OMAP: Fix for bus width which improves SD card's
> peformance.
> 
> This patch improves low speeds for SD cards.
> OMAP-MMC controller's can support maximum bus width of '8'.
> when bus width is mentioned as "8" in controller data,the SD
> stack will check whether bus width is "4" and if not it will
> set bus width to "1" and there by degrading peformance.
> This patch fixes the issue and improves the performance of
> SD cards.
> 
> Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>

ACK

Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>

> ---
>  Here are my experiment numbers, on a Class 6 SDHC card:
>  Read peformance is increased by 220%
>  Write Performance is increased by 52%
> 
>  drivers/mmc/host/omap_hsmmc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 83f0aff..8c97c22 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct
> platform_device
> *pdev)
>  		     MMC_CAP_WAIT_WHILE_BUSY;
> 
>  	if (mmc_slot(host).wires >= 8)
> -		mmc->caps |= MMC_CAP_8_BIT_DATA;
> +		mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
>  	else if (mmc_slot(host).wires >= 4)
>  		mmc->caps |= MMC_CAP_4_BIT_DATA;
> 
> --
> 1.6.3.3

