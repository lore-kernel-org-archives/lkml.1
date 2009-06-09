Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZFIN6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZFIN6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZFIN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:57:43 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:59063 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZFIN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j)
X-WSS-ID: 0KKZ5FT-03-LAP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 3/4] amd-iommu: detach device explicitly before attaching it to a new domain
Date: Tue, 9 Jun 2009 15:57:19 +0200
Message-ID: <1244555840-3855-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jun 2009 13:57:30.0954 (UTC) FILETIME=[3B3C92A0:01C9E90A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug with a device that could not be assigned to a KVM guest
because it is still assigned to a dma_ops protection domain.

[chrisw: simply remove WARN_ON(), will always fire since dev->driver
will be pci-sub]

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8187260..772e910 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2073,7 +2073,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 
 	old_domain = domain_for_device(devid);
 	if (old_domain)
-		return -EBUSY;
+		detach_device(old_domain, devid);
 
 	attach_device(iommu, domain, devid);
 
-- 
1.6.3.1


