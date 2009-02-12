Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbZBLRMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbZBLRMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbZBLRLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:11:47 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:39410 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758863AbZBLRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:11:46 -0500
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
To: linux-kernel@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH] slab: fix slab flags for archs use alignment larger 64-bit
Date: Thu, 12 Feb 2009 18:51:13 +0100
Message-Id: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think, this fix is necessary for all the architectures want to
perform DMA into kmalloc caches and need a guaranteed alignment
larger than the alignment of a 64-bit integer.
An example is sh architecture where ARCH_KMALLOC_MINALIGN is L1_CACHE_BYTES.

As side effect, these kind of objects cannot be visible
within the /proc/slab_allocators file.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index ddc41f3..031d785 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2262,7 +2262,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		ralign = align;
 	}
 	/* disable debug if necessary */
-	if (ralign > __alignof__(unsigned long long))
+	if (ralign > ARCH_KMALLOC_MINALIGN)
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
-- 
1.5.6.6

