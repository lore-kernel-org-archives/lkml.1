Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbXHWVid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbXHWVid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763382AbXHWViW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:22 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55542 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763390AbXHWViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:21 -0400
Date: Thu, 23 Aug 2007 17:38:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 7/7] UML - Eliminate floating point state from register file
Message-ID: <20070823213810.GA9120@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The floating point fields in the pt_regs register file aren't used, so
they are deleted.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/sysdep-i386/ptrace.h   |    2 --
 arch/um/include/sysdep-x86_64/ptrace.h |    1 -
 2 files changed, 3 deletions(-)

Index: linux-2.6.22/arch/um/include/sysdep-i386/ptrace.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-i386/ptrace.h	2007-08-23 15:05:36.000000000 -0400
+++ linux-2.6.22/arch/um/include/sysdep-i386/ptrace.h	2007-08-23 15:17:14.000000000 -0400
@@ -54,8 +54,6 @@ extern int sysemu_supported;
 
 struct uml_pt_regs {
 	unsigned long gp[MAX_REG_NR];
-	unsigned long fp[HOST_FP_SIZE];
-	unsigned long xfp[HOST_XFP_SIZE];
 	struct faultinfo faultinfo;
 	long syscall;
 	int is_user;
Index: linux-2.6.22/arch/um/include/sysdep-x86_64/ptrace.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-x86_64/ptrace.h	2007-08-23 15:05:36.000000000 -0400
+++ linux-2.6.22/arch/um/include/sysdep-x86_64/ptrace.h	2007-08-23 15:17:39.000000000 -0400
@@ -86,7 +86,6 @@
 
 struct uml_pt_regs {
 	unsigned long gp[MAX_REG_NR];
-	unsigned long fp[HOST_FP_SIZE];
 	struct faultinfo faultinfo;
 	long syscall;
 	int is_user;
