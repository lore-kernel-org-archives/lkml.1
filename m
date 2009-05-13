Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbZEMXOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbZEMXOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZEMXNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:13:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:30063 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZEMXNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,191,1241420400"; 
   d="scan'208";a="515282748"
Date: Wed, 13 May 2009 16:13:51 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Tony Luck'" <tony.luck@intel.com>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'ia64'" <linux-ia64@vger.kernel.org>
Subject: [PATCH] Fix Intel IOMMU Compilation Warnings on IA64
Message-ID: <20090513231351.GA22386@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling kernel on IA64 reports two warnings in intel-iommu.c:

drivers/pci/intel-iommu.c:3150: warning: format ?%llx? expects type ?long long unsigned int?, but argument 4 has type ?u64?
drivers/pci/intel-iommu.c: In function ?intel_iommu_map_range?:
drivers/pci/intel-iommu.c:3201: warning: format ?%llx? expects type ?long long unsigned int?, but argument 4 has type ?u64?

The warnings are fixed by adding type cast unsigned long long.

Signed-off-by: Fenghua Yu <fegnhua.yu@intel.com>

---

 intel-iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a563fbe..6f8cc21 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3147,7 +3147,8 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	if (end < dmar_domain->max_addr) {
 		printk(KERN_ERR "%s: iommu agaw (%d) is not "
 		       "sufficient for the mapped address (%llx)\n",
-		       __func__, iommu->agaw, dmar_domain->max_addr);
+		       __func__, iommu->agaw,
+		       (unsigned long long)dmar_domain->max_addr);
 		return -EFAULT;
 	}
 
@@ -3198,7 +3199,8 @@ static int intel_iommu_map_range(struct iommu_domain *domain,
 		if (end < max_addr) {
 			printk(KERN_ERR "%s: iommu agaw (%d) is not "
 			       "sufficient for the mapped address (%llx)\n",
-			       __func__, min_agaw, max_addr);
+			       __func__, min_agaw,
+			       (unsigned long long)max_addr);
 			return -EFAULT;
 		}
 		dmar_domain->max_addr = max_addr;
