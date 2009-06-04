Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZFDQYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZFDQYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZFDQTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:19:35 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56922 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZFDQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:19:10 -0400
Message-Id: <20090604161900.426173095@de.ibm.com>
References: <20090604161847.513682672@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 18:18:51 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/38] device irq power management
Content-Disposition: inline; filename=pm_genirq_buildfix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

On architectures without GENERIC_HARDIRQS there are no device irqs
to suspend or resume. Add an #ifdef to replace suspend_device_irqs()
and resume_device_irqs() with an empty inline function in that case.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/interrupt.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -183,9 +183,15 @@ extern void disable_irq(unsigned int irq
 extern void enable_irq(unsigned int irq);
 
 /* The following three functions are for the core kernel use only. */
+#ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
-#ifdef CONFIG_PM_SLEEP
+#else
+static inline void suspend_device_irqs(void) { }
+static inline void resume_device_irqs(void) { }
+#endif
+
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_GENERIC_HARDIRQS)
 extern int check_wakeup_irqs(void);
 #else
 static inline int check_wakeup_irqs(void) { return 0; }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

