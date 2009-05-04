Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZEDQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZEDQ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZEDQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:59:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:37526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093AbZEDQ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:59:06 -0400
Date: Mon, 4 May 2009 16:58:29 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090504102028.GA30307@amd.com>
References: <20090504102028.GA30307@amd.com>
Subject: [tip:x86/urgent] amd-iommu: fix iommu flag masks
Message-ID: <tip-6da7342ff1c5274c51ada084974668d10f769c16@git.kernel.org>
Git-Commit-ID: 6da7342ff1c5274c51ada084974668d10f769c16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 16:58:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6da7342ff1c5274c51ada084974668d10f769c16
Gitweb:     http://git.kernel.org/tip/6da7342ff1c5274c51ada084974668d10f769c16
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 4 May 2009 11:44:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 15:05:24 +0200

amd-iommu: fix iommu flag masks

The feature bits should be set via bitmasks, not via feature IDs.

[ Impact: fix feature enabling in newer IOMMU versions ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20090504102028.GA30307@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/amd_iommu_init.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42c33ce..8c0be09 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -49,10 +49,10 @@
 #define IVHD_DEV_EXT_SELECT             0x46
 #define IVHD_DEV_EXT_SELECT_RANGE       0x47
 
-#define IVHD_FLAG_HT_TUN_EN             0x00
-#define IVHD_FLAG_PASSPW_EN             0x01
-#define IVHD_FLAG_RESPASSPW_EN          0x02
-#define IVHD_FLAG_ISOC_EN               0x03
+#define IVHD_FLAG_HT_TUN_EN_MASK        0x01
+#define IVHD_FLAG_PASSPW_EN_MASK        0x02
+#define IVHD_FLAG_RESPASSPW_EN_MASK     0x04
+#define IVHD_FLAG_ISOC_EN_MASK          0x08
 
 #define IVMD_FLAG_EXCL_RANGE            0x08
 #define IVMD_FLAG_UNITY_MAP             0x01
@@ -569,19 +569,19 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	 * First set the recommended feature enable bits from ACPI
 	 * into the IOMMU control registers
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN ?
+	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
 		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
 
-	h->flags & IVHD_FLAG_PASSPW_EN ?
+	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
 
-	h->flags & IVHD_FLAG_RESPASSPW_EN ?
+	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
 
-	h->flags & IVHD_FLAG_ISOC_EN ?
+	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
 		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
 
