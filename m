Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833Ab0A1Lif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0A1Lif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716Ab0A1Lid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:33 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55722
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671Ab0A1Lic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:32 -0500
X-SpamScore: 3
X-BigFish: VPS3(z2d9bozab9bh936eMzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBY-01-FXT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/11] iommu-api: Rename ->{un}map function pointers to ->{un}map_range
Date: Thu, 28 Jan 2010 12:37:52 +0100
Message-ID: <1264678682-30655-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0680 (UTC) FILETIME=[6455A080:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new function pointer names match better with the
top-level functions of the iommu-api which are using them.
Main intention of this change is to make the ->{un}map
pointer names free for two new mapping functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 drivers/base/iommu.c        |    4 ++--
 drivers/pci/intel-iommu.c   |    4 ++--
 include/linux/iommu.h       |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index adb0ba0..59cae7c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2515,8 +2515,8 @@ static struct iommu_ops amd_iommu_ops = {
 	.domain_destroy = amd_iommu_domain_destroy,
 	.attach_dev = amd_iommu_attach_device,
 	.detach_dev = amd_iommu_detach_device,
-	.map = amd_iommu_map_range,
-	.unmap = amd_iommu_unmap_range,
+	.map_range = amd_iommu_map_range,
+	.unmap_range = amd_iommu_unmap_range,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
 };
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 8ad4ffe..f4c86c4 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -83,14 +83,14 @@ EXPORT_SYMBOL_GPL(iommu_detach_device);
 int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
 		    phys_addr_t paddr, size_t size, int prot)
 {
-	return iommu_ops->map(domain, iova, paddr, size, prot);
+	return iommu_ops->map_range(domain, iova, paddr, size, prot);
 }
 EXPORT_SYMBOL_GPL(iommu_map_range);
 
 void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
 		      size_t size)
 {
-	iommu_ops->unmap(domain, iova, size);
+	iommu_ops->unmap_range(domain, iova, size);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap_range);
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..a714e3d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3714,8 +3714,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.domain_destroy = intel_iommu_domain_destroy,
 	.attach_dev	= intel_iommu_attach_device,
 	.detach_dev	= intel_iommu_detach_device,
-	.map		= intel_iommu_map_range,
-	.unmap		= intel_iommu_unmap_range,
+	.map_range	= intel_iommu_map_range,
+	.unmap_range	= intel_iommu_unmap_range,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
 };
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3af4ffd..0f18f37 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -36,10 +36,10 @@ struct iommu_ops {
 	void (*domain_destroy)(struct iommu_domain *domain);
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
-	int (*map)(struct iommu_domain *domain, unsigned long iova,
-		   phys_addr_t paddr, size_t size, int prot);
-	void (*unmap)(struct iommu_domain *domain, unsigned long iova,
-		      size_t size);
+	int (*map_range)(struct iommu_domain *domain, unsigned long iova,
+			 phys_addr_t paddr, size_t size, int prot);
+	void (*unmap_range)(struct iommu_domain *domain, unsigned long iova,
+			    size_t size);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
-- 
1.6.6


