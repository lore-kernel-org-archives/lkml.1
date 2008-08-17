Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYHQTuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYHQTuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYHQTui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:50:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50730 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYHQTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:50:37 -0400
Date: Sun, 17 Aug 2008 12:50:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, rostedt@goodmis.org, dvhltc@us.ibm.com,
       niv@us.ibm.com
Subject: [PATCH tip/cor/rcu] remove redundant ACCESS_ONCE definition from
	rcupreempt.c
Message-ID: <20080817195036.GA27585@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the redundant definition of ACCESS_ONCE() from rcupreempt.c in
favor of the one in compiler.h.  Also merge the comment header from
rcupreempt.c's definition into that in compiler.h.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/compiler.h |    4 +++-
 kernel/rcupreempt.c      |    8 --------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8bd2da..8322141 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -190,7 +190,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * ACCESS_ONCE() in different C statements.
  *
  * This macro does absolutely -nothing- to prevent the CPU from reordering,
- * merging, or refetching absolutely anything at any time.
+ * merging, or refetching absolutely anything at any time.  Its main intended
+ * use is to mediate communication between process-level code and irq/NMI
+ * handlers, all running on the same CPU.
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 2782793..ca4bbbe 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -59,14 +59,6 @@
 #include <linux/rcupreempt_trace.h>
 
 /*
- * Macro that prevents the compiler from reordering accesses, but does
- * absolutely -nothing- to prevent CPUs from reordering.  This is used
- * only to mediate communication between mainline code and hardware
- * interrupt and NMI handlers.
- */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
-/*
  * PREEMPT_RCU data structures.
  */
 
