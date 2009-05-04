Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZEDKUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZEDKUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZEDKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:20:41 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:30906
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755091AbZEDKUk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:20:40 -0400
X-BigFish: VPS-8(z21eW5edJzzz1202hzzz32i6bh15fn43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJ47E4-04-LVF-01
Date: Mon, 4 May 2009 12:20:28 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [git pull] amd iommu updates for 2.6.30-rc4
Message-ID: <20090504102028.GA30307@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 May 2009 10:20:29.0090 (UTC) FILETIME=[F2BAD020:01C9CCA1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 19c1a6f5764d787113fa323ffb18be7991208f82:
  FUJITA Tomonori (1):
        x86 gart: reimplement IOMMU_LEAK feature by using DMA_API_DEBUG

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes-2.6.30

Joerg Roedel (1):
      amd-iommu: fix iommu flag masks

 arch/x86/kernel/amd_iommu_init.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

The patch fixes a minor issue with wrong evaluated iommu flags read from
the ACPI table. Please pull.

Here is the full diff:

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
 
-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

