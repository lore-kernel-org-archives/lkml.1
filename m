Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbXGPAtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbXGPAtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXGPAtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:49:01 -0400
Received: from rex.snapgear.com ([203.143.235.140]:39439 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753537AbXGPAtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:49:00 -0400
Date: Mon, 16 Jul 2007 10:48:11 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707160048.l6G0mB6V010147@goober>
To: torvalds@linux-foundation.org
Subject: [NOMMU]: stub expand_stack() for nommu case
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Be consistent with VM mmap, implement expand_stack().
We can't actually do anything other than return an error
in the no MMU case though.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/mm/nommu.c linux-2.6.22-uc0/mm/nommu.c
--- linux-2.6.22/mm/nommu.c	2007-07-12 15:22:07.000000000 +1000
+++ linux-2.6.22-uc0/mm/nommu.c	2007-07-12 15:24:21.000000000 +1000
@@ -367,6 +367,11 @@
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
