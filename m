Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYFVOUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYFVOUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYFVOUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39281 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbYFVOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:00 -0400
To: mchehab@infradead.org
Subject: [PATCH] cx23885 endianness fixes
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQB-00020d-Ib@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:19:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/cx23885/cx23885-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index c4cc2f3..d17343e 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -291,9 +291,9 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
 		lines = 6;
 	BUG_ON(lines < 2);
 
-	cx_write(8 + 0, cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC) );
-	cx_write(8 + 4, cpu_to_le32(8) );
-	cx_write(8 + 8, cpu_to_le32(0) );
+	cx_write(8 + 0, RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
+	cx_write(8 + 4, 8);
+	cx_write(8 + 8, 0);
 
 	/* write CDT */
 	for (i = 0; i < lines; i++) {
@@ -408,11 +408,11 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 	       dev->name, risc->cpu, (unsigned long)risc->dma);
 	for (i = 0; i < (risc->size >> 2); i += n) {
 		printk("%s:   %04d: ", dev->name, i);
-		n = cx23885_risc_decode(risc->cpu[i]);
+		n = cx23885_risc_decode(le32_to_cpu(risc->cpu[i]));
 		for (j = 1; j < n; j++)
 			printk("%s:   %04d: 0x%08x [ arg #%d ]\n",
 			       dev->name, i + j, risc->cpu[i + j], j);
-		if (risc->cpu[i] == RISC_JUMP)
+		if (risc->cpu[i] == cpu_to_le32(RISC_JUMP))
 			break;
 	}
 }
-- 
1.5.3.GIT


