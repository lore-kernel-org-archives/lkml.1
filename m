Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZIVWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZIVWSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 18:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZIVWSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:18:36 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60001 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZIVWSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C/mSh5PXQgtwgGjBkzOUwDSr9BEfgVviTIMBrPA91DSMie6svaKzvzNTa36BxLRO24
         p5a7qV7EEdLjpV0xJIyncDox1Guo+uUquGmBCCV6hUGowNvO7fFhR+hzBcbpLnQVqNIQ
         xhIYPNo11n+jNYTskqG2SbSqlxSVhBXm8GTQ0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing/workqueue: Use %pf in workqueue trace events
Date: Wed, 23 Sep 2009 00:18:30 +0200
Message-Id: <1253657910-2536-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253657910-2536-1-git-send-email-fweisbec@gmail.com>
References: <1253657910-2536-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Using %pf instead of %pF supresses printing of the function offset
which will always be 0 in the case of worklet functions.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090922024033.GB31801@kryten>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index fcfd9a1..e4612db 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
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
 
-- 
1.6.2.3

