Return-Path: <linux-kernel-owner+w=401wt.eu-S936831AbZFPF7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936831AbZFPF7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935862AbZFPFv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:26 -0400
Received: from kroah.org ([198.145.64.141]:48401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935852AbZFPFvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux1394-devel@lists.sourceforge.net,
       Kristian Hoegsberg <krh@redhat.com>
Subject: [PATCH 38/64] firewire: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:27 -0700
Message-Id: <1245131213-24168-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux1394-devel@lists.sourceforge.net
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kristian Hoegsberg <krh@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firewire/fw-sbp2.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.6.3.2

