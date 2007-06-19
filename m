Return-Path: <linux-kernel-owner+w=401wt.eu-S1762441AbXFSSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762441AbXFSSnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbXFSSnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:43:16 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53314 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbXFSSnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:43:15 -0400
Date: Tue, 19 Jun 2007 14:42:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Use get_free_pages to allocate kernel stacks
Message-ID: <20070619184245.GA10562@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason, I was using kmalloc instead of get_free_pages for
kernel stacks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/thread_info.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/thread_info.h	2007-06-19 12:23:16.000000000 -0400
+++ linux-2.6.21-mm/include/asm-um/thread_info.h	2007-06-19 14:06:36.000000000 -0400
@@ -54,8 +54,10 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) kmalloc(THREAD_SIZE, GFP_KERNEL))
-#define free_thread_info(ti) kfree(ti)
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
+						 CONFIG_KERNEL_STACK_ORDER))
+#define free_thread_info(ti) \
+	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
 
 #endif
 
