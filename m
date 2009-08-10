Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZHJUzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZHJUzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZHJUzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:55:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZHJUzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:55:22 -0400
Date: Mon, 10 Aug 2009 16:53:11 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <e7d71aa48812ff5a51327e861193f9c8d783ae9f.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 12/12] convert x86_64 mmap and uname to use DEFINE_SYSCALL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of syscalls are not using 'DEFINE_SYSCALL'. I'm not sure why. Convert
x86_64 uname and mmap to use DEFINE_SYSCALL.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 arch/x86/kernel/sys_x86_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 6bc211a..45e00eb 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,9 +18,9 @@
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
-asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
-		unsigned long prot, unsigned long flags,
-		unsigned long fd, unsigned long off)
+SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off)
 {
 	long error;
 	struct file *file;
@@ -226,7 +226,7 @@ bottomup:
 }
 
 
-asmlinkage long sys_uname(struct new_utsname __user *name)
+SYSCALL_DEFINE1(uname, struct new_utsname __user *, name)
 {
 	int err;
 	down_read(&uts_sem);
-- 
1.6.2.5

