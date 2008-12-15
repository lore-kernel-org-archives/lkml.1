Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYLOOSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYLOOSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYLOOSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:16 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:18964 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYLOOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:16 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBX925-03-GLI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/22] AMD IOMMU: convert amd_iommu_isolate to bool
Date: Mon, 15 Dec 2008 15:17:48 +0100
Message-ID: <1229350685-3816-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0022 (UTC) FILETIME=[F2B0FE60:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index c4b144e..7abf9cf 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -381,7 +381,7 @@ extern struct protection_domain **amd_iommu_pd_table;
 extern unsigned long *amd_iommu_pd_alloc_bitmap;
 
 /* will be 1 if device isolation is enabled */
-extern int amd_iommu_isolate;
+extern bool amd_iommu_isolate;
 
 /*
  * If true, the addresses will be flushed on unmap time, not when
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 30ae270..b53152b 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -121,7 +121,8 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
-int amd_iommu_isolate = 1;		/* if 1, device isolation is enabled */
+bool amd_iommu_isolate = true;		/* if true, device isolation is
+					   enabled */
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
@@ -1212,9 +1213,9 @@ static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
 		if (strncmp(str, "isolate", 7) == 0)
-			amd_iommu_isolate = 1;
+			amd_iommu_isolate = true;
 		if (strncmp(str, "share", 5) == 0)
-			amd_iommu_isolate = 0;
+			amd_iommu_isolate = false;
 		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
 	}
-- 
1.5.6.4


