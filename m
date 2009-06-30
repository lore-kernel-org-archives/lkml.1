Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZF3LTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZF3LTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZF3LTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:19:10 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62203 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZF3LTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mFQOqfFwETjb3r9fl24HndT5YcIz2F4kvBkBFPFPr6GKGTvfOrKRf/RTDzogjxp0O3
         uZ0pw7OgWa1SjclMWrxrbfko5Ic8Xs7RqvbPCNy3xmB0Z2o45cu/ayKBKUytu/B717Ls
         rdd7jWQulTq/WDuWVLuEkGR2V6Gno6J9082g0=
From: Albin Tonnerre <albin.tonnerre@gmail.com>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, thomas.petazzoni@free-electrons.com,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH] Fix compile when CONFIG_SERIAL_ATMEL=Y and CONFIG_SERIAL_ATMEL_CONSOLE=N
Date: Tue, 30 Jun 2009 13:19:08 +0200
Message-Id: <1246360748-4884-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SERIAL_ATMEL_CONSOLE is disabled, ATMEL_CONSOLE_DEVICE is set to
NULL, and trying to access ATMEL_CONSOLE_DEVICE->flags in
atmel_serial_probe makes the compile fail. This fixes the issue by only
accessing it if CONFIG_SERIAL_ATMEL_CONSOLE is defined

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 drivers/serial/atmel_serial.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index aaab321..fbe7242 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1576,6 +1576,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add_port;
 
+#ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 	if (atmel_is_console_port(&port->uart)
 			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
 		/*
@@ -1584,6 +1585,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 		 */
 		clk_disable(port->clk);
 	}
+#endif
 
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
-- 
1.6.0.4

