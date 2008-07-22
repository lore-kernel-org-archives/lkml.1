Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYGVFZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYGVFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGVFWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:16 -0400
Received: from mail.suse.de ([195.135.220.2]:53739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYGVFWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 11/79] device create: hid: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:35 -0700
Message-Id: <1216703983-21448-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hid/hidraw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 2fde6c6..0c6b4d4 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -322,8 +322,9 @@ int hidraw_connect(struct hid_device *hid)
 		goto out;
 	}
 
-	dev->dev = device_create(hidraw_class, NULL, MKDEV(hidraw_major, minor),
-				"%s%d", "hidraw", minor);
+	dev->dev = device_create_drvdata(hidraw_class, NULL,
+					 MKDEV(hidraw_major, minor), NULL,
+					 "%s%d", "hidraw", minor);
 
 	if (IS_ERR(dev->dev)) {
 		spin_lock(&minors_lock);
-- 
1.5.6.3

