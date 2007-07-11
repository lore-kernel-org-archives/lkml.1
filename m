Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbXGKXh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbXGKXh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934888AbXGKXdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935055AbXGKXdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/61] driver core: properly get driver in device_release_driver
Date: Wed, 11 Jul 2007 16:31:30 -0700
Message-Id: <11841967992975-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196787247-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index b0088b0..3c503e1 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -296,9 +296,8 @@ static void __device_release_driver(struct device * dev)
 {
 	struct device_driver * drv;
 
-	drv = dev->driver;
+	drv = get_driver(dev->driver);
 	if (drv) {
-		get_driver(drv);
 		driver_sysfs_remove(dev);
 		sysfs_remove_link(&dev->kobj, "driver");
 		klist_remove(&dev->knode_driver);
-- 
1.5.2.2

