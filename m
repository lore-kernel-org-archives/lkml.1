Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYDHQ15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYDHQ15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbYDHQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbYDHQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:10 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 03/28] x86: implement mapping_error in pci-nommu_64.c
Date: Tue,  8 Apr 2008 13:20:45 -0300
Message-Id: <1207671690778-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements mapping_error for pci-nommu_64.c.
It takes care to keep the same compatible behaviour it already
had. Although this file is not (yet) used for i386, we introduce
the i386 version here. Again, care is taken, even at the expense of
an ifdef, to keep the same behaviour inconditionally.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-nommu_64.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index 90a7c40..a4e8ccf 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -67,9 +67,21 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
+/* Make sure we keep the same behaviour */
+static int nommu_mapping_error(dma_addr_t dma_addr)
+{
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	return (dma_addr == bad_dma_address);
+#endif
+}
+
+
 const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
+	.mapping_error = nommu_mapping_error,
 	.is_phys = 1,
 };
 
-- 
1.5.0.6

