Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYHAVsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYHAVsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbYHAVsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:48:17 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:36753 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629AbYHAVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:48:16 -0400
Date: Fri, 1 Aug 2008 23:48:04 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: Move triggers before drivers in Makefile
Message-ID: <alpine.LNX.1.10.0808012344090.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 21:48:14 +0000
	Bayes: 0.0123 Tokens: new, 211; hammy, 4; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0123]
X-Spam-Signature: 90a586bd6757a5de3a3f5f00fafa5c4c401d7d93
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When both triggers and drivers are built-in, we should first register the
triggers and then the drivers, to make default triggers work during device
registration. We do this by moving the triggers before the drivers in the
Makefile as init order is determined by linking order. Sadly this simple
solution doesn't cover devices registered elsewhere in the kernel. But often
these drivers provide their own triggers and should themselves take care of
registering triggers before devices.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/Makefile |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

Patch is based on your current (024e8ac) leds git tree head.

diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index ff7982b..fa0f257 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -4,6 +4,13 @@ obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
+# LED Triggers
+# Handle triggers before drivers, to make default triggers work, when built-in.
+obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
+obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
+obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_CORGI)		+= leds-corgi.o
@@ -23,9 +30,3 @@ obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
-
-# LED Triggers
-obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
-obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
-obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
-obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
