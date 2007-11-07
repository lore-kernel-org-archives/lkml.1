Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbXKGSiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbXKGSiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbXKGShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:37:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:60187 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbXKGShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:37:02 -0500
Date: Wed, 7 Nov 2007 13:36:38 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/5] UML - Allow LFLAGS on command line
Message-ID: <20071107183638.GA8467@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow LFLAGS to be given to make and have the expected effect.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/um/Makefile
===================================================================
--- linux-2.6.orig/arch/um/Makefile	2007-11-06 10:46:55.000000000 -0500
+++ linux-2.6/arch/um/Makefile	2007-11-07 12:44:29.000000000 -0500
@@ -130,7 +130,9 @@ CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DST
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
-CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS)
+LD_FLAGS_CMDLINE = $(foreach opt,$(LFLAGS),-Wl,$(opt))
+
+CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
 define cmd_vmlinux__
 	$(CC) $(CFLAGS_vmlinux) -o $@ \
 	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
