Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXF0I3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXF0I3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXF0I2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:28:43 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53197 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXF0I2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:28:40 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Wed, 27 Jun 2007 16:35:46 +0800
Message-Id: <1182933348216-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11829333481375-git-send-email-wei.zhang@freescale.com>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com> <11829333481375-git-send-email-wei.zhang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the platform device support with RapidIO to MPC8641HPCN platform.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 7034bca..5518ed3 100644
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
+	{ .compatible = "fsl,rapidio-delta", },
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

