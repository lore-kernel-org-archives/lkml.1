Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZAYXHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZAYXHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 18:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbZAYXH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 18:07:26 -0500
Received: from kroah.org ([198.145.64.141]:42828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbZAYXHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 18:07:25 -0500
Subject: patch staging-usbip-usbip_start_threads-handle-kernel_thread-failure.patch added to gregkh-2.6 tree
To: roel.kluin@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Sun, 25 Jan 2009 15:00:58 -0800
In-Reply-To: <494C222A.8050507@gmail.com>
Message-ID: <12329244581987@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: usbip: usbip_start_threads(): handle kernel_thread failure

to my gregkh-2.6 tree.  Its filename is

    staging-usbip-usbip_start_threads-handle-kernel_thread-failure.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From roel.kluin@gmail.com  Sun Jan 25 14:35:50 2009
From: Roel Kluin <roel.kluin@gmail.com>
Date: Fri, 19 Dec 2008 23:37:30 +0100
Subject: Staging: usbip: usbip_start_threads(): handle kernel_thread failure
To: Greg KH <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-ID: <494C222A.8050507@gmail.com>


kernel_thread may fail, notice this.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -406,8 +406,20 @@ void usbip_start_threads(struct usbip_de
 	/*
 	 * threads are invoked per one device (per one connection).
 	 */
-	kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
-	kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
+	int retval;
+
+	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
+	if (retval < 0) {
+		printk(KERN_ERR "Creating tcp_rx thread for ud %p failed.\n",
+				ud);
+		return;
+	}
+	retval = kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
+	if (retval < 0) {
+		printk(KERN_ERR "Creating tcp_tx thread for ud %p failed.\n",
+				ud);
+		return;
+	}
 
 	/* confirm threads are starting */
 	wait_for_completion(&ud->tcp_rx.thread_done);


Patches currently in gregkh-2.6 which might be from roel.kluin@gmail.com are

staging/staging-meilhaus-unsigned-won-t-get-negative-after-subtraction.patch
staging/staging-otus-logical-bit-and-confusion.patch
staging/staging-usbip-usbip_start_threads-handle-kernel_thread-failure.patch
