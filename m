Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZFEIMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZFEIMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZFEIGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37498 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbZFEIFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 19/62] Blackfin: fix detection of cached L2 SRAM
Date: Fri,  5 Jun 2009 04:04:28 -0400
Message-Id: <1244189111-19639-20-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure our bfin_addr_dcachable() function flags cached L2 SRAM properly
else memory easily goes unflushed when working with DMA.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cacheflush.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index d7726ab..94697f0 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -108,6 +108,11 @@ static inline int bfin_addr_dcachable(unsigned long addr)
 		addr >= _ramend && addr < physical_mem_end)
 		return 1;
 
+#ifndef CONFIG_BFIN_L2_NOT_CACHED
+	if (addr >= L2_START && addr < L2_START + L2_LENGTH)
+		return 1;
+#endif
+
 	return 0;
 }
 
-- 
1.6.3.1

