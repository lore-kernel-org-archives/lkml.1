Return-Path: <linux-kernel-owner+w=401wt.eu-S936119AbXHNV6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936119AbXHNV6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934571AbXHNVko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:40:44 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42220 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934425AbXHNVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:40:41 -0400
Date: Tue, 14 Aug 2007 17:40:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 12/14] UML - Free LDT state on process exit
Message-ID: <20070814214025.GA17601@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The space allocated for a process LDT wasn't being freed when the
process exited.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/skas/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/mmu.c	2007-08-13 16:58:12.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/skas/mmu.c	2007-08-13 16:59:32.000000000 -0400
@@ -149,4 +149,6 @@ void destroy_context(struct mm_struct *m
 		pmd_free((pmd_t *) mmu->last_pmd);
 #endif
 	}
+
+	free_ldt(mmu);
 }
