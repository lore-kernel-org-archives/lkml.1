Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZFVCdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZFVCdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZFVCcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:32:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59315 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZFVCcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:32:54 -0400
Message-ID: <4A3EED63.3090908@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 10:33:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: cleanup for tracing_trace_options_read()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'\n' is already appended, and what we need is just an extra
space for the '\0'.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 076fa6f..4c3f856 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2266,8 +2266,8 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and newline */
 	}
 
-	/* +2 for \n and \0 */
-	buf = kmalloc(len + 2, GFP_KERNEL);
+	/* +1 for \0 */
+	buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf) {
 		mutex_unlock(&trace_types_lock);
 		return -ENOMEM;
@@ -2290,7 +2290,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	}
 	mutex_unlock(&trace_types_lock);
 
-	WARN_ON(r >= len + 2);
+	WARN_ON(r >= len + 1);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 
-- 
1.6.1.2

