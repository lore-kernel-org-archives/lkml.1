Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbXFWA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbXFWA3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbXFWA3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:29:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:53617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXFWA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:29:34 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070623229.766711000@suse.de>
To: patches@x86-64.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.22] [1/3] i386: Make CMPXCHG64 only dependent on PAE
Date: Sat, 23 Jun 2007 02:29:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is only used for PAE kernels in set_64bit.

The problem is that due to a old Windows bug many CPUs need magic MSRs 
to enable CMPXCHG64, and we can't do that nicely early enough before
it is potentially used.

But since we only need it in PAE kernels so only force the checking 
for CMPXCHG65 with PAE.

This fixes a boot failure on Transmeta Crusoe

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -299,7 +299,7 @@ config X86_POPAD_OK
 
 config X86_CMPXCHG64
 	bool
-	depends on !M386 && !M486
+	depends on X86_PAE
 	default y
 
 config X86_ALIGNMENT_16
Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -541,7 +541,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on X86_CMPXCHG64
+	depends on !M386 && !M486
 	help
 	  Select this if you have a 32-bit processor and more than 4
 	  gigabytes of physical RAM.
