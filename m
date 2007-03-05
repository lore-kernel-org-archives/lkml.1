Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXCEWvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXCEWvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXCEWu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:50:59 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49607 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXCEWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:50:44 -0500
Message-Id: <200703052241.l25MfL46008440@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 4/4] UML - Comment the initialization of a global
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 05 Mar 2007 17:41:21 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment the fact that sig_info is initialized early in boot, and thus doesn't
need any locking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/trap.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.18-mm/arch/um/os-Linux/trap.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/trap.c	2006-12-30 04:20:14.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/trap.c	2007-01-16 10:38:21.000000000 +1100
@@ -16,6 +16,7 @@ void usr2_handler(int sig, union uml_pt_
 	CHOOSE_MODE(syscall_handler_tt(sig, regs), (void) 0);
 }
 
+/* Initialized from linux_main() */
 void (*sig_info[NSIG])(int, union uml_pt_regs *);
 
 void os_fill_handlinfo(struct kern_handlers h)

