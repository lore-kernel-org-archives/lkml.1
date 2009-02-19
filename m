Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZBSNue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZBSNue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZBSNrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:50627 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbZBSNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ILqFbEwa5gRLrtE6Xt29yWEKXRZGxLRadxsCVawmhdSF60j2RofcIroPeJKQYo2uwE
         LjQie67nWAgWEsR/6IOqnzrzWpboobz8FWJuw0Oo3TPj5KtBDf7hyD4nwTJLaU0KRjc1
         ebUxIMCAOp8yMBtrC2jpM7o66gvVGPj5YW/7A=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa/zylonite2: add support for console uart
Date: Thu, 19 Feb 2009 21:45:58 +0800
Message-Id: <1235051161-8858-10-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-9-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-9-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/mach-mmp/zylonite2.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/zylonite2.c b/arch/arm/mach-mmp/zylonite2.c
index 82319b5..ca419aa 100644
--- a/arch/arm/mach-mmp/zylonite2.c
+++ b/arch/arm/mach-mmp/zylonite2.c
@@ -9,15 +9,27 @@
  */
 
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/addr-map.h>
+#include <mach/mfp-pxa168.h>
+#include <mach/pxa168.h>
 
 #include "common.h"
 
+static unsigned long zylonite2_pin_config[] __initdata = {
+	/* UART1 */
+	GPIO107_UART1_RXD,
+	GPIO108_UART1_TXD,
+};
+
 static void __init zylonite2_init(void)
 {
+	mfp_config(ARRAY_AND_SIZE(zylonite2_pin_config));
+
+	pxa168_add_uart1();
 }
 
 MACHINE_START(ZYLONITE2, "PXA168-based Zylonite2 Development Platform")
-- 
1.6.0.4

