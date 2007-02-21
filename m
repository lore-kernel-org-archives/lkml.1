Return-Path: <linux-kernel-owner+w=401wt.eu-S1423088AbXBUUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423088AbXBUUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXBUUdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:33:47 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59702 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1423101AbXBUUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:33:41 -0500
Message-Id: <200702212025.l1LKPJEA006774@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/4] UML - delete unused code
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Feb 2007 15:25:19 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of a bunch of unused stuff -
	cpu_feature had no users
	linux_prog is little-used, so its declaration is moved to the
user for easy deletion when the whole file goes away
	a long-unused debugging aid in helper.c is gone

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/kern_util.h |    1 -
 arch/um/include/user_util.h |    1 -
 arch/um/kernel/tt/gdb.c     |    2 ++
 arch/um/os-Linux/helper.c   |   11 -----------
 arch/um/os-Linux/main.c     |    8 +-------
 arch/um/sys-i386/bugs.c     |   23 -----------------------
 arch/um/sys-x86_64/bugs.c   |   23 -----------------------
 7 files changed, 3 insertions(+), 66 deletions(-)

Index: linux-2.6.17/arch/um/include/user_util.h
===================================================================
--- linux-2.6.17.orig/arch/um/include/user_util.h	2007-02-19 11:39:11.000000000 -0500
+++ linux-2.6.17/arch/um/include/user_util.h	2007-02-19 12:52:22.000000000 -0500
@@ -62,7 +62,6 @@ extern void kill_child_dead(int pid);
 extern int cont(int pid);
 extern void check_sigio(void);
 extern void arch_check_bugs(void);
-extern int cpu_feature(char *what, char *buf, int len);
 extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
 extern int arch_fixup(unsigned long address, void *sc_ptr);
 extern void arch_init_thread(void);
Index: linux-2.6.17/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-i386/bugs.c	2006-12-02 09:56:56.000000000 -0500
+++ linux-2.6.17/arch/um/sys-i386/bugs.c	2007-02-19 12:52:22.000000000 -0500
@@ -79,29 +79,6 @@ static int find_cpuinfo_line(int fd, cha
 	return(0);
 }
 
-int cpu_feature(char *what, char *buf, int len)
-{
-	int fd, ret = 0;
-
-	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open /proc/cpuinfo, err = %d\n", -fd);
-		return(0);
-	}
-
-	if(!find_cpuinfo_line(fd, what, buf, len)){
-		printk("Couldn't find '%s' line in /proc/cpuinfo\n", what);
-		goto out_close;
-	}
-
-	token(fd, buf, len, '\n');
-	ret = 1;
-
- out_close:
-	os_close_file(fd);
-	return(ret);
-}
-
 static int check_cpu_flag(char *feature, int *have_it)
 {
 	char buf[MAXTOKEN], c;
Index: linux-2.6.17/arch/um/sys-x86_64/bugs.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-x86_64/bugs.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.17/arch/um/sys-x86_64/bugs.c	2007-02-19 12:52:22.000000000 -0500
@@ -88,29 +88,6 @@ static int find_cpuinfo_line(int fd, cha
 	return(0);
 }
 
-int cpu_feature(char *what, char *buf, int len)
-{
-	int fd, ret = 0;
-
-	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Couldn't open /proc/cpuinfo, err = %d\n", -fd);
-		return(0);
-	}
-
-	if(!find_cpuinfo_line(fd, what, buf, len)){
-		printk("Couldn't find '%s' line in /proc/cpuinfo\n", what);
-		goto out_close;
-	}
-
-	token(fd, buf, len, '\n');
-	ret = 1;
-
- out_close:
-	os_close_file(fd);
-	return(ret);
-}
-
 /* Overrides for Emacs so that we follow Linus's tabbing style.
  * Emacs will notice this stuff at the end of the file and automatically
  * adjust the settings for this buffer only.  This must remain at the end
Index: linux-2.6.17/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.17.orig/arch/um/include/kern_util.h	2007-02-19 11:39:11.000000000 -0500
+++ linux-2.6.17/arch/um/include/kern_util.h	2007-02-19 12:52:22.000000000 -0500
@@ -23,7 +23,6 @@ struct kern_handlers {
 extern const struct kern_handlers handlinfo_kern;
 
 extern int ncpus;
-extern char *linux_prog;
 extern char *gdb_init;
 extern int kmalloc_ok;
 extern int jail;
Index: linux-2.6.17/arch/um/kernel/tt/gdb.c
===================================================================
--- linux-2.6.17.orig/arch/um/kernel/tt/gdb.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.17/arch/um/kernel/tt/gdb.c	2007-02-19 12:52:22.000000000 -0500
@@ -115,6 +115,8 @@ struct gdb_data {
 	int err;
 };
 
+extern char *linux_prog;
+
 static void config_gdb_cb(void *arg)
 {
 	struct gdb_data *data = arg;
Index: linux-2.6.17/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/main.c	2007-02-19 11:39:08.000000000 -0500
+++ linux-2.6.17/arch/um/os-Linux/main.c	2007-02-19 12:52:22.000000000 -0500
@@ -25,12 +25,7 @@
 #include "os.h"
 #include "um_malloc.h"
 
-/* Set in set_stklim, which is called from main and __wrap_malloc.
- * __wrap_malloc only calls it if main hasn't started.
- */
-unsigned long stacksizelim;
-
-/* Set in main */
+/* Set in main, unchanged thereafter */
 char *linux_prog;
 
 #define PGD_BOUND (4 * 1024 * 1024)
@@ -52,7 +47,6 @@ static void set_stklim(void)
 			exit(1);
 		}
 	}
-	stacksizelim = (lim.rlim_cur + PGD_BOUND - 1) & ~(PGD_BOUND - 1);
 }
 
 static __init void do_uml_initcalls(void)
Index: linux-2.6.17/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/helper.c	2007-02-19 11:39:05.000000000 -0500
+++ linux-2.6.17/arch/um/os-Linux/helper.c	2007-02-19 12:52:22.000000000 -0500
@@ -25,23 +25,12 @@ struct helper_data {
 	char *buf;
 };
 
-/* Debugging aid, changed only from gdb */
-int helper_pause = 0;
-
-static void helper_hup(int sig)
-{
-}
-
 static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
 	int errval;
 
-	if (helper_pause){
-		signal(SIGHUP, helper_hup);
-		pause();
-	}
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	errval = execvp_noalloc(data->buf, argv[0], argv);

