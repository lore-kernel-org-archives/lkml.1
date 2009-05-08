Return-Path: <linux-kernel-owner+w=401wt.eu-S1763540AbZEHOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763540AbZEHOHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbZEHOBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:40 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58249 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758704AbZEHOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:35 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jim Paris <jim@jtan.com>
Subject: [PATCH 14/15] ps3vram: Make ps3vram_priv.reports a void *
Date: Fri,  8 May 2009 16:01:23 +0200
Message-Id: <1241791284-11490-15-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-14-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-10-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-11-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-12-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-13-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-14-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can kill a cast.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jim Paris <jim@jtan.com>
---
 drivers/block/ps3vram.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 5f5b828..70f51ff 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -72,7 +72,7 @@ struct ps3vram_priv {
 	u64 memory_handle;
 	u64 context_handle;
 	u32 *ctrl;
-	u32 *reports;
+	void *reports;
 	u8 *xdr_buf;
 
 	u32 *fifo_base;
@@ -102,9 +102,9 @@ static char *size = "256M";
 module_param(size, charp, 0);
 MODULE_PARM_DESC(size, "memory size");
 
-static u32 *ps3vram_get_notifier(u32 *reports, int notifier)
+static u32 *ps3vram_get_notifier(void *reports, int notifier)
 {
-	return (void *)reports + DMA_NOTIFIER_OFFSET_BASE +
+	return reports + DMA_NOTIFIER_OFFSET_BASE +
 	       DMA_NOTIFIER_SIZE * notifier;
 }
 
-- 
1.6.2.4

