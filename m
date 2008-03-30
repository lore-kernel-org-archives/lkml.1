Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYC3XPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYC3XPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYC3XNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53922 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbYC3XNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:08 -0400
Date: Mon, 31 Mar 2008 02:12:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] char/cs5535_gpio.c: don't use 0 as NULL pointer
Message-ID: <20080330231256.GH28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use 0 as NULL pointer.

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
222d75d575dcc142dedce63ffc5d7addc5567ec9 diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index c2d23ca..c0a4a0b 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -215,7 +215,7 @@ static int __init cs5535_gpio_init(void)
 	else
 		mask = 0x0b003c66;
 
-	if (request_region(gpio_base, CS5535_GPIO_SIZE, NAME) == 0) {
+	if (!request_region(gpio_base, CS5535_GPIO_SIZE, NAME)) {
 		printk(KERN_ERR NAME ": can't allocate I/O for GPIO\n");
 		return -ENODEV;
 	}

