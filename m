Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYGUADE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYGUADE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYGUACu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:02:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:56706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbYGUACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:02:50 -0400
Subject: [PATCH 2/22] alpha: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net
In-Reply-To: <1216592798.3679.22.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 03:57:59 +0530
Message-Id: <1216592879.3679.24.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Declaring arch-dependent syscalls for alpha architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/alpha/kernel/signal.c   |    1 +
 include/asm-alpha/syscalls.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 410af4f..3cf9971 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/sigcontext.h>
diff --git a/include/asm-alpha/syscalls.h b/include/asm-alpha/syscalls.h
index e69de29..eec7dc5 100644
--- a/include/asm-alpha/syscalls.h
+++ b/include/asm-alpha/syscalls.h
@@ -0,0 +1,21 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_APLHA_SYSCALLS_H
+#define _ASM_APLHA_SYSCALLS_H
+
+/* kernel/signal.c */
+asmlinkage long sys_rt_sigaction(int, const struct sigaction __user *,
+				 struct sigaction __user *, size_t,
+				 void __user *restorer);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+#endif /* _ASM_APLHA_SYSCALLS_H */
-- 
1.5.5.1



