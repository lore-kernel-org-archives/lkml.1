Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZI2JUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZI2JUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZI2JUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:20:09 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59584 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZI2JUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:20:07 -0400
Date: Tue, 29 Sep 2009 12:18:53 +0300
From: Imre Deak <imre.deak@nokia.com>
To: ext Peter Huewe <PeterHuewe@gmx.de>
Cc: Jiri Kosina <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Jonathan McDowell <noodles@earth.li>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Mike Wege <ext-mike.wege@nokia.com>,
       "Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video/omap:  adding __init/__exit macros to various
	drivers
Message-ID: <20090929091853.GC9536@localhost>
References: <200909290318.07309.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909290318.07309.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 29 Sep 2009 09:17:32.0442 (UTC) FILETIME=[ACCF0FA0:01CA40E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 03:18:06AM +0200, ext Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of the following drivers in media/omap:
> drivers/video/omap/lcd_ams_delta.c
> drivers/video/omap/lcd_mipid.c
> 
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial tree.
> 
> linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Imre Deak <imre.deak@nokia.com>

> ---
> diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/omap/lcd_ams_delta.c
> index 1f74399..319a9a2 100644
> --- a/drivers/video/omap/lcd_ams_delta.c
> +++ b/drivers/video/omap/lcd_ams_delta.c
> @@ -123,12 +123,12 @@ struct platform_driver ams_delta_panel_driver = {
>  	},
>  };
>  
> -static int ams_delta_panel_drv_init(void)
> +static int __init ams_delta_panel_drv_init(void)
>  {
>  	return platform_driver_register(&ams_delta_panel_driver);
>  }
>  
> -static void ams_delta_panel_drv_cleanup(void)
> +static void __exit ams_delta_panel_drv_cleanup(void)
>  {
>  	platform_driver_unregister(&ams_delta_panel_driver);
>  }
> diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
> index 918ee89..d88a792 100644
> --- a/drivers/video/omap/lcd_mipid.c
> +++ b/drivers/video/omap/lcd_mipid.c
> @@ -607,7 +607,7 @@ static struct spi_driver mipid_spi_driver = {
>  	.remove	= __devexit_p(mipid_spi_remove),
>  };
>  
> -static int mipid_drv_init(void)
> +static int __init mipid_drv_init(void)
>  {
>  	spi_register_driver(&mipid_spi_driver);
>  
> @@ -615,7 +615,7 @@ static int mipid_drv_init(void)
>  }
>  module_init(mipid_drv_init);
>  
> -static void mipid_drv_cleanup(void)
> +static void __exit mipid_drv_cleanup(void)
>  {
>  	spi_unregister_driver(&mipid_spi_driver);
>  }
