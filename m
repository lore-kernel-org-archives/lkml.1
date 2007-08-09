Return-Path: <linux-kernel-owner+w=401wt.eu-S938265AbXHIAi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938265AbXHIAi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938137AbXHIAet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:34:49 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:39576 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273AbXHIAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:34:33 -0400
Message-Id: <20070809003343.664528532@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 20:32:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 4/7] Moved the io struct up to the generic lg.h
Content-Disposition: inline; filename=0004-Moved-the-io-struct-up-to-the-generic-lg.h-file.-Also-added-a-proper-ifdef.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the io struct into the lg.h file since the io.c is generic to other
architectures.

Also added a proper ifdef for the generic lg.h.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/lguest/i386/lg.h |   11 ++---------
 drivers/lguest/lg.h      |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
index 64f0abe..c5ea14c 100644
--- a/drivers/lguest/i386/lg.h
+++ b/drivers/lguest/i386/lg.h
@@ -20,6 +20,8 @@
 #include <linux/err.h>
 #include <asm/semaphore.h>
 #include "irq_vectors.h"
+/* some files include this, some include the parent */
+#include "../lg.h"
 
 #define GUEST_PL 1
 
@@ -245,15 +247,6 @@ void pin_page(struct lguest *lg, unsigned long vaddr);
 int lguest_device_init(void);
 void lguest_device_remove(void);
 
-/* io.c: */
-void lguest_io_init(void);
-int bind_dma(struct lguest *lg,
-	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
-void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
-void release_all_dma(struct lguest *lg);
-unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
-			     unsigned long *interrupt);
-
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
 void write_timestamp(struct lguest *lg);
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 4c4356e..3147bf6 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -1,3 +1,19 @@
+#ifndef _LGUEST_LG_GENERIC
+#define _LGUEST_LG_GENERIC
+
+struct lguest;
+
+/* io.c: */
+void lguest_io_init(void);
+int bind_dma(struct lguest *lg,
+	     unsigned long key, unsigned long udma, u16 numdmas, u8 interrupt);
+void send_dma(struct lguest *info, unsigned long key, unsigned long udma);
+void release_all_dma(struct lguest *lg);
+unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
+			     unsigned long *interrupt);
+
 #ifdef CONFIG_X86_32
 #include "i386/lg.h"
 #endif
+
+#endif /* _LGUEST_LG_GENERIC */
-- 
1.4.4.4

-- 
