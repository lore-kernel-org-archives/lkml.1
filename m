Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZGJBLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZGJBLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZGJBJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:55369 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZGJBJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 07/15] ia64: add dma_capable() to replace is_buffer_dma_capable()
Date: Fri, 10 Jul 2009 10:04:56 +0900
Message-Id: <1247187904-31999-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_capable() eventually replaces is_buffer_dma_capable(), which tells
if a memory area is dma-capable or not. The problem of
is_buffer_dma_capable() is that it doesn't take a pointer to struct
device so it doesn't work for POWERPC.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/dma-mapping.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 5a61b5c..88d0f86 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -69,6 +69,14 @@ dma_set_mask (struct device *dev, u64 mask)
 	return 0;
 }
 
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size <= *dev->dma_mask;
+}
+
 extern int dma_get_cache_alignment(void);
 
 static inline void
-- 
1.6.0.6

