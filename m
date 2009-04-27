Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbZD0PK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbZD0PK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZD0PHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:07:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbZD0PHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:07:24 -0400
Message-Id: <20090427150319.222669102@arndb.de>
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 17:01:26 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.chen@sunplusct.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: [RFC 12/17] asm-generic: add generic unaligned.h
Content-Disposition: inline; filename=0009-asm-generic-add-generic-unaligned.h.patch
X-Provags-ID: V01U2FsdGVkX19+gT64vyDUl/bL/XnPQ+9rtId8i5kcPKCGm8U
 4UskgGKp9MxHeKJyc/43MCsS2ThVpl990hw0+3iDOyuvLpsgjW
 jYicdcmggMnzE4nusSjXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implementation can be used by any architecture as a generic
way to provide the unaligned helpers. Many architectures can
override this by using linux/unaligned/access_ok.h.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/unaligned.h |   30 	30 +	0 -	0 !
 1 file changed, 30 insertions(+)
 create mode 100644 include/asm-generic/unaligned.h

Index: linux-2.6/include/asm-generic/unaligned.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/unaligned.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_GENERIC_UNALIGNED_H
+#define __ASM_GENERIC_UNALIGNED_H
+
+/*
+ * This is the most generic implementation of unaligned accesses
+ * and should work almost anywhere.
+ *
+ * If an architecture can handle unaligned accesses in hardware,
+ * it may want to use the linux/unaligned/access_ok.h implementation
+ * instead.
+ */
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN)
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#elif defined(__BIG_ENDIAN)
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#else
+# error need to define endianess
+#endif
+
+#endif /* __ASM_GENERIC_UNALIGNED_H */

-- 

