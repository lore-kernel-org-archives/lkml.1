Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbYDHQ3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbYDHQ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYDHQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbYDHQ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:32 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 05/28] x86: use sg_phys in x86_64
Date: Tue,  8 Apr 2008 13:20:47 -0300
Message-Id: <12076717023182-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the code usable in i386, where we have high memory mappings,
we drop te virt_to_bus(sg_virt()) construction in favour of sg_phys.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-nommu_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index 1da9cf9..c6901e7 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -60,7 +60,7 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
-		s->dma_address = virt_to_bus(sg_virt(s));
+		s->dma_address = sg_phys(s);
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
 		s->dma_length = s->length;
-- 
1.5.0.6

