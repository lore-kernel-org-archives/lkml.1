Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbZFRPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbZFRPOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761719AbZFRPNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:13:12 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38572 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbZFRPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:13:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
Subject: [PATCH 2/5] at91: Support for at91sam9g10: clocks management
Date: Thu, 18 Jun 2009 18:16:09 +0200
Message-Id: <1245341772-1689-3-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Xu <hong.xu@atmel.com>

Add the at91sam9g10 support to the AT91 generic clock file. It takes
advantage of the management by functionalities of those PLLs and clocks.

Signed-off-by: Hong Xu <hong.xu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 6396680..c042dcf 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -53,7 +53,7 @@
 #define cpu_has_800M_plla()	(  cpu_is_at91sam9g20() \
 				|| cpu_is_at91sam9g45())
 
-#define cpu_has_300M_plla()	(0)
+#define cpu_has_300M_plla()	(cpu_is_at91sam9g10())
 
 #define cpu_has_pllb()		(!(cpu_is_at91sam9rl() \
 				|| cpu_is_at91sam9g45()))
@@ -626,7 +626,9 @@ static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
 		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
 		udpck.pmc_mask = AT91RM9200_PMC_UDP;
 		at91_sys_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
-	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
+	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() ||
+		   cpu_is_at91sam9263() || cpu_is_at91sam9g20() ||
+		   cpu_is_at91sam9g10()) {
 		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
 		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
 	} else if (cpu_is_at91cap9()) {
-- 
1.5.3.7

