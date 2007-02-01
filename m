Return-Path: <linux-kernel-owner+w=401wt.eu-S1422854AbXBANIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422854AbXBANIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422855AbXBANIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:08:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422854AbXBANIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:08:46 -0500
Date: Thu, 1 Feb 2007 13:08:45 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: [PATCH] fix frv headers_check
Message-ID: <20070201130844.GC10050@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a) registers.h is really needed there
b) include of asm-generic/termios should be under __KERNEL__
c) includes of asm-generic/{memory_model,page} should be under
__KERNEL (nothing in there that would work in userland)
d) a lot of stuff in ptrace.h should be under __KERNEL__.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/asm-frv/Kbuild    |    6 ++++++
 include/asm-frv/page.h    |    4 ++--
 include/asm-frv/ptrace.h  |    4 ++++
 include/asm-frv/termios.h |    2 ++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
index c68e168..966a983 100644
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -1 +1,7 @@
 include include/asm-generic/Kbuild.asm
+
+header-y += registers.h
+
+unifdef-y += termios.h
+unifdef-y += ptrace.h
+unifdef-y += page.h
diff --git a/include/asm-frv/page.h b/include/asm-frv/page.h
index 134cc0c..213d92f 100644
--- a/include/asm-frv/page.h
+++ b/include/asm-frv/page.h
@@ -76,8 +76,6 @@ extern unsigned long max_pfn;
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
-
 #ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
 #define WANT_PAGE_VIRTUAL	1
 #endif
@@ -85,4 +83,6 @@ extern unsigned long max_pfn;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_PAGE_H */
diff --git a/include/asm-frv/ptrace.h b/include/asm-frv/ptrace.h
index 9a2241b..cf69340 100644
--- a/include/asm-frv/ptrace.h
+++ b/include/asm-frv/ptrace.h
@@ -12,9 +12,11 @@
 #define _ASM_PTRACE_H
 
 #include <asm/registers.h>
+#ifdef __KERNEL__
 #include <asm/irq_regs.h>
 
 #define in_syscall(regs) (((regs)->tbr & TBR_TT) == TBR_TT_TRAP0)
+#endif
 
 
 #define PT_PSR		0
@@ -60,6 +62,7 @@
 #define PTRACE_GETFDPIC_EXEC	0	/* [addr] request the executable loadmap */
 #define PTRACE_GETFDPIC_INTERP	1	/* [addr] request the interpreter loadmap */
 
+#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 /*
@@ -74,6 +77,7 @@ register struct pt_regs *__frame asm("gr28");
 extern unsigned long user_stack(const struct pt_regs *);
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
+#endif
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_PTRACE_H */
diff --git a/include/asm-frv/termios.h b/include/asm-frv/termios.h
index b4a664e..8840cf9 100644
--- a/include/asm-frv/termios.h
+++ b/include/asm-frv/termios.h
@@ -69,6 +69,8 @@ struct termio {
 #define N_SYNC_PPP	14
 #define N_HCI		15  /* Bluetooth HCI UART */
 
+#ifdef __KERNEL__
 #include <asm-generic/termios.h>
+#endif
 
 #endif /* _ASM_TERMIOS_H */
-- 
1.5.0-rc2.GIT


