Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZERHoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZERHoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZERHoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:44:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42181 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbZERHoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:44:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Subject: [PATCH v2] drivers/hvc: add missing __devexit_p()
Date: Mon, 18 May 2009 03:44:21 -0400
Message-Id: <1242632661-16198-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242632521-15954-1-git-send-email-vapier@gentoo.org>
References: <1242632521-15954-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: linuxppc-dev@ozlabs.org
---
v2
	- include all hvc files

 drivers/char/hvc_iseries.c |    2 +-
 drivers/char/hvc_vio.c     |    2 +-
 drivers/char/hvcs.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index bd62dc8..c72b994 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -113,7 +113,7 @@ static int __devexit hvc_vio_remove(struct vio_dev *vdev)
 static struct vio_driver hvc_vio_driver = {
 	.id_table	= hvc_driver_table,
 	.probe		= hvc_vio_probe,
-	.remove		= hvc_vio_remove,
+	.remove		= __devexit_p(hvc_vio_remove),
 	.driver		= {
 		.name	= hvc_driver_name,
 		.owner	= THIS_MODULE,
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index c76bccf..2724d62 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -868,7 +868,7 @@ static int __devexit hvcs_remove(struct vio_dev *dev)
 static struct vio_driver hvcs_vio_driver = {
 	.id_table	= hvcs_driver_table,
 	.probe		= hvcs_probe,
-	.remove		= hvcs_remove,
+	.remove		= __devexit_p(hvcs_remove),
 	.driver		= {
 		.name	= hvcs_driver_name,
 		.owner	= THIS_MODULE,
-- 
1.6.3

