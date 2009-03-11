Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZCKUsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZCKUsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZCKUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:47 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:51005 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZCKUrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/5] USB: misc/adutux, fix lock imbalance
Date: Wed, 11 Mar 2009 21:47:38 +0100
Message-Id: <1236804460-1432-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
References: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't unlock adutux_mutex when not held.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/usb/misc/adutux.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 7b6922e..2035265 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -376,7 +376,7 @@ static int adu_release(struct inode *inode, struct file *file)
 	if (dev->open_count <= 0) {
 		dbg(1," %s : device not opened", __func__);
 		retval = -ENODEV;
-		goto exit;
+		goto unlock;
 	}
 
 	adu_release_internal(dev);
@@ -385,9 +385,9 @@ static int adu_release(struct inode *inode, struct file *file)
 		if (!dev->open_count)	/* ... and we're the last user */
 			adu_delete(dev);
 	}
-
-exit:
+unlock:
 	mutex_unlock(&adutux_mutex);
+exit:
 	dbg(2," %s : leave, return value %d", __func__, retval);
 	return retval;
 }
-- 
1.6.2
caught by stanse

