Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZI2BSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZI2BSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZI2BSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:18:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:45087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753832AbZI2BSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:18:08 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18BkR4ujjYBDYAuKhOP0AA5kcMISnnaNoifX3vjJP
	fi2WDaGvsT5WZ/
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] video/omap:  adding __init/__exit macros to various drivers
Date: Tue, 29 Sep 2009 03:18:06 +0200
User-Agent: KMail/1.9.10
Cc: kernel-janitors@vger.kernel.org, Imre Deak <imre.deak@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Jonathan McDowell <noodles@earth.li>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Mike Wege <ext-mike.wege@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290318.07309.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of the following drivers in media/omap:
drivers/video/omap/lcd_ams_delta.c
drivers/video/omap/lcd_mipid.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/omap/lcd_ams_delta.c
index 1f74399..319a9a2 100644
--- a/drivers/video/omap/lcd_ams_delta.c
+++ b/drivers/video/omap/lcd_ams_delta.c
@@ -123,12 +123,12 @@ struct platform_driver ams_delta_panel_driver = {
 	},
 };
 
-static int ams_delta_panel_drv_init(void)
+static int __init ams_delta_panel_drv_init(void)
 {
 	return platform_driver_register(&ams_delta_panel_driver);
 }
 
-static void ams_delta_panel_drv_cleanup(void)
+static void __exit ams_delta_panel_drv_cleanup(void)
 {
 	platform_driver_unregister(&ams_delta_panel_driver);
 }
diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
index 918ee89..d88a792 100644
--- a/drivers/video/omap/lcd_mipid.c
+++ b/drivers/video/omap/lcd_mipid.c
@@ -607,7 +607,7 @@ static struct spi_driver mipid_spi_driver = {
 	.remove	= __devexit_p(mipid_spi_remove),
 };
 
-static int mipid_drv_init(void)
+static int __init mipid_drv_init(void)
 {
 	spi_register_driver(&mipid_spi_driver);
 
@@ -615,7 +615,7 @@ static int mipid_drv_init(void)
 }
 module_init(mipid_drv_init);
 
-static void mipid_drv_cleanup(void)
+static void __exit mipid_drv_cleanup(void)
 {
 	spi_unregister_driver(&mipid_spi_driver);
 }
