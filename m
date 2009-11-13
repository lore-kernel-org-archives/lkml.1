Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZKMWPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZKMWPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZKMWPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:15:39 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:5226 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZKMWPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:15:39 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 17:15:39 EST
X-Spam-Processed: digidescorp.com, Fri, 13 Nov 2009 16:08:46 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1568d5710a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] microblaze: Fix pfn_valid() for noMMU
Date: Fri, 13 Nov 2009 16:08:29 -0600
Message-Id: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuring DEBUG_SLAB causes a noMMU kernel to die during initialization
with an invalid virtual address panic in kfree_debugcheck().
The panic is due to an improper definition of pfn_valid().

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
--- a/arch/microblaze/include/asm/page.h	2009-09-09 17:13:59.000000000 -0500
+++ b/arch/microblaze/include/asm/page.h	2009-11-13 15:20:26.000000000 -0600
@@ -161,7 +161,8 @@ extern int page_is_ram(unsigned long pfn
 #  endif /* CONFIG_MMU */
 
 #  ifndef CONFIG_MMU
-#  define pfn_valid(pfn)	((pfn) >= min_low_pfn && (pfn) <= max_mapnr)
+#  define pfn_valid(pfn)	(((pfn) >= min_low_pfn) && \
+				((pfn) <= (min_low_pfn + max_mapnr)))
 #  define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT)
 #  else /* CONFIG_MMU */
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)

