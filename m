Return-Path: <linux-kernel-owner+w=401wt.eu-S939857AbXG3WNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939857AbXG3WNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969151AbXG3WKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969317AbXG3WKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] driver core: revert "device" link creation check
Date: Mon, 30 Jul 2007 15:09:30 -0700
Message-Id: <11858334042248-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858334013561-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
 <11858333892232-git-send-email-gregkh@suse.de>
 <11858333931362-git-send-email-gregkh@suse.de>
 <11858334013561-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

driver core: revert "device" link creation check

Commit 2ee97caf0a6602f749ddbfdb1449e383e1212707 introduced an extra
check on when to create the "device" symlink. Unfortunately, this
breaks input, so let's revert to the old behaviour.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b9bb399..e6738bc 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -678,8 +678,7 @@ static int device_add_class_symlinks(struct device *dev)
 		if (error)
 			goto out_subsys;
 	}
-	/* only bus-device parents get a "device"-link */
-	if (dev->parent && dev->parent->bus) {
+	if (dev->parent) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)
-- 
1.5.2.2

