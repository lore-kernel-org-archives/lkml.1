Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYFVOVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYFVOVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYFVOUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39302 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYFVOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:10 -0400
To: mchehab@infradead.org
Subject: [PATCH] bt8xx endianness annotations and fixes
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQL-00021d-Io@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:20:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/bt8xx/bt878.h         |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/bt878.h b/drivers/media/dvb/bt8xx/bt878.h
index 375fd28..d19b592 100644
--- a/drivers/media/dvb/bt8xx/bt878.h
+++ b/drivers/media/dvb/bt8xx/bt878.h
@@ -128,7 +128,7 @@ struct bt878 {
 	dma_addr_t buf_dma;
 
 	u32 risc_size;
-	u32 *risc_cpu;
+	__le32 *risc_cpu;
 	dma_addr_t risc_dma;
 	u32 risc_pos;
 
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 0165aac..4c5e528 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3705,7 +3705,7 @@ static void bttv_risc_disasm(struct bttv *btv,
 	for (i = 0; i < (risc->size >> 2); i += n) {
 		printk("%s:   0x%lx: ", btv->c.name,
 		       (unsigned long)(risc->dma + (i<<2)));
-		n = bttv_risc_decode(risc->cpu[i]);
+		n = bttv_risc_decode(le32_to_cpu(risc->cpu[i]));
 		for (j = 1; j < n; j++)
 			printk("%s:   0x%lx: 0x%08x [ arg #%d ]\n",
 			       btv->c.name, (unsigned long)(risc->dma + ((i+j)<<2)),
@@ -3774,8 +3774,8 @@ static void bttv_irq_debug_low_latency(struct bttv *btv, u32 rc)
 	printk("bttv%d: irq: skipped frame [main=%lx,o_vbi=%lx,o_field=%lx,rc=%lx]\n",
 	       btv->c.nr,
 	       (unsigned long)btv->main.dma,
-	       (unsigned long)btv->main.cpu[RISC_SLOT_O_VBI+1],
-	       (unsigned long)btv->main.cpu[RISC_SLOT_O_FIELD+1],
+	       (unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_VBI+1]),
+	       (unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_FIELD+1]),
 	       (unsigned long)rc);
 
 	if (0 == (btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC)) {
-- 
1.5.3.GIT


