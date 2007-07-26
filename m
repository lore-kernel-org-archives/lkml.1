Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbXGZIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbXGZIgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXGZIet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:34:49 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38953 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbXGZIeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:34:46 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: galak@kernel.crashing.org, mporter@kernel.crashing.org, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 3/5 v3] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Thu, 26 Jul 2007 16:42:50 +0800
Message-Id: <11854393753986-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11854393741899-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 26 Jul 2007 08:34:41.0578 (UTC) FILETIME=[CFA358A0:01C7CF5F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the platform device support with RapidIO to MPC8641HPCN platform.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index e9eaa07..7693adc 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -28,6 +28,8 @@
 #include <mm/mmu_decl.h>
 #include <asm/udbg.h>
 #include <asm/i8259.h>
+#include <asm/of_device.h>
+#include <asm/of_platform.h>
 
 #include <asm/mpic.h>
 
@@ -444,3 +446,17 @@ define_machine(mpc86xx_hpcn) {
 	.progress		= udbg_progress,
 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
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

