Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712Ab0A2V1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0A2V1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683Ab0A2V1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:27:15 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:44876 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0A2V1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:27:14 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: remove BKL from uinput open function
Date: Fri, 29 Jan 2010 19:23:16 -0200
Message-Id: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8702965848ed4bee27486a3e3d2ae34ebba6dd83 has push down the BKL
into uinput open function. However, there's nothing that needs locking
in there.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/input/misc/uinput.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index d3f5724..18206e1 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -34,7 +34,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
@@ -284,7 +283,6 @@ static int uinput_open(struct inode *inode, struct file *file)
 	if (!newdev)
 		return -ENOMEM;
 
-	lock_kernel();
 	mutex_init(&newdev->mutex);
 	spin_lock_init(&newdev->requests_lock);
 	init_waitqueue_head(&newdev->requests_waitq);
@@ -292,7 +290,6 @@ static int uinput_open(struct inode *inode, struct file *file)
 	newdev->state = UIST_NEW_DEVICE;
 
 	file->private_data = newdev;
-	unlock_kernel();
 
 	return 0;
 }
-- 
1.6.6

