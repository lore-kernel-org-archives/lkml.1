Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZIICt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZIICt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIICt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:49:26 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45740 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbZIICtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:49:25 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 4/5] powerpc: remove unused __page_aligned definition.
Date: Tue,  8 Sep 2009 22:49:05 -0400
Message-Id: <1252464546-26394-5-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already an architecture-independent __page_aligned_data macro
for this purpose, so removing the powerpc-specific macro should be
harmless.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/include/asm/page_64.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index 5817a3b..22e4795 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -152,14 +152,6 @@ do {						\
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
-#ifdef MODULE
-#define __page_aligned __attribute__((__aligned__(PAGE_SIZE)))
-#else
-#define __page_aligned \
-	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
-#endif
-
 #define VM_DATA_DEFAULT_FLAGS \
 	(test_thread_flag(TIF_32BIT) ? \
 	 VM_DATA_DEFAULT_FLAGS32 : VM_DATA_DEFAULT_FLAGS64)
-- 
1.6.3.3

