Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbYBGUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbYBGUKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbYBGUEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:04:12 -0500
Received: from ns.suse.de ([195.135.220.2]:37586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbYBGUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:04:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael E Brown <Michael_E_Brown@dell.com>,
       Michael E Brown <michael_e_brown@dell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] Driver core: Revert "Fix Firmware class name collision"
Date: Thu,  7 Feb 2008 12:02:18 -0800
Message-Id: <1202414539-4672-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080207200140.GA4572@suse.de>
References: <20080207200140.GA4572@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael E Brown <Michael_E_Brown@dell.com>

This reverts commit 109f0e93b6b728f03c1eb4af02bc25d71b646c59.

The original patch breaks BIOS updates on all Dell machines. The path to
the firmware file for the dell_rbu driver changes, which breaks all of
the userspace tools which rely on it.

Note that this patch re-introduces a problem with i2c name collision
that was previously fixed by this patch.

Signed-off-by: Michael E Brown <michael_e_brown@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0295855..4a1b9bf 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -292,7 +292,8 @@ firmware_class_timeout(u_long data)
 
 static inline void fw_setup_device_id(struct device *f_dev, struct device *dev)
 {
-	snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
+	/* XXX warning we should watch out for name collisions */
+	strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
 }
 
 static int fw_register_device(struct device **dev_p, const char *fw_name,
-- 
1.5.4

