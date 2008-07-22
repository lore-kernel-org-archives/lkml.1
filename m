Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYGVF3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYGVF3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbYGVFXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:43080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYGVFXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 24/79] device create: scsi: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:48 -0700
Message-Id: <1216703983-21448-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/dpt_i2o.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 2bc30e3..1fe0901 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -271,8 +271,8 @@ rebuild_sys_tab:
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
 		if (adpt_sysfs_class) {
-			struct device *dev = device_create(adpt_sysfs_class,
-				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit),
+			struct device *dev = device_create_drvdata(adpt_sysfs_class,
+				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit), NULL,
 				"dpti%d", pHba->unit);
 			if (IS_ERR(dev)) {
 				printk(KERN_WARNING"dpti%d: unable to "
-- 
1.5.6.3

