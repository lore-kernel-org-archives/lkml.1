Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZCKUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZCKUsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZCKUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:50 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:51006 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZCKUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:47 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/5] USB: misc/vstusb, fix lock imbalance
Date: Wed, 11 Mar 2009 21:47:39 +0100
Message-Id: <1236804460-1432-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
References: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we don't leak locked vstdev->lock in vstusb_write. Unlock
properly on one fail path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/usb/misc/vstusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/vstusb.c b/drivers/usb/misc/vstusb.c
index 63dff9b..f26ea8d 100644
--- a/drivers/usb/misc/vstusb.c
+++ b/drivers/usb/misc/vstusb.c
@@ -401,6 +401,7 @@ static ssize_t vstusb_write(struct file *file, const char __user *buffer,
 	}
 
 	if (copy_from_user(buf, buffer, count)) {
+		mutex_unlock(&vstdev->lock);
 		dev_err(&dev->dev, "%s: can't copy_from_user\n", __func__);
 		retval = -EFAULT;
 		goto exit;
-- 
1.6.2
caught by stanse

