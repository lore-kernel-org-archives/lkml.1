Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZKAVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZKAVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZKAVJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:09:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:52852 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZKAVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q0flUIAsmuceuJ5KTOI8v/y/UdkXBD161hZbBjgkWsIAbiH8vP/mn11s0jKwuaYb6g
         X6PY88GC600oiTo1PvJhkd9ZvVPTPGBUV5sbhc4CdLR/Ofykyu3EAOiZ+83J3syF7OKr
         x0j7gbRQ9cOGnmmKeiqFwh9Fv2eo1Ai5/Ue08=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/6] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
Date: Sun,  1 Nov 2009 22:09:13 +0100
Message-Id: <1257109753-6464-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4AE55B1B.2030006@web.de>
References: <4AE55B1B.2030006@web.de>
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
index 91c3d0e..85ba332 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -370,7 +370,6 @@ int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
-#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
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

