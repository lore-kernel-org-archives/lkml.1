Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYLSFOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYLSFOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYLSFLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:35 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42907 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 04/11] swiotlb: Print physical addr instead of bus addr in info printks
Date: Thu, 18 Dec 2008 23:11:15 -0600
Message-Id: <1229663480-10757-5-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the bus address is printed, but the physical address
makes more sense in the context of the overall iotlb, and on
some platforms we need a hwdev pointer to determine a bus address,
which we don't have at the time of these printks.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index add1f92..ef09b4c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -167,8 +167,10 @@ swiotlb_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
-	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	printk(KERN_INFO "Placing software IO TLB between cpu physical "
+	       "0x%llx - 0x%llx\n",
+	       (unsigned long long)virt_to_phys(io_tlb_start),
+	       (unsigned long long)virt_to_phys(io_tlb_end));
 }
 
 void __init
@@ -249,9 +251,10 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between 0x%lx - "
-	       "0x%lx\n", bytes >> 20,
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	printk(KERN_INFO "Placing %luMB software IO TLB between cpu physical "
+	       "0x%llx - 0x%llx\n", bytes >> 20,
+	       (unsigned long long)virt_to_phys(io_tlb_start),
+	       (unsigned long long)virt_to_phys(io_tlb_end));
 
 	return 0;
 
-- 
1.5.6.5

