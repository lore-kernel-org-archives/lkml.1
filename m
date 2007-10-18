Return-Path: <linux-kernel-owner+w=401wt.eu-S1764955AbXJRKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764955AbXJRKxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764681AbXJRKwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:52:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44764 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764812AbXJRKwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:52:22 -0400
Date: Thu, 18 Oct 2007 12:52:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: greg@kroah.com
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] USB iowarrior.c: fix check-after-use
Message-ID: <20071018105250.GM3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "dev"
was NULL.

Since "dev" being NULL doesn't seem to be possible here this patch 
removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
82a9906788e8bedc6d5adc54046e1713e4a399df 
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 46d9f27..9930b0a 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -351,7 +351,7 @@ static ssize_t iowarrior_write(struct file *file,
 
 	mutex_lock(&dev->mutex);
 	/* verify that the device wasn't unplugged */
-	if (dev == NULL || !dev->present) {
+	if (!dev->present) {
 		retval = -ENODEV;
 		goto exit;
 	}
