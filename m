Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbYD0XQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbYD0XQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbYD0XQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:16:05 -0400
Received: from smtp04.mtu.ru ([62.5.255.51]:53882 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbYD0XQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:16:03 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: iommu_sac_force can become static
Date: Mon, 28 Apr 2008 03:15:58 +0400
Message-Id: <1209338159-30095-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_sac_force variable is needlessly defined global,
and this patch makes it static. Additionally, this variable
needs not be explicitly initialized.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 50a18e4..81862d0 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -14,7 +14,7 @@ EXPORT_SYMBOL(forbid_dac);
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-int iommu_sac_force __read_mostly = 0;
+static int iommu_sac_force __read_mostly;
 
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
-- 
1.5.3.6

