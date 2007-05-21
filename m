Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXEUKSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXEUKSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXEUKJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:45 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761496AbXEUKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:21 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510294:sNHT25964064"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 08/32] Blackfin arch: Move write to VR_CTL closer to IDLE
Date: Mon, 21 May 2007 18:09:16 +0800
Message-Id: <11797421831286-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/mach-bf533/cdefBF532.h |    6 ++++--
 include/asm-blackfin/mach-bf537/cdefBF534.h |    6 ++++--
 include/asm-blackfin/mach-bf561/cdefBF561.h |    6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/asm-blackfin/mach-bf533/cdefBF532.h b/include/asm-blackfin/mach-bf533/cdefBF532.h
index 1d7c494..521bdb4 100644
--- a/include/asm-blackfin/mach-bf533/cdefBF532.h
+++ b/include/asm-blackfin/mach-bf533/cdefBF532.h
@@ -63,12 +63,14 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 {
 	unsigned long flags, iwr;
 
-	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(VR_CTL, val);
+	__builtin_bfin_ssync();
+
 	local_irq_save(flags);
 	asm("IDLE;");
 	local_irq_restore(flags);
diff --git a/include/asm-blackfin/mach-bf537/cdefBF534.h b/include/asm-blackfin/mach-bf537/cdefBF534.h
index 7b658c1..9a167f3 100644
--- a/include/asm-blackfin/mach-bf537/cdefBF534.h
+++ b/include/asm-blackfin/mach-bf537/cdefBF534.h
@@ -51,12 +51,14 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 {
 	unsigned long flags, iwr;
 
-	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
+
+	bfin_write16(VR_CTL, val);
+	__builtin_bfin_ssync();
+
 	local_irq_save(flags);
 	asm("IDLE;");
 	local_irq_restore(flags);
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 5dc0ed8..b14f872 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -59,12 +59,14 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 {
 	unsigned long flags, iwr;
 
-	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SICA_IWR0);
 	/* Only allow PPL Wakeup) */
 	bfin_write32(SICA_IWR0, IWR_ENABLE(0));
+
+	bfin_write16(VR_CTL, val);
+	__builtin_bfin_ssync();
+
 	local_irq_save(flags);
 	asm("IDLE;");
 	local_irq_restore(flags);
-- 
1.5.1.2
