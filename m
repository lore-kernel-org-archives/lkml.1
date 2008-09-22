Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYIVWkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYIVWkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYIVWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:39:52 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:55967 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYIVWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:39:51 -0400
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trent Piepho <tpiepho@freescale.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] leds: make the default trigger name const
Date: Mon, 22 Sep 2008 15:37:53 -0700
Message-Id: <1222123073-28996-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default_trigger fields of struct gpio_led and thus struct led_classdev
are pretty much always assigned from a string literal, which means the
string can't be modified.  Which is fine, since there is no reason to
modify the string and in fact it never is.

But they should be marked const to prevent such code from being added, to
prevent warnings if -Wwrite-strings is used, when assigned from a constant
string other than a string literal (which produces a warning under current
kernel compiler flags), and for general good coding practices.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
CC: Richard Purdie <rpurdie@rpsys.net>
---
 include/linux/leds.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d41ccb5..d3a73f5 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -123,7 +123,7 @@ extern void ledtrig_ide_activity(void);
  */
 struct led_info {
 	const char	*name;
-	char		*default_trigger;
+	const char	*default_trigger;
 	int		flags;
 };
 
@@ -135,7 +135,7 @@ struct led_platform_data {
 /* For the leds-gpio driver */
 struct gpio_led {
 	const char *name;
-	char *default_trigger;
+	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
 };
-- 
1.5.4.1

