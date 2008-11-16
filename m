Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKPKmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKPKmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYKPKmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:42:01 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40583 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYKPKmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:42:00 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: Add new entry type TRACE_BIN_DUMP
Date: Sun, 16 Nov 2008 16:07:59 +0530
Message-Id: <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
In-Reply-To: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace dump_entry can be used to dump binary data from
kernel to userspace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 kernel/trace/trace.c |    8 ++++++++
 kernel/trace/trace.h |   11 +++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c0d1170..004aafd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2106,6 +2106,14 @@ static enum print_line_t print_dump_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_BIN_DUMP: {
+		struct dump_entry *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_putmem(s, field->buf, field->len);
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 358d2a6..b24d350 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -26,6 +26,7 @@ enum trace_type {
 	TRACE_BOOT_CALL,
 	TRACE_BOOT_RET,
 	TRACE_FN_RET,
+	TRACE_BIN_DUMP,
 
 	__TRACE_LAST_TYPE
 };
@@ -107,6 +108,15 @@ struct print_entry {
 	char			buf[];
 };
 
+/*
+ * bin dump entry:
+ */
+struct dump_entry {
+	struct trace_entry ent;
+	int     len;
+	char    buf[];
+};
+
 #define TRACE_OLD_SIZE		88
 
 struct trace_field_cont {
@@ -249,6 +259,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
 		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET);\
+		IF_ASSIGN(var, ent, struct dump_entry, TRACE_BIN_DUMP);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
-- 
tg: (b382bc2..) an/ftrace-bin-dump.patch (depends on: an/ftrace-dp-printk.patch)
