Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXJ3RaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXJ3RaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJ3R3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:29:37 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43046 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXJ3R3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:29:36 -0400
Date: Tue, 30 Oct 2007 13:28:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 1/4] UML - Remove xmm checking on x86
Message-ID: <20071030172848.GA8356@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This patch removes some code which ran at every boot, but does not
seem to do anything anymore. Please test. It works for me but mistakes
can happen.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/sys-i386/bugs.c         |    3 ---
 include/asm-um/processor-i386.h |    1 -
 2 files changed, 4 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/bugs.c	2007-10-25 23:33:16.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/bugs.c	2007-10-26 12:31:25.000000000 -0400
@@ -15,7 +15,6 @@
 
 /* Set during early boot */
 int host_has_cmov = 1;
-int host_has_xmm = 0;
 
 static char token(int fd, char *buf, int len, char stop)
 {
@@ -163,8 +162,6 @@ void arch_check_bugs(void)
 	}
 	if (check_cpu_flag("cmov", &have_it))
 		host_has_cmov = have_it;
-	if (check_cpu_flag("xmm", &have_it))
-		host_has_xmm = have_it;
 }
 
 int arch_handle_signal(int sig, struct uml_pt_regs *regs)
Index: linux-2.6.22/include/asm-um/processor-i386.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-i386.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-um/processor-i386.h	2007-10-26 12:32:07.000000000 -0400
@@ -10,7 +10,6 @@
 #include "asm/host_ldt.h"
 #include "asm/segment.h"
 
-extern int host_has_xmm;
 extern int host_has_cmov;
 
 /* include faultinfo structure */
