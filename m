Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZIVCns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZIVCns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZIVCnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:43:46 -0400
Received: from ozlabs.org ([203.10.76.45]:59264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZIVCnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:43:45 -0400
Date: Tue, 22 Sep 2009 12:40:33 +1000
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tracing/workqueue: Use %pf in workqueue trace events
Message-ID: <20090922024033.GB31801@kryten>
References: <20090922023920.GA31801@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922023920.GA31801@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using %pf instead of %pF supresses printing of the function offset
which will always be 0.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/include/trace/events/workqueue.h
===================================================================
--- linux.trees.git.orig/include/trace/events/workqueue.h	2009-09-01 15:11:04.000000000 +1000
+++ linux.trees.git/include/trace/events/workqueue.h	2009-09-14 09:45:41.000000000 +1000
@@ -26,7 +26,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
@@ -48,7 +48,7 @@ TRACE_EVENT(workqueue_execution,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
