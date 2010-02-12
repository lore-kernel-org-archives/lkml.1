Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab0BLFio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:38:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59394 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0BLFim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:38:42 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Thomas Weber <swirl@gmx.li>
CC: Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Thomas Weber <weber@corscience.de>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Feb 2010 11:08:22 +0530
Subject: RE: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for
 DEVKIT8000
Thread-Topic: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for
 DEVKIT8000
Thread-Index: AcqrUjIPi6QRXmblQiKeIZLi1cP+SAATzPqA
Message-ID: <19F8576C6E063C45BE387C64729E7394044A96DB56@dbde02.ent.ti.com>
References: <1265917278-22011-1-git-send-email-swirl@gmx.li>
In-Reply-To: <1265917278-22011-1-git-send-email-swirl@gmx.li>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Thomas Weber
> Sent: Friday, February 12, 2010 1:11 AM
> Cc: Thomas Weber; Tomi Valkeinen; Thomas Weber; linux-
> omap@vger.kernel.org; linux-fbdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display
> for DEVKIT8000
> 
> This patch adds the 7 inch display for the DEVKIT8000.
[Hiremath, Vaibhav] Specify panel part/name here, patch description seems less descriptive.

> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  drivers/video/omap2/displays/Kconfig               |    8 ++-
>  drivers/video/omap2/displays/Makefile              |    1 +
>  .../video/omap2/displays/panel-innolux-at070tn83.c |  107
> ++++++++++++++++++++
>  3 files changed, 115 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/video/omap2/displays/panel-innolux-
> at070tn83.c
> 
> diff --git a/drivers/video/omap2/displays/Kconfig
> b/drivers/video/omap2/displays/Kconfig
> index b12a59c..ca6b372 100644
> --- a/drivers/video/omap2/displays/Kconfig
> +++ b/drivers/video/omap2/displays/Kconfig
> @@ -5,7 +5,7 @@ config PANEL_GENERIC
>          tristate "Generic Panel"
>          help
>  	  Generic panel driver.
> -	  Used for DVI output for Beagle and OMAP3 SDP.
> +	  Used for DVI output for Beagle, Devkit8000 and OMAP3 SDP.
> 
[Hiremath, Vaibhav] I think we should remove board name from here, since all the OMAP board supporting DVI output would use this. 

>  config PANEL_SHARP_LS037V7DW01
>          tristate "Sharp LS037V7DW01 LCD Panel"
> @@ -13,6 +13,12 @@ config PANEL_SHARP_LS037V7DW01
>          help
>            LCD Panel used in TI's SDP3430 and EVM boards
> 
> +config PANEL_INNOLUX_AT070TN83
> +	tristate "Innolux AT070TN83 LCD Panel"
> +	depends on OMAP2_DSS
> +	help
> +	 LCD Panel used in TimLL's Devkit8000
> +
>  config PANEL_TAAL
>          tristate "Taal DSI Panel"
>          depends on OMAP2_DSS_DSI
> diff --git a/drivers/video/omap2/displays/Makefile
> b/drivers/video/omap2/displays/Makefile
> index 9556464..087b192 100644
> --- a/drivers/video/omap2/displays/Makefile
> +++ b/drivers/video/omap2/displays/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_PANEL_GENERIC) += panel-generic.o
>  obj-$(CONFIG_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
> 
>  obj-$(CONFIG_PANEL_TAAL) += panel-taal.o
> +obj-$(CONFIG_PANEL_INNOLUX_AT070TN83) += panel-innolux-at070tn83.o
> diff --git a/drivers/video/omap2/displays/panel-innolux-at070tn83.c
> b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
> new file mode 100644
> index 0000000..f1d7f69
> --- /dev/null
> +++ b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
> @@ -0,0 +1,107 @@
> +/*
> + * LCD panel driver for Innolux AT70TN83
> + *
> + * Copyright (C) 2010 Thomas Weber <weber@corscience.de>
> + *
> + * This program is free software; you can redistribute it and/or
> modify it
> + * under the terms of the GNU General Public License version 2 as
> published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public
> License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/regulator/consumer.h>
[Hiremath, Vaibhav] Do you need consumer.h file here?

> +#include <linux/err.h>
> +
> +#include <plat/display.h>
> +
> +static struct omap_video_timings innolux_at_timings = {
> +	.x_res 		= 800,
> +	.y_res 		= 480,
> +
> +	.pixel_clock	= 40000,
> +
> +	.hsw		= 48,
> +	.hfp		= 1,
> +	.hbp		= 1,
> +
> +	.vsw		= 3,
> +	.vfp		= 12,
> +	.vbp		= 25,
> +};
> +
> +static int innolux_at_panel_probe(struct omap_dss_device *dssdev)
> +{
> +	dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
> +		OMAP_DSS_LCD_IHS;
> +	dssdev->panel.acb = 0x28;
> +	dssdev->panel.timings = innolux_at_timings;
> +
> +	return 0;
> +}
> +
> +static void innolux_at_panel_remove(struct omap_dss_device *dssdev)
> +{
> +}
> +
> +static int innolux_at_panel_enable(struct omap_dss_device *dssdev)
> +{
> +	return 0;
> +}
> +
> +static void innolux_at_panel_disable(struct omap_dss_device
> *dssdev)
> +{
> +
> +	if (dssdev->platform_disable)
> +		dssdev->platform_disable(dssdev);
> +
> +}
> +
> +static int innolux_at_panel_suspend(struct omap_dss_device *dssdev)
> +{
> +	innolux_at_panel_disable(dssdev);
> +	return 0;
> +}
> +
> +static int innolux_at_panel_resume(struct omap_dss_device *dssdev)
> +{
> +	return innolux_at_panel_enable(dssdev);
> +}
> +
> +static struct omap_dss_driver innolux_at_driver = {
> +	.probe		= innolux_at_panel_probe,
> +	.remove		= innolux_at_panel_remove,
> +
> +	.enable		= innolux_at_panel_enable,
> +	.disable	= innolux_at_panel_disable,
> +	.suspend	= innolux_at_panel_suspend,
> +	.resume		= innolux_at_panel_resume,
> +
> +	.driver         = {
> +		.name   = "innolux_at_panel",
> +		.owner  = THIS_MODULE,
> +	},
> +};
> +
> +static int __init innolux_at_panel_drv_init(void)
> +{
> +	return omap_dss_register_driver(&innolux_at_driver);
> +}
> +
> +static void __exit innolux_at_panel_drv_exit(void)
> +{
> +	omap_dss_unregister_driver(&innolux_at_driver);
> +}
> +
[Hiremath, Vaibhav] I think we can make use of panel_generic.c file for this display panel, I couldn't find anything different being done in this file except panel.config and acb configuration.

To support this panel you just need to define videomode in modedb.c file use boot argument for the same.

Thanks,
Vaibhav

> +module_init(innolux_at_panel_drv_init);
> +module_exit(innolux_at_panel_drv_exit);
> +MODULE_LICENSE("GPL");
> --
> 1.6.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
