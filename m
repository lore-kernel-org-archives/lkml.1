Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXGJJYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXGJJYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbXGJJX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:23:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42317 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXGJJX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:23:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org
Subject: Re: [patch] hide cond_syscall behind __KERNEL__ for x86_64
Date: Tue, 10 Jul 2007 05:24:08 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, ak@suse.de
References: <200706180203.55443.vapier@gentoo.org>
In-Reply-To: <200706180203.55443.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707100524.08771.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This brings x86_64 into line with all other architectures by only defining
cond_syscall() when __KERNEL__ is defined.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
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
