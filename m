Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbZEKUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbZEKUS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZEKUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:18:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:18846 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbZEKUSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=lHNnMkd76aIenOdKEAEYT7B8lxrYoVBe6OQlVbGWCPt0P/+fxugs+8InwTVvtPIj/L
         2CpCGrxFTKWraka6EGaIn0qererp8NszgaOxI4WaVaUmNvIkip04Yz/bdy+F8mJI9YPI
         5GoZWWIhnOIAm1PnTkDuwzQKBpd5ivvLDoNJQ=
Message-ID: <4A088827.7000907@gmail.com>
Date: Mon, 11 May 2009 22:18:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: krh@redhat.com, linux1394-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] firewire: remove driver_data direct access of struct device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 2bcf515..a70e66e 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1125,7 +1125,7 @@ static int sbp2_probe(struct device *dev)
 		return -ENOMEM;
 
 	tgt = (struct sbp2_target *)shost->hostdata;
-	unit->device.driver_data = tgt;
+	dev_set_drvdata(&unit->device, tgt);
 	tgt->unit = unit;
 	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
@@ -1180,7 +1180,7 @@ static int sbp2_probe(struct device *dev)
 static int sbp2_remove(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
-	struct sbp2_target *tgt = unit->device.driver_data;
+	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 
 	sbp2_target_put(tgt);
 	return 0;
@@ -1240,7 +1240,7 @@ static void sbp2_reconnect(struct work_struct *work)
 
 static void sbp2_update(struct fw_unit *unit)
 {
-	struct sbp2_target *tgt = unit->device.driver_data;
+	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu;
 
 	fw_device_enable_phys_dma(fw_device(unit->device.parent));
