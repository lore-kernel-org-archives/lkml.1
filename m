Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYGHRA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYGHRA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYGHQ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbYGHQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:50 -0400
Date: Tue, 8 Jul 2008 09:51:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 10/17] use WARN() in arch/x86/mm/pageattr.c
Message-ID: <20080708095108.75544a92@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in x86/mm/pageattr

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/mm/pageattr-test.c |    3 +--
 arch/x86/mm/pageattr.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux.trees.git/arch/x86/mm/pageattr.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/pageattr.c
+++ linux.trees.git/arch/x86/mm/pageattr.c
@@ -586,10 +586,9 @@ repeat:
 	if (!pte_val(old_pte)) {
 		if (!primary)
 			return 0;
-		printk(KERN_WARNING "CPA: called for zero pte. "
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
 		       cpa->vaddr);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
Index: linux.trees.git/arch/x86/mm/pageattr-test.c
===================================================================
--- linux.trees.git.orig/arch/x86/mm/pageattr-test.c
+++ linux.trees.git/arch/x86/mm/pageattr-test.c
@@ -221,8 +221,7 @@ static int pageattr_test(void)
 	failed += print_split(&sc);
 
 	if (failed) {
-		printk(KERN_ERR "NOT PASSED. Please report.\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "NOT PASSED. Please report.\n");
 		return -EINVAL;
 	} else {
 		if (print)
