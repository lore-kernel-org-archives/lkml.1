Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZEVMRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZEVMRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZEVMQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:14 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11778 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbZEVMQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:12 -0400
X-BigFish: VPS-7(z6c9Rzzz1202hzzz32i43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KK1OQF-04-9XW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] amd_iommu: un __init functions required for suspend/resume
Date: Fri, 22 May 2009 14:15:39 +0200
Message-ID: <1242994540-28799-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0485 (UTC) FILETIME=[06DEAC50:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: keep functions in kernel .text required in resume path ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ed10c0f..330896b 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -193,7 +193,7 @@ static inline unsigned long tbl_size(int entry_size)
  * This function set the exclusion range in the IOMMU. DMA accesses to the
  * exclusion range are passed through untranslated
  */
-static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
+static void iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
 	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
@@ -225,7 +225,7 @@ static void __init iommu_set_device_table(struct amd_iommu *iommu)
 }
 
 /* Generic functions to enable/disable certain features of the IOMMU. */
-static void __init iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
+static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
@@ -244,7 +244,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 }
 
 /* Function to enable the hardware */
-static void __init iommu_enable(struct amd_iommu *iommu)
+static void iommu_enable(struct amd_iommu *iommu)
 {
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at %s cap 0x%hx\n",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
@@ -811,7 +811,7 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 	return 0;
 }
 
-static int __init iommu_init_msi(struct amd_iommu *iommu)
+static int iommu_init_msi(struct amd_iommu *iommu)
 {
 	if (iommu->int_enabled)
 		return 0;
@@ -936,7 +936,7 @@ static void init_device_table(void)
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
  */
-static void __init enable_iommus(void)
+static void enable_iommus(void)
 {
 	struct amd_iommu *iommu;
 
-- 
1.6.3.1


