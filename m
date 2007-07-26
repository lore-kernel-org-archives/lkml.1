Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbXGZQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbXGZQc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbXGZQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:32:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35008 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbXGZQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:32:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix missing arguments in drivers/rtc/rtc-stk17ta8.c
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6Gf-00058W-Aa@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:32:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


struct bin_attribute * is needed in bin_attribute ->read()/->write()
now.  Incidentally, could people please run the fscking compiler
before and after applying their patch and compare the build logs?
That (and many, many other) would be caught immediately.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/rtc/rtc-stk17ta8.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index f10d3fa..8288b6b 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -258,7 +258,8 @@ static const struct rtc_class_ops stk17ta8_rtc_ops = {
 	.ioctl		= stk17ta8_rtc_ioctl,
 };
 
-static ssize_t stk17ta8_nvram_read(struct kobject *kobj, char *buf,
+static ssize_t stk17ta8_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *attr, char *buf,
 				 loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
@@ -272,7 +273,8 @@ static ssize_t stk17ta8_nvram_read(struct kobject *kobj, char *buf,
 	return count;
 }
 
-static ssize_t stk17ta8_nvram_write(struct kobject *kobj, char *buf,
+static ssize_t stk17ta8_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *attr, char *buf,
 				  loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
-- 
1.5.3.GIT


