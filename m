Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYFLQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYFLQ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYFLQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:29:13 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52295 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYFLQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:29:13 -0400
Date: Thu, 12 Jun 2008 12:28:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Remove include of asm/user.h
Message-ID: <20080612162841.GA8404@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I allowed an include of asm/user.h to sneak back in.  This patch
replaces it with sys/user.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/sys-i386/registers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/os-Linux/sys-i386/registers.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/sys-i386/registers.c	2008-06-10 11:42:06.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/sys-i386/registers.c	2008-06-10 11:55:54.000000000 -0400
@@ -6,7 +6,7 @@
 
 #include <errno.h>
 #include <sys/ptrace.h>
-#include <asm/user.h>
+#include <sys/user.h>
 #include "kern_constants.h"
 #include "longjmp.h"
 #include "user.h"
@@ -76,7 +76,7 @@ int put_fp_registers(int pid, unsigned l
 
 void arch_init_registers(int pid)
 {
-	struct user_fxsr_struct fpx_regs;
+	struct user_fpxregs_struct fpx_regs;
 	int err;
 
 	err = ptrace(PTRACE_GETFPXREGS, pid, 0, &fpx_regs);
