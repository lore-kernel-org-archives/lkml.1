Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYIQQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYIQQ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYIQQxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:24 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:65286 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbYIQQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:22 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMWE-03-U9J-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@lemmy.amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/23] AMD IOMMU: calculate IVHD size with a function
Date: Wed, 17 Sep 2008 18:52:55 +0200
Message-ID: <1221670377-19295-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0220 (UTC) FILETIME=[D68222C0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@lemmy.amd.com>

The current calculation of the IVHD entry size is hard to read. So move
this code to a seperate function to make it more clear what this
calculation does.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b876499..5303404 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -298,6 +298,14 @@ static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
  ****************************************************************************/
 
 /*
+ * This function calculates the length of a given IVHD entry
+ */
+static inline int ivhd_entry_length(u8 *ivhd)
+{
+	return 0x04 << (*ivhd >> 6);
+}
+
+/*
  * This function reads the last device id the IOMMU has to handle from the PCI
  * capability header for this IOMMU
  */
@@ -341,7 +349,7 @@ static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 		default:
 			break;
 		}
-		p += 0x04 << (*p >> 6);
+		p += ivhd_entry_length(p);
 	}
 
 	WARN_ON(p != end);
@@ -642,7 +650,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			break;
 		}
 
-		p += 0x04 << (e->type >> 6);
+		p += ivhd_entry_length(p);
 	}
 }
 
-- 
1.5.6.4


