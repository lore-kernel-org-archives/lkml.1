Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXGWCCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXGWCCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 22:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXGWCCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 22:02:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53656 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbXGWCC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 22:02:29 -0400
Date: Mon, 23 Jul 2007 12:02:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fault_inject: silence a warning
Message-Id: <20070723120246.af0d4df0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lib/fault-inject.c:168: warning: 'debugfs_create_ul_MAX_STACK_TRACE_DEPTH' defined but not used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 lib/fault-inject.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index b18fc2f..23985a2 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -139,12 +139,14 @@ static void debugfs_ul_set(void *data, u64 val)
 	*(unsigned long *)data = val;
 }
 
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
 {
 	*(unsigned long *)data =
 		val < MAX_STACK_TRACE_DEPTH ?
 		val : MAX_STACK_TRACE_DEPTH;
 }
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static u64 debugfs_ul_get(void *data)
 {
@@ -159,6 +161,7 @@ static struct dentry *debugfs_create_ul(const char *name, mode_t mode,
 	return debugfs_create_file(name, mode, parent, value, &fops_ul);
 }
 
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 DEFINE_SIMPLE_ATTRIBUTE(fops_ul_MAX_STACK_TRACE_DEPTH, debugfs_ul_get,
 			debugfs_ul_set_MAX_STACK_TRACE_DEPTH, "%llu\n");
 
@@ -169,6 +172,7 @@ static struct dentry *debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
 	return debugfs_create_file(name, mode, parent, value,
 				   &fops_ul_MAX_STACK_TRACE_DEPTH);
 }
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static void debugfs_atomic_t_set(void *data, u64 val)
 {
-- 
1.5.2.3

