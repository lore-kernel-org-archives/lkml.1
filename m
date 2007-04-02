Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXDBQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXDBQyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbXDBQyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:54:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40620 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbXDBQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:54:16 -0400
Date: Mon, 2 Apr 2007 12:50:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - no locking needed in tls.c
Message-ID: <20070402165010.GA7611@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment the lack of locking on a couple of globals.

Also fix the formatting of __setup_host_supports_tls.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-i386/tls.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.21-mm/arch/um/sys-i386/tls.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/tls.c	2007-03-30 15:26:36.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/tls.c	2007-03-30 16:01:35.000000000 -0400
@@ -23,9 +23,13 @@
 #include "skas.h"
 #endif
 
-/* If needed we can detect when it's uninitialized. */
+/*
+ * If needed we can detect when it's uninitialized.
+ *
+ * These are initialized in an initcall and unchanged thereafter.
+ */
 static int host_supports_tls = -1;
-int host_gdt_entry_tls_min = -1;
+int host_gdt_entry_tls_min;
 
 #ifdef CONFIG_MODE_SKAS
 int do_set_thread_area_skas(struct user_desc *info)
@@ -361,7 +365,8 @@ out:
 
 /* XXX: This part is probably common to i386 and x86-64. Don't create a common
  * file for now, do that when implementing x86-64 support.*/
-static int __init __setup_host_supports_tls(void) {
+static int __init __setup_host_supports_tls(void)
+{
 	check_host_supports_tls(&host_supports_tls, &host_gdt_entry_tls_min);
 	if (host_supports_tls) {
 		printk(KERN_INFO "Host TLS support detected\n");
