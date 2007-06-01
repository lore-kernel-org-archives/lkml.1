Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXFALKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXFALKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXFALKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:10:31 -0400
Received: from rex.snapgear.com ([203.143.235.140]:48555 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755124AbXFALKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:10:30 -0400
Date: Fri, 1 Jun 2007 21:09:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011109.l51B9LbK023545@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] nommu: stub expand_stack() for nommu case
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Be consistent with VM mmap, implement expand_stack().
We can't actually do anything other than return an error
in the no MMU case though.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>



diff -Naur linux-2.6.21/mm/nommu.c linux-2.6.21-uc0/mm/nommu.c
--- linux-2.6.21/mm/nommu.c	2007-05-01 17:09:34.000000000 +1000
+++ linux-2.6.21-uc0/mm/nommu.c	2007-05-01 17:14:27.000000000 +1000
@@ -359,6 +359,11 @@
 	return find_vma(mm, addr);
 }
 
+int expand_stack(struct vm_area_struct *vma, unsigned long address)
+{
+	return -ENOMEM;
+}
+
 /*
  * look up the first VMA exactly that exactly matches addr
  * - should be called with mm->mmap_sem at least held readlocked
