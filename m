Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZKWNu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZKWNu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZKWNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:50:25 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38779
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753112AbZKWNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:50:22 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTKEF6-02-42M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 1/2] x86/amd-iommu: un__init iommu_setup_msi
Date: Mon, 23 Nov 2009 14:49:45 +0100
Message-ID: <1258984186-4328-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1258984186-4328-1-git-send-email-joerg.roedel@amd.com>
References: <1258984186-4328-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 23 Nov 2009 13:49:50.0129 (UTC) FILETIME=[D38C8210:01CA6C43]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function may be called on the resume path and can not
be dropped after booting.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0d4581e..72bdbda 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -926,7 +926,7 @@ static int __init init_iommu_all(struct acpi_table_header *table)
  *
  ****************************************************************************/
 
-static int __init iommu_setup_msi(struct amd_iommu *iommu)
+static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
-- 
1.6.5.3


