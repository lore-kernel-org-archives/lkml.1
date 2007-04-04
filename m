Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXDDSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXDDSMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934079AbXDDSMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:12:03 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38706 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056AbXDDSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:53 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 60/90] ARM: OMAP: Merge gpmc changes from N800 tree
Date: Wed,  4 Apr 2007 14:05:39 -0400
Message-Id: <11757101303810-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710128235-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch merges gpmc changes from N800 tree.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpmc.c       |    7 +++++++
 include/asm-arm/arch-omap/gpmc.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index a3f31f0..b6b47f2 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -111,6 +111,13 @@ unsigned int gpmc_ns_to_ticks(unsigned int time_ns)
 	return (time_ns * 1000 + tick_ps - 1) / tick_ps;
 }
 
+unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns)
+{
+	unsigned long ticks = gpmc_ns_to_ticks(time_ns);
+
+	return ticks * gpmc_get_fclk_period() / 1000;
+}
+
 #ifdef DEBUG
 static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 			       int time, const char *name)
diff --git a/include/asm-arm/arch-omap/gpmc.h b/include/asm-arm/arch-omap/gpmc.h
index 434672d..0fe920a 100644
--- a/include/asm-arm/arch-omap/gpmc.h
+++ b/include/asm-arm/arch-omap/gpmc.h
@@ -81,6 +81,7 @@ struct gpmc_timings {
 };
 
 extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
+extern unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns);
 
 extern void gpmc_cs_write_reg(int cs, int idx, u32 val);
 extern u32 gpmc_cs_read_reg(int cs, int idx);
-- 
1.4.4.2

