Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0BAS1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:27:21 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:36447 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0BAS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:27:19 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Peter Osterlund <petero2@telia.com>
Subject: [PATCH] pktcdvd: removing device does not remove its sysfs dir
Date: Mon,  1 Feb 2010 16:23:05 -0200
Message-Id: <1265048586-8194-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the counterpart to cba767175becadc5c4016cceb7bfdd2c7fe722f4.
Device is not registered using dev_t, so it should not be destroyed
using device_destroy which looks up the device by dev_t. This will fail
and adding the device again will fail with the "duplicate name" error.
This is fixed using device_unregister instead of device_destroy.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/block/pktcdvd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2ddf03a..68b5957 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -322,7 +322,7 @@ static void pkt_sysfs_dev_remove(struct pktcdvd_device *pd)
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_unregister(pd->dev);
 }
 
 
-- 
1.6.6.1

