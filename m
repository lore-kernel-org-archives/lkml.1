Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZAIKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZAIKta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZAIKtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:49:18 -0500
Received: from ozlabs.org ([203.10.76.45]:44386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZAIKtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:49:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.11152.473597.634307@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:48:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/9] powerpc/perf_counter: Add perf_counter system call on powerpc
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... with an empty/dummy asm/perf_counter.h so it builds.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
new file mode 100644
index 0000000..59530ae
--- /dev/null
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -0,0 +1,10 @@
+/*
+ * Performance counter support - PowerPC-specific definitions.
+ *
+ * Copyright 2008-2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 803def2..da300c4 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -322,3 +322,4 @@ SYSCALL_SPU(epoll_create1)
 SYSCALL_SPU(dup3)
 SYSCALL_SPU(pipe2)
 SYSCALL(inotify_init1)
+SYSCALL(perf_counter_open)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index e07d0c7..7cef5af 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -341,10 +341,11 @@
 #define __NR_dup3		316
 #define __NR_pipe2		317
 #define __NR_inotify_init1	318
+#define __NR_perf_counter_open	319
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		319
+#define __NR_syscalls		320
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 3d0c776..94dd1fb 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,6 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
+	select HAVE_PERF_COUNTERS
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
