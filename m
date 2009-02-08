Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZBHOSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZBHOSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZBHOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:18:45 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46087 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZBHOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=UhOv/FTWiaItYNgo91Y9O4uMIjxvyOW9aaViVRBK0clD60uDYpnLHZEPvVvT3IepyL
         7eklu71J7xQDlosEKMt8NvgNTyMUjgZsJEAn1+twC2HfOmq8hG7p4b8xYRc2mXeegFxC
         UPQZGz3wJvxovBrlAzmdWiYN6fbKv3qEBmJwg=
Message-ID: <498EE9C0.3010601@gmail.com>
Date: Sun, 08 Feb 2009 15:18:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi: limit reaches -1, tested 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement limit will reach -1 rather than 0,
so the warning will not be issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 269a55e..a4652f1 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -779,7 +779,7 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
-			while ((read(drv_data) == 0) && limit--);
+			while ((read(drv_data) == 0) && --limit);
 
 			if (limit == 0)
 				dev_err(&drv_data->pdev->dev,

