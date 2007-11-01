Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXKATyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXKATyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXKATx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:53:56 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55249 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbXKATxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:53:55 -0400
Date: Thu, 1 Nov 2007 15:53:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - Fix kernel vs libc symbols clash
Message-ID: <20071101195326.GA8888@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2a772652c3971745228a2e40e6575ae594c88365
Author: Jeff Dike <jdike@addtoit.com>
Date:   Tue Oct 16 01:26:45 2007 -0700

    uml: fix an IPV6 libc vs kernel symbol clash
    
    On some systems, with IPV6 configured, there is a clash between the kernel's
    in6addr_any and the one in libc.
    
    This is handled in the usual (gross) way of defining the kernel symbol out of
    the way on the gcc command line.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 989224f..c3a399e 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -60,7 +60,8 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$(SUBARCH)
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
-	-Din6addr_loopback=kernel_in6addr_loopback
+	-Din6addr_loopback=kernel_in6addr_loopback \
+	-Din6addr_any=kernel_in6addr_any
 
 AFLAGS += $(ARCH_INCLUDE)
 

