Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYCLNzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYCLNzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYCLNzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:55:21 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:35172 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYCLNzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:55:19 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Mark early_printk as asmlinkage
Date: Wed, 12 Mar 2008 14:53:54 +0100
Message-Id: <1205330034-28828-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205330034-28828-1-git-send-email-jirislaby@gmail.com>
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not explicitly marked as asmlinkage, but invoked from x86_32
startup code with parameters on stack.

No other architectures define early_printk and none of them are affected
by this change, since defines asmlinkage as empty token.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/early_printk.c |    2 +-
 include/linux/kernel.h         |    2 +-
 kernel/printk.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 643fd86..ff9e735 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -196,7 +196,7 @@ static struct console simnow_console = {
 static struct console *early_console = &early_vga_console;
 static int early_console_initialized;
 
-void early_printk(const char *fmt, ...)
+asmlinkage void early_printk(const char *fmt, ...)
 {
 	char buf[512];
 	int n;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7e68c07..c7d61a1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -210,7 +210,7 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 		{ return false; }
 #endif
 
-extern void __attribute__((format(printf, 1, 2)))
+extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
 
 unsigned long int_sqrt(unsigned long);
diff --git a/kernel/printk.c b/kernel/printk.c
index 3fb257c..951543d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -38,7 +38,7 @@
 /*
  * Architectures can override it:
  */
-void __attribute__((weak)) early_printk(const char *fmt, ...)
+void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 {
 }
 
-- 
1.5.4.1

