Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYKPKjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYKPKjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKPKj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:39:27 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36594 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYKPKj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:39:27 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Fix writing to trace/trace_options
Date: Sun, 16 Nov 2008 16:07:58 +0530
Message-Id: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writing to trace/trace_options use the index of the array
to find the value of the flag. With branch tracer flag
defined conditionally, this breaks writing to trace_options
with branch tracer disabled.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 kernel/trace/trace.c |    2 --
 kernel/trace/trace.h |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 004aafd..ef7fe15 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -259,9 +259,7 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"ftrace_preempt",
-#ifdef CONFIG_BRANCH_TRACER
 	"branch",
-#endif
 	"annotate",
 	"dump",
 	NULL
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b24d350..d048b63 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -481,9 +481,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
 	TRACE_ITER_PREEMPTONLY		= 0x800,
-#ifdef CONFIG_BRANCH_TRACER
 	TRACE_ITER_BRANCH		= 0x1000,
-#endif
 	TRACE_ITER_ANNOTATE		= 0x2000,
 	TRACE_ITER_DUMP			= 0x4000,
 };
-- 
tg: (e186e8e..) an/branch-tracer-fix.patch (depends on: an/ext4-ftrace-test.patch)
