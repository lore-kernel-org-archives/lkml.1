Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbYEUAfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbYEUAfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765510AbYEUAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45315 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764970AbYEUAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:12 -0400
To: mchehab@infradead.org
Subject: [PATCH] cx18: direct dereferencing of iomem
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycFX-0004rc-RS@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/cx18/cx18-irq.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-irq.c b/drivers/media/video/cx18/cx18-irq.c
index 0590d71..25114a5 100644
--- a/drivers/media/video/cx18/cx18-irq.c
+++ b/drivers/media/video/cx18/cx18-irq.c
@@ -161,13 +161,15 @@ irqreturn_t cx18_irq_handler(int irq, void *dev_id)
 	*/
 
 	if (sw2) {
-		if (sw2 & (cx->scb->cpu2hpu_irq_ack | cx->scb->cpu2epu_irq_ack))
+		if (sw2 & (readl(&cx->scb->cpu2hpu_irq_ack) |
+			   readl(&cx->scb->cpu2epu_irq_ack)))
 			wake_up(&cx->mb_cpu_waitq);
-		if (sw2 & (cx->scb->apu2hpu_irq_ack | cx->scb->apu2epu_irq_ack))
+		if (sw2 & (readl(&cx->scb->apu2hpu_irq_ack) |
+			   readl(&cx->scb->apu2epu_irq_ack)))
 			wake_up(&cx->mb_apu_waitq);
-		if (sw2 & cx->scb->epu2hpu_irq_ack)
+		if (sw2 & readl(&cx->scb->epu2hpu_irq_ack))
 			wake_up(&cx->mb_epu_waitq);
-		if (sw2 & cx->scb->hpu2epu_irq_ack)
+		if (sw2 & readl(&cx->scb->hpu2epu_irq_ack))
 			wake_up(&cx->mb_hpu_waitq);
 	}
 
-- 
1.5.3.GIT


