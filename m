Return-Path: <linux-kernel-owner+w=401wt.eu-S940052AbXG3WaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940052AbXG3WaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969594AbXG3W2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:28:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54346 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969539AbXG3W2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:28:42 -0400
Date: Tue, 31 Jul 2007 00:28:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: mdharm-usb@one-eyed-alien.net, gregkh@suse.de
Cc: linux-usb-devel@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] usbat_check_status(): fix check-after-use
Message-ID: <20070730222822.GG3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "us"
was NULL.

Since "us" can't be NULL in the only caller this patch removes the
NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/usb/storage/shuttle_usbat.c.old	2007-07-30 16:56:34.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/usb/storage/shuttle_usbat.c	2007-07-30 16:57:24.000000000 +0200
@@ -190,9 +190,6 @@ static int usbat_check_status(struct us_
 	unsigned char *reply = us->iobuf;
 	int rc;
 
-	if (!us)
-		return USB_STOR_TRANSPORT_ERROR;
-
 	rc = usbat_get_status(us, reply);
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_FAILED;

