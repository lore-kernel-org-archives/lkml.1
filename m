Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYKOVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYKOVte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYKOVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYKOVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:00 -0500
Message-Id: <20081115214758.719124646@goodmis.org>
References: <20081115214705.363808961@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 15 Nov 2008 16:47:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: make filtered functions effective on setting
Content-Disposition: inline; filename=0005-ftrace-make-filtered-functions-effective-on-setting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: set filtered functions at time the filter is set

It can be confusing when the set_filter_functions is set (or cleared)
and the functions being recorded by the dynamic tracer does not
match.

This patch causes the code to be updated if the function tracer is
enabled and the filter is changed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3ef0ee6..80b1de3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1195,7 +1195,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_sysctl_lock);
 	mutex_lock(&ftrace_start_lock);
-	if (iter->filtered && ftrace_start_up && ftrace_enabled)
+	if (ftrace_start_up && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
-- 
1.5.6.5

-- 
