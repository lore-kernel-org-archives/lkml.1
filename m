Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYDHQ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYDHQ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYDHQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbYDHQ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:26 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 07/28] x86: use WARN_ON in mapping functions
Date: Tue,  8 Apr 2008 13:20:49 -0300
Message-Id: <1207671720433-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the very same way i386 do, we use WARN_ON functions
in map_simple and map_sg.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-nommu_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index c6901e7..8d036ae 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -30,6 +30,7 @@ nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
 	       int direction)
 {
 	dma_addr_t bus = paddr;
+	WARN_ON(size == 0);
 	if (!check_addr("map_single", hwdev, bus, size))
 				return bad_dma_address;
 	flush_write_buffers();
@@ -58,6 +59,8 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	struct scatterlist *s;
 	int i;
 
+	WARN_ON(nents == 0 || sg[0].length == 0);
+
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
 		s->dma_address = sg_phys(s);
-- 
1.5.0.6

