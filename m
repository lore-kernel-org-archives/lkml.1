Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbZJNOSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbZJNOSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZJNOST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:18:19 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:55500 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZJNOSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:18:18 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Andrew Sharp <andy.sharp@lsi.com>,
       Thomas Hommel <thomas.hommel@gefanuc.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] rtc: Do not use container_of macro as an argument for to_platform_device
Date: Wed, 14 Oct 2009 23:17:01 +0900
Message-Id: <1255529821-1377-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The to_platform_device macro itself uses container_of macro.
Nested use of container_of macro causes following sparse warnings:

rtc-ds1553.c:259:3: warning: symbol '__mptr' shadows an earlier one
rtc-ds1553.c:259:3: originally declared here

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-ds1553.c   |    8 ++++----
 drivers/rtc/rtc-ds1742.c   |    8 ++++----
 drivers/rtc/rtc-stk17ta8.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index dadd0f5..ed1ef7c 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -255,8 +255,8 @@ static ssize_t ds1553_nvram_read(struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
@@ -270,8 +270,8 @@ static ssize_t ds1553_nvram_write(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 19d2f33..a127336 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -131,8 +131,8 @@ static ssize_t ds1742_nvram_read(struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
@@ -146,8 +146,8 @@ static ssize_t ds1742_nvram_write(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index df3b6c5..eb486ca 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -247,8 +247,8 @@ static ssize_t stk17ta8_nvram_read(struct kobject *kobj,
 				 struct bin_attribute *attr, char *buf,
 				 loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
@@ -262,8 +262,8 @@ static ssize_t stk17ta8_nvram_write(struct kobject *kobj,
 				  struct bin_attribute *attr, char *buf,
 				  loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
-- 
1.5.6.5

