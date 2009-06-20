Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZFTPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZFTPIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTPId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:08:33 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:57266 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZFTPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qTje7bdydoDuBULAGMlMxqtN6xnCPQ0FSkTpMHxaLt75LBf4MowO+jdt+zYH6XgVGZ
         UjVi/z7d/DxF22WkYuZGvCc9qG/8Z/cNzm/HSa0OOW28+aMam8IvZJu7soE9KkpWmtUb
         CSZAYMw/HIfEzofjAWzQncyULMZmZuMTAug7E=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH] Staging: vt6655: fix build when !CONFIG_WIRELESS_EXT
Date: Sat, 20 Jun 2009 19:07:40 +0400
Message-Id: <1245510460-32102-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_WIRELESS_EXT is not set:
drivers/staging/vt6655/device_main.c:1153: error: 'struct net_device'
	has no member named 'wireless_handlers'

Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/vt6655/device_main.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a10ed27..878c0f0 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1146,14 +1146,9 @@ device_found1(struct pci_dev *pcid, const struct pci_device_id *ent)
     dev->irq                = pcid->irq;
     dev->netdev_ops         = &device_netdev_ops;
 
-#ifdef WIRELESS_EXT
-//Einsn Modify for ubuntu-7.04
-//	dev->wireless_handlers->get_wireless_stats = iwctl_get_wireless_stats;
-#if WIRELESS_EXT > 12
+#ifdef CONFIG_WIRELESS_EXT
 	dev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
-//	netdev->wireless_handlers = NULL;
-#endif /* WIRELESS_EXT > 12 */
-#endif /* WIRELESS_EXT */
+#endif
 
     rc = register_netdev(dev);
     if (rc)
-- 
1.6.3.1

