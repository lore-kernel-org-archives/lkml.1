Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbXHBVHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbXHBVHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbXHBVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:05:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43975 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbXHBVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:05:06 -0400
Date: Thu, 2 Aug 2007 17:04:37 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - Fix an IPV6 libc vs kernel symbol clash
Message-ID: <20070802210437.GA11174@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems, with IPV6 configured, there is a clash between the
kernel's in6addr_any and the one in libc.

This is handled in the usual (gross) way of defining the kernel symbol
out of the way on the gcc command line.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/Makefile
===================================================================
--- linux-2.6.21-mm.orig/arch/um/Makefile	2007-08-02 16:43:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/Makefile	2007-08-02 16:43:22.000000000 -0400
@@ -60,7 +60,8 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
-	-Din6addr_loopback=kernel_in6addr_loopback
+	-Din6addr_loopback=kernel_in6addr_loopback \
+	-Din6addr_any=kernel_in6addr_any
 
 AFLAGS += $(ARCH_INCLUDE)
 
