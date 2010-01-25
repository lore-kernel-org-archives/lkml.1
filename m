Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559Ab0AYBe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0AYBe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 20:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287Ab0AYBe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 20:34:29 -0500
Received: from trinity.fluff.org ([89.16.178.74]:40729 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0AYBe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 20:34:28 -0500
Date: Mon, 25 Jan 2010 01:34:21 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Miao <eric.miao@marvell.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
Message-ID: <20100125013421.GL26562@trinity.fluff.org>
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 06:03:57PM +0100, Uwe Kleine-König wrote:
> This fixes a warning on several pxa based machines:
> 
> 	arch/arm/mach-pxa/ssp.c:475: warning: initialization discards qualifiers from pointer target type

this looks sane to me.
 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Eric Miao <eric.miao@marvell.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/platform.c         |    2 +-
>  include/linux/platform_device.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 58efaf2..962246c 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -578,7 +578,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>  }
>  
>  static const struct platform_device_id *platform_match_id(
> -			struct platform_device_id *id,
> +			const struct platform_device_id *id,
>  			struct platform_device *pdev)
>  {
>  	while (id->name[0]) {
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 71ff887..3a6201e 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -21,7 +21,7 @@ struct platform_device {
>  	u32		num_resources;
>  	struct resource	* resource;
>  
> -	struct platform_device_id	*id_entry;
> +	const struct platform_device_id	*id_entry;
>  
>  	/* arch specific additions */
>  	struct pdev_archdata	archdata;
> @@ -62,7 +62,7 @@ struct platform_driver {
>  	int (*suspend)(struct platform_device *, pm_message_t state);
>  	int (*resume)(struct platform_device *);
>  	struct device_driver driver;
> -	struct platform_device_id *id_table;
> +	const struct platform_device_id *id_table;
>  };
>  
>  extern int platform_driver_register(struct platform_driver *);
> -- 
> 1.6.6
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

