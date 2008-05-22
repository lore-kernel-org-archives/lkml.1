Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYEVUnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYEVUnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYEVUm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:42:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60356 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755158AbYEVUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:42:58 -0400
Date: Thu, 22 May 2008 21:30:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] hci_vhci: Elimiate BKL from ioctl handling
Message-ID: <20080522213020.498327ed@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to unlocked_ioctl and fix the return value to be -ENOTTY as it
should be.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 0638730..41002ef 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -245,10 +245,9 @@ static unsigned int vhci_poll(struct file *file, poll_table *wait)
 	return POLLOUT | POLLWRNORM;
 }
 
-static int vhci_ioctl(struct inode *inode, struct file *file,
-					unsigned int cmd, unsigned long arg)
+static long vhci_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return -EINVAL;
+	return -ENOTTY;
 }
 
 static int vhci_open(struct inode *inode, struct file *file)
@@ -332,7 +331,7 @@ static const struct file_operations vhci_fops = {
 	.read		= vhci_read,
 	.write		= vhci_write,
 	.poll		= vhci_poll,
-	.ioctl		= vhci_ioctl,
+	.unlocked_ioctl	= vhci_ioctl,
 	.open		= vhci_open,
 	.release	= vhci_release,
 	.fasync		= vhci_fasync,
