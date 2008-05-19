Return-Path: <linux-kernel-owner+w=401wt.eu-S1764127AbYETApf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764127AbYETApf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYETAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:45:27 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39769 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754916AbYETAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:45:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jterkAP89CkkRbjD+gWyFUmFumCB83DdJCjHUpXHZoX4gN3mct4lPH234eYMXfwqDdQaQfUvNHlqGNaNfVf0S/C6msOPro/B/B421Rhx1XYlKkDkKlrDmVQyQMYBo4fWQsfyrCT5LJd6SNYEx1mh/GZzZp7Q7seQmmq9ObiHLpI=  ;
X-YMail-OSG: M1REdpIVM1n22OBNPjUOxGP91W_YHdoi8AiLwIuUmtX977DIdnZbMCibkjDRCAi89fiQMhZFLM7Q6W4SzUoMyvrXSpqeiPZ0rSihAm_x6Jj5Zh0BbKzJ.Cl3afe0Rd1.C_k-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc3] gpio: build fixes (mostly potential)
Date: Mon, 19 May 2008 15:50:18 -0700
User-Agent: KMail/1.9.9
Cc: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805191550.18937.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes various gpio-related build errors (mostly potential)
reported by Russell King and Uwe Kleine-König.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/asm-generic/gpio.h |    4 +++-
 include/linux/gpio.h       |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/asm-generic/gpio.h	2008-05-19 14:59:51.000000000 -0700
+++ b/include/asm-generic/gpio.h	2008-05-19 15:05:18.000000000 -0700
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_HAVE_GPIO_LIB
 
+#include <linux/compiler.h>
+
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
  * extra memory (for code and for per-GPIO table entries).
@@ -74,7 +76,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
-extern int __init __must_check gpiochip_reserve(int start, int ngpio);
+extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
--- a/include/linux/gpio.h	2008-05-19 15:05:34.000000000 -0700
+++ b/include/linux/gpio.h	2008-05-19 15:06:54.000000000 -0700
@@ -8,6 +8,8 @@
 
 #else
 
+#include <linux/errno.h>
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
