Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbXJUDPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbXJUDPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 23:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXJUDPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 23:15:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56887 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbXJUDPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 23:15:35 -0400
Date: Sat, 20 Oct 2007 21:47:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@daveloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] vfc_dev conversion to mutex: fallout
Message-ID: <20071020204753.GT8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	commit 7b96dc023a1b487bce59256fde14b8bb28b45aea had missed one
place.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/sbus/char/vfc_dev.c b/drivers/sbus/char/vfc_dev.c
index e7a1642..d4f8fcd 100644
--- a/drivers/sbus/char/vfc_dev.c
+++ b/drivers/sbus/char/vfc_dev.c
@@ -134,7 +134,7 @@ int init_vfc_hw(struct vfc_dev *dev)
 int init_vfc_devstruct(struct vfc_dev *dev, int instance) 
 {
 	dev->instance=instance;
-	init_MUTEX(&dev->device_lock_sem);
+	mutex_init(&dev->device_lock_mtx);
 	dev->control_reg=0;
 	dev->busy=0;
 	return 0;
