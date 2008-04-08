Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYDHQ2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYDHQ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYDHQ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbYDHQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:17 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 04/28] x86: Add flush_write_buffers in nommu functions
Date: Tue,  8 Apr 2008 13:20:46 -0300
Message-Id: <12076716961715-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds flush_write_buffers() in some functions of pci-nommu_64.c
They are added anywhere i386 would also have it. This is not a problem
for x86_64, since flush_rite_buffers() an nop for it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-nommu_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index a4e8ccf..1da9cf9 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -32,6 +32,7 @@ nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
 	dma_addr_t bus = paddr;
 	if (!check_addr("map_single", hwdev, bus, size))
 				return bad_dma_address;
+	flush_write_buffers();
 	return bus;
 }
 
@@ -64,6 +65,7 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 			return 0;
 		s->dma_length = s->length;
 	}
+	flush_write_buffers();
 	return nents;
 }
 
-- 
1.5.0.6

