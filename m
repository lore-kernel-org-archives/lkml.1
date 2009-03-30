Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZC3HNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZC3HNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZC3HNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:13:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZC3HNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:13:05 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] include CONFIG_STACK_TRACER in boot warning about debug options
Date: Mon, 30 Mar 2009 09:13:00 +0200
Message-Id: <1238397180-26913-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_STACK_TRACER=y contributes to DEBUG_COUNT, but it was not
included in the list.  This resulted in the following snipplet in my kernel
log:

[   16.170275] *****************************************************************************
[   16.178530] *                                                                           *
[   16.186782] *  REMINDER, the following debugging option is turned on in your .config:   *
[   16.195033] *                                                                           *
[   16.203288] *                                                                           *
[   16.211535] *  it may increase runtime overhead and latencies.                          *
[   16.219777] *                                                                           *
[   16.228026] *****************************************************************************

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch applies on top of 

	realtime: preempt warn about tracing

in the latest preempt-rt patch set.

Best regards
Uwe

 init/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 661cc0f..1e27ac5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -924,8 +924,8 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_FTRACE
-	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
+#ifdef CONFIG_STACK_TRACER
+	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
 #endif
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	printk(KERN_ERR "*        CONFIG_WAKEUP_LATENCY_HIST                                         *\n");
@@ -939,6 +939,9 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_LOCKDEP
 	printk(KERN_ERR "*        CONFIG_LOCKDEP                                                     *\n");
 #endif
+#ifdef CONFIG_FTRACE
+	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
+#endif
 	printk(KERN_ERR "*                                                                           *\n");
 #if DEBUG_COUNT == 1
 	printk(KERN_ERR "*  it may increase runtime overhead and latencies.                          *\n");
-- 
1.6.2.1

