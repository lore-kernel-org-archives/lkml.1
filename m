Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZCDMMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZCDMMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZCDMME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:12:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:33943 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCDMMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=u88PeZwUnKK3akDVGPLcF41l2B/aLqh1gQB6NY1J7KvxpG+xewIULPOSWBSfwsAHe4
         MI5XF/weldDHYJ0idbY5q4q/dBwkZ0EHvGwW6WjDWt5GcWUkPvN3v6qLQ9CzeTw3OG88
         UVvcnXeM12h93HMrXhkgo3iIiKjMePyeLpfhM=
Date: Wed, 4 Mar 2009 20:11:31 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH]remove a unnecessary "goto" on drivers/leds/leds-s3c24.c
Message-ID: <20090304121131.GA6854@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove a unnecessary goto on drivers/leds/leds-s3c24xx.c.
This goto is unnecessary.
-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

>From d5a6f29599d0dc94a6eda203414fb5d6ad99c68d Mon Sep 17 00:00:00 2001
From: Zhenwen Xu<helight.xu@gmail.com>
Date: Wed, 4 Mar 2009 20:02:34 +0800
Subject: [PATCH] remove a unnecessary goto on drivers/leds/leds-s3c24xx.c


Signed-off-by: Zhenwen Xu<helight.xu@gmail.com>
---
 drivers/leds/leds-s3c24xx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 4d81131..aa2e7ae 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -102,14 +102,11 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 	ret = led_classdev_register(&dev->dev, &led->cdev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "led_classdev_register failed\n");
-		goto exit_err1;
+		kfree(led);
+		return ret;
 	}
 
 	return 0;
-
- exit_err1:
-	kfree(led);
-	return ret;
 }
 
 static struct platform_driver s3c24xx_led_driver = {
-- 
1.5.6.5

