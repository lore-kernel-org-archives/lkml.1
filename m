Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbZE0H3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbZE0H3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbZE0H0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46905 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762175AbZE0HZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:59 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 25/29] microblaze_mmu_v2: Update dma.h for MMU
Date: Wed, 27 May 2009 08:47:50 +0200
Message-Id: <1243406874-3917-26-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-25-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
 <1243406874-3917-22-git-send-email-monstr@monstr.eu>
 <1243406874-3917-23-git-send-email-monstr@monstr.eu>
 <1243406874-3917-24-git-send-email-monstr@monstr.eu>
 <1243406874-3917-25-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/dma.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/dma.h b/arch/microblaze/include/asm/dma.h
index 0967fa0..08c073b 100644
--- a/arch/microblaze/include/asm/dma.h
+++ b/arch/microblaze/include/asm/dma.h
@@ -9,8 +9,13 @@
 #ifndef _ASM_MICROBLAZE_DMA_H
 #define _ASM_MICROBLAZE_DMA_H
 
+#ifndef CONFIG_MMU
 /* we don't have dma address limit. define it as zero to be
  * unlimited. */
 #define MAX_DMA_ADDRESS		(0)
+#else
+/* Virtual address corresponding to last available physical memory address.  */
+#define MAX_DMA_ADDRESS (CONFIG_KERNEL_START + memory_size - 1)
+#endif
 
 #endif /* _ASM_MICROBLAZE_DMA_H */
-- 
1.5.5.1

