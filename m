Return-Path: <linux-kernel-owner+w=401wt.eu-S934461AbZKXXsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461AbZKXXsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934380AbZKXXsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:48:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:36169 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934355AbZKXXsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:48:06 -0500
Date: Wed, 25 Nov 2009 08:46:28 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Nov 2009 08:46:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"x86: Handle HW IOMMU initialization failure gracefully" patchset
handled this option properly however somehow I broke it during cleanup
after that. Sorry.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -tip] x86: fix iommu=soft boot option

iommu=soft boot option forces the kernel to use swiotlb.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index e36e71d..e3c0a66 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -50,6 +50,8 @@ static struct dma_map_ops swiotlb_dma_ops = {
  */
 int __init pci_swiotlb_init(void)
 {
+	int use_swiotlb = swiotlb | swiotlb_force;
+
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
@@ -63,5 +65,5 @@ int __init pci_swiotlb_init(void)
 		dma_ops = &swiotlb_dma_ops;
 	}
 
-	return swiotlb_force;
+	return use_swiotlb;
 }
-- 
1.5.6.5

