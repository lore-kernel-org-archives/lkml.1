Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbXK2PC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbXK2PC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXK2PCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:02:46 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:34328 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbXK2PCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:02:46 -0500
Message-ID: <474ED490.9030608@tiscali.nl>
Date: Thu, 29 Nov 2007 16:02:40 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ysato@users.sourceforge.jp
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] asm-h8300: parentheses around definition CLOCK_TICK_RATE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some places where CLOCK_TICK_RATE may be used incorrectly:

arch/arm/mach-mx3/time.c:125:   __raw_writel((v / CLOCK_TICK_RATE) - 1, MXC_GPT_GPTPR);
drivers/watchdog/davinci_wdt.c:103:     timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
drivers/watchdog/davinci_wdt.c:105:     timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
drivers/watchdog/ks8695_wdt.c:64:       unsigned long tval = wdt_time * CLOCK_TICK_RATE;

I'm not sure whether this definition is used there, but adding parentheses
should be good anyways.
--
Add parentheses to prevent operator precedence errors

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/include/asm-h8300/timex.h b/include/asm-h8300/timex.h
index 2041314..23e6701 100644
--- a/include/asm-h8300/timex.h
+++ b/include/asm-h8300/timex.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_H8300_TIMEX_H
 #define _ASM_H8300_TIMEX_H
 
-#define CLOCK_TICK_RATE CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
+#define CLOCK_TICK_RATE (CONFIG_CPU_CLOCK*1000/8192) /* Timer input freq. */
 
 typedef unsigned long cycles_t;
 extern short h8300_timer_count;
