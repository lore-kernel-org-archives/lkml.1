Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYKGALU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYKGALU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYKGALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:11:09 -0500
Received: from host-60-63-230-24.midco.net ([24.230.63.60]:47730 "EHLO
	snuffleupagus.Belkin" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754000AbYKGALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:11:08 -0500
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 19:11:08 EST
From: arges@linux.vnet.ibm.com
To: eranian@gmail.com
Cc: perfmon2-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Chris J Arges <arges@linux.vnet.ibm.com>
Subject: [PATCH] perfmon2 add support for ppc970 processors
Date: Thu,  6 Nov 2008 16:59:38 -0700
Message-Id: <1226015978-19965-1-git-send-email-arges@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris J Arges <arges@linux.vnet.ibm.com>

Allows ppc970(fx,mp,gx) to use the perfmon_power4 module.
---
 arch/powerpc/perfmon/perfmon.c        |    2 +-
 arch/powerpc/perfmon/perfmon_power4.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perfmon/perfmon.c b/arch/powerpc/perfmon/perfmon.c
index a14a1e3..f1d93ee 100644
--- a/arch/powerpc/perfmon/perfmon.c
+++ b/arch/powerpc/perfmon/perfmon.c
@@ -284,7 +284,7 @@ char *pfm_arch_get_pmu_module_name(void)
 	case PV_970:
 	case PV_970FX:
 	case PV_970MP:
-		return "perfmon_ppc970";
+		return "perfmon_power4";
 	case PV_BE:
 		return "perfmon_cell";
 	}
diff --git a/arch/powerpc/perfmon/perfmon_power4.c b/arch/powerpc/perfmon/perfmon_power4.c
index eba9e8c..b262de3 100644
--- a/arch/powerpc/perfmon/perfmon_power4.c
+++ b/arch/powerpc/perfmon/perfmon_power4.c
@@ -57,8 +57,15 @@ static int pfm_power4_probe_pmu(void)
 	unsigned long pvr = mfspr(SPRN_PVR);
 	int ver = PVR_VER(pvr);
 
-	if ((ver == PV_POWER4) || (ver == PV_POWER4p))
+	switch (ver) {
+	case PV_POWER4:
+	case PV_POWER4p:
+	case PV_970:
+	case PV_970FX:
+	case PV_970MP:
+	case PV_970GX:
 		return 0;
+	}
 
 	return -1;
 }
-- 
1.5.4.5

Signed-off-by: Chris J Arges <arges@linux.vnet.ibm.com>

