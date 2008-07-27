Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbYG0QWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbYG0QWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYG0QWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:22:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbYG0QWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:22:15 -0400
Date: Mon, 28 Jul 2008 02:22:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] powerpc/vio: more fallout from dma_mapping_error API change
Message-Id: <20080728022214.5b97a39b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc/kernel/vio.c:533: error: too few arguments to function 'dma_mapping_error'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/vio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Compile tested for ppc64_defconfig.

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index ade8aea..49a166d 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -530,7 +530,7 @@ static dma_addr_t vio_dma_iommu_map_single(struct device *dev, void *vaddr,
 	}
 
 	ret = dma_iommu_ops.map_single(dev, vaddr, size, direction, attrs);
-	if (unlikely(dma_mapping_error(ret))) {
+	if (unlikely(dma_mapping_error(dev, ret))) {
 		vio_cmo_dealloc(viodev, roundup(size, IOMMU_PAGE_SIZE));
 		atomic_inc(&viodev->cmo.allocs_failed);
 	}
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
