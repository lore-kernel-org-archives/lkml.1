Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYITIAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYITIAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYITIAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:00:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYITIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:00:44 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] ftrace: mcount_addr defined but not used
Date: Sat, 20 Sep 2008 01:00:37 -0700
Message-Id: <1221897638-16272-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20080920061659.GF25713@elte.hu>
References: <20080920061659.GF25713@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DYNAMIC_FTRACE isn't used, neither is mcount_addr. This
patch eliminates that warning.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 kernel/trace/ftrace.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 89ed43b..f484909 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -37,14 +37,6 @@ int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
 /*
- * Since MCOUNT_ADDR may point to mcount itself, we do not want
- * to get it confused by reading a reference in the code as we
- * are parsing on objcopy output of text. Use a variable for
- * it instead.
- */
-static unsigned long mcount_addr = MCOUNT_ADDR;
-
-/*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
  */
@@ -178,6 +170,14 @@ static DEFINE_SPINLOCK(ftrace_hash_lock);
 #define ftrace_hash_unlock(flags) do { } while(0)
 #endif
 
+/*
+ * Since MCOUNT_ADDR may point to mcount itself, we do not want
+ * to get it confused by reading a reference in the code as we
+ * are parsing on objcopy output of text. Use a variable for
+ * it instead.
+ */
+static unsigned long mcount_addr = MCOUNT_ADDR;
+
 static struct task_struct *ftraced_task;
 
 enum {
-- 
1.6.0.2

