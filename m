Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZEHOCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZEHOCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZEHOBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:30 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58241 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757248AbZEHOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:29 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, Jim Paris <jim@jtan.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 03/15] ps3vram: Correct exchanged gotos in ps3vram_probe() error path
Date: Fri,  8 May 2009 16:01:12 +0200
Message-Id: <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
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
1.6.2.4

