Return-Path: <linux-kernel-owner+w=401wt.eu-S938413AbXHIAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938413AbXHIAgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938093AbXHIAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:34:45 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:35352 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937952AbXHIAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:34:27 -0400
Message-Id: <20070809003344.165770372@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 20:32:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 7/7] Move lguest_dma_info into generic lg.h
Content-Disposition: inline; filename=0007-Move-lguest_dma_info-into-generic-lg.h.txt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The lguest_dma_info is also generic across architectures.
Move it to the generic lg.h

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/lguest/i386/lg.h |   11 -----------
 drivers/lguest/lg.h      |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
index c5ea14c..ae83bd2 100644
--- a/drivers/lguest/i386/lg.h
+++ b/drivers/lguest/i386/lg.h
@@ -49,17 +49,6 @@ int init_pagetables(struct page **switcher_page, unsigned int pages);
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
 #define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
 
-struct lguest_dma_info
-{
-	struct list_head list;
-	union futex_key key;
-	unsigned long dmas;
-	u16 next_dma;
-	u16 num_dmas;
-	u16 guestid;
-	u8 interrupt; 	/* 0 when not registered */
-};
-
 /*H:310 The page-table code owes a great debt of gratitude to Andi Kleen.  He
  * reviewed the original code which used "u32" for all page table entries, and
  * insisted that it would be far clearer with explicit typing.  I thought it
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 3147bf6..6057e3c 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -12,6 +12,17 @@ void release_all_dma(struct lguest *lg);
 unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
 			     unsigned long *interrupt);
 
+struct lguest_dma_info
+{
+	struct list_head list;
+	union futex_key key;
+	unsigned long dmas;
+	u16 next_dma;
+	u16 num_dmas;
+	u16 guestid;
+	u8 interrupt; 	/* 0 when not registered */
+};
+
 #ifdef CONFIG_X86_32
 #include "i386/lg.h"
 #endif
-- 
1.4.4.4

-- 
