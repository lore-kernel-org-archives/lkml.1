Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZCJFM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZCJFM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZCJFLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:33 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZCJFL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cSqNkIYy31Eb6HEymqI6bCyVGTXTV/Itr1ECRaFZC/loaMrKNtPq53kVLk+FR09tpC
         /Dh72Dt3wI1C1x2++CWsBY8HUQwkgqhlqxM1szznFsGLa/9gNniyQhfdStrPd+fOMrCT
         DvoQrrj54oPFELwxnvwpKn2w4WcROh6er+Mc4=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, gregkh@suse.de
Subject: [PATCH 02/25] [staging] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:27 -0500
Message-Id: <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/staging/comedi/drivers.c      |    6 ++----
 drivers/staging/otus/wwrap.c          |    3 +--
 drivers/staging/usbip/vhci_sysfs.c    |    3 +--
 drivers/staging/wlan-ng/hfa384x_usb.c |    4 +---
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 36a93b9..0b3a0f4 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -545,8 +545,7 @@ unsigned int comedi_buf_munge(comedi_async * async, unsigned int num_bytes)
 
 	if (s->munge == NULL || (async->cmd.flags & CMDF_RAWDATA)) {
 		async->munge_count += num_bytes;
-		if ((int)(async->munge_count - async->buf_write_count) > 0)
-			BUG();
+		BUG_ON((int)(async->munge_count - async->buf_write_count) > 0);
 		return num_bytes;
 	}
 	/* don't munge partial samples */
@@ -576,8 +575,7 @@ unsigned int comedi_buf_munge(comedi_async * async, unsigned int num_bytes)
 		async->munge_ptr %= async->prealloc_bufsz;
 		count += block_size;
 	}
-	if ((int)(async->munge_count - async->buf_write_count) > 0)
-		BUG();
+	BUG_ON((int)(async->munge_count - async->buf_write_count) > 0);
 	return count;
 }
 
diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index 1bb5f59..a2d1389 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -350,8 +350,7 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
     buf->len = 0;
 #endif
 
-    if ((buf->tail + urb->actual_length) > buf->end)
-        BUG();
+    BUG_ON((buf->tail + urb->actual_length) > buf->end);
 
     skb_put(buf, urb->actual_length);
 
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 0fd33a6..e4c7143 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -31,8 +31,7 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 	char *s = out;
 	int i = 0;
 
-	if (!the_controller || !out)
-		BUG();
+	BUG_ON(!the_controller || !out);
 
 	spin_lock(&the_controller->lock);
 
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 8a75b50..7cb3825 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3612,9 +3612,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		goto exit;
 
 	skb = hw->rx_urb_skb;
-	if (!skb || (skb->data != urb->transfer_buffer)) {
-		BUG();
-	}
+	BUG_ON(!skb || (skb->data != urb->transfer_buffer));
 	hw->rx_urb_skb = NULL;
 
 	/* Check for error conditions within the URB */
-- 
1.6.1.3

