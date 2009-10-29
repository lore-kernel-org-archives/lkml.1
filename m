Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZJ2Qu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZJ2Qu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZJ2Qu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:50:28 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:33393
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755466AbZJ2QuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:50:25 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KSAC3T-04-FJW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] dma-debug: Fix compile warning with PAE enabled
Date: Thu, 29 Oct 2009 17:50:11 +0100
Message-ID: <1256835012-31410-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
References: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Oct 2009 16:50:17.0652 (UTC) FILETIME=[E4EDA740:01CA58B7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PAE is enabled in the kernel configuration the size of
phys_addr_t differs from the size of a void pointer. The gcc
prints a warning about that in dma-debug code.
This patch fixes the warning by converting the output to
unsigned long long instead of a pointer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 58a9f9f..ce6b7ea 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -819,9 +819,11 @@ static void check_unmap(struct dma_debug_entry *ref)
 		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
-			   "[cpu alloc address=%p] [cpu free address=%p]",
+			   "[cpu alloc address=0x%016llx] "
+			   "[cpu free address=0x%016llx]",
 			   ref->dev_addr, ref->size,
-			   (void *)entry->paddr, (void *)ref->paddr);
+			   (unsigned long long)entry->paddr,
+			   (unsigned long long)ref->paddr);
 	}
 
 	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
-- 
1.6.5


