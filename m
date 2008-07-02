Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYGBO3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYGBO3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGBO3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:29:22 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:37133 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753694AbYGBO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:29:20 -0400
Message-Id: <20080702142918.245723113@fluff.org>
References: <20080702142918.143669690@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 02 Jul 2008 15:29:19 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/1] MFD: SM501 fix gpio number calculation for upper bank
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-gpionrfix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sm501_gpio_pin2nr() routine returns the wrong values
for gpios in the upper bank. 

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc8-quilt3.orig/drivers/mfd/sm501.c	2008-07-02 14:17:49.000000000 +0100
+++ linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c	2008-07-02 14:44:06.000000000 +0100
@@ -1108,7 +1108,9 @@ static void sm501_gpio_remove(struct sm5
 static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
-	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+	int base = (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+
+	return (pin % 32) + base;
 }
 
 static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)

-- 
