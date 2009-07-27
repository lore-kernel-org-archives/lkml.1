Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZG0OSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZG0OSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZG0OSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:18:12 -0400
Received: from relay.atmel.no ([80.232.32.139]:59699 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZG0OSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:18:12 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: nicolas.ferre@atmel.com, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, Albin Tonnerre <albin.tonnerre@gmail.com>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] Fix compile when CONFIG_SERIAL_ATMEL=Y and CONFIG_SERIAL_ATMEL_CONSOLE=N
Date: Mon, 27 Jul 2009 16:17:55 +0200
Message-Id: <1248704275-14374-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albin Tonnerre <albin.tonnerre@gmail.com>

When SERIAL_ATMEL_CONSOLE is disabled, ATMEL_CONSOLE_DEVICE is set to
NULL, and trying to access ATMEL_CONSOLE_DEVICE->flags in
atmel_serial_probe makes the compile fail. This fixes the issue by only
accessing it if CONFIG_SERIAL_ATMEL_CONSOLE is defined

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 338b15c..607d43a 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1551,6 +1551,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add_port;
 
+#ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 	if (atmel_is_console_port(&port->uart)
 			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
 		/*
@@ -1559,6 +1560,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 		 */
 		clk_disable(port->clk);
 	}
+#endif
 
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
-- 
1.6.0.4

