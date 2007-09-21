Return-Path: <linux-kernel-owner+w=401wt.eu-S1764714AbXIUUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764714AbXIUUz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763302AbXIUUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:28 -0400
Received: from mail.suse.de ([195.135.220.2]:50079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbXIUUpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:17 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [33/45] i386: es7000 minor cleanups
Message-Id: <20070921204515.EDCBD14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make some needlessly global functions static
- #if 0 the unused es7000_stop_cpu()

AK: actually removed es7000_stop_cpu
AK: fixed a non ISO prototype too


Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/mach-es7000/es7000plat.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

Index: linux/arch/i386/mach-es7000/es7000plat.c
===================================================================
--- linux.orig/arch/i386/mach-es7000/es7000plat.c
+++ linux/arch/i386/mach-es7000/es7000plat.c
@@ -46,11 +46,11 @@
  * ES7000 Globals
  */
 
-volatile unsigned long	*psai = NULL;
-struct mip_reg		*mip_reg;
-struct mip_reg		*host_reg;
-int 			mip_port;
-unsigned long		mip_addr, host_addr;
+static volatile unsigned long	*psai = NULL;
+static struct mip_reg		*mip_reg;
+static struct mip_reg		*host_reg;
+static int 			mip_port;
+static unsigned long		mip_addr, host_addr;
 
 /*
  * GSI override for ES7000 platforms.
@@ -288,28 +288,8 @@ es7000_start_cpu(int cpu, unsigned long 
 
 }
 
-int
-es7000_stop_cpu(int cpu)
-{
-	int startup;
-
-	if (psai == NULL)
-		return -1;
-
-	startup= (0x1000000 | cpu);
-
-	while ((*psai & 0xff00ffff) != startup)
-		;
-
-	startup = (*psai & 0xff0000) >> 16;
-	*psai &= 0xffffff;
-
-	return 0;
-
-}
-
 void __init
-es7000_sw_apic()
+es7000_sw_apic(void)
 {
 	if (es7000_plat) {
 		int mip_status;
