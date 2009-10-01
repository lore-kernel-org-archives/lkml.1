Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZJAMZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZJAMZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbZJAMZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:25:42 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50853 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbZJAMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:25:41 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org, daniel@caiaq.de
Cc: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 1/1] LIS3LV02D_SPI: Module unload didn't remove sysfs entry
Date: Thu,  1 Oct 2009 15:25:24 +0300
Message-Id: <1254399924-30921-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1254399924-30921-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1254399924-30921-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 01 Oct 2009 12:25:31.0744 (UTC) FILETIME=[449F7600:01CA4292]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In module unload, lis3lv02d core driver sysfs clean up was not called.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/hwmon/lis3lv02d_spi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index ecd7395..82b1680 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -83,7 +83,8 @@ static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(lis3);
-	return 0;
+
+	return lis3lv02d_remove_fs(&lis3_dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.5.6.3

