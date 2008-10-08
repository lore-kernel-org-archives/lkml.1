Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYJHC0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYJHC0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYJHC0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:26:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbYJHC0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:26:12 -0400
Message-ID: <48EC199D.40808@cn.fujitsu.com>
Date: Wed, 08 Oct 2008 10:23:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: remove 2 exported symbols
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__mark_empty_function() and marker_probe_cb_noarg()
should not be seen by outer code. this patch remove them.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/marker.h b/include/linux/marker.h
index 1290653..f4d4d28 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -132,12 +132,8 @@ static inline void __printf(1, 2) ___mark_check_format(const char *fmt, ...)
 			___mark_check_format(format, ## args);		\
 	} while (0)
 
-extern marker_probe_func __mark_empty_function;
-
 extern void marker_probe_cb(const struct marker *mdata,
 	void *call_private, ...);
-extern void marker_probe_cb_noarg(const struct marker *mdata,
-	void *call_private, ...);
 
 /*
  * Connect a probe to a marker.
diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..4440a09 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -81,11 +81,10 @@ static struct hlist_head marker_table[MARKER_TABLE_SIZE];
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-void __mark_empty_function(void *probe_private, void *call_private,
+static void __mark_empty_function(void *probe_private, void *call_private,
 	const char *fmt, va_list *args)
 {
 }
-EXPORT_SYMBOL_GPL(__mark_empty_function);
 
 /*
  * marker_probe_cb Callback that prepares the variable argument list for probes.
@@ -157,7 +156,7 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
  *
  * Should be connected to markers "MARK_NOARGS".
  */
-void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
+static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 {
 	va_list args;	/* not initialized */
 	char ptype;
@@ -197,7 +196,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 	}
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
 static void free_old_closure(struct rcu_head *head)
 {



