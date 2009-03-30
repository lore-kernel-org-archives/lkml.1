Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZC3C1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZC3C1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 22:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZC3C1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 22:27:33 -0400
Received: from mail.renesas.com ([202.234.163.13]:62332 "EHLO
	mail04.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756224AbZC3C1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 22:27:32 -0400
X-AuditID: ac140387-00000004000005fd-e1-49d02dce3afb
Date: Mon, 30 Mar 2009 11:26:20 +0900
From: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Subject: Re: [PATCH 14/58] move sh_flctl's probe function to .devinit.text
In-reply-to: <1238196439-16535-14-git-send-email-u.kleine-koenig@pengutronix.de>
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Paul Mundt <lethal@linux-sh.org>
Message-id: <49D02DCC.5040500@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
References: <20090327232153.GA16348@pengutronix.de>
 <1238196439-16535-14-git-send-email-u.kleine-koenig@pengutronix.de>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

Thanks,
Yoshihiro Shimoda

Uwe Kleine-König wrote:
> A pointer to flctl_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/mtd/nand/sh_flctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
> index 821acb0..fdc0e4e 100644
> --- a/drivers/mtd/nand/sh_flctl.c
> +++ b/drivers/mtd/nand/sh_flctl.c
> @@ -763,7 +763,7 @@ static int flctl_chip_init_tail(struct mtd_info *mtd)
>  	return 0;
>  }
>  
> -static int __init flctl_probe(struct platform_device *pdev)
> +static int __devinit flctl_probe(struct platform_device *pdev)
>  {
>  	struct resource *res;
>  	struct sh_flctl *flctl;

