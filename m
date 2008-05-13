Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYEMG6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYEMG6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYEMG6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:58:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61003 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYEMG6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:58:19 -0400
Message-ID: <48293BB8.5090206@cn.fujitsu.com>
Date: Tue, 13 May 2008 14:56:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: rpurdie@rpsys.net
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: fix unsigned value overflow in for loop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following unsigned variable overflow:
	unsigned i;
	for (i = n; i >= 0; i--)
	...

It won't break anything to use type 'int'.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/leds/leds-atmel-pwm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
index 28db6c1..52297c3 100644
--- a/drivers/leds/leds-atmel-pwm.c
+++ b/drivers/leds/leds-atmel-pwm.c
@@ -37,7 +37,7 @@ static int __init pwmled_probe(struct platform_device *pdev)
 {
 	const struct gpio_led_platform_data	*pdata;
 	struct pwmled				*leds;
-	unsigned				i;
+	int					i;
 	int					status;
 
 	pdata = pdev->dev.platform_data;
-- 
1.5.4.rc3
