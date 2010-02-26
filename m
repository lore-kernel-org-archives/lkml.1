Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966255Ab0BZViF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:38:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966230Ab0BZVhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:37:53 -0500
Date: Fri, 26 Feb 2010 16:37:30 -0500
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <4aefea222db757a76ca70f20b6165e5084b99e8e.1267214186.git.jbaron@redhat.com>
In-Reply-To: <cover.1267214186.git.jbaron@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com>
Subject: [PATCH 08/12] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add COMPAT_SYSCALL_DEFINE#N() macro define common compat syscalls that
are not arch specific. Prepends "compat_sys_" to the syscall name to identify
it.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cd7b959..241a19c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -228,6 +228,13 @@ struct perf_event_attr;
 #define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, arch_compat_sys_##name, __VA_ARGS__)
 #define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, arch_compat_sys_##name, __VA_ARGS__)
 
+#define COMPAT_SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, compat_sys_##name, __VA_ARGS__)
+#define COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, compat_sys_##name, __VA_ARGS__)
+
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
-- 
1.6.5.1

