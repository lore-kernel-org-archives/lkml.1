Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbZDCNFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbZDCNFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZDCNFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:05:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55658 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbZDCNFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:05:42 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] ps3vram: Use proc_create_data() instead of proc_create()
Date: Fri,  3 Apr 2009 15:05:36 +0200
Message-Id: <1238763938-7076-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create_data() to avoid race conditions.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3vram.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 2e79d2c..6e73868 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -546,12 +546,10 @@ static void __devinit ps3vram_proc_init(struct ps3_system_bus_device *dev)
 	struct ps3vram_priv *priv = dev->core.driver_data;
 	struct proc_dir_entry *pde;
 
-	pde = proc_create(DEVICE_NAME, 0444, NULL, &ps3vram_proc_fops);
-	if (!pde) {
+	pde = proc_create_data(DEVICE_NAME, 0444, NULL, &ps3vram_proc_fops,
+			       priv);
+	if (!pde)
 		dev_warn(&dev->core, "failed to create /proc entry\n");
-		return;
-	}
-	pde->data = priv;
 }
 
 static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
-- 
1.6.0.4

