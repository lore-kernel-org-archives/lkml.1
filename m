Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbYJOG7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbYJOG7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 02:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYJOG6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 02:58:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYJOG6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 02:58:53 -0400
Message-ID: <48F5942A.2060705@cn.fujitsu.com>
Date: Wed, 15 Oct 2008 14:56:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip/tracing/markers] markers: remove exported symbol marker_probe_cb_noarg()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


marker_probe_cb_noarg() should not be seen by outer code.
this patch remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/marker.h b/include/linux/marker.h
index 38e32e7..4aca94a 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -137,8 +137,6 @@ extern marker_probe_func __mark_empty_function;
 
 extern void marker_probe_cb(const struct marker *mdata,
 	void *call_private, ...);
-extern void marker_probe_cb_noarg(const struct marker *mdata,
-	void *call_private, ...);
 
 /*
  * Connect a probe to a marker.
diff --git a/kernel/marker.c b/kernel/marker.c
index ef43c86..0f2a944 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
  *
  * Should be connected to markers "MARK_NOARGS".
  */
-void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
+static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 {
 	va_list args;	/* not initialized */
 	char ptype;
@@ -197,7 +197,6 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 	}
 	rcu_read_unlock_sched();
 }
-EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
 static void free_old_closure(struct rcu_head *head)
 {




