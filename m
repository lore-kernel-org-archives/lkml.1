Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYK0Kxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYK0Kxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYK0Kd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:58 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:52200 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYK0KcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:24 -0500
Message-Id: <20081127103135.613738445@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 28/60] sclp vt220: fix compile warning
Content-Disposition: inline; filename=127-sclp-warnings.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

get rid of this one:

  CC      drivers/s390/char/sclp_vt220.o
drivers/s390/char/sclp_vt220.c:588: warning: '__sclp_vt220_flush_buffer' defined but not used

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp_vt220.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: quilt-2.6/drivers/s390/char/sclp_vt220.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/sclp_vt220.c
+++ quilt-2.6/drivers/s390/char/sclp_vt220.c
@@ -583,23 +583,6 @@ sclp_vt220_chars_in_buffer(struct tty_st
 	return count;
 }
 
-static void
-__sclp_vt220_flush_buffer(void)
-{
-	unsigned long flags;
-
-	sclp_vt220_emit_current();
-	spin_lock_irqsave(&sclp_vt220_lock, flags);
-	if (timer_pending(&sclp_vt220_timer))
-		del_timer(&sclp_vt220_timer);
-	while (sclp_vt220_outqueue_count > 0) {
-		spin_unlock_irqrestore(&sclp_vt220_lock, flags);
-		sclp_sync_wait();
-		spin_lock_irqsave(&sclp_vt220_lock, flags);
-	}
-	spin_unlock_irqrestore(&sclp_vt220_lock, flags);
-}
-
 /*
  * Pass on all buffers to the hardware. Return only when there are no more
  * buffers pending.
@@ -745,6 +728,22 @@ sclp_vt220_con_device(struct console *c,
 	return sclp_vt220_driver;
 }
 
+static void __sclp_vt220_flush_buffer(void)
+{
+	unsigned long flags;
+
+	sclp_vt220_emit_current();
+	spin_lock_irqsave(&sclp_vt220_lock, flags);
+	if (timer_pending(&sclp_vt220_timer))
+		del_timer(&sclp_vt220_timer);
+	while (sclp_vt220_outqueue_count > 0) {
+		spin_unlock_irqrestore(&sclp_vt220_lock, flags);
+		sclp_sync_wait();
+		spin_lock_irqsave(&sclp_vt220_lock, flags);
+	}
+	spin_unlock_irqrestore(&sclp_vt220_lock, flags);
+}
+
 static int
 sclp_vt220_notify(struct notifier_block *self,
 			  unsigned long event, void *data)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

