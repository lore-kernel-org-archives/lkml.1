Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXLLXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXLLXii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXLLXi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:38:29 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:59078 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXLLXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Py9JLdZyglyFLCNW4ymKP6VL0EVWxBrE+b2HSWRZvWHixJQ2cOAZsvTrj0VICfH9LUr1plV5ws8sXvU8+MzSPblDaNG4vLPvNhGzqhvhFG8Yve9TOvsjcc/MjmHopR5nr5BBh9TZxK8h8B3PTfyrVABs+//7u6x5VDiWWOEBFWQ=
Subject: [PATCH] misc: Removal of final callers using fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 15:38:26 -0800
Message-Id: <1197502706.21291.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall expands to empty everywhere, remove it.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, I'm not sure who is best to hit with these final dribs and
drabs removing fastcall.  Once all of these have hit Linus' tree
I will send a final patch deleting the include/linux/linkage.h
definitions as well as any remaining occurances.

 arch/powerpc/sysdev/uic.c |    2 +-
 arch/sparc64/kernel/irq.c |    2 +-
 include/asm-arm/mutex.h   |    6 +++---
 mm/page_alloc.c           |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 847a549..bbb6caf 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -188,7 +188,7 @@ static struct irq_chip uic_irq_chip = {
  * instead of the end, to keep the window in which we can miss an
  * interrupt as small as possible.
  */
-void fastcall handle_uic_irq(unsigned int irq, struct irq_desc *desc)
+void handle_uic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index 30431bd..5ec06c8 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -522,7 +522,7 @@ static struct irq_chip sun4v_virq = {
 	.set_affinity	= sun4v_virt_set_affinity,
 };
 
-static void fastcall pre_flow_handler(unsigned int virt_irq,
+static void pre_flow_handler(unsigned int virt_irq,
 				      struct irq_desc *desc)
 {
 	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
diff --git a/include/asm-arm/mutex.h b/include/asm-arm/mutex.h
index cb29d84..020bd98 100644
--- a/include/asm-arm/mutex.h
+++ b/include/asm-arm/mutex.h
@@ -24,7 +24,7 @@
  * reattempted until it succeeds.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res;
 
@@ -44,7 +44,7 @@ __mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
 }
 
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res;
 
@@ -70,7 +70,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *
  * better generated assembly.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	int __ex_flag, __res, __orig;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8206c4..a8b08f9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1440,7 +1440,7 @@ try_next_zone:
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page * fastcall
+struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
-- 
1.5.3.7.2212.gd092



