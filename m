Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXFLI50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXFLI50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXFLI4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:56:15 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:46921 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbXFLI4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:56:14 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 3/5] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Tue, 12 Jun 2007 17:02:18 +0800
Message-Id: <11816389402216-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11816389401714-git-send-email-wei.zhang@freescale.com>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <11816389401714-git-send-email-wei.zhang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the platform device support with RapidIO to MPC8641HPCN platform.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 7034bca..f0ca5b3 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -28,6 +28,8 @@
 #include <mm/mmu_decl.h>
 #include <asm/udbg.h>
 #include <asm/i8259.h>
+#include <asm/of_device.h>
+#include <asm/of_platform.h>
 
 #include <asm/mpic.h>
 
@@ -467,3 +469,17 @@ define_machine(mpc86xx_hpcn) {
 	.calibrate_decr		= generic_calibrate_decr,
 	.progress		= udbg_progress,
 };
+
+
+static struct of_device_id mpc86xx_of_ids[] = {
+	{ .type = "soc", },
+	{ .type = "rapidio", },
+	{},
+};
+
+static __init int mpc86xx_of_device_init(void)
+{
+	return of_platform_bus_probe(NULL, mpc86xx_of_ids, NULL);
+}
+
+device_initcall(mpc86xx_of_device_init);
-- 
1.5.1

