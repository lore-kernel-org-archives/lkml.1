Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYAYHWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYAYHWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYAYHP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:26 -0500
Received: from ns.suse.de ([195.135.220.2]:52518 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbYAYHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 024/196] mtd: Convert from class_device to device for MTD/mtdchar
Date: Thu, 24 Jan 2008 23:09:22 -0800
Message-Id: <1201245134-4876-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

struct class_device is going away, this converts the code to use struct
device instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mtd/mtdchar.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 22ed96c..a0cee86 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -27,12 +27,10 @@ static void mtd_notify_add(struct mtd_info* mtd)
 	if (!mtd)
 		return;
 
-	class_device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
-			    NULL, "mtd%d", mtd->index);
+	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2), "mtd%d", mtd->index);
 
-	class_device_create(mtd_class, NULL,
-			    MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
-			    NULL, "mtd%dro", mtd->index);
+	device_create(mtd_class, NULL,
+		      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1), "mtd%dro", mtd->index);
 }
 
 static void mtd_notify_remove(struct mtd_info* mtd)
@@ -40,8 +38,8 @@ static void mtd_notify_remove(struct mtd_info* mtd)
 	if (!mtd)
 		return;
 
-	class_device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2));
-	class_device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1));
+	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2));
+	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1));
 }
 
 static struct mtd_notifier notifier = {
-- 
1.5.3.8

