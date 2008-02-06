Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYBFRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYBFRp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYBFRpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:45:13 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44496 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYBFRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:45:11 -0500
Date: Wed, 6 Feb 2008 12:44:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/5] UML - x86_64 should copy %fs during fork
Message-ID: <20080206174447.GA7856@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%fs needs to be copied from parent to child during fork.

Tidied up some whitespace while I was here.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-um/processor-x86_64.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-git/include/asm-um/processor-x86_64.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/processor-x86_64.h	2008-02-06 11:17:20.000000000 -0500
+++ linux-2.6-git/include/asm-um/processor-x86_64.h	2008-02-06 12:17:21.000000000 -0500
@@ -26,7 +26,7 @@ static inline void rep_nop(void)
 #define cpu_relax()   rep_nop()
 
 #define INIT_ARCH_THREAD { .debugregs  		= { [ 0 ... 7 ] = 0 }, \
-                           .debugregs_seq	= 0,			       \
+			   .debugregs_seq	= 0, \
 			   .fs			= 0, \
 			   .faultinfo		= { 0, 0, 0 } }
 
@@ -37,6 +37,7 @@ static inline void arch_flush_thread(str
 static inline void arch_copy_thread(struct arch_thread *from,
                                     struct arch_thread *to)
 {
+	to->fs = from->fs;
 }
 
 #include "asm/arch/user.h"
