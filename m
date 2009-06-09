Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbZFIN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbZFIN6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZFIN5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:57:49 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:54436 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbZFIN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:48 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j)
X-FB-SS: 13,
X-WSS-ID: 0KKZ5G2-04-0AQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] amd-iommu: remove unnecessary "AMD IOMMU: " prefix
Date: Tue, 9 Jun 2009 15:57:20 +0200
Message-ID: <1244555840-3855-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jun 2009 13:57:30.0986 (UTC) FILETIME=[3B4174A0:01C9E90A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That prefix is already included in the DUMP_printk macro. So there is no
need to repeat it in the format string.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 772e910..1c60554 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1266,9 +1266,8 @@ static int get_device_resources(struct device *dev,
 			dma_dom = (*iommu)->default_dom;
 		*domain = &dma_dom->domain;
 		attach_device(*iommu, *domain, *bdf);
-		DUMP_printk(KERN_INFO "AMD IOMMU: Using protection domain "
-				"%d for device %s\n",
-				(*domain)->id, dev_name(dev));
+		DUMP_printk("Using protection domain %d for device %s\n",
+			    (*domain)->id, dev_name(dev));
 	}
 
 	if (domain_for_device(_bdf) == NULL)
-- 
1.6.3.1


