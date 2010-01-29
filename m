Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686Ab0A2EWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0A2EWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672Ab0A2EWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:22:47 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53571 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab0A2EWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:22:46 -0500
From: John Stultz <johnstul@us.ibm.com>
To: Chris Zankel <chris@zankel.net>, <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] xtensa: Fix unnecessary setting of xtime
Date: Thu, 28 Jan 2010 20:22:27 -0800
Message-Id: <1264738947-21986-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtensa supports read_persisitent_clock(), so there is no reason for
the arch specific code to be setting xtime. Setting xtime will be done
by the generic timekeeping code.

Please let me know if this is some sort of a workaround for an issue
instead of just an oversight.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/xtensa/kernel/time.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19f7df3..19df764 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -60,11 +60,6 @@ static struct irqaction timer_irqaction = {
 
 void __init time_init(void)
 {
-	/* FIXME: xtime&wall_to_monotonic are set in timekeeping_init. */
-	read_persistent_clock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
-
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 	printk("Calibrating CPU frequency ");
 	platform_calibrate_ccount();
-- 
1.6.0.4

