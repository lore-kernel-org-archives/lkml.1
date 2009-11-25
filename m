Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZKYNbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZKYNbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbZKYNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:31:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:49044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368AbZKYNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:31:06 -0500
Date: Wed, 25 Nov 2009 13:30:36 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
References: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Fix iommu=soft boot option
Message-ID: <tip-273bee27fa9f79d94b78c83506016f2e41e78983@git.kernel.org>
Git-Commit-ID: 273bee27fa9f79d94b78c83506016f2e41e78983
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  273bee27fa9f79d94b78c83506016f2e41e78983
Gitweb:     http://git.kernel.org/tip/273bee27fa9f79d94b78c83506016f2e41e78983
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Wed, 25 Nov 2009 08:46:28 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Nov 2009 10:12:51 +0100

x86: Fix iommu=soft boot option

iommu=soft boot option forces the kernel to use swiotlb.

( This has the side-effect of enabling the swiotlb over the
  GART if this boot option is provided. This is the desired
  behavior of the swiotlb boot option and works like that
  for all other hw-IOMMU drivers. )

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org
LKML-Reference: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
