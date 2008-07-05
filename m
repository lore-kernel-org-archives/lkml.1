Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYGEJPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYGEJPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYGEJPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:15:03 -0400
Received: from [194.117.236.238] ([194.117.236.238]:41531 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYGEJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:15:01 -0400
Date: Sat, 5 Jul 2008 12:14:23 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi
Subject: [PATCH] Move _RET_IP_ and _THIS_IP_ to include/linux/kernel.h
Message-ID: <20080705121423.3a88d20f@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two macros are useful beyond lock debugging. Moved definitions from
include/linux/debug_locks.h to include/linux/kernel.h, so code that needs
them does not have to include the former, which would have been a less
intuitive choice of a header.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/debug_locks.h |   10 ++--------
 include/linux/kernel.h      |    3 +++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index f4a5871..4aaa4af 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_DEBUG_LOCKING_H
 #define __LINUX_DEBUG_LOCKING_H
 
+#include <linux/kernel.h>
+
 struct task_struct;
 
 extern int debug_locks;
@@ -11,14 +13,6 @@ extern int debug_locks_silent;
  */
 extern int debug_locks_off(void);
 
-/*
- * In the debug case we carry the caller's instruction pointer into
- * other functions, but we dont want the function argument overhead
- * in the nondebug case - hence these macros:
- */
-#define _RET_IP_		(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
-
 #define DEBUG_LOCKS_WARN_ON(c)						\
 ({									\
 	int __ret = 0;							\
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 792bf0a..2e70006 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -46,6 +46,9 @@ extern const char linux_proc_banner[];
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
+#define _RET_IP_		(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+
 #ifdef CONFIG_LBD
 # include <asm/div64.h>
 # define sector_div(a, b) do_div(a, b)
-- 
1.5.5.4
