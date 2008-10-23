Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYJWKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYJWKrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJWKrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:47:11 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:14282 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYJWKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Lkh7mKWW+ZzJLrc6QdA9GVtsFYwB765eZZxBMq5PVW5t+dr8i649L49/PPWHBTkSGI
         4u36KV1mW0GUC7q2WY7sclWG+2Rz28BdeIt6k6/RLfPqok5nKyYXdkFaIZ3JZCKc8L2/
         OUXVUdZGvY9MFEAaivGHkZQlxL4U5ac9J3yhQ=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] RTC S3C: Add device_init_wakeup() invokation
Date: Thu, 23 Oct 2008 13:46:55 +0300
Message-Id: <1224758815-23131-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device_init_wakeup() ivokation to probe function of
s3c2410_rtc_driver. Without of this wakealarm sysfs attribute does not
initialise.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/rtc/rtc-s3c.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 9a92ee1..70d9fc3 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -455,6 +455,8 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	/* register RTC and exit */
 
 	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
-- 
1.5.6.5

