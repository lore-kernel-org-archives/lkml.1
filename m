Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZIJBgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZIJBgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZIJBgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:36:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56701 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbZIJBgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:36:32 -0400
Message-ID: <4AA857D8.9020906@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 09:35:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro used to be used in both trace_selftest.c and
trace_ksym.c, but no longer, so remove it from header file.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h          |    1 -
 kernel/trace/trace_selftest.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 76ed0db..e6b1c73 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -202,7 +202,6 @@ struct syscall_trace_exit {
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
1.6.3
