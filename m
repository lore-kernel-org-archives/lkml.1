Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZEULqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZEULqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZEULp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:45:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37485 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZEULpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ku5//T2Lf7YFfd2LTbVr3l2hzZCK91WHB+Gv3C14fE0IVeliKkUjawUWD4xAaWsPY8
         jRJCU2O44hZEpSXHal8E1LK1RkK+m5qZsVlfuqN5KkSMarhuSKmiJPK3ngaonHy5xyPH
         /HDFUo0uhEeXyAZtDb6b0pO+12GFu23sEqHU8=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] Staging: cpc-usb: fix printk format warnings
Date: Thu, 21 May 2009 15:44:46 +0400
Message-Id: <1242906286-7066-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242906286-7066-1-git-send-email-a.beregalov@gmail.com>
References: <1242906286-7066-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warnings:
cpc-usb_drv.c:478: warning: format '%d' expects type 'int',
	but argument 4 has type 'size_t'
cpc-usb_drv.c:1034: warning: format '%d' expects type 'int',
	but argument 3 has type 'long unsigned int'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/cpc-usb/cpc-usb_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cpc-usb/cpc-usb_drv.c b/drivers/staging/cpc-usb/cpc-usb_drv.c
index d337a97..8e312c7 100644
--- a/drivers/staging/cpc-usb/cpc-usb_drv.c
+++ b/drivers/staging/cpc-usb/cpc-usb_drv.c
@@ -475,7 +475,7 @@ static ssize_t cpcusb_write(struct file *file, const char *buffer,
 	unsigned char type = 0;
 	CPC_MSG_T *info = NULL;
 
-	dbg("%s - entered minor %d, count = %d, present = %d",
+	dbg("%s - entered minor %d, count = %zu, present = %d",
 	    __func__, card->minor, count, card->present);
 
 	if (count > sizeof(CPC_MSG_T))
@@ -1031,7 +1031,7 @@ static int cpcusb_probe(struct usb_interface *interface,
 		retval = -ENOMEM;
 		goto error;
 	}
-	info("Allocated memory for %d messages (%d kbytes)",
+	info("Allocated memory for %d messages (%lu kbytes)",
 	     CPC_MSG_BUF_CNT, (sizeof(CPC_MSG_T) * CPC_MSG_BUF_CNT) / 1000);
 	memset(chan->buf, 0, sizeof(CPC_MSG_T) * CPC_MSG_BUF_CNT);
 
-- 
1.6.3.1

