Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYEMQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYEMQxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbYEMQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:52:58 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47251 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbYEMQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:52:58 -0400
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH] m68knommu: add read_barrier_depends() and irqs_disabled_flags()
Date: Tue, 13 May 2008 18:52:44 +0200
Message-Id: <1210697565-3106-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
References: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/home/bigeasy/git/linux-2.6-ftrace/kernel/trace/trace.c: In function 'tracing_generic_entry_update':
/home/bigeasy/git/linux-2.6-ftrace/kernel/trace/trace.c:802: error: implicit declaration of function 'irqs_disabled_flags'
make[3]: *** [kernel/trace/trace.o] Error 1
/home/bigeasy/git/linux-2.6-ftrace/kernel/trace/ftrace.c: In function 'ftrace_list_func':
/home/bigeasy/git/linux-2.6-ftrace/kernel/trace/ftrace.c:61: error: implicit declaration of function 'read_barrier_depends'

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 include/asm-m68knommu/system.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-m68knommu/system.h b/include/asm-m68knommu/system.h
index 64c6443..40f49de 100644
--- a/include/asm-m68knommu/system.h
+++ b/include/asm-m68knommu/system.h
@@ -118,6 +118,8 @@ asmlinkage void resume(void);
 #define smp_read_barrier_depends()	do { } while(0)
 #endif
 
+#define read_barrier_depends()  ((void)0)
+
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 struct __xchg_dummy { unsigned long a[100]; };
@@ -310,4 +312,13 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 #endif
 #define arch_align_stack(x) (x)
 
+
+static inline int irqs_disabled_flags(unsigned long flags)
+{
+	if (flags & 0x0700)
+		return 0;
+	else
+		return 1;
+}
+
 #endif /* _M68KNOMMU_SYSTEM_H */
-- 
1.5.4.3

