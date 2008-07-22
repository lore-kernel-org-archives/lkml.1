Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYGVF1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYGVF1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYGVFWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:53773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbYGVFWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 18/79] device create: macintosh: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:42 -0700
Message-Id: <1216703983-21448-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/macintosh/adb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index e5d4468..cae5248 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -862,7 +862,8 @@ adbdev_init(void)
 	adb_dev_class = class_create(THIS_MODULE, "adb");
 	if (IS_ERR(adb_dev_class))
 		return;
-	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), "adb");
+	device_create_drvdata(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL,
+			      "adb");
 
 	platform_device_register(&adb_pfdev);
 	platform_driver_probe(&adb_pfdrv, adb_dummy_probe);
-- 
1.5.6.3

