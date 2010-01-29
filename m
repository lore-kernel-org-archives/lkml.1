Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616Ab0A2HG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0A2HG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864Ab0A2HG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:06:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0A2HG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:06:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5875"; a="33015131"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH v2 2/4] GIC: Prevent gic from crossing NR_IRQS
Date: Thu, 28 Jan 2010 23:06:02 -0800
Message-Id: <1264748764-5319-3-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
References: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Prevent gic code from initializing interrupts beyon NR_IRQS.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index cd92ce0..8a2bfae 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -237,7 +237,8 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
-	for (i = irq_start; i < gic_data[gic_nr].irq_offset + max_irq; i++) {
+	for (i = irq_start;
+		i < NR_IRQS && i < gic_data[gic_nr].irq_offset + max_irq; i++) {
 		set_irq_chip(i, &gic_chip);
 		set_irq_chip_data(i, &gic_data[gic_nr]);
 		set_irq_handler(i, handle_level_irq);
-- 
1.5.6.3

