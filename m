Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbXEUKNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbXEUKNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXEUKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:26 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbXEUKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:16 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510262:sNHT51600038"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 19/32] Blackfin arch: document why we have to touch the UART peripheral in our boot up code
Date: Mon, 21 May 2007 18:09:27 +0800
Message-Id: <11797421864181-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/head.S |    3 ++-
 arch/blackfin/mach-bf537/head.S |    3 ++-
 arch/blackfin/mach-bf561/head.S |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 1a54ff5..4db9e62 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -173,7 +173,8 @@ ENTRY(__stext)
 	STI R2;
 #endif
 
-	/* Initialise UART */
+	/* Initialise UART - when booting from u-boot, the UART is not disabled
+	 * so if we dont initalize here, our serial console gets hosed */
 	p0.h = hi(UART_LCR);
 	p0.l = lo(UART_LCR);
 	r0 = 0x0(Z);
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index aafc686..b4377dd 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -181,7 +181,8 @@ ENTRY(__stext)
 	SSYNC;
 #endif
 
-	/*Initialise UART*/
+	/* Initialise UART - when booting from u-boot, the UART is not disabled
+	 * so if we dont initalize here, our serial console gets hosed */
 	p0.h = hi(UART_LCR);
 	p0.l = lo(UART_LCR);
 	r0 = 0x0(Z);
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 04f3ac3..9c8e688 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -127,7 +127,8 @@ ENTRY(__stext)
 	STI R2;
 #endif
 
-	/* Initialise UART*/
+	/* Initialise UART - when booting from u-boot, the UART is not disabled
+	 * so if we dont initalize here, our serial console gets hosed */
 	p0.h = hi(UART_LCR);
 	p0.l = lo(UART_LCR);
 	r0 = 0x0(Z);
-- 
1.5.1.2
