Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZFXLjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZFXLjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZFXLgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52697 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbZFXLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:35 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 19/20] omapfb: Add FB manual update option to Kconfig
Date: Wed, 24 Jun 2009 14:33:44 +0300
Message-Id: <01d9787f9f2fc8c74ea7da4bccba16366e5fa8bb.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <d724e13a36e386e87474ecc9f20fc8d07f22512d.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
 <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
 <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
 <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
 <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
 <b11909c54018be72619164782fcf3d6743d0fddd.1245842329.git.imre.deak@nokia.com>
 <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com>
 <f9ed866c0fe8112e1b18f2b90a52e41b23413982.1245842329.git.imre.deak@nokia.com>
 <d724e13a36e386e87474ecc9f20fc8d07f22512d.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:21.0419 (UTC) FILETIME=[FF3257B0:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also move the controller specific options up in the menu, to a more
logical spot.

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/Kconfig |   49 ++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index 2bffc07..551e3e9 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -32,6 +32,36 @@ config FB_OMAP_092M9R
 
 endchoice
 
+config FB_OMAP_LCDC_EXTERNAL
+	bool "External LCD controller support"
+	depends on FB_OMAP
+	help
+	  Say Y here, if you want to have support for boards with an
+	  external LCD controller connected to the SoSSI/RFBI interface.
+
+config FB_OMAP_LCDC_HWA742
+	bool "Epson HWA742 LCD controller support"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here if you want to have support for the external
+	  Epson HWA742 LCD controller.
+
+config FB_OMAP_LCDC_BLIZZARD
+	bool "Epson Blizzard LCD controller support"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here if you want to have support for the external
+	  Epson Blizzard LCD controller.
+
+config FB_OMAP_MANUAL_UPDATE
+	bool "Default to manual update mode"
+	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
+	help
+	  Say Y here, if your user-space applications are capable of
+	  notifying the frame buffer driver when a change has occured in
+	  the frame buffer content and thus a reload of the image data to
+	  the external frame buffer is required. If unsure, say N.
+
 config FB_OMAP_LCD_MIPID
 	bool "MIPI DBI-C/DCS compatible LCD support"
 	depends on FB_OMAP && SPI_MASTER
@@ -69,23 +99,4 @@ config FB_OMAP_DMA_TUNE
           answer yes. Answer no if you have a dedicated video
           memory, or don't use any of the accelerated features.
 
-config FB_OMAP_LCDC_EXTERNAL
-	bool "External LCD controller support"
-	depends on FB_OMAP
-	help
-	  Say Y here, if you want to have support for boards with an
-	  external LCD controller connected to the SoSSI/RFBI interface.
 
-config FB_OMAP_LCDC_HWA742
-	bool "Epson HWA742 LCD controller support"
-	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
-	help
-	  Say Y here if you want to have support for the external
-	  Epson HWA742 LCD controller.
-
-config FB_OMAP_LCDC_BLIZZARD
-	bool "Epson Blizzard LCD controller support"
-	depends on FB_OMAP && FB_OMAP_LCDC_EXTERNAL
-	help
-	  Say Y here if you want to have support for the external
-	  Epson Blizzard LCD controller.
-- 
1.6.3.2

