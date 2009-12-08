Return-Path: <linux-kernel-owner+w=401wt.eu-S966235AbZLHVOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966235AbZLHVOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966183AbZLHVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:14:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966176AbZLHVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:14:37 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/5] spi-imx: use positive logic to distinguish cpu variants
Date: Tue,  8 Dec 2009 22:14:08 +0100
Message-Id: <1260306850-14945-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260306850-14945-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091208211258.GA13706@pengutronix.de>
 <1260306850-14945-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260306850-14945-2-git-send-email-u.kleine-koenig@pengutronix.de>
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

This is much safer when support for new variants is added.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index d8d9a35..0ccbd1c 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -593,7 +593,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 	clk_enable(spi_imx->clk);
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk);
 
-	if (!cpu_is_mx31() || !cpu_is_mx35())
+	if (cpu_is_mx1() || cpu_is_mx21() || cpu_is_mx27())
 		writel(1, spi_imx->base + MXC_RESET);
 
 	/* drain receive buffer */
-- 
1.6.5.2

