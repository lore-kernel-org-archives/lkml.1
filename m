Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYIOUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYIOUER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYIOUC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:02:56 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:39929 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbYIOUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:02:54 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] gpio_free might sleep, x86 architecture
Date: Mon, 15 Sep 2008 22:02:43 +0200
Message-Id: <1221508963-27259-5-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation gpio_free should only be called from task
context only.  To make this more explicit add a might sleep to all
implementations.

This patch changes the gpio_free implementations for the x86
architecture.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/asm-x86/mach-rdc321x/gpio.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/mach-rdc321x/gpio.h b/include/asm-x86/mach-rdc321x/gpio.h
index acce0b7..3639ece 100644
--- a/include/asm-x86/mach-rdc321x/gpio.h
+++ b/include/asm-x86/mach-rdc321x/gpio.h
@@ -1,6 +1,8 @@
 #ifndef _RDC321X_GPIO_H
 #define _RDC321X_GPIO_H
 
+#include <linux/kernel.h>
+
 extern int rdc_gpio_get_value(unsigned gpio);
 extern void rdc_gpio_set_value(unsigned gpio, int value);
 extern int rdc_gpio_direction_input(unsigned gpio);
@@ -18,6 +20,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 	rdc_gpio_free(gpio);
 }
 
-- 
1.5.6.5

