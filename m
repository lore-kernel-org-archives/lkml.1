Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbYKTPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbYKTPCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbYKTOut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:50:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34987 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbYKTOus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:50:48 -0500
Date: Thu, 20 Nov 2008 15:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] iommu fixes
Message-ID: <20081120145039.GA12406@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
FUJITA Tomonori (1):
      intel-iommu: fix compile warnings


 drivers/pci/intel-iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a269272..5c8baa4 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1655,12 +1655,14 @@ int __init init_dmars(void)
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		}
 	}
 
