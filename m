Return-Path: <linux-kernel-owner+w=401wt.eu-S936921AbYD1SfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936921AbYD1SfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936463AbYD1SeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:34:24 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:47931 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966638AbYD1SeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=TBVMgx0y3OTkyfu0799/73Q6zqQ/Y2tRblIFtFRGc8wdDAleKd6gIWEwpeiHwUdksiKTN+g391lTMpqvZw+qCuVUoQGVd7IQDQusm2v7xpu8uCWwKmx4FFYBJOKLnydnzIVmQ+1E65zXfxTO2zQWxbl939mtFnEs40750AcKh2E=
Date: Mon, 28 Apr 2008 21:33:36 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mmiotrace: code style cleanups
Message-ID: <20080428213336.0b3661fa@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c2da03771e29159627c5c7b9509ec70bce9f91ee Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Mon, 28 Apr 2008 21:25:22 +0300
Subject: [PATCH] mmiotrace: code style cleanups

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c         |    4 ++--
 arch/x86/mm/mmio-mod.c      |    7 +++----
 arch/x86/mm/testmmiotrace.c |    2 +-
 include/linux/mmiotrace.h   |    6 +-----
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index b4287b7..40567d8 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -18,10 +18,10 @@
 #include <linux/percpu.h>
 #include <linux/kdebug.h>
 #include <linux/mutex.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/errno.h>
+#include <linux/errno.h>
 #include <asm/debugreg.h>
 #include <linux/mmiotrace.h>
 
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 1f77d85..a8d2a00 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -24,7 +24,7 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/version.h>
 #include <linux/kallsyms.h>
 #include <asm/pgtable.h>
@@ -418,11 +418,10 @@ static void enter_uniprocessor(void)
 
 	for_each_cpu_mask(cpu, downed_cpus) {
 		err = cpu_down(cpu);
-		if (!err) {
+		if (!err)
 			pr_info(NAME "CPU%d is down.\n", cpu);
-		} else {
+		else
 			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
-		}
 	}
 	if (num_online_cpus() > 1)
 		pr_warning(NAME "multiple CPUs still online, "
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index cfa60b2..d877c5b 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -2,7 +2,7 @@
  * Written by Pekka Paalanen, 2008 <pq@iki.fi>
  */
 #include <linux/module.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define MODULE_NAME "testmmiotrace"
 
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index dd6b64b..de8e912 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -1,9 +1,7 @@
 #ifndef MMIOTRACE_H
 #define MMIOTRACE_H
 
-#include <asm/types.h>
-
-#ifdef __KERNEL__
+#include <linux/types.h>
 
 #include <linux/list.h>
 
@@ -84,6 +82,4 @@ extern void disable_mmiotrace(void);
 extern void mmio_trace_rw(struct mmiotrace_rw *rw);
 extern void mmio_trace_mapping(struct mmiotrace_map *map);
 
-#endif /* __KERNEL__ */
-
 #endif /* MMIOTRACE_H */
-- 
1.5.3.7

