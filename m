Return-Path: <linux-kernel-owner+w=401wt.eu-S1764524AbXGLMI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764524AbXGLMI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXGLMIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:08:21 -0400
Received: from rex.snapgear.com ([203.143.235.140]:38175 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753724AbXGLMIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:08:20 -0400
Date: Thu, 12 Jul 2007 22:07:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707121207.l6CC7ok9026564@goober>
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
