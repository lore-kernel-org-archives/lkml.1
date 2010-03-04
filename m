Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0CDQzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:55:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab0CDQy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:54:59 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB: mx1-camera: compile fix
Date: Thu,  4 Mar 2010 17:54:46 +0100
Message-Id: <1267721687-19697-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
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

This is a regression of

	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this went unnoticed up to now as mx1_defconfig doesn't include support
for mx1-camera.
I have a patch pending to change that though.

Best regards
Uwe

 drivers/media/video/mx1_camera.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 2ba14fb..38e5315 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -45,6 +45,9 @@
 #include <mach/hardware.h>
 #include <mach/mx1_camera.h>
 
+#undef DMA_BASE 
+#define DMA_BASE MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR)
+
 /*
  * CSI registers
  */
@@ -783,7 +786,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 			       pcdev);
 
 	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
-			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
+			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
 	/* burst length : 16 words = 64 bytes */
 	imx_dma_config_burstlen(pcdev->dma_chan, 0);
 
-- 
1.7.0

