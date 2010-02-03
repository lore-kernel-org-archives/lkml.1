Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0BCE3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:29:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0BCE3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:29:50 -0500
Date: Wed, 3 Feb 2010 15:29:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grazvydas Ignotas <notasas@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20100203152947.f4955d91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-omap3pandora.c between commit
f8b6f704105164eac7c043a48f79c4234e03e4b2 ("omap: Rename hsmmc symbols to
reflect independence from twl4030") from the omap tree and commit
aacb4387a1e6f3b57977375532c6d8e47fcd5652 ("OMAP: pandora: add DSS2
support and related regulators") from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap3pandora.c
index 9967b5d,bd3e577..0000000
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@@ -192,7 -193,62 +193,62 @@@ static struct twl4030_keypad_data pando
  	.rep		= 1,
  };
  
+ static struct omap_dss_device pandora_lcd_device = {
+ 	.name			= "lcd",
+ 	.driver_name		= "tpo_td043mtea1_panel",
+ 	.type			= OMAP_DISPLAY_TYPE_DPI,
+ 	.phy.dpi.data_lines	= 24,
+ 	.reset_gpio		= 157,
+ };
+ 
+ static struct omap_dss_device pandora_tv_device = {
+ 	.name			= "tv",
+ 	.driver_name		= "venc",
+ 	.type			= OMAP_DISPLAY_TYPE_VENC,
+ 	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
+ };
+ 
+ static struct omap_dss_device *pandora_dss_devices[] = {
+ 	&pandora_lcd_device,
+ 	&pandora_tv_device,
+ };
+ 
+ static struct omap_dss_board_info pandora_dss_data = {
+ 	.num_devices	= ARRAY_SIZE(pandora_dss_devices),
+ 	.devices	= pandora_dss_devices,
+ 	.default_device	= &pandora_lcd_device,
+ };
+ 
+ static struct platform_device pandora_dss_device = {
+ 	.name		= "omapdss",
+ 	.id		= -1,
+ 	.dev		= {
+ 		.platform_data = &pandora_dss_data,
+ 	},
+ };
+ 
+ static struct regulator_consumer_supply pandora_vcc_lcd_supply = {
+ 	.supply		= "vcc",
+ 	.dev		= &pandora_lcd_device.dev,
+ };
+ 
+ static struct regulator_consumer_supply pandora_vdda_dac_supply = {
+ 	.supply		= "vdda_dac",
+ 	.dev		= &pandora_dss_device.dev,
+ };
+ 
+ static struct regulator_consumer_supply pandora_vdds_supplies[] = {
+ 	{
+ 		.supply		= "vdds_sdi",
+ 		.dev		= &pandora_dss_device.dev,
+ 	},
+ 	{
+ 		.supply		= "vdds_dsi",
+ 		.dev		= &pandora_dss_device.dev,
+ 	},
+ };
+ 
 -static struct twl4030_hsmmc_info omap3pandora_mmc[] = {
 +static struct omap2_hsmmc_info omap3pandora_mmc[] = {
  	{
  		.mmc		= 1,
  		.wires		= 4,
