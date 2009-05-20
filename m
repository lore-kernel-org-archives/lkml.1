Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZETSaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZETSaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZETSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59103 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbZETSZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:24 -0400
Subject: [RFC v2][PATCH 24/35] arm: use pte_offset_kernel() as base for pte_offset_map*()
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:23 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182523.6169CABA@kernel>
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

 linux-2.6.git-dave/arch/arm/include/asm/ptemap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/ptemap.h~arm-pte_offset_kernel arch/arm/include/asm/ptemap.h
--- linux-2.6.git/arch/arm/include/asm/ptemap.h~arm-pte_offset_kernel	2009-04-30 15:11:07.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/ptemap.h	2009-04-30 15:11:07.000000000 -0700
@@ -1,8 +1,8 @@
 #ifndef _ARM_ASM_PTEMAP_H
 #define _ARM_ASM_PTEMAP_H
 
-#define pte_offset_map(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map_nested(dir,addr)	(pmd_page_vaddr(*(dir)) + pte_index(addr))
+#define pte_offset_map(dir,addr)	pte_offset_kernel(dir,addr)
+#define pte_offset_map_nested(dir,addr)	pte_offset_kernel(dir,addr)
 #define pte_unmap(pte)		do { } while (0)
 #define pte_unmap_nested(pte)	do { } while (0)
 
_
