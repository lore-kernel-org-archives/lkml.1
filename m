Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYAYHV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYAYHV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbYAYHPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:17 -0500
Received: from ns.suse.de ([195.135.220.2]:52499 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbYAYHPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Joshua Thompson <funaho@jurai.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 022/196] adb: Convert from class_device to device
Date: Thu, 24 Jan 2008 23:09:20 -0800
Message-Id: <1201245134-4876-22-git-send-email-gregkh@suse.de>
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
Cc: Joshua Thompson <funaho@jurai.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/macintosh/adb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 5c742a5..b7adde4 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -875,5 +875,5 @@ adbdev_init(void)
 	adb_dev_class = class_create(THIS_MODULE, "adb");
 	if (IS_ERR(adb_dev_class))
 		return;
-	class_device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL, "adb");
+	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), "adb");
 }
-- 
1.5.3.8

