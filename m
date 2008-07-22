Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYGVFYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYGVFYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbYGVFWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:53721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYGVFWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/79] device create: dvb: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:33 -0700
Message-Id: <1216703983-21448-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/dvb/dvb-core/dvbdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index e208a60..e713277 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -233,9 +233,9 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	mutex_unlock(&dvbdev_register_lock);
 
-	clsdev = device_create(dvb_class, adap->device,
+	clsdev = device_create_drvdata(dvb_class, adap->device,
 			       MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
-			       "dvb%d.%s%d", adap->num, dnames[type], id);
+			       NULL, "dvb%d.%s%d", adap->num, dnames[type], id);
 	if (IS_ERR(clsdev)) {
 		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
-- 
1.5.6.3

