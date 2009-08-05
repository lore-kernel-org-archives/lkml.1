Return-Path: <linux-kernel-owner+w=401wt.eu-S933878AbZHEITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbZHEITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933838AbZHEITv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:38380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768AbZHEITt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:19:49 -0400
Date: Wed, 5 Aug 2009 08:19:25 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4A3EED63.3090908@cn.fujitsu.com>
References: <4A3EED63.3090908@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: cleanup for tracing_trace_options_read()
Message-ID: <tip-ff4e9da2330beb8d64498a513d3f9694e941b01a@git.kernel.org>
Git-Commit-ID: ff4e9da2330beb8d64498a513d3f9694e941b01a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 08:19:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff4e9da2330beb8d64498a513d3f9694e941b01a
Gitweb:     http://git.kernel.org/tip/ff4e9da2330beb8d64498a513d3f9694e941b01a
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 22 Jun 2009 10:33:07 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Jul 2009 12:02:09 -0400

tracing: cleanup for tracing_trace_options_read()

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
 
