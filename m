Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbYKWKjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbYKWKjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbYKWKjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:39:16 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:26452 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbYKWKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=G3y28eg5FeKZpHncCd/bQZzqk9xQ1U8CRiBfnlW2WulQUFR40sJP3dFrxyjN7uhv5q
         Kzp6nCSUpURj8QzoDxuC2yej9ag/obNCHgjwCW5x0oI+F58qm4l8oSWkzvK5W0GinMla
         acJ5ffi1ChEb2HCPqJBm8tGGcEOVoIB1WcH8c=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 3/3] tracing/stack-tracer: introduce CONFIG_USER_STACKTRACE_SUPPORT
Date: Sun, 23 Nov 2008 12:39:08 +0200
Message-Id: <1227436748-17075-3-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081123083740.GD30453@elte.hu>
References: <20081123085310.GF30453@elte.hu> <20081123083740.GD30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User stack tracing is just implemented for x86, but it is not x86 specific.
Introduce a generic config flag, that is currently enabled only for x86.
When other arches implements it, they will have to SELECT USER_STACKTRACE_SUPPORT

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 arch/x86/Kconfig           |    1 +
 include/linux/stacktrace.h |    2 +-
 kernel/trace/Kconfig       |    3 +++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7a146ba..e49a4fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -36,6 +36,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select USER_STACKTRACE_SUPPORT
 
 config ARCH_DEFCONFIG
 	string
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index fd42d68..1a8cecc 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -16,7 +16,7 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 
-#ifdef CONFIG_X86
+#ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
 #else
 # define save_stack_trace_user(trace)              do { } while (0)
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b8378fa..87fc34a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -3,6 +3,9 @@
 #  select HAVE_FUNCTION_TRACER:
 #
 
+config USER_STACKTRACE_SUPPORT
+	bool
+
 config NOP_TRACER
 	bool
 
-- 
1.5.6.5

