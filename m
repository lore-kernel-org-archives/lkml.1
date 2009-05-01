Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZEAOyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZEAOyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761422AbZEAOmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60785 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013AbZEAOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:51 -0400
Subject: [RFC][PATCH 31/35] mn10300: use pte_offset_kernel() as base for pte_offset_map*()
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:49 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144249.1E5C0439@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some architectures use pte_offset_map() as a basis for
pte_offset_kernel().  Others do the inverse.

Although arbitrary, Using pte_offset_kernel() as the base
seems a wee bit more popular and it also fits in well
with the way I'm breaking out the headers.

Instead of coding the same implementation twice, this
makes pte_offset_map{,_nested}() call pte_offset_kernel()
directly.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/mn10300/include/asm/ptemap.h~mn10300-pte_offset_kernel arch/mn10300/include/asm/ptemap.h
--- linux-2.6.git/arch/mn10300/include/asm/ptemap.h~mn10300-pte_offset_kernel	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1,8 @@
 #ifndef _MN10300_ASM_PTEMAP_H
 #define _MN10300_ASM_PTEMAP_H
 
-#define pte_offset_map(dir, address) \
-	((pte_t *) page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
 #define pte_unmap(pte)		do {} while (0)
 #define pte_unmap_nested(pte)	do {} while (0)
 
_
