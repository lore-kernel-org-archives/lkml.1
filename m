Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYGKNsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYGKNsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbYGKNrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:51 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34971 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755622AbYGKNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:50 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 25/30] W1: ds2490.c ds_reset remove ds_wait_status
Date: Fri, 11 Jul 2008 17:51:40 +0400
Message-Id: <12157843071820-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ds_reset no longer calls ds_wait_status, the result wasn't used and it
would only delay the following data operations.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 0bcdd3f..eb902ab 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -457,7 +457,7 @@ static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 		return 0;
 }
 
-static int ds_reset(struct ds_device *dev, struct ds_status *st)
+static int ds_reset(struct ds_device *dev)
 {
 	int err;
 
@@ -466,14 +466,6 @@ static int ds_reset(struct ds_device *dev, struct ds_status *st)
 	if (err)
 		return err;
 
-	ds_wait_status(dev, st);
-#if 0
-	if (st->command_buffer_status) {
-		printk(KERN_INFO "Short circuit.\n");
-		return -EIO;
-	}
-#endif
-
 	return 0;
 }
 
@@ -809,12 +801,9 @@ static u8 ds9490r_read_block(void *data, u8 *buf, int len)
 static u8 ds9490r_reset(void *data)
 {
 	struct ds_device *dev = data;
-	struct ds_status st;
 	int err;
 
-	memset(&st, 0, sizeof(st));
-
-	err = ds_reset(dev, &st);
+	err = ds_reset(dev);
 	if (err)
 		return 1;
 
-- 
1.4.4.4

