Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYKWOwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYKWOwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 09:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYKWOv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 09:51:57 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:43474 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105AbYKWOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:51:56 -0500
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 09:51:56 EST
Subject: [PATCH] irq.h remove padding from irq_desc on 64bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 14:34:43 +0000
Message-Id: <1227450883.2970.11.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct irq_desc : reorder to remove padding on 64bits
    
shrinks irq_desc to 128 bytes which saves data space & cache lines

On a generic x86_64/SMP build this reduces the reported data size by
64k.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
This patch is against 2.628-rc6, built & tested on AMD 64x2 desktop.

regards
Richard


diff --git a/include/linux/irq.h b/include/linux/irq.h
index d058c57..838a977 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -142,8 +142,8 @@ struct irq_chip {
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
- * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @last_unhandled:	aging timer for unhandled count
+ * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
  * @cpu:		cpu index useful for balancing
@@ -165,8 +165,8 @@ struct irq_desc {
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
-	unsigned int		irqs_unhandled;
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
+	unsigned int		irqs_unhandled;
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_t		affinity;


