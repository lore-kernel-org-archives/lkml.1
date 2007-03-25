Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbXCYQ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbXCYQ66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXCYQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:58:57 -0400
Received: from [198.99.130.12] ([198.99.130.12]:36834 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXCYQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:58:56 -0400
Date: Sun, 25 Mar 2007 12:54:32 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       JC.LAFOUCRIERE@CEA.FR
Subject: [PATCH] UML - Fix static linking
Message-ID: <20070325165432.GA6232@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is both 2.6.21 and -stable material ]

During a static link, ld has started putting a .note section in the
.uml.setup.init section.  This has the result that the UML setups
begin with 32 bytes of garbage and UML crashes immediately on boot.

This patch creates a specific .note section for ld to drop this stuff
into.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/common.lds.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-mm/include/asm-um/common.lds.S
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/common.lds.S	2007-03-05 13:03:47.000000000 -0500
+++ linux-2.6.21-mm/include/asm-um/common.lds.S	2007-03-23 23:03:53.000000000 -0400
@@ -15,6 +15,7 @@
   PROVIDE (_unprotected_end = .);
 
   . = ALIGN(4096);
+  .note : { *(note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
