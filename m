Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZIJI3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZIJI3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZIJI3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:29:47 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47880 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbZIJI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TEeUq6ZcOtxN47aFk8BbmxQ+oDaIQxpCezqC8FU5Bfvi6zGe8lfI/XdAtaVWdssBG2
         BTgDbsOE++WiROmlmYtTmFyzkb+t73xFAIBIIzEfR1791ixW/XZZ3V2BtRV4Mv1CcvvS
         wwSwjsdTBBtiC1YD/4MCj9EATRtAjJ48Em/UI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
Date: Thu, 10 Sep 2009 10:29:27 +0200
Message-Id: <1252571367-25876-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

The macro used to be used in both trace_selftest.c and
trace_ksym.c, but no longer, so remove it from header file.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h          |    1 -
 kernel/trace/trace_selftest.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea7e0bc..06b3a03 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -210,7 +210,6 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
-#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 struct ksym_trace_entry {
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 7179c12..a006f00 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -828,7 +828,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 
 	ksym_selftest_dummy = 0;
 	/* Register the read-write tracing request */
-	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
+	ret = process_new_ksym_entry("ksym_selftest_dummy", HW_BREAKPOINT_RW,
 					(unsigned long)(&ksym_selftest_dummy));
 
 	if (ret < 0) {
-- 
1.6.2.3

