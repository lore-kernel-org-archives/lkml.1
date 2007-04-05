Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbXDEQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbXDEQgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDEQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:36:20 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53390 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXDEQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:36:19 -0400
Date: Thu, 5 Apr 2007 12:31:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 2/4] UML - tidy process.c
Message-ID: <20070405163159.GA7117@c2.user-mode-linux.org>
References: <20070402165011.GA7616@c2.user-mode-linux.org> <200704031950.17109.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704031950.17109.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:50:16PM +0200, Blaisorblade wrote:
> Please, simply include uml-config.h and use just UML_CONFIG_MODE_TT.

okok :-)

	Jeff



Use only one ifdef to mark stack_sp as being tt mode only.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/kern_util.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/include/kern_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/kern_util.h	2007-04-03 13:14:38.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/kern_util.h	2007-04-05 12:24:36.000000000 -0400
@@ -8,6 +8,7 @@
 
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
+#include "uml-config.h"
 
 typedef void (*kern_hndl)(int, union uml_pt_regs *);
 
@@ -33,7 +34,7 @@ extern int nsyscalls;
 	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
 
 extern int kernel_fork(unsigned long flags, int (*fn)(void *), void * arg);
-#if defined(CONFIG_MODE_TT) || defined(UML_CONFIG_MODE_TT)
+#ifdef UML_CONFIG_MODE_TT
 extern unsigned long stack_sp(unsigned long page);
 #endif
 extern int kernel_thread_proc(void *data);
