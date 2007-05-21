Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbXEUKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbXEUKOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761927AbXEUKJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:34 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761003AbXEUKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:17 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510263:sNHT264843103"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 22/32] Blackfin arch: make sure we use local labels
Date: Mon, 21 May 2007 18:09:30 +0800
Message-Id: <11797421862969-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf537/head.S |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index b4377dd..2c2652b 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -470,38 +470,38 @@ ENTRY(_bfin_reset)
 	SSYNC;
 
 #if defined(CONFIG_MTD_M25P80)
-/*
- * The following code fix the SPI flash reboot issue,
- * /CS signal of the chip which is using PF10 return to GPIO mode
- */
+	/*
+	 * The following code fix the SPI flash reboot issue,
+	 * /CS signal of the chip which is using PF10 return to GPIO mode
+	 */
 	p0.h = hi(PORTF_FER);
 	p0.l = lo(PORTF_FER);
 	r0.l = 0x0000;
 	w[p0] = r0.l;
 	SSYNC;
 
-/* /CS return to high */
+	/* /CS return to high */
 	p0.h = hi(PORTFIO);
 	p0.l = lo(PORTFIO);
 	r0.l = 0xFFFF;
 	w[p0] = r0.l;
 	SSYNC;
 
-/* Delay some time, This is necessary */
+	/* Delay some time, This is necessary */
 	r1.h = 0;
 	r1.l = 0x400;
 	p1   = r1;
-	lsetup (_delay_lab1,_delay_lab1_end ) lc1 = p1;
-_delay_lab1:
+	lsetup (.L_delay_lab1, .L_delay_lab1_end) lc1 = p1;
+.L_delay_lab1:
 	r0.h = 0;
 	r0.l = 0x8000;
 	p0   = r0;
-	lsetup (_delay_lab0,_delay_lab0_end ) lc0 = p0;
-_delay_lab0:
+	lsetup (.L_delay_lab0, .L_delay_lab0_end) lc0 = p0;
+.L_delay_lab0:
 	nop;
-_delay_lab0_end:
+.L_delay_lab0_end:
 	nop;
-_delay_lab1_end:
+.L_delay_lab1_end:
 	nop;
 #endif
 
-- 
1.5.1.2
