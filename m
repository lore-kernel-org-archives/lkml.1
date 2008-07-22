Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYGVFfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYGVFfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYGVFYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:43166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbYGVFYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Maxim Krasnyansky <maxk@qualcomm.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 42/79] bluetooth: remove improper bluetooth class symlinks.
Date: Mon, 21 Jul 2008 22:19:06 -0700
Message-Id: <1216703983-21448-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't create symlinks in a class to a device that is not owned by the
class.  If the bluetooth subsystem really wants to point to all of the
devices it controls, it needs to create real devices, not fake symlinks.

Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bluetooth/hci_sysfs.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 844ca5f..c85bf8f 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -398,10 +398,6 @@ int hci_register_sysfs(struct hci_dev *hdev)
 		if (device_create_file(dev, bt_attrs[i]) < 0)
 			BT_ERR("Failed to create device attribute");
 
-	if (sysfs_create_link(&bt_class->subsys.kobj,
-				&dev->kobj, kobject_name(&dev->kobj)) < 0)
-		BT_ERR("Failed to create class symlink");
-
 	return 0;
 }
 
@@ -409,9 +405,6 @@ void hci_unregister_sysfs(struct hci_dev *hdev)
 {
 	BT_DBG("%p name %s type %d", hdev, hdev->name, hdev->type);
 
-	sysfs_remove_link(&bt_class->subsys.kobj,
-					kobject_name(&hdev->dev.kobj));
-
 	device_del(&hdev->dev);
 }
 
-- 
1.5.6.3

