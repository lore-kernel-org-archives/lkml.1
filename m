Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZERHnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZERHnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZERHmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:42:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41732 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbZERHmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:42:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: [PATCH] drivers/hvc: add missing __devexit_p()
Date: Mon, 18 May 2009 03:42:01 -0400
Message-Id: <1242632521-15954-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
---
 drivers/char/hvc_iseries.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index 449727b..936d05b 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -241,7 +241,7 @@ static int __devexit hvc_vio_remove(struct vio_dev *vdev)
 static struct vio_driver hvc_vio_driver = {
 	.id_table	= hvc_driver_table,
 	.probe		= hvc_vio_probe,
-	.remove		= hvc_vio_remove,
+	.remove		= __devexit_p(hvc_vio_remove),
 	.driver		= {
 		.name	= hvc_driver_name,
 		.owner	= THIS_MODULE,
-- 
1.6.3

