Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYL2QQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYL2QQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYL2QQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:16:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYL2QQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:16:11 -0500
Subject: [PATCH] x86: amd_iommu_init.c iommu_enable and
	iommu_enable_event_logging should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, leo.duran@amd.com,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 21:44:12 +0530
Message-Id: <1230567253.26564.14.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/amd_iommu_init.c:246:13: warning: symbol 'iommu_enable' was not declared. Should it be static?
arch/x86/kernel/amd_iommu_init.c:259:13: warning: symbol 'iommu_enable_event_logging' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c625800..fb85e8d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -243,7 +243,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 }
 
 /* Function to enable the hardware */
-void __init iommu_enable(struct amd_iommu *iommu)
+static void __init iommu_enable(struct amd_iommu *iommu)
 {
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU "
 	       "at %02x:%02x.%x cap 0x%hx\n",
@@ -256,7 +256,7 @@ void __init iommu_enable(struct amd_iommu *iommu)
 }
 
 /* Function to enable IOMMU event logging and event interrupts */
-void __init iommu_enable_event_logging(struct amd_iommu *iommu)
+static void __init iommu_enable_event_logging(struct amd_iommu *iommu)
 {
 	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
-- 
1.5.5.1



