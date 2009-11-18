Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZKROxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZKROxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZKROxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:53:47 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51260 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbZKROwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:52:00 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 14/16] unistd: add __NR_[get|set]prlimit syscall numbers
Date: Wed, 18 Nov 2009 15:52:00 +0100
Message-Id: <1258555922-2064-14-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

Add __NR_[get|set]prlimit syscall numbers to asm-generic. Add them
also to asm-x86.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/unistd_32.h   |    4 +++-
 arch/x86/include/asm/unistd_64.h   |    4 ++++
 arch/x86/kernel/syscall_table_32.S |    2 ++
 include/asm-generic/unistd.h       |    6 +++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6fb3c20..06dbb34 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,10 +342,12 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_getprlimit		337
+#define __NR_setprlimit		338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 337
+#define NR_syscalls 339
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 8d3ad0a..48ea56c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -661,6 +661,10 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_getprlimit				299
+__SYSCALL(__NR_getprlimit, sys_getprlimit)
+#define __NR_setprlimit				300
+__SYSCALL(__NR_setprlimit, sys_setprlimit)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0157cd2..2dd45cd 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,5 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long sys_getprlimit
+	.long sys_setprlimit
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..950587d 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -622,9 +622,13 @@ __SYSCALL(__NR_move_pages, sys_move_pages)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open 241
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_getprlimit 242
+__SYSCALL(__NR_getprlimit, sys_getprlimit)
+#define __NR_setprlimit 243
+__SYSCALL(__NR_setprlimit, sys_setprlimit)
 
 #undef __NR_syscalls
-#define __NR_syscalls 242
+#define __NR_syscalls 244
 
 /*
  * All syscalls below here should go away really,
-- 
1.6.4.2

