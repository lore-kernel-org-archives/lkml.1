Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXFRGD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXFRGD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXFRGDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:03:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55633 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXFRGDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:03:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bryan.wu@analog.com, ak@suse.de
Subject: [patch] hide cond_syscall behind __KERNEL__ for Blackfin/x86_64
Date: Mon, 18 Jun 2007 02:03:54 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180203.55443.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This brings Blackfin and x86_64 into line with all other architectures by only
defining cond_syscall() when __KERNEL__ is defined.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index 4df8790..0df9f2d 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -369,7 +369,6 @@
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#endif
 
 /*
  * "Conditional" syscalls
@@ -379,4 +378,6 @@
  */
 #define cond_syscall(x) asm(".weak\t_" #x "\n\t.set\t_" #x ",_sys_ni_syscall");
 
+#endif	/* __KERNEL__ */
+
 #endif				/* __ASM_BFIN_UNISTD_H */
diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
index ae1ed05..f5d627c 100644
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -674,6 +674,7 @@ asmlinkage long sys_rt_sigaction(int sig,
 #endif	/* __KERNEL__ */
 #endif	/* __NO_STUBS */
 
+#ifdef __KERNEL__
 /*
  * "Conditional" syscalls
  *
@@ -681,5 +682,6 @@ asmlinkage long sys_rt_sigaction(int sig,
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_64_UNISTD_H_ */
