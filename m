Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXCUWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXCUWXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965373AbXCUWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:23:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37519 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965360AbXCUWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:23:41 -0400
Date: Wed, 21 Mar 2007 23:24:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/3] kbuild: exempt more syscalls from warnings, for x86_64 and ARM.
Message-ID: <20070321222400.GD22623@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321221905.GA22623@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321221905.GA22623@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 984d35ec37866c9b10c2193fcd1b1b5c6ee4c6cb Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 21 Mar 2007 11:20:51 +0000
Subject: [PATCH] kbuild: exempt more syscalls from warnings, for x86_64 and ARM.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 init/missing_syscalls.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/init/missing_syscalls.c b/init/missing_syscalls.c
index dc6b97d..0b7e7d2 100644
--- a/init/missing_syscalls.c
+++ b/init/missing_syscalls.c
@@ -15,6 +15,8 @@
 #define __IGNORE_fcntl64
 #define __IGNORE_fadvise64_64
 #define __IGNORE_fstatat64
+#define __IGNORE_fstatfs64
+#define __IGNORE_statfs64
 #endif
 
 /* i386-specific or historical system calls */
@@ -31,8 +33,6 @@
 #define __IGNORE_iopl
 #define __IGNORE_idle
 #define __IGNORE_modify_ldt
-#define __IGNORE_getpmsg
-#define __IGNORE_putpmsg
 #define __IGNORE_ugetrlimit
 #define __IGNORE_mmap2
 #define __IGNORE_vm86
@@ -46,6 +46,27 @@
 #define __IGNORE_oldolduname
 #define __IGNORE_olduname
 #define __IGNORE_umount2
+#define __IGNORE_umount
+#define __IGNORE_waitpid
+#define __IGNORE_stime
+#define __IGNORE_nice
+#define __IGNORE_signal
+#define __IGNORE_sigaction
+#define __IGNORE_sgetmask
+#define __IGNORE_sigsuspend
+#define __IGNORE_sigpending
+#define __IGNORE_readdir
+#define __IGNORE_socketcall
+#define __IGNORE_ipc
+#define __IGNORE_sigreturn
+#define __IGNORE_sigprocmask
+#define __IGNORE_bdflush
+#define __IGNORE__llseek
+#define __IGNORE__newselect
+#define __IGNORE_create_module
+#define __IGNORE_delete_module
+#define __IGNORE_query_module
+#define __IGNORE_get_kernel_syms
 /* ... including the "new" 32-bit uid syscalls */
 #define __IGNORE_lchown32
 #define __IGNORE_getuid32
@@ -67,7 +88,10 @@
 #define __IGNORE_setfsuid32
 #define __IGNORE_setfsgid32
 
-/* Not yet upstream */
+/* Unmerged syscalls for AFS, STREAMS, etc. */
+#define __IGNORE_afs_syscall
+#define __IGNORE_getpmsg
+#define __IGNORE_putpmsg
 #define __IGNORE_vserver
 
 #include "missing_syscalls.h"
-- 
1.4.4.2

