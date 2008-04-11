Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYDKEqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYDKEqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYDKEqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:46:32 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:29455 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751228AbYDKEqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:46:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PDdYZkzvyXErM0Sn6RjdoK37f3BE/eUHQAzj4axAarRoPjK1rnfpPYJ/xn2vUPu9VrXsa8MjiUsRWaVUCMMtMX8etdyXPnfFlPKZ/3eJ87lt+Pgvk0DZF6qvFH2hkB4I4wMxZS7bRbRThxLt841d1q26ua+/NYurFGhpkx9Nw1E=  ;
X-YMail-OSG: fr0TbWUVM1lKr_B0za6mhDpnX3li_8DOEkr0wLGn4W5Wx6qC0gd82fFxsVTTfAH634Zo9nPnIg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [patch 2.6.25-rc8] mmc: fix platform driver hotplug/coldplug
Date: Thu, 10 Apr 2008 21:46:28 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804102146.29393.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable MMC host platform drivers, to re-enable auto loading.

Also, add missing owner declarations in driver init.

[ dbrownell@users.sourceforge.net: registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mmc/host/at91_mci.c |    1 +
 drivers/mmc/host/au1xmmc.c  |    2 ++
 drivers/mmc/host/imxmmc.c   |    2 ++
 drivers/mmc/host/omap.c     |    3 ++-
 drivers/mmc/host/pxamci.c   |    2 ++
 drivers/mmc/host/wbsd.c     |    1 +
 6 files changed, 10 insertions(+), 1 deletion(-)

--- g26.orig/drivers/mmc/host/at91_mci.c	2008-04-10 21:36:18.000000000 -0700
+++ g26/drivers/mmc/host/at91_mci.c	2008-04-10 21:36:50.000000000 -0700
@@ -1075,3 +1075,4 @@ module_exit(at91_mci_exit);
 MODULE_DESCRIPTION("AT91 Multimedia Card Interface driver");
 MODULE_AUTHOR("Nick Randell");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_mci");
--- g26.orig/drivers/mmc/host/au1xmmc.c	2008-04-10 21:36:18.000000000 -0700
+++ g26/drivers/mmc/host/au1xmmc.c	2008-04-10 21:40:36.000000000 -0700
@@ -998,6 +998,7 @@ static struct platform_driver au1xmmc_dr
 	.resume        = NULL,
 	.driver        = {
 		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -1018,5 +1019,6 @@ module_exit(au1xmmc_exit);
 MODULE_AUTHOR("Advanced Micro Devices, Inc");
 MODULE_DESCRIPTION("MMC/SD driver for the Alchemy Au1XXX");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:au1xxx-mmc");
 #endif
 
--- g26.orig/drivers/mmc/host/imxmmc.c	2008-04-10 21:36:18.000000000 -0700
+++ g26/drivers/mmc/host/imxmmc.c	2008-04-10 21:40:44.000000000 -0700
@@ -1128,6 +1128,7 @@ static struct platform_driver imxmci_dri
 	.resume		= imxmci_resume,
 	.driver		= {
 		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
 	}
 };
 
@@ -1147,3 +1148,4 @@ module_exit(imxmci_exit);
 MODULE_DESCRIPTION("i.MX Multimedia Card Interface Driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-mmc");
--- g26.orig/drivers/mmc/host/omap.c	2008-04-10 21:36:18.000000000 -0700
+++ g26/drivers/mmc/host/omap.c	2008-04-10 21:40:49.000000000 -0700
@@ -1255,6 +1255,7 @@ static struct platform_driver mmc_omap_d
 	.resume		= mmc_omap_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -1273,5 +1274,5 @@ module_exit(mmc_omap_exit);
 
 MODULE_DESCRIPTION("OMAP Multimedia Card driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("Juha Yrjölä");
--- g26.orig/drivers/mmc/host/pxamci.c	2008-04-10 21:36:18.000000000 -0700
+++ g26/drivers/mmc/host/pxamci.c	2008-04-10 21:40:53.000000000 -0700
@@ -693,6 +693,7 @@ static struct platform_driver pxamci_dri
 	.resume		= pxamci_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -711,3 +712,4 @@ module_exit(pxamci_exit);
 
 MODULE_DESCRIPTION("PXA Multimedia Card Interface Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-mci");
--- g26.orig/drivers/mmc/host/wbsd.c	2008-04-10 21:38:42.000000000 -0700
+++ g26/drivers/mmc/host/wbsd.c	2008-04-10 21:41:07.000000000 -0700
@@ -1948,6 +1948,7 @@ static struct platform_driver wbsd_drive
 	.resume		= wbsd_platform_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
 	},
 };
 
