Return-Path: <linux-kernel-owner+w=401wt.eu-S966410AbXG3CsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966410AbXG3CsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966024AbXG3Cr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41603 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936098AbXG3CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:22 -0400
Message-Id: <20070730024719.502748134@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:37 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=initialize-last_tick-in-calc_load.patch
Subject: [PATCH -rt 3/9] Fix jiffies wrap issue in update_times
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In prior -rt verisons the last_tick value was called wall_jiffies 
and was initialized in this same way as below. If this value isn't
initialized the calc_load function gets skewed for several minutes
right after boot up. Skewed meaning always zero.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/kernel/timer.c
===================================================================
--- linux-2.6.22.orig/kernel/timer.c
+++ linux-2.6.22/kernel/timer.c
@@ -987,7 +987,7 @@ void run_local_timers(void)
  */
 static inline void update_times(void)
 {
-	static unsigned long last_tick;
+	static unsigned long last_tick = INITIAL_JIFFIES;
 	unsigned long ticks, flags;
 
 	/*

-- 
