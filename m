Return-Path: <linux-kernel-owner+w=401wt.eu-S1161176AbXCAXwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161176AbXCAXwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXCAXwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:52:15 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:33972 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161176AbXCAXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:52:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3Jsv6m8xJFW91XsW+Qene3/V1mReJckCupSgJZT3DvYZJTjDyR7lno3EyIDSs5nBVIWZclSiaSJ0ZidER7ZSH8EfxjN4qv1kLnykDbAgr5EtVDaWG4J7LM1AR/7sqUnUWx7aeuFEtYzCoqBEB9V8iEwICDmFENnGTatakIVfN5g=  ;
X-YMail-OSG: lQEJi9YVM1n5IMedpgn_GCd5pXzRpZZ.8FTVipU6ZvNpU6zOK2BD_uCCRXj.Yijqz85yO5AzGqp4n7632g8JA9tXbqGvLGNV_RmuQNXLhYIte3SdGypNEoTK54eQ4DyX9S1rpPifUdBTovpkIcEdGIYvGg--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dtor@mail.ru>, pHilipp Zabel <philipp.zabel@gmail.com>
Subject: [patch 2.6.21-rc2] gpio_keys driver shouldn't be ARM-specific
Date: Thu, 1 Mar 2007 15:51:29 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011551.29696.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_keys driver is wrongly ARM-specific; it can't build on
other platforms with GPIO suport.  This fixes that problem.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
MERGE NOTE:  this just moves gpio_keys.h; this patch does no GIT magic

 include/asm-arm/hardware/gpio_keys.h |   17 -----------------
 drivers/input/keyboard/gpio_keys.c   |    4 +---
 include/linux/gpio_keys.h            |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 20 deletions(-)

Index: ap7000/drivers/input/keyboard/gpio_keys.c
===================================================================
--- ap7000.orig/drivers/input/keyboard/gpio_keys.c	2007-03-01 12:24:26.000000000 -0800
+++ ap7000/drivers/input/keyboard/gpio_keys.c	2007-03-01 12:25:54.000000000 -0800
@@ -23,11 +23,9 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/irq.h>
+#include <linux/gpio_keys.h>
 
 #include <asm/gpio.h>
-#include <asm/arch/hardware.h>
-
-#include <asm/hardware/gpio_keys.h>
 
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
Index: ap7000/include/asm-arm/hardware/gpio_keys.h
===================================================================
--- ap7000.orig/include/asm-arm/hardware/gpio_keys.h	2007-03-01 11:49:06.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-#ifndef _GPIO_KEYS_H
-#define _GPIO_KEYS_H
-
-struct gpio_keys_button {
-	/* Configuration parameters */
-	int keycode;
-	int gpio;
-	int active_low;
-	char *desc;
-};
-
-struct gpio_keys_platform_data {
-	struct gpio_keys_button *buttons;
-	int nbuttons;
-};
-
-#endif
Index: ap7000/include/linux/gpio_keys.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ap7000/include/linux/gpio_keys.h	2007-03-01 12:24:58.000000000 -0800
@@ -0,0 +1,17 @@
+#ifndef _GPIO_KEYS_H
+#define _GPIO_KEYS_H
+
+struct gpio_keys_button {
+	/* Configuration parameters */
+	int keycode;
+	int gpio;
+	int active_low;
+	char *desc;
+};
+
+struct gpio_keys_platform_data {
+	struct gpio_keys_button *buttons;
+	int nbuttons;
+};
+
+#endif
