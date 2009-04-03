Return-Path: <linux-kernel-owner+w=401wt.eu-S1765105AbZDCNGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765105AbZDCNGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZDCNFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:05:44 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55667 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756612AbZDCNFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:05:43 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Jim Paris <jim@jtan.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] ps3vram: Correct exchanged gotos in ps3vram_probe() error path
Date: Fri,  3 Apr 2009 15:05:37 +0200
Message-Id: <1238763938-7076-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1238763938-7076-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1238763938-7076-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Paris <jim@jtan.com>

From: Jim Paris <jim@jtan.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3vram.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 6e73868..3c9ad19 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -635,7 +635,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	if (ps3_open_hv_device(dev)) {
 		dev_err(&dev->core, "ps3_open_hv_device failed\n");
 		error = -EAGAIN;
-		goto out_close_gpu;
+		goto out_free_xdr_buf;
 	}
 
 	/* Request memory */
@@ -659,7 +659,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 		dev_err(&dev->core, "lv1_gpu_memory_allocate failed %d\n",
 			status);
 		error = -ENOMEM;
-		goto out_free_xdr_buf;
+		goto out_close_gpu;
 	}
 
 	/* Request context */
-- 
1.6.0.4

