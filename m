Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZGUBqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZGUBqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZGUBqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:46:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZGUBqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:46:10 -0400
Message-Id: <20090721014609.442730161@goodmis.org>
References: <20090721014528.716901277@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Jul 2009 21:45:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 3/4] tracing: cleanup for tracing_trace_options_read()
Content-Disposition: inline; filename=0003-tracing-cleanup-for-tracing_trace_options_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

'\n' is already appended, and what we need is just an extra
space for the '\0'.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A3EED63.3090908@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..38a4a3e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2256,8 +2256,8 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and newline */
 	}
 
-	/* +2 for \n and \0 */
-	buf = kmalloc(len + 2, GFP_KERNEL);
+	/* +1 for \0 */
+	buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf) {
 		mutex_unlock(&trace_types_lock);
 		return -ENOMEM;
@@ -2280,7 +2280,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	}
 	mutex_unlock(&trace_types_lock);
 
-	WARN_ON(r >= len + 2);
+	WARN_ON(r >= len + 1);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 
-- 
1.6.3.3

-- 
