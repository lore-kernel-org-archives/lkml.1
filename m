Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYDWUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYDWUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYDWUzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:55:40 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44861 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYDWUzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:55:39 -0400
Message-ID: <480FA248.7080900@tiscali.nl>
Date: Wed, 23 Apr 2008 22:55:36 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] xilinx_spi: test below 0 on unsigned irq in xilinx_spi_probe()
References: <480F99D5.7070300@tiscali.nl>
In-Reply-To: <480F99D5.7070300@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

similarly,
---
xilinx_spi->irq is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index cf6aef3..613db82 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -353,11 +353,12 @@ static int __init xilinx_spi_probe(struct platform_device *dev)
 		goto put_master;
 	}
 
-	xspi->irq = platform_get_irq(dev, 0);
-	if (xspi->irq < 0) {
-		ret = -ENXIO;
+	ret = platform_get_irq(dev, 0);
+	if (ret < 0)
 		goto unmap_io;
-	}
+
+	xspi->irq = ret;
+	ret = 0;
 
 	master->bus_num = pdata->bus_num;
 	master->num_chipselect = pdata->num_chipselect;

