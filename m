Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZI3Vlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZI3Vlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZI3Vlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:41:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40098 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZI3Vly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:41:54 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5757"; a="24372674"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@quicinc.com>, Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: allow empty ATAG_CORE
Date: Wed, 30 Sep 2009 14:44:31 -0700
Message-Id: <1254347072-27932-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brown <davidb@quicinc.com>

The ATAG_CORE is allowed to be empty.  Although this is handled
by parse_tag_core(), __vet_atags during startup rejects this tag
unless it contains data.  Allow the initial tag to be either the
full size, or empty.

Signed-off-by: David Brown <davidb@quicinc.com>
---
Currently, some configurations of the Android bootloader use an empty
ATAG_CORE.

 arch/arm/kernel/head-common.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 93ad576..1e8f0d6 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -13,6 +13,7 @@
 
 #define ATAG_CORE 0x54410001
 #define ATAG_CORE_SIZE ((2*4 + 3*4) >> 2)
+#define ATAG_CORE_SIZE_EMPTY ((2*4 + 3*4) >> 2)
 
 	.align	2
 	.type	__switch_data, %object
@@ -251,7 +252,8 @@ __vet_atags:
 	bne	1f
 
 	ldr	r5, [r2, #0]			@ is first tag ATAG_CORE?
-	subs	r5, r5, #ATAG_CORE_SIZE
+	cmp	r5, #ATAG_CORE_SIZE
+	cmpne	r5, #ATAG_CORE_SIZE_EMPTY
 	bne	1f
 	ldr	r5, [r2, #4]
 	ldr	r6, =ATAG_CORE
-- 
1.6.2.3

