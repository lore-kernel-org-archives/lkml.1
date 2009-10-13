Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZJMQGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZJMQGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZJMQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:06:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39219 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbZJMQGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:06:22 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] bluetooth: kill unneeded use of BKL ioctl
To: linux-kernel@vger.kernel.org
Date: Tue, 13 Oct 2009 16:54:20 +0100
Message-ID: <20091013155420.30923.55710.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we just return -EINVAL then locking really doesn't matter

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/bluetooth/hci_vhci.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index d5cde6d..7dc94a5 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -218,8 +218,7 @@ static unsigned int vhci_poll(struct file *file, poll_table *wait)
 	return POLLOUT | POLLWRNORM;
 }
 
-static int vhci_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long vhci_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return -EINVAL;
 }
@@ -287,7 +286,7 @@ static const struct file_operations vhci_fops = {
 	.read		= vhci_read,
 	.write		= vhci_write,
 	.poll		= vhci_poll,
-	.ioctl		= vhci_ioctl,
+	.unlocked_ioctl	= vhci_ioctl,
 	.open		= vhci_open,
 	.release	= vhci_release,
 };

