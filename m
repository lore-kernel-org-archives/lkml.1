Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbZD3Pv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbZD3Pv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbZD3Pmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbZD3PmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:04 -0400
Message-Id: <1fe78b00ce976fdcdd9f4a347bf4310a011b2c60.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 8 Nov 2008 11:37:51 +0100
Subject: [PATCH 15/27] asm-generic: Add missing generic tlb_flush definition
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX18iysz8/4LKChMZeEd6JPR5gqFrb6Jfifw0d4L
 vQGvSajTrUpCDFsFgm2wspdVGw5Rn4Vq21xU1q8vQWpZzS6rHa
 E+F34dmIB4m3mXR2VID8Q==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures with an MMU define tlb_flush as
flush_tlb_mm((tlb)->mm). This adds it as a default
implementation in asm-generic/tlb.h so that new nommu
architectures can simply use the header as is and
others can stop defining it themselves.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/tlb.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f490e43..3a65502 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -47,6 +47,10 @@ struct mmu_gather {
 /* Users of the generic TLB shootdown code must declare this storage space. */
 DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
 
+#ifndef tlb_flush
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+#endif
+
 /* tlb_gather_mmu
  *	Return a pointer to an initialized struct mmu_gather.
  */
-- 
1.5.6.3


