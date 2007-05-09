Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXEIUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXEIUeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXEIUdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:33:20 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40441 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbXEIUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:33:18 -0400
Date: Wed, 9 May 2007 16:27:22 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/6] UML - Shrink kernel stacks
Message-ID: <20070509202722.GA22469@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make kernel stacks be 1 page on i386 and 2 pages on x86_64.  These
matche the host values.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/Kconfig   |    2 +-
 arch/um/defconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/Kconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/Kconfig	2007-05-09 15:45:56.000000000 -0400
+++ linux-2.6.21-mm/arch/um/Kconfig	2007-05-09 16:06:03.000000000 -0400
@@ -277,7 +277,8 @@ config HIGHMEM
 
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
-	default 2
+	default 1 if 64BIT
+	default 0 if !64BIT
 	help
 	This option determines the size of UML kernel stacks.  They will
 	be 1 << order pages.  The default is OK unless you're running Valgrind
Index: linux-2.6.21-mm/arch/um/defconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/defconfig	2007-05-09 15:45:56.000000000 -0400
+++ linux-2.6.21-mm/arch/um/defconfig	2007-05-09 15:57:20.000000000 -0400
@@ -86,7 +86,7 @@ CONFIG_MCONSOLE=y
 # CONFIG_MAGIC_SYSRQ is not set
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
-CONFIG_KERNEL_STACK_ORDER=2
+CONFIG_KERNEL_STACK_ORDER=0
 CONFIG_UML_REAL_TIME_CLOCK=y
 
 #
