Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbZJMQD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbZJMQD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbZJMQD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:03:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55897 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbZJMQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:03:26 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@ksplice.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2] powerpc: remove unused __page_aligned definition.
Date: Tue, 13 Oct 2009 11:57:18 -0400
Message-Id: <1255449438-16874-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a resend of this patch with the right subject line]

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
index 3f17b83..3c7118f 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -162,14 +162,6 @@ do {						\
 
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
1.6.4.3

