Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZHJIsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZHJIsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZHJIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:48:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZHJIsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:48:02 -0400
Date: Mon, 10 Aug 2009 08:47:17 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, reif@earthlink.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, reif@earthlink.net,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249872797-1314-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249872797-1314-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] sparc: Remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
Message-ID: <tip-595cc8560783ea31ed1208dc1f97282a2a5606b7@git.kernel.org>
Git-Commit-ID: 595cc8560783ea31ed1208dc1f97282a2a5606b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 08:47:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  595cc8560783ea31ed1208dc1f97282a2a5606b7
Gitweb:     http://git.kernel.org/tip/595cc8560783ea31ed1208dc1f97282a2a5606b7
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 10 Aug 2009 11:53:14 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 09:34:59 +0200

sparc: Remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu

Now sparc uses include/asm-generic/dma-mapping-common.h.
pci_sun4v.c doesn't need to have no-op
dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
(dma-mapping-common.h does nothing if sync_{single|sg}_for_cpu
hook is not defined). So we can remove them safely.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1249872797-1314-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/sparc/kernel/pci_sun4v.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index ee800f9..23c33ff 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -525,20 +525,6 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static void dma_4v_sync_single_for_cpu(struct device *dev,
-				       dma_addr_t bus_addr, size_t sz,
-				       enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
-static void dma_4v_sync_sg_for_cpu(struct device *dev,
-				   struct scatterlist *sglist, int nelems,
-				   enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
 static struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
@@ -546,8 +532,6 @@ static struct dma_map_ops sun4v_dma_ops = {
 	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
 	.unmap_sg			= dma_4v_unmap_sg,
-	.sync_single_for_cpu		= dma_4v_sync_single_for_cpu,
-	.sync_sg_for_cpu		= dma_4v_sync_sg_for_cpu,
 };
 
 static void __devinit pci_sun4v_scan_bus(struct pci_pbm_info *pbm,
