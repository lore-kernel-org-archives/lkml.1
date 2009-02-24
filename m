Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbZBXP6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbZBXP6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbZBXP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:57:47 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:44955 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758356AbZBXP5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:57:46 -0500
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [RFC PATCH 3/3] imx-uart: remove unused init()/exit() from
	platform_data
To: greg@kroah.com
Cc: s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2009 17:57:42 +0200
Message-ID: <20090224155742.28880.93198.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 arch/arm/mach-imx/include/mach/imx-uart.h |    2 --
 arch/arm/plat-mxc/include/mach/imx-uart.h |    2 --
 drivers/serial/imx.c                      |   12 ------------
 3 files changed, 0 insertions(+), 16 deletions(-)


diff --git a/arch/arm/mach-imx/include/mach/imx-uart.h b/arch/arm/mach-imx/include/mach/imx-uart.h
index d54eb1d..3a685e1 100644
--- a/arch/arm/mach-imx/include/mach/imx-uart.h
+++ b/arch/arm/mach-imx/include/mach/imx-uart.h
@@ -4,8 +4,6 @@
 #define IMXUART_HAVE_RTSCTS (1<<0)
 
 struct imxuart_platform_data {
-	int (*init)(struct platform_device *pdev);
-	void (*exit)(struct platform_device *pdev);
 	unsigned int flags;
 };
 
diff --git a/arch/arm/plat-mxc/include/mach/imx-uart.h b/arch/arm/plat-mxc/include/mach/imx-uart.h
index 599217b..a938eba 100644
--- a/arch/arm/plat-mxc/include/mach/imx-uart.h
+++ b/arch/arm/plat-mxc/include/mach/imx-uart.h
@@ -22,8 +22,6 @@
 #define IMXUART_HAVE_RTSCTS (1<<0)
 
 struct imxuart_platform_data {
-	int (*init)(struct platform_device *pdev);
-	int (*exit)(struct platform_device *pdev);
 	unsigned int flags;
 };
 
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index a509546..6e78a77 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1144,19 +1144,10 @@ static int serial_imx_probe(struct platform_device *pdev)
 	if(pdata && (pdata->flags & IMXUART_HAVE_RTSCTS))
 		sport->have_rtscts = 1;
 
-	if (pdata->init) {
-		ret = pdata->init(pdev);
-		if (ret)
-			goto clkput;
-	}
-
 	uart_add_one_port(&imx_reg, &sport->port);
 	platform_set_drvdata(pdev, &sport->port);
 
 	return 0;
-clkput:
-	clk_put(sport->clk);
-	clk_disable(sport->clk);
 unmap:
 	iounmap(sport->port.membase);
 free:
@@ -1181,9 +1172,6 @@ static int serial_imx_remove(struct platform_device *pdev)
 
 	clk_disable(sport->clk);
 
-	if (pdata->exit)
-		pdata->exit(pdev);
-
 	iounmap(sport->port.membase);
 	kfree(sport);
 

