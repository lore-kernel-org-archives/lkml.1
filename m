Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZAERTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZAERTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZAERSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:18:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZAERSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:18:54 -0500
To: torvalds@linux-foundation.org
Subject: uml got broken by commit 30742d5c2277c325fb0e9d2d817d55a19995fe8f
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1LJt6K-0003T4-TN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 05 Jan 2009 17:18:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... if you revert a commit, revert the fixups elsewhere that had been
triggered by it.  Such as 8c56250f48347750c82ab18d98d647dcf99ca674
(lockdep, UML: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/system.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system.h
index ae5f94d..753346e 100644
--- a/arch/um/include/asm/system.h
+++ b/arch/um/include/asm/system.h
@@ -11,21 +11,21 @@ extern int get_signals(void);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define raw_local_save_flags(flags) do { typecheck(unsigned long, flags); \
+#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
 				     (flags) = get_signals(); } while(0)
-#define raw_local_irq_restore(flags) do { typecheck(unsigned long, flags); \
+#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
 				      set_signals(flags); } while(0)
 
-#define raw_local_irq_save(flags) do { raw_local_save_flags(flags); \
-                                   raw_local_irq_disable(); } while(0)
+#define local_irq_save(flags) do { local_save_flags(flags); \
+                                   local_irq_disable(); } while(0)
 
-#define raw_local_irq_enable() unblock_signals()
-#define raw_local_irq_disable() block_signals()
+#define local_irq_enable() unblock_signals()
+#define local_irq_disable() block_signals()
 
 #define irqs_disabled()                 \
 ({                                      \
         unsigned long flags;            \
-        raw_local_save_flags(flags);        \
+        local_save_flags(flags);        \
         (flags == 0);                   \
 })
 
-- 
1.5.6.5


