Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbYGVFZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbYGVFZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbYGVFWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:20 -0400
Received: from mail.suse.de ([195.135.220.2]:53750 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYGVFWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: [PATCH 12/79] device create: hwmon: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:36 -0700
Message-Id: <1216703983-21448-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/hwmon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 3db2845..7321a88 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -55,7 +55,8 @@ again:
 		return ERR_PTR(err);
 
 	id = id & MAX_ID_MASK;
-	hwdev = device_create(hwmon_class, dev, MKDEV(0,0), HWMON_ID_FORMAT, id);
+	hwdev = device_create_drvdata(hwmon_class, dev, MKDEV(0, 0), NULL,
+				      HWMON_ID_FORMAT, id);
 
 	if (IS_ERR(hwdev)) {
 		spin_lock(&idr_lock);
-- 
1.5.6.3

