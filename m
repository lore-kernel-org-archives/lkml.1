Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYFIGkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYFIGkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYFIGkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:40:05 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:47662 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYFIGkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:40:04 -0400
Date: Mon, 9 Jun 2008 08:39:58 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Alchemy: remove unused MMC macros from db1x00 header.
Message-ID: <20080609063958.GH8724@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609063521.GA8724@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c637a7ed8d8d3cf845aca7775923df1076e06b8d Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mano@roarinelk.homelinux.net>
Date: Wed, 21 May 2008 15:13:51 +0200
Subject: [PATCH] Alchemy: remove unused MMC macros from db1x00 header.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 include/asm-mips/mach-db1x00/db1x00.h |   45 ---------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/include/asm-mips/mach-db1x00/db1x00.h b/include/asm-mips/mach-db1x00/db1x00.h
index 612ae90..1a515b8 100644
--- a/include/asm-mips/mach-db1x00/db1x00.h
+++ b/include/asm-mips/mach-db1x00/db1x00.h
@@ -146,51 +146,6 @@ typedef volatile struct
 	((((VCC) << 2) | ((VPP) << 0)) << ((SLOT) * 8))
 
 /*
- * SD controller macros
- */
-
-/* Detect card. */
-#define mmc_card_inserted(_n_, _res_) \
-	do { \
-		BCSR * const bcsr = (BCSR *)0xAE000000; \
-		unsigned long mmc_wp, board_specific; \
-		if ((_n_)) { \
-			mmc_wp = BCSR_BOARD_SD1_WP; \
-		} else { \
-			mmc_wp = BCSR_BOARD_SD0_WP; \
-		} \
-		board_specific = au_readl((unsigned long)(&bcsr->specific)); \
-		if (!(board_specific & mmc_wp)) {/* low means card present */ \
-			*(int *)(_res_) = 1; \
-		} else { \
-			*(int *)(_res_) = 0; \
-		} \
-	} while (0)
-
-/*
- * Apply power to card slot(s).
- */
-#define mmc_power_on(_n_) \
-	do { \
-		BCSR * const bcsr = (BCSR *)0xAE000000; \
-		unsigned long mmc_pwr, mmc_wp, board_specific; \
-		if ((_n_)) { \
-			mmc_pwr = BCSR_BOARD_SD1_PWR; \
-			mmc_wp	= BCSR_BOARD_SD1_WP; \
-		} else { \
-			mmc_pwr = BCSR_BOARD_SD0_PWR; \
-			mmc_wp	= BCSR_BOARD_SD0_WP; \
-		} \
-		board_specific = au_readl((unsigned long)(&bcsr->specific)); \
-		if (!(board_specific & mmc_wp)) {/* low means card present */ \
-			board_specific |= mmc_pwr; \
-			au_writel(board_specific, (int)(&bcsr->specific)); \
-			au_sync(); \
-		} \
-	} while (0)
-
-
-/*
  * NAND defines
  *
  * Timing values as described in databook, * ns value stripped of the
-- 
1.5.5.3

