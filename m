Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZDOGsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZDOGsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZDOGsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:48:10 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43807 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZDOGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:48:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/3] Char: cyclades, remove spurious check in ISR
Date: Wed, 15 Apr 2009 08:47:14 +0200
Message-Id: <1239778034-18099-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239778034-18099-1-git-send-email-jirislaby@gmail.com>
References: <1239778034-18099-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check if dev_id is NULL, it never is.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 6d52439..ccf68a9 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1737,14 +1737,6 @@ static irqreturn_t cyz_interrupt(int irq, void *dev_id)
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",
-									irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	if (unlikely(!ISZLOADED(*cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
 		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
-- 
1.6.2

