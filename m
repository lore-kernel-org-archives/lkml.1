Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0CIQE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:04:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52874 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0CIQEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:04:24 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] [WATCHDOG] bfin: use new common Blackfin watchdog header
Date: Tue,  9 Mar 2010 11:07:40 -0500
Message-Id: <1268150860-28011-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this can be merged for 2.6.34 or 2.6.35

 drivers/watchdog/bfin_wdt.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 2159e66..3546a46 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/blackfin.h>
+#include <asm/bfin_watchdog.h>
 
 #define stamp(fmt, args...) \
 	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
@@ -51,24 +52,6 @@
 # define bfin_write_WDOG_STAT(x) bfin_write_WDOGA_STAT(x)
 #endif
 
-/* Bit in SWRST that indicates boot caused by watchdog */
-#define SWRST_RESET_WDOG 0x4000
-
-/* Bit in WDOG_CTL that indicates watchdog has expired (WDR0) */
-#define WDOG_EXPIRED 0x8000
-
-/* Masks for WDEV field in WDOG_CTL register */
-#define ICTL_RESET   0x0
-#define ICTL_NMI     0x2
-#define ICTL_GPI     0x4
-#define ICTL_NONE    0x6
-#define ICTL_MASK    0x6
-
-/* Masks for WDEN field in WDOG_CTL register */
-#define WDEN_MASK    0x0FF0
-#define WDEN_ENABLE  0x0000
-#define WDEN_DISABLE 0x0AD0
-
 /* some defaults */
 #define WATCHDOG_TIMEOUT 20
 
-- 
1.7.0.2

