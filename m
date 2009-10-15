Return-Path: <linux-kernel-owner+w=401wt.eu-S935511AbZJOU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511AbZJOU3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935249AbZJOU3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:29:41 -0400
Received: from www.tglx.de ([62.245.132.106]:52495 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935501AbZJOU3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:29:38 -0400
Message-Id: <20091015202758.591296185@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 20:28:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ALan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
Subject: [patch 5/5] bluetooth: Remove stub ioctl in hci_vhci
References: <20091015202722.372890083@linutronix.de>
Content-Disposition: inline;
	filename=bluetooth-hci-vhci-remove-stub-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the empty ioctl which just returns -EINVAL. vfs_ioctl() will
return -ENOTTY instead, but I doubt that any application will notice
the difference :)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org

---
 drivers/bluetooth/hci_vhci.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6-tip/drivers/bluetooth/hci_vhci.c
===================================================================
--- linux-2.6-tip.orig/drivers/bluetooth/hci_vhci.c
+++ linux-2.6-tip/drivers/bluetooth/hci_vhci.c
@@ -218,12 +218,6 @@ static unsigned int vhci_poll(struct fil
 	return POLLOUT | POLLWRNORM;
 }
 
-static int vhci_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	return -EINVAL;
-}
-
 static int vhci_open(struct inode *inode, struct file *file)
 {
 	struct vhci_data *data;
@@ -287,7 +281,6 @@ static const struct file_operations vhci
 	.read		= vhci_read,
 	.write		= vhci_write,
 	.poll		= vhci_poll,
-	.ioctl		= vhci_ioctl,
 	.open		= vhci_open,
 	.release	= vhci_release,
 };


