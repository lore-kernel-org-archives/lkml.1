Return-Path: <linux-kernel-owner+w=401wt.eu-S965416AbXAWTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbXAWTfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965408AbXAWTe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:34:56 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33093 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXAWTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:54 -0500
Message-Id: <200701231927.l0NJRf91005348@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/7] UML - locking comments in memory and tempfile code
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:41 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Locking comments and emacs comment removal in the low-level memory and
temp file code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/tempfile.h |   10 ----------
 arch/um/kernel/mem.c       |    3 ++-
 arch/um/os-Linux/mem.c     |    7 +++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

Index: linux-2.6.18-mm/arch/um/include/tempfile.h
===================================================================
--- linux-2.6.18-mm.orig/arch/um/include/tempfile.h	2007-01-17 12:30:03.000000000 +1100
+++ linux-2.6.18-mm/arch/um/include/tempfile.h	2007-01-17 12:46:52.000000000 +1100
@@ -9,13 +9,3 @@
 extern int make_tempfile(const char *template, char **tempname, int do_unlink);
 
 #endif
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.18-mm/arch/um/os-Linux/mem.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/mem.c	2007-01-17 12:30:03.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/mem.c	2007-01-17 12:46:52.000000000 +1100
@@ -20,7 +20,13 @@
 
 #include <sys/param.h>
 
+/* Modified by which_tmpdir, which is called during early boot */
 static char *default_tmpdir = "/tmp";
+
+/*
+ *  Modified when creating the physical memory file and when checking
+ * the tmp filesystem for usability, both happening during early boot.
+ */
 static char *tempdir = NULL;
 
 static void __init find_tempdir(void)
@@ -83,6 +89,7 @@ static int next(int fd, char *buf, int s
 	return 1;
 }
 
+/* which_tmpdir is called only during early boot */
 static int checked_tmpdir = 0;
 
 /* Look for a tmpfs mounted at /dev/shm.  I couldn't find a cleaner
Index: linux-2.6.18-mm/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/mem.c	2007-01-17 12:44:39.000000000 +1100
+++ linux-2.6.18-mm/arch/um/kernel/mem.c	2007-01-17 12:47:42.000000000 +1100
@@ -24,8 +24,9 @@
 #include "init.h"
 #include "kern_constants.h"
 
-/* Changed during early boot */
+/* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
+/* allocated in paging_init and unchanged thereafter */
 unsigned long *empty_bad_page = NULL;
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 unsigned long long highmem;

