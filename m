Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZD0TN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZD0TN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbZD0TKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:10:41 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:59522 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbZD0TKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:10:40 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
Date: Mon, 27 Apr 2009 15:10:11 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Subject: Fwd:
To: linux-kernel@vger.kernel.org
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-disposition: inline
Message-id: <200904271510.11162.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: 
Date: Monday 27 April 2009
From: arnd@arndb.de
To: "no To-header on input" <unlisted-recipients:; @gmail-pop.l.google.com>

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
Content-Disposition: inline; filename=0009-asm-generic-add-generic-
unaligned.h.patch
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

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Backed up the system lately?

