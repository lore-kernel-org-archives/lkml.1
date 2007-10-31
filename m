Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXJaUAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXJaUAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbXJaT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:59:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48820 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbXJaT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:59:57 -0400
Date: Wed, 31 Oct 2007 15:59:39 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Magotari <magotari@gmail.com>
Subject: [PATCH 4/4] UML - Fix build for !CONFIG_PRINTK
Message-ID: <20071031195939.GA9645@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the case of CONFIG_PRINTK being disabled.  This requires a
do-nothing stub to be present in arch/um/include/user.h so that we
don't get references to printk from libc code.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/user.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/include/user.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/user.h	2007-10-22 13:21:04.000000000 -0400
+++ linux-2.6.22/arch/um/include/user.h	2007-10-22 13:21:14.000000000 -0400
@@ -1,11 +1,13 @@
 /* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __USER_H__
 #define __USER_H__
 
+#include "uml-config.h"
+
 /*
  * The usual definition - copied here because the kernel provides its own,
  * fancier, type-safe, definition.  Using that one would require
@@ -23,8 +25,17 @@
 
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
+
+#ifdef UML_CONFIG_PRINTK
 extern int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
+#else
+static inline int printk(const char *fmt, ...)
+{
+	return 0;
+}
+#endif
+
 extern void schedule(void);
 extern int in_aton(char *str);
 extern int open_gdb_chan(void);
