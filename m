Return-Path: <linux-kernel-owner+w=401wt.eu-S966150AbZLHVPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966150AbZLHVPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966198AbZLHVOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:14:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60925 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966235AbZLHVOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:14:51 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Sascha Hauer <s.hauer@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] spi-imx: Add mx25 support
Date: Tue,  8 Dec 2009 22:14:09 +0100
Message-Id: <1260306850-14945-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260306850-14945-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091208211258.GA13706@pengutronix.de>
 <1260306850-14945-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260306850-14945-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260306850-14945-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/spi/spi_imx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 0ccbd1c..59b3a30 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -208,7 +208,7 @@ static int mx31_config(struct spi_imx_data *spi_imx,
 
 	if (cpu_is_mx31())
 		reg |= (config->bpw - 1) << MX31_CSPICTRL_BC_SHIFT;
-	else if (cpu_is_mx35()) {
+	else if (cpu_is_mx25() || cpu_is_mx35()) {
 		reg |= (config->bpw - 1) << MX35_CSPICTRL_BL_SHIFT;
 		reg |= MX31_CSPICTRL_SSCTL;
 	}
@@ -222,7 +222,7 @@ static int mx31_config(struct spi_imx_data *spi_imx,
 	if (config->cs < 0) {
 		if (cpu_is_mx31())
 			reg |= (config->cs + 32) << MX31_CSPICTRL_CS_SHIFT;
-		else if (cpu_is_mx35())
+		else if (cpu_is_mx25() || cpu_is_mx35())
 			reg |= (config->cs + 32) << MX35_CSPICTRL_CS_SHIFT;
 	}
 
@@ -565,7 +565,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
-	if (cpu_is_mx31() || cpu_is_mx35()) {
+	if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35()) {
 		spi_imx->intctrl = mx31_intctrl;
 		spi_imx->config = mx31_config;
 		spi_imx->trigger = mx31_trigger;
@@ -597,7 +597,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 		writel(1, spi_imx->base + MXC_RESET);
 
 	/* drain receive buffer */
-	if (cpu_is_mx31() || cpu_is_mx35())
+	if (cpu_is_mx25() || cpu_is_mx31() || cpu_is_mx35())
 		while (readl(spi_imx->base + MX3_CSPISTAT) & MX3_CSPISTAT_RR)
 			readl(spi_imx->base + MXC_CSPIRXDATA);
 
-- 
1.6.5.2

