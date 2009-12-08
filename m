Return-Path: <linux-kernel-owner+w=401wt.eu-S966219AbZLHVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966219AbZLHVOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966212AbZLHVO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:14:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52226 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965987AbZLHVO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:14:27 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/5] spi-imx: correct check for platform_get_irq failing
Date: Tue,  8 Dec 2009 22:14:07 +0100
Message-Id: <1260306850-14945-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260306850-14945-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091208211258.GA13706@pengutronix.de>
 <1260306850-14945-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

platform_get_irq returns -ENXIO if there is no entry.  So don't check
return value being nonzero but greater or equal to zero.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index c83ca05..d8d9a35 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -554,7 +554,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 	}
 
 	spi_imx->irq = platform_get_irq(pdev, 0);
-	if (!spi_imx->irq) {
+	if (spi_imx->irq < 0) {
 		ret = -EINVAL;
 		goto out_iounmap;
 	}
-- 
1.6.5.2

