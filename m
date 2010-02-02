Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0BBVWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:22:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab0BBVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:22:13 -0500
Date: Tue, 2 Feb 2010 16:21:55 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Message-Id: <ce5ccbcc86e34954948239b17010c5537fb62917.1265142153.git.jbaron@redhat.com>
In-Reply-To: <cover.1265142153.git.jbaron@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com>
Subject: [PATCH 5/6] syscalls: add define syscall prefix macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new 'SYSCALL_PREFIX_DEFINE#()' style macro to include/linux/syscalls.h.
This allows us to create syscalls via:

SYSCALL_PREFIX_DEFINE1(32_, mmap, struct mmap_arg_struct __user *, arg);

The standard 'SYSCALL_DEFINE#()' macro forces 'sys_blah', but for the 32 compat
calls we want 'sys32_blah'.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 36af9db..8ddd27e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -210,6 +210,7 @@ struct perf_event_attr;
 	asmlinkage long sys_##sname(void)
 #else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
+#define SYSCALL_PREFIX_DEFINE0(pre, name)	   asmlinkage long sys_##name(void)
 #endif
 
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
@@ -219,6 +220,13 @@ struct perf_event_attr;
 #define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
+#define SYSCALL_PREFIX_DEFINE1(pre, name, ...) SYSCALL_DEFINEx(1, pre##name, __VA_ARGS__)
+#define SYSCALL_PREFIX_DEFINE2(pre, name, ...) SYSCALL_DEFINEx(2, pre##name, __VA_ARGS__)
+#define SYSCALL_PREFIX_DEFINE3(pre, name, ...) SYSCALL_DEFINEx(3, pre##name, __VA_ARGS__)
+#define SYSCALL_PREFIX_DEFINE4(pre, name, ...) SYSCALL_DEFINEx(4, pre##name, __VA_ARGS__)
+#define SYSCALL_PREFIX_DEFINE5(pre, name, ...) SYSCALL_DEFINEx(5, pre##name, __VA_ARGS__)
+#define SYSCALL_PREFIX_DEFINE6(pre, name, ...) SYSCALL_DEFINEx(6, pre##name, __VA_ARGS__)
+
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
-- 
1.6.5.1

