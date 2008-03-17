Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbYCQFBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbYCQFBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYCQFBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:01:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYCQFBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:01:25 -0400
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH] powerpc exec PT_DTRACE
X-Shopping-List: (1) Political burgers
   (2) Clerical bag lunches
   (3) Malicious breezes
   (4) Bestial retention aluminum
Message-Id: <20080317050120.8C9DC26F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 22:01:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PT_DTRACE flag is meaningless and obsolete.
Don't touch it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/process.c   |    5 -----
 arch/powerpc/kernel/sys_ppc32.c |    5 -----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 4846bf5..7c8e3da 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -862,11 +862,6 @@ int sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
 	flush_spe_to_thread(current);
 	error = do_execve(filename, (char __user * __user *) a1,
 			  (char __user * __user *) a2, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 4a4f5c6..9c3371e 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -368,11 +368,6 @@ long compat_sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
 
 	error = compat_do_execve(filename, compat_ptr(a1), compat_ptr(a2), regs);
 
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 
 out:
