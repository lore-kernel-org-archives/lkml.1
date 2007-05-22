Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbXEVIJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbXEVIJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbXEVIG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:27 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:38694 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbXEVIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:13 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 14/15] x86-64: Calgary - only reserve the first 1MB of IO space for CalIOC2
Date: Tue, 22 May 2007 04:06:03 -0400
Message-Id: <11798211683559-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211673121-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com> <1179821167443-git-send-email-muli@il.ibm.com> <11798211673144-git-send-email-muli@il.ibm.com> <11798211671872-git-send-email-muli@il.ibm.com> <11798211673121-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 0bb0eb0..1df556c 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -808,13 +808,13 @@ static void __init calgary_reserve_regio
 	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
-	/* for CalIOC2 - avoid the entire first 2MB */
+	/* for CalIOC2 - avoid the entire first MB */
 	if (is_calgary(dev->device)) {
 		start = (640 * 1024);
 		npages = ((1024 - 640) * 1024) >> PAGE_SHIFT;
 	} else { /* calioc2 */
 		start = 0;
-		npages = (2 * 1024 * 1024) >> PAGE_SHIFT;
+		npages = (1 * 1024 * 1024) >> PAGE_SHIFT;
 	}
 	iommu_range_reserve(tbl, start, npages);
 
-- 
1.4.4

