Return-Path: <linux-kernel-owner+w=401wt.eu-S940826AbXGaDzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940826AbXGaDzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936324AbXGaDz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:55:27 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58139 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901AbXGaDzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:55:25 -0400
Date: Tue, 31 Jul 2007 12:54:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Remove fs.h from mm.h
Message-ID: <20070731035442.GA32114@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
	akpm@osdl.org, linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729223613.GA5916@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 02:36:13AM +0400, Alexey Dobriyan wrote:
> 0) Remove fs.h from mm.h. For this,
> 1) Uninline vma_wants_writenotify(). It's pretty huge anyway.
> 2) Add back fs.h or less bloated headers (err.h) to files that need it.
> 
sh ended up breaking all over the place, and sh64 in a few others.
I'll roll the fixes in to my git trees, but here they are for reference.

--

 arch/sh/kernel/init_task.c         |    2 +-
 arch/sh/kernel/process.c           |    1 +
 arch/sh/kernel/sys_sh.c            |    1 +
 arch/sh/kernel/vsyscall/vsyscall.c |    1 +
 arch/sh/mm/pg-sh4.c                |    1 +
 arch/sh64/kernel/init_task.c       |    2 +-
 arch/sh64/kernel/process.c         |    1 +
 arch/sh64/kernel/sys_sh64.c        |    1 +
 arch/sh64/lib/dbg.c                |    1 +
 9 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/init_task.c b/arch/sh/kernel/init_task.c
index 44053ea..4b449c4 100644
--- a/arch/sh/kernel/init_task.c
+++ b/arch/sh/kernel/init_task.c
@@ -3,7 +3,7 @@
 #include <linux/sched.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
-
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index 6334a4c..44ebe06 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -18,6 +18,7 @@
 #include <linux/kdebug.h>
 #include <linux/tick.h>
 #include <linux/reboot.h>
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
diff --git a/arch/sh/kernel/sys_sh.c b/arch/sh/kernel/sys_sh.c
index 76b1bc7..024ce5d 100644
--- a/arch/sh/kernel/sys_sh.c
+++ b/arch/sh/kernel/sys_sh.c
@@ -21,6 +21,7 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/module.h>
+#include <linux/fs.h>
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
 #include <asm/ipc.h>
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 2aa9438..95f4de0 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/elf.h>
 #include <linux/sched.h>
+#include <linux/err.h>
 
 /*
  * Should the kernel map a VDSO page into processes and pass its
diff --git a/arch/sh/mm/pg-sh4.c b/arch/sh/mm/pg-sh4.c
index df69da9..f4810aa 100644
--- a/arch/sh/mm/pg-sh4.c
+++ b/arch/sh/mm/pg-sh4.c
@@ -8,6 +8,7 @@
  */
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/sh64/kernel/init_task.c b/arch/sh64/kernel/init_task.c
index de2d07d..deee8bf 100644
--- a/arch/sh64/kernel/init_task.c
+++ b/arch/sh64/kernel/init_task.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
-
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/sh64/kernel/process.c b/arch/sh64/kernel/process.c
index 1b89c9d..ceb9458 100644
--- a/arch/sh64/kernel/process.c
+++ b/arch/sh64/kernel/process.c
@@ -21,6 +21,7 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/ptrace.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
diff --git a/arch/sh64/kernel/sys_sh64.c b/arch/sh64/kernel/sys_sh64.c
index 19126da..b7f18e2 100644
--- a/arch/sh64/kernel/sys_sh64.c
+++ b/arch/sh64/kernel/sys_sh64.c
@@ -19,6 +19,7 @@
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
diff --git a/arch/sh64/lib/dbg.c b/arch/sh64/lib/dbg.c
index 4310fc8..97816e0 100644
--- a/arch/sh64/lib/dbg.c
+++ b/arch/sh64/lib/dbg.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/fs.h>
 #include <asm/mmu_context.h>
 
 typedef u64 regType_t;
