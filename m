Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbXJRKxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbXJRKxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbXJRKwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:52:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44769 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764908AbXJRKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:52:38 -0400
Date: Thu, 18 Oct 2007 12:53:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: miquel@df.uba.ar, greg@kroah.com
Cc: rio500-users@lists.sourceforge.net, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] USB rio500.c: fix check-after-use
Message-ID: <20071018105307.GN3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "dev"
was NULL in these places.

Since "dev" being NULL isn't possible at these places this patch removes 
the NULL checks.

Additionally, I've fixed the formatting of the if's.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/misc/rio500.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

19cc945c5387e84123f654e1d7e7c79d29b3516c 
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 88f6abe..330c18e 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -118,10 +118,7 @@ ioctl_rio(struct inode *inode, struct file *file, unsigned int cmd,
 
 	mutex_lock(&(rio->lock));
         /* Sanity check to make sure rio is connected, powered, etc */
-        if ( rio == NULL ||
-             rio->present == 0 ||
-             rio->rio_dev == NULL )
-	{
+        if (rio->present == 0 || rio->rio_dev == NULL) {
 		retval = -ENODEV;
 		goto err_out;
 	}
@@ -280,10 +277,7 @@ write_rio(struct file *file, const char __user *buffer,
 	if (intr)
 		return -EINTR;
         /* Sanity check to make sure rio is connected, powered, etc */
-        if ( rio == NULL ||
-             rio->present == 0 ||
-             rio->rio_dev == NULL )
-	{
+        if (rio->present == 0 || rio->rio_dev == NULL) {
 		mutex_unlock(&(rio->lock));
 		return -ENODEV;
 	}
@@ -369,10 +363,7 @@ read_rio(struct file *file, char __user *buffer, size_t count, loff_t * ppos)
 	if (intr)
 		return -EINTR;
 	/* Sanity check to make sure rio is connected, powered, etc */
-        if ( rio == NULL ||
-             rio->present == 0 ||
-             rio->rio_dev == NULL )
-	{
+        if (rio->present == 0 || rio->rio_dev == NULL) {
 		mutex_unlock(&(rio->lock));
 		return -ENODEV;
 	}

