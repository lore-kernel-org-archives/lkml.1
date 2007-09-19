Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbXISBbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbXISBbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXISBbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:31:42 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49031 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXISBbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:31:41 -0400
Date: Tue, 18 Sep 2007 21:31:23 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Fix registers.c build
Message-ID: <20070919013123.GA10822@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

uml-stop-saving-process-fp-state.patch broke the UML/x86_64 build.

On x86_64, sys/ptrace.h has to be included before asm/ptrace.h.
Otherwise, the defines in asm/ptrace.h will ruin the parse of
sys/ptrace.h - 
    asm/ptrace.h:
	#define PTRACE_GETREGS            12

    sys/ptrace.h:
	enum __ptrace_request
	{
	...
	   PTRACE_GETREGS = 12,
	...
	}

Also, errno.h was missing.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/sys-x86_64/registers.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.20/arch/um/os-Linux/sys-x86_64/registers.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/sys-x86_64/registers.c	2007-09-18 20:51:35.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/sys-x86_64/registers.c	2007-09-18 20:52:15.000000000 -0400
@@ -3,9 +3,10 @@
  * Licensed under the GPL
  */
 
+#include <errno.h>
+#include <sys/ptrace.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
-#include <sys/ptrace.h>
 #include "longjmp.h"
 #include "user.h"
