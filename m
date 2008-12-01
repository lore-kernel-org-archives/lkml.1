Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbYLAIQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbYLAIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYLAIQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:16:47 -0500
Received: from ozlabs.org ([203.10.76.45]:58542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYLAIQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:16:47 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:46:44 +1030
Subject: [PATCH 1/6] cpumask: make CONFIG_NR_CPUS always valid.
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011846.44406.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Currently we have NR_CPUS, which is 1 on UP, and CONFIG_NR_CPUS on
SMP.  If we make CONFIG_NR_CPUS always valid (and always 1 on !SMP),
we can skip the middleman.

This also allows us to find and check all the remaining NR_CPUS users.

To avoid breaking every arch, we cheat and do this for the moment
in the header if the arch doesn't.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/threads.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -r 329e9ec99074 include/linux/threads.h
--- a/include/linux/threads.h	Thu Oct 23 23:46:33 2008 +1100
+++ b/include/linux/threads.h	Thu Oct 23 23:50:50 2008 +1100
@@ -8,16 +8,16 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors.  Setting this smaller saves quite a
+ * bit of memory.  Use nr_cpu_ids instead of this except for static bitmaps.
  */
-#ifdef CONFIG_SMP
+#ifndef CONFIG_NR_CPUS
+/* FIXME: This should be fixed in the arch's Kconfig */
+#define CONFIG_NR_CPUS	1
+#endif
+
+/* Places which use this should consider cpumask_var_t. */
 #define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
-#endif
 
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 


