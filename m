Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbXKNTWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbXKNTWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762761AbXKNTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:21:11 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44253 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXKNTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:21:08 -0500
Date: Wed, 14 Nov 2007 14:20:50 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 3/4] UML - Convert functions to void
Message-ID: <20071114192050.GA9088@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a few functions into returning void.
The return values were not used anyway, so I think it should not be a problem.
Also removed a little leftover bit from TT mode.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h        |    6 +-----
 arch/um/kernel/um_arch.c    |    5 ++---
 arch/um/os-Linux/start_up.c |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-11-14 13:29:47.000000000 -0500
+++ linux-2.6.22/arch/um/include/os.h	2007-11-14 13:42:32.000000000 -0500
@@ -167,14 +167,10 @@ extern int os_fchange_dir(int fd);
 
 /* start_up.c */
 extern void os_early_checks(void);
-extern int can_do_skas(void);
+extern void can_do_skas(void);
 extern void os_check_bugs(void);
 extern void check_host_supports_tls(int *supports_tls, int *tls_min);
 
-/* Make sure they are clear when running in TT mode. Required by
- * SEGV_MAYBE_FIXABLE */
-#define clear_can_do_skas() do { ptrace_faultinfo = proc_mm = 0; } while (0)
-
 /* mem.c */
 extern int create_mem_file(unsigned long long len);
 
Index: linux-2.6.22/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/um_arch.c	2007-11-14 13:29:47.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/um_arch.c	2007-11-14 13:42:32.000000000 -0500
@@ -198,7 +198,7 @@ __uml_setup("--help", Usage,
 "    Prints this message.\n\n"
 );
 
-static int __init uml_checksetup(char *line, int *add)
+static void __init uml_checksetup(char *line, int *add)
 {
 	struct uml_param *p;
 
@@ -208,10 +208,9 @@ static int __init uml_checksetup(char *l
 
 		n = strlen(p->str);
 		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
-			return 1;
+			return;
 		p++;
 	}
-	return 0;
 }
 
 static void __init uml_postsetup(void)
Index: linux-2.6.22/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/start_up.c	2007-11-14 13:29:47.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/start_up.c	2007-11-14 13:42:32.000000000 -0500
@@ -466,7 +466,7 @@ static inline void check_skas3_proc_mm(v
 	else non_fatal("found\n");
 }
 
-int can_do_skas(void)
+void can_do_skas(void)
 {
 	non_fatal("Checking for the skas3 patch in the host:\n");
 
@@ -476,8 +476,6 @@ int can_do_skas(void)
 
 	if (!proc_mm || !ptrace_faultinfo || !ptrace_ldt)
 		skas_needs_stub = 1;
-
-	return 1;
 }
 
 int __init parse_iomem(char *str, int *add)
