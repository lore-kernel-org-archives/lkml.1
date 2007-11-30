Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXLFMqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXLFMqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXLFMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:46 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53710 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbXLFMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:21 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <31a27c6de35cf8063146be40fc7803f0c2e4eae0.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 10:11:43 +0100
Subject: [PATCH 13/47] Add prototypes for cache flushing on CRISv32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need these to work around some cache bugs in CRISv32 chips.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/arch-v32/cache.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-cris/arch-v32/cache.h b/include/asm-cris/arch-v32/cache.h
index 80b236b..b3d752d 100644
--- a/include/asm-cris/arch-v32/cache.h
+++ b/include/asm-cris/arch-v32/cache.h
@@ -1,8 +1,19 @@
 #ifndef _ASM_CRIS_ARCH_CACHE_H
 #define _ASM_CRIS_ARCH_CACHE_H
 
+#include <asm/arch/hwregs/dma.h>
+
 /* A cache-line is 32 bytes. */
 #define L1_CACHE_BYTES 32
 #define L1_CACHE_SHIFT 5
 
+void flush_dma_list(dma_descr_data *descr);
+void flush_dma_descr(dma_descr_data *descr, int flush_buf);
+
+#define flush_dma_context(c) \
+  flush_dma_list(phys_to_virt((c)->saved_data));
+
+void cris_flush_cache_range(void *buf, unsigned long len);
+void cris_flush_cache(void);
+
 #endif /* _ASM_CRIS_ARCH_CACHE_H */
-- 
1.5.3.6.970.gd25430

