Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZH0LrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZH0LrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZH0LrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:47:05 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55014 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZH0LrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:47:04 -0400
Date: Thu, 27 Aug 2009 13:47:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: fix kunmap usage in pte_alloc_one
Message-ID: <20090827114704.GB8678@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] m68k: avoid pgprot_noncached redefinition

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Compiling m68k with defconfig gives a lot of these warnings:

In file included from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgalloc.h:13,
                 from arch/m68k/kernel/dma.c:15:
arch/m68k/include/asm/motorola_pgalloc.h: In function 'pte_alloc_one':
arch/m68k/include/asm/motorola_pgalloc.h:44: warning: passing argument 1 of 'kunmap' from incompatible pointer type

kunmap wants a page not a pte.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/m68k/include/asm/motorola_pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/m68k/include/asm/motorola_pgalloc.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/motorola_pgalloc.h
+++ linux-2.6/arch/m68k/include/asm/motorola_pgalloc.h
@@ -41,7 +41,7 @@ static inline pgtable_t pte_alloc_one(st
 		flush_tlb_kernel_page(pte);
 		nocache_page(pte);
 	}
-	kunmap(pte);
+	kunmap(page);
 	pgtable_page_ctor(page);
 	return page;
 }
