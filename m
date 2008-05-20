Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYEUAG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYEUAG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYEUAGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:06:41 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:45879 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764160AbYEUAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:06:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=BPsiIIxDDg6Ztqaj7XTtmOk8fGK+/gnOQtBauH3dvFU8LegGpabMKA4cuhrjvzkmSa1IWe1Nds8yDL5Ao/YMx3xvqd+vtzZpU26LqWyL+sutNKEA8sJYGG2UjZgOucx9hKn1+BZXezJmXk/Rj7UJJd/25fUa1oRcAcjgCmktKJY=  ;
X-YMail-OSG: JyPqUQ8VM1kFCsgc3YR4CUeisUe35q7ROY7lU0BTcwf4dhq9G2XEm.94dkqb1_Flx2sLdTPNDi8jeBrN3WQWv3970xlN4YeriIwPnp9XTuns7A4QcGrHEA1TdpFYuLWKfKQ-
X-Yahoo-Newman-Property: ymail-3
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc3] gpio: build fixes (mostly potential)
Cc: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Tue, 20 May 2008 16:17:57 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200805201617.57191.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes various gpio-related build errors (mostly potential)
reported in part by Russell King and Uwe Kleine-König.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Refreshed version -- should apply OK on top of the gpio sysfs support

 include/asm-generic/gpio.h |    6 +++++-
 include/linux/gpio.h       |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/asm-generic/gpio.h	2008-05-20 11:46:13.000000000 -0700
+++ b/include/asm-generic/gpio.h	2008-05-20 11:47:46.000000000 -0700
@@ -1,8 +1,12 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
+#include <linux/types.h>
+
 #ifdef CONFIG_HAVE_GPIO_LIB
 
+#include <linux/compiler.h>
+
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
  * extra memory (for code and for per-GPIO table entries).
@@ -78,7 +82,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
-extern int __init __must_check gpiochip_reserve(int start, int ngpio);
+extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
--- a/include/linux/gpio.h	2008-05-20 11:46:13.000000000 -0700
+++ b/include/linux/gpio.h	2008-05-20 11:47:09.000000000 -0700
@@ -8,6 +8,9 @@
 
 #else
 
+#include <linux/types.h>
+#include <linux/errno.h>
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
