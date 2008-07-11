Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbYGKPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbYGKPT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYGKPQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:16:06 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4430 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbYGKPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:16:05 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL24-03-1QF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/16] AMD IOMMU: replace self made size parsing with memparse call
Date: Fri, 11 Jul 2008 17:14:33 +0200
Message-ID: <1215789275-20975-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0321 (UTC) FILETIME=[D49CD110:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the self-made parsing of the amd_iommu_size option with the
generic memparse function call.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 2efc3d5..e0ff940 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1042,20 +1042,10 @@ static int __init parse_amd_iommu_options(char *str)
 
 static int __init parse_amd_iommu_size_options(char *str)
 {
-	for (; *str; ++str) {
-		if (strcmp(str, "32M") == 0)
-			amd_iommu_aperture_order = 25;
-		if (strcmp(str, "64M") == 0)
-			amd_iommu_aperture_order = 26;
-		if (strcmp(str, "128M") == 0)
-			amd_iommu_aperture_order = 27;
-		if (strcmp(str, "256M") == 0)
-			amd_iommu_aperture_order = 28;
-		if (strcmp(str, "512M") == 0)
-			amd_iommu_aperture_order = 29;
-		if (strcmp(str, "1G") == 0)
-			amd_iommu_aperture_order = 30;
-	}
+	unsigned order = PAGE_SHIFT + get_order(memparse(str, &str));
+
+	if ((order > 24) && (order < 31))
+		amd_iommu_aperture_order = order;
 
 	return 1;
 }
-- 
1.5.3.7


