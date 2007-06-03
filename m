Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXFCRX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXFCRX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 13:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXFCRXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 13:23:51 -0400
Received: from [198.99.130.12] ([198.99.130.12]:44414 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXFCRXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 13:23:50 -0400
Date: Sun, 3 Jun 2007 13:15:34 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] syslets demo - fix malloc failure check
Message-ID: <20070603171534.GA30116@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the stack malloc failure check.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 syslets/async-test-v5/sys.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/syslets/async-test-v5/sys.h
===================================================================
--- linux-2.6.orig/syslets/async-test-v5/sys.h	2007-05-31 13:29:57.000000000 -0400
+++ linux-2.6/syslets/async-test-v5/sys.h	2007-06-03 13:12:43.000000000 -0400
@@ -108,9 +108,10 @@ static u64 completion_ring[MAX_PENDING];
 
 static unsigned long thread_stack_alloc()
 {
-	void *stack = malloc(THREAD_STACK_SIZE) + THREAD_STACK_SIZE;
+	void *stack = malloc(THREAD_STACK_SIZE);
 	assert(stack != NULL);
 
+	stack += THREAD_STACK_SIZE;
 	pr("allocated stack: %p\n", stack);
 
 	return (unsigned long)stack;
