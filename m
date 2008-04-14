Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbYDNSpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbYDNSpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934200AbYDNSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51104 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764132AbYDNSm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:27 -0400
Date: Mon, 14 Apr 2008 21:41:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] char/cs5535_gpio.c: don't use 0 as NULL pointer
Message-ID: <20080414184121.GR6695@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 31 Mar 2008

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

