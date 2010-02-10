Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0BJJw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:52:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35909 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0BJJwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:52:24 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 10 Feb 2010 15:22:08 +0530
Subject: RE: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Thread-Topic: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Thread-Index: Acqoh4KC/gNHbux9SuWQcoMTmhO8SQBrb7ng
Message-ID: <19F8576C6E063C45BE387C64729E7394044A96D552@dbde02.ent.ti.com>
References: <20100208172521.abb500b4.sfr@canb.auug.org.au>
In-Reply-To: <20100208172521.abb500b4.sfr@canb.auug.org.au>
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



Thanks,
Vaibhav Hiremath
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Monday, February 08, 2010 11:55 AM
> To: Tomi Valkeinen
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org;
> Hiremath, Vaibhav; Tony Lindgren; linux-omap@vger.kernel.org
> Subject: linux-next: manual merge of the omap_dss2 tree with the
> omap tree
> 
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/mach-omap2/board-am3517evm.c between commit
> 13560d875d67c06239c82a6148c1b87075701fe9 ("AM3517: Enable basic I2C
> Support") from the omap tree and commit
> 56a3d0235cd50d14d7bd4d45e55d192aa0e78cac ("OMAP: AM3517: Enable DSS2
> for
> AM3517EVM board") from the omap_dss2 tree.
> 
> Juts overlapping additions.   I fixed it up (see below) and can
> carry the
> fix as necessary.
> 
> P.S. Tomi, this omap_dss2 commit only has your Acked-by not Signed-
> off-by.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-omap2/board-am3517evm.c
> index a166bcc,54af5f8..0000000
> --- a/arch/arm/mach-omap2/board-am3517evm.c
> +++ b/arch/arm/mach-omap2/board-am3517evm.c
> @@@ -33,15 -33,147 +34,156 @@@
> 
>   #include "mux.h"
> 
[Hiremath, Vaibhav] I don't see display.h being added here, but when I looked into linux-next repo, I could see that. I think the following commit only shows for the conflicted part, so should be ok.

Thanks,
Vaibhav

> + #define LCD_PANEL_PWR		176
> + #define LCD_PANEL_BKLIGHT_PWR	182
> + #define LCD_PANEL_PWM		181
> +
> + static int lcd_enabled;
> + static int dvi_enabled;
> +
> + static void __init am3517_evm_display_init(void)
> + {
> + 	int r;
> +
> + 	omap_mux_init_gpio(LCD_PANEL_PWR, OMAP_PIN_INPUT_PULLUP);
> + 	omap_mux_init_gpio(LCD_PANEL_BKLIGHT_PWR,
> OMAP_PIN_INPUT_PULLDOWN);
> + 	omap_mux_init_gpio(LCD_PANEL_PWM, OMAP_PIN_INPUT_PULLDOWN);
> + 	/*
> + 	 * Enable GPIO 182 = LCD Backlight Power
> + 	 */
> + 	r = gpio_request(LCD_PANEL_BKLIGHT_PWR, "lcd_backlight_pwr");
> + 	if (r) {
> + 		printk(KERN_ERR "failed to get lcd_backlight_pwr\n");
> + 		return;
> + 	}
> + 	gpio_direction_output(LCD_PANEL_BKLIGHT_PWR, 1);
> + 	/*
> + 	 * Enable GPIO 181 = LCD Panel PWM
> + 	 */
> + 	r = gpio_request(LCD_PANEL_PWM, "lcd_pwm");
> + 	if (r) {
> + 		printk(KERN_ERR "failed to get lcd_pwm\n");
> + 		goto err_1;
> + 	}
> + 	gpio_direction_output(LCD_PANEL_PWM, 1);
> + 	/*
> + 	 * Enable GPIO 176 = LCD Panel Power enable pin
> + 	 */
> + 	r = gpio_request(LCD_PANEL_PWR, "lcd_panel_pwr");
> + 	if (r) {
> + 		printk(KERN_ERR "failed to get lcd_panel_pwr\n");
> + 		goto err_2;
> + 	}
> + 	gpio_direction_output(LCD_PANEL_PWR, 1);
> +
> + 	printk(KERN_INFO "Display initialized successfully\n");
> + 	return;
> +
> + err_2:
> + 	gpio_free(LCD_PANEL_PWM);
> + err_1:
> + 	gpio_free(LCD_PANEL_BKLIGHT_PWR);
> + }
> +
> + static int am3517_evm_panel_enable_lcd(struct omap_dss_device
> *dssdev)
> + {
> + 	if (dvi_enabled) {
> + 		printk(KERN_ERR "cannot enable LCD, DVI is enabled\n");
> + 		return -EINVAL;
> + 	}
> + 	gpio_set_value(LCD_PANEL_PWR, 1);
> + 	lcd_enabled = 1;
> +
> + 	return 0;
> + }
> +
> + static void am3517_evm_panel_disable_lcd(struct omap_dss_device
> *dssdev)
> + {
> + 	gpio_set_value(LCD_PANEL_PWR, 0);
> + 	lcd_enabled = 0;
> + }
> +
> + static struct omap_dss_device am3517_evm_lcd_device = {
> + 	.type			= OMAP_DISPLAY_TYPE_DPI,
> + 	.name			= "lcd",
> + 	.driver_name		= "sharp_lq_panel",
> + 	.phy.dpi.data_lines 	= 16,
> + 	.platform_enable	= am3517_evm_panel_enable_lcd,
> + 	.platform_disable	= am3517_evm_panel_disable_lcd,
> + };
> +
> + static int am3517_evm_panel_enable_tv(struct omap_dss_device
> *dssdev)
> + {
> + 	return 0;
> + }
> +
> + static void am3517_evm_panel_disable_tv(struct omap_dss_device
> *dssdev)
> + {
> + }
> +
> + static struct omap_dss_device am3517_evm_tv_device = {
> + 	.type 			= OMAP_DISPLAY_TYPE_VENC,
> + 	.name 			= "tv",
> + 	.driver_name		= "venc",
> + 	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
> + 	.platform_enable	= am3517_evm_panel_enable_tv,
> + 	.platform_disable	= am3517_evm_panel_disable_tv,
> + };
> +
> + static int am3517_evm_panel_enable_dvi(struct omap_dss_device
> *dssdev)
> + {
> + 	if (lcd_enabled) {
> + 		printk(KERN_ERR "cannot enable DVI, LCD is enabled\n");
> + 		return -EINVAL;
> + 	}
> + 	dvi_enabled = 1;
> +
> + 	return 0;
> + }
> +
> + static void am3517_evm_panel_disable_dvi(struct omap_dss_device
> *dssdev)
> + {
> + 	dvi_enabled = 0;
> + }
> +
> + static struct omap_dss_device am3517_evm_dvi_device = {
> + 	.type			= OMAP_DISPLAY_TYPE_DPI,
> + 	.name			= "dvi",
> + 	.driver_name		= "generic_panel",
> + 	.phy.dpi.data_lines	= 24,
> + 	.platform_enable	= am3517_evm_panel_enable_dvi,
> + 	.platform_disable	= am3517_evm_panel_disable_dvi,
> + };
> +
> + static struct omap_dss_device *am3517_evm_dss_devices[] = {
> + 	&am3517_evm_lcd_device,
> + 	&am3517_evm_tv_device,
> + 	&am3517_evm_dvi_device,
> + };
> +
> + static struct omap_dss_board_info am3517_evm_dss_data = {
> + 	.num_devices	= ARRAY_SIZE(am3517_evm_dss_devices),
> + 	.devices	= am3517_evm_dss_devices,
> + 	.default_device	= &am3517_evm_lcd_device,
> + };
> +
> + struct platform_device am3517_evm_dss_device = {
> + 	.name		= "omapdss",
> + 	.id		= -1,
> + 	.dev		= {
> + 		.platform_data	= &am3517_evm_dss_data,
> + 	},
> + };
> +
>  +static int __init am3517_evm_i2c_init(void)
>  +{
>  +	omap_register_i2c_bus(1, 400, NULL, 0);
>  +	omap_register_i2c_bus(2, 400, NULL, 0);
>  +	omap_register_i2c_bus(3, 400, NULL, 0);
>  +
>  +	return 0;
>  +}
>  +
>   /*
>    * Board initialization
>    */
