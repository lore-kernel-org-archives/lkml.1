Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZCYAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZCYAcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbZCYA3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:40 -0400
Received: from kroah.org ([198.145.64.141]:54049 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756707AbZCYA3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 07/61] pci: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:11 -0700
Message-Id: <1237940825-22904-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/pci/hotplug/cpqphp_sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_sysfs.c b/drivers/pci/hotplug/cpqphp_sysfs.c
index a13abf5..8450f4a 100644
--- a/drivers/pci/hotplug/cpqphp_sysfs.c
+++ b/drivers/pci/hotplug/cpqphp_sysfs.c
@@ -225,7 +225,8 @@ void cpqhp_shutdown_debugfs(void)
 
 void cpqhp_create_debugfs_files(struct controller *ctrl)
 {
-	ctrl->dentry = debugfs_create_file(ctrl->pci_dev->dev.bus_id, S_IRUGO, root, ctrl, &debug_ops);
+	ctrl->dentry = debugfs_create_file(dev_name(&ctrl->pci_dev->dev),
+					   S_IRUGO, root, ctrl, &debug_ops);
 }
 
 void cpqhp_remove_debugfs_files(struct controller *ctrl)
-- 
1.6.2

