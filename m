Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYGYVFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYGYVFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYGYVEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:04:47 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:58616 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbYGYVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:04:46 -0400
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       Trent Piepho <tpiepho@freescale.com>
Subject: [PATCH 1/2] leds: make the default trigger name const
Date: Fri, 25 Jul 2008 14:01:44 -0700
Message-Id: <1217019705-24244-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default_trigger fields of struct gpio_led and thus struct led_classdev
are pretty much always assigned from a string literal, which means the
string can't be modified.  Which is fine, since there is no reason to
modify the string and in fact it never is.

But they should be marked const to prevent such code from being added, to
prevent warnings if -Wwrite-strings is used and when assigned from a
constant string other than a string literal (which produces a warning under
current kernel compiler flags), and for general good coding practices.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
---
 include/linux/leds.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 519df72..defe693 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -48,7 +48,7 @@ struct led_classdev {
 
 	struct device		*dev;
 	struct list_head	 node;			/* LED Device list */
-	char			*default_trigger;	/* Trigger to use */
+	const char		*default_trigger;	/* Trigger to use */
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
@@ -121,7 +121,7 @@ extern void ledtrig_ide_activity(void);
 /* For the leds-gpio driver */
 struct gpio_led {
 	const char *name;
-	char *default_trigger;
+	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
 };
-- 
1.5.4.3

