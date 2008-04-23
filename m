Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYDWJ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYDWJ60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYDWJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46174 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbYDWJwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:30 -0400
Date: Wed, 23 Apr 2008 12:51:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc64: cleanup after SunOS/Solaris binary emulation
	removal
Message-ID: <20080423095151.GD28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following cleanups are now possible:
- arch/sparc64/kernel/entry.S:ret_sys_call no longer has to be global
- arch/sparc64/kernel/sparc64_ksyms.c:
  remove no longer used prototypes

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc64/kernel/entry.S         |    2 +-
 arch/sparc64/kernel/sparc64_ksyms.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

ca8093aa35d5765240c30a334109356831c04b5c diff --git a/arch/sparc64/kernel/entry.S b/arch/sparc64/kernel/entry.S
index fb43c76..f54cd2d 100644
--- a/arch/sparc64/kernel/entry.S
+++ b/arch/sparc64/kernel/entry.S
@@ -1559,7 +1559,7 @@ linux_sparc_syscall32:
 
 	/* Linux native system calls enter here... */
 	.align	32
-	.globl	linux_sparc_syscall, ret_sys_call
+	.globl	linux_sparc_syscall
 linux_sparc_syscall:
 	/* Direct access to user regs, much faster. */
 	cmp		%g1, NR_SYSCALLS			! IEU1	Group
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 3873646..6633659 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -68,8 +68,6 @@ extern void *__memscan_zero(void *, size_t);
 extern void *__memscan_generic(void *, int, size_t);
 extern int __memcmp(const void *, const void *, __kernel_size_t);
 extern __kernel_size_t strlen(const char *);
-extern void linux_sparc_syscall(void);
-extern void rtrap(void);
 extern void show_regs(struct pt_regs *);
 extern void syscall_trace(struct pt_regs *, int);
 extern void sys_sigsuspend(void);

