Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbXKGSiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbXKGSiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbXKGShO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:37:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:60199 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbXKGShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:37:13 -0500
Date: Wed, 7 Nov 2007 13:36:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 5/5] UML - reconst a parameter
Message-ID: <20071107183643.GA8482@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The previous const-ing patch consted a string which shouldn't have
been, and I didn't notice the gcc warning.

ubd_setup can't take a const char * because its address is assigned to
something which expects a char *arg.  Many setups modify the string
they are given, they can't be const.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c	2007-11-07 13:20:45.000000000 -0500
+++ linux-2.6/arch/um/drivers/ubd_kern.c	2007-11-07 13:24:57.000000000 -0500
@@ -444,7 +444,7 @@ __uml_help(ubd_setup,
 "    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
-static int udb_setup(const char *str)
+static int udb_setup(char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
