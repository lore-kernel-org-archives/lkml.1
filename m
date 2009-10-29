Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZJ2QvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZJ2QvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZJ2QvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:51:02 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12880 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbZJ2Qu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:50:59 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KSAC3Z-04-FK2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Pavel Vasilyev <pavel@pavlinux.ru>, Dave Jones <davej@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] agp/amd64: Remove GART dependency on AGP_AMD64
Date: Thu, 29 Oct 2009 17:50:12 +0100
Message-ID: <1256835012-31410-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
References: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Oct 2009 16:50:17.0683 (UTC) FILETIME=[E4F26230:01CA58B7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Vasilyev <pavel@pavlinux.ru>

The GART IOMMU code has no strong dependency to the AMD64
AGP code. So the automatic selection of AGP_AMD64 for GART
can be removed.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/char/agp/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index ccb1fa8..2fb3a48 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -56,9 +56,8 @@ config AGP_AMD
 	  X on AMD Irongate, 761, and 762 chipsets.
 
 config AGP_AMD64
-	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
+	tristate "AMD Opteron/Athlon64 on-CPU GART support"
 	depends on AGP && X86
-	default y if GART_IOMMU
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
-- 
1.6.5


