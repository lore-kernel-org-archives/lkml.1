Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZD1JFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZD1JFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZD1JEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:04:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52014 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZD1JEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=BGu08+VA4Wj+fTHY9HnmP2LUEw0oR9hzJx2i9fPrLQkxeMRdO+N0CdCL2NtHYdh+kf
         bsLfp3/8tzUezTSlQWhZK7J+Y+JnBdCwxsxcBEvZzZXuWAwvZZ//UER/KS39lhPf4YyN
         e36xEsstEZaFKWB61ou7k5hPMTOCtj1HWBxHY=
Date: Tue, 28 Apr 2009 17:03:08 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net
Subject: [PATCH] fix a Section mismatch on drivers/leds/leds-gpio.c
Message-ID: <20090428090308.GA9006@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this section mismatch:

WARNING: drivers/leds/leds-gpio.o(.text+0x153): Section mismatch in reference from the function gpio_led_probe() to the function .devinit.text:create_gpio_led()
The function gpio_led_probe() references
the function __devinit create_gpio_led().
This is often because gpio_led_probe lacks a __devinit
annotation or the annotation of create_gpio_led is wrong.



Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/leds/leds-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index d210905..76895e6 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -129,7 +129,7 @@ static void delete_gpio_led(struct gpio_led_data *led)
 }
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM
-static int gpio_led_probe(struct platform_device *pdev)
+static int __devinit gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_led_data *leds_data;
-- 
1.5.6.5

-- 
--------------------------------
http://zhwen.org - Open and Free
