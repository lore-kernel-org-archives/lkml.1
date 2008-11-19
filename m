Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYKSFgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYKSFgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYKSFgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:36:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYKSFgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:36:04 -0500
Message-Id: <20081119053603.049862475@goodmis.org>
References: <20081119053449.282336740@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 00:34:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: make filtered functions effective on setting
Content-Disposition: inline; filename=0002-ftrace-make-filtered-functions-effective-on-setting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix filter selection to apply when set

It can be confusing when the set_filter_functions is set (or cleared)
and the functions being recorded by the dynamic tracer does not
match.

This patch causes the code to be updated if the function tracer is
enabled and the filter is changed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dcac741..5cbddb5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1189,7 +1189,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_sysctl_lock);
 	mutex_lock(&ftrace_start_lock);
-	if (iter->filtered && ftrace_start && ftrace_enabled)
+	if (ftrace_start && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
-- 
1.5.6.5

-- 
