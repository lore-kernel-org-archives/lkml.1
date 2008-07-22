Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYGVF2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYGVF2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbYGVFW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:53803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbYGVFWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 21/79] device create: mtd: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:45 -0700
Message-Id: <1216703983-21448-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mtd/mtdchar.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 129d429..aef9f4b 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -28,10 +28,13 @@ static void mtd_notify_add(struct mtd_info* mtd)
 	if (!mtd)
 		return;
 
-	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2), "mtd%d", mtd->index);
+	device_create_drvdata(mtd_class, NULL,
+			      MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
+			      NULL, "mtd%d", mtd->index);
 
-	device_create(mtd_class, NULL,
-		      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1), "mtd%dro", mtd->index);
+	device_create_drvdata(mtd_class, NULL,
+			      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
+			      NULL, "mtd%dro", mtd->index);
 }
 
 static void mtd_notify_remove(struct mtd_info* mtd)
-- 
1.5.6.3

