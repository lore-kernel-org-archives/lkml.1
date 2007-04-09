Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbXDIVij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbXDIVij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966028AbXDIVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:32:42 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33721 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966019AbXDIVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 13/18] ARM: OMAP: Merge gpmc changes from N800 tree
Date: Mon,  9 Apr 2007 17:30:56 -0400
Message-Id: <1176154308509-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761543041751-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch merges gpmc changes from N800 tree
and adds gpmc_get_fclk_period() to gpmc.h.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpmc.c       |    7 +++++++
 include/asm-arm/arch-omap/gpmc.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap2/gpmc.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/gpmc.c	2007-04-09 16:36:48.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/gpmc.c	2007-04-09 16:36:54.000000000 -0400
@@ -111,6 +111,13 @@ unsigned int gpmc_ns_to_ticks(unsigned i
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
Index: linux-2.6/include/asm-arm/arch-omap/gpmc.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/gpmc.h	2007-04-09 16:36:41.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/gpmc.h	2007-04-09 16:36:54.000000000 -0400
@@ -81,6 +81,8 @@ struct gpmc_timings {
 };
 
 extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
+extern unsigned int gpmc_round_ns_to_ticks(unsigned int time_ns);
+extern unsigned long gpmc_get_fclk_period(void);
 
 extern void gpmc_cs_write_reg(int cs, int idx, u32 val);
 extern u32 gpmc_cs_read_reg(int cs, int idx);
