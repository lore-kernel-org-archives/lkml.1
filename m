Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbXIUUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbXIUUzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763306AbXIUUp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:33012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763377AbXIUUpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:16 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: vapier@gentoo.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [32/45] x86_64: hide cond_syscall behind __KERNEL__
Message-Id: <20070921204514.DF01414EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mike Frysinger <vapier@gentoo.org>

This brings x86_64 into line with all other architectures by only defining
cond_syscall() when __KERNEL__ is defined.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/unistd.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/include/asm-x86_64/unistd.h
===================================================================
--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -676,6 +676,7 @@ asmlinkage long sys_rt_sigaction(int sig
 #endif	/* __KERNEL__ */
 #endif	/* __NO_STUBS */
 
+#ifdef __KERNEL__
 /*
  * "Conditional" syscalls
  *
@@ -683,5 +684,6 @@ asmlinkage long sys_rt_sigaction(int sig
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif	/* __KERNEL__ */
 
 #endif /* _ASM_X86_64_UNISTD_H_ */
