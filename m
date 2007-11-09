Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXKIU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXKIU1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXKIU1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:27:44 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44263 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXKIU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:27:43 -0500
Date: Fri, 9 Nov 2007 15:26:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Fix symlink loops
Message-ID: <20071109202637.GA7652@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This should go into 2.6.24 - it's simple enough and people are
complaining about this ]

symlinks to directories in the non-O= case were lacking -n, which
meant that, when the link already existed, a new link pointing at
itself was created in the target directory.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/um/Makefile
===================================================================
--- linux-2.6.orig/arch/um/Makefile	2007-11-09 14:32:36.000000000 -0500
+++ linux-2.6/arch/um/Makefile	2007-11-09 14:34:05.000000000 -0500
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(HEADER_ARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(SUBARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
@@ -180,7 +180,7 @@ $(ARCH_DIR)/include/sysdep: $(objtree)/$
 ifneq ($(KBUILD_SRC),)
 	$(Q)ln -fsn $(srctree)/$(ARCH_DIR)/include/sysdep-$(SUBARCH) $(ARCH_DIR)/include/sysdep
 else
-	$(Q)cd $(ARCH_DIR)/include && ln -sf sysdep-$(SUBARCH) sysdep
+	$(Q)cd $(ARCH_DIR)/include && ln -fsn sysdep-$(SUBARCH) sysdep
 endif
 
 $(ARCH_DIR)/os:
@@ -188,7 +188,7 @@ $(ARCH_DIR)/os:
 ifneq ($(KBUILD_SRC),)
 	$(Q)ln -fsn $(srctree)/$(ARCH_DIR)/os-$(OS) $(ARCH_DIR)/os
 else
-	$(Q)cd $(ARCH_DIR) && ln -sf os-$(OS) os
+	$(Q)cd $(ARCH_DIR) && ln -fsn os-$(OS) os
 endif
 
 # Generated files
