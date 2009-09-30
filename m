Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZI3Toz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZI3Toz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZI3Tox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:44:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37047 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbZI3Tov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:44:51 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2/7] spi-imx: update state correctly
Date: Wed, 30 Sep 2009 21:43:29 +0200
Message-Id: <1254339814-21506-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
 <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/spi/spi_imx.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index b1f530f..a8f9bff 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -443,6 +443,13 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	config.speed_hz  = t ? t->speed_hz : spi->max_speed_hz;
 	config.mode = spi->mode;
 
+	if (!config.speed_hz)
+		config.speed_hz = spi->max_speed_hz;
+	if (!config.bpw)
+		config.bpw = spi->bits_per_word;
+	if (!config.speed_hz)
+		config.speed_hz = spi->max_speed_hz;
+
 	spi_imx->config(spi_imx, &config);
 
 	return 0;
-- 
1.6.4.3

