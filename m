Return-Path: <linux-kernel-owner+w=401wt.eu-S936502AbXGMOji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936502AbXGMOji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936285AbXGMOi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:38:26 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50729 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761142AbXGMOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:38:24 -0400
Date: Fri, 13 Jul 2007 10:37:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Yan Zheng <yanzheng@21cn.com>, Alberto Bertogli <albertito@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] UML - Export hostfs symbols
Message-ID: <20070713143754.GA6239@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some exports for hostfs that are required after Alberto Bertogli's
fixes for accessing unlinked host files.

Also did some style cleanups while I was here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/user_syms.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6.17/arch/um/os-Linux/user_syms.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/user_syms.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/user_syms.c	2007-07-10 11:35:22.000000000 -0400
@@ -5,7 +5,8 @@
  * so I *must* declare good prototypes for them and then EXPORT them.
  * The kernel code uses the macro defined by include/linux/string.h,
  * so I undef macros; the userspace code does not include that and I
- * add an EXPORT for the glibc one.*/
+ * add an EXPORT for the glibc one.
+ */
 
 #undef strlen
 #undef strstr
@@ -61,12 +62,18 @@ EXPORT_SYMBOL_PROTO(dup2);
 EXPORT_SYMBOL_PROTO(__xstat);
 EXPORT_SYMBOL_PROTO(__lxstat);
 EXPORT_SYMBOL_PROTO(__lxstat64);
+EXPORT_SYMBOL_PROTO(__fxstat64);
 EXPORT_SYMBOL_PROTO(lseek);
 EXPORT_SYMBOL_PROTO(lseek64);
 EXPORT_SYMBOL_PROTO(chown);
+EXPORT_SYMBOL_PROTO(fchown);
 EXPORT_SYMBOL_PROTO(truncate);
+EXPORT_SYMBOL_PROTO(ftruncate64);
 EXPORT_SYMBOL_PROTO(utime);
+EXPORT_SYMBOL_PROTO(utimes);
+EXPORT_SYMBOL_PROTO(futimes);
 EXPORT_SYMBOL_PROTO(chmod);
+EXPORT_SYMBOL_PROTO(fchmod);
 EXPORT_SYMBOL_PROTO(rename);
 EXPORT_SYMBOL_PROTO(__xmknod);
 
@@ -102,14 +109,3 @@ EXPORT_SYMBOL(__stack_smash_handler);
 
 extern long __guard __attribute__((weak));
 EXPORT_SYMBOL(__guard);
-
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
