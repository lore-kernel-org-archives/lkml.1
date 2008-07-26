Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYGZRTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYGZRTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYGZRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:19:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:40866 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbYGZRTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:19:10 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] include/asm-generic/tlb.h must include <linux/pagemap.h>
Date: Sat, 26 Jul 2008 19:18:05 +0200
Message-Id: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 26 Jul 2008 17:18:52.0101 (UTC) FILETIME=[ACCCCF50:01C8EF43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compile error on avr32, introduced by
commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c
(exec: remove some includes):

In file included from include/asm/tlb.h:24,
                 from fs/exec.c:55:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[1]: *** [fs/exec.o] Error 1

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 include/asm-generic/tlb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index f490e43..f85f3a2 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -13,6 +13,7 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
-- 
1.5.6.2

