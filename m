Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXJ3J3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXJ3J3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXJ3J3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:29:44 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36575 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbXJ3J3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:29:43 -0400
Date: Tue, 30 Oct 2007 10:29:32 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/16] CRIS architecture: Correct compile errors
Message-ID: <20071030092932.GF11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing syscalls to cris architecture.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 arch/cris/arch-v10/kernel/entry.S |   36 +++++++++++++++++++++++++++++++++++
 include/asm-cris/unistd.h         |   39 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/arch/cris/arch-v10/kernel/entry.S linux-2.6.23/arch/cris/arch-v10/kernel/entry.S
--- clean_linux-2.6.23/arch/cris/arch-v10/kernel/entry.S	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/cris/arch-v10/kernel/entry.S	2007-10-17 11:15:19.000000000 +0200
@@ -1135,6 +891,42 @@
 	.long sys_add_key
 	.long sys_request_key
 	.long sys_keyctl
+	.long sys_ioprio_set
+	.long sys_ioprio_get		/* 290 */
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_migrate_pages
+	.long sys_openat		/* 295 */
+	.long sys_mkdirat
+	.long sys_mknodat
+	.long sys_fchownat
+	.long sys_futimesat
+	.long sys_fstatat64		/* 300 */
+	.long sys_unlinkat
+	.long sys_renameat
+	.long sys_linkat
+	.long sys_symlinkat
+	.long sys_readlinkat		/* 305 */
+	.long sys_fchmodat
+	.long sys_faccessat
+	.long sys_pselect6
+	.long sys_ppoll
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/include/asm-cris/unistd.h linux-2.6.23/include/asm-cris/unistd.h
--- clean_linux-2.6.23/include/asm-cris/unistd.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/unistd.h	2007-10-22 17:24:38.000000000 +0200
@@ -255,6 +255,7 @@
 #define __NR_io_submit		248
 #define __NR_io_cancel		249
 #define __NR_fadvise64		250
+/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
 #define __NR_exit_group		252
 #define __NR_lookup_dcookie	253
 #define __NR_epoll_create	254
@@ -292,10 +293,46 @@
 #define __NR_add_key		286
 #define __NR_request_key	287
 #define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316 
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd		322
+#define __NR_eventfd		323
+#define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 289
+#define NR_syscalls 325
 
 #include <asm/arch/unistd.h>
 
/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
