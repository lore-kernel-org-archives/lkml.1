Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZD0Oql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZD0Oql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZD0OmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:42:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbZD0OmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:42:05 -0400
Message-Id: <20090427143738.688526666@arndb.de>
From: <arnd@arndb.de>
To: unlisted-recipients:; (no To-header on input)
Date: Mon, 27 Apr 2009 10:42:05 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:22 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>,
 Harvey Harrison <harvey.harrison@gmail.com>,
 Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 12/17] asm-generic: add generic unaligned.h
Content-Disposition: inline; filename=0009-asm-generic-add-generic-unaligned.h.patch
X-Provags-ID: V01U2FsdGVkX180uRkKPtTR6NE5qs40yQi4ziqxITkI8KKYXbv
 ceZfZA4rNxQHTjaGg5pO05a3RFhyObTUvhsERRtOhJTrzruub3
 3XgHSsqqDkZJnfLEIfR2g==

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

