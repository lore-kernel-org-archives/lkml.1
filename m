Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZETS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZETS1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbZETSZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42385 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZETSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:04 -0400
Subject: [RFC v2][PATCH 12/35] mn10300: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:04 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182504.232CFEB6@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/mn10300/include/asm/pgtable.h |    6 +-----
 linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h  |   10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN arch/mn10300/include/asm/pgtable.h~mn10300-ptemaph arch/mn10300/include/asm/pgtable.h
--- linux-2.6.git/arch/mn10300/include/asm/pgtable.h~mn10300-ptemaph	2009-04-30 15:10:59.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/include/asm/pgtable.h	2009-04-30 15:10:59.000000000 -0700
@@ -455,11 +455,7 @@ static inline int set_kernel_exec(unsign
 	return 0;
 }
 
-#define pte_offset_map(dir, address) \
-	((pte_t *) page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
-#define pte_unmap(pte)		do {} while (0)
-#define pte_unmap_nested(pte)	do {} while (0)
+#include <asm/ptemap.h>
 
 /*
  * The MN10300 has external MMU info in the form of a TLB: this is adapted from
diff -puN arch/mn10300/include/asm/ptemap.h~mn10300-ptemaph arch/mn10300/include/asm/ptemap.h
--- linux-2.6.git/arch/mn10300/include/asm/ptemap.h~mn10300-ptemaph	2009-04-30 15:10:59.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h	2009-04-30 15:10:59.000000000 -0700
@@ -0,0 +1,10 @@
+#ifndef _MN10300_ASM_PTEMAP_H
+#define _MN10300_ASM_PTEMAP_H
+
+#define pte_offset_map(dir, address) \
+	((pte_t *) page_address(pmd_page(*(dir))) + pte_index(address))
+#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_unmap(pte)		do {} while (0)
+#define pte_unmap_nested(pte)	do {} while (0)
+
+#endif /* _MN10300_ASM_PTEMAP_H */
_
