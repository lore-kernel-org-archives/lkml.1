Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYFZTbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYFZTbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760516AbYFZT2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:38 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2554 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392AbYFZT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:37 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K334QX-04-UN4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for AMD IOMMU
Date: Thu, 26 Jun 2008 21:27:52 +0200
Message-ID: <1214508490-29683-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0808 (UTC) FILETIME=[C58DA200:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two parameters to the kernel command line to control behavior
of the AMD IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index d7a75bf..ec6f13b 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -789,3 +789,37 @@ void __init amd_iommu_detect(void)
 	}
 }
 
+static int __init parse_amd_iommu_options(char *str)
+{
+	for (; *str; ++str) {
+		if (strcmp(str, "off") == 0)
+			amd_iommu_disable = 1;
+		if (strcmp(str, "isolate") == 0)
+			amd_iommu_isolate = 1;
+	}
+
+	return 1;
+}
+
+static int __init parse_amd_iommu_size_options(char *str)
+{
+	for (; *str; ++str) {
+		if (strcmp(str, "32M") == 0)
+			amd_iommu_aperture_order = 25;
+		if (strcmp(str, "64M") == 0)
+			amd_iommu_aperture_order = 26;
+		if (strcmp(str, "128M") == 0)
+			amd_iommu_aperture_order = 27;
+		if (strcmp(str, "256M") == 0)
+			amd_iommu_aperture_order = 28;
+		if (strcmp(str, "512M") == 0)
+			amd_iommu_aperture_order = 29;
+		if (strcmp(str, "1G") == 0)
+			amd_iommu_aperture_order = 30;
+	}
+
+	return 1;
+}
+
+__setup("amd_iommu=", parse_amd_iommu_options);
+__setup("amd_iommu_size=", parse_amd_iommu_size_options);
-- 
1.5.3.7


